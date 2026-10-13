--- File: ZomboDesire/42/media/lua/client/ZombHuman/ZomboDesire_ZombHumanUpdate.lua
--- Core update loop and transformation logic for ZombHuman
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_ZombHumanUpdate.lua loaded")

-- Module for managing ZombHuman transformation and update logic
ZomboDesire_ZombHumanUpdate = ZomboDesire_ZombHumanUpdate or {}

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local table = table

--- Optimized list of active ZombHumans to avoid looping through all zombies in OnZombieUpdate
--- @type table
local activeZombHumans = table.newarray()

--- Module name for logging
--- @type string
local MODULE_NAME = "ZombHumanUpdate"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboDesire.isDebug in ZomboDesire_Main.lua).
--- Calls with cheap/no arguments use ZomboDesire.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboDesire.isDebug(MODULE_NAME)
end

--- Transforms a standard zombie into a ZombHuman
--- Handles sound suppression, visual caching, and state variable synchronization
--- @param zombie IsoZombie -- The zombie character to transform
--- @param brain table -- The brain configuration to apply
function ZomboDesire_ZombHumanUpdate.ZombHumanize(zombie, brain)
    if dbg() then
        local zInfo = string.format("ID %d", zombie:getID())
        ZomboDesire.debugLog(MODULE_NAME, "ZombHumanize -> Starting transformation for zombie %s", zInfo)
    end

    -- Add to active list for optimized OnTick update (if not already present)
    local alreadyActive = false
    for i = 1, #activeZombHumans do
        if activeZombHumans[i] == zombie then
            alreadyActive = true
            break
        end
    end
    if not alreadyActive then
        table.insert(activeZombHumans, zombie)
    end

    -- Stop groaning sounds immediately (Sound Patch)
    local emitter = zombie:getEmitter()
    if emitter then
        emitter:stopAll()
    end

    -- Set the zombie voice prefix to "ZombHuman"
    -- This ensures silence (as no "ZombHuman" sounds exist yet) and prepares for future voices
    local desc = zombie:getDescriptor()
    if desc then
        desc:setVoicePrefix("ZombHuman")
    end

    -- Save original visuals before transformation (Visual Restorer)
    -- IMPORTANT: This cache is required by ZomboLust for stripping logic
    -- Do not remove even if Zombify's restoration is disabled
    local itemVisuals = zombie:getItemVisuals()
    if itemVisuals and itemVisuals:size() > 0 then
        if dbg() then
            local zInfo = string.format("ID %d", zombie:getID())
            ZomboDesire.debugLog(MODULE_NAME, "ZombHumanize -> Caching %d item visuals for %s", itemVisuals:size(), zInfo)
        end
        local cachedVisuals = {}
        for i = 0, itemVisuals:size() - 1 do
            local itemVisual = itemVisuals:get(i)
            if itemVisual then
                table.insert(cachedVisuals, itemVisual)
            end
        end
        zombie:getModData().zombHuman_cachedVisuals = cachedVisuals
    end

    -- Save body blood/dirt
    local hVisuals = zombie:getHumanVisual()
    if hVisuals and BloodBodyPartType and BloodBodyPartType.MAX then
        if dbg() then
            local zInfo = string.format("ID %d", zombie:getID())
            ZomboDesire.debugLog(MODULE_NAME, "ZombHumanize -> Caching blood/dirt levels for %s", zInfo)
        end
        local maxIndex = BloodBodyPartType.MAX:index()
        local savedBlood = {}
        local savedDirt = {}
        for i = 0, maxIndex - 1 do
            local part = BloodBodyPartType.FromIndex(i)
            savedBlood[i] = hVisuals:getBlood(part)
            savedDirt[i] = hVisuals:getDirt(part)
        end
        zombie:getModData().zombHuman_savedBlood = savedBlood
        zombie:getModData().zombHuman_savedDirt = savedDirt
    end

    -- Load brain
    ZomboDesire_ZombHumanBrain.Update(zombie, brain)

    -- Game engine variables for animations
    zombie:setNoTeeth(true)
    -- Sync variable with XML conditions
    zombie:setVariable("ZombHuman", true)

    -- Disable standard zombie behaviors
    zombie:setWalkType("Walk")
    zombie:setVariable("ZombieHitReaction", "Chainsaw")
    zombie:setVariable("NoLungeTarget", true)

    ---@diagnostic disable-next-line: param-type-mismatch
    zombie:setPrimaryHandItem(nil)
    ---@diagnostic disable-next-line: param-type-mismatch
    zombie:setSecondaryHandItem(nil)
    zombie:resetEquippedHandsModels()

    -- Ensure visuals are restored/maintained
    zombie:resetModelNextFrame()
    if dbg() then
        local zInfo = string.format("ID %d", zombie:getID())
        ZomboDesire.debugLog(MODULE_NAME, "ZombHumanize -> Transformation completed for %s", zInfo)
    end
end

