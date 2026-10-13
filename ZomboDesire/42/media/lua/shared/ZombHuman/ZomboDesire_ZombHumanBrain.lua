--- File: ZomboDesire/42/media/lua/shared/ZombHuman/ZomboDesire_ZombHumanBrain.lua
--- Manages the ZombHuman brain data stored in a zombie's modData
--- providing accessors and utility functions for brain and task management
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_ZombHumanBrain.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Main"

--- Module name for logging
--- @type string
local MODULE_NAME = "ZombHumanBrain"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboDesire.isDebug in ZomboDesire_Main.lua).
--- Calls with cheap/no arguments use ZomboDesire.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboDesire.isDebug(MODULE_NAME)
end

--- Global module for ZombHuman brain management
ZomboDesire_ZombHumanBrain = ZomboDesire_ZombHumanBrain or {}

--- Retrieves the ZombHuman brain from the zombie's modData
--- @param zombie IsoZombie -- The zombie entity to retrieve the brain from
--- @return table|nil -- The brain data table or nil if it doesn't exist
function ZomboDesire_ZombHumanBrain.Get(zombie)
    if not zombie then return nil end
    local modData = zombie:getModData()
    return modData.zombHumanBrain
end

--- Updates or sets the ZombHuman brain in the zombie's modData
--- @param zombie IsoZombie -- The zombie entity to update
--- @param brain table -- The brain data table to store
function ZomboDesire_ZombHumanBrain.Update(zombie, brain)
    if not zombie then 
        ZomboDesire.errorLog(MODULE_NAME, "ZombHumanBrain.Update -> zombie is nil")
        return 
    end
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "ZombHumanBrain.Update -> Assigning/Updating brain for zombie ID %d", zombie:getID())
    end
    local modData = zombie:getModData()
    modData.zombHumanBrain = brain
end

--- Removes the ZombHuman brain from the zombie's modData
--- @param zombie IsoZombie -- The zombie entity to remove the brain from
function ZomboDesire_ZombHumanBrain.Remove(zombie)
    if not zombie then return end
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "ZombHumanBrain.Remove -> Removing brain from zombie ID %d", zombie:getID())
    end
    local modData = zombie:getModData()
    modData.zombHumanBrain = nil
end

--- Checks if the given brain has any tasks in its task list
--- @param brain table -- The brain data table to check
--- @return boolean -- True if the brain has one or more tasks, false otherwise
function ZomboDesire_ZombHumanBrain.HasTask(brain)
    if brain and brain.tasks and #brain.tasks > 0 then
        return true
    end
    return false
end

--- Checks if the given brain has at least one task of a specific action type
--- @param brain table -- The brain data table to check
--- @param taskType string -- The action type of the task to search for
--- @return boolean -- True if a matching task type is found, false otherwise
function ZomboDesire_ZombHumanBrain.HasTaskType(brain, taskType)
    if not brain or not brain.tasks then return false end
    for i = 1, #brain.tasks do
        local task = brain.tasks[i]
        if task.action == taskType then
            return true
        end
    end
    return false
end

return ZomboDesire_ZombHumanBrain
