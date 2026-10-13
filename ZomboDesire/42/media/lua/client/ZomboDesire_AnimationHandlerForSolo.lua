--- File: ZomboDesire/42/media/lua/client/ZomboDesire_AnimationHandlerForSolo.lua
--- Handler for playing solo animations on the player character
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_AnimationHandlerForSolo.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Main" -- Main module with debug functions
require "ZomboDesire_Utils" -- Utility functions (player controls, hand items, damage messages)

-- Core timed action system from Project Zomboid
require "TimedActions/ISBaseTimedAction"
local ISBaseTimedAction	 = ISBaseTimedAction
local ISTimedActionQueue = ISTimedActionQueue

-- Event system for handling animation markers and action events
require "AnimationEvents/ZomboDesire_EventsHandler"

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local floor      = math.floor
local format     = string.format
local match      = string.match
local type       = type
local tostring   = tostring
local ipairs     = ipairs
local pcall      = pcall

--- Module name for logging
--- @type string
local MODULE_NAME = "AnimationHandlerForSolo"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboDesire.isDebug in ZomboDesire_Main.lua).
--- Calls with cheap/no arguments use ZomboDesire.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboDesire.isDebug(MODULE_NAME)
end

-- ====================
-- Management variables
-- ====================
--- List of standard Project Zomboid animation events
--- These events are handled by the base game and not our custom handlers
--- @type table
local basicEvents = {
    Turn180Started       = true,
    Turn180TargetChanged = true,
    SetVariable          = true,
    NoAnimConditionsPass = true,
    NonLoopedAnimFadeOut = true,
    ActiveAnimLooped     = true,
    ActiveAnimFinishing  = true,
    ActiveAnimFinished   = true,
    PlaySound            = true,
    PlayerVoiceSound     = true,
    DeathSound           = true,
    Footstep             = true,
    FallOnFront          = true,
    PushAwayZombie       = true
}

-- ===============
-- Key statements
-- ===============
--- Module namespace - ensures we don't overwrite existing module
--- @type table
ZomboDesire_AnimationHandlerForSolo = ZomboDesire_AnimationHandlerForSolo or {}

-- Prior declaration of fields
--- @class ISSoloAnimationAction : ISBaseTimedAction
--- @field character IsoGameCharacter
--- @field animation string
--- @field duration number
--- @field overrideAnim boolean
--- @field stopOnWalk boolean
--- @field stopOnRun boolean
--- @field maxTime number
--- @field otherActions table|nil
--- @field stageConfig table|nil
--- @field onInterrupted function|nil
-- Create our custom timed action by extending the base timed action
-- This allows us to control animations with the game's action system
ISSoloAnimationAction = ISBaseTimedAction:derive("ISSoloAnimationAction")

-- ==================
-- Utility functions
-- ==================

--- Utility function to ensure correct ID display in debug logs
--- @param character IsoGameCharacter -- The character entity whose ID will be displayed
--- @return string -- A formatted string displaying the character's ID
local function getCharacterInfoString(character)
    if not character then return "nil character" end
    local id = character:getID() or "unknown"
    return format("ID -> %d", id)
end

