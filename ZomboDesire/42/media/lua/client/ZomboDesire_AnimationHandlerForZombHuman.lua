--- File: ZomboDesire/42/media/lua/client/ZomboDesire_AnimationHandlerForZombHuman.lua
--- Module to force ZombHuman (zombie with brain) to play character-specific animations
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_AnimationHandlerForZombHuman.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Main" -- Main module with debug functions
require "ZomboDesire/ZomboDesire_Init"
require "ZomboDesire_Utils"

-- Integration with the ZombHuman system
require "ZombHuman/ZomboDesire_ZombHumanBrain"
require "ZombHuman/ZomboDesire_ZombHumanTask"
require "ZombHuman/ZomboDesire_ZombHumanActions"

-- ==============================
-- Module namespace declaration
-- ==============================

local ZomboDesire_ZombHumanAnimation = {}

--- Module name for logging
--- @type string
local MODULE_NAME = "AnimationHandlerForZombHuman"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboDesire.isDebug in ZomboDesire_Main.lua).
--- Calls with cheap/no arguments use ZomboDesire.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboDesire.isDebug(MODULE_NAME)
end

--- Cached ModOptions object
local modOptions = nil

-- ===================
-- Type declarations
-- ===================

--- Multi-stage tracking info stored on a ZombHuman's modData under the key "ZomboDesireMultiStage".
--- Created in playZombHumanAnimation/play, advanced in handleNextStageCompletion.
--- Also read by other mods (e.g. ZomboLust_FXHandler.lua) to know which stage a ZombHuman has actually reached.
--- @class ZomboDesireMultiStageInfo
--- @field actorConfig table -- The ZombHuman actor's resolved config (character, stages)
--- @field animName string -- The animation config name this sequence belongs to
--- @field currentStage integer -- The stage index the ZombHuman is currently on (1-based)
--- @field totalStages integer -- The total number of stages in this sequence

-- ==================
-- Utility functions
-- ==================

--- Formats a debug string containing information about a zombie
--- @param zombie IsoZombie -- The zombie to get information from
--- @return string -- Formatted string with ID and persistent ID
local function getZombieInfoString(zombie)
    if not zombie then return "nil zombie" end
    local id = zombie:getID() or "unknown"
    local persistentID = zombie:getPersistentOutfitID() or 0
    return string.format("Character ID -> %d (persistentID = %d)", id, persistentID)
end

--- Selects a random performance string from a table or returns the string itself
--- @param value string|table -- The performance string or a table of strings
--- @return string -- The selected performance string
local function selectRandomPerform(value)
    if type(value) == "table" then
        local index = ZombRand(#value) + 1
        return value[index]
    elseif type(value) == "string" then
        return value
    else
        return ""
    end
end

-- ===================================
-- Damage detection during animations
-- ===================================

local currentZombHuman = nil

--- Event handler for when a zombie is hit
--- Interrupts animation if the hit zombie is the one currently in animation
--- @param hitZombie IsoZombie -- The zombie that was hit
--- @param attacker IsoGameCharacter -- The character that hit the zombie
--- @param bodyPart BodyPartType -- The body part that was hit
--- @param weapon HandWeapon -- The weapon used for the hit
local function onZombHumanHit(hitZombie, attacker, bodyPart, weapon)
    if not hitZombie or hitZombie ~= currentZombHuman then return end

    local currentAction = ZomboDesire_AnimationHandler.currentAnimationAction
    if not currentAction then return end

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "ATTENTION - Our ZombHuman %s took damage during animation - interrupting",
            getZombieInfoString(hitZombie))
    end

    ZomboDesire_ZombHumanAnimation.performZombHumanAnimationCleanup(hitZombie)

    if currentAction.forceStop then
        currentAction:forceStop()
    end
end

--- Registers damage detection for a specific ZombHuman during animation
--- @param zombHuman IsoZombie -- The ZombHuman to monitor
function ZomboDesire_ZombHumanAnimation.registerZombHumanDamageDetection(zombHuman)
    currentZombHuman = zombHuman
    Events.OnHitZombie.Add(onZombHumanHit)
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Damage detection registered for ZombHuman %s", getZombieInfoString(zombHuman))
    end
end

--- Unregisters damage detection for ZombHuman
function ZomboDesire_ZombHumanAnimation.unregisterZombHumanDamageDetection()
    Events.OnHitZombie.Remove(onZombHumanHit)
    currentZombHuman = nil
end

