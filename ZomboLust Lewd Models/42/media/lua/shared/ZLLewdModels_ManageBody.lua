--- File: ZomboLust Lewd Models/42/media/lua/shared/ZLLewdModels_ManageBody.lua
--- Manages equipping body hair and stubble
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust Lewd Models LOADING] ZLLewdModels_ManageBody.lua loaded")

-- Module name for logging
--- @type string
local MODULE_NAME = "ManageBody"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZLLewdModels.isDebug in ZomboLustLewdModels_Main.lua).
--- Calls with cheap/no arguments use ZLLewdModels.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZLLewdModels.isDebug(MODULE_NAME)
end

-- =============
-- Dependencies
-- =============
require("ZLLewdModels_Registries")
local zlSharedData = require("ZLLewdModels_SharedData")

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local table    = table
local pairs    = pairs
local tostring = tostring

--- @class ZLLewdModelsManageBody
local manageBody = {}

--- Flag to prevent recursive calls during clothing updates
manageBody.isProcessing = false

--- Flag to debounce clothing updates
manageBody.needsUpdate = false

--- Last known state of worn items to avoid redundant updates from blood/dirt
manageBody.lastWornFingerprint = ""

-- ==================
-- Utility Functions
-- ==================

--- Generates a unique string based on currently worn items (excluding blood/dirt states)
--- @param player IsoPlayer -- The player character
--- @return string -- A fingerprint representing the current worn items
local function getWornFingerprint(player)
    local wornItems = player:getWornItems()
    local fingerprint = ""
    for i=0, wornItems:size()-1 do
        local item = wornItems:get(i):getItem()
        if item then
            local getBodyLocation = item.getBodyLocation
            local getFullType = item.getFullType
            -- Use location and full type to identify the clothing setup
            -- We exclude blood/dirt by not including item:getVisual() data here
            -- Use tostring() to ensure objects are converted to strings for concatenation
            fingerprint = fingerprint .. tostring(getBodyLocation(item)) .. ":" .. tostring(getFullType(item)) .. ";"
        end
    end
    return fingerprint
end

--- Reduces inventory weight to allow equipping items even when overloaded
--- @param player IsoPlayer -- The player character
--- @param playerInv ItemContainer -- The player's inventory
--- @param backUp table -- Table to store original item weights
local function reduceInvWeight(player, playerInv, backUp)
    local invCapacity = playerInv:getCapacity()
    if player:getInventoryWeight() >= invCapacity then 
        local items = playerInv:getItems()                  
        for i=1,items:size() do
            local item = items:get(i-1)  
            table.insert(backUp, {item = item, weight = item:getWeight(), actualWeight = item:getActualWeight(), customWeight = item:isCustomWeight()}) 
            item:setActualWeight(0)         
            item:setWeight(0)          
            item:setCustomWeight(true)
            if player:getInventoryWeight() < invCapacity then
                break
            end
        end 
    end 
end

--- Restores original item weights after equipment operations
--- @param _player IsoPlayer -- The player character
--- @param _playerInv ItemContainer -- The player's inventory
--- @param backUp table -- Table containing original item weights
local function restoreWeight(_player, _playerInv, backUp)
    for i = 1, #backUp do
        local v = backUp[i]
        if v then
            local item = v.item
            item:setWeight(v.weight)
            item:setActualWeight(v.actualWeight)
            item:setCustomWeight(v.customWeight)
            item:syncItemFields()
        end
    end
end

-- ==================
-- Equipment Logic
-- ==================

