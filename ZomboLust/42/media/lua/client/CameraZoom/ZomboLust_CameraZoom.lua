--- File: ZomboLust/42/media/lua/client/CameraZoom/ZomboLust_CameraZoom.lua
--- Configurable camera zoom range with logarithmic (geometric) zoom steps for Build 42.
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_CameraZoom.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"

--- Module name for logging
--- @type string
local MODULE_NAME = "CameraZoom"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

-- ==============
-- Configuration
-- ==============

local OPTIONS_ID = "ZomboLust_CameraZoom"
local ENABLED_OPTION_ID = "zoom_enabled"
local MIN_OPTION_ID = "zoom_min_percent"
local MAX_OPTION_ID = "zoom_max_percent"
local STEPS_OPTION_ID = "zoom_steps"

-- Off by default: this system replaces the vanilla B42 zoom range, so every player must
-- opt in explicitly rather than have it imposed on them.
local DEFAULT_ENABLED = false

local DEFAULT_MIN_PERCENT = 5
local DEFAULT_MAX_PERCENT = 300
local DEFAULT_STEPS = 30

--- Absolute bounds enforced on every generated zoom level (raw camera factors from 0.01 to 5.0).
local MIN_PERCENT_FLOOR = 1
local MAX_PERCENT_CEIL = 500

local MIN_SLIDER_MAX = 100
local MAX_SLIDER_MIN = 100

local MIN_STEPS = 5
local MAX_STEPS = 100
local OPTION_SLIDER_STEP = 1

local STARTUP_DELAY_TICKS = 30

--- Main module table for camera zoom configuration
--- @class ZomboLust_CameraZoom
--- @field enabled boolean
--- @field minPercent number
--- @field maxPercent number
--- @field steps number
--- @field apply fun(): boolean
--- @field _handlers table<string, function>
-- Defaults are inlined in the fallback table (rather than assigned field-by-field afterwards)
-- so a Lua hot reload (F11) still preserves the previous instance's runtime values,
-- while giving the type checker concrete non-nil defaults for a first load.
ZomboLust_CameraZoom = ZomboLust_CameraZoom or {
    enabled = DEFAULT_ENABLED,
    minPercent = DEFAULT_MIN_PERCENT,
    maxPercent = DEFAULT_MAX_PERCENT,
    steps = DEFAULT_STEPS,
}

-- LuaLS tracks @field types reliably from a local declaration but not always through a
-- global's "X = X or {...}" fallback assignment; pin Zoom's type explicitly so every
-- Zoom.minPercent/maxPercent/steps read below is resolved as non-nil number.
---@type ZomboLust_CameraZoom
local Zoom = ZomboLust_CameraZoom

-- ============================
-- Runtime state / hot reload
-- ============================

-- Event callbacks are function references, so persisting them on the global mod table
-- lets a fresh Lua instance detach the previous copy's handlers before registering its own.
Zoom._handlers = Zoom._handlers or {}

if Zoom._handlers.startupApply then
    Events.OnTick.Remove(Zoom._handlers.startupApply)
    Zoom._handlers.startupApply = nil
end

if Zoom._handlers.onGameStart then
    Events.OnGameStart.Remove(Zoom._handlers.onGameStart)
    Zoom._handlers.onGameStart = nil
end

if Zoom._handlers.onCreatePlayer then
    Events.OnCreatePlayer.Remove(Zoom._handlers.onCreatePlayer)
    Zoom._handlers.onCreatePlayer = nil
end

-- =======
-- Helpers
-- =======

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

local function roundPercent(value, fallback, minimum, maximum)
    value = tonumber(value) or fallback
    return math.floor(clamp(value, minimum, maximum) + 0.5)
end

local function normalizeSettings(minPercent, maxPercent, steps)
    minPercent = roundPercent(minPercent, DEFAULT_MIN_PERCENT, MIN_PERCENT_FLOOR, MIN_SLIDER_MAX)
    maxPercent = roundPercent(maxPercent, DEFAULT_MAX_PERCENT, MAX_SLIDER_MIN, MAX_PERCENT_CEIL)
    steps = roundPercent(steps, DEFAULT_STEPS, MIN_STEPS, MAX_STEPS)

    -- The two sliders overlap at 100%; guarantee a usable range regardless of input order.
    if minPercent >= maxPercent then
        maxPercent = math.min(minPercent + 1, MAX_PERCENT_CEIL)
    end

    return minPercent, maxPercent, steps
