--- File: ZomboDesire/42/media/lua/client/ZomboDesire_AnimationHandler.lua
--- Handler for playing configured animations between player and zombHuman, and triggers cleanup after animation ends
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_AnimationHandler.lua loaded")

-- =============
-- Dependencies
-- =============
--- @class (partial) ZomboDesire_AnimationHandler
ZomboDesire_AnimationHandler = ZomboDesire_AnimationHandler or {}
require "ZomboDesire_Main" -- Main module with debug functions
require "ZomboDesire_Utils" -- Utility functions for zombie management and knockback control

-- Core timed action system from Project Zomboid
require "TimedActions/ISBaseTimedAction"
local ISBaseTimedAction	 = ISBaseTimedAction
local ISTimedActionQueue = ISTimedActionQueue

-- Inventory hooks to prevent drag-and-drop during multi-stage animations
require "ZomboDesire_InventoryHooks"

-- Special animation handler for zombHuman NPCs
require "ZombHuman/ZomboDesire_ZombHumanTask"
ZomboDesire_ZombHumanAnimation = require "ZomboDesire_AnimationHandlerForZombHuman"
---@diagnostic disable-next-line: inject-field
ZomboDesire_AnimationHandler.registerZombHumanDamageDetection = ZomboDesire_ZombHumanAnimation.registerZombHumanDamageDetection

-- Mini-game for Stage 1
ZomboDesire_MiniGame = require "MiniGame/ZomboDesire_MiniGame"

-- Event system for handling animation markers and action events
require "AnimationEvents/ZomboDesire_EventsHandler"

--- Module name for logging
--- @type string
local MODULE_NAME = "AnimationHandler"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboDesire.isDebug in ZomboDesire_Main.lua).
--- Calls with cheap/no arguments use ZomboDesire.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboDesire.isDebug(MODULE_NAME)
end

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local string   = string
local type     = type
local tostring = tostring

-- ====================
-- Management variables
-- ====================

--- List of standard Project Zomboid animation events
--- These events are handled by the base game and not our custom handlers
--- @type table<string, boolean>
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
    PushAwayZombie       = true,
    WindowCloseSuccess   = true,
    WindowAnimLooped     = true,
    ClimbWindowObstacle  = true,
    EmoteFinishing       = true
}

-- ===============
-- Key statements
-- ===============

--- Module namespace - ensures we don't overwrite existing module
--- @type table
ZomboDesire_AnimationHandler = ZomboDesire_AnimationHandler or {}

--- Tracks pending player cleanup operations with a delay
--- @type table|nil
ZomboDesire_AnimationHandler.playerCleanupPending = nil

--- Tracks the current zombHuman during animation (for multi-stage cleanup)
--- Keeps a reference to the zombHuman even when otherActions is empty
--- @type IsoGameCharacter|nil
ZomboDesire_AnimationHandler.currentZombHuman = nil

-- Declaration relating to Character
--- @class IsoGameCharacter
--- @field getClass function @Returns the Java class of the character

--- @class IsoPlayer : IsoGameCharacter
--- @class IsoZombie : IsoGameCharacter

-- Prior declaration of fields
---@diagnostic disable-next-line: duplicate-type
--- @class (partial) ISZomboDesireAnimationAction : ISBaseTimedAction
--- @field character IsoPlayer|IsoZombie
--- @field animation string
--- @field duration number
--- @field overrideAnim boolean
--- @field stopOnWalk boolean
--- @field stopOnRun boolean
--- @field maxTime number
--- @field otherActions table|nil
--- @field stageConfig table|nil
--- @field waitToStartCalled boolean|nil
--- @field waitingForZombHumanTask boolean|nil
--- @field zombHuman IsoZombie|nil
--- @field finalPosition {x: number, y: number, z: number}|nil
--- @field finalFacing IsoDirections|nil
--- @field miniGame table|nil
--- @field animEvent function
--- @field actionEvent function
--- @field new fun(self: ISZomboDesireAnimationAction, character: IsoPlayer|IsoZombie, animName: string, duration: number): ISZomboDesireAnimationAction
--- Create our custom timed action by extending the base timed action
--- This allows us to control animations with the game's action system
--- @type ISZomboDesireAnimationAction
ISZomboDesireAnimationAction = ISBaseTimedAction:derive("ISZomboDesireAnimationAction")

-- ==================
-- Utility functions
-- ==================

--- Utility function to ensure correct ID display in debug logs
--- @param zombie IsoGameCharacter -- The zombie entity whose ID will be displayed
--- @return string -- A formatted string displaying the zombie's ID
local function getZombieInfoString(zombie)
    if not zombie then return "nil zombie" end
    local id = zombie:getID() or "unknown"
    local persistentID = zombie:getPersistentOutfitID() or 0
    return string.format("ID -> %d (persistentID = %d)", id, persistentID)
end

--- Utility function to determine if a value is a dynamic Alt prefix and get its count
--- @param value string|table -- The perform value to check
--- @return string|nil, number|nil -- The prefix (if any) and the count of alternatives (if any)
local function getAltInfo(value)
    if type(value) == "string" and string.sub(value, -4) == "_Alt" then
        return value, ZomboDesire.AnimationAlts[value] or 1
    end
    if type(value) == "table" and #value == 1 and type(value[1]) == "string" and string.sub(value[1], -4) == "_Alt" then
        return value[1], ZomboDesire.AnimationAlts[value[1]] or 1
    end
    return nil, nil
end

