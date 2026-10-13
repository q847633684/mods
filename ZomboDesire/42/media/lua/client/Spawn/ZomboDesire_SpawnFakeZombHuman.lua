--- File: ZomboDesire/42/media/lua/client/Spawn/ZomboDesire_SpawnFakeZombHuman.lua
--- This module provides functionality to spawn a zombie and immediately transform it into a ZombHuman
--- for testing and debugging purposes.
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_SpawnFakeZombHuman.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Main"
local ZomboDesire_TransformZombHuman = require "Transform/ZomboDesire_TransformZombHuman"

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local pi    = math.pi
local cos   = math.cos
local sin   = math.sin
local floor = math.floor

--- Module name for logging
--- @type string
local MODULE_NAME = "SpawnFakeZombHuman"

--- Module table
local ZomboDesire_SpawnFakeZombHuman = {}

--- Calculates a random spawn position around the player
--- @param player IsoPlayer -- The player around which to generate the position
--- @return table -- Table containing the x, y, z coordinates of the spawn position
local function calculateRandomSpawnPosition(player)
    local playerX, playerY, playerZ = player:getX(), player:getY(), player:getZ()

    -- Define the min and max radius for random spawn (in tiles)
    local minSpawnRadius = 3
    local maxSpawnRadius = 8

    -- Generate a random radius between min and max
    local radiusRange = (maxSpawnRadius - minSpawnRadius) * 100
    local randomOffset = ZombRand(radiusRange + 1) / 100
    local radius = minSpawnRadius + randomOffset

    -- Generate a random angle in radians (0 to 2π)
    local angleInDegrees = ZombRand(360)
    local angle = angleInDegrees * pi / 180

    -- Calculate offset
    local offsetX = radius * cos(angle)
    local offsetY = radius * sin(angle)

    -- Calculate final spawn position
    local x = playerX + offsetX
    local y = playerY + offsetY
    local z = playerZ

    ZomboDesire.debugLog(MODULE_NAME, "Spawning near player -> player position (%.2f, %.2f, %d), offset (%.2f, %.2f), final position (%.2f, %.2f, %d)",
        playerX, playerY, playerZ, offsetX, offsetY, x, y, z)

    return {x = x, y = y, z = z}
end

--- Spawns a zombie and transforms it into a ZombHuman
--- @param _worldObjects table|any -- Context menu world objects (unused)
--- @param playerIndex number -- Index of the player (default: 0)
--- @param visualPreset table|nil -- Optional visual preset
--- @return IsoZombie|nil -- The spawned and transformed zombie
function ZomboDesire_SpawnFakeZombHuman.spawnFakeZombHuman(_worldObjects, playerIndex, visualPreset)
    -- Retrieve the local player
    local player = getSpecificPlayer(floor(playerIndex or 0))
    if not player then
        ZomboDesire.errorLog(MODULE_NAME, "No player found")
        return nil
    end

    -- Calculate random spawn position
    local pos = calculateRandomSpawnPosition(player)
    local square = getCell():getGridSquare(pos.x, pos.y, pos.z)
    if not square then
        ZomboDesire.errorLog(MODULE_NAME, "Invalid square at spawn position")
        return nil
    end

    -- Create zombie at location
    local female = false
    if visualPreset and visualPreset.female ~= nil then
        female = visualPreset.female
    else
        female = (ZombRand(2) == 0)
    end

    local femaleChance = female and 100 or 0
    local zlist = addZombiesInOutfit(pos.x, pos.y, pos.z, 1, "", femaleChance, false, false, false, false, false, false, 1.0)
    
    -- Optimize Java list access
    local zombie = nil
    if zlist and zlist:size() > 0 then
        zombie = zlist:get(0)
    end

    if not zombie then
        ZomboDesire.errorLog(MODULE_NAME, "Failed to spawn zombie at (%.2f, %.2f, %d)", pos.x, pos.y, pos.z)
        return nil
    end

    -- Apply visual preset if provided
    if visualPreset then
        local visual = zombie:getHumanVisual()
        zombie:setFemale(visualPreset.female)
        visual:setSkinTextureIndex(visualPreset.skin or 0)
        visual:setHairModel(visualPreset.hairType or "")
        if not visualPreset.female then
            visual:setBeardModel(visualPreset.beardType or "")
        end

        -- Note: Clothing would require adding items to inventory and wearing them
        -- For a debug spawn, we keep it simple for now or you could use zombie:getInventory():addItem(...)
    end

    zombie:resetModelNextFrame()

    -- Transform into ZombHuman
    local success = ZomboDesire_TransformZombHuman.transformZombieIntoZombHuman(zombie)
    if success then
        ZomboDesire.debugLog(MODULE_NAME, "Fake ZombHuman spawned and transformed successfully")
        return zombie
    else
        ZomboDesire.errorLog(MODULE_NAME, "Failed to transform spawned zombie into ZombHuman")
        return nil
    end
end

return ZomboDesire_SpawnFakeZombHuman
