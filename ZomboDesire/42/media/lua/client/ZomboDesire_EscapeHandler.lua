--- File: ZomboDesire/42/media/lua/client/ZomboDesire_EscapeHandler.lua
--- Client-side escape ability: prevent zombies from seeing the player for a limited time
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_EscapeHandler.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Main" -- Main module with debug functions

--- Module Declaration - Main module for the escape ability functionality
--- @class ZomboDesire_EscapeHandler
--- @field escapeTimerSet boolean -- Flag indicating if the escape timer is currently active
--- @field escapeTimerStart number -- Timestamp when the escape ability was activated (in seconds)
--- @field escapeTimerDuration number -- Duration of the escape effect (in seconds)
--- @field executeEscape function -- Main function to activate the escape ability
ZomboDesire_EscapeHandler = ZomboDesire_EscapeHandler or {}

-- State variables
ZomboDesire_EscapeHandler.escapeTimerSet      = false  -- Flag indicating if the escape timer is currently active
ZomboDesire_EscapeHandler.escapeTimerStart    = 0      -- Timestamp when the escape ability was activated (in seconds)
ZomboDesire_EscapeHandler.escapeTimerDuration = 0      -- Duration of the escape effect (in seconds)

--- Module name for logging
--- @type string
local MODULE_NAME = "EscapeHandler"

--- Accumulator for real-world time to ensure consistent blinking speed
--- @type number
local blinkRealTime = 0

-- ==================
--- Ability functions
-- ==================

--- Makes zombies ignore the player by setting them as "useless"
--- Called on every tick while the escape ability is active
--- @return nil
local function clearZombieAwareness()
    local cell = getCell()
    local zombieList  = cell:getZombieList()
    local zombieCount = zombieList:size()

    -- ZomboDesire.debugLog(MODULE_NAME, "clearZombieAwareness -> processing %d zombies", zombieCount)

    for i = 0, zombieCount - 1 do
        local zombie = zombieList:get(i)
        -- Track it in the global table only if it wasn't already useless
        if not zombie:isUseless() then
            zombie:setUseless(true)
            if ZomboDesire.neutralizedZombies then
                ZomboDesire.neutralizedZombies[zombie] = true
            end
        end
    end
end

--- Helper: calculate zombie attraction radius based on escape duration
--- Formula: (escapeDuration - 1) * 10 (in game units)
--- Results in gradual attraction radius increase: 0 -> 10 -> 40 -> 90 for 1-10 minutes
--- @param escapeDurationMinutes number -- Duration of escape in minutes (1-10)
--- @return number -- Attraction radius (0-90)
local function calculateZombieAttractionRadius(escapeDurationMinutes)
    local val = (escapeDurationMinutes - 1) * 10
    val = val < 0 and 0 or (val > 90 and 90 or val)
    return val - val % 1
end

--- Helper: apply zombie attraction by emitting a world sound at player location
--- Creates an "audible disturbance" that attracts nearby zombies based on radius
--- @param player IsoPlayer -- The player character
--- @param attractionRadius number -- Radius of attraction in game units
--- @return nil
local function applyZombieAttraction(player, attractionRadius)
    if not player then
        ZomboDesire.errorLog(MODULE_NAME, "applyZombieAttraction -> player is nil")
        return
    end

    local playerLocation = player:getCurrentSquare()
    if not playerLocation then
        ZomboDesire.errorLog(MODULE_NAME, "applyZombieAttraction -> player location is nil")
        return
    end

    local soundManager = getWorldSoundManager()
    if soundManager then
        ---@diagnostic disable-next-line: param-type-mismatch
        soundManager:addSound(player, playerLocation:getX(), playerLocation:getY(), playerLocation:getZ(), attractionRadius, 100)
        ZomboDesire.debugLog(MODULE_NAME, "applyZombieAttraction -> Emitted attraction signal with radius %d at player location", attractionRadius)
    else
        ZomboDesire.errorLog(MODULE_NAME, "applyZombieAttraction -> WorldSoundManager not found")
    end
