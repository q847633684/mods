--- File: ZomboLust/42/media/lua/shared/ZomboLust_Main.lua
--- Main core for ZomboLust
--- @author BlaBla 2025

-- ===================================================
-- Architecture Assumption: Single-Player Only (2026)
-- ===================================================
-- ZomboLust is designed, written and tested for solo play only.
-- This is a deliberate scope decision, not an oversight - full multiplayer support is a possible future goal but is not being worked on now.
-- Two separate assumptions are baked into the current codebase;
-- read both before attempting to add multiplayer support, since they need different fixes:
-- 1) "One local player" - many handlers call getSpecificPlayer(0) directly instead of receiving the player as a parameter
--    (e.g. ZomboLust_ExcitationUI.lua, ZomboLust_ExcitationSwinger.lua, ZomboLust_ExcitationDangerGroan.lua, ZomboLust_ExcitationSystem.decayExcitation),
--    and a few modules keep per-session tracking state in a module-local Lua upvalue instead of per-player modData
--    (ZomboLust_HygieneDisease.hallucinationZombies, ZomboLust_Physiology.internalDiscomfort, ZomboLust_Innocent.internalPanic).
--    This only matters for local split-screen (getNumActivePlayers() > 1 on the same machine):
--    each remote client in a normal network game only ever drives its own local player through these same hooks,
--    so getSpecificPlayer(0) already resolves correctly there.
--    The fix, if ever needed, is mechanical and low-risk:
--    thread the player through instead of hardcoding index 0, and key module-local state by player.
--
-- 2) "Client is authoritative" - the whole mod lives under lua/client + shared/ (no lua/server),
--    and defines no sendClientCommand/sendServerCommand/OnClientCommand/OnServerCommand anywhere.
--    Most systems only ever touch the acting player's own modData, which is harmless.
--    The one exception is ZomboLust_BukkakeWorld.lua, which writes decorative objects directly into chunk-level tile ModData
--    (see getChunkStorage) with no server round-trip.
--    This works today only because singleplayer's "server" is the same process as the client.
--    In a real network game (dedicated server, several machines) this is a genuine desync vector, not just a style issue,
--    and needs an explicit client-request / server-authority / broadcast layer
--    before it can be trusted - this is real design work, not a quick patch.
--
-- Do not add speculative isServer()/isClient() guards or partial per-player keying ahead of an actual multiplayer push:
-- the right shape of the fix depends on decisions not yet made (which systems should even be visible to other players),
-- so premature guards would likely need to be redone anyway and would just add dead weight to the solo-play code path in the meantime.

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_Main.lua loaded")

-- =============
-- Dependencies
-- =============
require("ZomboLust_Registries")

-- =========================
-- Namespace Initialization
-- =========================

--- Main namespace
--- @class ZomboLust
--- @field UI ZomboLust_ImageUI|nil
--- @field Sidebar table
--- @field registerSidebarButton function
ZomboLust = ZomboLust or {}

-- ====================
-- Debug Configuration
-- ====================

--- Global debug configuration
--- @type { enabled: boolean, modules: table<string, boolean> }
ZomboLust.Debug = {
    -- Master switch for all debugging
    enabled = false,

    -- Module-specific debug settings
    modules = {
        -- Core modules
        ["Main"] = true,
        ["VoiceUtils"] = true,
        ["DirtyTalkUtils"] = true,
        ["GenderMismatchHandler"] = true,
        ["MiniGame"] = true,
        ["FXHandler"] = true,
        ["CreationMethods"] = true,

        -- Gameplay modules
        ["Physiology"] = true,
        ["ExcitationSystem"] = true,
        ["ExcitationStimulants"] = true,
        ["DominoPush"] = true,
        ["SexualIntent"] = true,
        ["MoraleSystem"] = true,
        ["MoraleHooks"] = true,
        ["ApplyTrauma"] = true,
        ["Orgasm"] = true,
        ["HygieneDisease"] = true,
        ["Innocent"] = true,
        ["Everydrop"] = true,

        -- Cloth modules
        ["ClothingStrip"] = true,
        ["ClothingStripForZombHuman"] = true,
        ["CharacterCreation"] = true,

        -- Penis modules
        ["PenisManager"] = true,
        ["ZAEquip"] = true,

        -- Bukkake modules
        ["Bukkake"] = true,
        ["BukkakeWash"] = true,
        ["BukkakeWorld"] = true,
        ["BukkakeWashWorld"] = true,

        -- UI modules
        ["ImageUI"] = true,
        ["UIMain"] = true,
        ["Sidebar"] = true,
        ["ExcitationUI"] = true,
        ["MoraleUI"] = true,

        -- Camera modules
        ["CameraZoom"] = true,

        -- Debug modules
        ["DebugPenisAnimation"] = true,
        ["DebugDiseases"] = true
    }
}

-- ==================
-- Logging Functions
-- ==================

--- Checks whether debug logging is currently active for a given module
--- Exposed so call sites can guard the construction of expensive log arguments
--- (native engine calls, tostring, concatenation) BEFORE evaluating them.
--- In Lua, function arguments are always evaluated eagerly, so guarding only inside debugLog would not prevent that cost.
--- @param module string -- The module name
--- @return boolean
function ZomboLust.isDebug(module)
    return ZomboLust.Debug.enabled and ZomboLust.Debug.modules[module] == true
end

--- Displays a formatted debug message if debugging is enabled for the module
--- Self-guarded: safe to call directly when arguments are already cheap (local variables, literals).
--- For arguments that are costly to build, wrap the call site in "if ZomboLust.isDebug(MODULE_NAME) then ... end"
--- (see each module's local "dbg()" helper) instead of relying on this guard.
--- @param module string -- The module name
--- @param message string -- The message to display
--- @param ... any -- Arguments to be formatted in the message
function ZomboLust.debugLog(module, message, ...)
    if not ZomboLust.isDebug(module) then return end
    print(string.format("[ZomboLust %s] %s", module, string.format(message, ...)))
end

--- Displays an error message
--- @param module string -- The module name
--- @param message string -- The error message to display
--- @param ... any -- Arguments to be formatted in the message
function ZomboLust.errorLog(module, message, ...)
    print(string.format("[ZomboLust %s] ERROR %s", module, string.format(message, ...)))
end

--- Displays a warning message
--- @param module string -- The module name
--- @param message string -- The warning message to display
--- @param ... any -- Arguments to be formatted in the message
function ZomboLust.warningLog(module, message, ...)
    print(string.format("[ZomboLust %s] WARNING %s", module, string.format(message, ...)))
end

-- ======================================
-- Class Declarations (from ZomboDesire)
-- ======================================

--- Animation action class (inherited from ZomboDesire)
---@diagnostic disable-next-line: duplicate-type
--- @class (partial) ISZomboDesireAnimationAction : ISBaseTimedAction

-- ===============
-- Module Exports
-- ===============

return ZomboLust
