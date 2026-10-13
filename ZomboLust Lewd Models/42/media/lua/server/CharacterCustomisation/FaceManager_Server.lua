--- File: ZomboLust Lewd Models/42/media/lua/server/CharacterCustomisation/FaceManager_Server.lua
--- Methods for the server to add and remove customisation items
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- =============
-- Dependencies
-- =============

local FaceManager_Shared = require("CharacterCustomisation/FaceManager_Shared")
---@cast FaceManager_Shared FaceManager_Shared
local SPNCC_Data = require("CharacterCustomisation/SPNCC_Data")
local ZLLewdModelsModDataMigration = require("ZLLewdModels_ModDataMigration")

---@class SPNCharCustomData
---@field hasCustomised boolean
---@field face table
---@field bodyDetails table
---@field version number
---@field bodyHairGrowthEnabled boolean
---@field muscleVisuals boolean

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local pairs = pairs
local insert = table.insert

--- @class FaceManager_Server
local FaceManager_Server = {}

FaceManager_Server.modversion = 2

--- Sets the player's face customisation item
--- @param player IsoPlayer
--- @param name string The display name of the face
--- @param id string The item ID of the face
--- @param texture integer The texture index
--- @param sendData boolean Whether to sync data to client
--- @return InventoryItem|nil
function FaceManager_Server.SetPlayerFace(player, name, id, texture, sendData)
    FaceManager_Server.RemovePlayerFace(player, false)
    if name == "DefaultFace" or id == "" then return nil end

    local item = FaceManager_Server.AddItem(player, id, texture)

    FaceManager_Server.SetDataValue(player, "face", {name = name, id = id, texture = texture}, sendData)
    return item
end

--- Removes the player's face customisation item
--- @param player IsoPlayer
--- @param sendData boolean Whether to sync data to client
--- @return void
function FaceManager_Server.RemovePlayerFace(player, sendData)
    FaceManager_Server.RemoveWornItemsWithTag(player, SPNCC.ItemTag.Face)
    FaceManager_Server.SetDataValue(player, "face", {name = "DefaultFace", id = "", texture = 0}, sendData)
end

--- Adds a body detail item to the player
--- @param player IsoPlayer
--- @param name string
--- @param id string
--- @param texture integer
--- @param setData boolean Whether to update the mod data table
--- @return InventoryItem|nil
function FaceManager_Server.AddPlayerBodyDetail(player, name, id, texture, setData)

    local item = FaceManager_Server.AddItem(player, id, texture)

    if setData then
        local modData = player:getModData()
        local data = modData.ZLLewdModels ---@type SPNCharCustomData
        insert(data.bodyDetails, {name = name, id = id, texture = texture})
    end
    return item
end

--- Replaces the player's body detail items
--- @param player IsoPlayer
--- @param details table
--- @param sendData boolean
--- @return void
function FaceManager_Server.SetPlayerBodyDetails(player, details, sendData)
    FaceManager_Server.ClearPlayerBodyDetails(player, false)
    if #details > 0 then 
        for i = 1, #details do
            local v = details[i]
            FaceManager_Server.AddPlayerBodyDetail(player, v.name, v.id, v.texture, false)
        end
    end
    FaceManager_Server.SetDataValue(player, "bodyDetails", details, sendData)
end

--- Removes all body detail items from the player
--- @param player IsoPlayer
--- @param sendData boolean
--- @return void
function FaceManager_Server.ClearPlayerBodyDetails(player, sendData)
    FaceManager_Server.RemoveWornItemsWithTag(player, SPNCC.ItemTag.BodyDetail)
    FaceManager_Server.SetDataValue(player, "bodyDetails", {}, sendData)
end

--- Sets the player's muscle visual based on their strength level and mod/sandbox settings
--- @param player IsoPlayer
function FaceManager_Server.SetPlayerMuscle(player)
    local modData = player:getModData()
    local data = modData.ZLLewdModels ---@type SPNCharCustomData
    if not data then return end

    FaceManager_Server.RemovePlayerMuscle(player)

    if SandboxVars.SPNCharCustom.MuscleVisuals == 2 or not data.muscleVisuals then return end

    local muscleLevel = FaceManager_Shared.GetMuscleLevel(player:getPerkLevel(Perks.Strength))
    if muscleLevel ~= 0 then
        FaceManager_Server.AddPlayerMuscle(player, muscleLevel)
    end
end

--- Adds the muscle customisation item to the player
--- @param player IsoPlayer
--- @param muscleLevel integer
--- @return InventoryItem|nil
function FaceManager_Server.AddPlayerMuscle(player, muscleLevel)
    if muscleLevel <= 0 then return nil end

    local id = player:isFemale() and SPNCC_Data.Muscle[2] or SPNCC_Data.Muscle[1]

    local textureOffset = 0
    if muscleLevel == 2 then textureOffset = 5 end
    local texture = player:getHumanVisual():getSkinTextureIndex() + textureOffset

    return FaceManager_Server.AddItem(player, id, texture)
