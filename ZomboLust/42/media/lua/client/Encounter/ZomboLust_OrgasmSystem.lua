-- File: ZomboLust/42/media/lua/client/Encounter/ZomboLust_OrgasmSystem.lua
-- This module handles the Orgasm system for ZomboLust (Visuals and Effects)
-- @author BlaBla 2026

---@diagnostic disable: inject-field

print("[ZomboLust LOADING] ZomboLust_OrgasmSystem.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Utils"
require "MiniGame/ZomboLust_MoraleSystem"

-- Module name for logging
--- @type string
local MODULE_NAME = "Orgasm"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

ZomboLust_OrgasmSystem = ZomboLust_OrgasmSystem or {}
ZomboLust_OrgasmSystem.isFlashing = false
ZomboLust_OrgasmSystem.countdown = 0
---@type number
ZomboLust_OrgasmSystem.maxCountdown = 0
---@type number
ZomboLust_OrgasmSystem.pulseTimer = 0.0
ZomboLust_OrgasmSystem.isCountdownActive = false
ZomboLust_OrgasmSystem.orgasmPlayer = nil

-- Zombie awareness check during masturbation (player is stuck in place and defenseless)
---@type number
ZomboLust_OrgasmSystem.ZombieAwarenessRadius = 2.0 -- Same radius as the pheromone scan (ZomboLust_ExcitationSystem.PheromoneRadius)
---@type number
ZomboLust_OrgasmSystem.ZombieAwarenessCheckTickRate = 30 -- Scan every 30 frames (~1/2 second at 60fps), same cadence as ZomboLust_ExcitationSystem.UpdateTickRate

-- Climax Groan zombie attraction (see playClimaxSound): the orgasm cry is pitched as louder than a
-- simple Excitation groan/shout - equivalent to a vanilla car horn/alarm (PZwiki "Noise" page: 150).
---@type number
ZomboLust_OrgasmSystem.ClimaxAttractionRadius = 150
---@type number
ZomboLust_OrgasmSystem.ClimaxAttractionVolume = 150

-- UI Frame paths
---@type string[]
ZomboLust_OrgasmSystem.Frames = {
    "media/ui/Frame_Orgasm_Phase_1.png",
    "media/ui/Frame_Orgasm_Phase_2.png",
    "media/ui/Frame_Orgasm_Phase_3.png",
    "media/ui/Frame_Orgasm_Phase_4.png",
}

-- Climax Sound events (FMOD Event names from media/scripts)
---@type {Female: string[], Male: string[]}
ZomboLust_OrgasmSystem.Sounds = {
    Female = {
        "CaseyjoMoanFinal",
        "JanineMoanFinal",
        "KateMoanFinal",
        "MaryanneMoanFinal",
    },
    Male = {
        "BobMoanFinal",
        "ChrisMoanFinal",
        "HankMoanFinal",
        "JamesMoanFinal",
    }
}

-- =============
-- UI Component
-- =============

---@class ZomboLust_OrgasmUI : ISPanel
---@field player IsoPlayer
---@field phase integer
---@field cycle integer
---@field alpha number
---@field fadingIn boolean
---@field finished boolean
---@field baseOffsetX integer
---@field baseOffsetY integer
ZomboLust_OrgasmUI = ISPanel:derive("ZomboLust_OrgasmUI")

---@param x number
---@param y number
---@param width number
---@param height number
---@param player IsoPlayer
function ZomboLust_OrgasmUI:new(x, y, width, height, player)
    local o = ISPanel:new(x, y, width, height) -- Use standard coordinates
    setmetatable(o, self)
    self.__index = self
    o.player = player
    o.backgroundColor = {r=0, g=0, b=0, a=0}
    o.borderColor = {r=0, g=0, b=0, a=0}
    o.moveWithMouse = false
    o.phase = 1 -- 1 to 4
    o.cycle = 1
    o.alpha = 0
    o.fadingIn = true
    o.finished = false
    o.baseOffsetX = 0
    o.baseOffsetY = -56 -- Standard PZ Camera Y offset
    o:noBackground()
    -- Crucial: ignore mouse events
    o:setWantKeyEvents(false)
    return o
end

function ZomboLust_OrgasmUI:initialise()
    ISPanel.initialise(self)
    if self.javaObject and self.javaObject.setConsumeMouseEvents then
        self.javaObject:setConsumeMouseEvents(false)
    end
end

--- Plays a random climax sound based on player gender
function ZomboLust_OrgasmUI:playClimaxSound()
    if not self.player then return end

    local isFemale = self.player:isFemale()
    ---@type string[]
    local soundList = isFemale and ZomboLust_OrgasmSystem.Sounds.Female or ZomboLust_OrgasmSystem.Sounds.Male
    local selectedSound = soundList[ZombRand(#soundList) + 1]

    if selectedSound then
        ZomboLust.debugLog(MODULE_NAME, "Playing Phase %d Climax Sound: %s", self.phase, selectedSound)
        local emitter = self.player:getEmitter()
        if emitter then
            local soundID = emitter:playSound(selectedSound)
            if soundID ~= -1 then
                local pitch = isFemale and 1.0 or 0.8
                emitter:setVolume(soundID, 2.0)
                emitter:setPitch(soundID, pitch)
            end
        end

        -- Climax Groan - the orgasm cry attracts nearby zombies, same mechanism as the Excitation
        -- thoughts' groan (see playDangerGroan in ZomboLust_ExcitationDangerGroan.lua), but louder: a fixed radius
        -- matching a vanilla car horn/alarm (see ZomboLust_OrgasmSystem.ClimaxAttractionRadius).
        -- Excitation is always pinned at 100% here, so unlike the groan curve there is no scaling.
        local radius = ZomboLust_OrgasmSystem.ClimaxAttractionRadius
        addSound(self.player, math.floor(self.player:getX()), math.floor(self.player:getY()), math.floor(self.player:getZ()), radius, ZomboLust_OrgasmSystem.ClimaxAttractionVolume)

        ZomboLust.debugLog(MODULE_NAME, "Climax Groan: Zombie attraction radius %d (Car horn/alarm-equivalent)", radius)
    end
end

function ZomboLust_OrgasmUI:render()
    if self.finished then return end

    -- If the player dies mid-flash, stop immediately instead of running out the remaining fade cycles over the death screen.
    if self.player and self.player:isDead() then
        self.finished = true
        self:removeFromUIManager()
        return
    end

    local screenW = getCore():getScreenWidth()
    local screenH = getCore():getScreenHeight()

    local framePath = ZomboLust_OrgasmSystem.Frames[self.phase]
    if framePath then
        local tex = getTexture(framePath)
        if tex then
            self:drawTextureScaled(tex, 0, 0, screenW, screenH, self.alpha, 1, 1, 1)
        end
    end

    -- Flash Gamma effect (White overlay)
    -- The flash is strongest at the peak of each cycle
    local flashAlpha = self.alpha * 0.7 -- Limit to 70% to avoid blinding the real player too much, but enough for "all white"
    self:drawRect(0, 0, screenW, screenH, flashAlpha, 1, 1, 1)

    -- Speed of flash: 0.08 means approx 12 frames per fade
    local step = 0.08

    if self.fadingIn then
        -- Trigger sound at the very start of a new phase (First cycle, alpha 0)
        if self.alpha == 0 and self.cycle == 1 then
            self:playClimaxSound()
        end
        self.alpha = self.alpha + step
        if self.alpha >= 1 then
            self.alpha = 1
            self.fadingIn = false
        end
    else
        self.alpha = self.alpha - step
        if self.alpha <= 0 then
            self.alpha = 0
            self.fadingIn = true
            -- End of one cycle
            if self.cycle >= self.phase then
                -- Move to next phase
                self.phase = self.phase + 1
                self.cycle = 1
                if self.phase > 4 then
                    self.finished = true
                    self:removeFromUIManager()
                end
            else
                self.cycle = self.cycle + 1
            end
        end
    end
end

-- ==================
-- Utility Functions
-- ==================

-- Deferred action helper, centralized in ZomboDesire_Utils.lua
local createDelayedAction = ZomboDesire_Utils.createDelayedAction

-- ================
-- Logic Functions
-- ================

--- Scans nearby tiles for a zombie that has noticed the player (target == player).
--- The distance check alone isn't enough to decide whether to interrupt:
--- a zombie can be within radius without being a threat
--- (e.g. behind a wall/closed door in another room, or an unaware zombie the player is crouched behind).
--- getTarget() already reflects the game's own line-of-sight/awareness resolution,
--- so a single check covers both the indoor and outdoor cases.
--- @param player IsoPlayer
--- @return boolean True if an aware zombie is within radius
local function hasAwareZombieNearby(player)
    local cell = player:getCell()
    if not cell then return false end

    local zombieList = cell:getZombieList()
    local px, py, pz = player:getX(), player:getY(), player:getZ()
    local radiusSq = ZomboLust_OrgasmSystem.ZombieAwarenessRadius * ZomboLust_OrgasmSystem.ZombieAwarenessRadius

    for i = 0, zombieList:size() - 1 do
        local zombie = zombieList:get(i)
        if zombie and zombie:isAlive() and zombie:getZ() == pz then
            local dx, dy = zombie:getX() - px, zombie:getY() - py
            if (dx * dx + dy * dy) <= radiusSq and zombie.getTarget and zombie:getTarget() == player then
                return true
            end
        end
    end

    return false
end

--- Trigger the masturbation animation and effects
--- @param player IsoPlayer
local function startMasturbation(player)
    if not player then return end

    -- Disable player controls
    if ZomboDesire_Utils and ZomboDesire_Utils.disablePlayerControls then
        ZomboDesire_Utils.disablePlayerControls(player)
    end

    -- Tracks whether the animation was interrupted (e.g. by zombie damage), so the
    -- delayed effects/controls-restore below can be skipped since they were already
    -- handled immediately by the interruption callback
    local interrupted = false

    --- Called by ZomboDesire_AnimationHandlerForSolo if the animation is interrupted
    --- @param interruptedPlayer IsoPlayer
    local function onMasturbationInterrupted(interruptedPlayer)
        interrupted = true
        if ZomboDesire_Utils and ZomboDesire_Utils.enablePlayerControls then
            ZomboDesire_Utils.enablePlayerControls(interruptedPlayer)
        end
        if dbg() then
            ZomboLust.debugLog(MODULE_NAME, "Masturbation animation interrupted, controls restored immediately for %s",
                interruptedPlayer and interruptedPlayer:getUsername())
        end
    end

    -- Play solo animation
    local animName = player:isFemale() and "ZomboLust_Masturbation_Female01" or "ZomboLust_Masturbation_Male01"
    if ZomboDesire_AnimationHandlerForSolo and ZomboDesire_AnimationHandlerForSolo.playAnimationSolo then
        ZomboDesire_AnimationHandlerForSolo.playAnimationSolo(player, animName, 300, onMasturbationInterrupted) -- Approx duration
    end

    -- The player is stuck in place for the whole masturbation, so periodically scan for a
    -- zombie that has noticed them (see hasAwareZombieNearby) and bail out immediately -
    -- being unable to react to an approaching threat is what this whole check exists to fix.
    -- Reuses the same forceStop()/onMasturbationInterrupted path as the damage interruption,
    -- and keeps working across the animation's multiple stages since
    -- ZomboDesire_AnimationHandlerForSolo.currentAnimationAction is updated on every stage.
    local awarenessCheckCounter = 0
    local function onZombieAwarenessTick()
        if interrupted or not player or player:isDead() then
            Events.OnTick.Remove(onZombieAwarenessTick)
            return
        end

        local currentAction = ZomboDesire_AnimationHandlerForSolo and ZomboDesire_AnimationHandlerForSolo.currentAnimationAction
        if not currentAction or currentAction.character ~= player then
            -- Animation already ended (naturally, or via another interruption path)
            Events.OnTick.Remove(onZombieAwarenessTick)
            return
        end

        awarenessCheckCounter = awarenessCheckCounter + 1
        if awarenessCheckCounter < ZomboLust_OrgasmSystem.ZombieAwarenessCheckTickRate then return end
        awarenessCheckCounter = 0

        if hasAwareZombieNearby(player) then
            Events.OnTick.Remove(onZombieAwarenessTick)

            player:Say(getText("IGUI_ZomboLust_Orgasm_ZombieSpotted"))
            if dbg() then
                ZomboLust.debugLog(MODULE_NAME, "Masturbation interrupted: an aware zombie is within %.1f tiles of %s",
                    ZomboLust_OrgasmSystem.ZombieAwarenessRadius, player:getUsername())
            end

            if currentAction.forceStop then
                currentAction:forceStop()
            end
        end
    end
    Events.OnTick.Add(onZombieAwarenessTick)

    -- Trigger visuals and sounds (same as Case 2)
    -- We wait until the end of Stage 3 of masturbation (approx 35 seconds = 2150 ticks at 60fps)
    createDelayedAction(2150, function()
        if interrupted then return end
        ZomboLust_OrgasmSystem.triggerOrgasmEffects(player, true)
    end)

    -- Restore controls after the animation (1440 frames @ 30fps * 1.6 = 2304 ticks)
    createDelayedAction(2304, function()
        if interrupted then return end
        if player and ZomboDesire_Utils and ZomboDesire_Utils.enablePlayerControls then
            ZomboDesire_Utils.enablePlayerControls(player)
            if dbg() then
                ZomboLust.debugLog(MODULE_NAME, "Masturbation animation finished, restoring controls for %s", player:getUsername())
            end
        end
    end)
end

--- Internal tick handler for highlighting the player during countdown
local function onOrgasmCountdownTick()
    local player = ZomboLust_OrgasmSystem.orgasmPlayer
    if not player or not ZomboLust_OrgasmSystem.isCountdownActive or player:isDead() then
        Events.OnTick.Remove(onOrgasmCountdownTick)
        ZomboLust_OrgasmSystem.isCountdownActive = false
        if player then player:setHighlighted(false) end
        return
    end

    ZomboLust_OrgasmSystem.pulseTimer = ZomboLust_OrgasmSystem.pulseTimer + getGameTime():getMultiplier()

    -- Minute 1-4: Slow pulse (approx 1.5 sec)
    -- Minute 5+: Fast flashing (approx 0.3 sec)
    local isEarlyPhase = ZomboLust_OrgasmSystem.countdown < 5
    local speed = isEarlyPhase and 0.04 or 0.20
    local alpha = (math.sin(ZomboLust_OrgasmSystem.pulseTimer * speed) + 1) / 2

    -- getIndex() is the non-deprecated replacement for the old getPlayerNum() (same integer split-screen slot)
    local playerNum = player:getIndex()
    -- Pink color: R=1.0, G=0.2, B=0.6 (Deeper pink)
    player:setHighlighted(playerNum, alpha > 0.2, false)
    player:setHighlightColor(playerNum, 1.0, 0.2, 0.6, alpha)
    player:setOutlineHighlight(playerNum, true)
    player:setOutlineHighlightCol(playerNum, 1.0, 0.2, 0.6, alpha)
end

--- Internal handler for IGT countdown
local function onOrgasmEveryOneMinute()
    local player = ZomboLust_OrgasmSystem.orgasmPlayer
    if not player or not ZomboLust_OrgasmSystem.isCountdownActive or player:isDead() then
        Events.EveryOneMinute.Remove(onOrgasmEveryOneMinute)
        ZomboLust_OrgasmSystem.isCountdownActive = false
        return
    end

    ZomboLust_OrgasmSystem.countdown = ZomboLust_OrgasmSystem.countdown + 1

    if ZomboLust_OrgasmSystem.countdown == 1 then
        player:Say(getText("IGUI_ZomboLust_Orgasm_Urge_1"))
    elseif ZomboLust_OrgasmSystem.countdown == 5 then
        player:Say(getText("IGUI_ZomboLust_Orgasm_Urge_2"))
    end

    -- Check if time is up
    if ZomboLust_OrgasmSystem.countdown >= ZomboLust_OrgasmSystem.maxCountdown then
        -- Wait for player to be out of vehicle
        if not player:getVehicle() then
            ZomboLust_OrgasmSystem.isCountdownActive = false
            Events.EveryOneMinute.Remove(onOrgasmEveryOneMinute)
            player:setHighlighted(false)
            startMasturbation(player)
        else
            ZomboLust.debugLog(MODULE_NAME, "Orgasm time up but player is in vehicle. Delaying...")
        end
    end
end

--- Shared logic for visual/sound effects and stats reset
--- @param player IsoPlayer
--- @param isCase1 boolean True if triggered from Case 1 (Masturbation)
function ZomboLust_OrgasmSystem.triggerOrgasmEffects(player, isCase1)
    if not player then return end

    -- Skip if the player died in the meantime (e.g. bled out / infection while the
    -- delayed timer was running, without triggering the damage-interruption path)
    if player:isDead() then
        if dbg() then
            ZomboLust.debugLog(MODULE_NAME, "Skipping orgasm effects - player %s is dead", player:getUsername())
        end
        return
    end

    -- 1) Inform player with visual frames & sound
    local ui = ZomboLust_OrgasmUI:new(0, 0, 0, 0, player) -- Start with 0 size to avoid blocking clicks
    ui:initialise()
    ui:addToUIManager()
    ui:backMost() -- Behind other UI but in front of world

    -- 2) Maximize morale level
    player:getStats():set(CharacterStat.UNHAPPINESS, 0)

    -- Reset saved morale from mini-game
    if ZomboLust_MoraleSystem then
        -- Close the Morale Bar UI if it exists and is open
        if ZomboLust_MoraleSystem.BarUI and not ZomboLust_MoraleSystem.BarUI.isClosed then
            -- Set morale to 100% before finishing to ensure unhappiness is reset to 0
            ZomboLust_MoraleSystem.BarUI.morale = 100
            ZomboLust_MoraleSystem.BarUI:finish("orgasm")
        end

        -- Ensure the final stored value is nil to avoid applying penalties during cleanup
        ZomboLust_MoraleSystem.FinalMoraleAtEndOfMiniGame = nil
    end

    -- 3) Lower excitation level
    -- Case 2: 80-85% | Case 1: 0-15%
    local newExcitation = isCase1 and ZombRand(16) or (80 + ZombRand(6))

    if ZomboLust_ExcitationSystem and ZomboLust_ExcitationSystem.setExcitation then
        ZomboLust_ExcitationSystem.setExcitation(player, newExcitation)
    else
        -- Fallback if not yet exposed
        player:getModData().ZL_Excitation = newExcitation
    end

    -- 4) Reset penalties related to morale
    -- (This is covered by setting FinalMoraleAtEndOfMiniGame to nil and Unhappiness to 0)

    ZomboLust.debugLog(MODULE_NAME, "Orgasm %s Triggered! Excitation reset to %d%%, Morale Maximized.",
        isCase1 and "Case 1" or "Case 2", newExcitation)