--- Removes the Penis item from the character's hands and inventory
--- @param character IsoGameCharacter -- The character from which to remove the Penis item (can be a player or ZombHuman zombie)
local function removePenisFromPlayer(character)
    ZomboDesire.debugLog(MODULE_NAME, "Removing Penis item from character (could be a player or ZombHuman zombie)")

    -- Check if this is a player or another type of character
    local isPlayer = instanceof(character, "IsoPlayer")

    -- Check primary and secondary hands
    local primaryItem = character:getPrimaryHandItem()
    local secondaryItem = character:getSecondaryHandItem()

    -- Remove from primary hand if it contains Penis
    if primaryItem then
        local itemType = primaryItem:getType()
        if match(itemType, "Penis") then
            ZomboDesire.debugLog(MODULE_NAME, "Removing Penis from primary hand")
            if isPlayer then
                ---@diagnostic disable-next-line: param-type-mismatch
                ISTimedActionQueue.add(ISUnequipAction:new(character, primaryItem, 1))
            else
                -- For non-players (ZombHumans), remove directly
                ---@diagnostic disable-next-line: param-type-mismatch
                character:setSecondaryHandItem(nil)
            end
        end
    end

    -- Remove from secondary hand if it contains Penis
    if secondaryItem then
        local itemType = secondaryItem:getType()
        if match(itemType, "Penis") then
            ZomboDesire.debugLog(MODULE_NAME, "Removing Penis from secondary hand")
            if isPlayer then
                ---@diagnostic disable-next-line: param-type-mismatch
                ISTimedActionQueue.add(ISUnequipAction:new(character, secondaryItem, 1))
            else
                -- For non-players (ZombHumans), remove directly
                ---@diagnostic disable-next-line: param-type-mismatch
                character:setSecondaryHandItem(nil)
            end
        end
    end

    -- Remove from inventory
    local inventory = character:getInventory()
    if inventory then
        local items = inventory:getItems()
        local size = items:size()
        for i = 0, size - 1 do
            local item = items:get(i)
            local itemType = item:getType()
            if match(itemType, "Penis") then
                ZomboDesire.debugLog(MODULE_NAME, "Removing Penis from inventory: %s", itemType)
                inventory:Remove(item)
            end
        end
    end
end

-- ===================================
-- Damage detection during animations
-- ===================================

--- Global reference to the currently active solo animation action
--- @type ISSoloAnimationAction|nil
ZomboDesire_AnimationHandlerForSolo.currentAnimationAction = nil

--- Damage detection watching this handler's currentAnimationAction, factored out to ZomboDesire_Utils
--- since ZomboDesire_AnimationHandler needs the exact same interrupt logic (only the tracked action reference differs).
local registerDamageDetection, unregisterDamageDetection = ZomboDesire_Utils.createDamageDetection(
    MODULE_NAME,
    function() return ZomboDesire_AnimationHandlerForSolo.currentAnimationAction end,
    function() ZomboDesire_AnimationHandlerForSolo.currentAnimationAction = nil end
)

-- Damage detection events are registered per animation in start() and unregistered in stop()/perform()

-- =====================
-- Custom timed actions
-- =====================

--- Constructor for the solo animation action
--- Creates a new timed action for playing custom solo animations
--- @param character IsoGameCharacter -- The character (player) that will perform the animation
--- @param animName string -- The animation name as defined in the XML animation file
--- @param duration number -- The animation duration in milliseconds
--- @return table -- A table instance configured as an ISSoloAnimationAction object
---@diagnostic disable: inject-field
function ISSoloAnimationAction:new(character, animName, duration)
    ---@diagnostic disable-next-line: param-type-mismatch
    local o = ISBaseTimedAction.new(self, character)
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Creating new solo animation action -> character = %s, animation = %s, duration = %d",
            getCharacterInfoString(character), tostring(animName), duration)
    end

    -- Core properties
    ---@diagnostic disable: assign-type-mismatch, inject-field
    o.character = character			-- The character performing the animation
    o.animation = animName			-- The animation name (XML animNode key)
    o.duration = duration or 1000	-- Animation duration with fallback

    -- Animation control flags
    o.overrideAnim = true			-- Override any current animation
    o.stopOnWalk = true				-- Stop when walking (for solo animations)
    o.stopOnRun = true				-- Stop when running (for solo animations)
    o.maxTime = -1					-- Will be calculated in start() based on duration

    -- Stages initialization
    o.stageConfig = nil

    -- Optional callback invoked with the character when the animation is interrupted
    -- (e.g. by damage) instead of completing normally. Lets external callers (like
    -- ZomboLust's orgasm system) react immediately instead of relying on fixed timers.
    o.onInterrupted = nil
    ---@diagnostic enable: assign-type-mismatch, inject-field

    return o
end

--- Checks if the animation action can still be performed
--- Verifies the character exists and is still alive
--- @return boolean -- True if the action can proceed, false otherwise
function ISSoloAnimationAction:isValid()
    return self.character and not self.character:isDead()
end

--- Preparation before starting animation
--- This function is called by the action queue system before starting the action
--- For solo animations, we don't need to wait for anything
--- @return boolean -- Always returns false to allow the action to start immediately
function ISSoloAnimationAction:waitToStart()
    if not self.waitToStartCalled then
        self.waitToStartCalled = true
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "waitToStart called for character = %s",
                getCharacterInfoString(self.character))
        end
    end

    return false
