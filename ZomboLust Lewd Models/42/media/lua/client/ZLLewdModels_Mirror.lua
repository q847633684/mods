--- File: ZomboLust Lewd Models/42/media/lua/client/ZLLewdModels_Mirror.lua
--- UI for the Mirror functionality
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust Lewd Models LOADING] ZLLewdModels_Mirror.lua loaded")

-- Module name for logging
--- @type string
local MODULE_NAME = "Mirror"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZLLewdModels.isDebug in ZomboLustLewdModels_Main.lua).
--- Calls with cheap/no arguments use ZLLewdModels.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZLLewdModels.isDebug(MODULE_NAME)
end

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local tostring = tostring
local abs = math.abs

-- =============
-- Dependencies
-- =============
require "ZomboLustLewdModels_Main"
require "ISUI/ISColorPickerHSB"
require "RadioCom/ISUIRadio/ISSliderPanel"

-- ================
-- Module Namespace
-- ================

ZLLewdModels = ZLLewdModels or {}
--- @class ZLLewdModels.Mirror : ISCollapsableWindow
--- @field playerz IsoPlayer -- The player character associated with this window
--- @field Isometric boolean -- Whether the camera is in isometric mode
--- @field playermodel ISCharacterScreenAvatar -- The 3D avatar panel
--- @field colorPicker ISColorPickerHSB -- The color picker
--- @field alphaSlider ISSliderPanel -- The alpha slider
--- @field entry2 ISTextEntryBox -- The scale input box
--- @field lbl ISLabel -- The background color label
--- @field lbl2 ISLabel -- The scale label
--- @field buttonaction ISButton -- The toggle camera button
--- @field animCombo ISComboBox -- The animation selection combo box
--- @field paneledge number -- Padding for UI elements
--- @field buttonwidth number -- Standard button width
--- @field buttonheight number -- Standard button height
--- @field instance ZLLewdModels.Mirror -- The singleton instance of the Mirror UI
--- @field open fun(player: IsoPlayer): ZLLewdModels.Mirror -- Opens or restores the Mirror UI
--- @field isMirrorOnSquare fun(square: IsoGridSquare, playerObj: IsoPlayer): boolean -- Checks for a mirror on a square
--- @field tabpanel ISTabPanel -- The tab panel
--- @field viewPanel ISPanel -- The panel for the avatar view
--- @field settingsPanel ISPanel -- The panel for color and alpha settings
ZLLewdModels.Mirror = ISCollapsableWindow:derive("ZLLewdModels.Mirror")
ZLLewdModels.Mirror.instance = nil

-- Fix for IDE warnings regarding missing layout methods in Umbrella definitions
--- @format disable
--- @param layout any
function ISCollapsableWindow:SaveLayout(layout) end
--- @param layout any
function ISCollapsableWindow:RestoreLayout(layout) end
--- @format enable

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

--- Updates the background color based on picker and slider values
function ZLLewdModels.Mirror:updateBackgroundColor()
    local rgb = self.colorPicker.pickedRGB
    local alpha = self.alphaSlider:getCurrentValue()
    self.backgroundColor = {r = rgb.r, g = rgb.g, b = rgb.b, a = alpha}
    ZLLewdModels.debugLog(MODULE_NAME, "Updated background color: R=%f, G=%f, B=%f, A=%f", rgb.r, rgb.g, rgb.b, alpha)
end

--- Toggles between isometric and front camera view
function ZLLewdModels.Mirror:playaction()
    self.Isometric = not self.Isometric
    self.playermodel:setIsometric(self.Isometric)
    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "Toggled camera. Isometric: %s", tostring(self.Isometric))
    end
end

--- Handles animation selection from the combo box
--- @param combo ISComboBox -- The animation selection combo box
function ZLLewdModels.Mirror:onAnimSelected(combo)
    local state = combo:getOptionData(combo.selected)
    
    -- When using the combo, we are always in player-avatar mode
    self.playermodel:setAnimSetName("player-avatar")
    self.playermodel:clearVariables()
    
    if state == "idle" then
        self.playermodel:setState(nil)
        self.playermodel:reportEvent("EventIdle")
    elseif state == "walk" then
        self.playermodel:setState(nil)
        self.playermodel:reportEvent("EventWalk")
    elseif state == "run" then
        self.playermodel:setState(nil)
        self.playermodel:reportEvent("EventRun")
    end
    
    ZLLewdModels.debugLog(MODULE_NAME, "Selected standard state: %s", state)
end

