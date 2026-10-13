--- File: ZomboDesire/42/media/lua/shared/ZomboDesire/ZomboDesire_Init.lua
--- Initialization of ZomboDesire animation configurations
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_Init.lua loaded")

-- Register custom Lua events
LuaEventManager.AddEvent("OnZomboDesireStageTransition")

-- ISZomboDesireAnimationAction lifecycle events, for external mods (like ZomboLust) that need to react to an animation action
-- starting/completing/stopping without monkey-patching the class directly.
-- Each fires with the ISZomboDesireAnimationAction instance (self) as its only argument.
-- See ISZomboDesireAnimationAction:start/perform/stop in ZomboDesire_AnimationHandler.lua for the exact firing point of each.
LuaEventManager.AddEvent("OnZomboDesireAnimationActionStart")
LuaEventManager.AddEvent("OnZomboDesireAnimationActionPerform")
LuaEventManager.AddEvent("OnZomboDesireAnimationActionStop")

-- ZomboDesire_MiniGame lifecycle events, for external mods (like ZomboLust) that need to react to or extend the mini-game
-- without monkey-patching the class directly.
-- Each fires with the ZomboDesire_MiniGame instance as its first argument; subscribers may mutate it in place
-- (e.g. pinkSize/pinkStart, or custom fields like controlPromptLines) exactly as a monkey-patch would have.
-- Fired after the native method's own guard clauses (isClosed/shouldSkipCleanup),
-- so a redundant re-entrant call does not re-fire the event - see ZomboDesire_MiniGame.lua for the exact firing point of each,
-- and ZomboDesire_Cleanup.lua for OnZomboDesireCleanupRestoreState.
-- Note: ZomboDesire_MiniGame.Handlers.onEnd is a separate, already-safe extension point
-- (a plain table field, re-read dynamically on every call) - no event needed for that one, see its own comment in ZomboDesire_MiniGame.lua
LuaEventManager.AddEvent("OnZomboDesireMiniGameLaunch")
LuaEventManager.AddEvent("OnZomboDesireMiniGameFinish")
LuaEventManager.AddEvent("OnZomboDesireMiniGameCalculateZones")
LuaEventManager.AddEvent("OnZomboDesireMiniGameInitialise")
LuaEventManager.AddEvent("OnZomboDesireMiniGamePrerender")
LuaEventManager.AddEvent("OnZomboDesireCleanupRestoreState")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Main" -- Main module with debug functions

--- Module name for logging
--- @type string
local MODULE_NAME = "Init"

--- Initialize/ensure animation configs container
--- This is also defined in ZomboDesire_Main.lua, but kept here because this file is directly required
--- by animation config scripts that need immediate access to the registration function

--- Main namespace
--- @type table
ZomboDesire = ZomboDesire or {}

--- Animation configurations container
--- @type table
ZomboDesire.AnimationConfigs = ZomboDesire.AnimationConfigs or {}
ZomboDesire.AnimationAlts = ZomboDesire.AnimationAlts or {}

--- Position relative between player and zombie/ZombHuman
--- @type "FaceToFace"|"FaceToBack"|nil
ZomboDesire.relativePosition = nil

--- Zombie gender tag for animation selection
--- @type "ZF0"|"ZM0"|nil
ZomboDesire.zombieGenderTag = nil

--- Object interaction tag for animation selection
--- @type "Leaning over"|"Standing against"|"Sitting on"|"Lying on"|"On stairs"|nil
ZomboDesire.objectInteractionTag = nil

--- =======================================
--- Utility function: FPS measurement code
--- =======================================
--[[
local frameCount = 0
local lastTime   = getTimestampMs()

Events.OnPostRender.Add(function()
    frameCount = frameCount + 1
    if frameCount % 60 == 0 then
        local now   = getTimestampMs()
        local delta = now - lastTime       -- ms pour 60 frames
        local measuredFPS = 60 / (delta / 1000)
        debugLog("Measured FPS %.1f (over 60 frames in %d ms)", measuredFPS, delta)
        lastTime     = now
        frameCount   = 0
    end
end)
]]

-- =====================================
-- Animation Configuration Registration
-- =====================================

--- Registers a new animation configuration in the global registry
--- @param configName string -- String identifier for the animation configuration
--- @param configTable table -- Table containing all animation parameters and settings
---							Must include: animName, tags, actors with their stages
-- 
-- Usage: Each AnimationConfig script should call:
--        ZomboDesire.registerAnimationConfig("UniqueName", configTable)
local function registerAnimationConfig(configName, configTable)
    -- Validate input parameters
    if not configName or type(configName) ~= "string" then
        ZomboDesire.errorLog(MODULE_NAME, "Invalid animation config name '%s' (must be a string)", tostring(configName))
        return
    end

    if type(configTable) ~= "table" then
        ZomboDesire.errorLog(MODULE_NAME, "Invalid animation config for '%s' (must be a table)", configName)
        return
    end

    -- Register the configuration
    ZomboDesire.AnimationConfigs[configName] = configTable
    ZomboDesire.debugLog(MODULE_NAME, "Registered animation config '%s'", configName)
