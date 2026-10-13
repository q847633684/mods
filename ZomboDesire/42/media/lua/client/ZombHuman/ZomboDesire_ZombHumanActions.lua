--- File: ZomboDesire/42/media/lua/client/ZombHuman/ZomboDesire_ZombHumanActions.lua
--- Actions for ZombHuman task system
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_ZombHumanActions.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Main"
require "ZomboDesire_Utils"

--- Table of all available actions for the ZombHuman task system
ZomboDesire_ZombHumanActions = ZomboDesire_ZombHumanActions or {}

--- Module name for logging
--- @type string
local MODULE_NAME = "ZombHumanActions"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboDesire.isDebug in ZomboDesire_Main.lua).
--- Calls with cheap/no arguments use ZomboDesire.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboDesire.isDebug(MODULE_NAME)
end

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local tostring = tostring
local tonumber = tonumber
local pairs    = pairs

-- Use _G to bypass EmmyLua "undefined global" warning for Java class
local InventoryItemFactory = _G["InventoryItemFactory"]

--- Instantiates a game item from its type string
--- @param itemType string -- The item type (e.g., "Base.Axe")
--- @return InventoryItem|nil -- The instantiated item or nil if failed
local function instanceItem(itemType)
    if not itemType or itemType == "" then return nil end
    local item = InventoryItemFactory.CreateItem(itemType)
    if not item then
        ZomboDesire.errorLog(MODULE_NAME, "Failed to create item: %s", tostring(itemType))
    end
    return item
end

-- ========================
-- Custom Animation Action
-- ========================

ZomboDesire_ZombHumanActions.CustomAnim = {}

--- Called when a CustomAnim task starts
--- @param zombHuman IsoZombie -- The ZombHuman performing the action
--- @param task table -- The task configuration
--- @return boolean -- true if the task can move to WORKING state immediately
ZomboDesire_ZombHumanActions.CustomAnim.onStart = function(zombHuman, task)
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "CustomAnim.onStart -> anim '%s' for %d ticks", tostring(task.anim), tonumber(task.time) or 0)
    end

    -- Interaction with AnimationHandler for damage detection
    if ZomboDesire_AnimationHandler and ZomboDesire_AnimationHandler.registerZombHumanDamageDetection then
        ZomboDesire_AnimationHandler.registerZombHumanDamageDetection(zombHuman)
    end

    -- If player already started, we can move to WORKING
    if ZomboDesire.playerAnimationStarted then
        ZomboDesire.debugLog(MODULE_NAME, "Player animation already started, moving to WORKING state")
        return true
    end

    ZomboDesire.debugLog(MODULE_NAME, "Waiting for playerAnimationStarted to move to WORKING state")
    return false -- Wait until player starts
end

--- Called every tick while the CustomAnim task is in WORKING state
--- @param zombHuman IsoZombie -- The ZombHuman performing the action
--- @param task table -- The task configuration
--- @return boolean -- true if the task is completed
ZomboDesire_ZombHumanActions.CustomAnim.onWorking = function(zombHuman, task)
    -- High frequency trace for BumpType monitoring
    -- ZomboDesire.debugLog(MODULE_NAME, "TRACE: ID %d WORKING '%s' - Bump: %s", zombHuman:getID(), task.anim or "nil", tostring(zombHuman:getBumpType()))

    -- Force manual position and orientation
    if ZomboDesire.zombHumanFinalPosition then
        -- ZomboDesire.debugLog(MODULE_NAME, "Forcing position -> %.2f, %.2f, %.2f", ZomboDesire.zombHumanFinalPosition.x, ZomboDesire.zombHumanFinalPosition.y, ZomboDesire.zombHumanFinalPosition.z)
        zombHuman:setX(ZomboDesire.zombHumanFinalPosition.x)
        zombHuman:setY(ZomboDesire.zombHumanFinalPosition.y)
        zombHuman:setZ(ZomboDesire.zombHumanFinalPosition.z)
    end
    if ZomboDesire.zombHumanFinalFacing then
        -- ZomboDesire.debugLog(MODULE_NAME, "Forcing direction -> %s", tostring(ZomboDesire.zombHumanFinalFacing))
        zombHuman:setDir(ZomboDesire.zombHumanFinalFacing --[[@as any]])
    end

    -- Push nearby zombies away
    ZomboDesire_Utils.pushNearbyZombies(zombHuman:getX(), zombHuman:getY(), zombHuman:getZ(), 3)

    if task.time <= 0 then
        ZomboDesire.debugLog(MODULE_NAME, "CustomAnim.onWorking completed (time <= 0)")
        return true -- completed
    end
    return false