end

--- Initializes and starts the animation
--- Sets up timing parameters and begins playing the animation on the character
--- Converts Blender animation frames to game engine time units
function ISSoloAnimationAction:start()
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "SoloAction START -> character = %s, animation = %s",
            getCharacterInfoString(self.character), self.animation)
    end

    -- Detect if this is a multi-stage animation
    local isMultiStage = self.stageConfig ~= nil
    local isFirstStage = false

    if isMultiStage then
        -- First stage has nextStageIndex == 2 (because it will play stage 2 next)
        isFirstStage = self.stageConfig.nextStageIndex == 2
    end

    -- Enable inventory blocking at the start of the first stage of a multi-stage solo animation
    if isMultiStage and isFirstStage then
        ZomboDesire.enableInventoryBlock()
        ZomboDesire.debugLog(MODULE_NAME, "Enabled inventory blocking for multi-stage solo animation (first stage)")
    end

    -- Calculate animation duration for the game engine
    local blenderFPS = 30 -- The animation created in Blender is at 30 fps

    -- The 1.6 multiplier is empirically determined to be correct
    -- This converts animation duration from Blender (frames@30fps) to PZ engine time
    local endAnimationTime = floor(self.duration * 1.6)

    -- Set the action duration in the game engine
    self.maxTime = endAnimationTime
    ZomboDesire.debugLog(MODULE_NAME, "Blender duration = %d frames, converted duration = %d PZ engine time",
        self.duration, endAnimationTime)
    self.action:setTime(self.maxTime)
    ZomboDesire.debugLog(MODULE_NAME, "Applied maxTime = %d to action", self.maxTime)

    -- Calculate duration in seconds for logging purposes
    local durationInSeconds = self.duration / blenderFPS
    local animationName = self.animation
    ZomboDesire.debugLog(MODULE_NAME, "About to setActionAnim -> '%s' (length = %.2f seconds)", animationName, durationInSeconds)

    -- Start the animation on the character
    self:setActionAnim(animationName)
    ZomboDesire.debugLog(MODULE_NAME, "SetActionAnim has been set -> '%s' (length = %.2f seconds)", animationName, durationInSeconds)

    -- Simulate time elapsed during this animation stage (10-30 minutes IGT)
    ZomboDesire_Utils.advanceGameTime(10, 30)

    -- Register this animation action for damage detection
    ZomboDesire_AnimationHandlerForSolo.currentAnimationAction = self
    ZomboDesire.debugLog(MODULE_NAME, "Registered solo animation action for damage detection")

    -- Register damage detection events for this animation
    registerDamageDetection()

    -- Set the animation as active
    ZomboDesire.debugLog(MODULE_NAME, "Animation started successfully")
end

--- Updates the animation state
--- Called every frame while the animation is active
function ISSoloAnimationAction:update()
    -- No special update logic needed for solo animations
end

--- Override animEvent: called by the engine when an <m_Events> marker is hit in the XML animation file
--- Dispatch only custom events; let vanilla handle core events
--- @param m_EventName string -- Name of the event
--- @param m_Time number -- Time elapsed since the beginning of the animation
function ISSoloAnimationAction:animEvent(m_EventName, m_Time)
    -- ZomboDesire.debugLog(MODULE_NAME, "DesireAction ANIM EVENT -> m_EventName = %s m_Time = %s", tostring(m_EventName), tostring(m_Time))

    -- If this is not a base vanilla Event, treat it as custom and load OUR module for this Event marker
    if not basicEvents[m_EventName] then
        ZomboDesire.debugLog(MODULE_NAME, "Looking for custom handler for '%s'", m_EventName)
        local markerHandler = ZomboDesire.EventMarkerModules[m_EventName]
        if type(markerHandler) == "function" then
            ZomboDesire.debugLog(MODULE_NAME, "Found handler for '%s', invoking", m_EventName)
            -- Invoke the event markerHandler: signature (actionInstance, m_EventName)
            local markerHandlerSuccess, markerHandlerError = pcall(markerHandler, self, m_EventName)
            if markerHandlerSuccess then
                ZomboDesire.debugLog(MODULE_NAME, "'%s' executed without error", m_EventName)
            else
                ZomboDesire.errorLog(MODULE_NAME, "Error in handler '%s' -> %s", m_EventName, tostring(markerHandlerError))
            end
            return
        else
            ZomboDesire.warningLog(MODULE_NAME, "No custom handler function for '%s'", m_EventName)
        end
    else
        -- For all other events (core PZ), do nothing here and let vanilla modules run
        -- ZomboDesire.debugLog(MODULE_NAME, "Not a custom FrameEvent markerHandler. Passing through vanilla Event '%s'", tostring(m_EventName))
    end