end

--- Trigger the orgasm countdown for Case 1 (No Animation)
--- @param player IsoPlayer
function ZomboLust_OrgasmSystem.triggerOrgasmCase1(player)
    if not player or ZomboLust_OrgasmSystem.isCountdownActive then return end

    ZomboLust_OrgasmSystem.isCountdownActive = true
    ZomboLust_OrgasmSystem.orgasmPlayer = player
    ZomboLust_OrgasmSystem.countdown = 0
    ZomboLust_OrgasmSystem.maxCountdown = 6 + ZombRand(5) -- 6 to 10 minutes IGT (approx 22-37s IRL on 90min day)
    ZomboLust_OrgasmSystem.pulseTimer = 0.0

    ZomboLust.debugLog(MODULE_NAME, "Orgasm Case 1 initiated. Countdown: %d minutes IGT.", ZomboLust_OrgasmSystem.maxCountdown)

    Events.EveryOneMinute.Add(onOrgasmEveryOneMinute)
    Events.OnTick.Add(onOrgasmCountdownTick)
end

--- Trigger the orgasm effects for Case 2 (During Animation)
--- @param player IsoPlayer
function ZomboLust_OrgasmSystem.triggerOrgasmCase2(player)
    ZomboLust_OrgasmSystem.triggerOrgasmEffects(player, false)
end
