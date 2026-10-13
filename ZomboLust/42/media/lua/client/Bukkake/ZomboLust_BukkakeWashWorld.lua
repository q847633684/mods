-- File: ZomboLust/42/media/lua/client/Bukkake/ZomboLust_BukkakeWashWorld.lua
-- This module implements cleaning world cum textures (floor/walls)
-- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_BukkakeWashWorld.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"
require "TimedActions/ISZomboLustWashWorld"

local BukkakeWashWorld = {}
ZomboLust.BukkakeWashWorld = BukkakeWashWorld

-- Module name for logging
--- @type string
local MODULE_NAME = "BukkakeWashWorld"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

-- Constants for cleaning costs
local WATER_UNIT_COST = 0.1 -- Amount of fluid units per trace
local WATER_UNIT_COST_SOAP = 0.05 -- Reduced cost with soap

-- =====================================
-- Predicates (B42 Fluid System & Tags)
-- =====================================

--- Check if an item is a suitable absorbent (has base:cleanstains tag)
--- @param item InventoryItem -- The item to check
--- @return boolean -- True if the item is a valid absorbent
local function predicateAbsorbent(item)
    return item:hasTag(ItemTag.CLEAN_STAINS) and not item:isBroken()
end

--- Check if an item contains water or tainted water
--- @param item InventoryItem -- The item to check
--- @return boolean -- True if the item contains water
local function predicateWater(item)
    local fc = item:getFluidContainer()
    return fc and (fc:contains(Fluid.Water) or fc:contains(Fluid.TaintedWater)) and fc:getAmount() >= 0.05
end

--- Check if an item is a cleaning agent (Soap, CleaningLiquid, or Bleach)
--- @param item InventoryItem -- The item to check
--- @return boolean -- True if the item is a valid cleaning agent
local function predicateCleaningAgent(item)
    -- Solid soap (Drainable)
    if item:getType() == "Soap2" then
        return item:getCurrentUses() > 0
    end
    -- Fluid containers (CleaningLiquid or Bleach)
    local fc = item:getFluidContainer()
    return fc and (fc:contains(Fluid.CleaningLiquid) or fc:contains(Fluid.Bleach)) and fc:getAmount() >= 0.05
end

-- ===========
-- Main Logic
-- ===========

--- Finds a cum object (floor or wall) on a square
--- @param square IsoGridSquare -- The square to check for traces
--- @return IsoObject|nil -- The cum object if found, otherwise nil
function BukkakeWashWorld.getTraceOnSquare(square)
    if not square then return nil end
    local objects = square:getObjects()
    local size = objects:size()
    for i = 0, size - 1 do
        local obj = objects:get(i)
        local name = obj:getName()
        if name == "CumFloor" or name == "CumWall" then
            return obj
        end
    end
    return nil
end

--- Callback for the context menu option
--- @param worldobjects table -- The objects under the mouse click
--- @param player integer -- The player index
--- @param square IsoGridSquare -- The square where the trace is located
--- @param trace IsoObject -- The cum trace object to clean
--- @param absorbent InventoryItem -- The item used to wipe the trace
--- @param water InventoryItem -- The item containing water for cleaning
--- @param cleaningAgent InventoryItem|nil -- Optional cleaning agent (soap, bleach, etc.)
local function onCleanTrace(worldobjects, player, square, trace, absorbent, water, cleaningAgent)
    local playerObj = getSpecificPlayer(player)
    if not playerObj then return end

    -- Check if we're close enough (standard 2 tiles)
    if luautils.walkAdj(playerObj, square) then
        ISTimedActionQueue.add(ISZomboLustWashWorld:new(playerObj, square, trace, absorbent, water, cleaningAgent))
        if dbg() then
            ZomboLust.debugLog(MODULE_NAME, "Cleaning action queued for square [%d, %d]", square:getX(), square:getY())
        end
    end
end

--- Hook for context menu
--- @param player integer -- The player index
--- @param context ISContextMenu -- The context menu being filled
--- @param worldobjects table -- The objects at the click location
local function onFillWorldObjectContextMenu(player, context, worldobjects)
    ---@diagnostic disable
    local playerObj = getSpecificPlayer(player)
    if not playerObj or playerObj:getVehicle() then return end

    local square = nil
    for i = 1, #worldobjects do
        local obj = worldobjects[i]
        square = obj:getSquare()
        if square then break end
    end

    if not square then return end

    -- 1. Check if there's a trace on this square
    local trace = BukkakeWashWorld.getTraceOnSquare(square)
    if not trace then
        if dbg() then
            ZomboLust.debugLog(MODULE_NAME, "No cum trace found on square [%d, %d]", square:getX(), square:getY())
        end
        return
    end

    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "Found cum trace '%s' on square [%d, %d]", trace:getName(), square:getX(), square:getY())
    end

    -- 2. Check for required items
    local inventory = playerObj:getInventory()
    local absorbent = inventory:getFirstTagEval(ItemTag.CLEAN_STAINS, predicateAbsorbent)
    local water = inventory:getFirstEvalRecurse(predicateWater)
    local cleaningAgent = inventory:getFirstEvalRecurse(predicateCleaningAgent)

    if not absorbent then
        ZomboLust.debugLog(MODULE_NAME, "Missing absorbent tool")
    end
    if not water then
        ZomboLust.debugLog(MODULE_NAME, "Missing water container")
    end
    if cleaningAgent then
        if dbg() then
            ZomboLust.debugLog(MODULE_NAME, "Cleaning agent found: %s", cleaningAgent:getType())
        end
    end

    -- 3. Add option if we have the basics (Absorbent + Water)
    local optionText = getText("ContextMenu_ZomboLust_Clean_Cum_Trace") or "Clean ejaculation traces"
    local option = context:addOption(optionText, worldobjects, onCleanTrace, player, square, trace, absorbent, water, cleaningAgent)

    -- Tooltip logic if missing items
    if not absorbent or not water then
        option.notAvailable = true
        local tooltip = ISWorldObjectContextMenu.addToolTip()
        tooltip:setName(optionText)
        local colorRed = " <RGB:1,0,0> "
        local colorGreen = " <RGB:1,1,1> "

        local text = ""
        text = text .. (absorbent and colorGreen or colorRed) .. (getText("Tooltip_ZomboLust_Need_Absorbent") or "Absorbent needed (Bath towel, Dish cloth, Sponge, Broom, Mop)") .. " <LINE> "
        text = text .. (water and colorGreen or colorRed) .. (getText("Tooltip_ZomboLust_Need_Water") or "Water needed (Optional: Soap, Bleach)") .. " <LINE> "

        tooltip.description = text
        option.toolTip = tooltip
    end
    ---@diagnostic enable
end

-- Events
Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)

return BukkakeWashWorld
