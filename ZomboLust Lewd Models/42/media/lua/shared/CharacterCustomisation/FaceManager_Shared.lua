--- File: ZomboLust Lewd Models/42/media/lua/shared/CharacterCustomisation/FaceManager_Shared.lua
--- Functions for adding and removing customisation items ingame
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- Module name for logging
--- @type string
local MODULE_NAME = "FaceManager_Shared"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZLLewdModels.isDebug in ZomboLustLewdModels_Main.lua).
--- Calls with cheap/no arguments use ZLLewdModels.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZLLewdModels.isDebug(MODULE_NAME)
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
local insert   = table.insert

--- @class FaceManager_Shared
--- @field GetFirstWornItemWithTag fun(player:IsoPlayer, tag:string|ItemTag):InventoryItem|nil
--- @field GetWornItemsWithTag fun(player:IsoPlayer, tag:string|ItemTag):table
--- @field GetInventoryItemsWithTag fun(player:IsoPlayer, tag:string|ItemTag):table
local FaceManager_Shared = {}

--- Creates a new inventory item and sets its texture
--- @param type string The item type ID
--- @param texture integer The texture index to apply
--- @return InventoryItem
function FaceManager_Shared.CreateItem(type, texture)
    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "CreateItem: type=" .. tostring(type) .. " | texture=" .. tostring(texture))
    end
    -- local item = InventoryItemFactory.CreateItem(type) --b41
    local item = instanceItem(type) --b42

    FaceManager_Shared.SetItemTexture(item, texture)
    return item
end

--- Sets the texture index for an inventory item's visual
--- @param item InventoryItem
--- @param texture integer
function FaceManager_Shared.SetItemTexture(item, texture)
    if item == nil then return end

    local visual = item:getVisual()
    if visual == nil then
        if dbg() then
            ZLLewdModels.debugLog(MODULE_NAME, "SetItemTexture: item:getVisual() is nil for " .. tostring(item:getFullType()) .. ". Trying synchWithVisual.")
        end
        item:synchWithVisual()
        visual = item:getVisual()
    end

    if visual == nil then
        if dbg() then
            ZLLewdModels.debugLog(MODULE_NAME, "SetItemTexture: item:getVisual() is STILL nil for " .. tostring(item:getFullType()))
        end
        return
    end

    local clothingItem = item:getClothingItem()
    local oldBase = visual:getBaseTexture(clothingItem)
    local oldChoice = visual:getTextureChoice(clothingItem)
    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "SetItemTexture: Setting texture " .. tostring(texture) .. " on " .. tostring(item:getFullType()) .. " (old: base=" .. tostring(oldBase) .. ", choice=" .. tostring(oldChoice) .. ")")
    end

    ---@diagnostic disable-next-line: undefined-field
    if visual.setSkinTextureIndex then
        ---@diagnostic disable-next-line: undefined-field
        visual:setSkinTextureIndex(texture)
    end

    -- These are the standard texture settings for items
    visual:setBaseTexture(texture)
    visual:setTextureChoice(texture)

    -- Sync changes back to the item
    if item.synchWithVisual then
        item:synchWithVisual()
    end

    local finalIndex = -1
    ---@diagnostic disable-next-line: undefined-field
    if visual.getSkinTextureIndex then 
        ---@diagnostic disable-next-line: undefined-field
        finalIndex = visual:getSkinTextureIndex() 
    end
    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "SetItemTexture: Applied texture " .. tostring(texture) .. " to " .. tostring(item:getFullType()) .. ". Current base=" .. tostring(visual:getBaseTexture(clothingItem)) .. ", choice=" .. tostring(visual:getTextureChoice(clothingItem)) .. ", skinIndex=" .. tostring(finalIndex))
    end
end

--- Calculates the muscle level (0-2) based on strength level
--- @param level integer|nil
--- @return integer
function FaceManager_Shared.GetMuscleLevel(level)
    if level == nil then return 0 end
    if level <= 5 then return 	0 end
    if level <= 8 then return 	1 end
    if level <= 10 then return 	2 end
    return 0
end

--- Synchronizes blood from player to a newly added item if supported
--- @param player IsoPlayer
--- @param item InventoryItem
--- @return boolean
function FaceManager_Shared.SyncBloodOnNewItem(player, item)
    if not item:hasTag(SPNCC.ItemTag.CanHaveBlood) then return false end
    FaceManager_Shared.AddBloodAndDirtToItem(item:getVisual(), player:getVisual())
    item:synchWithVisual()
    return true
end

--- Copies blood and dirt for a specific body part from one visual to another
--- @param item1 ItemVisual|HumanVisual
--- @param item2 ItemVisual|HumanVisual
--- @param part BloodBodyPartType
--- @return boolean
function FaceManager_Shared.AddBloodAndDirtToBodyPart(item1, item2, part)
    local conditionChanged = false
    -- blood
    local item1Blood = item1:getBlood(part)
    local item2Blood = item2:getBlood(part)
    if item1Blood ~= item2Blood then
        item1:setBlood(part, item2Blood)
        conditionChanged = true
    end
    -- print(part)
    -- print(tostring(item1Blood) .. " | " .. tostring(item2Blood))
    -- print(tostring(item1:getBlood(part)) .. " | " .. tostring(item2:getBlood(part)))

    -- dirt
    local item1Dirt = item1:getDirt(part)
    local item2Dirt = item2:getDirt(part)
    if item1Dirt ~= item2Dirt then
        item1:setDirt(part, item2Dirt)
        conditionChanged = true
    end
    return conditionChanged