--- Handles the Aim pose toggle
--- @param index number
--- @param selected boolean
function ZLLewdModels.Mirror:onAimTicked(index, selected)
    if selected then
        -- 1. Reset combo to Idle and disable it
        self.animCombo.selected = 1
        self.animCombo.enable = false
        
        -- 2. Switch to player AnimSet for Aim pose
        self.playermodel:setAnimSetName("player")
        self.playermodel:clearVariables()
        self.playermodel:setVariable("verticalAimAngle", 0.0)
        self.playermodel:setVariable("IdleSpeed", 0.2)
        
        -- Weapon handling
        local weapon = self.playerz:getPrimaryHandItem()
        local weaponType = "knife"
        if weapon and instanceof(weapon, "HandWeapon") then
            weaponType = self.playerz:getVariableString("Weapon") or "knife"
        end
        self.playermodel:setVariable("Weapon", weaponType)
        self.playermodel:setState("aim")
        ZLLewdModels.debugLog(MODULE_NAME, "Aim pose ACTIVE - Combo disabled")
    else
        -- 1. Re-enable combo
        self.animCombo.enable = true
        
        -- 2. Force back to Idle (resetting to player-avatar set)
        self:onAnimSelected(self.animCombo)
        ZLLewdModels.debugLog(MODULE_NAME, "Aim pose INACTIVE - Returning to Idle")
    end
end

--- Displays a mini help window explaining the avatar controls
function ZLLewdModels.Mirror:onHelp()
    local helpText = " <RGB:1,1,1> <H1> " .. getText("IGUI_ZLLewdModels_Help_Title") .. " <LINE> <H2> <RGB:0.8,0.8,0.8> "
    helpText = helpText .. " <TEXT> " .. getText("IGUI_ZLLewdModels_Help_Zoom") .. " <LINE> "
    helpText = helpText .. " <TEXT> " .. getText("IGUI_ZLLewdModels_Help_Pan") .. " <LINE> "
    helpText = helpText .. " <TEXT> " .. getText("IGUI_ZLLewdModels_Help_Reset") .. " <LINE> "
    
    local width = 350
    local height = 200
    local x = self:getAbsoluteX() + (self:getWidth() / 2) - (width / 2)
    local y = self:getAbsoluteY() + (self:getHeight() / 2) - (height / 2)
    
    local modal = ISModalRichText:new(x, y, width, height, helpText, false, nil, nil, nil)
    modal:initialise()
    modal:addToUIManager()
    modal.backgroundColor = {r=0, g=0, b=0, a=0.9}
end

