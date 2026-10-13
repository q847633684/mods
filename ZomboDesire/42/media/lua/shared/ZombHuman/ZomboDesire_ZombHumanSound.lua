--- File: ZomboDesire/42/media/lua/shared/ZombHuman/ZomboDesire_ZombHumanSound.lua
--- Provides sound management for ZombHuman entities, including vocal phrases and speech cooldowns
--- @author BlaBla 2026
---
--- NOT YET WIRED UP: no caller requires this module yet. Reserved for the planned
--- "living human bandit ZombHuman" encounters (friendly or hostile player interactions),
--- where the ZombHuman needs to speak instead of staying silent like a standard undead ZombHuman.

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_ZombHumanSound.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Main"

--- Module name for logging
--- @type string
local MODULE_NAME = "ZombHumanSound"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboDesire.isDebug in ZomboDesire_Main.lua).
--- Calls with cheap/no arguments use ZomboDesire.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboDesire.isDebug(MODULE_NAME)
end

--- Global module for ZombHuman sound and vocal management
ZomboDesire_ZombHumanSound = ZomboDesire_ZombHumanSound or {}

--- Definition of vocal phrase configurations including prefixes, chances, and durations
ZomboDesire_ZombHumanSound.SoundTab = {
    SPOTTED =           {prefix = "ZSSpotted_", chance = 70, randMax = 6, length = 10},
    HIT =               {prefix = "ZSHit_", chance = 100, randMax = 14, length = 0.1},
    BREACH =            {prefix = "ZSBreach_", chance = 80, randMax = 6, length = 10},
    RELOADING =         {prefix = "ZSReloading_", chance = 80, randMax = 6, length = 4},
    CAR =               {prefix = "ZSCar_", chance = 90, randMax = 6, length = 4},
    DEATH =             {prefix = "ZSDeath_", chance = 70, randMax = 8, length = 6},
    DEAD =              {prefix = "ZSDead_", chance = 100, randMax = 6, length = 3},
    BURN =              {prefix = "ZSBurn_", chance = 100, randMax = 3, length = 8},
    DRAGDOWN =          {prefix = "ZSDragdown_", chance = 100, randMax = 3, length = 8},
}

--- Plays a vocal phrase for a ZombHuman if conditions are met (distance, chance, cooldown)
--- @param zombie IsoZombie -- The zombie entity that will 'say' the phrase
--- @param phrase string -- The key for the phrase configuration in ZombHumanSound.SoundTab (e.g., 'SPOTTED')
--- @param force boolean|nil -- If true, interrupts current speech and forces the new phrase to play
function ZomboDesire_ZombHumanSound.Say(zombie, phrase, force)
    local brain = ZomboDesire_ZombHumanBrain.Get(zombie)
    if not brain then 
        ZomboDesire.errorLog(MODULE_NAME, "Say -> No brain found for zombie ID %d", zombie:getID())
        return 
    end

    if not force and brain.speech and brain.speech > 0 then
        -- if ZomboDesire.Debug.enabled and ZomboDesire.Debug.modules[MODULE_NAME] then
            -- ZomboDesire.debugLog(MODULE_NAME, "Say -> Skipping phrase '%s' for ID %d (cooldown active: %.2f)", phrase, zombie:getID(), brain.speech)
        -- end
        return 
    end

    if force then
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Say -> Forcing phrase '%s' for ID %d (interrupting existing sounds)", phrase, zombie:getID())
        end
        zombie:getEmitter():stopAll()
    end

    local player = getSpecificPlayer(0)
    if not player then return end

    local dist = ZomboDesire_ZombHumanUtils.DistTo(player:getX(), player:getY(), zombie:getX(), zombie:getY())

    if dist <= 14 then
        local voice
        local sex = zombie:isFemale() and "Female" or "Male"

        if brain.voice then 
            voice = brain.voice
        else
            -- fallback/default voice logic
            if zombie:isFemale() then 
                voice = 3
            else
                local brainId = brain.id or 0
                voice = 1 + (brainId < 0 and -brainId or brainId) % 4
                if voice > 4 then voice = 1 end
            end
        end

        local config = ZomboDesire_ZombHumanSound.SoundTab[phrase]
        if config then
            local r = ZombRand(100)
            if r < config.chance then
                local soundName = config.prefix .. sex .. "_" .. voice .. "_" .. tostring(1 + ZombRand(config.randMax))
                local length = config.length or 2

                if dbg() then
                    ZomboDesire.debugLog(MODULE_NAME, "Say -> Playing sound '%s' for ID %d (dist: %.2f, sex: %s, voice: %s)", soundName, zombie:getID(), dist, sex, tostring(voice))
                end

                -- Always play for now, can add options later if needed
                zombie:getEmitter():playVocals(soundName)
                brain.speech = length
            else
                -- if ZomboDesire.Debug.enabled and ZomboDesire.Debug.modules[MODULE_NAME] then
                    -- ZomboDesire.debugLog(MODULE_NAME, "Say -> Chance check failed for phrase '%s' (r=%d, chance=%d)", phrase, r, config.chance)
                -- end
            end
        else
            ZomboDesire.warningLog(MODULE_NAME, "Say -> Configuration for phrase '%s' not found in SoundTab", phrase)
        end
    else
        -- if ZomboDesire.Debug.enabled and ZomboDesire.Debug.modules[MODULE_NAME] then
            -- ZomboDesire.debugLog(MODULE_NAME, "Say -> Zombie ID %d too far to play phrase '%s' (dist: %.2f)", zombie:getID(), phrase, dist)
        -- end
    end
end

return ZomboDesire_ZombHumanSound