--- Utility function to select a random element from a table or return the string if not a table
--- NOTE: This is kept for individual/solo animations. For multi-actor scenes, loadAnimationConfig
--- handles synchronized index selection to ensure all actors use the same Alt variant.
--- @param value string|table -- The perform value (string or table of alternatives)
--- @return string -- The selected animation name
local function selectRandomPerform(value)
    local prefix, count = getAltInfo(value)
    if prefix and count then
        return prefix .. tostring(ZombRand(count) + 1)
    end

    if type(value) == "table" then
        return value[ZombRand(#value) + 1]
    end

    if type(value) == "string" then
        return value
    end

    ZomboDesire.errorLog(MODULE_NAME, "Invalid perform value. Expected string or table, got %s", type(value))
    return ""
end

-- ===================================
-- Damage detection during animations
-- ===================================

--- Global reference to the currently active animation action
--- @type ISZomboDesireAnimationAction|nil
ZomboDesire_AnimationHandler.currentAnimationAction = nil

--- Damage detection watching this handler's currentAnimationAction, factored out to ZomboDesire_Utils
--- since ZomboDesire_AnimationHandlerForSolo needs the exact same interrupt logic (only the tracked action reference differs).
local registerDamageDetection, unregisterDamageDetection = ZomboDesire_Utils.createDamageDetection(
    MODULE_NAME,
    function() return ZomboDesire_AnimationHandler.currentAnimationAction end,
    function() ZomboDesire_AnimationHandler.currentAnimationAction = nil end
)

-- Damage detection events are registered per animation in start() and unregistered in stop()/perform()
-- Note: ZombHuman damage detection is handled separately in ZomboDesire_AnimationHandlerForZombHuman.lua

-- ========================================
-- Delayed player cleanup (ZombHumans AI sync)
-- ========================================

--- Handles delayed player cleanup to allow ZombHumans AI to reassign tasks
--- This runs every tick only when a cleanup is pending
local function onTickPlayerCleanup()
    local cleanup = ZomboDesire_AnimationHandler.playerCleanupPending
    if not cleanup then 
        Events.OnTick.Remove(onTickPlayerCleanup)
        return 
    end

    -- Decrement the tick counter
    cleanup.ticksRemaining = cleanup.ticksRemaining - 1

    -- Execute cleanup when timer reaches 0
    if cleanup.ticksRemaining <= 0 then
        ZomboDesire.debugLog(MODULE_NAME, "ATTENTION - Executing delayed player cleanup (restoreState + cleanupKnockbacks)")
        ZomboDesire_Cleanup.restoreState(cleanup.character)
        ZomboDesire_Utils.cleanupKnockbacks() -- Clean up knockback events
        ZomboDesire_AnimationHandler.playerCleanupPending = nil
        
        -- Stop the tick handler
        Events.OnTick.Remove(onTickPlayerCleanup)
    end
end

-- Function to schedule cleanup (called from stop/perform)
local function schedulePlayerCleanup(character)
    ZomboDesire_AnimationHandler.playerCleanupPending = {
        character = character,
        ticksRemaining = 2 -- Small delay (2 ticks) to ensure AI sync
    }
    Events.OnTick.Add(onTickPlayerCleanup)
end

-- =====================
-- Custom timed actions
-- =====================

--- Constructor for the animation action
--- Creates a new timed action for playing custom animations
--- @param character IsoGameCharacter -- The character (player or NPC) that will perform the animation
--- @param animName string -- The animation name as defined in the XML animation file
--- @param duration number -- The animation duration in milliseconds
--- @return ISZomboDesireAnimationAction -- A table instance configured as an ISZomboDesireAnimationAction object
---@public
---@diagnostic disable: inject-field
function ISZomboDesireAnimationAction:new(character, animName, duration)
    ---@diagnostic disable-next-line: param-type-mismatch
    local o = ISBaseTimedAction.new(self, character)
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Creating new animation action -> character = %s, animation = %s, duration = %d",
            getZombieInfoString(character), tostring(animName), duration)
    end

    -- Core properties
    ---@diagnostic disable: assign-type-mismatch, inject-field
    o.character = character			-- The character performing the animation
    o.animation = animName			-- The animation name (XML animNode key)
    o.duration = duration or 1000	-- Animation duration with fallback

    -- Animation control flags
    o.overrideAnim = true			-- Override any current animation
    o.stopOnWalk = false			-- Don't stop when walking
    o.stopOnRun = false				-- Don't stop when running
    o.maxTime = -1					-- Will be calculated in start() based on duration

    -- Synchronization with other characters
    o.otherActions = nil			-- Will store references to other characters' actions
    o.waitToStartCalled = false
    o.waitingForZombHumanTask = false
    o.zombHuman = nil
    o.finalPosition = nil
    o.finalFacing = nil
    o.miniGame = nil
    ---@diagnostic enable: assign-type-mismatch, inject-field

    return o
end

--- Checks if the animation action can still be performed
--- Verifies the character exists and is still alive
--- @return boolean -- True if the action can proceed, false otherwise
function ISZomboDesireAnimationAction:isValid()
    return self.character and not self.character:isDead()
end

--- Preparation before starting animation
--- This function is called by the action queue system before starting the action
--- Ensures synchronization between characters. Manual maintenance is preferred over 
--- the native B42 grapple to ensure reliable control restoration.
--- @return boolean -- Returns true if we need to wait for zombHuman task, false otherwise to allow the action to start
function ISZomboDesireAnimationAction:waitToStart()
    -- If this is the first time this function is called for this action
    if not self.waitToStartCalled then
        self.waitToStartCalled = true
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "waitToStart called for character = %s, has linked actions to otherActions ? -> %s",
                getZombieInfoString(self.character), tostring(self.otherActions ~= nil))
        end
    end

    -- Guard Clause: exit early if character is a zombie/zombHuman
    if self.character:isZombie() or self.character:getModData().isZombHuman then
        return false
    end

    -- Find the zombHuman among the other actions
    if not self.zombHuman and self.otherActions then
        for i = 1, #self.otherActions do
            local otherAction = self.otherActions[i]
            if otherAction.character:isZombie() or otherAction.character:getModData().isZombHuman then
                self.zombHuman = otherAction.character
                break
            end
        end
    end

    -- Handles waiting for zombHuman task to be ready
    local function waitForZombHumanTask()
        if not self.waitingForZombHumanTask then
            self.waitingForZombHumanTask = true
            if dbg() then
                local currentStageNum = self.stageConfig and (self.stageConfig.nextStageIndex - 1) or 1
                ---@cast self.zombHuman IsoZombie
                ZomboDesire.debugLog(MODULE_NAME, "Waiting for zombHuman %s to receive its task (Stage %d)...",
                    getZombieInfoString(self.zombHuman), currentStageNum)
            end
        end
        return true
    end

    -- Check if zombHuman is ready (replaces grapple initialization)
    if not self.zombHuman then
        return false
    end

    -- Check if the zombHuman has received its task
    local zombHumanTask = ZomboDesire_ZombHumanTask.GetTask(self.zombHuman)

    -- Always wait for the zombHuman task to be ready and matching our animation system
    -- This ensures player and zombHuman start each stage simultaneously
    if not zombHumanTask or zombHumanTask.action ~= "CustomAnim" then
        -- ZombHuman task not ready yet, wait
        return waitForZombHumanTask()
    end

    -- ZombHuman task is ready
    if self.waitingForZombHumanTask then
        ---@cast self.zombHuman IsoZombie
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "ZombHuman %s task is now ready, proceeding with animation start",
                getZombieInfoString(self.zombHuman))
        end
    end

    ZomboDesire.debugLog(MODULE_NAME, "Synchronization achieved between player and zombHuman")
    return false
