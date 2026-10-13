--- File: ZomboDesire/42/media/lua/client/ZomboDesire_InventoryHooks.lua
--- Dynamic hooks for inventory interactions during animations
--- Prevents drag-and-drop item transfers and food/drink/pill consumption during multi-stage animations
--- Hook is ONLY active during multi-stage animations for optimal performance
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_InventoryHooks.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Main" -- Main module with debug functions
require "TimedActions/ISTimedActionQueue" -- TimedActionQueue system

--- Module name for logging
--- @type string
local MODULE_NAME = "InventoryHooks"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboDesire.isDebug in ZomboDesire_Main.lua).
--- Calls with cheap/no arguments use ZomboDesire.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboDesire.isDebug(MODULE_NAME)
end

-- ========================================
-- Dynamic Hook System for Inventory Block
-- ========================================

--- Store original ISTimedActionQueue.add function (saved once at load time)
--- @type function
local original_ISTimedActionQueue_add = ISTimedActionQueue.add

--- Flag to track if hook is currently active
--- @type boolean
local isHookActive = false

--- Actions to block during multi-stage animations (cached at top-level for performance)
local blockedActions = {
    ["ISInventoryTransferAction"] = true,
    ["ISEatFoodAction"] = true,
    ["ISDrinkFluidAction"] = true,
    ["ISTakePillAction"] = true
}

--- Hooked version of ISTimedActionQueue.add
--- Blocks inventory transfers and food/drink/pill consumption during multi-stage animations
--- @param action ISBaseTimedAction -- The timed action to add to the queue
--- @return any -- Result from original function, or nil if blocked
local function hooked_ISTimedActionQueue_add(action)
    -- Check if this is one of the blocked actions
    if blockedActions[action.Type] then
        -- Get the character performing this action
        local character = action.character

        -- Get the action queue for this character
        local queue = ISTimedActionQueue.queues[character]

        if queue and queue.current then
            ---@type table|nil Current action from queue (custom ISZomboDesireAnimationAction with stageConfig field)
            local currentAction = queue.current

            -- Check if current action is one of our multi-stage animations
            -- Multi-stage animations have both Type = "ISZomboDesireAnimationAction" and stageConfig.nextStageIndex
            -- Note: stageConfig is a custom field added by our ISZomboDesireAnimationAction class
            if currentAction and 
               currentAction.Type == "ISZomboDesireAnimationAction" and 
               currentAction.stageConfig and 
               currentAction.stageConfig.nextStageIndex then

                if dbg() then
                    ZomboDesire.debugLog(MODULE_NAME, "BLOCKED %s during multi-stage animation for character %s",
                        tostring(action.Type), tostring(character:getFullName()))
                end

                -- Do not add the action to the queue
                return nil
            end
        end
    end

    -- Call the original function for all other cases
    return original_ISTimedActionQueue_add(action)
end

-- ==================================
-- Public API: Enable/Disable Hook
-- ==================================

--- Enables the inventory blocking hook
--- Should be called when a multi-stage animation starts
function ZomboDesire.enableInventoryBlock()
    if isHookActive then
        ZomboDesire.warningLog(MODULE_NAME, "Inventory block already active, skipping")
        return
    end

    -- Replace ISTimedActionQueue.add with our hooked version
    ISTimedActionQueue.add = hooked_ISTimedActionQueue_add
    isHookActive = true

    ZomboDesire.debugLog(MODULE_NAME, "Inventory block ENABLED - drag-and-drop and consumption actions now blocked")
end

--- Disables the inventory blocking hook
--- Should be called when a multi-stage animation ends
function ZomboDesire.disableInventoryBlock()
    if not isHookActive then
        ZomboDesire.debugLog(MODULE_NAME, "Inventory block already inactive, skipping")
        return
    end

    -- Restore original ISTimedActionQueue.add, but only if it's still our hook that is installed.
    -- If another mod re-hooked ISTimedActionQueue.add on top of ours while the block was active,
    -- blindly restoring here would silently strip that mod's hook out of the chain.
    if ISTimedActionQueue.add == hooked_ISTimedActionQueue_add then
        ISTimedActionQueue.add = original_ISTimedActionQueue_add
    else
        ZomboDesire.warningLog(MODULE_NAME, "ISTimedActionQueue.add was replaced by another mod while our hook was active, leaving it in place to avoid breaking that mod")
    end
    isHookActive = false

    ZomboDesire.debugLog(MODULE_NAME, "Inventory block DISABLED - drag-and-drop and consumption actions now allowed")
end

--- Returns current hook state (for debugging)
--- @return boolean True if hook is active, false otherwise
function ZomboDesire.isInventoryBlockActive()
    return isHookActive
end

ZomboDesire.debugLog(MODULE_NAME, "Dynamic inventory hook system initialized (hook currently INACTIVE)")