end

--- Removes the muscle customisation item from the player
--- @param player IsoPlayer
function FaceManager_Server.RemovePlayerMuscle(player)
    FaceManager_Server.RemoveItemAtBodyLocation(player, SPNCC.ItemBodyLocation.Muscle)
end

--- Synchronizes blood from player's body to their customisation items
--- @param player IsoPlayer
function FaceManager_Server.SyncBlood(player)
    local itemsWithBlood = FaceManager_Shared.GetWornItemsWithTag(player, SPNCC.ItemTag.CanHaveBlood)
    if #itemsWithBlood == 0 then return end

    local playerVisual = player:getVisual()

    -- this isnt optimised but no matter what i do it just doesnt work in multiplayer
    for i = 1, #itemsWithBlood do
        local item = itemsWithBlood[i]
        if item then
            FaceManager_Shared.AddBloodAndDirtToItem(item:getVisual(), playerVisual)
            item:synchWithVisual()
        end
    end
    FaceManager_Server.OnClothingUpdated(player)
end

--- Updates a specific key in the player's mod data and optionally syncs it to the client
--- @param player IsoPlayer
--- @param key string
--- @param value any
--- @param sendData boolean
function FaceManager_Server.SetDataValue(player, key, value, sendData)
    local modData = player:getModData()
    local data = modData.ZLLewdModels ---@type SPNCharCustomData
    if not data then return end
    data[key] = value
    if sendData then sendServerCommand(player, "SPNCC", "SetPlayerModDataValues", {values = {[key] = value}}) end
end

--- Initializes the mod data structure for a player
--- @param player IsoPlayer
--- @return table
function FaceManager_Server.CreatePlayerData(player)
    local moddata = player:getModData()
    ZLLewdModelsModDataMigration.migrateLegacyModData(moddata)
    moddata.ZLLewdModels = moddata.ZLLewdModels or {}
    local data = moddata.ZLLewdModels ---@type SPNCharCustomData

    data.version = FaceManager_Server.modversion
    data.hasCustomised = false
    data.face = {name = "DefaultFace", id = "DefaultFace", texture = 0}
    data.bodyDetails = {}
    if data.bodyHairGrowthEnabled == nil then data.bodyHairGrowthEnabled = true end
    if data.muscleVisuals == nil then data.muscleVisuals = true end

    return data
end