end

--- Initializes and starts the animation
--- Sets up timing parameters and begins playing the animation on the character
--- Converts Blender animation frames to game engine time units
function ISZomboDesireAnimationAction:start()
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "DesireAction START -> self = %s, animation = %s", getZombieInfoString(self.character), self.animation)
    end

    local zombHumanTask = nil
    local zombHumanChar = nil

    -- Guard Clause: Exit early if this is not the player
    if self.character:isZombie() or self.character:getModData().isZombHuman then
        return
    end

    -- Save the player's final position (after walking)
    self.finalPosition = { 
        x = self.character:getX(), 
        y = self.character:getY(), 
        z = self.character:getZ() 
    }

    -- Save the player's final direction (after orientation)
    self.finalFacing = self.character:getDir()

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Saved player final position -> x = %.2f, y = %.2f, z = %.2f, dir = %s",
            self.finalPosition.x, self.finalPosition.y, self.finalPosition.z,
            tostring(self.finalFacing))
    end

    -- Find the zombHuman among the other actions (for stage 1)
    if self.otherActions then
        for i = 1, #self.otherActions do
            local otherAction = self.otherActions[i]
            if otherAction.character:isZombie() then
                zombHumanChar = otherAction.character
                ---@type IsoGameCharacter
                zombHumanChar = zombHumanChar

                -- Save the zombHuman's final position
                -- NOTE: z is taken from the PLAYER (self.character), not the zombie. The zombie's own
                -- getZ() can be stale (e.g. mid-stairs height from before it was teleported next to the
                -- player), which desyncs it from the tile it now stands on and can lead the engine to
                -- treat it as falling. The player and zombie are always meant to share the same height.
                ZomboDesire.zombHumanFinalPosition = {
                    x = zombHumanChar:getX(),
                    y = zombHumanChar:getY(),
                    z = self.character:getZ()
                }

                -- Save the zombHuman's final direction
                ZomboDesire.zombHumanFinalFacing = zombHumanChar:getDir()

                if dbg() then
                    ZomboDesire.debugLog(MODULE_NAME, "Saved zombHuman final position -> x = %.2f, y = %.2f, z = %.2f, dir = %s",
                        ZomboDesire.zombHumanFinalPosition.x,
                        ZomboDesire.zombHumanFinalPosition.y,
                        ZomboDesire.zombHumanFinalPosition.z,
                        tostring(ZomboDesire.zombHumanFinalFacing))
                end

                break
            end
        end
    -- For stages 2 and 3, get the zombHuman from stageConfig
    elseif self.stageConfig and self.stageConfig.zombHuman then
        zombHumanChar = self.stageConfig.zombHuman
        ---@type IsoGameCharacter
        zombHumanChar = zombHumanChar
        ZomboDesire.debugLog(MODULE_NAME, "Retrieved zombHuman from stageConfig for stage %d",
            self.stageConfig.nextStageIndex - 1)
    end

    -- Save current zombHuman globally for multi-stage cleanup reference
    if zombHumanChar then
        ZomboDesire_AnimationHandler.currentZombHuman = zombHumanChar
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Saved current zombHuman to global reference %s", getZombieInfoString(zombHumanChar))
        end
    end

    -- Retrieve the task from the zombHuman (for all stages)
    if zombHumanChar then
        zombHumanTask = ZomboDesire_ZombHumanTask.GetTask(zombHumanChar)
        if not zombHumanTask then
            ZomboDesire.warningLog(MODULE_NAME, "No task found for zombHuman %s", getZombieInfoString(zombHumanChar))
        else
            if dbg() then
                ZomboDesire.debugLog(MODULE_NAME, "Retrieved zombHuman task for %s", getZombieInfoString(zombHumanChar))
            end
        end
    end

    -- Calculate animation duration for the game engine
    -- This converts animation duration from Blender (frames@30fps) to PZ engine time
    local blenderFPS = 30 -- The animation created in Blender is at 30 fps

    -- Detect if this is a multi-stage animation
    local isMultiStage = self.stageConfig ~= nil
    local isLastStage = false
    local isFirstStage = false

    -- Check if this is the last stage of a multi-stage animation
    if isMultiStage then
        local actorConfig = self.stageConfig.actorConfig
        local nextStageIndex = self.stageConfig.nextStageIndex

        -- If there's no next stage, this is the last stage
        isLastStage = (actorConfig and actorConfig.stages) and (not actorConfig.stages[nextStageIndex]) or false

        -- First stage has nextStageIndex == 2 (because it will play stage 2 next)
        isFirstStage = nextStageIndex == 2
    end

    -- Enable inventory blocking at the start of the first stage of a multi-stage animation
    if isMultiStage and isFirstStage and not self.character:isZombie() and not self.character:getModData().isZombHuman then
        ZomboDesire.enableInventoryBlock()
        ZomboDesire.debugLog(MODULE_NAME, "Enabled inventory blocking for multi-stage animation (first stage)")
    end

    -- The 1.6 multiplier compensates for the time drift when m_SyncTrackingEnabled is true in XML
    -- Stage Begin and End (player and zombie) :
    -- m_Looped = false -> m_SyncTrackingEnabled is true
    local endAnimationTime
    if isMultiStage and not isLastStage then
        -- Detect looping stages to apply extra padding (3.2 instead of 1.6)
        -- The 3.2 multiplier compensates for the time drift when m_SyncTrackingEnabled is false in XML
        -- Looping stages (player and zombie):
        -- m_Looped = true -> m_SyncTrackingEnabled is false

        local actorConfig = self.stageConfig.actorConfig
        local totalStages = (actorConfig and actorConfig.stages) and #actorConfig.stages or 0
        local currentStageIndex = self.stageConfig.nextStageIndex - 1

        -- Determine if this is a looping stage (2 for 3-stage anim, 2-4 for 5-stage anim)
        local isLoopingStage = false
        if totalStages == 3 then
            isLoopingStage = (currentStageIndex == 2)
        elseif totalStages == 5 then
            isLoopingStage = (currentStageIndex >= 2 and currentStageIndex <= 4)
        end

        local stageMultiplier = 1.6
        if isLoopingStage then
            stageMultiplier = 3.2
            ZomboDesire.debugLog(MODULE_NAME, "Looping stage detected (Stage %d/%d) -> applying extra padding multiplier (3.2)",
                currentStageIndex, totalStages)
        end

        -- Multi-stage (intermediate stages): Use calculation without additional delay to prevent desynchronization between stages
        endAnimationTime = math.floor(self.duration * stageMultiplier)
        ZomboDesire.debugLog(MODULE_NAME, "Multi-stage animation detected (intermediate stage) -> using precise timing without delay")
    else
        -- Single-stage OR last stage of multi-stage: Add 20 (≈ 1/6 second) to ensure zombHuman finishes first
        -- Yes, I know... +20 only works for the short ZomboDesire animations, but there can still be freezes...
        -- For all the Framework and Lust animations, the <m_TimePc>0.900</m_TimePc> tag in the "End" XML files
        -- ensures the zombie returns to its idle state, without risking a freeze.
        -- In ZomboDesire_Cleanup.lua in removeZombHumanBrain, right after removing the
        -- ZombHumanBrain, we only clean up the global reference.
        -- The methods makeInactive and resetModelNextFrame are probably superfluous.
        endAnimationTime = math.floor((self.duration * 1.6) + 20) -- In short : Don't touch that !
        if isLastStage then
            ZomboDesire.debugLog(MODULE_NAME, "Multi-stage animation detected (LAST stage) -> adding delay to ensure zombHuman finishes first")
        else
            ZomboDesire.debugLog(MODULE_NAME, "Single-stage animation detected -> adding delay to ensure zombHuman finishes first")
        end
    end

    -- Set the action duration in the game engine
    self.maxTime = endAnimationTime
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Blender duration = %d frames, converted duration = %d PZ engine time (multi-stage %s)",
            self.duration, endAnimationTime, tostring(isMultiStage))
    end
    self.action:setTime(self.maxTime)
    ZomboDesire.debugLog(MODULE_NAME, "Applied maxTime = %d to action", self.maxTime)

    -- Calculate duration in seconds for logging purposes
    local durationInSeconds = self.duration / blenderFPS
    local animationName = self.animation
    ZomboDesire.debugLog(MODULE_NAME, "About to setActionAnim -> '%s' (length = %.2f seconds)", animationName, durationInSeconds)

    -- Start the animation for any character
    self:setActionAnim(animationName)
    ZomboDesire.debugLog(MODULE_NAME, "SetActionAnim has been set -> '%s' (length = %.2f seconds)", animationName, durationInSeconds)

    -- Flag character as being in a ZomboDesire scene
    local characterModData = self.character:getModData()
    if characterModData then
        characterModData.ZomboDesireScene = true
    end

    -- Directly trigger the zombHuman's animation and game logic (we know it's a player due to guard clause at start)
    ZomboDesire.playerAnimationStarted = true
    ZomboDesire.debugLog(MODULE_NAME, "Player animation started flag set to true")

    -- Register this animation action for damage detection
    ZomboDesire_AnimationHandler.currentAnimationAction = self
    ZomboDesire.debugLog(MODULE_NAME, "Registered animation action for damage detection")

    -- Register damage detection events for this animation
    registerDamageDetection()

    -- Launch Mini-game if it's the first stage of a multi-stage animation
    if isMultiStage and isFirstStage then
        ZomboDesire.debugLog(MODULE_NAME, "Launching Mini-game for Stage 1 Begin")
        local player = self.character
        ---@cast player IsoPlayer
        self.miniGame = ZomboDesire_MiniGame.Launch(player, self)
    end

    -- Fires only when the setup above actually ran (i.e. not for the zombie/zombHuman guard clause early-return above),
    -- once self.maxTime/finalPosition/etc. are fully populated.
    triggerEvent("OnZomboDesireAnimationActionStart", self)
