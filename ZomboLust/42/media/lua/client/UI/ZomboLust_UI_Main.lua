-- File: ZomboLust/42/media/lua/client/UI/ZomboLust_UI_Main.lua
-- Initialization and registration of the ZomboLust UI
-- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_UI_Main.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"
require "UI/ZomboLust_ImageUI"
require "UI/ZomboLust_Sidebar"

-- Module name for logging
--- @type string
local MODULE_NAME = "UIMain"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

--- Initializes the ZomboLust UI components
local function onCreateUI()
    if ZomboLust.UI then
        ZomboLust.debugLog(MODULE_NAME, "onCreateUI: UI already initialized, skipping")
        return
    end

    local x = 100
    local y = 100
    local width = 304 -- Recommended video width (divisible by 8)
    local height = 256 -- 232 (video) + 24 (title bar)

    ZomboLust.debugLog(MODULE_NAME, "onCreateUI: Creating ZomboLust Sexual Activity Viewer window at %dx%d", width, height)

    -- Create the image viewer window
    local ui = ZomboLust_ImageUI:new(x, y, width, height)
    ui:initialise()
    ui:addToUIManager()
    ui:setVisible(false) -- Start hidden until triggered

    -- Register to the global ZomboLust namespace for easy access from event handlers
    ---@diagnostic disable-next-line: inject-field
    ZomboLust.UI = ui

    -- PERSISTENCE: Register the window with ISLayoutManager to remember position/size
    ISLayoutManager.RegisterWindow("ZomboLust_SexualActivityViewer", ZomboLust_ImageUI, ui)

    ZomboLust.debugLog(MODULE_NAME, "onCreateUI: ZomboLust Sexual Activity Viewer initialized and added to UIManager")
end

-- Hook into the OnCreateUI event
Events.OnCreateUI.Add(onCreateUI)

ZomboLust.debugLog(MODULE_NAME, "ZomboLust_UI_Main.lua loaded and Event listeners registered")
