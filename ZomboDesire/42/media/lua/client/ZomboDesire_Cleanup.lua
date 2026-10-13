--- File: ZomboDesire/42/media/lua/client/ZomboDesire_Cleanup.lua
--- Handles cleanup after animation: remove ZombHuman, restore original zombie, release player control, manage player invisibility
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_Cleanup.lua loaded")

-- ============
-- Dependencies
-- ============
-- ZomboDesire_Main: Core module that defines the main namespace and global state variables
--                   Contains all shared flags, references, state management for the mod and debug functions
require "ZomboDesire_Main"

-- ZomboDesire_Utils: Utility functions for world interactions
--                    Provides functions for handling knockback effects, player control management
require "ZomboDesire_Utils"

-- ZomboDesire_EscapeHandler: Handles player escape ability (invisibility to zombies)
--                            Provides the escape logic that was previously triggered by animation events
require "ZomboDesire_EscapeHandler"

-- ZombHumanUpdate: Core logic for ZombHuman transformation and Zombify
require "ZombHuman/ZomboDesire_ZombHumanUpdate"

--- Module name for logging
--- @type string
local MODULE_NAME = "Cleanup"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboDesire.isDebug in ZomboDesire_Main.lua).
--- Calls with cheap/no arguments use ZomboDesire.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboDesire.isDebug(MODULE_NAME)
end

-- ================
-- Module Namespace
-- ================
--- Main namespace for cleanup functionality
--- This table is also pre-declared in ZomboDesire_Main.lua
--- @class (partial) ZomboDesire_Cleanup
ZomboDesire_Cleanup = {}

-- ============
-- Module State
-- ============
--- Tracks whether the cleanup process has already been executed
--- Prevents multiple cleanup calls from affecting the game state
--- @type boolean
local hasRestored = false

--- Constants
--- Delay in ticks before reactivating zombie awarness (240 ticks ~= 2 seconds)
--- @type number
local ZOMBIE_AWARNESS_REACTIVATION_DELAY_TICKS = 240

-- ==================
-- Cleanup Functions
-- ==================

--- Checks if cleanup has already been performed
--- @return boolean -- true if cleanup should be skipped
local function shouldSkipCleanup()
    if hasRestored then
        ZomboDesire.debugLog(MODULE_NAME, "Cleanup already performed - skipping")
        return true
    end
    return false
end

--- Restores zombie sounds after deZombHumanization
--- Note: This function is called from ZomboDesire_ZombHumanUpdate.lua during Zombify
--- @param zombie IsoZombie -- The zombie whose sounds must be restored
function ZomboDesire_Cleanup.restoreZombieSounds(zombie)
    if not zombie then return end

    ZomboDesire.debugLog(MODULE_NAME, "Zombie Sounds Restoration")

    -- Reset the zombie voice prefix to its default value
    local desc = zombie:getDescriptor()
    if desc then
        -- Reset the voice prefix to that of a standard zombie
        -- The "ZombHuman" prefix was defined in ZombHumanUpdate.ZombHumanize
        desc:setVoicePrefix("") -- Use an empty string to revert to the default prefix
        ZomboDesire.debugLog(MODULE_NAME, "Zombie voice prefix reset")
    end

    -- Force a reset of the zombie's sound system
    -- This is necessary because simply resetting the voice prefix is not enough to fully restore the zombie's sounds

    -- Reset the sound emitter
    local emitter = zombie:getEmitter()
    if emitter then
        -- Stop all current sounds
        emitter:stopAll()

        -- Reset variables that might affect sounds
        zombie:setVariable("ZombHuman", false)
        zombie:setVariable("NoLungeTarget", false)
        zombie:setVariable("ZombieHitReaction", "")

        -- Reset the zombie's basic sounds based on its gender
        -- Play a sound to "wake up" the sound system
        local voiceSound = zombie:isFemale() and "FemaleZombieVoiceA" or "MaleZombieVoiceA"
        emitter:playSound(voiceSound)

        ZomboDesire.debugLog(MODULE_NAME, "Zombie Sound Emitter Reset")
    end

    -- Force update of zombie model to apply changes
    zombie:resetModelNextFrame()

    ZomboDesire.debugLog(MODULE_NAME, "Zombie sounds successfully restored")
end