end

--- Updates the character position and orientation during animation
--- Called every frame to ensure the character maintains its initial position and facing
--- Prevents unwanted movement or rotation during the animation sequence
function ISZomboDesireAnimationAction:update()
    -- Force manual position and orientation to bypass B42 grapple input locking
    if self.finalPosition then
        self.character:setX(self.finalPosition.x)
        self.character:setY(self.finalPosition.y)
        self.character:setZ(self.finalPosition.z)
    end
    if self.finalFacing then
        ---@cast self.finalFacing any
        self.character:setDir(self.finalFacing)
    end
end

--- Override animEvent: called by the engine when an <m_Events> marker is hit in the XML animation file
--- Dispatch only custom events; let vanilla handle core events
--- @param m_EventName string -- Name of the event
--- @param m_ParameterValue string -- The parameter value from the XML
function ISZomboDesireAnimationAction:animEvent(m_EventName, m_ParameterValue)
    -- ZomboDesire.debugLog(MODULE_NAME, "DesireAction ANIM EVENT -> m_EventName = %s m_ParameterValue = %s", tostring(m_EventName), tostring(m_ParameterValue))

    -- If this is not a base vanilla Event, treat it as custom and load OUR module for this Event marker
    if not basicEvents[m_EventName] then
        -- ZomboDesire.debugLog(MODULE_NAME, "Looking for custom handler for '%s'", m_EventName)
        local markerHandler = ZomboDesire.EventMarkerModules[m_EventName]
        if type(markerHandler) == "function" then
            -- ZomboDesire.debugLog(MODULE_NAME, "Found handler for '%s', invoking", m_EventName)
            -- Invoke the event markerHandler: signature (actionInstance, m_EventName, m_ParameterValue)
            local markerHandlerSuccess, markerHandlerError = pcall(markerHandler, self, m_EventName, m_ParameterValue)
            if markerHandlerSuccess then
                -- ZomboDesire.debugLog(MODULE_NAME, "'%s' executed without error", m_EventName)
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
function ISZomboDesireAnimationAction:actionEvent(event)
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

