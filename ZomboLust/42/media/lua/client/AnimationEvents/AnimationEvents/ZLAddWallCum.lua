--- File: ZomboLust/42/media/lua/client/AnimationEvents/AnimationEvents/ZLAddWallCum.lua
--- Animation Event: Adds a cum texture to the wall
--- @author BlaBla 2026

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"
local BukkakeWorld = require "Bukkake/ZomboLust_BukkakeWorld"

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local tostring = tostring
local type     = type

-- Module name for logging
local MODULE_NAME = "BukkakeWorld"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

--- @param action any -- The animation action object
--- @param eventName string -- The name of the event (e.g., 'ZLAddWallCum')
--- @param parameter string -- The parameter value
return function(action, eventName, parameter)
    ZomboLust.debugLog(MODULE_NAME, "ZLAddWallCum handler called -> eventName: %s, parameter: %s", tostring(eventName), tostring(parameter))

    local character = action
    if action and type(action) == "table" and action.character then 
        character = action.character 
    end

    if not character then
        ZomboLust.errorLog(MODULE_NAME, "ZLAddWallCum: No character found in action")
        return
    end

    BukkakeWorld.addWallCum(character)
end