end

--- Helper: reactivate all zombies so they resume their normal behavior
--- @return nil
local function restoreZombieAwareness()
    ZomboDesire.debugLog(MODULE_NAME, "restoreZombieAwareness -> restoring all neutralized zombies")

    -- 1. Restore zombies from the global tracking table (guarantees restoration of distant zombies)
    if ZomboDesire.neutralizedZombies then
        local trackedCount = 0
        for zombie, _ in pairs(ZomboDesire.neutralizedZombies) do
            -- Ensure the zombie object is still valid and alive
            if zombie and zombie:isAlive() then
                zombie:setUseless(false)
                trackedCount = trackedCount + 1
            end
        end
        ZomboDesire.debugLog(MODULE_NAME, "restoreZombieAwareness -> restored %d tracked zombies from global table", trackedCount)
        -- Clear the table for next use to avoid memory leaks or stale references
        ZomboDesire.neutralizedZombies = {}
    end

    -- 2. Safety catch-all: also ensure all zombies in the current cell are reactivated
    local cell = getCell()
    local zombieList  = cell:getZombieList()
    local zombieCount = zombieList:size()
    
    for i = 0, zombieCount - 1 do
        local zombie = zombieList:get(i)
        zombie:setUseless(false)
    end

    local player = getPlayer()
    if player then
        player:setTargetAlpha(1.0)
    end

    local escapeDurationMinutes = ZomboDesire_EscapeHandler.escapeTimerDuration / 60
    local attractionRadius = calculateZombieAttractionRadius(escapeDurationMinutes)
    ---@cast attractionRadius integer

    if attractionRadius > 0 then
        applyZombieAttraction(player, attractionRadius)
    else
        ZomboDesire.debugLog(MODULE_NAME, "restoreZombieAwareness -> Invisibility duration too short (%.1f min), no attraction penalty applied", escapeDurationMinutes)
    end
end

--- Handles player opacity based on escape duration progress (blinking effect)
--- @param player IsoPlayer -- The player character
--- @return nil
local function updatePlayerOpacity(player)
    if not player or not ZomboDesire_EscapeHandler.escapeTimerSet then return end

    -- Update real time accumulator using engine delta
    blinkRealTime = blinkRealTime + getGameTime():getRealworldSecondsSinceLastUpdate() ---@cast blinkRealTime number

    local currentTimeSeconds = getGameTime():getWorldAgeHours() * 3600
    local elapsed = currentTimeSeconds - ZomboDesire_EscapeHandler.escapeTimerStart
    local progress = elapsed / ZomboDesire_EscapeHandler.escapeTimerDuration

    if progress < 0.60 then
        -- Normal phase: semi-transparent
        player:setTargetAlpha(0.5)
    elseif progress < 0.80 then
        -- Warning phase 1: slow blink (every 0.5s real time)
        local blinkFlag = math.floor(blinkRealTime / 0.5) % 2 == 0
        player:setTargetAlpha(blinkFlag and 0.5 or 1.0)
    elseif progress < 1.0 then
        -- Warning phase 2: fast blink (every 0.2s real time)
        local blinkFlag = math.floor(blinkRealTime / 0.2) % 2 == 0
        player:setTargetAlpha(blinkFlag and 0.5 or 1.0)
    else
        -- End of duration reached, restore opacity
        player:setTargetAlpha(1.0)
    end
end