--- Performs cleanup after a ZombHuman animation ends or is interrupted
--- @param zombHuman IsoZombie -- The ZombHuman to cleanup
function ZomboDesire_ZombHumanAnimation.performZombHumanAnimationCleanup(zombHuman)
    if not zombHuman then return end

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Cleaning up animation state for ZombHuman %s", getZombieInfoString(zombHuman))
    end

    local md = zombHuman:getModData()

    if md.ZomboDesireMultiStage then
        md.ZomboDesireMultiStage = nil
    end

    -- Clear ZombHuman tasks
    ZomboDesire_ZombHumanTask.ClearTasks(zombHuman)

    -- Force the animation engine to exit the Bump state to prevent freezing
    -- This compensates for cases where the XML event BumpAnimFinished=true is not reached (e.g., interrupted before Stage 3 at 0.900)
    zombHuman:setVariable("BumpAnimFinished", true)

    -- Reset animation flags
    ZomboDesire.zombHumanFinalPosition = nil
    ZomboDesire.zombHumanFinalFacing = nil
    ZomboDesire.playerAnimationStarted = false

    ZomboDesire_ZombHumanAnimation.unregisterZombHumanDamageDetection()

    ZomboDesire_AnimationHandler.currentAnimationAction = nil
end

-- =========================
-- Private helper functions
-- =========================

local AnimConfigs = ZomboDesire and ZomboDesire.AnimationConfigs

--- Validates if a character is a ZombHuman
--- @param char IsoGameCharacter -- The character to check
--- @return boolean -- true if character is a valid ZombHuman
function ZomboDesire_ZombHumanAnimation.CheckZombHuman(char)
    if not char then return false end
    if not char:isZombie() then return false end
    return true
end

--- Plays a specific animation on a ZombHuman using the bump system
--- @param char IsoGameCharacter -- The ZombHuman
--- @param animKey string -- The animation key to play
function ZomboDesire_ZombHumanAnimation.playBump(char, animKey)
    -- Reset the animation finished flag to ensure the first animation stage in the next encounter is not skipped
    -- This variable was set back to true in ZomboDesire_Cleanup.lua within the removeZombHumanBrain function to prevent
    -- the zombie from freezing in case the animation stops abruptly.
    -- We must reset it to false here, otherwise the engine would skip the first stage and stay in Idle
    char:setVariable("BumpAnimFinished", false)
    char:setBumpType(animKey)

    -- Simulate time elapsed during this animation stage (10-30 minutes IGT by default)
    -- ZomboLust's Cute/Fugly traits scale this range when present (Cute x2, Fugly x0.5)
    local minMinutes, maxMinutes = 10, 30
    local action = ZomboDesire_AnimationHandler.currentAnimationAction
    local player = action and action.character
    if player and ZomboLustRegistries and ZomboLustRegistries.Traits then
        if ZomboLustRegistries.Traits.Cute and player:hasTrait(ZomboLustRegistries.Traits.Cute) then
            minMinutes, maxMinutes = minMinutes * 2, maxMinutes * 2
        elseif ZomboLustRegistries.Traits.Fugly and player:hasTrait(ZomboLustRegistries.Traits.Fugly) then
            minMinutes, maxMinutes = math.floor(minMinutes * 0.5), math.floor(maxMinutes * 0.5)
        end
    end

    ZomboDesire_Utils.advanceGameTime(minMinutes, maxMinutes)
end