--- Called when the animation action completes successfully
--- Performs cleanup operations and restores character state
--- Calls the base class perform method and triggers additional cleanup routines
function ISZomboDesireAnimationAction:perform()
    -- Fires unconditionally, before any perform logic runs below
    -- (including the interrupted/guard clause checks further down) - subscribers filter by self.character themselves if needed.
    triggerEvent("OnZomboDesireAnimationActionPerform", self)

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "DesireAction PERFORM -> cleaning up for char = %s", getZombieInfoString(self.character))
    end

    -- Remove the scene flag from character's mod data
    local characterModData = self.character:getModData()
    if characterModData then 
        characterModData.ZomboDesireScene = nil
    end

    -- Call parent class perform method
    ISBaseTimedAction.perform(self)

    -- Check if animation was interrupted (e.g., by damage detection)
    -- If currentAnimationAction is not this action, it means it was interrupted
    if ZomboDesire_AnimationHandler.currentAnimationAction ~= self then
        ZomboDesire.debugLog(MODULE_NAME, "Animation was interrupted, skipping multi-stage continuation")
        return
    end

    -- Guard Clause: Exit early if this is not a player or not part of a multi-stage animation
    if self.character:isZombie() or self.character:getModData().isZombHuman or 
       not self.stageConfig or not self.stageConfig.nextStageIndex then
        return
    end

    local nextStageIndex = self.stageConfig.nextStageIndex
    local actorConfig = self.stageConfig.actorConfig
    local animName = self.stageConfig.animName
    local zombHuman = self.stageConfig.zombHuman

    -- Check if there's a next stage to play
    if actorConfig and actorConfig.stages and actorConfig.stages[nextStageIndex] then
        -- Trigger transition event for external mods (like ZomboLust) to handle FX or character state
        triggerEvent("OnZomboDesireStageTransition", self.character, zombHuman, nextStageIndex)

        local nextStage = actorConfig.stages[nextStageIndex]
        local nextAnimName = nextStage.perform
        local nextDuration = nextStage.duration

        ZomboDesire.debugLog(MODULE_NAME, "Playing next stage animation for player -> %s with duration %d",
            nextAnimName, nextDuration)

        -- Create a new action for the next stage
        ---@cast self.character IsoPlayer
        ---@diagnostic disable-next-line: redundant-parameter
        local nextAction = ISZomboDesireAnimationAction:new(self.character, nextAnimName, nextDuration)

        -- Pass stage configuration to the next action
        nextAction.stageConfig = {
            actorConfig = actorConfig,
            animName = animName,
            nextStageIndex = nextStageIndex + 1,
            zombHuman = zombHuman
        }

        -- Queue the player action for the next stage
        ZomboDesire.debugLog(MODULE_NAME, "Adding next stage %d to queue for player", nextStageIndex)
        ---@diagnostic disable-next-line: param-type-mismatch
        ISTimedActionQueue.add(nextAction)
        ZomboDesire.debugLog(MODULE_NAME, "Queued next stage %d for player", nextStageIndex)
        return
    end

    -- Multi-stage animation sequence completed
    ZomboDesire.debugLog(MODULE_NAME, "Multi-stage animation sequence completed")

    -- Disable inventory blocking when multi-stage animation ends normally
    ZomboDesire.disableInventoryBlock()
    ZomboDesire.debugLog(MODULE_NAME, "Disabled inventory blocking - multi-stage animation sequence completed")

    -- Cleanup zombHuman reference when multi-stage animation ends normally
    -- Note: ZombHuman cleanup is handled by ZomboDesire_AnimationHandlerForZombHuman.lua
    if ZomboDesire_AnimationHandler.currentZombHuman then
        ZomboDesire_AnimationHandler.currentZombHuman = nil
    end

    -- Run additional cleanup operations
    ZomboDesire.debugLog(MODULE_NAME, "Cleaning call from Player")
    ZomboDesire_Cleanup.restoreState(self.character)
    ZomboDesire_Utils.cleanupKnockbacks() -- Clean up knockback events

    -- Clear damage detection reference when animation ends normally
    if ZomboDesire_AnimationHandler.currentAnimationAction == self then
        ZomboDesire_AnimationHandler.currentAnimationAction = nil
        ZomboDesire.debugLog(MODULE_NAME, "Cleared damage detection reference on normal animation end")

        -- Unregister damage detection events after normal animation end
        unregisterDamageDetection()
    end
