-- File: ZomboLust/42/media/lua/client/Bukkake/ZomboLust_BukkakeWorld.lua
-- This module handles adding cum textures to the floor and walls
-- Optimized for Build 42 with Chunk-level storage and LoadChunk events
-- Single-player only: getChunkStorage below writes decorative objects directly into
-- chunk-level tile ModData from the client, with no server round-trip.
-- See the Architecture Assumption note in ZomboLust_Main.lua before relying on this in a real network game -
-- it only works today because singleplayer's "server" is the same process as the client.
-- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_BukkakeWorld.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"

local BukkakeWorld = {}
ZomboLust.BukkakeWorld = BukkakeWorld

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local table  = table
local string = string
local math   = math
local abs    = math.abs

-- Module name for logging
--- @type string
local MODULE_NAME = "BukkakeWorld"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

-- Texture lists
-- List of floor textures (26 files)
local floorTextures = table.newarray()
for i = 1, 26 do
    floorTextures[i] = "media/textures/Cum_Floor/Cum_Floor_" .. string.format("%02d", i) .. ".png"
end

-- List of wall textures (26 files)
local wallTextures = table.newarray()
for i = 1, 26 do
    wallTextures[i] = "media/textures/Cum_Wall/Cum_Wall_" .. string.format("%02d", i) .. ".png"
end

-- =============
-- Helpers
-- =============

--- Helper function to set properties for wall overlays
--- @param obj IsoObject -- The object to apply properties to
--- @param wallDir string -- "N" or "W"
local function applyWallOverlayProps(obj, wallDir)
    if not obj or not obj.getProperties then return end
    ---@type PropertyContainer
    local props = obj:getProperties()

    -- Set WallOverlay flag to ensure it renders correctly on walls
    if IsoFlagType and IsoFlagType.WallOverlay then
        props:set(IsoFlagType.WallOverlay)
    end

    -- Attach to North or West wall
    if wallDir == "N" and IsoFlagType.attachedN then
        props:set(IsoFlagType.attachedN)
    elseif wallDir == "W" and IsoFlagType.attachedW then
        props:set(IsoFlagType.attachedW)
    end
end

--- Helper function to check if a square has a wall or fence in a specific direction
--- @param square IsoGridSquare -- The square to check for walls or fences
--- @param wallDir string -- "N" or "W"
--- @return boolean -- Returns true if a wall or fence is found in the specified direction
local function hasWallOrFence(square, wallDir)
    if not square or not square.getProperties then return false end
    local props = square:getProperties()
    if wallDir == "N" then
        return props:has(IsoFlagType.WallN) or props:has(IsoFlagType.HoppableN) or props:has(IsoFlagType.TallHoppableN) or props:has(IsoFlagType.DoorWallN) or props:has(IsoFlagType.WindowN)
    elseif wallDir == "W" then
        return props:has(IsoFlagType.WallW) or props:has(IsoFlagType.HoppableW) or props:has(IsoFlagType.TallHoppableW) or props:has(IsoFlagType.DoorWallW) or props:has(IsoFlagType.WindowW)
    end
    return false
end

--- Get the storage table for a chunk (stored on square 0,0,0 of the chunk)
--- No server authority: writes land directly in the tile's ModData from whichever client calls this.
--- Fine in singleplayer (client == embedded server); would desync in a real network game
--- without an explicit client-request / server-authority / broadcast layer first.
--- @param chunk IsoChunk -- The chunk to get storage for
--- @param createIfMissing boolean -- If true, create the table if it doesn't exist
local function getChunkStorage(chunk, createIfMissing)
    if not chunk then return nil end
    local sq = chunk:getGridSquare(0, 0, 0)
    if not sq then return nil end
    local modData = sq:getModData()
    if not modData.ZL_ChunkTraces then 
        if not createIfMissing then return nil end
        modData.ZL_ChunkTraces = {} 
    end
    return modData.ZL_ChunkTraces
end

-- =============
-- Object Creation
-- =============

