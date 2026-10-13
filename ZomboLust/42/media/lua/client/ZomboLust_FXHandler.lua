--- File: ZomboLust/42/media/lua/client/ZomboLust_FXHandler.lua
--- Handles visual transitions between animation stages using smoke and heart particles
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_FXHandler.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"

-- Module name for logging
--- @type string
local MODULE_NAME = "FXHandler"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

local heartParticles = {}
local smokeParticles = {}
local heartTexture = nil
local smokeTextureCache = {}

-- Maximum real time (ms) to wait for the ZombHuman to confirm it reached the expected
-- stage before giving up and restoring visibility anyway. The ZombHuman's task system
-- relays through several extra OnTick steps compared to the player's TimedAction queue
-- (which switches to the next stage within the same tick), so this bounds how long we
-- hold the mask if that relay is abnormally slow or never confirms (e.g. interruption).
local ZOMBHUMAN_SYNC_TIMEOUT_MS = 3000

-- Pre-load smoke textures to avoid pink squares on first use
for i = 1, 60 do
    local frameStr = string.format("%03d", i)
    smokeTextureCache[i] = getTexture("media/textures/FX/smoke/" .. frameStr .. ".png")
end

-- Pre-load the heart texture too, same as smoke above
heartTexture = getTexture("media/textures/FX/ZomboLust_Heart.png")
if not heartTexture then
    ZomboLust.errorLog(MODULE_NAME, "Failed to preload heart texture: media/textures/FX/ZomboLust_Heart.png")
end

-- ======================
-- Visibility Management
-- ======================

--- Restores the player and/or zombie to full visibility (opposite of the invisibility forced during a stage transition)
--- @param player IsoPlayer|nil -- The player to restore, or nil to skip
--- @param zombie IsoZombie|nil -- The ZombHuman to restore, or nil to skip
local function restoreVisibility(player, zombie)
    if player then
        ZomboLust.debugLog(MODULE_NAME, "Restoring player visibility")
        getCore():setDisplayPlayerModel(true)
    end
    if zombie then
        ZomboLust.debugLog(MODULE_NAME, "Restoring zombie alpha (1.0)")
        zombie:setTargetAlpha(1.0)
    end
end

