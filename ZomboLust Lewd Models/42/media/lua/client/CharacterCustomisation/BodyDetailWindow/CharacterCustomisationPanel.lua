--- File: ZomboLust Lewd Models/42/media/lua/client/CharacterCustomisation/BodyDetailWindow/CharacterCustomisationPanel.lua
--- This is the actual menu element.
--- By being a separate UI element it can be implemented in both the character creation menu and in-game hair options.
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- Module name for logging
--- @type string
local MODULE_NAME = "CharacterCustomisationPanel"

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

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
-- local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
-- local header_height = FONT_HGT_SMALL + 14
-- local BUTTON_HGT = FONT_HGT_SMALL + 15

local icons = {
    iso_On = getTexture("media/textures/UI_Iso_On.png"),
    iso_Off = getTexture("media/textures/UI_Iso_Off.png"),

    zoom_Out = getTexture("media/textures/UI_Zoom_Out.png"),
    zoom_In = getTexture("media/textures/UI_Zoom_In.png"),

    hair_On = getTexture("media/textures/UI_Hair_On.png"),
    hair_Off = getTexture("media/textures/UI_Hair_Off.png"),

    muscle_On = getTexture("media/textures/UI_Muscle_On.png"),
    muscle_Off = getTexture("media/textures/UI_Muscle_Off.png"),
}

local base = ISPanelJoypad
---@class CharacterCustomisationPanel : ISPanelJoypad
---@field desc SurvivorDesc|nil
---@field char IsoPlayer|nil
---@field previewDesc SurvivorDesc|nil
---@field isIngame boolean
---@field avatarPanel ISUI3DModel
---@field muscleButton ISButtonImage
---@field hairButton ISButtonImage
---@field isoButton ISButtonImage
---@field zoomOutButton ISButton
---@field zoomInButton ISButton
---@field zoomLevel number
---@field faceMenu BodyDetailMenuPanel
---@field bodyDetailMenu BodyDetailMenuPanel
---@field saveButton ISButton
---@field onBodyDetailSelected function|nil
---@field onClose function|nil
---@field onCloseSave function|nil
---@field onCloseCancel function|nil
CharacterCustomisationPanel = base:derive("CharacterCustomisationPanel")

--- Creates a new instance of CharacterCustomisationPanel
--- @return CharacterCustomisationPanel
function CharacterCustomisationPanel:new()
    local o = base.new(self, 0, 0, 0, 0)
    ---@cast o CharacterCustomisationPanel
    o.desc = nil
    o.char = nil
    o.previewDesc = nil
    o.isIngame = false
    return o
end

-- function CharacterCustomisationPanel:render()
-- 	base.render(self)

-- 	-- local height = getTextManager():MeasureFont(self.font);

-- 	-- self:drawText(getText("UI_characreation_charapanel"), 75, height/2, 1, 1, 1, 1, UIFont.Title)
-- end

--- Initialises the panel and its children
function CharacterCustomisationPanel:initialise()
    -- we create a dummy survivor for the previews