--- Removes the ZombHuman brain from a zombie without removing the entity from the world
--- This function converts a ZombHuman back to a regular zombie
--- @return boolean -- true if ZombHuman brain was successfully removed
local function removeZombHumanBrain()
    ---@type IsoZombie|nil
    local ZombHumanEntity = ZomboDesire.originalZombie

    if not ZombHumanEntity then
        ZomboDesire.errorLog(MODULE_NAME, "ZombHuman reference missing or invalid")
        return false
    end

    ZomboDesire.debugLog(MODULE_NAME, "Removing ZombHuman brain using Zombify()")

    -- Use Zombify function from ZomboDesire_ZombHumanUpdate.lua
    ZomboDesire_ZombHumanUpdate.Zombify(ZombHumanEntity)

    -- There’s no need to do anything here to set the zombie back to idle.
    -- It’s the Event <m_ParameterValue>BumpAnimFinished=true in the XML files from the End directory that sends
    -- the correct command to make the zombie inactive.
    -- To prevent PZ from ignoring this event, the time tag must be set to <m_TimePc>0.900 instead of <m_Time>End
    -- Otherwise, the longer the animation, the more often PZ tends to skip this event and never process it, which causes
    -- the zombie to freeze in an infinite Bump state.
    -- We encountered the same issue when we tried to add EscapeAndInvisibility with a <m_Time>End tag.

    -- Force the animation engine to exit the Bump state to prevent freezing
    -- This compensates for cases where the XML event BumpAnimFinished=true is not reached (e.g., interrupted before Stage 3 at 0.900)
    -- NOTE: This flag is reset to false in ZomboDesire_AnimationHandlerForZombHuman.playBump() to ensure
    -- the next encounter (Player versus Zombie) correctly plays the first animation stage
    ZombHumanEntity:setVariable("BumpAnimFinished", true)

    -- Reset zombie state to make it behave like a normal zombie again
    ZombHumanEntity:makeInactive(false) -- probably superfluous

    -- Force the entity to update its model and behavior
    ZombHumanEntity:resetModelNextFrame() -- probably superfluous

    -- Clear the global reference
    ZomboDesire.originalZombie = nil

    return true
end

--- Repositions both protagonists to their starting positions before the animation
--- This ensures both the zombie and player are restored to where they were before being moved.
--- The zombie may already be gone at this point (ZomboLust Pacify/Succubus can remove/kill it
--- earlier, during the animation, on a successful completion) - in that case it is simply
--- skipped, but the player is always repositioned regardless.
--- @param player IsoPlayer -- The player to reposition
--- @param zombie IsoZombie|nil -- The zombie to reposition, if it still exists
--- @return boolean -- true if the player was successfully repositioned
local function repositionProtagoniststoStartingPositions(player, zombie)
    if not player then
        ZomboDesire.errorLog(MODULE_NAME, "Player reference missing for repositioning")
        return false
    end

    if not ZomboDesire.animationStartPositions then
        ZomboDesire.errorLog(MODULE_NAME, "Animation start positions not available for repositioning")
        return false
    end

    local zombieStartX = ZomboDesire.animationStartPositions.zombieX --[[@as number]]
    local zombieStartY = ZomboDesire.animationStartPositions.zombieY --[[@as number]]
    local playerStartX = ZomboDesire.animationStartPositions.playerX --[[@as number]]
    local playerStartY = ZomboDesire.animationStartPositions.playerY --[[@as number]]

    if not playerStartX or not playerStartY then
        ZomboDesire.errorLog(MODULE_NAME, "Invalid starting positions for player repositioning")
        return false
    end

    -- Reposition the zombie to its starting location, if it still exists
    if zombie then
        if not zombieStartX or not zombieStartY then
            ZomboDesire.errorLog(MODULE_NAME, "Invalid starting positions for zombie repositioning")
        else
            zombie:setX(zombieStartX)
            zombie:setY(zombieStartY)
            ZomboDesire.debugLog(MODULE_NAME, "Zombie repositioned to starting coordinates (%.2f, %.2f)", zombieStartX, zombieStartY)
        end
    end

    -- Reposition the player to its starting location
    player:setX(playerStartX)
    player:setY(playerStartY)
    ZomboDesire.debugLog(MODULE_NAME, "Player repositioned to starting coordinates (%.2f, %.2f)", playerStartX, playerStartY)

    return true
end