--- Updates the player's customisation based on client data
-- TODO (before enabling multiplayer support):
-- clientData.face.id / clientData.bodyDetails[].id come straight from the client and are passed to instanceItem() unvalidated.
-- Fine for solo (no untrusted peer), but before MP goes live this needs to check the ids against a known whitelist
-- (e.g. SPNCC_Data's face/detail tables).
--- @param player IsoPlayer
--- @param clientData table
function FaceManager_Server.SetCustomisation(player, clientData)
    local modData = player:getModData()
    local data = modData.ZLLewdModels ---@type SPNCharCustomData
    if not data then data = FaceManager_Server.CreatePlayerData(player) end

    data.hasCustomised = true
    data.face = clientData.face
    data.bodyDetails = clientData.bodyDetails
    data.bodyHairGrowthEnabled = clientData.bodyHairGrowthEnabled
    data.muscleVisuals = clientData.muscleVisuals

    FaceManager_Server.RefreshCustomisation(player)

    sendServerCommand(player, "SPNCC", "SetPlayerModData", {data = data})
end

--- Sets customisation for a new character
-- TODO (before enabling multiplayer support): same unvalidated-client-data concern as SetCustomisation above.
--- @param player IsoPlayer
--- @param clientData table
function FaceManager_Server.SetCustomisationNewCharacter(player, clientData)
    local data = FaceManager_Server.CreatePlayerData(player)

    data.hasCustomised = true
    data.face = clientData.face
    data.bodyDetails = clientData.bodyDetails
    data.bodyHairGrowthEnabled = clientData.bodyHairGrowthEnabled
    data.muscleVisuals = clientData.muscleVisuals

    FaceManager_Server.RefreshCustomisation(player)

    sendServerCommand(player, "SPNCC", "SetPlayerModData", {data = data})
end

--- Refreshes all customisation items and visuals for a player
--- @param player IsoPlayer
function FaceManager_Server.RefreshCustomisation(player)
    local modData = player:getModData()
    local data = modData.ZLLewdModels ---@type SPNCharCustomData
    if not data then data = FaceManager_Server.CreatePlayerData(player) end

    FaceManager_Server.SetPlayerFace(player, data.face.name, data.face.id, data.face.texture, false)

    FaceManager_Server.SetPlayerBodyDetails(player, data.bodyDetails, false)

    FaceManager_Server.SetPlayerMuscle(player)

    FaceManager_Server.SyncRemoveCustomisation(player)

    FaceManager_Server.OnClothingUpdated(player)
end

--- Handles a player joining the server and initializes their customisation
--- @param player IsoPlayer
function FaceManager_Server.OnPlayerJoin(player)
    local modData = player:getModData()
    ZLLewdModelsModDataMigration.migrateLegacyModData(modData)
    local data = modData.ZLLewdModels ---@type SPNCharCustomData
    local isNewCharacter = (data == nil) or (not data.hasCustomised)

    if not isNewCharacter then
        -- print("Existing character")
        -- FaceManager_Server.CheckData(player, data)
        -- FaceManager_Server.RefreshCustomisation(player)
    else
        -- print("New character")
        data = FaceManager_Server.CreatePlayerData(player)
    end

    FaceManager_Server.RefreshCustomisation(player)

    -- Only runs in multiplayer
    sendServerCommand(player, "SPNCC", "SetPlayerModData", {data = data})
    if isNewCharacter then
        sendServerCommand(player, "SPNCC", "OpenCharacterCustomisationWindow", {})
    end
end

--- Creates and adds an item to the player's inventory and wears it
--- @param player IsoPlayer
--- @param id string
--- @param texture integer
--- @return InventoryItem|nil
function FaceManager_Server.AddItem(player, id, texture)
    local item = FaceManager_Shared.CreateItem(id, texture)
    if not item then return end

    FaceManager_Shared.SyncBloodOnNewItem(player, item)

    player:getInventory():AddItem(item)
    sendAddItemToContainer(player:getInventory(), item)

    player:setWornItem(item:getBodyLocation(), item)
    sendClothing(player, item:getBodyLocation(), item)

    return item
end

--- Removes an item from the player's worn items and inventory
--- @param player IsoPlayer
--- @param item InventoryItem
function FaceManager_Server.RemoveItem(player, item)
    if not item then return end

    -- this doesnt work when the bodylocation is set to multi item
    -- player:removeWornItem(item)

    -- this works but doesnt send a syncpacket in mp so it needs a workaround to sync
    player:getWornItems():remove(item)

    player:getInventory():Remove(item)
    sendRemoveItemFromContainer(player:getInventory(), item)
end

--- Triggers a clothing update and resets the player model
--- @param player IsoPlayer
function FaceManager_Server.OnClothingUpdated(player)
    triggerEvent("OnClothingUpdated", player)
    player:resetModel()
    sendServerCommand(player, "SPNCC", "OnClothingUpdated", {})
end

--- Force synchronizes customisation removal in multiplayer by adding and removing a blank item
--- @param player IsoPlayer
function FaceManager_Server.SyncRemoveCustomisation(player)
    if not isServer() then return end

    -- IsoPlayer:removeWornItem does not work with multi item bodylocations so they have to be removed from wornitems manually
    -- Unfortunately the SyncClothing packets are sent in IsoPlayer:removeWornItem so we need to add a blank item to force sync in mp

    -- print("MULTIPLAYER ONLY setting blank item")
    ---@type InventoryItem|nil
    local blank = player:getWornItem(SPNCC.ItemBodyLocation.Blank)
    if not blank then 
        blank = FaceManager_Server.AddItem(player, "Base.SPNCharCustom_Blank", 0)
    end
    if not blank then return end
    player:removeWornItem(blank)
    player:setWornItem(SPNCC.ItemBodyLocation.Blank, blank)
end

--- Removes a list of items from the player
--- @param player IsoPlayer
--- @param items table
function FaceManager_Server.RemoveItems(player, items)
    if not items then return end
    for _, item in pairs(items) do
        FaceManager_Server.RemoveItem(player, item)
    end
end

--- Removes all items in player inventory that have the specified tag
--- @param player IsoPlayer
--- @param tag string|ItemTag
function FaceManager_Server.RemoveItemsWithTag(player, tag)
    ---@cast tag any
    local items = FaceManager_Shared.GetInventoryItemsWithTag(player, tag);
    FaceManager_Server.RemoveItems(player, items)
end

--- Removes all currently worn items that have the specified tag
--- @param player IsoPlayer
--- @param tag string|ItemTag
function FaceManager_Server.RemoveWornItemsWithTag(player, tag)
    ---@cast tag any
    local items = FaceManager_Shared.GetWornItemsWithTag(player, tag);
    FaceManager_Server.RemoveItems(player, items)
end

--- Removes the item currently worn at the specified body location
--- @param player IsoPlayer
--- @param bodylocation string|ItemBodyLocation
function FaceManager_Server.RemoveItemAtBodyLocation(player, bodylocation)
    ---@cast bodylocation any
    local item = player:getWornItem(bodylocation)
    if item then
        FaceManager_Server.RemoveItem(player, item)
    end
end

return FaceManager_Server