--- Creates the UI elements inside the window
function ZLLewdModels.Mirror:createChildren()
    ISCollapsableWindow.createChildren(self)

    self.paneledge = 10
    self.buttonwidth = 80
    self.buttonheight = 25
    local bottomAreaHeight = 60 -- Increased height for the bottom controls area

    local titleBarHeight = self:titleBarHeight()

    -- Tab Panel
    self.tabpanel = ISTabPanel:new(0, titleBarHeight, self.width, self.height - titleBarHeight - bottomAreaHeight - self.paneledge)
    self.tabpanel:initialise()
    self.tabpanel.background = false -- Make it transparent to see window background
    self:addChild(self.tabpanel)

    -- View Panel (Tab 1)
    self.viewPanel = ISPanel:new(0, 0, self.tabpanel.width, self.tabpanel.height - self.tabpanel.tabHeight)
    self.viewPanel:initialise()
    self.viewPanel.background = false -- Make it transparent
    self.viewPanel:setVisible(false)
    self.tabpanel:addView(getText("IGUI_ZLLewdModels_Tab_View"), self.viewPanel)

    -- Character Model View (Inside View Panel)
    self.playermodel = ISCharacterScreenAvatar:new(self.paneledge, self.paneledge, self.viewPanel.width - 2*self.paneledge, self.viewPanel.height - 2*self.paneledge)
    self.playermodel:setVisible(true)
    self.viewPanel:addChild(self.playermodel)

    -- View properties (Framing)
    self.playermodel.zoomLevel = 0.0
    self.playermodel.yOffsetValue = -0.5
    self.playermodel.xOffsetValue = 0.0
    self.playermodel.zoomStep = 1.0
    self.playermodel.dragPanSpeed = 0.002
    self.playermodel.rotateStepPixels = 32
    self.playermodel.dragRotateAccum = 0

    -- Apply initial view
    local function applyView(model)
        ---@cast model any
        model:setZoom(model.zoomLevel)
        model:setYOffset(model.yOffsetValue)
        model:setXOffset(model.xOffsetValue)
    end

    -- Override mouse events for zoom and panning
    self.playermodel.onMouseWheel = function(model, del)
        ---@cast model any
        model.zoomLevel = model.zoomLevel - (del * model.zoomStep)
        applyView(model)
        return true
    end

    self.playermodel.onMouseDown = function(model, x, y)
        ---@cast model any
        model.mouseDown = true
        model.dragRotateAccum = 0
        model.dragX = 0 -- Fix for ISUI3DModel:onMouseMoveOutside expecting dragX to be a number
        model:setCapture(true)
        return true
    end

    self.playermodel.onMouseMove = function(model, dx, dy)
        ---@cast model any
        if model.mouseDown then
            -- Rotation
            model.dragRotateAccum = model.dragRotateAccum + dx
            while abs(model.dragRotateAccum) >= model.rotateStepPixels do
                local dir = model:getDirection() or IsoDirections.S
                dir = IsoDirectionSet.rotate(dir, (model.dragRotateAccum < 0) and -1 or 1)
                model:setDirection(dir)
                model.dragRotateAccum = model.dragRotateAccum + ((model.dragRotateAccum < 0) and model.rotateStepPixels or -model.rotateStepPixels)
            end
            -- Vertical Positioning (Panning)
            model.yOffsetValue = model.yOffsetValue - (dy * model.dragPanSpeed)
            applyView(model)
        end
        return true
    end

    self.playermodel.onMouseMoveOutside = function(model, dx, dy)
        ---@cast model any
        if model.mouseDown then
            -- Fix for ISUI3DModel:onMouseMoveOutside (though this override prevents it from being called)
            model.dragX = (model.dragX or 0) + dx
            -- Mirror the onMouseMove logic for consistency
            model.dragRotateAccum = model.dragRotateAccum + dx
            while math.abs(model.dragRotateAccum) >= model.rotateStepPixels do
                local dir = model:getDirection() or IsoDirections.S
                dir = IsoDirectionSet.rotate(dir, (model.dragRotateAccum < 0) and -1 or 1)
                model:setDirection(dir)
                model.dragRotateAccum = model.dragRotateAccum + ((model.dragRotateAccum < 0) and model.rotateStepPixels or -model.rotateStepPixels)
            end
            -- Vertical Positioning (Panning)
            model.yOffsetValue = model.yOffsetValue - (dy * model.dragPanSpeed)
            applyView(model)
        end
    end

    self.playermodel.onMouseUp = function(model, x, y)
        ---@cast model any
        model.mouseDown = false
        model.dragRotateAccum = 0
        model.dragX = 0
        model:setCapture(false)
        return true
    end

    self.playermodel.onMouseUpOutside = function(model, x, y)
        ---@cast model any
        if model.mouseDown then
            model.mouseDown = false
            model.dragRotateAccum = 0
            model.dragX = 0
            model:setCapture(false)
        end
        return true
    end

    -- Reset view on right click
    self.playermodel.onRightMouseUp = function(model, x, y)
        ---@cast model any
        model.zoomLevel = 0.0
        model.yOffsetValue = -0.5
        model.xOffsetValue = 0.0
        applyView(model)
        return true
    end

    -- Default setup
    self.playermodel:setState("idle")
    self.playermodel:setDirection(IsoDirections.S)
    self.playermodel:setIsometric(false)
    self.playermodel:setCharacter(self.playerz)
    applyView(self.playermodel)

    -- Settings Panel (Tab 2)
    self.settingsPanel = ISPanel:new(0, 0, self.tabpanel.width, self.tabpanel.height - self.tabpanel.tabHeight)
    self.settingsPanel:initialise()
    self.settingsPanel.background = false -- Make it transparent
    self.settingsPanel:setVisible(false)
    self.tabpanel:addView(getText("IGUI_ZLLewdModels_Tab_Settings"), self.settingsPanel)

    local localheight = self.paneledge

    -- Label for background color
    self.lbl = ISLabel:new(self.paneledge, localheight, self.buttonheight, getText("IGUI_ZLLewdModels_BGColor"), 1, 1, 1, 1.0, UIFont.Small, true)
    self.lbl:initialise()
    self.lbl:instantiate()
    self.settingsPanel:addChild(self.lbl)

    localheight = localheight + self.buttonheight + 2

    -- HSB Color Picker
    local initialColor = ColorInfo.new(self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b, self.backgroundColor.a)
    self.colorPicker = ISColorPickerHSB:new(self.paneledge, localheight, initialColor)
    self.colorPicker:initialise()
    self.colorPicker:instantiate()
    self.colorPicker:setInitialColor(initialColor) -- Explicitly set initial color
    -- Override onSliderChange to update in real-time
    local oldOnSliderChange = self.colorPicker.onSliderChange
    self.colorPicker.onSliderChange = function(picker, value, slider)
        oldOnSliderChange(picker, value, slider)
        self:updateBackgroundColor()
    end
    -- Override onMouseDownColorBox to update in real-time
    local oldOnMouseDownColorBox = self.colorPicker.onMouseDownColorBox
    self.colorPicker.onMouseDownColorBox = function(picker, x, y)
        oldOnMouseDownColorBox(picker, x, y)
        self:updateBackgroundColor()
    end
    -- PREVENT DISAPPEARING: Disable automatic removal when clicking outside
    self.colorPicker.onMouseDownOutside = function(picker, x, y) end
    self.settingsPanel:addChild(self.colorPicker)

    localheight = localheight + self.colorPicker:getHeight() + self.paneledge

    -- Alpha Label
    local alphaLbl = ISLabel:new(self.paneledge, localheight, self.buttonheight, getText("IGUI_ZLLewdModels_Alpha"), 1, 1, 1, 1.0, UIFont.Small, true)
    alphaLbl:initialise()
    alphaLbl:instantiate()
    self.settingsPanel:addChild(alphaLbl)

    -- Alpha Slider
    self.alphaSlider = ISSliderPanel:new(self.paneledge + 80, localheight, 200, self.buttonheight, self, self.updateBackgroundColor)
    self.alphaSlider:initialise()
    self.alphaSlider:instantiate()
    self.alphaSlider:setValues(0, 1, 0.01, 0.1)
    self.alphaSlider:setCurrentValue(self.backgroundColor.a, true)
    self.settingsPanel:addChild(self.alphaSlider)
    
    -- Help Button (?)
    local helpBtnSize = 20
    self.helpBtn = ISButton:new(self.width - helpBtnSize - 10, titleBarHeight + 2, helpBtnSize, helpBtnSize, "?", self, self.onHelp)
    self.helpBtn:initialise()
    self.helpBtn:instantiate()
    self.helpBtn.borderColor = {r=1, g=1, b=1, a=0.3}
    self.helpBtn:setFont(UIFont.Medium)
    self:addChild(self.helpBtn)

    -- Ensure real-time background color is applied at startup
    self:updateBackgroundColor()

    -- Row of buttons (Bottom, always visible)
    local bottomY = self.height - bottomAreaHeight + self.paneledge
    local buttonX = self.paneledge

    -- Toggle Camera Button
    self.buttonaction = ISButton:new(buttonX, bottomY, self.buttonwidth, self.buttonheight, getText("IGUI_ZLLewdModels_Camera"), self, self.playaction)
    self.buttonaction:initialise()
    self.buttonaction:instantiate()
    self.buttonaction.borderColor = {r=1, g=1, b=1, a=1}
    self:addChild(self.buttonaction)

    buttonX = buttonX + self.buttonwidth + self.paneledge

    -- Animation Selector
    self.animCombo = ISComboBox:new(buttonX, bottomY, 120, self.buttonheight, self, self.onAnimSelected)
    self.animCombo:initialise()
    self:addChild(self.animCombo)
    self.animCombo:addOptionWithData(getText("IGUI_anim_Idle"), "idle")
    self.animCombo:addOptionWithData(getText("IGUI_anim_Walk"), "walk")
    self.animCombo:addOptionWithData(getText("IGUI_anim_Run"), "run")
    self.animCombo.selected = 1

    buttonX = buttonX + 120 + self.paneledge

    -- Aim Toggle (TickBox)
    self.aimTickBox = ISTickBox:new(buttonX, bottomY, 100, self.buttonheight, "", self, self.onAimTicked)
    self.aimTickBox:initialise()
    self.aimTickBox:instantiate()
    self.aimTickBox:addOption(getText("IGUI_anim_Aim"))
    self:addChild(self.aimTickBox)
