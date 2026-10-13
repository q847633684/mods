--- File: ZomboLust/42/media/lua/client/Encounter/ZomboLust_SexualIntentSystem.lua
--- Determines, ahead of contact, whether an opposite-gender zombie approaching a fully
--- undressed player will trigger a sexual animation or a normal bite attempt once it
--- reaches the player. Gives the player an early visual cue (pink outline) for zombies
--- that have been "elected" to trigger the sexual animation.
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_SexualIntentSystem.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"
local ZomboLust_ClothingStrip = require "Clothing/ZomboLust_ClothingStrip"

-- Module name for logging
--- @type string
local MODULE_NAME = "SexualIntent"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

-- ================
-- Module Namespace
-- ================
--- Main namespace
--- @type table
ZomboLust_SexualIntentSystem = ZomboLust_SexualIntentSystem or {}

-- Default chance (%) that an elected zombie bites instead of triggering the sexual animation, once the player has nothing left to strip.
-- Only used as a fallback (see getBiteChance below) before the "biteChance" mod option slider
-- (registered in ZomboLust_ModOptions.lua) has finished loading.
ZomboLust_SexualIntentSystem.BiteChance = 35

-- Per-zombie roll cache, keyed by the zombie object itself (same pattern as ZomboDesire.neutralizedZombies in ZomboDesire_Intercept.lua)
--- @type table<IsoZombie, {elected: boolean, lastSeenTick: number, player: IsoPlayer}>
ZomboLust_SexualIntentSystem.zombieIntent = {}

-- Incremented once per throttled scan pass (see ZomboLust_ExcitationSystem.updateExcitation);
-- used to detect zombies that fell out of proximity range since the previous pass
--- @type number
ZomboLust_SexualIntentSystem.scanTick = 0

-- ==================
-- Highlight helpers
-- ==================

