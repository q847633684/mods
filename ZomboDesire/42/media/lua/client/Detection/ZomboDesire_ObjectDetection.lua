--- File: ZomboDesire/42/media/lua/client/Detection/ZomboDesire_ObjectDetection.lua
--- Object detection utilities for ZomboDesire framework
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_ObjectDetection.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Main"													-- Main module with debug functions
local ZomboDesire_ObjectTypes = require "Objects/ZomboDesire_ObjectTypes"	-- Object type definitions
local ZomboDesire_Utils = require "ZomboDesire_Utils"						-- Utilities including determinePlayerSideOfObject

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil'
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local math     = math
local table    = table
local string   = string
local tostring = tostring
local pairs    = pairs
local type     = type

--- Module name for logging
--- @type string
local MODULE_NAME = "ObjectDetection"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboDesire.isDebug in ZomboDesire_Main.lua).
--- Calls with cheap/no arguments use ZomboDesire.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboDesire.isDebug(MODULE_NAME)
end

-- ==========
-- Main Logic
-- ==========

-- Checking that ZomboDesire_ObjectTypes are loaded correctly
if not ZomboDesire_ObjectTypes then
    ZomboDesire.errorLog(MODULE_NAME, "Failed to load ZomboDesire_ObjectTypes.lua")
end

-- Checking that ZomboDesire_ObjectTypes.objectTypes is not empty
if not ZomboDesire_ObjectTypes.objectTypes or type(ZomboDesire_ObjectTypes.objectTypes) ~= "table" or #ZomboDesire_ObjectTypes.objectTypes == 0 then
    ZomboDesire.errorLog(MODULE_NAME, "ZomboDesire_ObjectTypes.lua does not contain valid object definitions")
end

--- Module table
--- @class ZomboDesire_ObjectDetection
local ZomboDesire_ObjectDetection = {}

--- Hash table for fast lookup of object types by sprite prefix
--- This table will be used to optimize the search in checkSquareForObjects
--- @type table<string, table>
local spriteToObjectTypeMap = {}

--- Fast lookup for interior wall sprites
--- @type table<string, boolean>
local interiorWallSprites = {}

--- Patterns of sprite names that identify interior walls
local INTERIOR_WALL_PATTERNS = {
    "walls_interior_bathroom_01",
    "walls_interior_house_01",
    "walls_interior_house_02",
    "walls_interior_house_03",
    "walls_interior_house_04",
    "location_community_police_01",
    "location_community_school_01",
    "location_hospitality_sunstarmotel_02",
    "location_restaurant_diner_01",
    "location_restaurant_pileocrepe_01",
    "location_restaurant_pizzawhirled_01",
    "location_shop_bargNclothes_01",
    "carpentry_02",
    "location_community_medical_01",
    "location_restaurant_bar_01",
    "industry_01",
    "industry_railroad_05",
    "industry_trucks_01",
    "location_business_bank_01",
    "location_restaurant_pie_01",
    "location_shop_fossoil_01",
    "location_shop_gas2go_01",
    "location_shop_mall_01",
    "location_barn_01",
    "location_community_church_small_01",
    "location_hospitality_sunstarmotel_01",
    "location_military_tent_01",
    "location_restaurant_seahorse_01",
    "location_restaurant_spiffos_01",
    "location_sewer_01",
    "location_shop_greenes_01",
    "location_trailer_01",
    "walls_commercial_01",
    "walls_commercial_02",
    "walls_commercial_03"
}

--- Types to be treated as walls
local wallTypes = {
    ["Wall"] = true,
    ["Fence"] = true,
    ["High Fence"] = true,
    ["High Fence Door"] = true,
    ["Low Fence Door"] = true
}

--- List of sprite prefixes that commonly block passage
local blockingPrefixes = {
    "walls_",
    "fencing_",
    "furniture_",
    "appliances_refrigeration_",
}

--- List of types of objects that block the passage
local blockingTypes = {
    "Wall",
    "Door",
    "Fence",
    "Fence Door",
    "High Fence Door",
    "Built-in Trailer Fridge",
    "Table",
    "Office Desk",
    "Dark School Bench",
    "Light School Bench",
    "Drawers",
    "Crate",
    "Box",
    "Western Piano",
    "Black Grand Piano",
}

--- Offset for checking the 8 adjacent squares
local adjacentOffsets = {
    {x=0, y=-1}, {x=1, y=-1}, {x=1, y=0}, {x=1, y=1},
    {x=0, y=1}, {x=-1, y=1}, {x=-1, y=0}, {x=-1, y=-1}
}

