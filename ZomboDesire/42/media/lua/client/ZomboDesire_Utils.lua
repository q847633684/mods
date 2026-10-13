--- File: ZomboDesire/42/media/lua/client/ZomboDesire_Utils.lua
--- Utilities for zombies (knockback, repel, push back)
--- Provides functions for pushing zombies away from a location with smooth interpolation
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_Utils.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Main" -- Main module with debug functions

--- Module name for logging
--- @type string
local MODULE_NAME = "Utils"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboDesire.isDebug in ZomboDesire_Main.lua).
--- Calls with cheap/no arguments use ZomboDesire.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboDesire.isDebug(MODULE_NAME)
end

--- Initialization of namespace in case of Main failure
--- @class (partial) ZomboDesire_Utils
ZomboDesire_Utils = ZomboDesire_Utils or {}

---@class KnockbackTask
---@field z IsoZombie The zombie to push back
---@field startX number Original X position
---@field startY number Original Y position
---@field targetX number Target X position
---@field targetY number Target Y position
---@field ux number Unit X vector
---@field uy number Unit Y vector
---@field speed number Movement speed
---@field step number Current interpolation step
---@field totalSteps number Total steps for interpolation

--- Internal list for knockback tasks
---@type KnockbackTask[]
ZomboDesire_Utils.knockbackTasks = {}
ZomboDesire_Utils.knockbackInitialized = false

--- Constants
--- @type number
local KNOCKBACK_STEPS = 10 -- number of interpolation steps
--- @type number
local MAX_KNOCKBACK_TASKS = 100 -- maximum number of concurrent knockback tasks

-- ==================
-- Utility functions
-- ==================