---@diagnostic disable-next-line: param-type-mismatch
    self.previewDesc = SurvivorFactory:CreateSurvivor()
    self.previewDesc:setForename("Preview")
    self.previewDesc:setSurname("McPreviewPants")

    local screen_width = getCore():getScreenWidth()
    local screen_height = getCore():getScreenHeight()

    -- local width_modifier = screen_width / 1920
    -- local height_modifier = screen_height / 1080

    --cap the menu sizes at 1080p because it breaks ultra widescreen
    local valW = screen_width / 1920
    local width_modifier = valW < 1 and valW or 1
    local valH = screen_height / 1080
    local height_modifier = valH < 1 and valH or 1

    local avatar_size = 150 * height_modifier
    local tickbox_size = 32
    local tickbox_padding = 12

    local comboHgt = FONT_HGT_SMALL + 3 * 2

    local avatarPanel_header = comboHgt*2
    local avatarPanel_width = 300 * width_modifier
    local avatarPanel_height = (600 + comboHgt) * height_modifier

    local avatarPanel_aspectratio = avatarPanel_width/avatarPanel_height

    ---@type number
    local offset_x = 0
    ---@type number
    local offset_y = 0

    --preview avatar
    self.avatarPanel = ISUI3DModel:new(offset_x, offset_y + avatarPanel_header, avatarPanel_width, avatarPanel_height)
    ---@cast self.avatarPanel any
    self.avatarPanel.backgroundColor = {r=0, g=0, b=0, a=0}
    self.avatarPanel.borderColor = {r=1, g=1, b=1, a=0}
    self:addChild(self.avatarPanel)
    self.avatarPanel:setDirection(IsoDirections.S)
    self.avatarPanel:setState("idle")
    self.avatarPanel:setIsometric(false)
    self.avatarPanel:setDoRandomExtAnimations(false)

    --TICKBOXES
    offset_x = 0 + tickbox_padding
    offset_y = 0 + tickbox_padding

    --muscle tickbox
    self.muscleButton = ISButtonImage:new(offset_x, offset_y, tickbox_size, tickbox_size, icons.muscle_On, icons.muscle_Off, self, self.BodyDetailSelected)
    self.muscleButton:initialise()
    self.muscleButton:instantiate()
    self:addChild(self.muscleButton)
    self.muscleButton.tooltip = getText("Tooltip_Muscle")

    offset_x = offset_x + tickbox_padding + tickbox_size

    --body hair tickbox
    self.hairButton = ISButtonImage:new(offset_x, offset_y, tickbox_size, tickbox_size, icons.hair_On, icons.hair_Off, self, self.BodyDetailSelected)
    self.hairButton:initialise()
    self.hairButton:instantiate()
    self:addChild(self.hairButton)
    self.hairButton.tooltip = getText("Tooltip_BodyHairGrowth")

    --VIEW BUTTONS

    local valRX = self.avatarPanel:getRight() - tickbox_padding - (tickbox_size/2)
    offset_x = valRX - valRX % 1
    local valBY = self.avatarPanel:getBottom() - tickbox_padding
    offset_y = valBY - valBY % 1

    --iso button
    self.isoButton = ISButtonImage:new(offset_x, offset_y, tickbox_size, tickbox_size, icons.iso_On, icons.iso_Off, self, self.setIso)
    self.isoButton:initialise()
    self.isoButton:instantiate()
    self:addChild(self.isoButton)
    self.isoButton.useSelectedColor = false

    --zoom buttons
    local valZY = offset_y - tickbox_padding - tickbox_size
    offset_y = valZY - valZY % 1

    self.zoomOutButton = ISButton:new(offset_x, offset_y, tickbox_size, tickbox_size, "", self, self.onZoomButton)
    self.zoomOutButton.internal = "OUT"
    self.zoomOutButton:initialise()
    self.zoomOutButton:instantiate()
    self.zoomOutButton:setImage(icons.zoom_Out)
    self:addChild(self.zoomOutButton)

    local valZIY = offset_y - tickbox_padding - tickbox_size
    offset_y = valZIY - valZIY % 1

    self.zoomInButton = ISButton:new(offset_x, offset_y, tickbox_size, tickbox_size, "", self, self.onZoomButton)
    self.zoomInButton.internal = "IN"
    self.zoomInButton:initialise()
    self.zoomInButton:instantiate()
    self.zoomInButton:setImage(icons.zoom_In)
    self:addChild(self.zoomInButton)

    self.zoomLevel = 0
    self:setAvatarZoom()

    --MENUS 

    --face menu

    offset_x = self.avatarPanel:getRight()
    offset_y = 0

    self.faceMenu = BodyDetailMenuPanel:new(offset_x, offset_y, avatar_size, avatar_size, 2, 6, 3)
    self:addChild(self.faceMenu)
    self.faceMenu.onSelect = function(info)

        self:BodyDetailSelected()	-- an option has been pressed so we update the character body details

    end
    self.faceMenu:initialise()
    self.faceMenu.label = getText("UI_characreation_face")
    self.faceMenu.tooltipEnabled = true
    self.faceMenu.isFacePanel = true

    local valFB = self.faceMenu:getBottom()
    offset_y = valFB - valFB % 1

    --body detail menu
    self.bodyDetailMenu = BodyDetailMenuPanel:new(offset_x, offset_y, avatar_size, avatar_size, 2, 6, 3)
    self:addChild(self.bodyDetailMenu)
    self.bodyDetailMenu.onSelect = function(info)

        self:BodyDetailSelected()	-- an option has been pressed so we update the character body details

    end
    self.bodyDetailMenu:initialise()
    self.bodyDetailMenu.label = getText("UI_characreation_bodydetail")
    self.bodyDetailMenu.tooltipEnabled = true
    self.bodyDetailMenu.isExclusive = false

    self:setHeight(self.bodyDetailMenu:getHeight() + self.faceMenu:getHeight())

    self.avatarPanel:setHeight(self:getHeight() - avatarPanel_header)
    self.avatarPanel:setWidth(self.avatarPanel:getHeight() * avatarPanel_aspectratio)

    local valAR = self.avatarPanel:getRight()
    offset_x = valAR - valAR % 1
    self.faceMenu:setX(offset_x)
    self.bodyDetailMenu:setX(offset_x)

    self:setWidth(self.bodyDetailMenu:getWidth() + self.avatarPanel:getWidth())

    -- we make this a function because the ingame menu needs to replace it with a save and cancel button
    self:createCloseButton()

    self.backgroundColor = {r=0,g=0,b=0,a=1}

    --set visuals
    self:setAvatarDescs()