--- Internal function to create and add a floor cum object to a square
--- @param targetSquare IsoGridSquare -- The square to add the object to
--- @param spriteName string -- The sprite name for the texture
--- @param forceRefresh boolean -- Force immediate visual refresh
--- @param skipCheck? boolean -- If true, skip the deduplication check (faster for loading chunks)
local function createFloorCumObject(targetSquare, spriteName, forceRefresh, skipCheck)
    -- Deduplication: check if an exact same object already exists
    if not skipCheck then
        local objects = targetSquare:getObjects()
        for i = 0, objects:size() - 1 do
            local obj = objects:get(i)
            if obj:getObjectName() == "CumFloor" and obj:getModData().spriteName == spriteName then
                return obj -- Skip creation
            end
        end
    end

    local sprite = IsoSpriteManager.instance:AddSprite(spriteName)
    if not sprite then
        ZomboLust.errorLog(MODULE_NAME, "addFloorCum: Failed to load sprite %s", spriteName)
        return nil
    end

    -- Create object
    local cum = IsoObject.new(targetSquare, spriteName, "CumFloor", false)
    cum:setSprite(sprite)

    -- Save sprite name in the object's own ModData for identification
    cum:getModData().spriteName = spriteName

    -- Set dirty yellow color (r:0.8, g:0.7, b:0.4)
    cum:setCustomColor(0.8, 0.7, 0.4, 0.5)

    -- Fix the "floating" issue by forcing a vertical offset in the render
    -- -95 is the perfect value to place it 1 pixel above the floor (-96)
    if cum.setRenderYOffset then
        cum:setRenderYOffset(-95)
    end

    -- The SetOverlaySprite method displays the texture in the air despite its renderYOffset parameter
    -- The DoSplat method does not display any texture because, although exposed in Lua, it probably
    -- only works with blood textures managed in Java

    -- Add to square
    targetSquare:AddTileObject(cum)

    -- Force immediate visual refresh
    ---@diagnostic disable-next-line: undefined-field
    if forceRefresh and targetSquare.recalcBitMaps then
        ---@diagnostic disable-next-line: undefined-field
        targetSquare:recalcBitMaps()
    end
    return cum
end

--- Internal function to create and add a wall cum object to a square
--- @param targetSquare IsoGridSquare -- The square to add the object to
--- @param spriteName string -- The sprite name for the texture
--- @param wallDir string -- The wall direction ("N" or "W")
--- @param forceRefresh boolean -- Force immediate visual refresh
--- @param skipCheck? boolean -- If true, skip the deduplication check (faster for loading chunks)
local function createWallCumObject(targetSquare, spriteName, wallDir, forceRefresh, skipCheck)
    -- Deduplication: check if an exact same object already exists
    if not skipCheck then
        local objects = targetSquare:getObjects()
        for i = 0, objects:size() - 1 do
            local obj = objects:get(i)
            if obj:getObjectName() == "CumWall" and obj:getModData().spriteName == spriteName then
                return obj -- Skip creation
            end
        end
    end

    local sprite = IsoSpriteManager.instance:AddSprite(spriteName)
    if not sprite then
        ZomboLust.errorLog(MODULE_NAME, "addWallCum: Failed to load sprite %s", spriteName)
        return nil
    end

    -- Apply wall properties directly to the Sprite
    local sprops = sprite:getProperties()
    if sprops and sprops.set then
        sprops:set(IsoFlagType.WallOverlay)
        if wallDir == "N" then
            sprops:set(IsoFlagType.attachedN)
        elseif wallDir == "W" then
            sprops:set(IsoFlagType.attachedW)
        end
    end

    -- Create object
    local cum = IsoObject.new(targetSquare, spriteName, "CumWall", false)
    cum:setSprite(sprite)

    -- Save sprite name in the object's own ModData for identification
    cum:getModData().spriteName = spriteName

    -- Set dirty yellow color (r:0.8, g:0.7, b:0.4)
    cum:setCustomColor(0.8, 0.7, 0.4, 0.5)

    -- Set vertical offset to apply the texture on the wall at characters' pubis/hips level
    if cum.setRenderYOffset then
        cum:setRenderYOffset(-63)
    end

    -- Apply wall-specific object flags (attachment N or W)
    applyWallOverlayProps(cum, wallDir)

    targetSquare:AddTileObject(cum)

    -- Force immediate visual refresh
    ---@diagnostic disable-next-line: undefined-field
    if forceRefresh and targetSquare.recalcBitMaps then
        ---@diagnostic disable-next-line: undefined-field
        targetSquare:recalcBitMaps()
    end
    return cum
end

-- =============
-- Public API
-- =============

