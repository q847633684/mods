--- File: ZomboDesire/42/media/lua/shared/ZombHuman/ZomboDesire_ZombHumanUtils.lua
--- Provides utility functions for ZombHuman entities, including stable ID generation and distance calculations
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_ZombHumanUtils.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Main"

--- Module name for logging
--- @type string
local MODULE_NAME = "ZombHumanUtils"

--- Global module for ZombHuman utility functions
ZomboDesire_ZombHumanUtils = ZomboDesire_ZombHumanUtils or {}

--- Local cache to store generated IDs and avoid redundant bitwise operations
local idcache = {}

--- Converts a number to a table of bits (string representation)
--- @param num integer -- The number to convert to bits
--- @return table -- A table of bit strings representing the number
local function toBits(num)
    if not num then
        ZomboDesire.errorLog(MODULE_NAME, "toBits -> num is nil")
        return {}
    end
    local bits = string.split(string.reverse(Long.toUnsignedString(num, 2)), "")
    while #bits < 16 do bits[#bits+1] = "0" end
    return bits
end

--- Converts a table of bits back into a decimal number
--- @param bits table -- A table of bit strings representing a number
--- @return integer -- The decimal representation of the bits
local function toDec(bits)
    if not bits or #bits == 0 then
        ZomboDesire.errorLog(MODULE_NAME, "toDec -> bits table is empty or nil")
        return 0
    end
    local decimal = Long.parseUnsignedLong(string.reverse(table.concat(bits, "")), 2)
    return decimal
end

--- Generates or retrieves a unique stable ID for a zombie based on its persistent outfit ID
--- @param zombie IsoZombie -- The zombie entity to get the ID from
--- @return integer -- A stable and unique ID for the ZombHuman
function ZomboDesire_ZombHumanUtils.GetZombHumanID(zombie)
    if not zombie then 
        ZomboDesire.errorLog(MODULE_NAME, "GetZombHumanID -> zombie is nil")
        return 0 
    end
    local dec = zombie:getPersistentOutfitID()
    local id = idcache[dec]
    if id then return id end

    ZomboDesire.debugLog(MODULE_NAME, "GetZombHumanID -> Generating new stable ID for persistentOutfitID %d", dec)

    local bits = toBits(dec)
    local hat = bits[16]
    if hat == "1" then
        bits[16] = "0"
        id = toDec(bits)
        ZomboDesire.debugLog(MODULE_NAME, "GetZombHumanID -> Hat bit detected and cleared. New ID: %d", id)
        idcache[dec] = id
    else
        id = dec
        idcache[dec] = id
    end
    return id
end

--- Calculates the Euclidean distance between two points (x1, y1) and (x2, y2)
--- @param x1 number -- X coordinate of the first point
--- @param y1 number -- Y coordinate of the first point
--- @param x2 number -- X coordinate of the second point
--- @param y2 number -- Y coordinate of the second point
--- @return number -- The Euclidean distance between the two points
function ZomboDesire_ZombHumanUtils.DistTo(x1, y1, x2, y2)
    return (((x1 - x2) * (x1 - x2)) + ((y1 - y2) * (y1 - y2))) ^ 0.5
end

return ZomboDesire_ZombHumanUtils