-- Populate the hash table with data from ZomboDesire_ObjectTypes
local objectTypesList = ZomboDesire_ObjectTypes.objectTypes
for i = 1, #objectTypesList do
    local objectType = objectTypesList[i]
    local spriteNames = objectType.spriteNames
    if spriteNames and #spriteNames > 0 then
        for j = 1, #spriteNames do
            local sprite = spriteNames[j]
            if sprite.name then
                spriteToObjectTypeMap[sprite.name] = objectType

                -- Check if this sprite is an interior wall and cache it
                for k = 1, #INTERIOR_WALL_PATTERNS do
                    if string.find(sprite.name, INTERIOR_WALL_PATTERNS[k]) then
                        interiorWallSprites[sprite.name] = true
                        break
                    end
                end
            end
        end
    else
        ZomboDesire.warningLog(MODULE_NAME, "Object type '%s' has no sprite names defined", objectType.type or "unknown")
    end
end

-- Check that the hash table is not empty
local isEmpty = true
for _ in pairs(spriteToObjectTypeMap) do
    isEmpty = false
    break
end

if isEmpty then
    ZomboDesire.warningLog(MODULE_NAME, "No valid sprite prefixes found in object types")
end

--- Object types that should be excluded when player is behind them
--- @type table<string, boolean>
local OBJECTS_TO_EXCLUDE_FROM_BACK = {
    -- Appliances / Communication
    ["TV"] = true,

    -- Appliances / Cooking appliances
    ["Large Modern Cooker"] = true,
    ["BakeOMatic Industrial"] = true,
    ["Oven"] = true,
    ["Drum"] = true,
    ["Barbecue"] = true,
    ["Jorge Foreguy Barbecue"] = true,
    ["Full Jorge Foreguy Barbecue"] = true,

    -- Appliances / Fridges
    ["Fridge"] = true,
    ["Other Fridge"] = true,
    ["Freezer"] = true,

    -- Appliances / Washing machines
    ["Clothes Dryer"] = true,
    ["Washing Machine"] = true,
    ["Blue Combo WasherDryer"] = true,

    -- Appliances / Other
    ["Terminal"] = true,
    ["Arcade"] = true,
    ["Pinball"] = true,

    -- Plumbing / Sinks
    ["Sink"] = true,

    -- Plumbing / Baths and showers
    ["Shower screen"] = true,
    ["Bath"] = true,

    -- Plumbing / Toilets
    ["Toilet"] = true,

    -- Plumbing / Other
    ["Water Dispenser"] = true,
    ["Empty Water Dispenser"] = true,

    -- Comfort / Beds
    ["Bed"] = true,
    ["Beds"] = true,

    -- Comfort / Couches
    ["Couch"] = true,

    -- Comfort / Chairs
    ["Chair"] = true,

    -- Comfort / Benches
    ["Bench"] = true,

    -- Comfort / Stools
    ["Stool"] = true,

    -- Comfort / Seats
    ["Seat"] = true,

    -- Comfort / Other
    ["Pew"] = true,
    ["Orange Futon"] = true,

    -- Tables
    ["Table"] = true,

    -- Storage
    ["Shelves"] = true,
    ["Shelf"] = true,
    ["Stand"] = true,
    ["Rack"] = true,
    ["Cabinet"] = true,
    ["Drawers"] = true,
    ["Wardrobe"] = true,
    ["Locker"] = true,
    ["Cardboard Box"] = true,
    ["Public Mail Box"] = true,
    ["Crate"] = true,
    ["Scarecrow"] = true,
    ["Mannequin"] = true,
    ["Desk"] = true,
    ["Glass"] = true,
    ["Bin"] = true,
    ["Dumpster"] = true,

    -- Storage / Other
    ["Slurp Burp Soda Machine"] = true,
    ["Large Machine"] = true,

    -- Workstations
    ["Workbench"] = true,
    ["Loom"] = true,
    ["Pottery Wheel"] = true,

    -- Decorations / Sculptures
    ["Bust"] = true,
    ["Statue"] = true,

    -- Decorations / Phones
    ["Pay Phones"] = true,

    -- Signs
    ["Sign"] = true,

    -- Plants
    ["Plantbed"] = true,
    ["Hay"] = true,

    -- Miscellaneous
    ["Road Block"] = true,
    ["Laundry Cart"] = true,
    ["Planter"] = true,
    ["Gravestone"] = true,
    ["Cairn"] = true,
    ["Childrens Play Castle"] = true,
    ["Standing Vault"] = true,
    ["Small Soda Machine"] = true,
    ["Oldies Jukebox"] = true,
    ["Piano"] = true,
    ["Pool Cue Stand"] = true,
    ["Security Wall Monitors"] = true,
    ["DogHouse"] = true,

    -- Everything else
    ["Damaged Public Mail Box"] = true,
    ["Distillery"] = true,
    ["Tires Pile Small"] = true,
    ["Tires Pile Big"] = true,
    ["Large Animal Feeder"] = true,
    ["Small Animal Feeder"] = true,
    ["Large Metal Feeder With Roof"] = true,
    ["Long Cattle Feeder"] = true,
    ["Short Cattle Feeder"] = true,
    ["Chicken Coop"] = true,
    ["Target Panel"] = true,
    ["Pallet Gold"] = true,
    ["Welcome Knox"] = true,
    ["Concrete Road Block"] = true,
    ["Small Newspaper Vending Machine"] = true,
    ["Large Newspaper Vending Machine"] = true,
    ["Composter"] = true,
    ["Stack Log"] = true,
    ["Mobile Medical Tool"] = true,
    ["Medical Foot Tool"] = true,
    ["Baby Incubator"] = true,
    ["Mortuary Storage"] = true,
    ["Blood Bank"] = true,
    ["Wide Medical Cabinet"] = true,
    ["Heavy Industry Machine"] = true,
    ["Advertising Mall"] = true,
    ["Mechanical Conveyor"] = true,
    ["Automatic Machinery"] = true,
    ["Industrial Electrical Panel"] = true,
    ["Industrial Jigsaw"] = true,
    ["Various Machinery"] = true,
    ["ATM Machine"] = true,
    ["Bank Vault"] = true,
    ["Gas Pump"] = true,
    ["Out of Gas"] = true,
    ["Mall Central Block"] = true,
    ["Mall Map"] = true,
    ["Gym Treadmills"] = true,
    ["Fitness Contraption"] = true,
    ["Tennis Net"] = true,
    ["Buffet Pans"] = true,
    ["Pallet Brick"] = true
}

