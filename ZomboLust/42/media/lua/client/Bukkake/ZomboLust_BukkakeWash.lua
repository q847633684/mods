-- File: ZomboLust/42/media/lua/client/Bukkake/ZomboLust_BukkakeWash.lua
-- This implements the Bukkake cleaning feature to the ISWashYourself action
-- @author BlaBla 2026 (based on Timers 2025)

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_BukkakeWash.lua loaded (ISWashYourself extended)")

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"
local BukkakeHandler = require("Bukkake/ZomboLust_Bukkake")

-- Module name for logging
--- @type string
local MODULE_NAME = "BukkakeWash"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

-- Cache the original functions
local original_ISWashYourself_complete = ISWashYourself.complete
local original_ISWashYourself_GetRequiredWater = ISWashYourself.GetRequiredWater

--- Overriding complete to include Bukkake cleaning
--- @return boolean -- Returns true if the washing action is completed successfully
---@diagnostic disable-next-line: duplicate-set-field
function ISWashYourself:complete()
    -- Execute original game logic
    local success = original_ISWashYourself_complete(self)

    -- If cleaning was successful, remove all Bukkake layers
    if success then
        if dbg() then
            ZomboLust.debugLog(MODULE_NAME, "Character washed, cleaning all Bukkake layers for: %s", self.character:getFullName())
        end
        BukkakeHandler:cleanAllLayers(self.character)
    end

    return success
end

--- Overriding GetRequiredWater to include Bukkake coverage cost
--- @param character IsoGameCharacter -- The character to check
--- @return integer -- Returns the amount of water units required, including Bukkake cost
function ISWashYourself.GetRequiredWater(character)
    -- Get original water cost (blood/dirt)
    local units = original_ISWashYourself_GetRequiredWater(character)

    -- Calculate extra cost from Bukkake layers
    local coverage = BukkakeHandler:quantityPercentage(character)
    local extraUnits = 0

    if coverage >= 1.0 then 
        extraUnits = 3
    elseif coverage >= 0.5 then
        extraUnits = 2
    elseif coverage > 0.0 then
        extraUnits = 1
    end

    if extraUnits > 0 then
        ZomboLust.debugLog(MODULE_NAME, "Extra water cost for Bukkake coverage (%.2f%%): +%d units", coverage * 100, extraUnits)
    end

    units = units + extraUnits

    ---@cast units integer
    return units
end