end

--- Override actionEvent: called by the engine on <ActionEvent>
--- Dispatch only custom events; let vanilla handle core events
--- @param event string -- The event name
function ISSoloAnimationAction:actionEvent(event)
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "DesireAction ACTION EVENT -> event = %s", tostring(event))
    end

    -- If this is not a base vanilla event, treat it as custom and load OUR module for this action marker
    if not basicEvents[event] then
        local actionHandler = ZomboDesire.ActionEventModules[event]
        if type(actionHandler) == "table" and type(actionHandler.onActionEvent) == "function" then
            -- Invoke the event actionHandler: signature (actionInstance)
            actionHandler.onActionEvent(self)
            if dbg() then
                ZomboDesire.debugLog(MODULE_NAME, "Custom ActionEvent actionHandler for custom event '%s'", tostring(event))
            end
            return
        end
    else
        -- For all other events (core PZ), do nothing here and let vanilla modules run
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Not a custom ActionEvent actionHandler. Passing through vanilla event '%s'", tostring(event))
        end
    end
end

--- Performs final cleanup when the animation is complete
--- Called by the action system when the action time reaches maxTime
function ISSoloAnimationAction:perform()
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "SoloAction PERFORM -> character = %s, animation = %s",
            getCharacterInfoString(self.character), self.animation)
    end

    -- Complete the action
    ISBaseTimedAction.perform(self)

    -- Check if this is part of a multi-stage animation
    if not self.stageConfig or not self.stageConfig.nextStageIndex then
        -- Single-stage animation: Remove Penis item at the end
        removePenisFromPlayer(self.character)

        -- Clear damage detection reference when animation ends normally
        if ZomboDesire_AnimationHandlerForSolo.currentAnimationAction == self then
            ZomboDesire_AnimationHandlerForSolo.currentAnimationAction = nil
            unregisterDamageDetection()
        end
        return
    end

    local nextStageIndex = self.stageConfig.nextStageIndex
    local actorConfig = self.stageConfig.actorConfig
    local animName = self.stageConfig.animName

    -- Check if there's a next stage to play
    if not actorConfig or not actorConfig.stages or not actorConfig.stages[nextStageIndex] then
        ZomboDesire.debugLog(MODULE_NAME, "Multi-stage animation sequence completed")

        -- Disable inventory blocking when multi-stage solo animation ends normally
        ZomboDesire.disableInventoryBlock()
        ZomboDesire.debugLog(MODULE_NAME, "Disabled inventory blocking - multi-stage solo animation sequence completed")

        -- Remove Penis item at the end of multi-stage animations
        removePenisFromPlayer(self.character)

        -- Clear damage detection reference when animation ends normally
        if ZomboDesire_AnimationHandlerForSolo.currentAnimationAction == self then
            ZomboDesire_AnimationHandlerForSolo.currentAnimationAction = nil
            unregisterDamageDetection()
        end
        return
    end

    -- Continue with the next stage animation
    local nextStage = actorConfig.stages[nextStageIndex]
    local nextAnimName = nextStage.perform
    local nextDuration = nextStage.duration

    ZomboDesire.debugLog(MODULE_NAME, "Playing next stage animation -> %s with duration %d",
        nextAnimName, nextDuration)

    -- Create a new action for the next stage
    local nextAction = ISSoloAnimationAction:new(self.character, nextAnimName, nextDuration)

    -- Carry the interruption callback over to the next stage
    nextAction.onInterrupted = self.onInterrupted

    -- Pass stage configuration to the next action
    nextAction.stageConfig = {
        actorConfig = actorConfig,
        animName = animName,
        nextStageIndex = nextStageIndex + 1
    }

    -- Queue the next action
    ---@diagnostic disable-next-line: param-type-mismatch
    ISTimedActionQueue.add(nextAction)
