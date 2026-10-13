-- File: ZomboLust/42/media/lua/client/ZomboLust_Innocent.lua
-- Passive panic effect for the Innocent trait: panic rises while outdoors with
-- nothing left to strip (see ZomboLust_ClothingStrip.hasClothingToRemove).
-- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_Innocent.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"
require "Clothing/ZomboLust_ClothingStrip"

--- @class ZomboLust_Innocent
local ZomboLust_Innocent = {}

-- Module name for logging
--- @type string
local MODULE_NAME = "Innocent"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

-- Panic gained per frame while outdoors with no removable clothing left, scaled by game speed.
-- ~1 panic/sec at normal speed -> roughly 90s of continuous exposure to go from 0 to Terrified (100)
-- Runs UNTHROTTLED (every OnPlayerUpdate call, see internalPanic below): the engine decays
-- PANIC on its own each frame when nothing it recognizes justifies it (same class of issue
-- as Discomfort's internalDiscomfort countermeasure in ZomboLust_Physiology.lua and the Wimp
-- Stress push in ZomboLust_ExcitationSystem.lua) - a throttled push here would get eroded
-- between our updates.
ZomboLust_Innocent.OutdoorNudePanicGainPerTick = 0.02

-- Internal tracking to bypass engine stat reset/conflicts (same pattern as internalDiscomfort)
--- @type number
local internalPanic = -1

--- Apply passive panic while outdoors with no removable clothing left
--- @param player IsoPlayer
local function applyOutdoorNudePanic(player)
    local stats = player:getStats()
    local sq = player:getSquare()

    if not sq or not sq:isOutside() or ZomboLust_ClothingStrip.hasClothingToRemove(player) then
        -- Condition no longer met: stop fighting the engine, let PANIC decay/behave normally
        internalPanic = -1
        return
    end

    -- Initialize from the live value the first frame the condition becomes true
    if internalPanic < 0 then
        internalPanic = stats:get(CharacterStat.PANIC)
    end

    if internalPanic < 100.0 then
        local increase = ZomboLust_Innocent.OutdoorNudePanicGainPerTick * getGameTime():getMultiplier()
        internalPanic = math.min(100.0, internalPanic + increase)
        stats:set(CharacterStat.PANIC, internalPanic)

        ZomboLust.debugLog(MODULE_NAME, "applyOutdoorNudePanic -> +%.3f panic (outdoors, nothing left to strip) -> %.2f", increase, internalPanic)
    end
end

--- Main dispatcher, called on every player update
--- @param player IsoPlayer
function ZomboLust_Innocent.onPlayerUpdate(player)
    if not player or player:isDead() or player:isZombie() then
        -- internalPanic is a module-local, not per-player modData
        -- (single-player only, see the Architecture Assumption note in ZomboLust_Main.lua): without this reset it would survive
        -- the death check below and leak into the next character created in the same session (see applyOutdoorNudePanic's own reset above).
        internalPanic = -1
        return
    end

    local trait = ZomboLustRegistries.Traits.Innocent
    if not trait or not player:hasTrait(trait) then
        internalPanic = -1
        return
    end

    applyOutdoorNudePanic(player)
end

Events.OnPlayerUpdate.Add(ZomboLust_Innocent.onPlayerUpdate)

return ZomboLust_Innocent