end

--- Renders the UI and updates the 3D model properties
function ZLLewdModels.Mirror:render()
    ISCollapsableWindow.render(self)

    if self.playermodel and self.playermodel.javaObject then
        self.playermodel.javaObject:setWidth(self.viewPanel.width - 2*self.paneledge)
        self.playermodel.javaObject:setHeight(self.viewPanel.height - 2*self.paneledge)
    end
    -- Do not delete or try to optimize this shit.
    -- setCharacter MUST be present, and the function MUST remain render(self)
    -- otherwise, the character will not be updated with each clothing change, for example
    self.playermodel:setCharacter(self.playerz)
end

function ZLLewdModels.Mirror:SaveLayout(name, layout)
    ISLayoutManager.DefaultSaveWindow(self, layout)
    layout.backgroundColor = self.backgroundColor.r .. "," .. self.backgroundColor.g .. "," .. self.backgroundColor.b .. "," .. self.backgroundColor.a
end

function ZLLewdModels.Mirror:RestoreLayout(name, layout)
    ISLayoutManager.DefaultRestoreWindow(self, layout)
    if layout.backgroundColor then
        local rgb = string.split(layout.backgroundColor, ",")
        if #rgb == 4 then
            self.backgroundColor = {r = tonumber(rgb[1]), g = tonumber(rgb[2]), b = tonumber(rgb[3]), a = tonumber(rgb[4])}
            -- Update UI if it's already created
            if self.colorPicker and self.alphaSlider then
                local initialColor = ColorInfo.new(self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b, self.backgroundColor.a)
                self.colorPicker:setInitialColor(initialColor)
                self.alphaSlider:setCurrentValue(self.backgroundColor.a, true)
            end
        end
    end
