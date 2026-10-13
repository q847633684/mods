-- File: ZomboLust/42/media/lua/client/UI/ZomboLust_Sidebar.lua
-- Adds a custom button system to the game's sidebar
-- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_Sidebar.lua loaded (Modular Version)")

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local table = table
local pairs = pairs
local math  = math

-- Module name for logging
--- @type string
local MODULE_NAME = "Sidebar"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

-- ==============================
-- Modular Sidebar Registry
-- ==============================

ZomboLust.Sidebar = {
    Buttons = {}
}

--- Registers a new button for the sidebar
--- @param config {id:string, iconName:string, tooltip:string, onClick:function, isActive:function, condition:function|nil}
function ZomboLust.registerSidebarButton(config)
    table.insert(ZomboLust.Sidebar.Buttons, config)
    ZomboLust.debugLog(MODULE_NAME, "Registered sidebar button: %s", config.id)
end

-- ==================================
-- Utility: Get Sidebar Texture Size
-- ==================================

local function getTextureWidth()
    local core = getCore()
    if not core then return 48 end
    local size = core:getOptionSidebarSize()
    if size == 6 then size = core:getOptionFontSizeReal() - 1 end

    if size == 2 then return 64
    elseif size == 3 then return 80
    elseif size == 4 then return 96
    elseif size == 5 then return 128
    end
    return 48
end

-- =======================
-- Hooking ISEquippedItem
-- =======================

---@class (partial) ISEquippedItem
---@field zl_buttons table<string, ISButton>
---@field zl_icons table<string, {on:any, off:any}>

-- Store original methods
local original_ISEquippedItem_new = ISEquippedItem.new
local original_ISEquippedItem_initialise = ISEquippedItem.initialise
local original_ISEquippedItem_prerender = ISEquippedItem.prerender
local original_ISEquippedItem_onOptionMouseDown = ISEquippedItem.onOptionMouseDown

--- Overrides new to load ZomboLust textures
function ISEquippedItem:new(x, y, width, height, chr)
    local o = original_ISEquippedItem_new(self, x, y, width, height, chr)
    o.zl_buttons = {}
    o.zl_icons = {}

    local tw = getTextureWidth()
    local sidebarButtons = ZomboLust.Sidebar.Buttons
    for i = 1, #sidebarButtons do
        local cfg = sidebarButtons[i]
        if not cfg then break end
        o.zl_icons[cfg.id] = {
            on = getTexture("media/ui/Sidebar/" .. tw .. "/" .. cfg.iconName .. "_On_" .. tw .. ".png"),
            off = getTexture("media/ui/Sidebar/" .. tw .. "/" .. cfg.iconName .. "_Off_" .. tw .. ".png")
        }
    end

    return o
end

--- Overrides initialise to create the ZomboLust button
function ISEquippedItem:initialise()
    original_ISEquippedItem_initialise(self)

    -- Only add to player 0 -- getIndex() is the non-deprecated replacement for the old getPlayerNum()
    if self.chr:getIndex() ~= 0 then return end

    local tw = getTextureWidth()
    local th = tw * 0.75
    local spacing = 15
    local sidebarButtons = ZomboLust.Sidebar.Buttons

    -- Calculate Y position: find the bottom of the last visible button
    -- In Build 42, we search through the children to find the lowest button
    for i = 1, #sidebarButtons do
        local cfg = sidebarButtons[i]
        if not cfg then break end
        -- Check custom condition (e.g. only for females)
        if not cfg.condition or cfg.condition(self.chr) then
            local lastY = 0.0
            for _, child in pairs(self:getChildren()) do
                if child.internal then lastY = math.max(lastY, child:getBottom()) end
            end

            local y = math.floor(lastY) + spacing
            local btn = ISButton:new(0, y, tw, th, "", self, self.onOptionMouseDown)

            -- Create the ZomboLust button
            btn:setImage(self.zl_icons[cfg.id].off)
            btn.internal = cfg.id
            btn:initialise()
            btn:instantiate()
            btn:setDisplayBackground(false)
            btn:ignoreWidthChange()
            btn:ignoreHeightChange()
            self:addChild(btn)

            -- Add tooltip
            self:addMouseOverToolTipItem(btn, getText(cfg.tooltip))
            self.zl_buttons[cfg.id] = btn
        end
    end

    -- Resize sidebar to fit new button
    self:shrinkWrap()
end

--- Overrides onOptionMouseDown to handle the ZomboLust button click
function ISEquippedItem:onOptionMouseDown(button, x, y)
    local sidebarButtons = ZomboLust.Sidebar.Buttons
    for i = 1, #sidebarButtons do
        local cfg = sidebarButtons[i]
        if not cfg then break end
        if button.internal == cfg.id then
            if cfg.onClick then cfg.onClick() end
            return
        end
    end
    original_ISEquippedItem_onOptionMouseDown(self, button, x, y)
end

--- Overrides prerender to update the button icon
function ISEquippedItem:prerender()
    original_ISEquippedItem_prerender(self)

    local sidebarButtons = ZomboLust.Sidebar.Buttons
    for i = 1, #sidebarButtons do
        local cfg = sidebarButtons[i]
        if not cfg then break end
        local btn = self.zl_buttons[cfg.id]
        if btn then
            if cfg.isActive and cfg.isActive() then
                btn:setImage(self.zl_icons[cfg.id].on)
            else
                btn:setImage(self.zl_icons[cfg.id].off)
            end
        end
    end
end

-- ==============================
-- Register Core ZomboLust Button
-- ==============================

ZomboLust.registerSidebarButton({
    id = "ZOMBOLUST",
    iconName = "ZomboLust",
    tooltip = "IGUI_ZomboLust_Sidebar_Tooltip",
    onClick = function()
        if ZomboLust.UI then
            ZomboLust.UI:setVisible(not ZomboLust.UI:getIsVisible())
        end
    end,
    isActive = function()
        return ZomboLust.UI and ZomboLust.UI:getIsVisible()
    end
})
