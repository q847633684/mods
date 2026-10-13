--- File: ZomboLust Lewd Models/42/media/lua/shared/ZomboLustLewdModels_Main.lua
--- Main core for ZomboLust Lewd Models
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust Lewd Models LOADING] ZomboLustLewdModels_Main.lua loaded")

-- =========================
-- Namespace Initialization
-- =========================

--- Main namespace
--- @type table
ZLLewdModels = ZLLewdModels or {}

-- ====================
-- Debug Configuration
-- ====================

--- Global debug configuration
--- @type { enabled: boolean, modules: table<string, boolean> }
ZLLewdModels.Debug = {
    -- Master switch for all debugging
    enabled = false,

    -- Module-specific debug settings
    modules = {
        -- Mirror
        ["Main"] = true,
        ["Mirror"] = true,
        ["MirrorWorldMenu"] = true,

        -- Body
        ["CharacterInit"] = true,
        ["CharacterScreen"] = true,
        ["ShaveAction"] = true,
        ["HairGrowth"] = true,
        ["ManageBody"] = true,
        ["RazorMod"] = true,
        ["ClothingChecks"] = true,

        -- Creation
        ["CharacterCreation"] = true,
        ["SPNCC_Data"] = true,
        ["CC_UpdateCharacterPreview"] = true,
        ["FaceManager_Shared"] = true,
        ["CharacterCustomisationPanel"] = true,
        ["BodyDetailMenuPanel"] = true,
        ["CC_Randomise"] = true
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
function ZLLewdModels.isDebug(module)
    return ZLLewdModels.Debug.enabled and ZLLewdModels.Debug.modules[module] == true
end

--- Displays a formatted debug message if debugging is enabled for the module
--- Self-guarded: safe to call directly when arguments are already cheap (local variables, literals).
--- For arguments that are costly to build, wrap the call site in "if ZLLewdModels.isDebug(MODULE_NAME) then ... end"
--- (see each module's local "dbg()" helper) instead of relying on this guard.
--- @param module string -- The module name
--- @param message string -- The message to display
--- @param ... any -- Arguments to be formatted in the message
function ZLLewdModels.debugLog(module, message, ...)
    if not ZLLewdModels.isDebug(module) then return end
    print(string.format("[ZLLewdModels %s] %s", module, string.format(message, ...)))
end

--- Displays an error message
--- @param module string -- The module name
--- @param message string -- The error message to display
--- @param ... any -- Arguments to be formatted in the message
function ZLLewdModels.errorLog(module, message, ...)
    print(string.format("[ZLLewdModels %s] ERROR %s", module, string.format(message, ...)))
end

--- Displays a warning message
--- @param module string -- The module name
--- @param message string -- The warning message to display
--- @param ... any -- Arguments to be formatted in the message
function ZLLewdModels.warningLog(module, message, ...)
    print(string.format("[ZLLewdModels %s] WARNING %s", module, string.format(message, ...)))
end

-- ===============
-- Module Exports
-- ===============

return ZLLewdModels