end

--- Constructor for the Mirror UI
--- @param x number -- X position of the window
--- @param y number -- Y position of the window
--- @param width number -- Width of the window
--- @param height number -- Height of the window
--- @param player IsoPlayer -- The player character associated with the UI
--- @return ZLLewdModels.Mirror -- The new Mirror instance
function ZLLewdModels.Mirror:new(x, y, width, height, player)
    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "Creating new Mirror UI instance for player: %s", player:getFullName())
    end
    --- @type ZLLewdModels.Mirror
    local o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.backgroundColor = {r=0, g=0, b=0, a=0.5}
    o.resizable = true
    o.playerz = player
    o.Isometric = false
    return o
end

--- Opens or restores the Mirror UI
--- @param player IsoPlayer -- The player character opening the UI
--- @return ZLLewdModels.Mirror -- The Mirror UI instance
function ZLLewdModels.Mirror.open(player)
    if ZLLewdModels.Mirror.instance then
        ZLLewdModels.Mirror.instance.playerz = player
        if ZLLewdModels.Mirror.instance.playermodel then
            ZLLewdModels.Mirror.instance.playermodel:setCharacter(player)
        end
        ZLLewdModels.Mirror.instance:setVisible(true)
        ZLLewdModels.Mirror.instance:addToUIManager()
        if dbg() then
            ZLLewdModels.debugLog(MODULE_NAME, "Restored existing Mirror UI instance for player: %s", player:getFullName())
        end
        return ZLLewdModels.Mirror.instance
    end

    local width = 550
    local height = 650
    local x = (getCore():getScreenWidth() / 2) - (width / 2)
    local y = (getCore():getScreenHeight() / 2) - (height / 2)

    local mirror = ZLLewdModels.Mirror:new(x, y, width, height, player)
    mirror:initialise()
    
    -- PERSISTENCE: Register the window with ISLayoutManager to remember position/size
    -- CRITICAL: Must be called before setVisible to avoid overwriting visibility state
    ISLayoutManager.RegisterWindow("ZLLewdModels_Mirror", ZLLewdModels.Mirror, mirror)
    
    mirror:setVisible(true)
    mirror:addToUIManager()

    ZLLewdModels.Mirror.instance = mirror
    ZLLewdModels.debugLog(MODULE_NAME, "Created and registered new Mirror UI instance")
    return mirror
end

--- Fills the context menu for inventory items
--- @param playerNum integer -- The index of the player who right-clicked
--- @param context any -- The context menu being filled
--- @param items table -- The list of items selected in the inventory
local function onFillInventoryObjectContextMenu(playerNum, context, items)
    local player = getSpecificPlayer(playerNum)
    if not player then return end

    ZLLewdModels.debugLog(MODULE_NAME, "Filling inventory context menu for player %d", playerNum)

    local mirrorItem = nil
    for i = 1, #items do
        local item = items[i]
        if not instanceof(item, "InventoryItem") then
            item = item.items[1]
        end
        if item:getFullType() == "Base.Mirror" then
            mirrorItem = item
            break
        end
    end

    if mirrorItem then
        context:addOption(getText("IGUI_ZLLewdModels_Context_LookAtMirror"), player, function()
            ZLLewdModels.Mirror.open(player)
        end)
    end
end

Events.OnFillInventoryObjectContextMenu.Add(onFillInventoryObjectContextMenu)
