-- File: ZomboLust/42/media/lua/client/Excitation/ZomboLust_ExcitationSwinger.lua
-- Swinger trait partner-count side of the Excitation system:
-- tracks how many partners the player has had in the current 24h window, resetting at midnight.
-- The resulting pheromone multiplier is applied in ZomboLust_ExcitationSystem.lua's PheromoneTraitMultipliers.
-- Single-player only: resetSwingerPartnerCount hardcodes getSpecificPlayer(0), see the Architecture Assumption note in ZomboLust_Main.lua
-- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_ExcitationSwinger.lua loaded")

---@diagnostic disable: inject-field
-- =============
-- Dependencies
-- =============
require "Excitation/ZomboLust_ExcitationSystem"

-- Module name for logging
--- @type string
local MODULE_NAME = "ExcitationSystem"

-- ==================
-- Utility Functions
-- ==================

--- Gets the current Swinger partner count (resets daily) for the player
--- @param player IsoPlayer
--- @return number
function ZomboLust_ExcitationSystem.getSwingerPartnerCount(player)
    if not player then return 0 end
    local modData = player:getModData()
    modData.ZL_SwingerPartnerCount = modData.ZL_SwingerPartnerCount or 0
    return modData.ZL_SwingerPartnerCount
end

--- Increments the Swinger partner count for the player by 1 (called on mini-game success)
--- @param player IsoPlayer
function ZomboLust_ExcitationSystem.incrementSwingerPartnerCount(player)
    if not player then return end
    local modData = player:getModData()
    modData.ZL_SwingerPartnerCount = ZomboLust_ExcitationSystem.getSwingerPartnerCount(player) + 1

    ZomboLust.debugLog(MODULE_NAME, "Swinger partner count incremented to %d", modData.ZL_SwingerPartnerCount)
end

-- =================
-- Event Management
-- =================

--- Resets the Swinger partner count for a new 24h window (called at midnight)
local function resetSwingerPartnerCount()
    local player = getSpecificPlayer(0)
    if not player then return end
    local modData = player:getModData()
    modData.ZL_SwingerPartnerCount = 0

    ZomboLust.debugLog(MODULE_NAME, "Swinger partner count reset for new day")
end

Events.EveryDays.Add(resetSwingerPartnerCount)

print("[ZomboLust] Excitation Swinger Initialized")
