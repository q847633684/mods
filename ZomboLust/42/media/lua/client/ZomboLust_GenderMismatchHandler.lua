-- File: ZomboLust/42/media/lua/client/ZomboLust_GenderMismatchHandler.lua
-- Integration point between ZomboDesire and ZomboLust for gender mismatch handling
-- Applies clothing stripping before delegating to ZomboDesire's handler
-- @author BlaBla 2025

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_GenderMismatchHandler.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"
local ZomboLust_ClothingStrip = require "Clothing/ZomboLust_ClothingStrip"
local ZomboDesire_Cleanup = require "ZomboDesire_Cleanup"
local ZomboDesire_Utils = require "ZomboDesire_Utils"

-- Module name for logging
--- @type string
local MODULE_NAME = "GenderMismatchHandler"

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
local ZomboLust_GenderMismatchHandler = {}

--- Check if the player's health or endurance is low enough to break Dominate's immunity
--- Health threshold mirrors vanilla's own "Severe damage" body status band (getOverallBodyHealth() <= 50)
--- Endurance threshold reuses vanilla's own getEnduranceWarning(), the same value the game
--- uses to detect that the player is getting too tired (e.g. it gates Fitness/Sprinting XP gain)
--- @param player IsoPlayer -- The player character
--- @return boolean -- True if health or endurance is low
local function isPlayerWeakened(player)
    local isHealthLow = player:getBodyDamage():getOverallBodyHealth() <= 50
    local isEnduranceLow = player:getStats():get(CharacterStat.ENDURANCE) <= player:getStats():getEnduranceWarning()
    return isHealthLow or isEnduranceLow
end

--- End the collision cleanly without triggering sexual animations
--- Used both when clothing was successfully stripped and when the ButtonedUp
--- trait causes the zombie to fail its grab attempt
--- @param player IsoPlayer -- The player character
--- @param character IsoZombie -- The ZombHuman that collided with the player
local function endCollisionCleanly(player, character)
    -- Reset all animation tags to prevent stale state
    ZomboDesire_Cleanup.resetAllAnimationTags()

    -- Re-enable player controls
    ZomboDesire_Utils.enablePlayerControls(player)

    -- Set zombie to normal mode if it's a zombie
    if character:isZombie() then
        character:setUseless(false)
    end
end

--- Handle gender mismatch with clothing stripping
--- This function is called when a player collides with a ZombHuman of different gender
--- It applies clothing stripping and then delegates to ZomboDesire's handler
--- @param player IsoPlayer -- The player character
--- @param character IsoZombie -- The ZombHuman that collided with the player
--- @param characterGender string -- The gender of the attacking character ('M' or 'F')
--- @param forceModTag string -- The mod tag to force for animations
--- @param ZomboDesire_HandleGenderMismatch function -- The original ZomboDesire handler function
function ZomboLust_GenderMismatchHandler.handleCollisionWithStripping(
    player,
    character,
    characterGender,
    forceModTag,
    ZomboDesire_HandleGenderMismatch
)
    ZomboLust.debugLog(MODULE_NAME, "handleCollisionWithStripping called")

    if not player or not character then
        ZomboLust.errorLog(MODULE_NAME, "Invalid player or character parameters")
        return
    end

    -- Guard Clause: Dominate trait makes the player immune to stripping and defeat
    -- entirely, unless their health or endurance is low - end the collision cleanly
    -- without stripping or escalating to sexual animations
    if player:hasTrait(ZomboLustRegistries.Traits.Dominate) and not isPlayerWeakened(player) then
        ZomboLust.debugLog(MODULE_NAME, "Player has Dominate trait and is not weakened - zombie failed to overpower the player")
        ZomboLust_ClothingStrip.playFailedGrabFeedback(character, player, "IGUI_ZomboLust_Dominate_Failed")
        endCollisionCleanly(player, character)
        return
    end

    -- Guard Clause: ButtonedUp trait gives the player a chance to have the zombie
    -- fail its grab entirely - end the collision cleanly without stripping or
    -- escalating to sexual animations
    if player:hasTrait(ZomboLustRegistries.Traits.ButtonedUp) and ZombRand(2) == 0 then
        ZomboLust.debugLog(MODULE_NAME, "Player has ButtonedUp trait - chance triggered, zombie failed to grab clothing")
        ZomboLust_ClothingStrip.playFailedGrabFeedback(character, player)
        endCollisionCleanly(player, character)
        return
    end

    -- Attempt to strip the player before sexual animations
    -- Remove 1 clothing item by default, or up to 2 (50% chance) if the player has the BaggyStyle trait
    local numToRemove = 1
    if player:hasTrait(ZomboLustRegistries.Traits.BaggyStyle) and ZombRand(2) == 0 then
        numToRemove = 2
        ZomboLust.debugLog(MODULE_NAME, "Player has BaggyStyle trait - chance triggered, allowing up to 2 items to be stripped")
    end

    local stripSucceeded = ZomboLust_ClothingStrip.attemptStripping(
        character,
        player,
        numToRemove
    )

    -- Guard Clause: If stripping failed, proceed with sexual animations instead
    if not stripSucceeded then
        -- No clothes left to strip - proceed with sexual animations
        ZomboLust.debugLog(MODULE_NAME, "No clothing to strip - delegating to ZomboDesire_HandleGenderMismatch for sexual animations")
        if ZomboDesire_HandleGenderMismatch then
            ZomboDesire_HandleGenderMismatch(player, character, characterGender, forceModTag)
        end
        return
    end

    -- Stripping succeeded, end the collision here (progressive stripping)
    ZomboLust.debugLog(MODULE_NAME, "Clothing successfully stripped - ending collision without sexual animations")

    endCollisionCleanly(player, character)
end

return ZomboLust_GenderMismatchHandler
