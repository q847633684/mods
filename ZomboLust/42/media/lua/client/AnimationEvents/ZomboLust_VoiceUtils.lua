--- File: ZomboLust/42/media/lua/client/AnimationEvents/ZomboLust_VoiceUtils.lua
--- Voice Utility Functions
--- Provides centralized voice detection and name mapping for animation events
--- Maps Project Zomboid's voiceType numeric values to voice names
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_VoiceUtils.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_AnimationHandler"
require "ZomboLust_Main"

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local tostring = tostring

local ZomboLust_VoiceUtils = {}

--- Module name for logging
--- @type string
local MODULE_NAME = "VoiceUtils"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

--- Voice type to name mapping based on voiceStyles.xml
--- Female voices:
---   0 = Kate
---   1 = Casey-Jo (mapped to "Caseyjo" for file naming)
---   2 = Maryanne
---   3 = Janine
--- Male voices:
---   0 = Bob
---   1 = Hank
---   2 = James
---   3 = Chris
local FEMALE_VOICE_NAMES = {
    [0] = "Kate",
    [1] = "Caseyjo",  -- Casey-Jo without hyphen
    [2] = "Maryanne",
    [3] = "Janine"
}

local MALE_VOICE_NAMES = {
    [0] = "Bob",
    [1] = "Hank",
    [2] = "James",
    [3] = "Chris"
}

--- Gets the voice name for a character
--- @param character IsoGameCharacter -- The character to get the voice name for
--- @return string -- The voice name (e.g., "Janine", "Caseyjo", "Bob", "Chris")
function ZomboLust_VoiceUtils.GetVoiceName(character)
    -- Check ModData first to avoid Java calls
    local modData = character:getModData()
    if modData.ZL_VoiceName then
        return modData.ZL_VoiceName
    end

    local descriptor = character:getDescriptor()
    local voiceType = descriptor:getVoiceType()
    local isFemale = character:isFemale()

    ZomboLust.debugLog(MODULE_NAME, "GetVoiceName called - voiceType %d, isFemale %s", voiceType, tostring(isFemale))

    local voiceName
    if isFemale then
        voiceName = FEMALE_VOICE_NAMES[voiceType] or "Kate"
    else
        voiceName = MALE_VOICE_NAMES[voiceType] or "Bob"
    end

    -- Cache in ModData for future calls
    modData.ZL_VoiceName = voiceName

    ZomboLust.debugLog(MODULE_NAME, "Returning %s voice %s (Cached in ModData)", isFemale and "female" or "male", voiceName)

    return voiceName
end

--- Constructs a sound name for a character and sound type
--- @param character IsoGameCharacter -- The character
--- @param soundType string -- The sound type (e.g., "BreathFast", "GruntToneLow")
--- @return string -- The full sound name (e.g., "JanineBreathFast")
function ZomboLust_VoiceUtils.GetSoundName(character, soundType)
    local voiceName = ZomboLust_VoiceUtils.GetVoiceName(character)
    local soundName = voiceName .. soundType
    -- ZomboLust.debugLog(MODULE_NAME, "GetSoundName constructed %s (voiceName %s, soundType %s)", soundName, voiceName, soundType)
    return soundName
end

return ZomboLust_VoiceUtils