--- Equips or removes a 3D hair model on a specific location
--- @param player IsoPlayer -- The player character
--- @param args {bodyLocation: string, itemID: string|nil} -- Location and Item ID to equip
function manageBody.EquipBodyItem(player, args)
    if not args or not args.bodyLocation then return end

    local getResLoc = ResourceLocation.of
    local getItemLoc = ItemBodyLocation.get

    -- Get the location from the player's own location group (B42 way)
    local resLoc = getResLoc(args.bodyLocation)
    local itemBodyLoc = getItemLoc(resLoc)
    if not itemBodyLoc then
        ZLLewdModels.errorLog(MODULE_NAME, "Failed to resolve ItemBodyLocation for: %s", tostring(args.bodyLocation))
        return
    end

    -- Check if it's one of our modded locations
    if not zlSharedData.ModdedLocation(itemBodyLoc) then
        if dbg() then
            ZLLewdModels.debugLog(MODULE_NAME, "Location %s is not marked as modded hair/stubble. Skipping.", tostring(args.bodyLocation))
        end
        return
    end

    local oldItem = player:getWornItem(itemBodyLoc)
    
    -- OPTIMIZATION: Check if already correctly equipped to avoid redundant updates and events
    if args.itemID == nil then
        if not oldItem then return end
    else
        if oldItem and oldItem:getFullType() == args.itemID then
            return
        end
    end

    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "EquipBodyItem: Location=%s, ItemID=%s", tostring(args.bodyLocation), tostring(args.itemID))
    end

    local inv = player:getInventory()

    if args.itemID == nil then
        ---@diagnostic disable-next-line: param-type-mismatch
        player:setWornItem(itemBodyLoc, nil)
        if oldItem then
            inv:Remove(oldItem)
        end
    else
        local item = instanceItem(args.itemID)
        if item then
            player:setWornItem(itemBodyLoc, item)
            if oldItem then
                inv:Remove(oldItem)
            end
            inv:Remove(item)
        else
            ZLLewdModels.errorLog(MODULE_NAME, "Failed to instance item: %s", tostring(args.itemID))
        end
    end
    -- Trigger visual update
    player:getHumanVisual():setHairModel(player:getHumanVisual():getHairModel())
end

--- Prepares a body hair equipment action for the queue
--- @param player IsoPlayer -- The player character
--- @param args {bodyLocation: string} -- The location ID to equip hair on
--- @param equipQueue table -- The queue to add the action to
function manageBody.EquipBodyHair(player, args, equipQueue)
    local bodyLocation = args.bodyLocation
    local locID = zlSharedData.ModLocationID
    local data = player:getModData().ZLLewdModels

    if not data or not locID[bodyLocation] or not data[locID[bodyLocation]] then return end

    local hairItem = data[locID[bodyLocation]]
    if hairItem == "None" then
        table.insert(equipQueue, {actionName = "EquipBodyItem", args = {bodyLocation = bodyLocation, itemID = nil}})
    else        
        local itemID = hairItem
        local gender = player:isFemale() and "Female" or "Male"
        local skinColor = player:getHumanVisual():getSkinTextureIndex()
        local optimizedTable = zlSharedData.OptimizedBodyHair[gender]

        if optimizedTable and optimizedTable[skinColor] then
            itemID = hairItem .. "_" .. optimizedTable[skinColor]
        end         

        -- Check if optimized version exists (simplified for scripts)
        table.insert(equipQueue, {actionName = "EquipBodyItem", args = {bodyLocation = bodyLocation, itemID = itemID}})
    end
end

--- Prepares a beard stubble equipment action for the queue
--- @param player IsoPlayer -- The player character
--- @param _args table|nil -- Unused arguments
--- @param equipQueue table -- The queue to add the action to
function manageBody.EquipBeardStubble(player, _args, equipQueue)
    if player:isFemale() then return end

    local data = player:getModData().ZLLewdModels
    if not data then return end

    local currentBeard = getBeardStylesInstance():FindStyle(player:getHumanVisual():getBeardModel())
    local beardID = currentBeard and currentBeard:getName() or nil

    if zlSharedData.FullBeards[beardID] then
        table.insert(equipQueue, {actionName = "EquipBodyItem", args = {bodyLocation = "zllewdmodels:beardstubble", itemID = nil}})
        data.BeardStubble = 1
    elseif data.BeardStubble == 0 then
        table.insert(equipQueue, {actionName = "EquipBodyItem", args = {bodyLocation = "zllewdmodels:beardstubble", itemID = nil}})
    else
        local skinColor = player:getHumanVisual():getSkinTextureIndex()
        local itemID = "ZLLewdModels.StubbleBeard_Light"
        if skinColor == 4 or skinColor == 5 then
            itemID = "ZLLewdModels.StubbleBeard_Dark"
        end
        table.insert(equipQueue, {actionName = "EquipBodyItem", args = {bodyLocation = "zllewdmodels:beardstubble", itemID = itemID}})
    end
end