--- Retrieves and processes animation configuration for a given animation name
--- @param animName string -- The name of the animation configuration
--- @return table|nil -- The processed animation configuration or nil if not found
local function getAnimationConfig(animName)
    if not AnimConfigs then 
        ZomboDesire.errorLog(MODULE_NAME, "ZomboDesire.AnimationConfigs is nil when trying to load config for '%s'", animName)
        return nil 
    end

    local cfg = AnimConfigs[animName]
    if not cfg then 
        ZomboDesire.warningLog(MODULE_NAME, "Animation configuration not found for '%s'", animName)
        return nil 
    end

    ZomboDesire.debugLog(MODULE_NAME, "Found animation config for '%s' with %d actors", animName, #cfg.actors)

    local configCopy = {}
    for k, v in pairs(cfg) do
        configCopy[k] = v
    end

    -- Apply Stage 2 multiplier
    ---@type number
    local multiplier = 1
    if not modOptions then
        modOptions = PZAPI.ModOptions:getOptions("ZomboDesire")
    end
    if modOptions then
        local option = modOptions:getOption("stage2Multiplier")
        if option and option.getValue then
            local index = tonumber(option:getValue()) or 1
            local step = getActivatedMods():contains("ZomboLust") and 5 or 1
            multiplier = index * step
        end
    end

    if multiplier > 1 then
        ZomboDesire.debugLog(MODULE_NAME, "Applying Stage 2 duration multiplier: %.2f", multiplier)
    end

    configCopy.actors = {}
    for i = 1, #cfg.actors do
        local actor = cfg.actors[i]
        configCopy.actors[i] = { character = actor.character, stages = {} }
        for j = 1, #actor.stages do
            local stage = actor.stages[j]
            local stageDuration = stage.duration
            local totalStages = #actor.stages

            -- Multiply duration if configured
            local shouldMultiply = false
            if totalStages == 3 then
                shouldMultiply = (j == 2)
            elseif totalStages == 5 then
                shouldMultiply = (j >= 2 and j <= 4)
            end

            if shouldMultiply and multiplier > 1 then
                stageDuration = stageDuration * multiplier
            end

            configCopy.actors[i].stages[j] = {
                perform = selectRandomPerform(stage.perform),
                duration = stageDuration
            }
        end
    end

    ZomboDesire.debugLog(MODULE_NAME, "Loaded animation configuration for '%s' with Stage 2 duration: %d frames (unscaled: %d)",
        animName, configCopy.actors[1].stages[2].duration, cfg.actors[1].stages[2].duration)

    return configCopy
end

--- Calculates the duration of an animation stage in ticks
--- @param stage table -- The stage configuration containing duration in frames
--- @param animName string -- The name of the animation
--- @param isLoopingStage boolean -- Whether this is a looping stage (applies different tick rate)
--- @param isLastStage boolean -- Whether this is the last stage of the animation
--- @return number -- Duration in game ticks
local function calculateAnimationDuration(stage, animName, isLoopingStage, isLastStage)
    local durationFrames = stage.duration

    -- Sync with Player TimedAction in ZomboDesire_AnimationHandler.lua
    -- A 30 fps animation corresponds to 2 engine ticks per frame (60 ticks per second)
    -- To match Player's 1.6 multiplier (Begin -> 8s for 240 frames or End -> 4s for 120 frames), the ZombHuman needs 2.0
    -- To match Player's 3.2 multiplier (Stage 2 -> 10s for 300 frames), the ZombHuman needs 4.0
    -- These are the perfect values to synchronize everyone
    -- To prevent the zombie freeze, only the endAnimationTime value should be modified in ZomboDesire_AnimationHandler.lua
    local multiplier = 2.0
    if isLoopingStage then
        multiplier = 4.0 -- Extra padding for looping Stage
    end

    local ticksNeeded = durationFrames * multiplier
    ticksNeeded = ticksNeeded - ticksNeeded % 1

    return ticksNeeded
end

--- Creates and inserts a CustomAnim task into the ZombHuman's task system
--- @param zombHuman IsoZombie -- The ZombHuman character
--- @param animKey string -- The animation key to play
--- @param duration number -- Duration of the animation task
--- @param multiStageInfo ZomboDesireMultiStageInfo|nil -- Optional multi-stage tracking info
--- @param isContinuation boolean -- If true, we don't clear the queue (avoids losing next stage)
function ZomboDesire_ZombHumanAnimation.createAndInsertAnimationTask(zombHuman, animKey, duration, multiStageInfo, isContinuation)
    local task = {
        action = "CustomAnim",
        anim = animKey,
        time = duration,
        state = "NEW"
    }

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Inserting CustomAnim task for %s -> anim '%s' for %d ticks",
            getZombieInfoString(zombHuman), animKey, duration)
    end

    -- Only clear tasks when starting a NEW animation sequence
    -- For continuations, the current task is still being processed and will be removed by ZombHumanUpdate
    if not isContinuation then
        ZomboDesire.debugLog(MODULE_NAME, "New sequence detected -> clearing existing tasks (Idle fallback)")
        ZomboDesire_ZombHumanTask.ClearTasks(zombHuman)
    end

    ZomboDesire_ZombHumanTask.AddTask(zombHuman, task)

    local md = zombHuman:getModData()
    if multiStageInfo then
        md.ZomboDesireMultiStage = multiStageInfo
    end
end