--- Helper: tick-based timer to end the escape ability
--- Checks if the escape duration has elapsed and performs cleanup
--- @return nil
local function updateEscapeTimer()
    local currentTimeSeconds = getGameTime():getWorldAgeHours() * 3600  -- current time in seconds
    if currentTimeSeconds - ZomboDesire_EscapeHandler.escapeTimerStart < ZomboDesire_EscapeHandler.escapeTimerDuration then
        return
    end

    -- Escape duration has elapsed, perform cleanup
    ZomboDesire.debugLog(MODULE_NAME, "Invisibility period ended after %d seconds.", ZomboDesire_EscapeHandler.escapeTimerDuration)

    -- Cleanup listeners
    Events.OnTick.Remove(clearZombieAwareness)
    Events.OnTick.Remove(updateEscapeTimer)
    Events.OnPlayerUpdate.Remove(updatePlayerOpacity)

    -- reactivate all zombies and apply attraction penalty
    restoreZombieAwareness()

    -- reset the escape timer
    ZomboDesire_EscapeHandler.escapeTimerSet = false

    -- Immediate re-enable of collision listener for ZomboDesire_Intercept.lua
    if not ZomboDesire.collisionListener then
        ZomboDesire.errorLog(MODULE_NAME, "collisionListener not found in ZomboDesire table")
        return
    end

    if not ZomboDesire.isCollisionListenerRegistered then
        Events.OnCharacterCollide.Add(ZomboDesire.collisionListener)
        ZomboDesire.isCollisionListenerRegistered = true
        ZomboDesire.debugLog(MODULE_NAME, "Collision listener re-enabled after escape")
    else
        ZomboDesire.debugLog(MODULE_NAME, "Collision listener already registered, skipping re-enable after escape")
    end
end

--- Main function: Activates the player's invisibility to zombies for a limited time
--- Called directly from ZomboDesire_Cleanup.restoreState() after animation completion
--- @param player IsoPlayer -- The player character to apply the escape ability to
--- @return nil
function ZomboDesire_EscapeHandler.executeEscape(player)
    ZomboDesire.debugLog(MODULE_NAME, "executeEscape called")

    if not player then
        ZomboDesire.errorLog(MODULE_NAME, "Player parameter is nil")
        return
    end

    -- Setup the escape timer and listeners only if not already active
    if not ZomboDesire_EscapeHandler.escapeTimerSet then
        -- Calculate start time and set duration
        ZomboDesire_EscapeHandler.escapeTimerStart = getGameTime():getWorldAgeHours() * 3600  -- Convert to seconds
        -- Get escape duration from mod options
        local options = PZAPI.ModOptions:getOptions("ZomboDesire")
        if options then
            local escapeDurationOption = options:getOption("escapeDuration")
            if escapeDurationOption then
                ---@diagnostic disable-next-line: need-check-nil
                local duration = escapeDurationOption:getValue()
                if duration then
                    ---@diagnostic disable-next-line: param-type-mismatch
                    ZomboDesire_EscapeHandler.escapeTimerDuration = duration * 60
                else
                    ZomboDesire_EscapeHandler.escapeTimerDuration = 180  -- Fallback: Duration in seconds (3 minutes)
                end
            else
                ZomboDesire_EscapeHandler.escapeTimerDuration = 180  -- Fallback: Duration in seconds (3 minutes)
            end
        else
            ZomboDesire_EscapeHandler.escapeTimerDuration = 180  -- Fallback: Duration in seconds (3 minutes)
        end

        ZomboDesire.debugLog(MODULE_NAME, "Invisibility period started for %d seconds.", ZomboDesire_EscapeHandler.escapeTimerDuration)

        -- Reset blink timer for new escape
        blinkRealTime = 0

        -- Register event handlers for zombie awareness and timer updates
        Events.OnTick.Add(clearZombieAwareness)
        Events.OnTick.Add(updateEscapeTimer)
        Events.OnPlayerUpdate.Add(updatePlayerOpacity)

        -- Mark the escape ability as active
        ZomboDesire_EscapeHandler.escapeTimerSet = true
    else
        ZomboDesire.debugLog(MODULE_NAME, "Escape ability already active - skipping activation")
    end
end

ZomboDesire.debugLog(MODULE_NAME, "Escape handler ready")
return ZomboDesire_EscapeHandler