--- Processes objects in a box and identifies those that match the defined types
--- @param objects PZArrayList<IsoObject> -- List of objects to be processed
--- @param playerSquare IsoGridSquare -- The player's square (for calculating relative positions)
--- @param square IsoGridSquare -- The box containing the objects
--- @param isPlayerSquare boolean -- Indicates if this is the player's square
--- @param playerIsOutside boolean -- Indicates if the player is outside
--- @return table -- List of detected objects
local function processObjectsInSquare(objects, playerSquare, square, isPlayerSquare, playerIsOutside)
    -- Table to store detected objects
    local detectedObjects = {}
    local objectsSize = objects:size()

    for i = 0, objectsSize - 1 do
        local object = objects:get(i)
        local sprite = object and object:getSprite()
        if not object or not sprite then
            -- Skip this object if it's nil or has no sprite
            ZomboDesire.debugLog(MODULE_NAME, "Object with no sprite found, skipping")
            -- Continue to next iteration
        else
            local spriteName = sprite:getName()

            if not spriteName or spriteName == "" then
                ZomboDesire.debugLog(MODULE_NAME, "Object with empty sprite name found, skipping")
                -- Continue to next iteration
            else
                -- Instead of iterating through all object types, we search directly in the hash table
                local matchFound = false

                -- First try exact match (for new format with tables)
                if spriteToObjectTypeMap[spriteName] then
                    local objectType = spriteToObjectTypeMap[spriteName]

                    -- Calculate the square's position relative to the player
                    local relX = square:getX() - playerSquare:getX()
                    local relY = square:getY() - playerSquare:getY()

                    -- Add to detected objects
                    table.insert(detectedObjects, {
                        object = object,
                        type = objectType.type,
                        spriteName = spriteName,
                        isPlayerSquare = isPlayerSquare,
                        isInteriorWall = interiorWallSprites[spriteName] or false,
                        square = square,
                        relX = relX,
                        relY = relY
                    })

                    ZomboDesire.debugLog(MODULE_NAME, "Object detected -> %s (Sprite %s) at relative position %d,%d, both %s",
                        objectType.type, spriteName or "N/A", relX, relY,
                        playerIsOutside and "outside" or "inside")

                    matchFound = true
                end

                -- If we haven't found a match, we report it
                if not matchFound then
                    ZomboDesire.debugLog(MODULE_NAME, "No matching object type found for sprite %s", spriteName)
                end
            end
        end
    end

    return detectedObjects
end