end

--- Creates the close button for the panel
function CharacterCustomisationPanel:createCloseButton()
    -- Close button
    local hgt = FONT_HGT_SMALL*2
    local btnpadding = hgt/4
    local yoffset = self.bodyDetailMenu:getBottom() + btnpadding

    local btnwidth = self:getWidth() - (btnpadding*2)

    --move this to the middle of the menu?
    self.saveButton = ISButton:new(btnpadding, yoffset, btnwidth,hgt, getText("UI_Close"), self, self.close)
    self.saveButton:initialise()
    self.saveButton:instantiate()
    self.saveButton:enableAcceptColor()
    self:addChild(self.saveButton)

    self:setHeight(self:getHeight() + btnpadding + hgt + btnpadding)
end

--- Toggles isometric view on the avatar panel
function CharacterCustomisationPanel:setIso()
    self.avatarPanel:setIsometric(self.isoButton:isSelected())	--invert the selection
end

local ZoomSettings = {
    maxZoom = 18,
    maxY = -0.875,

    minZoom = 0,
    minY = -0.5,

    zoomlevels = 4,
}
local zoom_step = (ZoomSettings.maxZoom - ZoomSettings.minZoom)/ZoomSettings.zoomlevels
local y_step = (ZoomSettings.maxY - ZoomSettings.minY)/ZoomSettings.zoomlevels

--- Handles the zoom button click
--- @param button ISButton
--- @param x number
--- @param y number
function CharacterCustomisationPanel:onZoomButton(button,x,y)
    local oldZoomLevel = self.zoomLevel
    local newZoomLevel = oldZoomLevel

    if button.internal == "IN" and oldZoomLevel ~= ZoomSettings.zoomlevels then
        newZoomLevel = oldZoomLevel + 1
    elseif button.internal == "OUT" and oldZoomLevel ~= 0 then 
        newZoomLevel = oldZoomLevel - 1
    end

    if oldZoomLevel == newZoomLevel then return end
    self.zoomLevel = newZoomLevel
    self:setAvatarZoom()
end

--- Sets the zoom level on the avatar panel
function CharacterCustomisationPanel:setAvatarZoom()
    local newZoom = ZoomSettings.minZoom + (zoom_step*self.zoomLevel)
    local newY = ZoomSettings.minY + (y_step*self.zoomLevel)

    self.avatarPanel:setYOffset(newY)
    self.avatarPanel:setZoom(newZoom)
end

--- Syncs the visuals from the source description or player to the preview description
function CharacterCustomisationPanel:syncDescVisuals()
    if not self.previewDesc then return end
    ZLLewdModels.debugLog(MODULE_NAME, "syncDescVisuals: Syncing visuals to preview character")
    local previewVisual = self.previewDesc:getHumanVisual()

    local visual = nil
    local isFemale = false
    if self.desc then
        visual = self.desc:getHumanVisual()
        isFemale = self.desc:isFemale()
    elseif self.char then
        visual = self.char:getHumanVisual()
        isFemale = self.char:isFemale()
    else
        ZLLewdModels.warningLog(MODULE_NAME, "syncDescVisuals: No source description or character found")
        return
    end

    local skinTextureIndex = visual:getSkinTextureIndex()
    local skinColor = visual:getSkinColor()
    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "syncDescVisuals: Source SkinTextureIndex=" .. tostring(skinTextureIndex))
    end

    self.previewDesc:setFemale(isFemale)
    previewVisual:setSkinTextureIndex(skinTextureIndex)
    previewVisual:setSkinColor(skinColor)

    previewVisual:setBeardModel(visual:getBeardModel())
    previewVisual:setBeardColor(visual:getBeardColor())
    previewVisual:setHairModel(visual:getHairModel())
    previewVisual:setHairColor(visual:getHairColor())

    -- Sync body hair and other visual traits if possible in B42
    if previewVisual.setBodyHairIndex and visual.getBodyHairIndex then
        previewVisual:setBodyHairIndex(visual:getBodyHairIndex())
    end
end