--- Prepares a head stubble equipment action for the queue
--- @param player IsoPlayer -- The player character
--- @param _args table|nil -- Unused arguments
--- @param equipQueue table -- The queue to add the action to
function manageBody.EquipHeadStubble(player, _args, equipQueue)
    local data = player:getModData().ZLLewdModels
    if not data then return end

    if data.HeadStubble == 1 then   
        local skinColor = player:getHumanVisual():getSkinTextureIndex()
        local genderSuffix = player:isFemale() and "_F" or "_M"
        local itemID = "ZLLewdModels.StubbleHead_Light" .. genderSuffix
        if skinColor == 4 or skinColor == 5 then
            itemID = "ZLLewdModels.StubbleHead_Dark" .. genderSuffix
        end
        table.insert(equipQueue, {actionName = "EquipBodyItem", args = {bodyLocation = "zllewdmodels:headstubble", itemID = itemID}})
    else
        table.insert(equipQueue, {actionName = "EquipBodyItem", args = {bodyLocation = "zllewdmodels:headstubble", itemID = nil}})
    end
end

-- ==================
-- Execution Logic
-- ==================

--- @type table<string, boolean>
local isEquipAction = {
    ["EquipBodyHair"] = true,
    ["EquipBeardStubble"] = true,
    ["EquipHeadStubble"] = true,
}

--- Processes a queue of equipment actions
--- @param player IsoPlayer -- The player character
--- @param queue {functionName: string, args: table}[] -- The sequence of actions to process
--- @param updateAvatar boolean -- Whether to trigger character screen refresh
function manageBody.executeQueue(player, queue, updateAvatar)
    ZLLewdModels.debugLog(MODULE_NAME, "executeQueue: Processing queue with %d actions", #queue)
    local shouldReduceWeight = false
    local defaultQueue = {}

    for i = 1, #queue do
        local v = queue[i]
        if v then
            if isEquipAction[v.functionName] then
                manageBody[v.functionName](player, v.args, defaultQueue)
                shouldReduceWeight = true
            else
                table.insert(defaultQueue, {actionName = v.functionName, args = v.args or {}})
            end
        end
    end

    local backUp = {}
    local inv = player:getInventory()
    if shouldReduceWeight then
        reduceInvWeight(player, inv, backUp)
    end

    for i = 1, #defaultQueue do
        local v = defaultQueue[i]
        if v and manageBody[v.actionName] then
            manageBody[v.actionName](player, v.args)
        end
    end

    restoreWeight(player, inv, backUp)

    if updateAvatar then
        if ISCharacterInfoWindow and ISCharacterInfoWindow.instance and ISCharacterInfoWindow.instance.charScreen then
            ISCharacterInfoWindow.instance.charScreen.refreshNeeded = true 
        end 
    end

    -- Update fingerprint to current state to avoid triggering onClothingUpdate immediately after
    manageBody.lastWornFingerprint = getWornFingerprint(player)
end

-- ==================
-- Event Handlers
-- ==================

--- Refreshes all hair models when clothing is updated
--- @param player IsoPlayer -- The player whose clothing updated
function manageBody.onClothingUpdate(player)
    if manageBody.isProcessing then return end
    
    local data = player:getModData().ZLLewdModels
    if not data then return end

    -- Fingerprint check to see if clothes actually changed (ignores blood/dirt)
    local currentFingerprint = getWornFingerprint(player)
    if currentFingerprint == manageBody.lastWornFingerprint then
        -- ZLLewdModels.debugLog(MODULE_NAME, "onClothingUpdate: Ignoring (blood/dirt update only)")
        return
    end

    if not manageBody.needsUpdate then
        ZLLewdModels.debugLog(MODULE_NAME, "onClothingUpdate: Update requested (clothing changed)")
        manageBody.needsUpdate = true
    end
end

--- Processes debounced updates every tick
function manageBody.onTick()
    if not manageBody.needsUpdate or manageBody.isProcessing then return end

    local player = getPlayer()
    if not player then return end

    manageBody.needsUpdate = false
    manageBody.isProcessing = true

    ZLLewdModels.debugLog(MODULE_NAME, "onTick: Processing debounced clothing update")

    local queue = {
        {functionName = "EquipBeardStubble", args = {}},
    }

    -- Refresh hair items just in case
    for locationID,_ in pairs(zlSharedData.BodyHairLocations) do
        table.insert(queue, {functionName = "EquipBodyHair", args = {bodyLocation = locationID}})
    end

    manageBody.executeQueue(player, queue, true)
    
    -- Update fingerprint AFTER processing to capture the state with new hair items
    manageBody.lastWornFingerprint = getWornFingerprint(player)
    
    manageBody.isProcessing = false
end

Events.OnClothingUpdated.Add(manageBody.onClothingUpdate)
Events.OnTick.Add(manageBody.onTick)

return manageBody