end

--- Copies blood and dirt for all body parts from one visual to another
--- @param item1 ItemVisual|HumanVisual
--- @param item2 ItemVisual|HumanVisual
--- @return boolean
function FaceManager_Shared.AddBloodAndDirtToItem(item1, item2)
    local conditionChanged = false
    local maxIndex = BloodBodyPartType.MAX:index()
    for i=1,maxIndex do
        local part = BloodBodyPartType.FromIndex(i-1)
        if FaceManager_Shared.AddBloodAndDirtToBodyPart(item1, item2, part) then conditionChanged = true end
    end
    return conditionChanged
end

--- Opens the character customisation window for a player
--- @param player IsoPlayer
--- @param hideCancelButton boolean
--- @return CharacterCustomisationPanel_Ingame|nil
function FaceManager_Shared.OpenCharacterCustomisationWindow(player, hideCancelButton)
    local data = player:getModData().ZLLewdModels
    if not data then return nil end

    local CharCustomWindow = CharacterCustomisationPanel_Ingame:new()
    ---@diagnostic disable-next-line: inject-field
    CharCustomWindow.hideCancelButton = hideCancelButton
    CharCustomWindow:initialise()
    CharCustomWindow:addToUIManager()

    CharCustomWindow:setX( (getCore():getScreenWidth()/2) - (CharCustomWindow:getWidth()/2) )
    CharCustomWindow:setY( (getCore():getScreenHeight()/2) - (CharCustomWindow:getHeight()/2) )

    ---@diagnostic disable-next-line: undefined-field
    CharCustomWindow:OpenMenu(player)

    --pause the game so the player doesnt get jumped by zombies
    if not isClient() and not isServer() and UIManager.getSpeedControls() then
        UIManager.getSpeedControls():SetCurrentGameSpeed(0)
        UIManager.setShowPausedMessage(false)
    end

    return CharCustomWindow
end

-- -----------
--   GETTERS
-- -----------

--- Finds the first worn item that has the face tag
--- @param player IsoPlayer
--- @return InventoryItem|nil
function FaceManager_Shared.GetWornPlayerFace(player)
    local wornItems = player:getWornItems()
    for i=0, wornItems:size()-1 do
        local item = wornItems:getItemByIndex(i)
        if item:hasTag(SPNCC.ItemTag.Face) then return item end
    end
    return nil
end

--- Finds all worn items that have the specified tag
--- @param player IsoPlayer
--- @param tag string|ItemTag
--- @return table
function FaceManager_Shared.GetWornItemsWithTag(player, tag)
    ---@cast tag any
    local items = {}
    local wornItems = player:getWornItems()
    for i=0, wornItems:size()-1 do
        local item = wornItems:getItemByIndex(i)
        if item:hasTag(tag) then 
            insert(items, item) 
        end
    end
    return items
end

--- Finds the first worn item that has the specified tag
--- @param player IsoPlayer
--- @param tag string|ItemTag
--- @return InventoryItem|nil
function FaceManager_Shared.GetFirstWornItemWithTag(player, tag)
    ---@cast tag any
    local wornItems = player:getWornItems()
    for i=0, wornItems:size()-1 do
        local item = wornItems:getItemByIndex(i)
        if item:hasTag(tag) then 
            return item
        end
    end
end

--- Gets a worn item at the specified body location
--- @param player IsoPlayer
--- @param bodylocation string|ItemBodyLocation
--- @return InventoryItem|nil
function FaceManager_Shared.GetWornItem(player, bodylocation)
    ---@cast bodylocation any
    return player:getWornItem(bodylocation)
end

--- Finds a worn item with the specified tag
--- @param player IsoPlayer
--- @param tag string|ItemTag
--- @return InventoryItem|nil
function FaceManager_Shared.GetWornItemWithTag(player, tag)
    ---@cast tag any
    local wornItems = player:getWornItems()
    for i=0, wornItems:size()-1 do
        local item = wornItems:getItemByIndex(i)
        if item:hasTag(tag) then return item end
    end
    return nil
end

--- Finds all items in the player's inventory that have the specified tag
--- @param player IsoPlayer
--- @param tag string|ItemTag
--- @return table
function FaceManager_Shared.GetInventoryItemsWithTag(player, tag)
    ---@cast tag any
    local items = {}
    ---@diagnostic disable-next-line: missing-parameter
    local javaItems = player:getInventory():getAllTagEval(tag, function(item) return true end)
    if javaItems then
        for i=0, javaItems:size()-1 do
            insert(items, javaItems:get(i))
        end
    end
    return items
end

return FaceManager_Shared