end

--- Handles interruption of the animation action
--- Stops all linked actions and performs cleanup operations
--- Prevents recursion by safely stopping other actions first
function ISZomboDesireAnimationAction:stop()
    -- Fires unconditionally, before any stop/cleanup logic runs below - subscribers filter by self.character themselves if needed.
    triggerEvent("OnZomboDesireAnimationActionStop", self)

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "DEBUG: stop() called for character %s. currentAnimationAction matches? %s",
            getZombieInfoString(self.character), tostring(ZomboDesire_AnimationHandler.currentAnimationAction == self))

        ZomboDesire.debugLog(MODULE_NAME, "ATTENTION - DesireAction STOP -> propagating to otherActions. otherActions = %d", #(self.otherActions or {}))
    end

    -- Stop ZomboLust video playback immediately on interruption (Echap, damage, etc.)
    if ZomboDesire_Cleanup and ZomboDesire_Cleanup.stopZomboLustVideo then
        ZomboDesire_Cleanup.stopZomboLustVideo()
    end

    -- Interrupt the mini-game if it's still running
    -- We do this before clearing otherActions to ensure result handling 
    -- can still access the zombHuman via self.otherActions or currentZombHuman
    local miniGame = self.miniGame
    self.miniGame = nil
    if miniGame and not miniGame.isClosed then
        ZomboDesire.debugLog(MODULE_NAME, "ATTENTION - Animation stopped, forcing mini-game to finish as interrupted")
        miniGame:finish("interrupted")
    end

    -- First we remove the list to break the recursion
    local actionsToStop = self.otherActions
    self.otherActions = nil

    -- Cleanup on interruption (only force-stop true TimedActions)
    if actionsToStop then
        for i = 1, #actionsToStop do
            local otherAction = actionsToStop[i]
            -- Safety: simple log to avoid formatting/tostring errors
            if dbg() then
                ZomboDesire.debugLog(MODULE_NAME, " stopping otherAction index " .. tostring(i))
            end

            -- Only table-values can have methods
            if type(otherAction) == "table" and otherAction ~= self and type(otherAction.stop) == "function" then
                -- Secure the call to avoid 'bugged action' clearing the whole queue
                local status, err = pcall(otherAction.stop, otherAction)
                if not status and dbg() then
                    ZomboDesire.debugLog(MODULE_NAME, " ERROR during otherAction:stop() propagation: " .. tostring(err))
                end
            end
        end
    end

    -- Clear our scene flag
    local characterModData = self.character:getModData()
    if characterModData then 
        characterModData.ZomboDesireScene = nil
    end

    -- To avoid nil call problems, only call base stop if self.action is set
    if self.action then
        ISBaseTimedAction.stop(self)
    end

    -- Clear damage detection reference when animation is interrupted
    if ZomboDesire_AnimationHandler.currentAnimationAction == self then
        ZomboDesire_AnimationHandler.currentAnimationAction = nil
        ZomboDesire.debugLog(MODULE_NAME, "ATTENTION - Cleared damage detection reference on animation interruption")

        -- Unregister damage detection events after animation interruption
        unregisterDamageDetection()
    end

    -- Disable inventory blocking on animation interruption
    if not self.character:isZombie() and not self.character:getModData().isZombHuman then
        ZomboDesire.disableInventoryBlock()
        ZomboDesire.debugLog(MODULE_NAME, "ATTENTION - Disabled inventory blocking on animation interruption")
    end

    -- Perform zombHuman cleanup
    -- Find the zombHuman among other actions or use the global current zombHuman reference (for multi-stage cleanup)
    local zombHumanToClean = nil

    if actionsToStop then
        for i = 1, #actionsToStop do
            local otherAction = actionsToStop[i]
            if otherAction.character:isZombie() or otherAction.character:getModData().isZombHuman then
                zombHumanToClean = otherAction.character
                break
            end
        end
    end

    -- If no zombHuman found in otherActions, use the global current zombHuman (multi-stage cleanup)
    if not zombHumanToClean and ZomboDesire_AnimationHandler.currentZombHuman then
        zombHumanToClean = ZomboDesire_AnimationHandler.currentZombHuman
        ---@cast zombHumanToClean IsoZombie
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "ATTENTION - Using currentZombHuman fallback for multi-stage cleanup %s",
                getZombieInfoString(zombHumanToClean))
        end
    end

    -- Execute zombHuman cleanup if we found the zombHuman
    if zombHumanToClean then
        ---@cast zombHumanToClean IsoZombie
        -- Call the zombHuman cleanup function
        ZomboDesire.debugLog(MODULE_NAME, "ATTENTION - About to call performZombHumanAnimationCleanup() on animation interruption")
        ZomboDesire_ZombHumanAnimation.performZombHumanAnimationCleanup(zombHumanToClean)

        -- Schedule player cleanup for 5 ticks later to allow ZombHumans AI to reassign task
        ZomboDesire.debugLog(MODULE_NAME, "ATTENTION - Scheduling delayed player cleanup (5 ticks) to allow ZombHumans AI recovery")
        schedulePlayerCleanup(self.character)
        ZomboDesire_AnimationHandler.playerCleanupPending.ticksRemaining = 5

        -- Clear the current zombHuman reference when animation is stopped
        ZomboDesire_AnimationHandler.currentZombHuman = nil
    end
end

--- Forces the animation action to stop immediately
--- This is called when the action needs to be forcefully terminated (e.g., due to damage)
--- Calls the parent forceStop method which will trigger stop() for cleanup
function ISZomboDesireAnimationAction:forceStop()
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "DEBUG: forceStop() INITIATED for character %s", getZombieInfoString(self.character))
        ZomboDesire.debugLog(MODULE_NAME, "ATTENTION - DesireAction FORCE STOP -> character = %s (will trigger stop() for cleanup)", getZombieInfoString(self.character))
    end

    -- Call parent forceStop which will call self.action:forceStop() on Java side
    -- The Java side will then trigger our stop() method for cleanup
    ISBaseTimedAction.forceStop(self)
