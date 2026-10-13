-- File: ZomboLust/42/media/lua/client/ZomboLust_Physiology.lua
-- This module handles physiological changes during sexual animations (Wetness, Temperature, Metabolism)
-- @author BlaBla 2026 (based on ZomboWin logic)

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_Physiology.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"

-- ======================
-- Variables & Constants
-- ======================

-- Localized Enum constants for maximum performance (avoids repeated field access in OnTick)
local WETNESS     = CharacterStat.WETNESS
local TEMPERATURE = CharacterStat.TEMPERATURE
local ENDURANCE   = CharacterStat.ENDURANCE
local BOREDOM     = CharacterStat.BOREDOM
local THIRST      = CharacterStat.THIRST
local DISCOMFORT  = CharacterStat.DISCOMFORT
local HEAVY_WORK     = Metabolics.HeavyWork
local FITNESS              = Perks.Fitness

-- Module name for logging
--- @type string
local MODULE_NAME = "Physiology"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

-- Oscillator to create the "blinking" effect on moodles
local wetnessOscillator = 0

-- Internal tracking to bypass engine stat reset/conflicts
-- Module-local, not per-player modData: single-player only, see the Architecture Assumption note
-- in ZomboLust_Main.lua before relying on this across multiple simultaneous local players.
--- @type number
local internalDiscomfort = -1

-- ==========
-- Functions
-- ==========