--- Sets the body details on the preview character
--- @param wornCustomisationItems InventoryItem[]
function CharacterCustomisationPanel:setPreviewBodyDetails(wornCustomisationItems)
    if not self.previewDesc then return end

    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "setPreviewBodyDetails: Applying " .. tostring(#wornCustomisationItems) .. " items to preview character")
    end
    self:syncDescVisuals() -- Ensure skin color is synced from the main character

    local wornItems = self.previewDesc:getWornItems()

    wornItems:clear()

    --BODY DETAILS
    for i = 1, #wornCustomisationItems, 1 do
        local v = wornCustomisationItems[i]
        if dbg() then
            ZLLewdModels.debugLog(MODULE_NAME, "setPreviewBodyDetails: Setting item " .. tostring(v:getFullType()) .. " at " .. tostring(v:getBodyLocation()))
        end
        self.previewDesc:setWornItem(v:getBodyLocation(), v)
    end

    --we need to apply the new preview visual to the avatars
    self:setAvatarDescs()
end

--- Prepares the preview visuals and applies them to the avatars
function CharacterCustomisationPanel:setAvatarDescs()
    if not self.previewDesc then return end
    --we set the main avatar panel first so that it shows all of the customisation
    if self.avatarPanel then
        self.avatarPanel:setSurvivorDesc(self.previewDesc)
    end

    --Here we need to make sure that the preview avatars only show the items that they need to preview
    --face should show in the previews

    --get the face
    local faceLocation = SPNCC.ItemBodyLocation.Face
    local face = self.faceMenu:getSelectedOption()
    if face and face.bodylocation then
        faceLocation = face.bodylocation
    end
    local faceItem = self.previewDesc:getWornItem(faceLocation)
    --remove all other items
    self.previewDesc:getWornItems():clear()
    --readd the face
    if faceItem then self.previewDesc:setWornItem(faceLocation, faceItem) end

    --we need to refresh the customisation on the preview avatars
    self:applyVisual()
end

--- Sends the preview visuals to all sub-panels
function CharacterCustomisationPanel:applyVisual()
    if not self.previewDesc then return end
    if self.faceMenu then
        self.faceMenu:setDesc(self.previewDesc)
        self.faceMenu:applyVisual()
    end
    if self.bodyDetailMenu then
        self.bodyDetailMenu:setDesc(self.previewDesc)
        self.bodyDetailMenu:applyVisual()
    end
end

--- Refreshes the options in the sub-menus
function CharacterCustomisationPanel:refreshOptions()
    if self.bodyDetailMenu then 
        self.bodyDetailMenu:refreshOptions()
    end
    if self.faceMenu then 
        self.faceMenu:refreshOptions()
    end
end

--- Sets the selected body details in the menu
--- @param names string[]
function CharacterCustomisationPanel:setSelectedBodyDetails(names)
    if not self.bodyDetailMenu then return end
    self.bodyDetailMenu:setSelectedOptions(names)
end

--- Clears the selected body details in the menu
function CharacterCustomisationPanel:clearSelectedBodyDetails()
    if not self.bodyDetailMenu then return end
    self.bodyDetailMenu:setSelectedOptions({})
end

--- Sets the selected face in the menu
--- @param name string
function CharacterCustomisationPanel:setSelectedFace(name)
    if not self.faceMenu then return end
    self.faceMenu:setSelectedOption(name)
end

--- Sets the face options in the menu
--- @param list table
function CharacterCustomisationPanel:setFaceOptions(list)
    if not self.faceMenu then return end
    self.faceMenu:setOptions(list)
end

--- Sets the body detail options in the menu
--- @param list table
function CharacterCustomisationPanel:setBodyDetailOptions(list)
    if not self.bodyDetailMenu then return end
    self.bodyDetailMenu:setOptions(list)
end

--- Sets the source SurvivorDesc
--- @param desc SurvivorDesc
function CharacterCustomisationPanel:setDesc(desc)
    self.desc = desc
    self.char = nil
end

--- Sets the source IsoPlayer
--- @param desc IsoPlayer
function CharacterCustomisationPanel:setChar(desc)
    self.desc = nil
    self.char = desc
end

--- Callback triggered when a body detail is selected
function CharacterCustomisationPanel:BodyDetailSelected()
    if self.onBodyDetailSelected then self.onBodyDetailSelected() end
end

--- Sets the visibility of locked options in the menus
--- @param visible boolean
function CharacterCustomisationPanel:setLockedOptionsVisible(visible)
    self.faceMenu.lockedOptionsVisible = visible
    self.bodyDetailMenu.lockedOptionsVisible = visible
end

-- ##########
-- # Cursor #
-- ##########

--- Handles mouse up events
--- @param x number
--- @param y number
function CharacterCustomisationPanel:onMouseUp(x,y)
    base.onMouseUp(self,x,y)
    if not (0 < x and 0 < y and x < self:getWidth() and y < self:getHeight()) then self:close() end
end

--- Closes the panel
function CharacterCustomisationPanel:close()
    if self.onClose then self.onClose() end
end

--- Closes the panel and saves changes
function CharacterCustomisationPanel:closeSave()
    self:close()
    if self.onCloseSave then self.onCloseSave() end
end

function CharacterCustomisationPanel:closeCancel()
    self:close()
    if self.onCloseCancel then self.onCloseCancel() end
end

-- ##############
-- # CONTROLLER #
-- ##############

function CharacterCustomisationPanel:setJoypadFocused(focused, joypadData)
    --self.bodyDetailMenu:setJoypadFocused(focused, joypadData)
end