end

--- Called when the CustomAnim task moves to COMPLETED state
--- @param zombHuman IsoZombie -- The ZombHuman performing the action
--- @param task table -- The task configuration
--- @return boolean -- true if the task can be removed from the queue
ZomboDesire_ZombHumanActions.CustomAnim.onComplete = function(zombHuman, task)
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "CustomAnim.onComplete callback (currentStage was %s)", 
            tostring(zombHuman:getModData().ZomboDesireMultiStage and zombHuman:getModData().ZomboDesireMultiStage.currentStage or "N/A"))
    end

    local md = zombHuman:getModData()
    if md.ZomboDesireMultiStage and ZomboDesire_ZombHumanAnimation then
        -- Handle multi-stage logic
        ZomboDesire.debugLog(MODULE_NAME, "Processing next stage in multi-stage sequence")
        ZomboDesire_ZombHumanAnimation.handleNextStageCompletion(zombHuman, md.ZomboDesireMultiStage, md)
    end

    return true
end

-- =================
-- Equipment Action 
-- =================

ZomboDesire_ZombHumanActions.Equip = {}

--- Mapping of attachment types to their corresponding animations
--- @type table<string, string[]>
local attachmentTypeMap = {
    ["HolsterRight"] = { "AttachHolsterRight", "AttachHolsterRightOut" },
    ["Back"] = { "AttachBack", "AttachBackOut" },
    ["SmallBeltLeft"] = { "AttachHolsterLeft", "AttachHolsterLeftOut" }
}

--- Find the appropriate attachment definition for a given attachment type
--- @param attachmentType string -- The attachment type ID to find
--- @return string|nil -- The first animation key
--- @return string|nil -- The second animation key
--- @return string|nil -- The slot name
local function findAttachmentDefinition(attachmentType)
    if not ISHotbarAttachDefinition then return nil end
    local attachDef = ISHotbarAttachDefinition --[[@as any]]
    for _, def in pairs(attachDef) do
        if def.attachments then
            for k, v in pairs(def.attachments) do
                if k == attachmentType then
                    local config = attachmentTypeMap[def.type]
                    if config then
                        return config[1], config[2], v
                    end
                end
            end
        end
    end
    return nil
end