--- Handles the transition to the next stage of a multi-stage animation
--- @param zombHuman IsoZombie -- The ZombHuman character
--- @param multiStage ZomboDesireMultiStageInfo -- The multi-stage tracking information
--- @param md table -- The character's mod data
function ZomboDesire_ZombHumanAnimation.handleNextStageCompletion(zombHuman, multiStage, md)
    local currentStage = multiStage.currentStage
    local totalStages = multiStage.totalStages
    local actorCfg = multiStage.actorConfig

    if currentStage < totalStages then
        local nextStageIndex = currentStage + 1
        local stage = actorCfg.stages[nextStageIndex]
        local animName = multiStage.animName
        local isLastStage = (nextStageIndex == totalStages)

        -- Determine if this is a looping stage (2 for 3-stage anim, 2-4 for 5-stage anim)
        local isLoopingStage = false
        if totalStages == 3 then
            isLoopingStage = (nextStageIndex == 2)
        elseif totalStages == 5 then
            isLoopingStage = (nextStageIndex >= 2 and nextStageIndex <= 4)
        end

        local duration = calculateAnimationDuration(stage, animName, isLoopingStage, isLastStage)

        multiStage.currentStage = nextStageIndex

        ZomboDesire.debugLog(MODULE_NAME, "ZombHuman starting Stage %d/%d -> %s", nextStageIndex, totalStages, stage.perform)

        ZomboDesire_ZombHumanAnimation.playBump(zombHuman, stage.perform)
        ZomboDesire_ZombHumanAnimation.createAndInsertAnimationTask(zombHuman, stage.perform, duration, multiStage, true)
    else
        -- End of animation
        md.ZomboDesireMultiStage = nil
        ZomboDesire.debugLog(MODULE_NAME, "ZombHuman multi-stage sequence completed")
    end
end

-- Main function to play the animation sequence

--- Starts a multi-stage animation sequence on a ZombHuman
--- @param zombHuman IsoZombie -- The ZombHuman character
--- @param animName string -- The name of the animation configuration to play
--- @return boolean -- true if animation started successfully
function ZomboDesire_ZombHumanAnimation.playZombHumanAnimation(zombHuman, animName)
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "playZombHumanAnimation called for %s with animName '%s'",
            getZombieInfoString(zombHuman), animName)
    end

    local config = getAnimationConfig(animName)
    if not config then 
        ZomboDesire.errorLog(MODULE_NAME, "Failed to start animation: config for '%s' not found", animName)
        return false 
    end

    -- Find ZombHuman actor in config
    local actorCfg = nil
    for i = 1, #config.actors do
        local actor = config.actors[i]
        if actor.character == "zombie" or actor.character == "ZombHuman0" then
            actorCfg = actor
            break
        end
    end

    if not actorCfg then 
        ZomboDesire.errorLog(MODULE_NAME, "Failed to start animation: No ZombHuman actor found in config for '%s'", animName)
        return false 
    end

    ZomboDesire.debugLog(MODULE_NAME, "ZombHuman starting Stage 1/2 -> %s", actorCfg.stages[1].perform)

    -- Play first stage
    local stage = actorCfg.stages[1]
    local totalStages = #actorCfg.stages
    local isLastStage = (totalStages == 1)
    local duration = calculateAnimationDuration(stage, animName, false, isLastStage)

    local multiStageInfo = {
        animName = animName,
        currentStage = 1,
        totalStages = totalStages,
        actorConfig = actorCfg
    }

    ZomboDesire_ZombHumanAnimation.playBump(zombHuman, stage.perform)
    ZomboDesire_ZombHumanAnimation.createAndInsertAnimationTask(zombHuman, stage.perform, duration, multiStageInfo, false)

    ZomboDesire.debugLog(MODULE_NAME, "playZombHumanAnimation() successfully initiated for '%s'", animName)

    return true
end

--- Higher-level function to start an animation for ZombHuman, called by animation handlers
--- @param zombHuman IsoZombie -- The ZombHuman involved
--- @param player IsoPlayer -- The player involved
--- @param animName string -- The name of the animation
--- @param config table -- The full animation configuration
--- @return boolean -- true if animation started successfully
function ZomboDesire_ZombHumanAnimation.play(zombHuman, player, animName, config)
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "play called for %s with animName '%s'", getZombieInfoString(zombHuman), animName)
    end

    -- Find ZombHuman actor in config
    local actorCfg = nil
    for i = 1, #config.actors do
        local actor = config.actors[i]
        if actor.character == "zombie" or actor.character == "ZombHuman0" then
            actorCfg = actor
            break
        end
    end

    if not actorCfg then 
        ZomboDesire.errorLog(MODULE_NAME, "No ZombHuman actor config found for animation '%s'", animName)
        return false 
    end

    -- Play first stage
    local stage = actorCfg.stages[1]
    local isFirstStageLast = (#actorCfg.stages == 1)
    local duration = calculateAnimationDuration(stage, animName, false, isFirstStageLast)

    local multiStageInfo = {
        actorConfig = actorCfg, -- Store full config for next stages
        animName = animName,
        currentStage = 1,
        totalStages = #actorCfg.stages
    }

    ZomboDesire_ZombHumanAnimation.playBump(zombHuman, stage.perform)
    ZomboDesire_ZombHumanAnimation.createAndInsertAnimationTask(zombHuman, stage.perform, duration, multiStageInfo, false)

    ZomboDesire.debugLog(MODULE_NAME, "play() successfully initiated multi-stage animation sequence for '%s'", animName)

    return true
end

return ZomboDesire_ZombHumanAnimation