end

-- ===============================
-- Animation management functions
-- ===============================

--- Loads and validates animation configuration for a given animation name
--- @param animName string -- Key for the animation config
--- @return table|nil -- The animation configuration or nil if invalid
local function loadAnimationConfig(animName)
    ZomboDesire.debugLog(MODULE_NAME, "Loading animation configuration for '%s'", animName)
    ---@type table|nil
    local config = ZomboDesire.AnimationConfigs[animName]

    if not config then
        ZomboDesire.errorLog(MODULE_NAME, "No valid animations found or no config for animName -> %s", tostring(animName))
        return nil
    end

    ---@cast config table

    -- Create a deep copy of the config to avoid modifying the global one
    local configCopy = {}
    for k, v in pairs(config) do
        configCopy[k] = v
    end

    -- Store shared choices for each stage to ensure all actors use the same Alt index
    local stageChoices = {}
    local firstActor = config.actors[1]
    if firstActor and firstActor.stages then
        for j = 1, #firstActor.stages do
            local stage = firstActor.stages[j]
            local prefix, altCount = getAltInfo(stage.perform)
            if not prefix and type(stage.perform) == "table" then
                altCount = #stage.perform
            end

            stageChoices[j] = ZombRand(altCount or 1) + 1
        end
    end

    -- Apply Stage 2 multiplier if configured in mod options
    ---@type number
    local multiplier = 1
    local modOptions = PZAPI.ModOptions:getOptions("ZomboDesire")
    if modOptions then
        local option = modOptions:getOption("stage2Multiplier")
        if option then
            ---@cast option any
            local index = tonumber(option:getValue()) or 1
            local step = getActivatedMods():contains("ZomboLust") and 5 or 1
            multiplier = index * step
        end
    end

    configCopy.actors = {}
    for i = 1, #config.actors do
        local actor = config.actors[i]
        configCopy.actors[i] = { character = actor.character, stages = {} }
        for j = 1, #actor.stages do
            local stage = actor.stages[j]
            local chosenIndex = stageChoices[j] or 1
            local performValue = stage.perform
            local selectedPerform = ""

            local prefix, count = getAltInfo(performValue)
            if prefix and count then
                local index = math.min(chosenIndex, count)
                selectedPerform = prefix .. tostring(index)
            elseif type(performValue) == "table" then
                local index = math.min(chosenIndex, #performValue)
                selectedPerform = performValue[index]
            else
                selectedPerform = performValue
            end

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
                if dbg() then
                    ZomboDesire.debugLog(MODULE_NAME, "Applied multiplier x%d to Stage %d/%d duration for %s (%d -> %d)",
                        multiplier, j, totalStages, tostring(actor.character), stage.duration, stageDuration)
                end
            end

            configCopy.actors[i].stages[j] = {
                perform = selectedPerform,
                duration = stageDuration
            }
        end
    end

    ZomboDesire.debugLog(MODULE_NAME, "Found valid configuration for animation -> %s (with synchronized random selection applied)", animName)
    return configCopy
end

--- Determines the appropriate actor configuration based on character type (Player or ZombHuman0)
--- @param config table -- The animation configuration
--- @return table|nil -- The actor configuration or nil if invalid
local function determineActorConfig(config)
    -- Select actor configs by character type (Player)
    ZomboDesire.debugLog(MODULE_NAME, "Looking for Player character configuration")

    -- Find matching character configuration for Player
    local actorConfig = nil
    local actors = config.actors or {}
    for i = 1, #actors do
        local actor = actors[i]
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Checking config.actors[%d].character = %s", i, tostring(actor.character))
        end
        if actor.character == "Player" then
            actorConfig = actor
            ZomboDesire.debugLog(MODULE_NAME, "Matched actorConfig at index %d for character Player", i)
            break
        end
    end

    -- Fallback to the first config if nothing matches
    actorConfig = actorConfig or (config.actors and config.actors[1])

    if not actorConfig or not actorConfig.stages then
        ZomboDesire.errorLog(MODULE_NAME, "Invalid actorConfig for animation")
        return nil
    end

    return actorConfig
end

--- Creates animation actions for both player and zombHuman
--- @param player IsoPlayer -- The player character
--- @param zombHuman IsoGameCharacter -- The zombHuman character
--- @param config table -- The synchronized animation configuration
--- @param actorConfig table -- The actor configuration for Player
--- @param animName string -- The animation name (for fallback)
--- @return table -- Array of created animation actions
local function createAnimationActions(player, zombHuman, config, actorConfig, animName)
    -- Queue only the first stage; subsequent stages triggered via XML ActionEvents
    local firstStage = actorConfig.stages[1]
    local duration = firstStage.duration or actorConfig.defaultDuration or 1000
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "firstStage.perform = %s duration = %d", tostring(firstStage and firstStage.perform), duration)
    end

    -- Create action for a single character
    local function createActionForCharacter(character)
        if not character then
            ZomboDesire.errorLog(MODULE_NAME, "Character is nil when creating action")
            return nil
        end

        local characterAnim = nil
        local characterActorConfig = nil
        local isZombHuman = character:isZombie() or character:getModData().isZombHuman

        -- Attempt to find ZombHuman0 configuration if character is a zombHuman
        if isZombHuman and config and config.actors then
            -- Find matching character configuration for ZombHuman0
            for i = 1, #config.actors do
                local actor = config.actors[i]
                if actor.character == "ZombHuman0" and actor.stages and actor.stages[1] then
                    characterAnim = actor.stages[1].perform
                    characterActorConfig = actor
                    ZomboDesire.debugLog(MODULE_NAME, "Selected zombHuman animation for character ZombHuman0 -> %s", characterAnim)
                    break
                end
            end
        end

        -- Fallback to default actorConfig if no specific animation found (Player or ZombHuman fallback)
        if not characterAnim then
            characterAnim = firstStage.perform
            characterActorConfig = actorConfig
            if isZombHuman then
                ZomboDesire.warningLog(MODULE_NAME, "Using fallback animation for zombHuman %s", characterAnim)
            end
        end

        ---@type string
        characterAnim = characterAnim

        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Creating action for character = %s class = %s perform = %s",
                getZombieInfoString(character),
                tostring(character:getClass() or "nil"),
                tostring(characterAnim or "nil"))
        end

        -- Create the animation action with the appropriate animation
        ---@diagnostic disable-next-line: redundant-parameter
        local animAction = ISZomboDesireAnimationAction:new(character, characterAnim, duration)

        -- Add stage configuration if this is a multi-stage animation (only for player)
        if not character:isZombie() and not character:getModData().isZombHuman and 
           characterActorConfig and characterActorConfig.stages and #characterActorConfig.stages > 1 then
            animAction.stageConfig = {
                actorConfig = characterActorConfig,
                animName = animName,
                nextStageIndex = 2,  -- Index of the next stage to play
                zombHuman = zombHuman      -- Reference to the zombHuman character
            }
            ZomboDesire.debugLog(MODULE_NAME, "Setting up multi-stage animation with %d total stages for player",
                #characterActorConfig.stages)
        end

        return animAction
    end

    -- Create timed actions for both player and zombHuman
    local actions = {}
    local chars = {player, zombHuman}
    for i = 1, #chars do
        local character = chars[i]
        local animAction = createActionForCharacter(character)
        if animAction then
            table.insert(actions, animAction)
        end
    end

    -- Link actions together for synchronization
    for i = 1, #actions do
        local action = actions[i]
        action.otherActions = actions
    end

    ZomboDesire.debugLog(MODULE_NAME, "Created %d animation actions", #actions)
    return actions
end

--- Queues animation actions for execution
--- @param actions table -- Array of animation actions
--- @param player IsoPlayer -- The player character
--- @param animName string -- The animation name (for fallback)
--- @param zombHuman IsoGameCharacter -- The zombHuman character
--- @param config table|nil -- Optional: The synchronized animation configuration
local function queueAnimationActions(actions, player, animName, zombHuman, config)
    -- Position zombHuman at exact player coordinates just before animation starts
    -- This minimizes visual clipping by reducing time between positioning and animation startup
    --- This allows the animation FBX to manage proper positioning and orientation
    if zombHuman and player then
        local targetX = player:getX()
        local targetY = player:getY()
        zombHuman:setX(targetX)
        zombHuman:setY(targetY)
        -- Sync height too: X/Y alone can leave the zombie at a stale Z (e.g. mid-stairs), desyncing
        -- it from the tile it now stands on and risking the engine treating it as falling.
        zombHuman:setZ(player:getZ())
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "ZombHuman positioned at exact player coordinates (%.2f, %.2f, %.2f) just before animation queue",
                targetX, targetY, player:getZ())
        end
    end

    for i = 1, #actions do
        local animAction = actions[i]
        local character = animAction.character

        if character:isZombie() then
            -- ZombHuman case: use bumpType + task system instead of ISTimedActionQueue
            if dbg() then
                ZomboDesire.debugLog(MODULE_NAME, "Clearing queue & using task system for zombHuman %s", getZombieInfoString(character))
            end
            -- Clear any pending player-like actions
            ISTimedActionQueue.clear(character)
            -- Invoke bump + task - Pass the synchronized config to ensure identical Alt selection
            ZomboDesire_ZombHumanAnimation.play(character, player, animAction.anim or animName, config --[[@as table]])
        elseif not character:isZombie() then
            -- Player case: clear and enqueue
            if dbg() then
                ZomboDesire.debugLog(MODULE_NAME, "Clearing queue for player %s", getZombieInfoString(character))
            end
            ISTimedActionQueue.clear(character)
            ZomboDesire.debugLog(MODULE_NAME, "Add animation action to queue")
            ISTimedActionQueue.add(animAction)
        else
            ZomboDesire.errorLog(MODULE_NAME, "Unknown character -> Skipping character %s", getZombieInfoString(character))
        end
    end
end

--- Main function to play an animation between player and zombHuman
--- Coordinates the entire animation sequence from configuration loading to execution
--- @param player IsoPlayer -- The player character
--- @param zombHuman IsoGameCharacter -- The zombHuman character
--- @param animName string -- Key for the animation config
function ZomboDesire_AnimationHandler.playAnimation(player, zombHuman, animName)
    -- Check if the actors are valid
    if not player or not zombHuman then
        ZomboDesire.errorLog(MODULE_NAME, "Invalid actors for animation")
        return
    end

    ZomboDesire.debugLog(MODULE_NAME, "Starting animation sequence")
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Handler playAnimation -> animName = %s for player = %s and zombHuman = %s",
            animName, getZombieInfoString(player), getZombieInfoString(zombHuman))
    end

    -- Step 1: Load and validate animation configuration
    local config = loadAnimationConfig(animName)
    if not config then return end

    -- Step 2: Determine actor configuration for Player character
    local actorConfig = determineActorConfig(config)
    if not actorConfig then return end

    -- Check if this is a multi-stage animation
    local isMultiStage = actorConfig.stages and #actorConfig.stages > 1
    if isMultiStage then
        ZomboDesire.debugLog(MODULE_NAME, "Detected multi-stage animation with %d stages", #actorConfig.stages)
    end

    -- Step 3: Create animation actions for both characters
    local actions = createAnimationActions(player, zombHuman, config, actorConfig, animName)

    -- Step 4: Queue the actions for execution
    queueAnimationActions(actions, player, animName, zombHuman, config)
end

return ZomboDesire_AnimationHandler
