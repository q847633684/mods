--- File: ZomboDesire/42/media/lua/client/AnimationEvents/ZomboDesire_EventsHandler.lua
--- Handles custom animation events by lazy-loading modules from AnimationEvents folder
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_EventsHandler.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Main" -- Main module with debug functions
-- Import the base timed action class for animation actions
require "TimedActions/ISBaseTimedAction"

--- Reference to the timed action queue for adding animation actions
--- @type table
local ISTimedActionQueue = ISTimedActionQueue

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local setmetatable = setmetatable
local pcall        = pcall
local type         = type

--- Module name for logging
--- @type string
local MODULE_NAME = "EventsHandler"

--- Setup lazy-loading for frame event handlers (<FrameEvent>)
--- When an unknown event is accessed, this metatable will attempt to load
--- the corresponding module from AnimationEvents/AnimationEvents/
setmetatable(ZomboDesire.EventMarkerModules, {
    --- Metatable __index function for lazy-loading frame event handlers
    --- @param self table -- The EventMarkerModules table
    --- @param event string -- The name of the event to load
    --- @return function|boolean -- The handler function if loaded successfully, false otherwise
    __index = function(self, event)
        -- Try requiring the corresponding module
        local modulePath = "AnimationEvents/AnimationEvents/" .. event
        local loadSuccess, moduleResult = pcall(require, modulePath)

        if loadSuccess and type(moduleResult) == "function" then
            -- Store the handler function for future use
            ---@cast moduleResult function
            rawset(self, event, moduleResult)
            ZomboDesire.debugLog(MODULE_NAME, "Loaded frame event handler for '%s'", event)
            return moduleResult
        end

        -- Mark as unavailable by setting to false
        rawset(self, event, false)
        ZomboDesire.warningLog(MODULE_NAME, "Failed to load frame event handler for '%s'", event)
        return false
    end
})

--- Setup lazy-loading for action event handlers (<ActionEvent>)
--- When an unknown event is accessed, this metatable will attempt to load
--- the corresponding module from AnimationEvents/ActionEvents/
setmetatable(ZomboDesire.ActionEventModules, {
    --- Metatable __index function for lazy-loading action event handlers
    --- @param self table -- The ActionEventModules table
    --- @param event string -- The name of the event to load
    --- @return table|boolean -- The handler module if loaded successfully, false otherwise
    __index = function(self, event)
        -- Try requiring the corresponding module
        local modulePath = "AnimationEvents/ActionEvents/" .. event
        local loadSuccess, moduleResult = pcall(require, modulePath)

        if loadSuccess and type(moduleResult) == "table" then
            -- Store the handler module for future use
            ---@cast moduleResult table
            rawset(self, event, moduleResult)
            ZomboDesire.debugLog(MODULE_NAME, "Loaded action event handler for '%s'", event)
            return moduleResult
        end

        -- Mark as unavailable by setting to false
        rawset(self, event, false)
        ZomboDesire.warningLog(MODULE_NAME, "Failed to load action event handler for '%s'", event)
        return false
    end
})

--- Helper function to trigger a custom animation action
--- Creates and queues an ISZomboDesireAnimationAction for the specified player
--- @param player IsoPlayer -- The IsoPlayer instance to perform the animation
--- @param animationName string -- The name of the animation to play
--- @param duration number -- The duration of the animation in game time
--- @return nil
function ZomboDesire_playAnimation(player, animationName, duration)
    -- Create a new animation action with the specified parameters
    ---@diagnostic disable-next-line: redundant-parameter
    local action = ISZomboDesireAnimationAction:new(player, animationName, duration)
    -- Add the action to the timed action queue for execution
    ISTimedActionQueue.add(action)
end
