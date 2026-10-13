-- File: ZomboLust/42/media/lua/client/Excitation/ZomboLust_ExcitationUI.lua
-- UI widgets for the ZomboLust Excitation system: the fullscreen pink overlay and the draggable excitation bar.
-- Simulation/logic lives in ZomboLust_ExcitationSystem.lua.
-- Single-player only: this file hardcodes getSpecificPlayer(0) and creates one singleton OverlayUI/BarUI pair,
-- see the Architecture Assumption note in ZomboLust_Main.lua.
-- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_ExcitationUI.lua loaded")

---@diagnostic disable: inject-field
-- =============
-- Dependencies
-- =============
require "ISUI/ISPanel"
require "Excitation/ZomboLust_ExcitationSystem"

-- Module name for logging
--- @type string
local MODULE_NAME = "ExcitationUI"

local getExcitation = ZomboLust_ExcitationSystem.getExcitation

-- ==============
-- UI Components
-- ==============

---@class ZomboLust_ExcitationOverlay : ISPanel
ZomboLust_ExcitationOverlay = ISPanel:derive("ZomboLust_ExcitationOverlay")

function ZomboLust_ExcitationOverlay:new()
    local o = ISPanel:new(0, 0, 0, 0) -- Start with 0 size to avoid blocking clicks
    setmetatable(o, self)
    self.__index = self
    o.backgroundColor = {r=0, g=0, b=0, a=0}
    o.borderColor = {r=0, g=0, b=0, a=0}
    o.moveWithMouse = false
    o:backMost() -- Render behind most UI but in front of the world
    return o
end

function ZomboLust_ExcitationOverlay:initialise()
    ISPanel.initialise(self)
    -- Crucial: ignore mouse events
    if self.javaObject and self.javaObject.setConsumeMouseEvents then
        self.javaObject:setConsumeMouseEvents(false)
    end
end

function ZomboLust_ExcitationOverlay:prerender()
    local player = getSpecificPlayer(0)
    if not player then return end

    local excitation = getExcitation(player)
    if excitation <= 0 then return end

    local screenW = getCore():getScreenWidth()
    local screenH = getCore():getScreenHeight()

    -- Calculate Alpha based on 10% steps
    -- 1-10% -> 0.1, 11-20% -> 0.2, ..., 91-100% -> 1.0
    local alpha = math.ceil(excitation / 10) / 10
    if alpha > 1.0 then alpha = 1.0 end

    local tex = getTexture("media/ui/Excitation.png")
    if not tex then return end

    -- Draw to cover the whole screen
    self:drawTextureScaled(tex, 0, 0, screenW, screenH, alpha, 1, 1, 1)
end

function ZomboLust_ExcitationOverlay:render()
end

---@class ZomboLust_ExcitationBar : ISPanel
---@field currentAlpha number
ZomboLust_ExcitationBar = ISPanel:derive("ZomboLust_ExcitationBar")
ZomboLust_ExcitationBar.__index = ZomboLust_ExcitationBar

---@param x number
---@param y number
---@param width number
---@param height number
---@return ZomboLust_ExcitationBar
function ZomboLust_ExcitationBar:new(x, y, width, height)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    o:noBackground()
    o.backgroundColor = {r=0, g=0, b=0, a=0}
    o.borderColor = {r=0, g=0, b=0, a=0}
    o.currentAlpha = 1.0
    o.moveWithMouse = true
    return o
end

---@param _x number
---@param _y number
---@return boolean
function ZomboLust_ExcitationBar:onMouseDown(_x, _y)
    self.dragging = true
    ZomboLust.debugLog(MODULE_NAME, "ExcitationBar: MouseDown - Dragging started")
    return true
end

---@param dx number
---@param dy number
---@return boolean
function ZomboLust_ExcitationBar:onMouseMove(dx, dy)
    if self.dragging then
        local newX = self:getX() + dx
        local newY = self:getY() + dy

        -- Clamp to screen
        local screenWidth = getCore():getScreenWidth()
        local screenHeight = getCore():getScreenHeight()
        newX = math.max(0, math.min(newX, screenWidth - self:getWidth()))
        newY = math.max(0, math.min(newY, screenHeight - self:getHeight()))

        self:setX(newX)
        self:setY(newY)
        return true
    end
    -- Return false to allow other UI elements (like Inventory) to receive mouse events
    return false
end

---@param dx number
---@param dy number
---@return boolean
function ZomboLust_ExcitationBar:onMouseMoveOutside(dx, dy)
    return self:onMouseMove(dx, dy)
end

---@param _x number
---@param _y number
---@return boolean
function ZomboLust_ExcitationBar:onMouseUp(_x, _y)
    if self.dragging then
        self.dragging = false
        -- Save position to ModData
        local player = getSpecificPlayer(0)
        if player then
            local modData = player:getModData()
            modData.ZL_Excitation_X = self:getX()
            modData.ZL_Excitation_Y = self:getY()
        end
        ZomboLust.debugLog(MODULE_NAME, "ExcitationBar: MouseUp - Dragging stopped")
        return true
    end
    return false
end

---@param x number
---@param y number
---@return boolean
function ZomboLust_ExcitationBar:onMouseUpOutside(x, y)
    return self:onMouseUp(x, y)
end