--- Handles updates to player physiology during animations
--- @param player IsoPlayer -- The player character to update
local function onPlayerUpdate(player)
    -- Safety check: ensure player exists and is not dead
    if not player or player:isDead() then return end

    -- Only apply logic if the player is currently in a ZomboDesire animation scene
    -- (Redundant modData check removed as Event is managed dynamically)
    local stats = player:getStats()
    if not stats then
        ZomboLust.errorLog(MODULE_NAME, "Failed to get stats for player %s", player:getUsername())
        return
    end

    local bodyDamage = player:getBodyDamage()
    if not bodyDamage then
        ZomboLust.errorLog(MODULE_NAME, "Failed to get bodyDamage for player %s", player:getUsername())
        return
    end

    -- 1. Realism: Set metabolic target to simulate physical effort
    -- This naturally increases core temperature and sweat generation in B42
    local thermo = bodyDamage:getThermoregulator()
    if thermo then
        -- Setting to HeavyWork (like running or heavy lifting)
        thermo:setMetabolicTarget(HEAVY_WORK)
    else
        ZomboLust.warningLog(MODULE_NAME, "Thermoregulator not found for player %s", player:getUsername())
    end

    -- 2. Visual Effect: Wetness manipulation (based on ZomboWin)
    -- In PZ, the Wetness moodle appears at level 1 (> 15) and changes to Soaked at level 2 (> 40)
    -- We oscillate around 40 to make the moodle "blink" or change state frequently
    local currentWetness = stats:get(WETNESS)

    if currentWetness < 40 then
        -- Slowly increase wetness until we reach the threshold
        stats:set(WETNESS, currentWetness + 0.1)
    else
        -- Once at/above 40, create a blinking effect by toggling values
        wetnessOscillator = wetnessOscillator + 1
        if wetnessOscillator % 30 == 0 then
            if dbg() then
                ZomboLust.debugLog(MODULE_NAME, "Wetness threshold reached, oscillating moodle for %s", player:getUsername())
            end
        end

        -- Toggle every 15 frames for a noticeable blink
        if wetnessOscillator % 30 < 15 then
            stats:set(WETNESS, 39.5)
        else
            stats:set(WETNESS, 40.5)
        end
    end

    -- 3. Manual Temperature increase
    -- Simulates the heat of the moment beyond what the metabolic rate does naturally
    -- Target 38.5 Celsius (Feverish level, but not dangerous)
    local currentTemp = stats:get(TEMPERATURE)
    if currentTemp < 38.5 then
        stats:set(TEMPERATURE, currentTemp + 0.005)
    elseif currentTemp >= 38.5 and currentTemp < 38.505 then
        -- if ZomboLust.Debug.enabled and ZomboLust.Debug.modules[MODULE_NAME] then
            -- ZomboLust.debugLog(MODULE_NAME, "Target physiological temperature (38.5) reached for %s", player:getUsername())
        -- end
    end

    -- 4. Effort & Stamina: Decrease endurance to simulate exertion
    -- Refined logic: Asymptotic stabilization (Target Floor)
    -- Instead of dropping to 0, endurance will stabilize at a "hard work" level base on traits
    -- Stabilization examples (Male, Fitness 0 to 10):
    -- YoungBuck    : 0.60 to 0.85 (Alert/Ready)
    -- LowEffort    : 0.45 to 0.70 (Moderate fatigue)
    -- SpunkDefault : 0.30 to 0.55 (Standard exertion)
    -- InPrime      : 0.20 to 0.45 (High fatigue)
    -- AARP         : 0.05 to 0.30 (Total exhaustion)

    -- Trait-based endurance configuration (Fornication traits)
    local baseFloor = 0.30 -- Default (SpunkDefault)
    local enduranceLossFactor = 0.002 -- Default smooth factor (SpunkDefault)
    local traits = ZomboLustRegistries.Traits

    if traits then
        if player:hasTrait(traits.YoungBuck) then
            baseFloor = 0.60
            enduranceLossFactor = 0.0005 -- Very low loss
        elseif player:hasTrait(traits.LowEffort) then
            baseFloor = 0.45
            enduranceLossFactor = 0.001 -- Low loss
        elseif player:hasTrait(traits.InPrime) then
            baseFloor = 0.20
            enduranceLossFactor = 0.004 -- High loss
        elseif player:hasTrait(traits.AARP) then
            baseFloor = 0.05
            enduranceLossFactor = 0.008 -- Very high loss
        end
    end

    -- Calculate the final target floor based on Fitness (0.0 to 1.0)
    local fitnessLevel = player:getPerkLevel(FITNESS)
    local targetFloor = baseFloor + (fitnessLevel * 0.025)

    -- Gender modifier: Females maintain slightly more breath (based on ZomboWin spirit)
    if player:isFemale() then
        targetFloor = targetFloor + 0.05
    end

    -- Cap targetFloor to ensure some minimal exertion is possible
    if targetFloor > 0.95 then targetFloor = 0.95 end

    local currentEndurance = stats:get(ENDURANCE)
    if currentEndurance > targetFloor then
        -- Asymptotic decay: lose X% of the distance to the floor per update
        -- This makes the loss fast at first, then very slow as it approaches the target
        local diff = currentEndurance - targetFloor
        local enduranceLoss = diff * enduranceLossFactor -- Smooth factor

        stats:set(ENDURANCE, currentEndurance - enduranceLoss)

        -- Debug log when the player starts to feel the exertion
        if dbg() then
            if currentEndurance >= 0.75 and (currentEndurance - enduranceLoss) < 0.75 then
                ZomboLust.debugLog(MODULE_NAME, "Player %s exertion (factor %.4f) stabilizing towards floor: %.2f", player:getUsername(), enduranceLossFactor, targetFloor)
            end
        end
    end

    -- 5. Psychological effects: Decrease boredom (Ennui)
    -- Asymptotic reduction towards 0.0 (total distraction)
    local currentBoredom = stats:get(BOREDOM)
    if currentBoredom > 0 then
        -- Slowly reduce boredom
        local boredomLoss = currentBoredom * 0.005
        stats:set(BOREDOM, currentBoredom - boredomLoss)
    end

    -- 6. Dehydration: Increase thirst due to sweat and effort
    -- Refined logic: Asymptotic growth towards a target ceiling
    -- This prevents excessive dehydration during very long animations

    -- Target ceiling: 0.25 (Limit of level 1 moodle "Slightly Thirsty")
    local targetCeiling = 0.25
    local currentThirst = stats:get(THIRST)

    if currentThirst < targetCeiling then
        -- Slowly increase thirst as a percentage of the remaining gap to the ceiling
        local diff = targetCeiling - currentThirst
        local thirstIncrease = diff * 0.0001 -- Very slow asymptotic approach

        stats:set(THIRST, currentThirst + thirstIncrease)
    end

    -- 7. Discomfort: Increase progressively during the act (cumulative & asymptotic)
    -- Target Ceiling: 95.0 (Deep into Level 4 "Extremely Uncomfortable" on 0-100 scale)
    -- We use internalDiscomfort to prevent the engine from overriding our values.
    local targetDiscomfortCeiling = 95.0
    
    -- Initialize if it's a new animation scene
    if internalDiscomfort < 0 then
        internalDiscomfort = stats:get(DISCOMFORT)
    end

    if internalDiscomfort < targetDiscomfortCeiling then
        -- Refined factor: 0.00015 for a slower, more natural progression
        -- Reaches Niveau 3 (~70.0) only on longer scenes, avoiding instant Niveau 4.
        local diff = targetDiscomfortCeiling - internalDiscomfort
        local discomfortIncrease = diff * 0.00015

        internalDiscomfort = internalDiscomfort + discomfortIncrease
        stats:set(DISCOMFORT, internalDiscomfort)
    end

    -- 8. Masochist: Maximum groin pain for the duration of any sexual animation
    -- Reasserted every tick (like Nymphomaniac's pain floor in ZomboLust_ExcitationSystem.lua),
    -- since the engine decays pain on its own each frame.
    if traits and player:hasTrait(traits.Masochist) then
        if player:getMoodles():getMoodleLevel(MoodleType.PAIN) < 4 then
            local groin = bodyDamage:getBodyPart(BodyPartType.Groin)
            if groin then
                groin:setAdditionalPain(100) -- Level 4 "Agony"
            end
        end
    end
end

-- ====================
-- Animation Management
-- ====================

--- @class (partial) ISZomboDesireAnimationAction
--- @field zomboLustEventTracked boolean|nil

-- Track the number of active animations to manage the OnPlayerUpdate event
local activeAnimations = 0

--- Adds the player update event if it's the first animation starting
--- @param action ISZomboDesireAnimationAction
local function addUpdateEvent(action)
    if action.zomboLustEventTracked then return end
    action.zomboLustEventTracked = true

    activeAnimations = activeAnimations + 1
    if activeAnimations == 1 then
        Events.OnPlayerUpdate.Add(onPlayerUpdate)
        ZomboLust.debugLog(MODULE_NAME, "Dynamically ADDED OnPlayerUpdate event (Active animations: %d)", activeAnimations)
    end
end

--- Removes the player update event if it's the last animation ending
--- @param action ISZomboDesireAnimationAction
local function removeUpdateEvent(action)
    if not action.zomboLustEventTracked then return end
    action.zomboLustEventTracked = false

    activeAnimations = activeAnimations - 1
    if activeAnimations <= 0 then
        activeAnimations = 0
        internalDiscomfort = -1 -- Reset internal tracking
        Events.OnPlayerUpdate.Remove(onPlayerUpdate)
        ZomboLust.debugLog(MODULE_NAME, "Dynamically REMOVED OnPlayerUpdate event")
    end
end

-- =======================================
-- ZomboDesire Animation Lifecycle Events
-- =======================================

-- We subscribe to ZomboDesire's own animation lifecycle events
-- (declared in ZomboDesire_Init.lua, fired from ISZomboDesireAnimationAction:start/perform/stop in ZomboDesire_AnimationHandler.lua)
-- to dynamically manage the CPU-heavy OnPlayerUpdate event.
-- This used to monkey-patch start/perform/stop directly; renaming those methods inside ZomboDesire
-- would have silently broken the hook (no error, the patched methods would simply never run).
-- Subscribing to named events instead means ZomboDesire is free to rename/reorganize
-- its own methods as long as it keeps firing these three events from wherever that logic ends up.

--- @param action ISZomboDesireAnimationAction
local function onAnimationActionStart(action)
    -- Only track for players, not zombies or NPCs (ZombHumans)
    if action.character and instanceof(action.character, "IsoPlayer") and not action.character:isZombie() then
        addUpdateEvent(action)
    end
end

--- Shared handler for both normal completion (Perform) and interruption (Stop):
--- both cases mean "this action is done, stop tracking it" for our purposes.
--- @param action ISZomboDesireAnimationAction
local function onAnimationActionEnd(action)
    if action.character and instanceof(action.character, "IsoPlayer") and not action.character:isZombie() then
        removeUpdateEvent(action)
    end
end

-- Ensure the events exist before subscribing (ZomboDesire must be loaded and up to date)
if Events.OnZomboDesireAnimationActionStart and Events.OnZomboDesireAnimationActionPerform and Events.OnZomboDesireAnimationActionStop then
    Events.OnZomboDesireAnimationActionStart.Add(onAnimationActionStart)
    Events.OnZomboDesireAnimationActionPerform.Add(onAnimationActionEnd)
    Events.OnZomboDesireAnimationActionStop.Add(onAnimationActionEnd)
else
    ZomboLust.errorLog(MODULE_NAME, "ZomboDesire animation lifecycle events not found (ZomboDesire missing or outdated)! Dynamic event management disabled.")
end