--- Checks a square for objects that can be used in animations
--- @param playerSquare IsoGridSquare -- The square the player is on
--- @param square IsoGridSquare -- The square to check for objects
--- @param isPlayerSquare boolean -- Indicates if this is the player's square
--- @return table -- List of detected objects
local function checkSquareForObjects(playerSquare, square, isPlayerSquare)
    -- Checking settings
    if not playerSquare then
        ZomboDesire.errorLog(MODULE_NAME, "checkSquareForObjects -> playerSquare is nil")
        return {}
    end

    if not square then
        ZomboDesire.warningLog(MODULE_NAME, "checkSquareForObjects -> square is nil")
        return {}
    end

    -- Check if player and square have the same inside/outside status
    local playerIsOutside = playerSquare:isOutside()
    local squareIsOutside = square:isOutside()

    -- If player is outside and square is inside (or vice versa), ignore objects on this square
    if playerIsOutside ~= squareIsOutside then
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Ignoring objects on square at relative position %d,%d (player outside %s, square outside %s)",
                square:getX() - playerSquare:getX(), square:getY() - playerSquare:getY(),
                tostring(playerIsOutside), tostring(squareIsOutside))
        end
        return {}
    end

    -- Checking that tile has objects
    local objects = square:getObjects()
    if not objects or objects:size() == 0 then
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "No objects found on square at relative position %d,%d",
                square:getX() - playerSquare:getX(), square:getY() - playerSquare:getY())
        end
        return {}
    end

    -- Process objects in the square
    return processObjectsInSquare(objects, playerSquare, square, isPlayerSquare, playerIsOutside)
end

--- Retrieves the adjacent squares surrounding a given square
--- @param playerSquare IsoGridSquare -- The square from which to retrieve adjacent squares
--- @return table -- A table containing the adjacent squares
local function getAdjacentSquares(playerSquare)
    local adjacentSquares = {}
    -- Check the 8 adjacent squares
    for i = 1, #adjacentOffsets do
        local offset = adjacentOffsets[i]
        local adjacentSquare = getCell():getGridSquare(
            playerSquare:getX() + offset.x,
            playerSquare:getY() + offset.y,
            playerSquare:getZ()
        )
        if adjacentSquare then
            table.insert(adjacentSquares, adjacentSquare)
        end
    end

    return adjacentSquares
end

--- Checks if there are stairs on the player's square and prioritizes them
--- @param allDetectedObjects table -- List of all detected objects
--- @return table -- Either only the stairs object or the original list
local function prioritizeStairsOnPlayerSquare(allDetectedObjects)
    -- Check if there are any stairs on the player's square
    local stairsOnPlayerSquare = nil

    for i = 1, #allDetectedObjects do
        local obj = allDetectedObjects[i]
        if obj.type == "Stairs" and obj.isPlayerSquare then
            stairsOnPlayerSquare = obj
            ZomboDesire.debugLog(MODULE_NAME, "Stairs detected on player square -> %s", obj.spriteName)
            break
        end
    end

    -- If stairs are found on player square, return only that object
    if stairsOnPlayerSquare then
        ZomboDesire.debugLog(MODULE_NAME, "Prioritizing stairs on player square, ignoring all other objects")
        return {stairsOnPlayerSquare}
    end

    -- Otherwise return the original list
    return allDetectedObjects
end

--- Filters out objects that should be ignored based on player position
--- @param allDetectedObjects table -- List of detected objects
--- @param player IsoPlayer -- The player
--- @return table -- Filtered list of objects
local function filterObjectsByPlayerPosition(allDetectedObjects, player)
    -- Create a new list for filtered objects
    local positionFiltered = {}

    for i = 1, #allDetectedObjects do
        local obj = allDetectedObjects[i]
        local shouldIgnore = false

        -- Check if this object type should be excluded when player is behind it
        local shouldCheckPosition = false
        if obj.type then
            for excludedType, _ in pairs(OBJECTS_TO_EXCLUDE_FROM_BACK) do
                if string.find(obj.type, excludedType) then
                    shouldCheckPosition = true
                    break
                end
            end
        end

        local sprite = shouldCheckPosition and obj.object and obj.object:getSprite()
        if sprite then
            -- Get the object's direction
            local spriteName = sprite:getName()
            local objectDir = ZomboDesire_ObjectTypes.getSpriteDirection(spriteName)

            -- If we have a valid direction and the player is behind the object, ignore it
            if objectDir and ZomboDesire_Utils.determinePlayerSideOfObject(player, obj.square, objectDir) == "Back" then
                ZomboDesire.debugLog(MODULE_NAME, "Ignoring %s at relative position %d,%d because player is behind it",
                    obj.type, obj.relX, obj.relY)
                shouldIgnore = true
            end
        end

        -- If the object should not be ignored, add it to the filtered list
        if not shouldIgnore then
            table.insert(positionFiltered, obj)
        end
    end

    return positionFiltered
end