end

--- Cleans up after the animation completes
--- Resets any state changes made during the animation
function ISSoloAnimationAction:stop()
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "SoloAction STOP -> character = %s, animation = %s",
            getCharacterInfoString(self.character), self.animation)
    end

    -- Disable inventory blocking on solo animation interruption
    ZomboDesire.disableInventoryBlock()
    ZomboDesire.debugLog(MODULE_NAME, "Disabled inventory blocking on solo animation interruption")

    -- Remove Penis item when animation is interrupted
    removePenisFromPlayer(self.character)

    -- Clear damage detection reference when animation is interrupted
    if ZomboDesire_AnimationHandlerForSolo.currentAnimationAction == self then
        ZomboDesire_AnimationHandlerForSolo.currentAnimationAction = nil
        ZomboDesire.debugLog(MODULE_NAME, "ATTENTION - Cleared damage detection reference on solo animation interruption")
        unregisterDamageDetection()
    end

    -- Notify the caller that the animation was interrupted (e.g. ZomboLust orgasm
    -- effects), so it can react immediately instead of waiting on fixed timers
    if self.onInterrupted then
        local status, err = pcall(self.onInterrupted, self.character)
        if not status and dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "ERROR in onInterrupted callback -> %s", tostring(err))
        end
    end

    -- Reset any animation state if needed
    ISBaseTimedAction.stop(self)
end

-- ==========================
-- Animation Config Functions
-- ==========================

--- Loads and validates animation configuration for a given animation name
--- @param animName string -- Key for the animation config
--- @return table|nil -- The animation configuration or nil if invalid
local function loadAnimationConfig(animName)
    ZomboDesire.debugLog(MODULE_NAME, "Loading solo animation configuration for '%s'", animName)
    ---@type table|nil
    local config = ZomboDesire.AnimationConfigs[animName]

    if not config then
        ZomboDesire.errorLog(MODULE_NAME, "No valid solo animations found or no config for animName -> %s", tostring(animName))
        return nil
    end

    ---@cast config table

    -- Validate the configuration
    if not config.actors then
        ZomboDesire.errorLog(MODULE_NAME, "Invalid solo animation config for '%s' -> missing 'actors' table", animName)
        return nil
    end

    ZomboDesire.debugLog(MODULE_NAME, "Solo animation configuration loaded successfully for '%s'", animName)
    return config
end

--- Determines the appropriate actor configuration based on player gender
--- @param player IsoPlayer -- The player character
--- @param config table -- The animation configuration
--- @return table|nil -- The actor configuration or nil if invalid
local function determineActorConfig(player, config)
    ZomboDesire.debugLog(MODULE_NAME, "Determining actor configuration for solo animation")

    -- Get player gender
    local descriptor = player:getDescriptor()
    local isFemale = descriptor and descriptor:isFemale()
    local gender = isFemale and "Female" or "Male"

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Player gender detected -> isFemale = %s, gender = %s", tostring(isFemale), gender)
    end

    -- Browse the actors table to find the configuration corresponding to the genre
    local actorConfig = nil
    for _, actor in ipairs(config.actors) do
        if actor.gender == gender then
            actorConfig = actor
            break
        end
    end

    if not actorConfig then
        ZomboDesire.errorLog(MODULE_NAME, "No actor configuration found for gender '%s'", gender)
        return nil
    end

    -- Validate the actor configuration
    if not actorConfig.stages or #actorConfig.stages == 0 then
        ZomboDesire.errorLog(MODULE_NAME, "Invalid actor configuration -> missing or empty 'stages' table")
        return nil
    end

    ZomboDesire.debugLog(MODULE_NAME, "Actor configuration determined successfully")
    return actorConfig
end

