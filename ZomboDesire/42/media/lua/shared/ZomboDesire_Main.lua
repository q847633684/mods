--- File: ZomboDesire/42/media/lua/shared/ZomboDesire_Main.lua
--- Main core for ZomboDesire framework
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_Main.lua loaded")

-- =========================
-- Namespace Initialization
-- =========================

--- Main namespace
--- @type table
ZomboDesire = ZomboDesire or {}

--- Sub-namespaces
--- @class (partial) ZomboDesire_Utils
ZomboDesire_Utils = ZomboDesire_Utils or {}
--- @class (partial) ZomboDesire_Cleanup
ZomboDesire_Cleanup = ZomboDesire_Cleanup or {}
ZomboDesire.AnimationConfigs = ZomboDesire.AnimationConfigs or {}
--- @class (partial) ZomboDesire_AnimationHandler
--- @field registerZombHumanDamageDetection fun(zombHuman: IsoZombie)
ZomboDesire_AnimationHandler = ZomboDesire_AnimationHandler or {}
--- @class (partial) ZomboDesire_Staging
ZomboDesire_Staging = ZomboDesire_Staging or {}

-- ====================
-- Debug Configuration
-- ====================

--- Global debug configuration
--- @type { enabled: boolean, modules: table<string, boolean> }
ZomboDesire.Debug = {
    -- Master switch for all debugging
    enabled = false,

    -- Module-specific debug settings
    modules = {
        -- Core modules
        ["Main"] = true,
        ["Utils"] = true,
        ["Cleanup"] = true,
        ["AnimationHandler"] = true,
        ["AnimationHandlerForZombHuman"] = true,
        ["AnimationHandlerForSolo"] = true,
        ["Intercept"] = true,
        ["InventoryHooks"] = true,

        -- Detection modules
        ["Detection"] = true,
        ["ObjectDetection"] = true,

        -- Object modules
        ["ObjectTags"] = true,
        ["ObjectTypes"] = true,

        -- ZombHuman Logic modules
        ["ZombHumanUtils"] = true,
        ["ZombHumanBrain"] = true,
        ["ZombHumanTask"] = true,
        ["ZombHumanSound"] = true,
        ["ZombHumanUpdate"] = true,
        ["ZombHumanActions"] = true,

        -- Transform modules
        ["TransformZombHuman"] = true,

        -- Spawn modules
        ["SpawnFakeZombHuman"] = true,

        -- Staging modules
        ["Staging"] = true,

        -- MiniGame module
        ["MiniGame"] = true,

        -- Animation events
        ["EventsHandler"] = true,
        ["EscapeHandler"] = true,

        -- Debug modules
        ["DebugSpawnFakeZombHuman"] = true,
        ["DebugPlaySoloAnimations"] = true,
        ["DebugControls"] = true,

        -- Init module
        ["Init"] = true
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
function ZomboDesire.isDebug(module)
    return ZomboDesire.Debug.enabled and ZomboDesire.Debug.modules[module] == true
end

--- Displays a formatted debug message if debugging is enabled for the module
--- Self-guarded: safe to call directly when arguments are already cheap (local variables, literals).
--- For arguments that are costly to build, wrap the call site in "if ZomboDesire.isDebug(MODULE_NAME) then ... end"
--- (see each module's local "dbg()" helper) instead of relying on this guard.
--- @param module string -- The module name
--- @param message string -- The message to display
--- @param ... any -- Arguments to be formatted in the message
function ZomboDesire.debugLog(module, message, ...)
    if not ZomboDesire.isDebug(module) then return end
    print(string.format("[ZomboDesire %s] %s", module, string.format(message, ...)))
end

--- Displays an error message
--- @param module string -- The module name
--- @param message string -- The error message to display
--- @param ... any -- Arguments to be formatted in the message
function ZomboDesire.errorLog(module, message, ...)
    print(string.format("[ZomboDesire %s] ERROR %s", module, string.format(message, ...)))
end

--- Displays a warning message
--- @param module string -- The module name
--- @param message string -- The warning message to display
--- @param ... any -- Arguments to be formatted in the message
function ZomboDesire.warningLog(module, message, ...)
    print(string.format("[ZomboDesire %s] WARNING %s", module, string.format(message, ...)))
end

-- =======================
-- Game Object References
-- =======================

-- Original zombie references (set in ZomboDesire_TransformZombHuman.lua)
---@type IsoZombie|nil
ZomboDesire.originalZombie = nil

-- Table to track zombies set to "useless" by the mod to ensure they are restored correctly
-- Using a table with zombies as keys for efficient lookups and restoration
---@type table<IsoZombie, boolean>
ZomboDesire.neutralizedZombies = {}

-- Collision listener reference (set in ZomboDesire_Intercept.lua)
ZomboDesire.collisionListener = nil

-- Flag to track if collision listener is currently registered (prevents duplicate registrations)
-- Used in ZomboDesire_Intercept.lua (when removing listener) and ZomboDesire_EscapeHandler.lua (when re-enabling)
ZomboDesire.isCollisionListenerRegistered = true

-- ====================
-- Mod Detection Flags
-- ====================

-- ZomboLust mod detection flags (set in ZomboDesire_Intercept.lua)
ZomboDesire.IsZomboLustActive              = false
ZomboDesire.IsZomboLustLesbianActive       = false
ZomboDesire.IsZomboLustGayActive           = false
ZomboDesire.IsZomboLustBestialityActive    = false
ZomboDesire.IsZomboLustDreamsActive        = false
ZomboDesire.IsZomboLustEndGameActive       = false
ZomboDesire.IsZomboLustFurryActive         = false
ZomboDesire.IsZomboLustMasturbationActive  = false
ZomboDesire.IsZomboLustOccultActive        = false
ZomboDesire.IsZomboLustBeingFemaleActive   = false
ZomboDesire.IsZomboLustReactiveSoundActive = false

-- ======================
-- Animation State Flags
-- ======================

-- Flag for ZombHuman transformation completion (set in ZomboDesire_TransformZombHuman.lua)
ZomboDesire.ZombHumanizeCompleted = false

--- Position relative between player and zombie/ZombHuman (set in ZomboDesire_Intercept.lua)
--- @type "FaceToFace"|"FaceToBack"|nil
ZomboDesire.relativePosition = nil

--- Zombie gender tag for animation selection (set in ZomboDesire_Intercept.lua)
--- @type "ZF0"|"ZM0"|nil
ZomboDesire.zombieGenderTag = nil

--- Object interaction tag for animation selection (set in ZomboDesire_Intercept.lua)
--- @type "Leaning over"|"Standing against"|"Sitting on"|"Lying on"|"On stairs"|nil
ZomboDesire.objectInteractionTag = nil

-- Initialize flags for animation synchronization
-- Indicates that the player animation has started
-- (set for ZomboDesire_AnimationHandler.lua and for ZomboDesire_AnimationHandlerForZombHuman.lua)
ZomboDesire.playerAnimationStarted = false

-- Initialization variables for ZombHuman animation states (set in ZomboDesire_AnimationHandlerForZombHuman.lua)
ZomboDesire.zombHumanFinalPosition = nil
ZomboDesire.zombHumanFinalFacing = nil

--- Stores starting positions of player and zombie when animation sequence begins (set in ZomboDesire_Intercept.lua)
--- Used to validate that protagonists haven't moved during setup (climbing windows, push back defense, etc.)
--- @type {playerX: number|nil, playerY: number|nil, zombieX: number|nil, zombieY: number|nil}
ZomboDesire.animationStartPositions = {
    playerX = nil,
    playerY = nil,
    zombieX = nil,
    zombieY = nil
}

-- ============================
-- Event System Initialization
-- ============================

-- Event handler modules (set for ZomboDesire_EventsHandler.lua)
ZomboDesire.EventMarkerModules = {}
ZomboDesire.ActionEventModules = {}

-- =====================
-- Class Initialization
-- =====================

-- ZombHuman actions for character-specific animations (set for ZomboDesire_AnimationHandlerForZombHuman.lua)
ZomboDesire_ZombHumanActions = ZomboDesire_ZombHumanActions or {}
ZomboDesire_ZombHumanActions.CustomAnim = ZomboDesire_ZombHumanActions.CustomAnim or {}

-- ISZomboDesireAnimationAction will be derived in ZomboDesire_AnimationHandler.lua

-- ===============
-- Module Exports
-- ===============

return ZomboDesire