--- Called when an Equip task starts
--- @param zombie IsoZombie -- The zombie performing the action
--- @param task table -- The task configuration
--- @return boolean -- Always returns true as equipment setup is synchronous
ZomboDesire_ZombHumanActions.Equip.onStart = function(zombie, task)
    task.tick = 1

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Equip.onStart -> action: %s, itemPrimary: %s, itemSecondary: %s", 
            tostring(task.action), tostring(task.itemPrimary), tostring(task.itemSecondary))
    end

    if task.itemSecondary then
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Attempting to equip secondary item -> %s", tostring(task.itemSecondary))
        end

        -- Logic for equipping secondary item
        local hands = zombie:getVariableString("ZombHumanPrimaryType")
        local canEquipSecondary = (not hands or hands == "") or hands == "barehand" or hands == "onehanded" or hands == "handgun" or hands == "throwing"

        if canEquipSecondary then
            local oldSecondary = zombie:getVariableString("ZombHumanSecondary")
            if oldSecondary ~= task.itemSecondary then
                local secondaryItem = instanceItem(task.itemSecondary)
                if secondaryItem then
                    zombie:setSecondaryHandItem(secondaryItem)
                    zombie:setVariable("ZombHumanSecondary", task.itemSecondary)

                    local ls = secondaryItem:getLightStrength()
                    if ls > 0 then
                        secondaryItem:setActivated(true)
                        zombie:setVariable("ZombHumanTorch", true)
                        ZomboDesire.debugLog(MODULE_NAME, "Item has light strength, activated torch mode")
                    else
                        zombie:setVariable("ZombHumanTorch", false)
                    end
                    ZomboDesire.debugLog(MODULE_NAME, "Secondary item '%s' equipped successfully", task.itemSecondary)
                else
                    ZomboDesire.errorLog(MODULE_NAME, "Failed to create secondary item: %s", tostring(task.itemSecondary))
                end
            else
                ZomboDesire.debugLog(MODULE_NAME, "Secondary item '%s' is already equipped", task.itemSecondary)
            end
        else
            ZomboDesire.errorLog(MODULE_NAME, "Cannot equip secondary item - hands type '%s' occupies both hands", tostring(hands))
        end
    end

    if task.itemPrimary then
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Attempting to equip primary item -> %s", tostring(task.itemPrimary))
        end
        local primaryItem = instanceItem(task.itemPrimary)
        if not primaryItem then
            ZomboDesire.errorLog(MODULE_NAME, "Failed to instance itemPrimary -> %s", tostring(task.itemPrimary))
            return true
        end

        local attachmentType = primaryItem:getAttachmentType()
        local anim1, anim2, slot = findAttachmentDefinition(attachmentType)
        if anim1 then
            if dbg() then
                ZomboDesire.debugLog(MODULE_NAME, "Found attachment definition: anim1=%s, anim2=%s, slot=%s", anim1, anim2, tostring(slot))
            end
            task.anim1 = anim1
            task.anim2 = anim2
            task.slot = slot
            return true
        end

        -- Fallback
        ZomboDesire.warningLog(MODULE_NAME, "No attachment definition found for type '%s', using fallback", tostring(attachmentType))
        task.anim1 = "AttachHolsterLeft"
        task.anim2 = "AttachHolsterLeftOut"
    end

    return true
end

--- Called every tick while the Equip task is in WORKING state
--- @param zombie IsoZombie -- The zombie performing the action
--- @param task table -- The task configuration
--- @return boolean -- true if the equipment process is completed
ZomboDesire_ZombHumanActions.Equip.onWorking = function(zombie, task)
    if not task.itemPrimary then
        return true
    end

    if task.tick == 1 then
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Equip.onWorking starting anim1: %s", tostring(task.anim1))
        end
        zombie:setBumpType(task.anim1)
    end

    if task.tick == 15 then
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Equip.onWorking at tick 15, starting anim2: %s", tostring(task.anim2))
        end
        if task.slot then
            if dbg() then
                ZomboDesire.debugLog(MODULE_NAME, "Clearing attached item in slot: %s", tostring(task.slot))
            end
            ---@diagnostic disable-next-line: param-type-mismatch
            zombie:setAttachedItem(task.slot, nil)
        end
        zombie:setBumpType(task.anim2)

        -- We would need a SetHands logic here if we wanted to support primary weapons
        -- For now, ZomboDesire mostly uses secondary items (Penis)
    end

    if task.tick > 20 and zombie:getBumpType() ~= task.anim1 and zombie:getBumpType() ~= task.anim2 then
        ZomboDesire.debugLog(MODULE_NAME, "Equip.onWorking finished after tick 20 and anim completion")
        return true
    end

    task.tick = task.tick + 1
    return false
end

--- Called when the Equip task moves to COMPLETED state
--- @param zombie IsoZombie -- The zombie performing the action
--- @param task table -- The task configuration
--- @return boolean -- Always returns true
ZomboDesire_ZombHumanActions.Equip.onComplete = function(zombie, task)
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Equip.onComplete -> equipment process finished for '%s'", tostring(task.itemPrimary or task.itemSecondary or "unknown"))
    end
    return true
end

return ZomboDesire_ZombHumanActions