--- Apply the pink outline used to signal an "elected" zombie (about to trigger the sexual animation)
--- Same color language as ZomboLust_OrgasmSystem.onOrgasmCountdownTick, applied to the zombie instead of the player
--- @param player IsoPlayer -- The observing player (drives per-splitscreen-player visibility)
--- @param zombie IsoZombie -- The elected zombie
local function applyHighlight(player, zombie)
    -- getIndex() is the non-deprecated replacement for the old getPlayerNum()
    -- (same integer split-screen slot, see Umbrella's IsoPlayer.lua @deprecated tag on getPlayerNum)
    local playerNum = player:getIndex()
    zombie:setHighlighted(playerNum, true, false)
    zombie:setHighlightColor(playerNum, 1.0, 0.2, 0.6, 1.0)
    zombie:setOutlineHighlight(playerNum, true)
    zombie:setOutlineHighlightCol(playerNum, 1.0, 0.2, 0.6, 1.0)

    -- Belt-and-suspenders against the stand-up/no-recollide bite
    -- (AttackState.java skips its whole AttackCollisionCheck handler, so no bite/scratch/laceration can land,
    -- regardless of whether OnCollide re-fires for this zombie).
    zombie:setNoTeeth(true)
end

--- Remove the pink outline from a zombie, if any
--- @param zombie IsoZombie
local function clearHighlight(zombie)
    zombie:setHighlighted(false)
    zombie:setNoTeeth(false)
end

--- Re-asserts the pink outline on an "elected" zombie right as it updates.
--- A single setHighlighted/setOutlineHighlight call does not stick on an AI-controlled zombie.
--- Its own update loop resets the flag, unlike a player-controlled character (same reason
--- ZomboLust_OrgasmSystem.onOrgasmCountdownTick re-applies every tick for the player).
--- Hooking OnZombieUpdate (fires from/after this specific zombie's own update cycle) instead
--- of a generic OnTick guarantees our reassertion runs after whatever resets the flag,
--- rather than racing an unspecified OnTick-vs-zombie-update dispatch order; it also lets us
--- filter directly on the zombie we're notified about instead of scanning the whole table.
--- @param zombie IsoZombie
local function onZombieUpdate(zombie)
    local entry = ZomboLust_SexualIntentSystem.zombieIntent[zombie]
    if entry and entry.elected and zombie:isAlive() then
        applyHighlight(entry.player, zombie)
    end
end
Events.OnZombieUpdate.Add(onZombieUpdate)

-- ========================
-- Undressed flag (ModData)
-- ========================

--- Recomputes and stores the "player has nothing left to strip" ModData flag
--- Called once per throttled scan pass from ZomboLust_ExcitationSystem.updateExcitation
--- @param player IsoPlayer
function ZomboLust_SexualIntentSystem.updateUndressedFlag(player)
    local modData = player:getModData()
    modData.ZL_Undressed = not ZomboLust_ClothingStrip.hasClothingToRemove(player)
end

--- Reads the "player is fully undressed" flag, computing it on demand if it hasn't
--- run yet this session (e.g. very first tick after a fresh spawn/load)
--- @param player IsoPlayer
--- @return boolean
function ZomboLust_SexualIntentSystem.isPlayerUndressed(player)
    local modData = player:getModData()
    if modData.ZL_Undressed == nil then
        ZomboLust_SexualIntentSystem.updateUndressedFlag(player)
    end
    return modData.ZL_Undressed
end

-- ==============
-- Intent rolling
-- ==============

--- Reads the live "biteChance" mod option slider (0-100), falling back to
--- ZomboLust_SexualIntentSystem.BiteChance if the option isn't registered yet.
--- ZombRand(100) returns an integer in 0 <-> 99 , so both extremes behave as expected:
--- 0 -> the roll is always >= 0 (always elected, never bites), 100 -> the roll is never >= 100 (never elected, always bites).
--- @return number
local function getBiteChance()
    local options = PZAPI and PZAPI.ModOptions and PZAPI.ModOptions:getOptions("ZomboLust")
    local option = options and options:getOption("biteChance")
    if option and option.getValue then
        ---@cast option umbrella.ModOptions.Slider
        return option:getValue()
    end
    return ZomboLust_SexualIntentSystem.BiteChance
end

--- Rolls the dice for a given zombie and caches the result
--- @param player IsoPlayer
--- @param zombie IsoZombie
--- @return boolean elected -- True if the zombie will trigger the sexual animation, false if it will bite
local function rollIntent(player, zombie)
    local elected = ZombRand(100) >= getBiteChance()

    ZomboLust_SexualIntentSystem.zombieIntent[zombie] = {
        elected = elected,
        lastSeenTick = ZomboLust_SexualIntentSystem.scanTick,
        player = player
    }

    if elected then
        applyHighlight(player, zombie)
    end

    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "Zombie ID %d rolled sexual intent -> %s",
            zombie:getID(), elected and "SEXUAL ANIMATION (elected)" or "BITE")
    end

    return elected
end

--- Called once per adjacent opposite-gender zombie during the throttled proximity scan in ZomboLust_ExcitationSystem.updateExcitation.
--- Only rolls once per approach - repeated calls while the zombie stays in range just refresh its "still seen" timestamp so it isn't purged.
--- @param player IsoPlayer
--- @param zombie IsoZombie
function ZomboLust_SexualIntentSystem.scanProximity(player, zombie)
    if not zombie or not zombie:isAlive() then return end
    if player:isFemale() == zombie:isFemale() then return end
    if not ZomboLust_SexualIntentSystem.isPlayerUndressed(player) then return end

    local entry = ZomboLust_SexualIntentSystem.zombieIntent[zombie]
    if entry then
        entry.lastSeenTick = ZomboLust_SexualIntentSystem.scanTick
        return
    end

    rollIntent(player, zombie)
end

--- Purges zombies that fell out of proximity range since the last scan pass, clearing their
--- highlight and cache entry so they roll again from scratch on their next approach.
--- Call once, right after the proximity scan loop for the current pass completes.
function ZomboLust_SexualIntentSystem.purgeStale()
    for zombie, entry in pairs(ZomboLust_SexualIntentSystem.zombieIntent) do
        if entry.lastSeenTick ~= ZomboLust_SexualIntentSystem.scanTick then
            if entry.elected then
                clearHighlight(zombie)
            end
            ZomboLust_SexualIntentSystem.zombieIntent[zombie] = nil
        end
    end
end

--- Determines whether a zombie now in actual contact with the player should trigger the sexual animation or a bite attempt.
--- Uses the cached proximity roll when available; otherwise rolls immediately
--- (e.g. the zombie reached contact faster than the throttled
--- scan could catch it - lunge, teleport-adjacent spawn, very first tick after game start).
--- Always returns true (legacy behaviour, unchanged) while the player still has clothing to
--- strip - the bite/animation split only exists once fully undressed.
--- @param player IsoPlayer
--- @param zombie IsoZombie
--- @return boolean elected
function ZomboLust_SexualIntentSystem.isZombieElectedForAnimation(player, zombie)
    if not player or not zombie then return true end
    if not ZomboLust_SexualIntentSystem.isPlayerUndressed(player) then return true end

    local entry = ZomboLust_SexualIntentSystem.zombieIntent[zombie]
    if entry then
        return entry.elected
    end

    return rollIntent(player, zombie)
end

--- Clears any tracked intent/highlight for a zombie - call once it has been transformed into
--- a ZombHuman (or otherwise resolved) so the pink outline doesn't linger uselessly
--- @param zombie IsoZombie
function ZomboLust_SexualIntentSystem.clearZombieIntent(zombie)
    if not zombie then return end
    local entry = ZomboLust_SexualIntentSystem.zombieIntent[zombie]
    if not entry then return end

    if entry.elected then
        clearHighlight(zombie)
    end
    ZomboLust_SexualIntentSystem.zombieIntent[zombie] = nil
end

return ZomboLust_SexualIntentSystem
