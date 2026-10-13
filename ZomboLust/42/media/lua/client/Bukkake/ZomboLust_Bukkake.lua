-- File: ZomboLust/42/media/lua/client/Bukkake/ZomboLust_Bukkake.lua
-- This is the module that handles all Bukkake related stuff, mainly the layering on of characters
-- @author BlaBla 2026 (based on Timer_z 2025)

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_Bukkake.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"

-- Module name for logging
--- @type string
local MODULE_NAME = "Bukkake"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local table            = table
local table_newarray   = table.newarray
local table_insert     = table.insert
local string           = string
local tostring         = tostring
local pairs            = pairs

--- @class LayerEntry -- Defines a single layer configuration
--- @field Location ItemBodyLocation -- The BodyLocation object associated with this layer
--- @field Layers string[] -- Array of item names for this layer (e.g., {'Bukkake_Face1', 'Bukkake_Face2'})

--- @class BukkakeValues -- Stores character-specific layer state in modData
--- @field Location string -- The BodyLocation associated with this layer
--- @field UnusedLayers integer[] -- Array containing indices of items that can still be added
--- @field UsedLayers integer[] -- Array containing indices of items currently being worn
--- @field Quantity integer -- Current count of layers worn in this location

--- Stores all the main names and references of the layers so the game's performance is not heavily affected
--- @class BukkakeHandler
--- @field Limit integer -- Maximum number of layers per location
--- @field HumanGroupLocations BodyLocationGroup -- Reference to the "Human" BodyLocationGroup
--- @field LayerEntries table<string, LayerEntry> -- Map of defined layers
--- @field LayersList string[] -- Array of defined layer names for fast iteration
local BukkakeHandler = {
    Limit = 5, -- A limit of how many layers can be used at the same time
    HumanGroupLocations = BodyLocations.getGroup("Human"),
    LayerEntries = {},
    LayersList = table_newarray()
}

-- Assign to global or return for other modules
ZomboLust.BukkakeHandler = BukkakeHandler

--- Just define a human location for the layers
--- @param location string -- The BodyLocation ID to define (e.g., 'Bukkake_FullFace')
--- @return ItemBodyLocation -- Returns the existing ItemBodyLocation object
function BukkakeHandler:defineLocation(location)
    -- In B42, we must get the ItemBodyLocation object
    -- Since they are registered in registries.lua with "ZomboLust:" prefix
    local resourceLoc = ResourceLocation.of("ZomboLust:" .. location)
    local itemBodyLocation = ItemBodyLocation.get(resourceLoc)

    if itemBodyLocation then
        -- Now get the BodyLocation from the group
        local layer = self.HumanGroupLocations:getOrCreateLocation(itemBodyLocation)
        if layer then
            layer:setMultiItem(true) -- Allows multiple layers in one location
            ZomboLust.debugLog(MODULE_NAME, "defineLocation: Successfully linked layer for '%s'", location)
        end
    else
        ZomboLust.errorLog(MODULE_NAME, "defineLocation: Could not find ItemBodyLocation for '%s' (ZomboLust:%s)", location, location)
    end

    return itemBodyLocation
end

