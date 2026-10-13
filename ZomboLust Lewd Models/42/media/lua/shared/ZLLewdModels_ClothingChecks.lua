--- File: ZomboLust Lewd Models/42/media/lua/shared/ZLLewdModels_ClothingChecks.lua
--- Handles logic for checking if body parts are covered by clothing
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust Lewd Models LOADING] ZLLewdModels_ClothingChecks.lua loaded")

-- Module name for logging
--- @type string
local MODULE_NAME = "ClothingChecks"

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
local table = table

-- Module Initialization
--- @class zlClothingChecks
local zlClothingChecks = {}

--- @type table<string, string[]>
local areaLocations = {
    Legs = {
        "PANTS", "PANTS_SKINNY", "PANTS_EXTRA", "SHORT_PANTS", "SHORTS_SHORT", 
        "SKIRT", "LONG_SKIRT", "DRESS", "LONG_DRESS", "FULL_SUIT", "BOILERSUIT", 
        "FULL_SUIT_HEAD", "LEGS1", "TORSO1LEGS1", "SOCKS", "SHOES", 
        "BATH_ROBE", "FULL_ROBE", "BODY_COSTUME"
    },
    Pubic = {
        "PANTS", "PANTS_SKINNY", "PANTS_EXTRA", "SHORT_PANTS", "SHORTS_SHORT", 
        "SKIRT", "LONG_SKIRT", "DRESS", "LONG_DRESS", "FULL_SUIT", "BOILERSUIT", 
        "FULL_SUIT_HEAD", "LEGS1", "TORSO1LEGS1", "UNDERWEAR_BOTTOM", "UNDERWEAR",
        "BATH_ROBE", "FULL_ROBE", "BODY_COSTUME"
    },
    Armpits = {
        "TSHIRT", "SHORT_SLEEVE_SHIRT", "SHIRT", "SWEATER", "SWEATER_HAT", 
        "JACKET", "JACKET_DOWN", "JACKET_BULKY", "JACKET_HAT", "JACKET_HAT_BULKY", 
        "JACKET_SUIT", "FULL_SUIT", "BOILERSUIT", "FULL_SUIT_HEAD", "DRESS", 
        "LONG_DRESS", "TANK_TOP", "TORSO1", "TORSO1LEGS1", "BATH_ROBE", 
        "FULL_ROBE", "BODY_COSTUME", "FULL_TOP", "UNDERWEAR_TOP"
    },
    Head = {
        "HAT", "FULL_HAT"
    }
}

--- Checks if a specific body area is covered by any clothing item
--- @param player IsoPlayer -- The player to check
--- @param area string -- "Legs", "Pubic", "Armpits" or "Head"
--- @return boolean -- True if the area is covered
function zlClothingChecks.isAreaCovered(player, area)
    local ItemBodyLocation = ItemBodyLocation
    local locations = areaLocations[area]
    if not locations then return false end

    for i = 1, #locations do
        local locID = locations[i]
        local bodyLoc = ItemBodyLocation[locID]
        if bodyLoc then
            ---@cast bodyLoc ItemBodyLocation
            local item = player:getWornItem(bodyLoc)
            if item then
                -- Check if it's an exception (some items might technically occupy a slot but not cover it,
                -- but for shaving we usually want it bare)
                if dbg() then
                    ZLLewdModels.debugLog(MODULE_NAME, "Area %s is covered by %s at %s", area, item:getFullType(), locID)
                end
                return true
            end
        end
    end

    return false
end

--- Returns a list of items covering a specific area
--- @param player IsoPlayer -- The player to check
--- @param area string -- "Legs", "Pubic", "Armpits" or "Head"
--- @return InventoryItem[] -- List of covering items
function zlClothingChecks.getCoveringItems(player, area)
    local ItemBodyLocation = ItemBodyLocation
    local items = {}
    local locations = areaLocations[area]
    if not locations then return items end

    for i = 1, #locations do
        local locID = locations[i]
        local bodyLoc = ItemBodyLocation[locID]
        if bodyLoc then
            ---@cast bodyLoc ItemBodyLocation
            local item = player:getWornItem(bodyLoc)
            if item then
                table.insert(items, item)
            end
        end
    end
    return items
end

return zlClothingChecks