--- Disables NoClip mode on the player
--- This is necessary to restore normal collision detection after positioning
--- @param character IsoPlayer|IsoGameCharacter -- The character to check and disable NoClip for
--- @param playerInstance IsoPlayer -- The cached player instance
local function disablePlayerNoClip(character, playerInstance)
    ZomboDesire.debugLog(MODULE_NAME, "Disabling NoClip on player")

    -- Determine which player to use
    local playerToDisableNoClip
    if instanceof(character, "IsoPlayer") then
        playerToDisableNoClip = character
    else
        playerToDisableNoClip = playerInstance
    end

    -- Disable NoClip to restore normal collision detection
    if playerToDisableNoClip then
        ---@cast playerToDisableNoClip IsoPlayer
        playerToDisableNoClip:setNoClip(false, false)
        ZomboDesire.debugLog(MODULE_NAME, "NoClip disabled on player")
    else
        ZomboDesire.errorLog(MODULE_NAME, "Failed to get player for NoClip disable")
    end
end

--- Releases player control restrictions
--- @param character IsoPlayer|IsoGameCharacter -- The character to check and release control for
--- @param playerInstance IsoPlayer -- The cached player instance
local function releasePlayerControl(character, playerInstance)
    ZomboDesire.debugLog(MODULE_NAME, "Releasing player control")

    -- Determine which player to use
    local playerToRelease
    if instanceof(character, "IsoPlayer") then
        playerToRelease = character
    else
        playerToRelease = playerInstance
    end

    -- Use the shared utility function from ZomboDesire_Utils
    if playerToRelease then
        ---@cast playerToRelease IsoPlayer
        ZomboDesire_Utils.enablePlayerControls(playerToRelease)
    end
end

--- Removes penis items from both player and zombie (ZomboLust integration)
--- Must be called before ZomboDesire.originalZombie is set to nil
--- @param player IsoPlayer -- The player to remove penis from
--- @param zombie IsoZombie -- The zombie to remove penis from
local function removePenisFromBothCharacters(player, zombie)
    if ZomboDesire.IsZomboLustActive and ZomboLust_PenisManager then
        if player and not player:isFemale() then
            ZomboLust_PenisManager.removePenis(player)
        end

        if zombie and not zombie:isFemale() then
            ZomboLust_PenisManager.removePenis(zombie)
        end
    end
end

--- Stops the ZomboLust video playback if active (ZomboLust integration)
--- @public
function ZomboDesire_Cleanup.stopZomboLustVideo()
    if ZomboDesire.IsZomboLustActive and ZomboLust and ZomboLust.UI then
        ZomboDesire.debugLog(MODULE_NAME, "ZomboLust integration: Stopping video playback")
        ZomboLust.UI:close()
    end
end

--- Performs final cleanup of global state
local function finalizeCleanup()
    -- Reset position and gender tags
    if ZomboDesire then
        ZomboDesire.relativePosition = nil
        ZomboDesire.zombieGenderTag = nil
        ZomboDesire.objectInteractionTag = nil
        ZomboDesire.debugLog(MODULE_NAME, "All animation tags reset to nil")
    end

    -- Reset saved starting positions to prevent stale data on next animation
    if ZomboDesire and ZomboDesire.animationStartPositions then
        ZomboDesire.animationStartPositions.playerX = nil
        ZomboDesire.animationStartPositions.playerY = nil
        ZomboDesire.animationStartPositions.zombieX = nil
        ZomboDesire.animationStartPositions.zombieY = nil
        ZomboDesire.debugLog(MODULE_NAME, "Animation start positions cleared")
    end

    -- Mark cleanup as completed
    hasRestored = true

    ZomboDesire.debugLog(MODULE_NAME, "Cleanup finalized")
end

