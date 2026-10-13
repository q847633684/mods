--- File: ZomboDesire/42/media/lua/shared/ZombHuman/ZomboDesire_ZombHumanTask.lua
--- Manages tasks for ZombHuman entities, including task adding, retrieval, and removal, as well as core animation timing actions
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_ZombHumanTask.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Main"

--- Module name for logging
--- @type string
local MODULE_NAME = "ZombHumanTask"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboDesire.isDebug in ZomboDesire_Main.lua).
--- Calls with cheap/no arguments use ZomboDesire.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboDesire.isDebug(MODULE_NAME)
end

--- Global module for ZombHuman action definitions
ZomboDesire_ZombHumanActions = ZomboDesire_ZombHumanActions or {}

--- Time action (used for animations)
ZomboDesire_ZombHumanActions.Time = {}

--- Called when a Time task starts
--- @param zombie IsoZombie -- The zombie entity performing the task
--- @param task table -- The task data table
--- @return boolean -- Always returns true to transition to WORKING state immediately
ZomboDesire_ZombHumanActions.Time.onStart = function(zombie, task)
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Time.onStart -> Action: %s, Anim: %s", tostring(task.action), tostring(task.anim))
    end
    return true
end

--- Called every frame while a Time task is in the WORKING state
--- @param zombie IsoZombie -- The zombie entity performing the task
--- @param task table -- The task data table
--- @return boolean -- Returns true if the animation is finished or mismatching, false otherwise
ZomboDesire_ZombHumanActions.Time.onWorking = function(zombie, task)
    if zombie:getBumpType() ~= task.anim then 
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Time.onWorking -> Animation mismatch or finished (BumpType: %s, expected: %s)", tostring(zombie:getBumpType()), tostring(task.anim))
        end
        return true 
    end
    return false
end

--- Called when a Time task is completed
--- @param zombie IsoZombie -- The zombie entity performing the task
--- @param task table -- The task data table
--- @return boolean -- Always returns true to indicate completion
ZomboDesire_ZombHumanActions.Time.onComplete = function(zombie, task)
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Time.onComplete -> Task finished for ID %d", zombie:getID())
    end
    return true
end

--- Global module for ZombHuman task management
ZomboDesire_ZombHumanTask = ZomboDesire_ZombHumanTask or {}

--- Adds a task to a ZombHuman's brain. If the task list exceeds 10 items, it is cleared first
--- @param zombie IsoZombie -- The zombie entity to add the task to
--- @param task table -- The task data table to add
function ZomboDesire_ZombHumanTask.AddTask(zombie, task)
    if not zombie then return end
    local brain = ZomboDesire_ZombHumanBrain.Get(zombie)
    if brain then
        if #brain.tasks > 9 then
            ZomboDesire.warningLog(MODULE_NAME, "AddTask -> Task list limit reached (10) for ID %d, clearing queue", zombie:getID())
            brain.tasks = {}
        end
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "AddTask -> Adding task '%s' to ID %d (Queue size: %d)", tostring(task.action), zombie:getID(), #brain.tasks + 1)
        end
        table.insert(brain.tasks, task)
    else
        ZomboDesire.errorLog(MODULE_NAME, "AddTask -> No brain found for zombie ID %d", zombie:getID())
    end
end

--- Retrieves the current (first) task from a ZombHuman's brain
--- @param zombie IsoZombie -- The zombie entity to get the task from
--- @return table|nil -- The current task data table or nil if no tasks exist
function ZomboDesire_ZombHumanTask.GetTask(zombie)
    local brain = ZomboDesire_ZombHumanBrain.Get(zombie)
    if brain and brain.tasks and #brain.tasks > 0 then
        return brain.tasks[1]
    end
    return nil
end

--- Removes the current (first) task from a ZombHuman's brain
--- @param zombie IsoZombie -- The zombie entity to remove the task from
function ZomboDesire_ZombHumanTask.RemoveTask(zombie)
    if not zombie then return end
    local brain = ZomboDesire_ZombHumanBrain.Get(zombie)
    if brain and brain.tasks and #brain.tasks > 0 then
        local task = brain.tasks[1]
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "RemoveTask -> Removing task '%s' from ID %d", tostring(task.action), zombie:getID())
        end
        table.remove(brain.tasks, 1)
    end
end

--- Clears all tasks from a ZombHuman's brain and handles necessary cleanup like stopping sounds
--- @param zombie IsoZombie -- The zombie entity to clear tasks for
function ZomboDesire_ZombHumanTask.ClearTasks(zombie)
    if not zombie then return end
    local brain = ZomboDesire_ZombHumanBrain.Get(zombie)
    if brain then
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "ClearTasks -> Clearing all tasks for ID %d", zombie:getID())
        end
        brain.tasks = {}
    end

    -- Stop any sound loop associated with tasks
    local emitter = zombie:getEmitter()
    -- We can add a list of sounds to stop if needed, similar to ZombHumanSound.SoundStopList
end

return ZomboDesire_ZombHumanTask