--- Filters objects based on their type when player is outside
--- @param positionFiltered table -- List of position filtered objects
--- @param playerIsInside boolean -- Whether the player is inside a building
--- @return table -- Filtered list of objects
local function filterObjectsForOutside(positionFiltered, playerIsInside)
    -- If the player is inside, no need to filter
    if playerIsInside then
        return positionFiltered
    end

    ZomboDesire.debugLog(MODULE_NAME, "Player is outside - checking for exterior objects vs walls")

    -- Check if we have both walls and other objects
    local hasWalls = false
    local hasOtherObjects = false
    local exteriorObjects = {}
    local exteriorWalls = {}

    for i = 1, #positionFiltered do
        local obj = positionFiltered[i]
        if wallTypes[obj.type] then
            hasWalls = true
            table.insert(exteriorWalls, obj)
        else
            hasOtherObjects = true
            table.insert(exteriorObjects, obj)
        end
    end

    -- If we have both walls/fences and other objects, filter out the walls/fences
    if hasWalls and hasOtherObjects then
        ZomboDesire.debugLog(MODULE_NAME, "Both walls/fences and other objects detected outside - prioritizing objects over walls/fences")
        return exteriorObjects
    end

    -- If we only have walls, return them
    if hasWalls then
        ZomboDesire.debugLog(MODULE_NAME, "Only walls detected outside")
        return exteriorWalls
    end

    -- If we only have other objects, return them
    ZomboDesire.debugLog(MODULE_NAME, "Only objects (no walls) detected outside")
    return positionFiltered
end

--- Filters objects that are behind interior walls relative to the player
--- @param positionFiltered table -- List of all detected objects
--- @param player IsoPlayer -- The player
--- @return table -- Filtered list of objects excluding those behind interior walls
local function filterObjectsBehindInteriorWalls(positionFiltered, player)
    -- Get player's square and room ID
    local playerSquare = player:getCurrentSquare()
    if not playerSquare then
        ZomboDesire.warningLog(MODULE_NAME, "Cannot filter objects behind walls - player square is nil")
        return positionFiltered
    end

    -- Check if player is inside a building
    if playerSquare:isOutside() then
        ZomboDesire.debugLog(MODULE_NAME, "Player is outside - skipping interior wall filtering")
        return positionFiltered
    end

    -- Get player's room object (IsoRoom)
    local playerRoom = playerSquare:getRoom()

    -- If player is not in a defined room, we can't filter by room
    if not playerRoom then
        ZomboDesire.debugLog(MODULE_NAME, "Player is not in a defined room - skipping room-based filtering")
        return positionFiltered
    end

    -- Get room name for logging
    local playerRoomName = playerRoom:getName() or "unnamed"
    ZomboDesire.debugLog(MODULE_NAME, "Player is in room %s", playerRoomName)

    -- First, check if we have any interior walls in the detected objects
    local interiorWallsCount = 0
    for i = 1, #positionFiltered do
        local obj = positionFiltered[i]
        if obj.isInteriorWall then
            ZomboDesire.debugLog(MODULE_NAME, "Interior wall detected -> %s", obj.spriteName)
            interiorWallsCount = interiorWallsCount + 1
        end
    end

    -- If no interior walls, no need to filter
    if interiorWallsCount == 0 then
        ZomboDesire.debugLog(MODULE_NAME, "No interior walls detected")
        return positionFiltered
    end

    ZomboDesire.debugLog(MODULE_NAME, "Interior walls detected (%d) - filtering objects behind walls", interiorWallsCount)

    -- Filter objects based on room comparison
    local roomFiltered = {}
    for i = 1, #positionFiltered do
        local obj = positionFiltered[i]
        -- Walls are always kept, and we only check rooms for other objects
        local objRoom = (obj.type ~= "Wall") and obj.square:getRoom()
        local objRoomName = objRoom and (objRoom:getName() or "unnamed")

        -- Log the room of the object if it has one
        if objRoomName then
            ZomboDesire.debugLog(MODULE_NAME, "Object %s at relative position %d,%d is in room %s",
                obj.type, obj.relX, obj.relY, objRoomName)
        end

        -- If the object is in a different room than the player, ignore it
        if objRoom and objRoom ~= playerRoom then
            ZomboDesire.debugLog(MODULE_NAME, "Ignoring %s at relative position %d,%d because it's behind an interior wall (different room '%s' vs player's '%s')",
                obj.type, obj.relX, obj.relY, objRoomName, playerRoomName)
        else
            -- In all other cases (Wall, same room, or no room), we keep the object
            table.insert(roomFiltered, obj)
        end
    end

    return roomFiltered
end