end

--- Registers the number of available alternatives for an animation prefix
--- @param prefix string -- The animation prefix (ending with _Alt)
--- @param count number -- The number of alternatives (1 to count)
local function registerAnimationAlts(prefix, count)
    if not prefix or type(prefix) ~= "string" then
        ZomboDesire.errorLog(MODULE_NAME, "Invalid animation prefix '%s' (must be a string)", tostring(prefix))
        return
    end

    if type(count) ~= "number" then
        ZomboDesire.errorLog(MODULE_NAME, "Invalid count for '%s' (must be a number)", prefix)
        return
    end

    ZomboDesire.AnimationAlts[prefix] = count
    ZomboDesire.debugLog(MODULE_NAME, "Registered %d alternatives for prefix '%s'", count, prefix)
end

-- Expose registration function to global namespace for animation config files
ZomboDesire.registerAnimationConfig = registerAnimationConfig
ZomboDesire.registerAnimationAlts = registerAnimationAlts

-- ==========================================
-- Standard Animation Alternatives (Alt1...3)
-- ==========================================

-- Current standard animations have 3 alternatives as of March 2026
local standardCount = 3

-- Registering common prefixes for ZM0 (Male Zombie) and ZF0 (Female Zombie)
-- This list should be updated when new Alt animations are added
-- ZM0
-- Front
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Front_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Front_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Front_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Front_End_Alt", standardCount)
-- _Le
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Front_Le_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Front_Le_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Front_Le_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Front_Le_End_Alt", standardCount)
-- _Ly
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Front_Ly_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Front_Ly_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Front_Ly_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Front_Ly_End_Alt", standardCount)
-- _Os
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Front_Os_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Front_Os_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Front_Os_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Front_Os_End_Alt", standardCount)
-- _Sa
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Front_Sa_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Front_Sa_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Front_Sa_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Front_Sa_End_Alt", standardCount)
-- _So
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Front_So_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Front_So_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Front_So_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Front_So_End_Alt", standardCount)

-- Back
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Back_Begin-TurnAround_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Back_End-TurnAround_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Back_Begin-TurnAround_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Back_End-TurnAround_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Back_Begin-TurnHalfway_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Back_End-TurnHalfway_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Back_Begin-TurnHalfway_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Back_End-TurnHalfway_Alt", standardCount)
-- _Le
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Back_Le_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Back_Le_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Back_Le_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Back_Le_End_Alt", standardCount)
-- _Ly
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Back_Ly_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Back_Ly_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Back_Ly_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Back_Ly_End_Alt", standardCount)
-- _Os
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Back_Os_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Back_Os_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Back_Os_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Back_Os_End_Alt", standardCount)
-- _Sa
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Back_Sa_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Back_Sa_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Back_Sa_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Back_Sa_End_Alt", standardCount)
-- _So
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Back_So_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZM0_Back_So_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Back_So_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZM0_Back_So_End_Alt", standardCount)


-- ZF0
-- Front
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Front_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Front_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Front_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Front_End_Alt", standardCount)
-- _Le
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Front_Le_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Front_Le_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Front_Le_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Front_Le_End_Alt", standardCount)
-- _Ly
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Front_Ly_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Front_Ly_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Front_Ly_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Front_Ly_End_Alt", standardCount)
-- _Os
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Front_Os_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Front_Os_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Front_Os_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Front_Os_End_Alt", standardCount)
-- _Sa
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Front_Sa_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Front_Sa_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Front_Sa_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Front_Sa_End_Alt", standardCount)
-- _So
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Front_So_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Front_So_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Front_So_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Front_So_End_Alt", standardCount)

-- Back
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Back_Begin-TurnAround_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Back_End-TurnAround_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Back_Begin-TurnAround_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Back_End-TurnAround_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Back_Begin-TurnHalfway_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Back_End-TurnHalfway_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Back_Begin-TurnHalfway_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Back_End-TurnHalfway_Alt", standardCount)
-- _Le
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Back_Le_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Back_Le_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Back_Le_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Back_Le_End_Alt", standardCount)
-- _Ly
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Back_Ly_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Back_Ly_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Back_Ly_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Back_Ly_End_Alt", standardCount)
-- _Os
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Back_Os_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Back_Os_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Back_Os_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Back_Os_End_Alt", standardCount)
-- _Sa
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Back_Sa_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Back_Sa_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Back_Sa_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Back_Sa_End_Alt", standardCount)
-- _So
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Back_So_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Kate_ZomboDesire_ZF0_Back_So_End_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Back_So_Begin_Alt", standardCount)
ZomboDesire.registerAnimationAlts("Bob_ZomboDesire_ZF0_Back_So_End_Alt", standardCount)
