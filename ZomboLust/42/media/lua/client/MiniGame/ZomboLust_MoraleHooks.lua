-- File: ZomboLust/42/media/lua/client/MiniGame/ZomboLust_MoraleHooks.lua
-- Integration points that wire the ZomboLust Morale mini-game into ZomboDesire's own mini-game and cleanup lifecycle,
-- via ZomboDesire's own lifecycle events (declared in ZomboDesire_Init.lua) instead of monkey-patching the class/functions directly:
--   1. OnZomboDesireMiniGameLaunch      -> also launches ZomboLust_MoraleSystem.Launch
--   2. OnZomboDesireMiniGameFinish      -> also closes ZomboLust_MoraleSystem.BarUI
--   3. OnZomboDesireCleanupRestoreState -> applies morale penalties/zombie reward/Test Subject
-- Simulation lives in ZomboLust_MoraleSystem.lua; UI (ZomboLust_MoraleBar) lives in ZomboLust_MoraleUI.lua.
-- @author BlaBla 2026

print("[ZomboLust LOADING] ZomboLust_MoraleHooks.lua loaded")

-- =============
-- Dependencies
-- =============
require "MiniGame/ZomboDesire_MiniGame"
require "MiniGame/ZomboLust_MoraleSystem"
require "MiniGame/ZomboLust_MoraleUI"

-- Module name for logging
--- @type string
local MODULE_NAME = "MoraleHooks"

-- ============
-- Integration
-- ============

--- Also launch our own morale bar alongside ZomboDesire's mini-game
--- @param _miniGame ZomboDesire_MiniGame -- Unused: we only need the launch arguments
--- @param character IsoPlayer
--- @param action ISZomboDesireAnimationAction
local function onMiniGameLaunch(_miniGame, character, action)
    ZomboLust_MoraleSystem.Launch(character, action)
end

--- Also close the morale bar when ZomboDesire's mini-game finishes
--- @param _miniGame ZomboDesire_MiniGame -- Unused: only the result is needed
--- @param result string
local function onMiniGameFinish(_miniGame, result)
    if ZomboLust_MoraleSystem.BarUI and not ZomboLust_MoraleSystem.BarUI.isClosed then
        ZomboLust_MoraleSystem.BarUI:finish(result)
    end
end

-- ===========================
-- Cleanup Integration (Malus)
-- ===========================

--- Applies morale penalties/zombie reward/Test Subject effects once ZomboDesire's own world-state cleanup has fully run
--- @param character IsoGameCharacter
local function onCleanupRestoreState(character)
    -- Apply penalties if we have a stored morale value from a non-interrupted game
    if ZomboLust_MoraleSystem.FinalMoraleAtEndOfMiniGame and instanceof(character, "IsoPlayer") then
        ---@cast character IsoPlayer
        ZomboLust.debugLog(MODULE_NAME, "Cleanup detected - applying morale penalties")
        ZomboLust_MoraleSystem.ApplyFinalPenalties(character, ZomboLust_MoraleSystem.FinalMoraleAtEndOfMiniGame)

        -- Zombie reward (health restoration + speed bonus) - see ZomboLust_MoraleSystem.ApplyZombieReward
        ZomboLust_MoraleSystem.ApplyZombieReward(ZomboLust_MoraleSystem.FinalZombieAtEndOfMiniGame,
            ZomboLust_MoraleSystem.FinalZombieStartHealthAtEndOfMiniGame, ZomboLust_MoraleSystem.FinalMoraleAtEndOfMiniGame)

        -- Test Subject (Cobaye) logic
        local traitTestSubject = ZomboLustRegistries.Traits.TestSubject
        if traitTestSubject and character:hasTrait(traitTestSubject) then
            ZomboLust_MoraleSystem.ApplyTestSubjectEffect(character)
        elseif traitTestSubject then
            ZomboLust.debugLog(MODULE_NAME, "Test Subject logic skipped: trait not present on character")
        end

        -- Reset stored values
        ZomboLust_MoraleSystem.FinalMoraleAtEndOfMiniGame = nil
        ZomboLust_MoraleSystem.FinalZombieAtEndOfMiniGame = nil
        ZomboLust_MoraleSystem.FinalZombieStartHealthAtEndOfMiniGame = nil
    else
        ZomboLust.debugLog(MODULE_NAME, "Test Subject logic skipped: FinalMoraleAtEndOfMiniGame is nil (game interrupted or casual)")
    end
end

-- Ensure the events exist before subscribing (ZomboDesire must be loaded and up to date)
if Events.OnZomboDesireMiniGameLaunch and Events.OnZomboDesireMiniGameFinish and Events.OnZomboDesireCleanupRestoreState then
    Events.OnZomboDesireMiniGameLaunch.Add(onMiniGameLaunch)
    Events.OnZomboDesireMiniGameFinish.Add(onMiniGameFinish)
    Events.OnZomboDesireCleanupRestoreState.Add(onCleanupRestoreState)
else
    ZomboLust.errorLog(MODULE_NAME, "ZomboDesire mini-game/cleanup lifecycle events not found (ZomboDesire missing or outdated)! Morale integration disabled.")
end

print("[ZomboLust] Morale Hooks Initialized")