--- Adds a cum texture to the floor near the character
--- @param character IsoGameCharacter -- The character triggering the event
function BukkakeWorld.addFloorCum(character)
    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "addFloorCum triggered for: " .. (character and character:getFullName() or "nil"))
    end

    if not character then 
        ZomboLust.errorLog(MODULE_NAME, "addFloorCum: Character is nil")
        return 
    end

    local targetSquare = character:getSquare()
    if not targetSquare then 
        ZomboLust.errorLog(MODULE_NAME, "addFloorCum: Character square is nil for %s", character:getFullName())
        return 
    end

    -- Pick a random floor texture
    local spriteName = floorTextures[ZombRand(1, #floorTextures + 1)]
    ---@cast spriteName string

    -- Create the object
    if createFloorCumObject(targetSquare, spriteName, true) then
        -- Save for persistence
        local storage = getChunkStorage(targetSquare:getChunk(), true)
        if storage then
            table.insert(storage, { x = targetSquare:getX() % 10, y = targetSquare:getY() % 10, z = targetSquare:getZ(), s = spriteName, t = "f" })
            if dbg() then
                ZomboLust.debugLog(MODULE_NAME, "Successfully added floor cum texture: %s at square [%d, %d]", spriteName, targetSquare:getX(), targetSquare:getY())
            end
        end
    end
end

--- Adds a cum texture to a nearby wall or fence
--- @param character IsoGameCharacter -- The character triggering the event
function BukkakeWorld.addWallCum(character)
    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "addWallCum triggered for: " .. (character and character:getFullName() or "nil"))
    end

    if not character then 
        ZomboLust.errorLog(MODULE_NAME, "addWallCum: Character is nil")
        return 
    end

    local square = character:getSquare()
    if not square then 
        ZomboLust.errorLog(MODULE_NAME, "addWallCum: Character square is nil for %s", character:getFullName())
        return 
    end

    local wallDir = nil
    local targetSquare = nil

    -- 1. Check current square for walls
    if hasWallOrFence(square, "N") then
        wallDir = "N"
        targetSquare = square
        ZomboLust.debugLog(MODULE_NAME, "addWallCum: Wall found on current square (N)")
    elseif hasWallOrFence(square, "W") then
        wallDir = "W"
        targetSquare = square
        ZomboLust.debugLog(MODULE_NAME, "addWallCum: Wall found on current square (W)")
    else
        -- 2. Check facing direction for walls on adjacent squares
        local dir = character:getDir()
        local x = square:getX()
        local y = square:getY()
        local z = square:getZ()

        if dbg() then
            ZomboLust.debugLog(MODULE_NAME, "addWallCum: Scanning adjacent squares for walls in direction %s", tostring(dir))
        end

        if dir == IsoDirections.N or dir == IsoDirections.NE or dir == IsoDirections.NW then
            local n = getCell():getGridSquare(x, y - 1, z)
            if hasWallOrFence(n, "N") then
                wallDir = "N"
                targetSquare = n
            end
        elseif dir == IsoDirections.W or dir == IsoDirections.NW or dir == IsoDirections.SW then
            local w = getCell():getGridSquare(x - 1, y, z)
            if hasWallOrFence(w, "W") then
                wallDir = "W"
                targetSquare = w
            end
        elseif dir == IsoDirections.S or dir == IsoDirections.SE or dir == IsoDirections.SW then
            -- A wall to the South is technically the North wall of the square below
            local s = getCell():getGridSquare(x, y + 1, z)
            if hasWallOrFence(s, "N") then
                wallDir = "N"
                targetSquare = s
            end
        elseif dir == IsoDirections.E or dir == IsoDirections.NE or dir == IsoDirections.SE then
            -- A wall to the East is technically the West wall of the square to the right
            local e = getCell():getGridSquare(x + 1, y, z)
            if hasWallOrFence(e, "W") then
                wallDir = "W"
                targetSquare = e
            end
        end
    end

    -- 3. If a wall is found, apply the texture
    if targetSquare and wallDir then
        ZomboLust.debugLog(MODULE_NAME, "addWallCum: Wall found on adjacent square (%s)", wallDir)
        local spriteName = wallTextures[ZombRand(1, #wallTextures + 1)]
        ---@cast spriteName string

        -- Create the object
        if createWallCumObject(targetSquare, spriteName, wallDir, true) then
            -- Save for persistence
            local storage = getChunkStorage(targetSquare:getChunk(), true)
            if storage then
                table.insert(storage, { x = targetSquare:getX() % 10, y = targetSquare:getY() % 10, z = targetSquare:getZ(), s = spriteName, t = "w", d = wallDir })
                if dbg() then
                    ZomboLust.debugLog(MODULE_NAME, "Successfully added wall cum texture: %s on %s wall at [%d, %d]", spriteName, wallDir, targetSquare:getX(), targetSquare:getY())
                end
            end
        end
    else
        -- If no wall was found, do nothing
        ZomboLust.debugLog(MODULE_NAME, "No wall found nearby, doing nothing")
    end
end

-- =============
-- Events
-- =============

-- The base game does not use LoadGridsquare for blood.
-- Blood is handled natively in the game's Java engine.
-- It is stored as a direct property of the tile (IsoGridSquare), not in modData. That’s why it is so smooth.
-- I cannot reproduce this exact behavior without modifying the game’s Java code.

--- Event handler for loading a chunk. Recreates cum textures for all squares in the chunk.
--- @param chunk IsoChunk -- The chunk being loaded
local function onLoadChunk(chunk)
    if not chunk then return end

    -- Distance check: only process chunks within 8 chunks (80 tiles) of the player
    -- This prevents the World Map from processing thousands of chunks at once
    local player = getSpecificPlayer(0)
    if player then
        local px, py = player:getX(), player:getY()
        -- Safely get chunk world coordinates from its base square (0,0,0)
        local baseSq = chunk:getGridSquare(0, 0, 0)
        if baseSq then
            local cx, cy = baseSq:getX(), baseSq:getY()
            if abs(px - cx) > 80 or abs(py - cy) > 80 then return end
        end
    end

    -- Security: Skip processing if the world map is open to prevent massive lag/freeze
    ---@diagnostic disable-next-line: undefined-global
    if ISWorldMap_instance and ISWorldMap_instance:isVisible() then return end

    -- Optimized Chunk Loading: pass false to NOT create empty tables
    local storage = getChunkStorage(chunk, false)
    if storage then
        -- Recreate each texture saved (Numerical loop is faster than ipairs)
        for i = 1, #storage do
            local data = storage[i]
            if data then
                local sq = chunk:getGridSquare(data.x, data.y, data.z)
                if sq then
                    if data.t == "f" then 
                        -- Pass true to skipCheck: square is brand new and empty of our objects
                        createFloorCumObject(sq, data.s, false, true)
                    elseif data.t == "w" and data.d then 
                        -- Pass true to skipCheck: square is brand new and empty of our objects
                        createWallCumObject(sq, data.s, data.d, false, true) 
                    end
                end
            end
        end
    end
end

-- Track event status
local isLoadChunkActive = true

--- Disables the LoadChunk event
function BukkakeWorld.disableLoadChunk()
    if isLoadChunkActive then
        Events.LoadChunk.Remove(onLoadChunk)
        isLoadChunkActive = false
        ZomboLust.debugLog(MODULE_NAME, "Events.LoadChunk disabled (World Map open)")
    end
end

--- Enables the LoadChunk event
function BukkakeWorld.enableLoadChunk()
    if not isLoadChunkActive then
        Events.LoadChunk.Add(onLoadChunk)
        isLoadChunkActive = true
        ZomboLust.debugLog(MODULE_NAME, "Events.LoadChunk enabled (World Map closed)")
    end
end

-- Register event (LoadChunk is called once per 10x10 chunk)
Events.LoadChunk.Add(onLoadChunk)

-- Hook into World Map to toggle the event
local function initWorldMapHooks()
    if not ISWorldMap then return end

    -- Hook static ShowWorldMap
    local original_ShowWorldMap = ISWorldMap.ShowWorldMap
    ISWorldMap.ShowWorldMap = function(...)
        BukkakeWorld.disableLoadChunk()
        return original_ShowWorldMap(...)
    end

    -- Hook static HideWorldMap (called by radial menu/keys)
    local original_HideWorldMap = ISWorldMap.HideWorldMap
    ISWorldMap.HideWorldMap = function(...)
        local res = original_HideWorldMap(...)
        BukkakeWorld.enableLoadChunk()
        return res
    end

    -- Hook the instance method close() to catch UI close button (X) and ESC key
    local original_close = ISWorldMap.close
    ISWorldMap.close = function(self)
        local res = original_close(self)
        BukkakeWorld.enableLoadChunk()
        return res
    end

    ZomboLust.debugLog(MODULE_NAME, "World Map hooks fully initialized (Static + Close)")
end

-- Wait for game start to ensure ISWorldMap is available
Events.OnGameStart.Add(initWorldMapHooks)

return BukkakeWorld