--- Clean up knockback tasks and remove the event listener
--- Resets the state of the knockback system
function ZomboDesire_Utils.cleanupKnockbacks()
    --[[
    if ZomboDesire.Debug.enabled and ZomboDesire.Debug.modules[MODULE_NAME] then
        ZomboDesire.debugLog(MODULE_NAME, "cleanupKnockbacks() called - Initial state -> initialized = %s, taskCount = %d", tostring(ZomboDesire_Utils.knockbackInitialized), #ZomboDesire_Utils.knockbackTasks)
    end
    ]]

    if ZomboDesire_Utils.knockbackInitialized then
        Events.OnTick.Remove(ZomboDesire_Utils.processKnockbacks)
        ZomboDesire_Utils.knockbackTasks = {}
        ZomboDesire_Utils.knockbackInitialized = false
        --[[
        if ZomboDesire.Debug.enabled and ZomboDesire.Debug.modules[MODULE_NAME] then
            ZomboDesire.debugLog(MODULE_NAME, "Knockback system cleaned up - Final state -> initialized = %s, taskCount = %d", tostring(ZomboDesire_Utils.knockbackInitialized), #ZomboDesire_Utils.knockbackTasks)
        end
        ]]
    else
        ZomboDesire.debugLog(MODULE_NAME, "Knockback system was not initialized, nothing to clean up")
    end
end

--- Retrieves the current state of the knockback system
--- @return table -- A table containing the initialization state and number of tasks
local function getKnockbackStatus()
    local status = {
        initialized = ZomboDesire_Utils.knockbackInitialized,
        taskCount = #ZomboDesire_Utils.knockbackTasks
    }
    --[[
    if ZomboDesire.Debug.enabled and ZomboDesire.Debug.modules[MODULE_NAME] then
        ZomboDesire.debugLog(MODULE_NAME, "Knockback status -> initialized = %s, taskCount = %d", 
            tostring(status.initialized), status.taskCount)
    end
    ]]
    return status
end

--- Checks if a square is free of obstacles that would block a zombie
--- Uses the game's official methods to check if a square is walkable
--- @param square IsoGridSquare -- The square to check
--- @return boolean -- True if the square is free, false otherwise
function ZomboDesire_Utils.isSquareFreeForZombie(square)
    if not square then return false end

    ---@diagnostic disable: undefined-field
    -- Check if the square is solid or has solid transparent objects
    if square:has(IsoFlagType.solid) then
        return false
    end

    -- Check if the square has solid transparent objects (windows, fences, etc.)
    if square:has(IsoFlagType.solidtrans) then
        return false
    end

    -- Check if the square has a floor (zombies can't stand in the air)
    if not square:has(IsoFlagType.solidfloor) then
        return false
    end

    -- Check for objects that would block movement
    local objects = square:getObjects()
    if objects and objects:size() > 0 then
        for i = 0, objects:size() - 1 do
            local obj = objects:get(i)
            if obj then
                -- Check if the object is a wall, door, or other blocking object
                if obj:getType() == IsoObjectType.wall or 
                   obj:getType() == IsoObjectType.doorFrN or 
                   obj:getType() == IsoObjectType.doorFrW or 
                   obj:getType() == IsoObjectType.doorN or 
                   obj:getType() == IsoObjectType.doorW or 
                   obj:getType() == IsoObjectType.tree then
                    return false
                end

                -- Check if the object has properties that would block movement
                local props = obj:getProperties()
                if props then
                    if props:has(IsoFlagType.collideN) or props:has(IsoFlagType.collideW) then
                        return false
                    end
                end
            end
        end
    end
    ---@diagnostic enable: undefined-field

    return true
end

--- Finds a free adjacent square for a zombie
--- Uses a simple algorithm to find a valid adjacent square
--- @param x number -- X coordinate of the original square
--- @param y number -- Y coordinate of the original square
--- @param z number -- Z coordinate of the original square
--- @return IsoGridSquare|nil -- A free adjacent square or nil if none found
function ZomboDesire_Utils.findFreeAdjacentSquare(x, y, z)
    local cell = getCell()
    if not cell then return nil end

    -- Check the 8 adjacent squares in a random order
    ---@type table[]
    local adjacentOffsets = {
        {x=0, y=-1}, {x=1, y=-1}, {x=1, y=0}, {x=1, y=1},
        {x=0, y=1}, {x=-1, y=1}, {x=-1, y=0}, {x=-1, y=-1}
    }

    -- Shuffle the offsets for randomness
    for i = #adjacentOffsets, 2, -1 do
        local j = ZombRand(i) + 1
        ---@diagnostic disable-next-line: inject-field
        adjacentOffsets[i], adjacentOffsets[j] = adjacentOffsets[j], adjacentOffsets[i]
    end

    -- Check each adjacent square
    for i = 1, #adjacentOffsets do
        local offset = adjacentOffsets[i]
        local adjacentSquare = cell:getGridSquare(
            x + offset.x,
            y + offset.y,
            z
        )

        if adjacentSquare and ZomboDesire_Utils.isSquareFreeForZombie(adjacentSquare) then
            return adjacentSquare
        end
    end

    -- If no adjacent square is free, try squares that are 2 tiles away
    ---@type table[]
    local extendedOffsets = {
        {x=0, y=-2}, {x=1, y=-2}, {x=2, y=-2}, {x=2, y=-1}, {x=2, y=0}, 
        {x=2, y=1}, {x=2, y=2}, {x=1, y=2}, {x=0, y=2}, {x=-1, y=2},
        {x=-2, y=2}, {x=-2, y=1}, {x=-2, y=0}, {x=-2, y=-1}, {x=-2, y=-2},
        {x=-1, y=-2}
    }

    -- Shuffle the extended offsets
    for i = #extendedOffsets, 2, -1 do
        local j = ZombRand(i) + 1
        ---@diagnostic disable-next-line: inject-field
        extendedOffsets[i], extendedOffsets[j] = extendedOffsets[j], extendedOffsets[i]
    end

    -- Check each extended square
    for i = 1, #extendedOffsets do
        local offset = extendedOffsets[i]
        local extendedSquare = cell:getGridSquare(
            x + offset.x,
            y + offset.y,
            z
        )

        if extendedSquare and ZomboDesire_Utils.isSquareFreeForZombie(extendedSquare) then
            return extendedSquare
        end
    end

    -- No free square found
    return nil
end

--- Advances the In Game Time (IGT) by a random amount of minutes
--- This simulates the time elapsed during an animation stage
--- @param minMinutes number -- Minimum minutes to advance
--- @param maxMinutes number -- Maximum minutes to advance
function ZomboDesire_Utils.advanceGameTime(minMinutes, maxMinutes)
    local gt = getGameTime()
    if not gt then return end

    local minutes = ZombRand(minMinutes, maxMinutes + 1)
    local currentTime = gt:getTimeOfDay()
    local newTime = currentTime + (minutes / 60)

    ZomboDesire.debugLog(MODULE_NAME, "Simulating time elapsed: +%d minutes (%.2f -> %.2f)", minutes, currentTime, newTime)

    gt:setTimeOfDay(newTime)
end

-- ==================
-- Deferred actions
-- ==================

--- Runs a function after a delay measured in game ticks (Events.OnTick), instead of a callback-based timer.
--- Used whenever code needs to wait ~N ticks before continuing (e.g. delayed animation feedback, a status effect kicking in) without blocking.
--- @param delayTicks number -- Number of ticks to wait before executing the action
--- @param actionFunction function -- The function to execute after the delay
--- @return function -- The tick handler, in case the caller needs to cancel it via Events.OnTick.Remove
function ZomboDesire_Utils.createDelayedAction(delayTicks, actionFunction)
    local currentTick = 0

    local function tickHandler()
        currentTick = currentTick + 1
        if currentTick >= delayTicks then
            -- Important: Delete the event BEFORE doing anything else
            Events.OnTick.Remove(tickHandler)
            -- Execute the action
            actionFunction()
        end
    end

    Events.OnTick.Add(tickHandler)
    return tickHandler -- Return the handler in case we need to cancel it
end

-- =========================
-- Player feedback messages
-- =========================

--- Informs the player via a chat message that the animation/scene was just interrupted
--- Used to avoid the player mistaking a voluntary interruption (damage, distance, etc.) for a bug
--- @param player IsoPlayer -- Player to notify
function ZomboDesire_Utils.sayAnimationInterrupted(player)
    if not player then return end

    local msg = getText("IGUI_ZomboDesire_Animation_Interrupted")
    player:addLineChatElement(msg, 1.0, 1.0, 1.0)

    ZomboDesire.debugLog(MODULE_NAME, "Notified player of animation interruption")
end

-- ===================================
-- Damage detection during animations
-- ===================================

--- Creates a self-contained damage-detection system for interrupting an animation action when the player takes damage
--- (either via OnPlayerGetDamage or OnWeaponHitCharacter).
--- Factored out because ZomboDesire_AnimationHandler and ZomboDesire_AnimationHandlerForSolo both need the exact same interrupt logic,
--- differing only in which "current animation action" field they track -> the getter/clearer closures carry that difference.
--- @param moduleName string -- Module name to use for debug logs (keeps per-module debug filtering working)
--- @param getCurrentAction fun(): table|nil -- Returns the caller's currently active animation action
--- @param clearCurrentAction fun() -- Clears the caller's reference to the currently active animation action
--- @return function registerDamageDetection -- Call in start() to begin watching for damage
--- @return function unregisterDamageDetection -- Call in stop()/perform() to stop watching
function ZomboDesire_Utils.createDamageDetection(moduleName, getCurrentAction, clearCurrentAction)
    --- Handles damage detection during animation playback
    --- Interrupts animation if player takes damage
    --- @param player IsoPlayer -- The player who took damage
    local function onPlayerDamageReceived(player)
        -- Only check if we have an active animation
        local currentAction = getCurrentAction()
        if not currentAction then return end

        -- Verify it's the player from our animation
        if player ~= currentAction.character then return end

        -- Only interrupt for players (not zombies/zombHumans)
        if player:isZombie() or player:getModData().isZombHuman then return end

        ZomboDesire.debugLog(moduleName, "ATTENTION - Player took damage during animation - interrupting animation")

        ZomboDesire_Utils.sayAnimationInterrupted(player)

        -- Force stop the animation immediately if the method exists
        if currentAction and currentAction.forceStop then
            currentAction:forceStop()
        end

        -- Clear the reference
        clearCurrentAction()
    end

    --- Alternative damage detection using weapon hit events
    --- @param attacker IsoGameCharacter -- The character who attacked (unused but kept for API compatibility)
    --- @param target IsoGameCharacter -- The character who was hit
    --- @param weapon HandWeapon -- The weapon used (unused but kept for API compatibility)
    --- @param damage number -- The damage dealt
    local function onWeaponHitCharacter(attacker, target, weapon, damage)
        -- Only interested in hits on players
        if not target or target:isZombie() or target:getModData().isZombHuman then return end

        -- Check if target is in an active animation
        local currentAction = getCurrentAction()
        if not currentAction or target ~= currentAction.character then return end

        -- Only interrupt if damage was actually dealt
        if not (damage and damage > 0 and currentAction and currentAction.forceStop) then
            return
        end

        ZomboDesire.debugLog(moduleName, "ATTENTION - Player hit by weapon during animation (damage %.1f) - interrupting animation", damage)

        ZomboDesire_Utils.sayAnimationInterrupted(target)

        -- Force stop the animation
        currentAction:forceStop()

        -- Clear the reference
        clearCurrentAction()
    end

    --- Registers damage detection event handlers
    local function registerDamageDetection()
        -- Primary damage detection: when player receives any damage
        Events.OnPlayerGetDamage.Add(onPlayerDamageReceived)

        -- Secondary detection: weapon hits (catches more specific cases)
        Events.OnWeaponHitCharacter.Add(onWeaponHitCharacter)

        ZomboDesire.debugLog(moduleName, "Damage detection event handlers registered (player and weapon hits)")
    end

    --- Unregisters damage detection event handlers
    local function unregisterDamageDetection()
        Events.OnPlayerGetDamage.Remove(onPlayerDamageReceived)
        Events.OnWeaponHitCharacter.Remove(onWeaponHitCharacter)

        ZomboDesire.debugLog(moduleName, "Damage detection event handlers unregistered (player and weapon hits)")
    end

    return registerDamageDetection, unregisterDamageDetection
end

-- ============================
-- Repel and push back zombies
-- ============================

--- Internal tick handler for processing knockback interpolation
--- Processes a limited number of tasks per tick to maintain performance
--- @param delta number -- Time since last tick (unused but kept for API compatibility)
function ZomboDesire_Utils.processKnockbacks(delta)
    -- Process a maximum number of tasks per tick to avoid performance issues
    local maxTasksPerTick = 20
    local tasksProcessed = 0

    for i = #ZomboDesire_Utils.knockbackTasks, 1, -1 do
        -- Limit the number of tasks processed per tick
        tasksProcessed = tasksProcessed + 1
        if tasksProcessed > maxTasksPerTick then
            break
        end

        -- Simulate "continue" with repeat ... until true
        repeat
            ---@type any
            local task = ZomboDesire_Utils.knockbackTasks[i]

            -- If task or zombie is invalid, remove and continue
            if not task or not task.z or not task.z:isAlive() then
                table.remove(ZomboDesire_Utils.knockbackTasks, i)
                break
            end

            ---@type any
            local z = task.z

            -- increment step
            task.step = task.step + 1
            local t = task.step / task.totalSteps
            -- linear interpolation
            local newX = task.startX + (task.targetX - task.startX) * t
            local newY = task.startY + (task.targetY - task.startY) * t
            z:setX(newX)
            z:setY(newY)

            -- apply velocity for force effect
            local canSetSpeed = z.setXSpeed and z.setYSpeed
            if canSetSpeed then
                z:setXSpeed(task.ux * task.speed)
                z:setYSpeed(task.uy * task.speed)
            end

            -- Check if task is finished
            if task.step < task.totalSteps then
                break -- continue to next task
            end

            -- Task is finished: reset speed
            if canSetSpeed then
                z:setXSpeed(0)
                z:setYSpeed(0)
            end

            -- Check if the final position is free of obstacles
            local finalX, finalY = math.floor(newX), math.floor(newY)
            local finalSquare = getCell():getGridSquare(finalX, finalY, z:getZ())

            if finalSquare and not ZomboDesire_Utils.isSquareFreeForZombie(finalSquare) then
                -- The final position has obstacles, find a free adjacent square
                ZomboDesire.debugLog(MODULE_NAME, "Zombie pushed to occupied square at (%d, %d), finding alternative", finalX, finalY)
                local freeSquare = ZomboDesire_Utils.findFreeAdjacentSquare(finalX, finalY, z:getZ())

                if freeSquare then
                    -- Move the zombie to the free square
                    z:setX(freeSquare:getX())
                    z:setY(freeSquare:getY())
                    if dbg() then
                        ZomboDesire.debugLog(MODULE_NAME, "Moved zombie to free adjacent square at (%d, %d)",
                            freeSquare:getX(), freeSquare:getY())
                    end
                else
                    ZomboDesire.warningLog(MODULE_NAME, "No free adjacent square found for zombie at (%d, %d)", finalX, finalY)
                end
            end

            table.remove(ZomboDesire_Utils.knockbackTasks, i)
        until true
    end

    -- If all tasks are completed, we can remove the event listener
    if #ZomboDesire_Utils.knockbackTasks == 0 then
        ZomboDesire_Utils.cleanupKnockbacks()
    end
end

--- Finds zombies within a radius and creates knockback tasks for them
--- @param zlist table -- The list of zombies to check
--- @param cx number -- X coordinate of center point
--- @param cy number -- Y coordinate of center point
--- @param radius number -- Push distance within which zombies will be moved
--- @return table -- A table of zombies found within the radius
local function findZombiesInRadius(zlist, cx, cy, radius)
    local zombiesInRadius = {}
    local radiusSq = radius * radius
    for i = 0, zlist:size() - 1 do
        local z = zlist:get(i)
        if z and z:isAlive() then
            local zx, zy = z:getX(), z:getY()
            local dx, dy = zx - cx, zy - cy
            local distSq = dx * dx + dy * dy
            if distSq > 0 and distSq <= radiusSq then
                local dist = distSq ^ 0.5
                table.insert(zombiesInRadius, {zombie = z, distance = dist, x = zx, y = zy})
            end
        end
    end

    -- Sort zombies by distance (closest first)
    table.sort(zombiesInRadius, function(a, b) return a.distance < b.distance end)
    return zombiesInRadius
end

--- Makes a zombie play the Stagger Back/Knocked Down animation randomly
--- @param zombie IsoZombie -- The zombie that has to play the animation
--- @return boolean -- True if successful, false otherwise
function ZomboDesire_Utils.triggerZombieFallAnimation(zombie)
    if not zombie or not zombie:isAlive() then
        return false
    end

    -- Randomly choose between knocked down and stagger back animations
    local useKnockedDown = (ZombRand(2) == 0) -- 50% chance for each animation

    -- Make the zombie useless and clear its target to stop groaning and following
    -- Track it in the global table only if it wasn't already useless
    if not zombie:isUseless() then
        zombie:setUseless(true)
        if ZomboDesire.neutralizedZombies then
            ZomboDesire.neutralizedZombies[zombie] = true
        end
    end
    ---@diagnostic disable-next-line: param-type-mismatch
    zombie:setTarget(nil)
    zombie:setTargetSeenTime(0)

    if useKnockedDown then
        zombie:setKnockedDown(true)
        ZomboDesire.debugLog(MODULE_NAME, "Used setKnockedDown and setUseless on zombie")
    else
        zombie:setStaggerBack(true)
        ZomboDesire.debugLog(MODULE_NAME, "Used setStaggerBack and setUseless on zombie")
    end

    return true
end

--- Creates knockback tasks for zombies
--- @param zombiesInRadius table -- Table of zombies to create tasks for
--- @param availableSlots number -- Maximum number of tasks to create
--- @param cx number -- X coordinate of center point
--- @param cy number -- Y coordinate of center point
--- @param radius number -- Push distance within which zombies will be moved
--- @return number -- Number of tasks created
local function createKnockbackTasks(zombiesInRadius, availableSlots, cx, cy, radius)
    local tasksCreated = 0
    for i = 1, math.min(#zombiesInRadius, availableSlots) do
        local zombieData = zombiesInRadius[i]
        local z = zombieData.zombie

        -- Skip if this zombie is already being pushed
        local alreadyPushed = false
        for j = 1, #ZomboDesire_Utils.knockbackTasks do
            if ZomboDesire_Utils.knockbackTasks[j].z == z then
                alreadyPushed = true
                break
            end
        end

        if not alreadyPushed then
            local zx, zy = zombieData.x, zombieData.y
            local dx, dy = zx - cx, zy - cy
            local dist = zombieData.distance

            -- Knock down the zombie
            ZomboDesire_Utils.triggerZombieFallAnimation(z)

            local ux, uy = dx / dist, dy / dist
            -- compute target further out for visual clarity
            local targetX = cx + ux * (radius * 1.5)
            local targetY = cy + uy * (radius * 1.5)
            -- create task
            local task = {
                z = z,
                startX = zx,
                startY = zy,
                targetX = targetX,
                targetY = targetY,
                ux = ux,
                uy = uy,
                speed = radius * 2, -- force magnitude
                step = 0,
                totalSteps = KNOCKBACK_STEPS
            }
            table.insert(ZomboDesire_Utils.knockbackTasks, task)
            tasksCreated = tasksCreated + 1
            ZomboDesire.debugLog(MODULE_NAME, "Scheduled knockback for zombie at (%.2f, %.2f), distance = %.2f", zx, zy, dist)
        end
    end
    return tasksCreated
end

--- Push away nearby zombies for clear animation view with smooth interpolation and force
--- @param cx number -- X coordinate of center point
--- @param cy number -- Y coordinate of center point
--- @param cz number -- Z coordinate of center point (unused but kept for API consistency)
--- @param radius number -- Push distance within which zombies will be moved
function ZomboDesire_Utils.pushNearbyZombies(cx, cy, cz, radius)
    local cell = getCell()
    if not cell then ZomboDesire.errorLog(MODULE_NAME, "getCell() returned nil") return end
    local zlist = cell:getZombieList()
    if not zlist then ZomboDesire.errorLog(MODULE_NAME, "getZombieList() returned nil") return end

    -- Log the initial state
    --[[
    if ZomboDesire.Debug.enabled and ZomboDesire.Debug.modules[MODULE_NAME] then
        ZomboDesire.debugLog(MODULE_NAME, "pushNearbyZombies called - Initial knockbackInitialized state -> %s", tostring(ZomboDesire_Utils.knockbackInitialized))
    end
    ]]

    -- Initialize tick handler once
    if not ZomboDesire_Utils.knockbackInitialized then
        ZomboDesire_Utils.knockbackInitialized = true
        Events.OnTick.Add(ZomboDesire_Utils.processKnockbacks)
        --[[
        if ZomboDesire.Debug.enabled and ZomboDesire.Debug.modules[MODULE_NAME] then
            ZomboDesire.debugLog(MODULE_NAME, "Knockback system initialized - New state -> initialized = %s", tostring(ZomboDesire_Utils.knockbackInitialized))
            getKnockbackStatus()
        end
        ]]
    else
        ZomboDesire.debugLog(MODULE_NAME, "Knockback system was already initialized")
    end

    -- Check current task count
    local currentTaskCount = #ZomboDesire_Utils.knockbackTasks
    local availableSlots = MAX_KNOCKBACK_TASKS - currentTaskCount

    if availableSlots <= 0 then
        ZomboDesire.warningLog(MODULE_NAME, "Maximum knockback tasks reached (%d). No new tasks will be created.", MAX_KNOCKBACK_TASKS)
        return
    end

    -- Find zombies within radius
    local zombiesInRadius = findZombiesInRadius(zlist, cx, cy, radius)

    -- Create knockback tasks
    local tasksCreated = createKnockbackTasks(zombiesInRadius, availableSlots, cx, cy, radius)

    --[[
    if ZomboDesire.Debug.enabled and ZomboDesire.Debug.modules[MODULE_NAME] then
        ZomboDesire.debugLog(MODULE_NAME, "Created %d knockback tasks out of %d zombies in radius", tasksCreated, #zombiesInRadius)
        ZomboDesire.debugLog(MODULE_NAME, "pushNearbyZombies completed - Final state -> initialized = %s, taskCount = %d", tostring(ZomboDesire_Utils.knockbackInitialized), #ZomboDesire_Utils.knockbackTasks)
    end
    ]]
end

-- ===========================
-- Side determination utility
-- ===========================

--- Determines which side of an object the player is on
--- @param player IsoPlayer -- The player
--- @param objectSquare IsoGridSquare -- The object square
--- @param objectDir IsoDirections -- The direction of the object
--- @return string -- The side of the object where the player is located ("Front", "Back")
function ZomboDesire_Utils.determinePlayerSideOfObject(player, objectSquare, objectDir)
    -- Get player and object coordinates
    local playerX, playerY = player:getX(), player:getY()
    local objectX, objectY = objectSquare:getX(), objectSquare:getY()

    -- Calculate position differences
    local deltaX = playerX - objectX
    local deltaY = playerY - objectY

    -- Determine the side based on the direction of the object using early returns
    if objectDir == IsoDirections.N then return deltaY < 0 and "Front" or "Back" end -- Object facing North. Player North of the object (in front). Player South of the object (behind)
    if objectDir == IsoDirections.S then return deltaY > 0 and "Front" or "Back" end -- Object facing South. Player South of the object (in front). Player North of the object (behind)
    if objectDir == IsoDirections.E then return deltaX > 0 and "Front" or "Back" end -- Object facing East. Player East of the object (in front). Player West of the object (behind)
    if objectDir == IsoDirections.W then return deltaX < 0 and "Front" or "Back" end -- Object facing West. Player West of the object (in front). Player East of the object (behind)

    -- If the direction is not standard (like NE, NW, SE, SW)
    return "Unknown"
end

-- ============================
-- Player controls management
-- ============================

--- Disables player controls to prevent movement and actions during animations
--- @param player IsoPlayer -- Player whose controls will be disabled
--- @return boolean -- true if controls were successfully disabled
function ZomboDesire_Utils.disablePlayerControls(player)
    if not player then
        ZomboDesire.errorLog(MODULE_NAME, "Unable to disable controls - invalid player")
        return false
    end

    -- Block movement and directional inputs
    player:setBlockMovement(true)
    player:setIgnoreInputsForDirection(true)

    -- Disable contextual interactions (doors, items, etc.)
    player:setIgnoreContextKey(true)

    -- Disable combat actions
    player:setIgnoreAimingInput(true)
    player:setBannedAttacking(true)

    -- Disable running and sprinting
    player:setAllowRun(false)
    player:setAllowSprint(false)

    ZomboDesire.debugLog(MODULE_NAME, "Player controls disabled")

    return true
end

--- Re-enables player controls after animations are complete
--- @param player IsoPlayer -- Player whose controls will be re-enabled
--- @return boolean -- true if controls were successfully re-enabled
function ZomboDesire_Utils.enablePlayerControls(player)
    if not player then
        ZomboDesire.errorLog(MODULE_NAME, "Unable to enable controls - invalid player")
        return false
    end

    -- Re-enable movement and directional inputs
    player:setBlockMovement(false)
    player:setIgnoreInputsForDirection(false)

    -- Re-enable contextual interactions (doors, items, etc.)
    player:setIgnoreContextKey(false)

    -- Re-enable combat actions
    player:setIgnoreAimingInput(false)
    player:setBannedAttacking(false)

    -- Re-enable running and sprinting
    player:setAllowRun(true)
    player:setAllowSprint(true)

    ZomboDesire.debugLog(MODULE_NAME, "Player controls re-enabled")

    return true
end

-- ============================
-- Player equipment management
-- ============================

--- Unequips both hand items so they don't clip through the character model during
--- solo animations. Unlike ZomboDesire_Staging.handlePlayerItems (used for two-actor
--- scenes), this has no difficulty logic: items simply go back to the inventory.
--- @param player IsoPlayer -- Player whose hand items will be unequipped
function ZomboDesire_Utils.unequipHandItems(player)
    if not player then return end

    local primary = player:getPrimaryHandItem()
    local secondary = player:getSecondaryHandItem()

    if not primary and not secondary then return end

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Unequipping hand items before solo animation (primary = %s, secondary = %s)",
            tostring(primary and primary:getType()), tostring(secondary and secondary:getType()))
    end

    -- Items are already part of the player's inventory; unequipping just clears the hands
    ---@diagnostic disable-next-line: param-type-mismatch
    player:setPrimaryHandItem(nil)
    ---@diagnostic disable-next-line: param-type-mismatch
    player:setSecondaryHandItem(nil)

    -- Force inventory UI refresh and sync
    if player:getInventory() then
        player:getInventory():setDrawDirty(true)
    end

    -- This global call updates the inventory pane if it's open
    ---@diagnostic disable-next-line: undefined-global
    if ISInventoryPage and ISInventoryPage.dirtyUI then
        ---@diagnostic disable-next-line: undefined-global
        ISInventoryPage.dirtyUI()
    end
end

return ZomboDesire_Utils