--- Filters objects based on their type when player is inside
--- @param roomFiltered table -- List of room filtered objects
--- @param playerIsInside boolean -- Whether the player is inside a building
--- @return table -- Filtered list of objects
local function filterObjectsForInside(roomFiltered, playerIsInside)
    -- If the player is not inside, no need to filter (this is handled by filterObjectsForOutside)
    if not playerIsInside then
        return roomFiltered
    end

    ZomboDesire.debugLog(MODULE_NAME, "Player is inside - checking for interior objects vs walls")

    -- Check if we have both walls and other objects
    local hasWalls = false
    local hasOtherObjects = false
    local interiorObjects = {}
    local interiorWalls = {}

    for i = 1, #roomFiltered do
        local obj = roomFiltered[i]
        if obj.type == "Wall" then
            hasWalls = true
            table.insert(interiorWalls, obj)
        else
            hasOtherObjects = true
            table.insert(interiorObjects, obj)
        end
    end

    -- If we have both walls and other objects, filter out the walls
    if hasWalls and hasOtherObjects then
        ZomboDesire.debugLog(MODULE_NAME, "Both walls and other objects detected inside building - prioritizing objects over walls")
        return interiorObjects
    end

    -- If we only have walls, return them
    if hasWalls then
        ZomboDesire.debugLog(MODULE_NAME, "Only walls detected inside building")
        return interiorWalls
    end

    -- If we only have other objects, return them
    ZomboDesire.debugLog(MODULE_NAME, "Only objects (no walls) detected inside building")
    return roomFiltered
end