end

--- Inserts "percent" into "percentages" unless an equivalent value (to the nearest hundredth of a percent)
--- is already present, tracking membership via "seen".
--- Shared by buildZoomLevels() and restoreVanillaZoomLevels() so both can anchor the player's current zoom into whichever list they generate.
--- @param percentages number[]
--- @param seen table<integer, boolean>
--- @param percent number
local function addUniquePercent(percentages, seen, percent)
    local key = math.floor((percent * 100) + 0.5)
    if not seen[key] then
        seen[key] = true
        percentages[#percentages + 1] = percent
    end
end

--- Sorts percentages highest to lowest (the order B42's setZoomLevels() expects,
--- per the vanilla Tutorial1.lua example) and converts them to raw camera zoom factors.
--- @param percentages number[]
--- @return number[] levels
local function toSortedLevels(percentages)
    table.sort(percentages, function(a, b) return a > b end)

    local levels = {}
    for i = 1, #percentages do
        levels[i] = percentages[i] / 100.0
    end

    return levels
end

--- Builds zoom levels on a logarithmic (geometric) scale between minPercent and maxPercent.
--- Consecutive stops share a constant ratio rather than a constant difference, so stops are
--- naturally dense near minPercent (fine control when zoomed in) and sparse near maxPercent (fast scrolling when zoomed out).
--- @param minPercent number
--- @param maxPercent number
--- @param steps integer
--- @param anchorZoom number|nil -- current raw camera zoom factor, if any
--- @return number[] levels -- raw camera zoom factors, sorted highest to lowest
local function buildZoomLevels(minPercent, maxPercent, steps, anchorZoom)
    local percentages = {}
    local seen = {}

    local function addPercent(percent)
        addUniquePercent(percentages, seen, clamp(percent, minPercent, maxPercent))
    end

    local ratio = (maxPercent / minPercent) ^ (1 / (steps - 1))
    for i = 1, steps do
        addPercent(minPercent * (ratio ^ (i - 1)))
    end

    -- B42 requires the active camera's current zoom to exist in the installed zoom-stop list.
    -- Add it explicitly so the geometric scale itself never has to be distorted to accommodate it.
    if anchorZoom then
        addPercent(anchorZoom * 100.0)
    end

    return toSortedLevels(percentages)
end

--- Restores the vanilla B42 zoom-stop list, so turning this system off (or never enabling it)
--- leaves the camera exactly as the base game or another zoom mod set it up.
--- getDefaultZoomLevels() returns the vanilla percentages as a Java ArrayList<integer>
--- (see MainOptions.lua:1426-1428), converted here to the raw factors setZoomLevels() expects.
--- @return boolean success
local function restoreVanillaZoomLevels()
    local core = getCore()
    if not core then return false end

    local ok, defaults = pcall(function() return core:getDefaultZoomLevels() end)
    if not ok or not defaults then
        ZomboLust.errorLog(MODULE_NAME, "Could not read the vanilla default zoom levels.")
        return false
    end

    local percentages = {}
    local seen = {}
    for i = 1, defaults:size() do
        addUniquePercent(percentages, seen, defaults:get(i - 1))
    end

    -- The player's current zoom may still be sitting on one of our custom (off-grid) stops from before this system was turned off.
    -- B42 requires the active camera's current zoom to exist in the installed list,
    -- so anchor it here too, exactly like buildZoomLevels() does going the other way,
    -- instead of assuming the engine gracefully snaps to the nearest vanilla stop on its own.
    if getSpecificPlayer(0) then
        local currentZoom = core:getZoom(0)
        if currentZoom then
            addUniquePercent(percentages, seen, currentZoom * 100.0)
        end
    end

    local levels = toSortedLevels(percentages)
    if #levels == 0 then
        ZomboLust.errorLog(MODULE_NAME, "Vanilla default zoom levels were empty.")
        return false
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    setZoomLevels(unpack(levels))

    ZomboLust.debugLog(MODULE_NAME, "Custom zoom disabled; restored %d vanilla zoom levels.", #levels)

    return true
end

local function loadSavedSettings()
    if not PZAPI or not PZAPI.ModOptions then return end

    local options = PZAPI.ModOptions:getOptions(OPTIONS_ID)
    if not options then return end

    local enabledOption = options:getOption(ENABLED_OPTION_ID)
    local minOption = options:getOption(MIN_OPTION_ID)
    local maxOption = options:getOption(MAX_OPTION_ID)
    local stepsOption = options:getOption(STEPS_OPTION_ID)

    if enabledOption then
        ---@cast enabledOption umbrella.ModOptions.TickBox
        Zoom.enabled = enabledOption:getValue()
    end

    local minValue = Zoom.minPercent
    local maxValue = Zoom.maxPercent
    local stepsValue = Zoom.steps

    -- getOption() returns a union of every possible option kind (some of which, like Button, have no getValue());
    -- narrowing to Slider here is what these IDs are always registered as,
    -- matching the ---@cast pattern used for the difficulty ComboBox elsewhere.
    if minOption then
        ---@cast minOption umbrella.ModOptions.Slider
        minValue = minOption:getValue()
    end

    if maxOption then
        ---@cast maxOption umbrella.ModOptions.Slider
        maxValue = maxOption:getValue()
    end

    if stepsOption then
        ---@cast stepsOption umbrella.ModOptions.Slider
        stepsValue = stepsOption:getValue()
    end

    Zoom.minPercent, Zoom.maxPercent, Zoom.steps = normalizeSettings(minValue, maxValue, stepsValue)
end

local function stopStartupApply()
    if Zoom._handlers.startupApply then
        Events.OnTick.Remove(Zoom._handlers.startupApply)
        Zoom._handlers.startupApply = nil
    end
end

-- ========================
-- Apply zoom configuration
-- ========================

function Zoom.apply()
    if type(setZoomLevels) ~= "function" then
        ZomboLust.errorLog(MODULE_NAME, "setZoomLevels() is unavailable; custom zoom settings were not applied.")
        return false
    end

    -- Off by default and fully optional: players who prefer the vanilla range (or another zoom mod) must never have this system imposed on them.
    if not Zoom.enabled then
        return restoreVanillaZoomLevels()
    end

    -- Read back through locals rather than Zoom.* for the rest of this function.
    local minPercent, maxPercent, steps = normalizeSettings(Zoom.minPercent, Zoom.maxPercent, Zoom.steps)
    Zoom.minPercent, Zoom.maxPercent, Zoom.steps = minPercent, maxPercent, steps

    local core = getCore()
    local anchorZoom = nil
    if core and getSpecificPlayer(0) then
        anchorZoom = core:getZoom(0)
    end

    local levels = buildZoomLevels(minPercent, maxPercent, steps, anchorZoom)
    if #levels == 0 then
        ZomboLust.errorLog(MODULE_NAME, "No zoom levels were generated.")
        return false
    end

    -- The Umbrella stub declares a single kahlua.Array<number> parameter, but vanilla B42
    -- code (Tutorial1.lua: setZoomLevels(1.75, 1.5, 1.25, 1.0)) confirms the real calling
    -- convention is individual number arguments; the stub is imprecise, not this call.
    ---@diagnostic disable-next-line: param-type-mismatch
    setZoomLevels(unpack(levels))

    ZomboLust.debugLog(
        MODULE_NAME,
        "Applied %d%%-%d%% range over %d requested steps (%d levels generated).",
        minPercent, maxPercent, steps, #levels
    )

    return true
end

-- =====================
-- Build 42 Mod Options
-- =====================

local function registerOptions()
    if not PZAPI or not PZAPI.ModOptions then
        ZomboLust.errorLog(MODULE_NAME, "PZAPI.ModOptions unavailable; settings UI was not registered.")
        return
    end

    -- Reuse the existing options object during F11 reloads.
    -- Creating another object with the same controls would duplicate UI entries/callbacks.
    local options = PZAPI.ModOptions:getOptions(OPTIONS_ID)
    if not options then
        options = PZAPI.ModOptions:create(OPTIONS_ID, "ZomboLust - Camera Zoom")
    end

    options:addTitle(getText("UI_options_ZomboLust_zoomTitle"))

    local enabledTickBox = options:getOption(ENABLED_OPTION_ID)
    if not enabledTickBox then
        enabledTickBox = options:addTickBox(
            ENABLED_OPTION_ID,
            getText("UI_options_ZomboLust_zoom_enabled"),
            DEFAULT_ENABLED,
            getText("UI_options_ZomboLust_zoom_enabled_tooltip")
        )
    end
    ---@cast enabledTickBox umbrella.ModOptions.TickBox

    -- options:addSeparator()

    local minSlider = options:getOption(MIN_OPTION_ID)
    if not minSlider then
        minSlider = options:addSlider(
            MIN_OPTION_ID,
            getText("UI_options_ZomboLust_zoom_min"),
            MIN_PERCENT_FLOOR,
            MIN_SLIDER_MAX,
            OPTION_SLIDER_STEP,
            DEFAULT_MIN_PERCENT,
            getText("UI_options_ZomboLust_zoom_min_tooltip")
        )
    end

    local maxSlider = options:getOption(MAX_OPTION_ID)
    if not maxSlider then
        maxSlider = options:addSlider(
            MAX_OPTION_ID,
            getText("UI_options_ZomboLust_zoom_max"),
            MAX_SLIDER_MIN,
            MAX_PERCENT_CEIL,
            OPTION_SLIDER_STEP,
            DEFAULT_MAX_PERCENT,
            getText("UI_options_ZomboLust_zoom_max_tooltip")
        )
    end

    local stepsSlider = options:getOption(STEPS_OPTION_ID)
    if not stepsSlider then
        stepsSlider = options:addSlider(
            STEPS_OPTION_ID,
            getText("UI_options_ZomboLust_zoom_steps"),
            MIN_STEPS,
            MAX_STEPS,
            OPTION_SLIDER_STEP,
            DEFAULT_STEPS,
            getText("UI_options_ZomboLust_zoom_steps_tooltip")
        )
    end

    -- getOption()/addSlider() both resolve to the full option-kind union;
    -- narrow each to Slider so getValue() is unambiguous, matching the pattern used above.
    ---@cast minSlider umbrella.ModOptions.Slider
    ---@cast maxSlider umbrella.ModOptions.Slider
    ---@cast stepsSlider umbrella.ModOptions.Slider

    -- Grey the range sliders out while the system is off, so it's visually obvious they
    -- have no effect until the master switch above them is checked.
    local function setSlidersEnabled(isEnabled)
        minSlider:setEnabled(isEnabled)
        maxSlider:setEnabled(isEnabled)
        stepsSlider:setEnabled(isEnabled)
    end

    setSlidersEnabled(Zoom.enabled)

    enabledTickBox.onChange = function(_, selected)
        setSlidersEnabled(selected)
    end

    -- Replace the previous apply callback on every reload so it always closes over the current script instance.
    options.apply = function()
        Zoom.enabled = enabledTickBox:getValue()
        Zoom.minPercent = minSlider:getValue()
        Zoom.maxPercent = maxSlider:getValue()
        Zoom.steps = stepsSlider:getValue()

        Zoom.apply()
    end
end

-- ==========
-- Lifecycle
-- ==========

local function onGameStart()
    loadSavedSettings()
    stopStartupApply()

    local ticks = 0
    Zoom._handlers.startupApply = function()
        ticks = ticks + 1
        if ticks < STARTUP_DELAY_TICKS then return end

        stopStartupApply()
        Zoom.apply()
    end

    Events.OnTick.Add(Zoom._handlers.startupApply)
end

local function onCreatePlayer()
    -- Newly created players start at a game-selected zoom value.
    -- Reapplying the configured levels anchors the new camera against them immediately.
    Zoom.apply()
end

registerOptions()

Zoom._handlers.onGameStart = onGameStart
Zoom._handlers.onCreatePlayer = onCreatePlayer

Events.OnGameStart.Add(Zoom._handlers.onGameStart)
Events.OnCreatePlayer.Add(Zoom._handlers.onCreatePlayer)

-- F11 reload can happen while a game is already active, so apply immediately when a player exists.
-- A normal initial load still uses OnGameStart's startup delay.
if getSpecificPlayer(0) then
    loadSavedSettings()
    Zoom.apply()
end

return Zoom