--- Helper to draw rounded rectangles (tube-like)
function ZomboLust_ExcitationBar:drawRoundedRect(x, y, width, height, alpha, r, g, b, radius)
    radius = radius or math.floor(height / 2)
    if radius > height / 2 then radius = math.floor(height / 2) end
    if width < radius * 2 then return end

    -- Main body
    self:drawRect(x + radius, y, width - (radius * 2), height, alpha, r, g, b)

    -- Left cap
    for i = 0, radius - 1 do
        local dx = radius - i
        local yOffset = math.sqrt(math.max(0, radius * radius - dx * dx))
        local capHeight = math.floor(yOffset * 2)
        if capHeight > 0 then
            self:drawRect(x + i, y + (height - capHeight) / 2, 1, capHeight, alpha, r, g, b)
        end
    end

    -- Right cap
    for i = 0, radius - 1 do
        local dx = i + 1
        local yOffset = math.sqrt(math.max(0, radius * radius - dx * dx))
        local capHeight = math.floor(yOffset * 2)
        if capHeight > 0 then
            self:drawRect(x + width - radius + i, y + (height - capHeight) / 2, 1, capHeight, alpha, r, g, b)
        end
    end
end

--- Helper to draw progress fill with rounded ends
function ZomboLust_ExcitationBar:drawFillBar(x, y, width, height, alpha, r, g, b, radius)
    if width <= 1 then return end
    radius = radius or math.floor(height / 2)
    if radius > height / 2 then radius = math.floor(height / 2) end

    -- Left rounding always
    for i = 0, math.min(radius - 1, width - 1) do
        local dx = radius - i
        local yOffset = math.sqrt(math.max(0, radius * radius - dx * dx))
        local capHeight = math.floor(yOffset * 2)
        if capHeight > 0 then
            self:drawRect(x + i, y + (height - capHeight) / 2, 1, capHeight, alpha, r, g, b)
        end
    end

    if width < radius * 2 then return end

    -- Middle body
    self:drawRect(x + radius, y, width - (radius * 2), height, alpha, r, g, b)

    -- Right rounding
    for i = 0, radius - 1 do
        local dx = i + 1
        local yOffset = math.sqrt(math.max(0, radius * radius - dx * dx))
        local capHeight = math.floor(yOffset * 2)
        if capHeight > 0 then
            self:drawRect(x + width - radius + i, y + (height - capHeight) / 2, 1, capHeight, alpha, r, g, b)
        end
    end
end

function ZomboLust_ExcitationBar:render()
    local player = getSpecificPlayer(0)
    if not player then return end

    local excitation = getExcitation(player)
    -- Show if excitation > 0, or if debugging, or if currently dragging
    if excitation <= 0 and not ZomboLust.Debug.enabled and not self.dragging then return end

    local barHeight = 20
    local barWidth = 400
    local x = 0
    local y = 0

    -- Outer White Border
    self:drawRoundedRect(x - 1, y - 1, barWidth + 2, barHeight + 2, self.currentAlpha, 1, 1, 1, 11)
    -- Black Background
    self:drawRoundedRect(x, y, barWidth, barHeight, self.currentAlpha, 0, 0, 0, 10)
    -- Grey Inner
    self:drawRoundedRect(x + 2, y + 2, barWidth - 4, barHeight - 4, self.currentAlpha * 0.8, 0.2, 0.2, 0.2, 8)

    -- Pink Fill (Rose)
    local fillWidth = ((barWidth - 4) * excitation) / 100
    if fillWidth > 0 then
        self:drawFillBar(x + 2, y + 2, fillWidth, barHeight - 4, self.currentAlpha * 0.9, 1.0, 0.4, 0.7, 8)
    end

    -- Text
    local text = getText("IGUI_ZomboLust_Excitation") .. ": " .. math.floor(excitation) .. "%"
    local font = UIFont.Small
    local textWidth = getTextManager():MeasureStringX(font, text)
    local textHeight = getTextManager():getFontHeight(font)
    self:drawText(text, x + (barWidth - textWidth) / 2, y + (barHeight - textHeight) / 2, 1, 1, 1, 1, font)
end

-- =================
-- Window Lifecycle
-- =================

local BarUI = nil
local OverlayUI = nil

local function initExcitationUI()
    if BarUI then
        BarUI:removeFromUIManager()
    end
    if OverlayUI then
        OverlayUI:removeFromUIManager()
    end

    local player = getSpecificPlayer(0)
    if not player then return end
    local modData = player:getModData()

    -- Initialize Overlay (Fullscreen)
    OverlayUI = ZomboLust_ExcitationOverlay:new()
    OverlayUI:initialise()
    OverlayUI:addToUIManager()

    -- Position bottom right by default, or load from ModData
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()
    local defaultX = screenWidth - 450
    local defaultY = screenHeight - 150

    local x = modData.ZL_Excitation_X or defaultX
    local y = modData.ZL_Excitation_Y or defaultY

    BarUI = ZomboLust_ExcitationBar:new(x, y, 400, 20)
    BarUI:initialise()
    BarUI:addToUIManager()

    ZomboLust.debugLog(MODULE_NAME, "UI initialized at x:%d, y:%d (Loaded: %s)", x, y, tostring(modData.ZL_Excitation_X ~= nil))
end

Events.OnGameStart.Add(initExcitationUI)

print("[ZomboLust] Excitation UI Initialized")