--- Main function: restores world to pre-interception state
--- Technically the character parameter is an IsoGameCharacter
--- but the function handles both types correctly thanks to the instanceof check in releasePlayerControl
--- @param character IsoPlayer|IsoZombie -- IsoPlayer instance from ZomboDesire_AnimationHandler.lua
---										or ZombHuman instance from ZomboDesire_AnimationHandlerForZombHuman.lua
---@diagnostic disable-next-line: duplicate-set-field
function ZomboDesire_Cleanup.restoreState(character)
    -- Skip if already restored
    if shouldSkipCleanup() then
        return
    end

    local player = getSpecificPlayer(0) --[[@as IsoPlayer]]
    local zombie = ZomboDesire.originalZombie --[[@as IsoZombie]]

    local callerInfo = "Unknown"
    if character then
        if instanceof(character, "IsoPlayer") then callerInfo = "Player" else callerInfo = "ZombHuman" end
    end
    ZomboDesire.debugLog(MODULE_NAME, "Starting world state restoration (Called by: %s)", callerInfo)

    -- Clean up knockback events
    -- This must be done BEFORE the escape period starts
    ZomboDesire_Utils.cleanupKnockbacks()

    -- Guarded explicitly: getID/getBumpType/isUseless cross the Lua-Java bridge
    -- and would be evaluated even with debug off if we relied on debugLog's own guard
    if zombie and dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "TRACE: Zombie %d state before Zombify - Bump: %s, Useless: %s",
            zombie:getID(), tostring(zombie:getBumpType()), tostring(zombie:isUseless()))
    end

    -- Step 1: Reposition both protagonists to their starting locations (before ZomboDesire.originalZombie is cleared)
    repositionProtagoniststoStartingPositions(player, zombie)

    -- Step 2: Remove penis items from both characters (ZomboLust integration - must be before Step 3)
    removePenisFromBothCharacters(player, zombie)

    -- Step 3: Stop ZomboLust video playback
    ZomboDesire_Cleanup.stopZomboLustVideo()

    -- Step 4: Remove ZombHuman brain (but keep the entity) to turn it back into a normal zombie.
    -- Skipped if the zombie reference is already gone: on a successful completion, the ZomboLust
    -- "Pacify"/"Succubus" traits may already have removed/killed the zombie earlier, from
    -- ZLApplyTrauma.lua (fired only on successful End/End_Vag animations), clearing
    -- ZomboDesire.originalZombie before this function runs.
    if zombie then
        removeZombHumanBrain()
    end

    -- Step 5: Disable NoClip to restore normal collision detection
    -- No need here to stipulate that character MUST be an IsoPlayer because there is already an instanceof check in disablePlayerNoClip
    ---@diagnostic disable-next-line: param-type-mismatch
    disablePlayerNoClip(character, player)

    -- Step 6: Release player control
    -- No need here to stipulate that character MUST be an IsoPlayer because there is already an instanceof check in releasePlayerControl
    ---@diagnostic disable-next-line: param-type-mismatch
    releasePlayerControl(character, player)

    -- Step 7: Execute escape ability (if character is player)
    if instanceof(character, "IsoPlayer") then
        ---@diagnostic disable-next-line: param-type-mismatch
        ZomboDesire_EscapeHandler.executeEscape(character)
    else
        -- If called from ZombHuman, get the actual player
        if player then
            ZomboDesire_EscapeHandler.executeEscape(player)
        else
            ZomboDesire.errorLog(MODULE_NAME, "Failed to get player for escape ability")
        end
    end

    -- Step 8: Final cleanup
    finalizeCleanup()

    -- For external mods (like ZomboLust) to apply their own post-cleanup effects (morale penalties, rewards, etc.)
    -- without monkey-patching this function.
    -- Fires past the shouldSkipCleanup() guard above, so a redundant re-entrant call doesn't re-fire it.
    triggerEvent("OnZomboDesireCleanupRestoreState", character)
end

--- Must be called at the start of each new interception
function ZomboDesire_Cleanup.resetCleanupFlag()
    ZomboDesire.debugLog(MODULE_NAME, "Reset cleanup flag")
    hasRestored = false
    -- Reset animation tags to ensure they're not stuck in stale state
    if ZomboDesire then
        ZomboDesire.relativePosition = nil
        ZomboDesire.zombieGenderTag = nil
        ZomboDesire.objectInteractionTag = nil
        ZomboDesire.debugLog(MODULE_NAME, "Position/gender tags reset")
    end
end

--- Resets all animation tags (position, gender, and object interaction) to prevent stale state
function ZomboDesire_Cleanup.resetAllAnimationTags()
    ZomboDesire.debugLog(MODULE_NAME, "Resetting position, gender, and object interaction tags")
    if ZomboDesire then
        ZomboDesire.relativePosition = nil
        ZomboDesire.zombieGenderTag = nil
        ZomboDesire.objectInteractionTag = nil
        ZomboDesire.debugLog(MODULE_NAME, "Position, gender, and object interaction tags reset to nil")
    end
end

return ZomboDesire_Cleanup