--- Creates animation actions for the player
--- @param player IsoPlayer -- The player character
--- @param actorConfig table -- The actor configuration
--- @param animName string -- The animation name (for fallback)
--- @param overrideDuration number -- Optional duration override for single-step animations
--- @param onInterrupted function|nil -- Optional callback invoked with the character if the animation is interrupted
--- @return table -- Array of created animation actions
local function createAnimationActions(player, actorConfig, animName, overrideDuration, onInterrupted)
    -- Queue only the first stage; subsequent stages triggered via perform callback
    local firstStage = actorConfig.stages[1]
    -- Use the duration provided as a parameter only if it is specified and it is not a multi-step animation
    local duration = overrideDuration or firstStage.duration or actorConfig.defaultDuration or 1000
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "firstStage.perform = %s duration = %d",
            tostring(firstStage and firstStage.perform), duration)
    end

    local actions = {}

    -- Create the player action
    local playerAction = nil

    -- Determine the animation name
    local animationName = firstStage.perform or animName
    ZomboDesire.debugLog(MODULE_NAME, "Creating solo animation action for player with animation '%s'", animationName)

    -- Create the action
    playerAction = ISSoloAnimationAction:new(player, animationName, duration)
    playerAction.onInterrupted = onInterrupted

    -- Add stage configuration if this is a multi-stage animation
    if #actorConfig.stages > 1 then
        playerAction.stageConfig = {
            actorConfig = actorConfig,
            animName = animName,
            nextStageIndex = 2  -- Index of the next stage to play
        }
        ZomboDesire.debugLog(MODULE_NAME, "Setting up multi-stage animation with %d total stages", #actorConfig.stages)
    end

    table.insert(actions, playerAction)

    ZomboDesire.debugLog(MODULE_NAME, "Created %d animation actions", #actions)
    return actions
end

--- Queues animation actions for execution
--- @param actions table -- Array of animation actions
local function queueAnimationActions(actions)
    for _, animAction in ipairs(actions) do
        local character = animAction.character

        -- Add the action to the queue
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Queueing animation action for character %s",
                getCharacterInfoString(character))
        end
        ISTimedActionQueue.clear(character)
        ZomboDesire.debugLog(MODULE_NAME, "Add animation action to queue")
        ISTimedActionQueue.add(animAction)
    end
end

--- Main function to play a solo animation on the player
--- Coordinates the entire animation sequence from configuration loading to execution
--- @param player IsoPlayer -- The player character
--- @param animName string -- Key for the animation config
--- @param duration number -- The duration of the animation in frames (at 30fps)
--- @param onInterrupted function|nil -- Optional callback invoked with the character if the animation is interrupted (e.g. by damage) instead of completing normally
function ZomboDesire_AnimationHandlerForSolo.playAnimationSolo(player, animName, duration, onInterrupted)
    -- Check if the player is valid
    if not player then
        ZomboDesire.errorLog(MODULE_NAME, "Invalid player for solo animation")
        return
    end

    if not animName then
        ZomboDesire.errorLog(MODULE_NAME, "Cannot play animation -> animName is nil")
        return
    end

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Playing solo animation '%s' on player %s with duration %d",
            animName, getCharacterInfoString(player), duration or 0)
    end

    -- Step 1: Load and validate animation configuration
    local config = loadAnimationConfig(animName)
    if not config then
        ZomboDesire.errorLog(MODULE_NAME, "Failed to load animation configuration for '%s'", animName)
        return
    end
    ZomboDesire.debugLog(MODULE_NAME, "Using configuration-based animation for '%s'", animName)

    -- Step 2: Determine actor configuration based on player's gender
    local actorConfig = determineActorConfig(player, config)
    if not actorConfig then
        ZomboDesire.errorLog(MODULE_NAME, "Failed to determine actor configuration for '%s'", animName)
        return
    end

    -- Step 3: Unequip hand items so they don't clip through the character model
    ZomboDesire_Utils.unequipHandItems(player)

    -- Step 4: Create animation actions for the player
    -- For multi-step animations, the duration parameter is ignored.
    local isMultiStage = actorConfig.stages and #actorConfig.stages > 1
    local actions = createAnimationActions(player, actorConfig, animName, isMultiStage and nil or duration, onInterrupted)
    if not actions or #actions == 0 then
        ZomboDesire.errorLog(MODULE_NAME, "Failed to create animation actions for '%s'", animName)
        return
    end

    -- Step 5: Queue the actions for execution
    queueAnimationActions(actions)
end

-- Return the module for requiring
return ZomboDesire_AnimationHandlerForSolo