--- Monitor for the start of the next stage to restore visibility
--- @param player IsoPlayer -- The player whose action queue we poll for progress
--- @param zombie IsoZombie -- The ZombHuman whose stage confirmation we wait for
--- @param wrapperFunc function -- Reference to this OnTick wrapper itself, so it can remove itself once done
--- @param expectedStage number -- The stage index the ZombHuman must reach (ZomboDesireMultiStage.currentStage)
---        before we consider it caught up. Set in sync with ZomboDesire_AnimationHandlerForZombHuman's
---        handleNextStageCompletion, which updates it in the same call as the actual setBumpType.
--- @param monitorStartMs number -- getTimestampMs() taken when monitoring began, for the safety timeout
local function onTickCheckStart(player, zombie, wrapperFunc, expectedStage, monitorStartMs)
    -- Safety check: if player or zombie are gone, stop monitoring
    if not player or not player:getSquare() or not zombie or not zombie:isAlive() then
        ZomboLust.debugLog(MODULE_NAME, "onTickCheckStart: safety stop (character lost)")
        Events.OnTick.Remove(wrapperFunc)
        return
    end

    local queue = ISTimedActionQueue.getTimedActionQueue(player)
    if not queue then return end

    local action = queue.current
    -- If no action is running, the sequence might have been interrupted or finished
    if not action then
        ZomboLust.debugLog(MODULE_NAME, "onTickCheckStart: sequence finished/interrupted, restoring visibility")
        restoreVisibility(player, zombie)
        Events.OnTick.Remove(wrapperFunc)
        return
    end

    local playerReady = action:getJobDelta() > 0.01

    -- The ZombHuman's task system relays through extra OnTick steps before its new stage
    -- actually starts (unlike the player's TimedAction queue, which switches within the same tick).
    -- Without this check, visibility was restored as soon as the player was ready,
    -- exposing the ZombHuman still in its previous pose for tens to hundreds of ms.
    local zombieReady = true
    if expectedStage then
        local md = zombie:getModData()
        ---@type ZomboDesireMultiStageInfo|nil
        local multiStage = md and md.ZomboDesireMultiStage
        zombieReady = multiStage ~= nil and multiStage.currentStage == expectedStage
    end

    -- Safety timeout: never hold the mask indefinitely if the ZombHuman never confirms
    -- (e.g. its own sequence was interrupted independently of the player's)
    local timedOut = false
    if not zombieReady and monitorStartMs then
        timedOut = (getTimestampMs() - monitorStartMs) > ZOMBHUMAN_SYNC_TIMEOUT_MS
        if timedOut then
            ZomboLust.warningLog(MODULE_NAME, "onTickCheckStart: timed out after %dms waiting for ZombHuman to reach stage %s, restoring visibility anyway",
                ZOMBHUMAN_SYNC_TIMEOUT_MS, tostring(expectedStage))
        end
    end

    -- We restore visibility only once both the player's next action has actually started
    -- progressing AND the ZombHuman has confirmed it reached the same stage (or we timed out)
    if playerReady and (zombieReady or timedOut) then
        ZomboLust.debugLog(MODULE_NAME, "onTickCheckStart: both sides ready (player delta > 0.01, zombie stage=%s), restoring visibility",
            tostring(expectedStage))
        restoreVisibility(player, zombie)
        Events.OnTick.Remove(wrapperFunc)
    else
        -- Force invisibility until both sides are ready
        getCore():setDisplayPlayerModel(false)
        zombie:setAlpha(0.0)
        zombie:setTargetAlpha(0.0)
    end
end

-- ================
-- Smoke FX System
-- ================

--- Spawns a single smoke particle at the given world position
--- @param x number -- World X coordinate
--- @param y number -- World Y coordinate
--- @param z number -- World Z coordinate
local function spawnSmoke(x, y, z)
    ZomboLust.debugLog(MODULE_NAME, "Spawning smoke screen at (%.2f, %.2f)", x, y)
    local particle = {
        x = x + ZombRandFloat(-0.5, 0.5),
        y = y + ZombRandFloat(-0.5, 0.5),
        z = z,
        frame = 1,
        frameCnt = 60,
        rep = 1,
        repCnt = 1, -- Duration of the smoke screen
        size = 1200, -- Larger to cover characters
        alpha = 0.9 -- Slightly denser
    }
    table.insert(smokeParticles, particle)
end

--- Updates and draws every active smoke particle, removing expired ones
--- @param playerNum integer -- The split-screen player index (see IsoPlayer.getPlayerIndex)
--- @param zoom number -- The current camera zoom level for this player
local function updateAndDrawSmoke(playerNum, zoom)
    if #smokeParticles == 0 then return end

    for i = #smokeParticles, 1, -1 do
        local p = smokeParticles[i]

        -- Drawing logic
        local size = p.size / zoom
        local offset = size / 2
        local tx = isoToScreenX(playerNum, p.x, p.y, p.z) - offset
        local ty = isoToScreenY(playerNum, p.x, p.y, p.z) - offset

        local tex = smokeTextureCache[p.frame]
        if tex then
            -- Explicit UV mapping (21 params) is required for SpriteRenderer to display textures correctly
            -- Custom RGBA coloring (Pink: 1.0, 0.5, 0.8)
            local u1, v1 = tex:getXStart(), tex:getYStart()
            local u2, v2 = tex:getXEnd(), tex:getYStart()
            local u3, v3 = tex:getXEnd(), tex:getYEnd()
            local u4, v4 = tex:getXStart(), tex:getYEnd()
            ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
            SpriteRenderer.instance:render(tex, tx, ty, tx + size, ty, tx + size, ty + size, tx, ty + size, u1, v1, u2, v2, u3, v3, u4, v4, 1.0, 0.5, 0.8, p.alpha)
        else
            ZomboLust.errorLog(MODULE_NAME, "Failed to load smoke texture frame: %d", p.frame)
        end

        -- Animation progression
        p.frame = p.frame + 2
        if p.frame > p.frameCnt then
            p.frame = 1
            p.rep = p.rep + 1
            ZomboLust.debugLog(MODULE_NAME, "Smoke cycle %d finished", p.rep - 1)
        end

        if p.rep > p.repCnt then
            ZomboLust.debugLog(MODULE_NAME, "Smoke screen expired")
            table.remove(smokeParticles, i)
        end
    end
end

-- ================
-- Heart FX System
-- ================

--- Spawns a single heart particle at the given world position, with randomized size/speed/oscillation
--- @param x number -- World X coordinate
--- @param y number -- World Y coordinate
--- @param z number -- World Z coordinate
local function spawnHeart(x, y, z)
    local particle = {
        x = x + (ZombRandFloat(-0.5, 0.5)),
        y = y + (ZombRandFloat(-0.5, 0.5)),
        z = z,
        size = ZombRandFloat(16, 48), -- Base size in pixels
        scale = 0.1, -- Starting scale (Expansion)
        alpha = 1.0,
        speedY = ZombRandFloat(0.01, 0.03), -- Upward speed
        phase = ZombRandFloat(0, 6.28), -- Start phase for oscillation (2 * PI)
        oscSpeed = ZombRandFloat(0.04, 0.08), -- Oscillation speed
        oscWidth = ZombRandFloat(0.4, 0.8), -- Oscillation width for visible zigzag
        life = 120 -- 2 seconds at 60fps
    }
    table.insert(heartParticles, particle)
end

--- Updates and draws every active heart particle, removing expired ones
--- @param playerNum integer -- The split-screen player index (see IsoPlayer.getPlayerIndex)
--- @param zoom number -- The current camera zoom level for this player
local function updateAndDrawHearts(playerNum, zoom)
    if #heartParticles == 0 then return end

    if not heartTexture then return end

    for _i = #heartParticles, 1, -1 do
        local p = heartParticles[_i]

        -- Update
        p.life = p.life - 1
        p.scale = math.min(1.0, p.scale + 0.05) -- Expansion
        p.alpha = math.min(1.0, p.life / 20) -- Fade out at end

        -- Movement
        p.y = p.y - p.speedY -- Upward
        local offsetX = math.sin(p.phase) * p.oscWidth -- Oscillation
        p.phase = p.phase + p.oscSpeed

        -- Position
        local tx = isoToScreenX(playerNum, p.x + offsetX, p.y, p.z)
        local ty = isoToScreenY(playerNum, p.x + offsetX, p.y, p.z)

        -- Draw
        local finalSize = (p.size * p.scale) / zoom
        local drawOffset = finalSize / 2
        UIManager.DrawTexture(heartTexture, tx - drawOffset, ty - drawOffset, finalSize, finalSize, p.alpha)

        if p.life <= 0 then
            table.remove(heartParticles, _i)
        end
    end
end

--- OnPreUIDraw event handler: draws the smoke and heart particle overlays, if any are active
local function onPreUIDraw()
    if #heartParticles == 0 and #smokeParticles == 0 then return end

    local player = getPlayer()
    if not player then return end
    local playerNum = IsoPlayer.getPlayerIndex(player)
    local zoom = getCore():getZoom(playerNum)

    -- Smoke drawn first (behind)
    updateAndDrawSmoke(playerNum, zoom)
    -- Hearts drawn second (in front)
    updateAndDrawHearts(playerNum, zoom)
end

-- ========================
-- Main Transition Handler
-- ========================

--- OnZomboDesireStageTransition event handler: masks the player and ZombHuman behind smoke/hearts
--- and holds them invisible until both sides have confirmed they reached the new stage
--- @param player IsoPlayer -- The player transitioning to the next stage
--- @param zombie IsoZombie -- The ZombHuman transitioning to the next stage
--- @param nextStageIndex integer -- The stage index both sides are transitioning into
local function onStageTransition(player, zombie, nextStageIndex)
    if not player or not zombie then 
        ZomboLust.warningLog(MODULE_NAME, "onStageTransition: player or zombie is nil")
        return 
    end

    ZomboLust.debugLog(MODULE_NAME, "Stage transition detected (Next Stage: %d)", nextStageIndex)

    -- 1. Immediate Invisibility
    ZomboLust.debugLog(MODULE_NAME, "Setting player/zombie invisible")
    getCore():setDisplayPlayerModel(false)
    zombie:setTargetAlpha(0.0)

    -- 2. Smoke Screen
    ZomboLust.debugLog(MODULE_NAME, "Spawning dense smoke screen (5 particles)")
    for _i = 1, 5 do
        spawnSmoke(player:getX(), player:getY(), player:getZ())
    end

    -- 3. Spawn Heart Particles
    ZomboLust.debugLog(MODULE_NAME, "Spawning 15 heart particles")
    for _i = 1, 15 do
        spawnHeart(player:getX(), player:getY(), player:getZ())
    end

    -- 4. Monitor for reappearance
    -- We wait for both the player's next action AND the ZombHuman's confirmed stage
    -- (nextStageIndex, set by ZomboDesire_AnimationHandlerForZombHuman.handleNextStageCompletion)
    -- before lifting the mask, to avoid revealing the ZombHuman still in its previous pose.
    ZomboLust.debugLog(MODULE_NAME, "Starting OnTick monitor for reappearance (waiting for stage %d on both sides)", nextStageIndex)
    local monitorStartMs = getTimestampMs()
    -- Self-referencing closure: `wrapper` must exist as an upvalue so it can remove itself from OnTick once onTickCheckStart is done.
    -- It's nil only for the instant between this declaration
    -- and the assignment right below -- by the time OnTick actually invokes it, it's always a function.
    local wrapper = nil
    wrapper = function()
        ---@diagnostic disable-next-line: param-type-mismatch
        onTickCheckStart(player, zombie, wrapper, nextStageIndex, monitorStartMs)
    end
    Events.OnTick.Add(wrapper)
end

-- Initialize events
-- Note: OnZomboDesireStageTransition must be declared in ZomboDesire
Events.OnZomboDesireStageTransition.Add(onStageTransition)
Events.OnPreUIDraw.Add(onPreUIDraw)