--- Will define the layer and store all the items from the mentioned location into an array
--- @param name string -- The name that the layer will be called (e.g., 'Face')
--- @param location string -- The BodyLocation ID that the layer will reference
--- @param itemPrefix string -- The prefix of the item names (e.g., 'Bukkake_Face')
--- @param itemCount integer -- How many items are in this layer (e.g., 20)
function BukkakeHandler:defineLayer(name, location, itemPrefix, itemCount)
    if not name or not location or not itemPrefix then
        return
    end

    local locationObj = self:defineLocation(location)
    if not locationObj then
        ZomboLust.errorLog(MODULE_NAME, "defineLayer: Failed to get/create Location object for '%s'", location)
        return
    end

    -- Manually build the list of items based on the provided prefix and count
    -- This is much safer in B42 than relying on getAllItemsForBodyLocation
    local layers = {}
    for i = 1, itemCount do
        table.insert(layers, itemPrefix .. i)
    end

    --- @type LayerEntry
    self.LayerEntries[name] = {
        Location = locationObj,
        Layers = layers,
    }
    table_insert(self.LayersList, name)

    ZomboLust.debugLog(MODULE_NAME, "Layer defined: %s at %s (%d items)", name, location, #layers)
end

--- Definitions of the layers and their associated BodyLocations
--- Wrapped in a function to be called once scripts are fully loaded
function BukkakeHandler:initLayers()
    self:defineLayer("Face", "Bukkake_FullFace", "Bukkake_Face", 20)
    self:defineLayer("Mouth", "Bukkake_CenteredMouth", "Bukkake_Mouth", 20)
    self:defineLayer("Back", "Bukkake_FullBack", "Bukkake_Back", 20)
    self:defineLayer("Chest", "Bukkake_FullChest", "Bukkake_Chest", 20)
    self:defineLayer("Breast", "Bukkake_CenteredBreast", "Bukkake_Breast", 20)
    self:defineLayer("Pussy", "Bukkake_CenteredPussy", "Bukkake_Pussy", 20)
    self:defineLayer("Butt", "Bukkake_CenteredButt", "Bukkake_Butt", 20)
    self:defineLayer("Thigh", "Bukkake_UpperThigh", "Bukkake_Thigh", 20)
    self:defineLayer("UpperLegs", "Bukkake_UpperLegs", "Bukkake_Legs", 20)
    self:defineLayer("Misc", "Bukkake_Miscellaneous", "Bukkake_Misc", 20)
end

-- Event to initialize layers after game initialization
Events.OnGameBoot.Add(function()
    BukkakeHandler:initLayers()
end)

--- Gets the values of the layer in the character modData
--- @param character IsoGameCharacter -- The character to get data from
--- @return table -- Returns the character's Bukkake modData table
function BukkakeHandler:getBukkake(character)
    if not character then
        ZomboLust.errorLog(MODULE_NAME, "getBukkake: character is nil!")
        return {}
    end

    local modData = character:getModData()
    if not modData.ZL_Bukkake then
        if dbg() then
            ZomboLust.debugLog(MODULE_NAME, "Initializing modData.ZL_Bukkake for " .. character:getFullName())
        end
        modData.ZL_Bukkake = {}
    end

    local layerEntries = self.LayerEntries
    local layersList = self.LayersList

    -- Ensure all defined layers exist in the modData (useful if new layers were added)
    for i = 1, #layersList do
        local layer = layersList[i]
        local values = layerEntries[layer]
        local layerData = modData.ZL_Bukkake[layer]

        -- Repair logic: if layer doesn't exist OR if it's empty but shouldn't be
        if not layerData or (#layerData.UnusedLayers == 0 and #layerData.UsedLayers == 0 and #values.Layers > 0) then
            if not layerData then
                if dbg() then
                    ZomboLust.debugLog(MODULE_NAME, "Adding missing layer data to modData: " .. layer)
                end
            else
                if dbg() then
                    ZomboLust.debugLog(MODULE_NAME, "Repairing empty layer data in modData: " .. layer)
                end
            end

            local layers = values.Layers
            local unused_layers = {}
            for index = 1, #layers do
                unused_layers[index] = index
            end

            local locationID = "null"
            if values.Location then
                locationID = values.Location:toString()
            end

            modData.ZL_Bukkake[layer] = {
                Location = locationID,
                UnusedLayers = unused_layers,
                UsedLayers = {},
                Quantity = 0
            }
        end
    end

    return modData.ZL_Bukkake
end

--- Adds a layer to the character
--- @param character IsoGameCharacter -- The character who will receive the layer
--- @param layerName string -- Name of the layer to add (e.g., 'Face')
--- @param quantity integer | nil -- How many layers to add (1 by default)
function BukkakeHandler:addLayer(character, layerName, quantity)
    -- If layerName is the event name itself, it means the parameter wasn't passed or is delayed
    if not layerName or layerName == "ZLAddLayer" then 
        ZomboLust.warningLog(MODULE_NAME, "addLayer: invalid layerName '%s'", tostring(layerName))
        return 
    end

    if not character then
        ZomboLust.errorLog(MODULE_NAME, "addLayer: character is nil for layer '%s'", layerName)
        return
    end

    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "addLayer called for %s on %s", tostring(layerName), character:getFullName())
    end

    quantity = quantity or 1
    local bukkakeData = self:getBukkake(character)
    local layerData = bukkakeData[layerName]

    if not layerData then 
        ZomboLust.errorLog(MODULE_NAME, "addLayer: No layer data found in modData for '%s'", tostring(layerName))
        -- Debug: list available layers in modData
        local available = ""
        local layersList = self.LayersList
        for i = 1, #layersList do 
            available = available .. layersList[i] .. ", " 
        end
        ZomboLust.debugLog(MODULE_NAME, "Available layers in modData: %s", available)
        return 
    end

    local layerEntries = self.LayerEntries
    local layerEntry = layerEntries[layerName]
    if not layerEntry then
        ZomboLust.errorLog(MODULE_NAME, "addLayer: No layer entry found in LayerEntries for '%s'", tostring(layerName))
        return
    end

    local location = layerEntry.Location
    local locationStr = location and location:toString() or "unknown"
    local limit = self.Limit

    for i = 1, quantity do
        ZomboLust.debugLog(MODULE_NAME, "addLayer: Processing quantity %d/%d for %s", i, quantity, layerName)

        if layerData.Quantity >= limit then
            ZomboLust.debugLog(MODULE_NAME, "addLayer: Limit reached (%d/%d) for %s", layerData.Quantity, limit, layerName)
            break
        elseif #layerData.UnusedLayers <= 0 then
            ZomboLust.debugLog(MODULE_NAME, "addLayer: No more unused layers available for %s, increasing quantity only", layerName)
            layerData.Quantity = layerData.Quantity + 1
            break
        end

        -- Pick a random unused item index
        local randIndex = ZombRand(1, #layerData.UnusedLayers + 1)
        local chosenIndex = table.remove(layerData.UnusedLayers, randIndex --[[@as integer]])
        table.insert(layerData.UsedLayers, chosenIndex)

        local itemFullType = layerEntry.Layers[chosenIndex]
        ---@cast itemFullType string

        -- Items are in module 'Base' (defined in .txt files)
        if not string.find(itemFullType, "%.") then
            itemFullType = "Base." .. itemFullType
        end

        ZomboLust.debugLog(MODULE_NAME, "addLayer: Attempting to instance item '%s' at index %d", itemFullType, chosenIndex)
        local item = instanceItem(itemFullType)
        if item and location then
            ZomboLust.debugLog(MODULE_NAME, "addLayer: Item instanced, setting worn item on location '%s'", locationStr)
            character:setWornItem(location, item, false)
            layerData.Quantity = layerData.Quantity + 1
            if dbg() then
                ZomboLust.debugLog(MODULE_NAME, "Added layer %s to %s (Quantity: %d)", itemFullType, character:getFullName(), layerData.Quantity)
            end
        else
            if not item then
                ZomboLust.errorLog(MODULE_NAME, "addLayer: Failed to instance item '%s'!", itemFullType)
            else
                ZomboLust.errorLog(MODULE_NAME, "addLayer: Location object is missing for '%s'!", layerName)
            end
        end
    end
end

--- Cleans a specific layer
--- @param character IsoGameCharacter -- The character to clean
--- @param layerName string -- Name of the layer to remove (e.g., 'Face')
function BukkakeHandler:cleanLayer(character, layerName)
    if not layerName or layerName == "ZLCleanLayer" then 
        ZomboLust.warningLog(MODULE_NAME, "cleanLayer: invalid layerName '%s'", tostring(layerName))
        return 
    end

    if not character then
        ZomboLust.errorLog(MODULE_NAME, "cleanLayer: character is nil for layer '%s'", layerName)
        return
    end

    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "cleanLayer called for %s on %s", tostring(layerName), character:getFullName())
    end

    local bukkakeData = self:getBukkake(character)
    local layerData = bukkakeData[layerName]

    if not layerData then 
        ZomboLust.warningLog(MODULE_NAME, "cleanLayer: No data found for layer '%s'", layerName)
        return 
    end

    local locationID = layerData.Location
    if not locationID or locationID == "null" then
        ZomboLust.errorLog(MODULE_NAME, "cleanLayer: Invalid locationID '%s' for layer '%s'", tostring(locationID), layerName)
        return
    end

    local itemBodyLocation = ItemBodyLocation.get(ResourceLocation.of(locationID))
    if not itemBodyLocation then
        ZomboLust.errorLog(MODULE_NAME, "cleanLayer: Could not find ItemBodyLocation for ID '%s'", locationID)
        return
    end

    local wornItems = character:getWornItems()

    -- Remove all items in this location
    local item = wornItems:getItem(itemBodyLocation)
    local removedCount = 0
    while item do
        wornItems:remove(item)
        removedCount = removedCount + 1
        item = wornItems:getItem(itemBodyLocation)
    end
    ZomboLust.debugLog(MODULE_NAME, "cleanLayer: Removed %d items from location %s", removedCount, locationID)

    -- Move used keys back to unused
    local movedCount = 0
    while #layerData.UsedLayers > 0 do
        table.insert(layerData.UnusedLayers, table.remove(layerData.UsedLayers))
        movedCount = movedCount + 1
    end
    ZomboLust.debugLog(MODULE_NAME, "cleanLayer: Moved %d indices back to UnusedLayers", movedCount)

    layerData.Quantity = 0
    character:resetModelNextFrame()
    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "Cleaned layer %s for %s", layerName, character:getFullName())
    end
