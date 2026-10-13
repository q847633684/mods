--- File: ZomboDesire/42/media/lua/client/Transform/ZomboDesire_TransformZombHuman.lua
--- Handles direct transformation of a zombie into a ZombHuman
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_TransformZombHuman.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Main"
require "ZombHuman/ZomboDesire_ZombHumanBrain"
require "ZombHuman/ZomboDesire_ZombHumanUtils"
require "ZombHuman/ZomboDesire_ZombHumanUpdate"

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local abs = math.abs

--- Module name for logging
--- @type string
local MODULE_NAME = "TransformZombHuman"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboDesire.isDebug in ZomboDesire_Main.lua).
--- Calls with cheap/no arguments use ZomboDesire.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboDesire.isDebug(MODULE_NAME)
end

--- Initialization of namespace
local ZomboDesire_TransformZombHuman = {}

-- =================================
-- Main ID Logic and Brain Creation
-- =================================
--- Transforms a zombie directly into a ZombHuman by injecting a brain
--- @param collidedChar IsoZombie -- The zombie to transform
--- @param forceModTag string|nil -- Optional tag to force ("Desire" or "Lust")
--- @return boolean -- True if transformation was successful
function ZomboDesire_TransformZombHuman.transformZombieIntoZombHuman(collidedChar, forceModTag)
    ZomboDesire.debugLog(MODULE_NAME, "Starting direct zombie-to-ZombHuman transformation")

    if not collidedChar or not collidedChar:isZombie() then
        ZomboDesire.errorLog(MODULE_NAME, "Invalid zombie parameter")
        return false
    end

    -- Store zombie reference for later use
    ZomboDesire.originalZombie = collidedChar

    -- Generate a unique ID
    local id = ZomboDesire_ZombHumanUtils.GetZombHumanID(collidedChar)

    -- Create a simplified brain
    local brain = {
        id = id,
        tasks = {},
        speech = 0,
        voice = (collidedChar:isFemale() and 3 or (1 + abs(id) % 3)),
        forceModTag = forceModTag or "Desire"
    }

    -- Apply transformation (defined in ZomboDesire_ZombHumanUpdate.lua)
    ZomboDesire_ZombHumanUpdate.ZombHumanize(collidedChar, brain)

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Transformation successful for Zombie ID %d", collidedChar:getID())
    end

    -- Trigger completion flag for other modules
    ZomboDesire.ZombHumanizeCompleted = true

    return true
end

return ZomboDesire_TransformZombHuman