--- Reverts a ZombHuman back into a standard zombie
--- Restores original visuals, blood/dirt levels, and removes the brain
--- @param zombie IsoZombie -- The character to zombify
function ZomboDesire_ZombHumanUpdate.Zombify(zombie)
    if dbg() then
        local zInfo = string.format("ID %d", zombie:getID())
        ZomboDesire.debugLog(MODULE_NAME, "Zombify -> Reverting ZombHuman %s back to normal zombie", zInfo)
    end

    -- Remove from active list
    for i = 1, #activeZombHumans do
        if activeZombHumans[i] == zombie then
            table.remove(activeZombHumans, i)
            if dbg() then
                local zInfo = string.format("ID %d", zombie:getID())
                ZomboDesire.debugLog(MODULE_NAME, "Zombify -> Removed zombie %s from active list", zInfo)
            end
            break
        end
    end

    zombie:setNoTeeth(false)
    zombie:setVariable("ZombHuman", false)
    zombie:setWalkType("2")
    ---@diagnostic disable-next-line: param-type-mismatch
    zombie:setPrimaryHandItem(nil)
    ---@diagnostic disable-next-line: param-type-mismatch
    zombie:setSecondaryHandItem(nil)
    zombie:resetEquippedHandsModels()

    -- No need to set the zombie as useless here; ZomboDesire_EscapeHandler.lua
    -- will force all nearby zombies to be useless to give the player time to escape.

    -- The <m_TimePc>0.900</m_TimePc> tag in ZomboLust and ZomboDesire's "End" XML files ensures
    -- the zombie returns to its idle state.
    -- The old <m_Time>End</m_Time> tag caused the same problem when trying to launch the EscapeAndInvisibility from the XML files.

    --[[
    -- Restore original visuals from cache
    -- NOTE: This block may be re-enabled for future "fully humanized" ZombHumans (NPCs)
    -- to allow them to dress back after an animation sequence.
    local cachedVisuals = zombie:getModData().zombHuman_cachedVisuals
    if cachedVisuals then
        ZomboDesire.debugLog(MODULE_NAME, "Zombify -> Restoring %d item visuals for %s", #cachedVisuals, zInfo)
        local itemVisuals = zombie:getItemVisuals()
        itemVisuals:clear()
        for _, visual in ipairs(cachedVisuals) do
            itemVisuals:add(visual)
        end
        zombie:getModData().zombHuman_cachedVisuals = nil
    end
    ]]

    -- Restore blood/dirt
    local savedBlood = zombie:getModData().zombHuman_savedBlood
    local savedDirt = zombie:getModData().zombHuman_savedDirt
    if savedBlood and savedDirt then
        if dbg() then
            local zInfo = string.format("ID %d", zombie:getID())
            ZomboDesire.debugLog(MODULE_NAME, "Zombify -> Restoring blood/dirt levels for %s", zInfo)
        end
        local hVisuals = zombie:getHumanVisual()
        local maxIndex = BloodBodyPartType.MAX:index()
        for i = 0, maxIndex - 1 do
            local part = BloodBodyPartType.FromIndex(i)
            hVisuals:setBlood(part, savedBlood[i] or 0)
            hVisuals:setDirt(part, savedDirt[i] or 0)
        end
        zombie:getModData().zombHuman_savedBlood = nil
        zombie:getModData().zombHuman_savedDirt = nil
    end

    -- Remove brain
    ZomboDesire_ZombHumanBrain.Remove(zombie)

    -- Restore zombie sounds after deZombHumanization
    if ZomboDesire_Cleanup and ZomboDesire_Cleanup.restoreZombieSounds then
        ZomboDesire_Cleanup.restoreZombieSounds(zombie)
    end

    zombie:resetModelNextFrame()
    if dbg() then
        local zInfo = string.format("ID %d", zombie:getID())
        ZomboDesire.debugLog(MODULE_NAME, "Zombify -> Reversion completed for %s", zInfo)
    end
end

--- Internal function to process the current task of a ZombHuman
--- Manages state transitions between NEW, WORKING, and COMPLETED
--- @param zombie IsoZombie -- The character performing the task
--- @param task table -- The task data structure
local function ProcessTask(zombie, task)
    if not task.action then return end
    if not task.state then task.state = "NEW" end

    if task.state == "NEW" then
        if not task.time then task.time = 1000 end

        if dbg() then
            local zInfo = string.format("ID %d", zombie:getID())
            ZomboDesire.debugLog(MODULE_NAME, "ProcessTask -> Initializing NEW task '%s' for %s", task.action, zInfo)
        end

        if task.anim then
            zombie:setBumpType(task.anim)
        end

        ---@type any
        local action = ZomboDesire_ZombHumanActions[task.action]
        if action and action.onStart then
            local done = action.onStart(zombie, task)
            if done then 
                if dbg() then
                    local zInfo = string.format("ID %d", zombie:getID())
                    ZomboDesire.debugLog(MODULE_NAME, "ProcessTask -> Task '%s' moved to WORKING state for %s", task.action, zInfo)
                end
                task.state = "WORKING" 
            end
        else
            if not action then
                local zInfo = string.format("ID %d", zombie:getID())
                ZomboDesire.warningLog(MODULE_NAME, "ProcessTask -> Action '%s' not found in ZombHumanActions for %s", task.action, zInfo)
            end
            task.state = "WORKING"
        end

    elseif task.state == "WORKING" then
        local decrement = 1 / ((getAverageFPS() + 0.5) * 0.01666667)
        task.time = task.time - decrement

        --[[
        -- Detailed tracing of the working state
        if task.action == "CustomAnim" then
            ZomboDesire.debugLog(MODULE_NAME, "DEBUG: ID %d WORKING '%s' - Time: %.2f - Bump: %s - Pos: %.2f,%.2f", 
                zombie:getID(), task.anim or "nil", task.time, tostring(zombie:getBumpType()), zombie:getX(), zombie:getY())
        end
        ]]

        ---@type any
        local action = ZomboDesire_ZombHumanActions[task.action]
        local done = false
        if action and action.onWorking then
            done = action.onWorking(zombie, task)
        end

        if done or task.time <= 0 then 
            if dbg() then
                local zInfo = string.format("ID %d", zombie:getID())
                ZomboDesire.debugLog(MODULE_NAME, "ProcessTask -> Task '%s' completed working phase for %s (done=%s, time=%.2f)", task.action, zInfo, tostring(done), task.time)
            end
            task.state = "COMPLETED"
        end

    elseif task.state == "COMPLETED" then
        ---@type any
        local action = ZomboDesire_ZombHumanActions[task.action]
        local done = true
        if action and action.onComplete then
            done = action.onComplete(zombie, task)
        end

        if done then 
            if dbg() then
                local zInfo = string.format("ID %d", zombie:getID())
                ZomboDesire.debugLog(MODULE_NAME, "ProcessTask -> Removing COMPLETED task '%s' for %s", task.action, zInfo)
            end
            ZomboDesire_ZombHumanTask.RemoveTask(zombie)
        end
    end
end

--- Main event handler for OnTick (Optimized)
--- Monitors state, processes tasks, and handles safety checks only for active ZombHumans
local function OnTickUpdate()
    if #activeZombHumans == 0 or isServer() then return end

    -- Cache player and coordinates once per tick for all ZombHumans
    local player = getSpecificPlayer(0)
    if not player or player:isDead() then return end

    local pX, pY = player:getX(), player:getY()

    -- Use numeric loop (faster than pairs/ipairs according to guides)
    -- Iterate backward so a dead/invalid entry can be table.remove()'d in place without
    -- disturbing the indices of entries not yet visited this tick.
    for i = #activeZombHumans, 1, -1 do
        local zombie = activeZombHumans[i]

        -- Guard against invalid zombie reference: a ZombHuman that dies in combat, by fire, etc. never calls Zombify(),
        -- so it must be purged here or it stays in this list (and gets checked every tick) for the rest of the game session.
        if not zombie or zombie:isDead() then
            if zombie then
                if dbg() then
                    ZomboDesire.debugLog(MODULE_NAME, "OnTickUpdate -> ZombHuman %d died without reverting, purging from active list", zombie:getID())
                end
                ZomboDesire_ZombHumanBrain.Remove(zombie)
            end
            table.remove(activeZombHumans, i)
        else
            local brain = ZomboDesire_ZombHumanBrain.Get(zombie)

            -- Handle ZombHuman state transitions and guard against missing brain
            if not brain and zombie:getVariableBoolean("ZombHuman") then
                ZomboDesire_ZombHumanUpdate.Zombify(zombie)
            elseif brain then
                if not zombie:getVariableBoolean("ZombHuman") then
                    ZomboDesire_ZombHumanUpdate.ZombHumanize(zombie, brain)
                end

                -- Safety timeout / Distance check using cached player coords
                local zX, zY = zombie:getX(), zombie:getY()
                local dist = ZomboDesire_ZombHumanUtils.DistTo(zX, zY, pX, pY)

                -- If too far, zombify to prevent ghosting
                if dist > 20 then
                    if dbg() then
                        ZomboDesire.debugLog(MODULE_NAME, "OnTickUpdate -> ZombHuman %d too far (%.2f), zombifying", zombie:getID(), dist)
                    end
                    ZomboDesire_ZombHumanUpdate.Zombify(zombie)
                else
                    -- Update speech cooldown
                    if brain.speech and brain.speech > 0 then
                        brain.speech = brain.speech - 0.01
                        if brain.speech < 0 then brain.speech = 0 end
                    end

                    -- Process tasks
                    local task = ZomboDesire_ZombHumanTask.GetTask(zombie)
                    if task then
                        ProcessTask(zombie, task)
                    end
                end
            end
        end
    end
end

Events.OnTick.Add(OnTickUpdate)

return ZomboDesire_ZombHumanUpdate