--- Checks if an object on a square is blocking movement
--- @param frontObj IsoObject -- The object to check
--- @return boolean -- True if the object is blocking, false otherwise
local function isObjectBlocking(frontObj)
    -- Check if the object has a sprite (indicating it's a physical object)
    local sprite = frontObj and frontObj:getSprite()
    if not sprite then return false end

    local spriteName = sprite:getName()
    if not spriteName or spriteName == "" then return false end

    -- 1. First check if the sprite matches a blocking prefix
    for i = 1, #blockingPrefixes do
        local prefix = blockingPrefixes[i]
        if string.find(spriteName, prefix) then
            ZomboDesire.debugLog(MODULE_NAME, "Found blocking object with sprite prefix %s (sprite %s)", prefix, spriteName)
            return true
        end
    end

    -- 2. Check if it is a blocking object type from modData
    if frontObj:getModData() and frontObj:getModData().objectType then
        local objectType = frontObj:getModData().objectType
        for i = 1, #blockingTypes do
            local blockingType = blockingTypes[i]
            if objectType and string.find(objectType, blockingType) then
                ZomboDesire.debugLog(MODULE_NAME, "Found blocking object with type %s", objectType)
                return true
            end
        end
    end

    -- 3. Try to determine its type from the sprite as a fallback
    local determinedType = ZomboDesire_ObjectTypes.getObjectTypeFromSprite(spriteName)
    if determinedType then
        for i = 1, #blockingTypes do
            local blockingType = blockingTypes[i]
            if determinedType and string.find(determinedType, blockingType) then
                ZomboDesire.debugLog(MODULE_NAME, "Found blocking object with determined type %s (sprite %s)", determinedType, spriteName)
                return true
            end
        end
    end

    ZomboDesire.debugLog(MODULE_NAME, "Found non-blocking object with sprite %s", spriteName)
    return false
end

--- Filters objects based on whether there is free space in front of them
--- @param environmentFilteredList table -- List of filtered objects (either insideFiltered or outsideFiltered)
--- @param player IsoPlayer -- The player (not used but kept for consistency with other functions)
--- @return table -- Filtered list of objects with free space in front
local function filterObjectsByFreeSpace(environmentFilteredList, player)
    local freeSpaceFiltered = {}

    ZomboDesire.debugLog(MODULE_NAME, "Starting free space filtering with %d objects", #environmentFilteredList)

    for i = 1, #environmentFilteredList do
        local obj = environmentFilteredList[i]
        -- Get the object's direction
        local objectDir = nil
        local shouldCheckFreeSpace = false
        ---@type number
        local frontX = 0
        ---@type number
        local frontY = 0

        local sprite = obj.object and obj.object:getSprite()
        if sprite then
            local spriteName = sprite:getName()
            objectDir = ZomboDesire_ObjectTypes.getSpriteDirection(spriteName)

            if objectDir then
                -- Calculate the position in front of the object
                local dirString = tostring(objectDir)

                if dirString == "N" then
                    frontX, frontY = obj.square:getX(), math.floor(obj.square:getY() - 1)
                    shouldCheckFreeSpace = true
                elseif dirString == "E" then
                    frontX, frontY = math.floor(obj.square:getX() + 1), obj.square:getY()
                    shouldCheckFreeSpace = true
                elseif dirString == "S" then
                    frontX, frontY = obj.square:getX(), math.floor(obj.square:getY() + 1)
                    shouldCheckFreeSpace = true
                elseif dirString == "W" then
                    frontX, frontY = math.floor(obj.square:getX() - 1), obj.square:getY()
                    shouldCheckFreeSpace = true
                else
                    ZomboDesire.warningLog(MODULE_NAME, "Including %s at %d,%d because direction format is unknown %s",
                        obj.type, obj.relX, obj.relY, dirString)
                end
            else
                ZomboDesire.debugLog(MODULE_NAME, "Including %s at %d,%d because direction couldn't be determined",
                    obj.type, obj.relX, obj.relY)
            end
        else
            ZomboDesire.warningLog(MODULE_NAME, "Object %s at %d,%d has no sprite or is invalid - including by default", obj.type, obj.relX, obj.relY)
        end

        -- Only check for free space if we have a valid direction
        if not shouldCheckFreeSpace then
            table.insert(freeSpaceFiltered, obj)
        else
            ---@cast frontX number
            ---@cast frontY number
            -- Get the square in front of the object
            local frontSquare = getCell():getGridSquare(frontX, frontY, obj.square:getZ())

            if not frontSquare then
                -- If the front square doesn't exist, it's not a free space
                ZomboDesire.errorLog(MODULE_NAME, "Ignoring %s at relative position %d,%d because the square in front doesn't exist (coordinates %d,%d,%d)",
                    obj.type, obj.relX, obj.relY, frontX, frontY, obj.square:getZ())
            else
                if dbg() then
                    ZomboDesire.debugLog(MODULE_NAME, "Object at %d,%d (world %d,%d) - checking front square at %d,%d",
                        obj.relX, obj.relY, obj.square:getX(), obj.square:getY(), frontX, frontY)
                end

                -- Check if the square has any objects that would block movement
                local objects = frontSquare:getObjects()
                local hasBlockingObject = false

                if objects and objects:size() > 0 then
                    local frontObjectsSize = objects:size()
                    ZomboDesire.debugLog(MODULE_NAME, "Front square exists and has %d objects", frontObjectsSize)

                    for j = 0, frontObjectsSize - 1 do
                        if isObjectBlocking(objects:get(j)) then
                            hasBlockingObject = true
                            break
                        end
                    end
                else
                    ZomboDesire.debugLog(MODULE_NAME, "Front square has no objects or is empty")
                end

                -- If there's no blocking object, add the object to the filtered list
                if not hasBlockingObject then
                    table.insert(freeSpaceFiltered, obj)
                    ZomboDesire.debugLog(MODULE_NAME, "Including %s at relative position %d,%d because there's free space in front",
                        obj.type, obj.relX, obj.relY)
                else
                    ZomboDesire.debugLog(MODULE_NAME, "Ignoring %s at relative position %d,%d because front square is blocked",
                        obj.type, obj.relX, obj.relY)
                end
            end
        end
    end

    ZomboDesire.debugLog(MODULE_NAME, "Free space filtering complete %d objects remaining", #freeSpaceFiltered)
    return freeSpaceFiltered
end

--- Sorts objects based on their priority
--- @param freeSpaceFiltered table -- List of detected objects
--- @return table -- Sorted list of objects
local function sortObjectsByPriority(freeSpaceFiltered)
    -- Sort detected objects by priority:
    -- 1. Objects on the player's square
    -- 2. Objects on adjacent squares, sorted by distance
    table.sort(freeSpaceFiltered, function(a, b)
        -- First priority: objects on player's square vs adjacent squares
        if a.isPlayerSquare and not b.isPlayerSquare then
            return true
        elseif not a.isPlayerSquare and b.isPlayerSquare then
            return false
        end

        -- If both objects are on adjacent squares, prioritize by distance (Manhattan distance)
        if not a.isPlayerSquare and not b.isPlayerSquare then
            local distA = math.abs(a.relX) + math.abs(a.relY)
            local distB = math.abs(b.relX) + math.abs(b.relY)
            return distA < distB
        end

        -- If all else is equal, maintain stable sort
        return false
    end)

    return freeSpaceFiltered
end

--- Detects objects on the player's tile (or around) to determine if a specific animation should be played
--- @param player IsoPlayer -- The player involved in the collision
--- @return table|nil -- Detected object with properties (object, type, spriteName, square, relativeX, relativeY) or nil if none found
function ZomboDesire_ObjectDetection.detectObjectOnPlayerTile(player)
    -- Checking the player parameter
    if not player then
        ZomboDesire.errorLog(MODULE_NAME, "detectObjectOnPlayerTile -> player is nil")
        return nil
    end

    -- Retrieve the tile the player is on
    local playerSquare = player:getSquare()
    if not playerSquare then
        ZomboDesire.errorLog(MODULE_NAME, "detectObjectOnPlayerTile -> player square is nil")
        return nil
    end

    -- Check if player is inside a building
    local playerIsInside = not playerSquare:isOutside()

    -- Table to store all detected objects
    local allDetectedObjects = {}

    -- Check the player's square
    local objectsOnPlayerSquare = checkSquareForObjects(playerSquare, playerSquare, true)
    for i = 1, #objectsOnPlayerSquare do
        table.insert(allDetectedObjects, objectsOnPlayerSquare[i])
    end

    -- Check adjacent squares
    local adjacentSquares = getAdjacentSquares(playerSquare)
    for i = 1, #adjacentSquares do
        local adjacentSquare = adjacentSquares[i]
        if adjacentSquare then
            local objectsOnAdjacentSquare = checkSquareForObjects(playerSquare, adjacentSquare, false)
            for j = 1, #objectsOnAdjacentSquare do
                table.insert(allDetectedObjects, objectsOnAdjacentSquare[j])
            end
        end
    end

    -- If no objects were detected, return nil
    if #allDetectedObjects == 0 then
        ZomboDesire.debugLog(MODULE_NAME, "No objects detected around player")
        return nil
    end

    -- Prioritize stairs if they are on the player's square
    local stairsObjects = prioritizeStairsOnPlayerSquare(allDetectedObjects)

    -- If we have exactly one object and it's stairs, return it directly without further filtering
    if #stairsObjects == 1 and stairsObjects[1].type == "Stairs" then
        local stairsObj = stairsObjects[1]
        ---@cast stairsObj -nil
        ZomboDesire.debugLog(MODULE_NAME, "Stairs detected and selected, bypassing all filters")

        ---@diagnostic disable: undefined-field
        return {
            object = stairsObj.object,
            type = stairsObj.type,
            spriteName = stairsObj.spriteName,
            square = stairsObj.square,
            relativeX = stairsObj.relX,
            relativeY = stairsObj.relY
        }
        ---@diagnostic enable: undefined-field
    end

    -- If no stairs or multiple objects, continue with normal filtering

    -- Filter objects based on player position (ignore chairs, couches, etc. if player is behind them)
    local positionFiltered = filterObjectsByPlayerPosition(allDetectedObjects, player)

    -- Post-filtering verification
    if #positionFiltered == 0 then
        ZomboDesire.debugLog(MODULE_NAME, "No objects left after position filtering")
        return nil
    end

    -- Filter objects for outside case (prioritize objects over walls when outside)
    local outsideFiltered = filterObjectsForOutside(positionFiltered, playerIsInside)

    -- Post-filtering verification
    if not playerIsInside and #outsideFiltered == 0 then
        ZomboDesire.debugLog(MODULE_NAME, "No objects left after outside filtering")
        return nil
    end

    -- Filters objects that are behind interior walls relative to the player
    local roomFiltered = filterObjectsBehindInteriorWalls(positionFiltered, player)

    -- Post-filtering verification
    if playerIsInside and #roomFiltered == 0 then
        ZomboDesire.debugLog(MODULE_NAME, "No objects left after room filtering")
        return nil
    end

    -- Filter objects for inside case (prioritize objects over walls when inside)
    local insideFiltered = filterObjectsForInside(roomFiltered, playerIsInside)

    -- Post-filtering verification
    if playerIsInside and #insideFiltered == 0 then
        ZomboDesire.debugLog(MODULE_NAME, "No objects left after inside filtering")
        return nil
    end

    -- Determine which filtered list to use based on player location
    local environmentFilteredList
    if playerIsInside then
        environmentFilteredList = insideFiltered
        ZomboDesire.debugLog(MODULE_NAME, "Using inside filtered list for free space check (%d objects)", #environmentFilteredList)
    else
        environmentFilteredList = outsideFiltered
        ZomboDesire.debugLog(MODULE_NAME, "Using outside filtered list for free space check (%d objects)", #environmentFilteredList)
    end

    -- Filter objects based on free space in front of them
    local freeSpaceFiltered = filterObjectsByFreeSpace(environmentFilteredList, player)

    -- Post-filtering verification
    if #freeSpaceFiltered == 0 then
        ZomboDesire.debugLog(MODULE_NAME, "No objects left after free space filtering")
        return nil
    end

    -- Sort objects by priority
    local sortedObjects = sortObjectsByPriority(freeSpaceFiltered)

    -- Return the highest priority object
    local bestMatch = sortedObjects[1]
    ---@cast bestMatch -nil
    ZomboDesire.debugLog(MODULE_NAME, "Selected object -> %s at relative position %d,%d",
        bestMatch.type, bestMatch.relX, bestMatch.relY)

    ---@diagnostic disable: undefined-field
    return {
        object = bestMatch.object,
        type = bestMatch.type,
        spriteName = bestMatch.spriteName,
        square = bestMatch.square,
        relativeX = bestMatch.relX,
        relativeY = bestMatch.relY
    }
    ---@diagnostic enable: undefined-field
end

-- Return the module
return ZomboDesire_ObjectDetection