end

--- Cleans all Bukkake layers
--- @param character IsoGameCharacter -- The character to clean completely
function BukkakeHandler:cleanAllLayers(character)
    local layersList = self.LayersList
    for i = 1, #layersList do
        self:cleanLayer(character, layersList[i])
    end
end

--- Returns the total "coverage" percentage
--- @param character IsoGameCharacter -- The character to check
--- @return number -- Returns a float between 0.0 and 1.0 representing coverage percentage
function BukkakeHandler:quantityPercentage(character)
    local bukkakeData = self:getBukkake(character)
    local totalLimit = 0
    local totalQuantity = 0
    local limit = self.Limit

    for _, data in pairs(bukkakeData) do
        totalQuantity = totalQuantity + data.Quantity
        totalLimit = totalLimit + limit
    end

    if totalLimit == 0 then return 0 end
    return totalQuantity / totalLimit
end

--- Restore layers (useful after reloading or model reset)
--- @param character IsoGameCharacter -- The character whose layers need restoring
function BukkakeHandler:checkUsedLayers(character)
    local modData = character:getModData()
    if not modData.ZL_Bukkake then return end

    local layerEntries = self.LayerEntries

    for layerName, layerData in pairs(modData.ZL_Bukkake) do
        local layerEntry = layerEntries[layerName]
        if layerEntry and layerEntry.Location then
            local location = layerEntry.Location
            local layers = layerEntry.Layers
            local usedLayers = layerData.UsedLayers

            for i = 1, #usedLayers do
                local index = usedLayers[i]
                local itemFullType = layers[index]
                ---@cast itemFullType string
                if not string.find(itemFullType, "%.") then
                    itemFullType = "Base." .. itemFullType
                end
                local item = instanceItem(itemFullType)
                if item then
                    character:setWornItem(location, item, false)
                    if dbg() then
                        ZomboLust.debugLog(MODULE_NAME, "Restored layer %s for %s", itemFullType, character:getFullName())
                    end
                end
            end
        else
            ZomboLust.warningLog(MODULE_NAME, "checkUsedLayers: No layer entry or location for '%s'", layerName)
        end
    end
end

-- Event for player creation to restore textures
local function OnCreatePlayer(_, player)
    BukkakeHandler:checkUsedLayers(player)
end

Events.OnCreatePlayer.Add(OnCreatePlayer)

return BukkakeHandler
