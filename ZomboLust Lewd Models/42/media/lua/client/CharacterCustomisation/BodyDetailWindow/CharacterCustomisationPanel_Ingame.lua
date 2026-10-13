--- File: ZomboLust Lewd Models/42/media/lua/client/CharacterCustomisation/BodyDetailWindow/CharacterCustomisationPanel_Ingame.lua
--- Derivative of the character creation window but with functions for handling customisation ingame
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- =============
-- Dependencies
-- =============
require("CharacterCustomisation/BodyDetailWindow/CharacterCustomisationPanel")
local base = CharacterCustomisationPanel
--- @class CharacterCustomisationPanel_Ingame : CharacterCustomisationPanel
--- @field lockedOptionsVisible boolean
--- @field faceMenuVisible boolean
--- @field bodyDetailMenuVisible boolean
--- @field isIngame boolean
--- @field canClose boolean
--- @field hideCancelButton boolean
--- @field previewItems table
--- @field oldItems table
--- @field otherItems table
--- @field saveButton ISButton
--- @field cancelButton ISButton
--- @field onCloseSave function|nil
--- @field onCloseCancel function|nil
--- @field onClose function|nil
--- @field musclePreviewItem InventoryItem|nil
--- @field otherPreviewItems table
CharacterCustomisationPanel_Ingame = base:derive("CharacterCustomisationPanel_Ingame")

local FaceManager_Shared = require("CharacterCustomisation/FaceManager_Shared")
local SPNCC_Data = require("CharacterCustomisation/SPNCC_Data")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local table = table

--- Creates a new CharacterCustomisationPanel_Ingame instance
--- @return CharacterCustomisationPanel_Ingame
function CharacterCustomisationPanel_Ingame:new()
    local o = base.new(self)
    ---@cast o CharacterCustomisationPanel_Ingame
    o.lockedOptionsVisible = false
    o.faceMenuVisible = true
    o.bodyDetailMenuVisible = true
    o.isIngame = true
    o.canClose = false
    o.hideCancelButton = false
    o.previewItems = table.newarray()
    o.oldItems = table.newarray()
    o.otherItems = table.newarray()
    return o
end

--- Initialises the menu when it is opened for a specific player
--- @param player IsoPlayer
function CharacterCustomisationPanel_Ingame:OpenMenu(player)

    -- sendClientCommand(player, "SPNCC", "RequestSyncModData", { })

    self.backgroundColor = {r=0,g=0,b=0,a=0.8}

    self.faceMenu:setVisible(self.faceMenuVisible)
    self.bodyDetailMenu:setVisible(self.bodyDetailMenuVisible)

    --hide the muscle tickbox if player choice is disabled
    self.muscleButton:setVisible(SandboxVars.SPNCharCustom.MuscleVisuals == 3)

    --hide the body hair tickbox if player choice is disabled
    self.hairButton:setVisible(SandboxVars.SPNCharCustom.BodyHairGrowthEnabled == 3)

    --tell the menus whether to show or hide locked options
    self:setLockedOptionsVisible(self.lockedOptionsVisible)

    self:setChar(player)
    self:syncDescVisuals()
    self:FillCustomisationWindow()
    self:SetPlayerCustomisationFromData()
end

--- Renders the UI and displays status messages if certain menus are disabled
function CharacterCustomisationPanel_Ingame:render()
    base.render(self)

    --we display text telling the player that changing face or details is disabled in sandbox settings
    local valX = self.faceMenu:getX() + (self.faceMenu:getWidth()/2)
    local offset_x = valX - valX % 1

    if not self.faceMenu:isVisible() then
        local valY = self.faceMenu:getY() + (self.faceMenu:getHeight()/2)
        local offset_y = valY - valY % 1

        self:drawTextCentre(getText("UI_characreation_facedisabled"), offset_x, offset_y, 1, 1, 1, 0.5, UIFont.Medium)
    end
    if not self.bodyDetailMenu:isVisible() then
        local valY = self.bodyDetailMenu:getY() + (self.bodyDetailMenu:getHeight()/2)
        local offset_y = valY - valY % 1

        self:drawTextCentre(getText("UI_characreation_detailsdisabled"), offset_x, offset_y, 1, 1, 1, 0.5, UIFont.Medium)
    end
end

--- Replaces standard close buttons with Save and Cancel buttons
function CharacterCustomisationPanel_Ingame:createCloseButton()
    -- Close button
    local hgt = FONT_HGT_SMALL*2
    local btnpadding = hgt/4
    local yoffset = self.avatarPanel:getBottom() + btnpadding

    local btnwidth = self:getWidth()/8
    -- local btnpadding = btnwidth/4

    self.saveButton = ISButton:new(self:getWidth()-btnwidth-btnpadding, yoffset, btnwidth,hgt, getText("UI_characreation_BuildSave"), self, self.closeSave)
    self.saveButton:initialise()
    self.saveButton:instantiate()
    self.saveButton:enableAcceptColor()
    self:addChild(self.saveButton)

    self.cancelButton = ISButton:new(0+btnpadding, yoffset, btnwidth,hgt, getText("UI_Cancel"), self, self.closeCancel)
    self.cancelButton:initialise()
    self.cancelButton:instantiate()
    self.cancelButton:enableCancelColor()
    self:addChild(self.cancelButton)

    if self.hideCancelButton then 
        self.cancelButton:setVisible(false)
    end

    self:setHeight(self:getHeight() + btnpadding + hgt + btnpadding)
end

--- Closes the menu and saves changes to the player
function CharacterCustomisationPanel_Ingame:closeSave()
    self:close()
    --when we close the menu we apply the customisation to the player
    self:UpdatePlayerCustomisation()

    if self.onCloseSave then self.onCloseSave() end
end

--- Closes the menu without saving changes
function CharacterCustomisationPanel_Ingame:closeCancel()
    self:close()
    if self.onCloseCancel then self.onCloseCancel() end
end

--- Internal close function to handle visibility and speed controls
function CharacterCustomisationPanel_Ingame:close()
    self:setVisible(false)
    self:removeFromUIManager()
    if self.onClose then self.onClose() end

    if isClient() or isServer() then return end

    if UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then
        UIManager.getSpeedControls():SetCurrentGameSpeed(1)
        UIManager.setShowPausedMessage(false)
    end
end

--- Handles mouse up event, used for clicking outside to close if enabled
--- @param x number
--- @param y number
function CharacterCustomisationPanel_Ingame:onMouseUp(x,y)
    if not self.canClose then return end

    if not (0 < x and 0 < y and x < self:getWidth() and y < self:getHeight()) then self:closeCancel() end
end

--- Callback for when a body detail is selected
function CharacterCustomisationPanel_Ingame:BodyDetailSelected()
    self:UpdatePreviewCustomisation()
end

--- Creates temporary customisation items and updates the preview avatar
function CharacterCustomisationPanel_Ingame:UpdatePreviewCustomisation()
    self.previewItems = table.newarray()

    local face = self.faceMenu:getSelectedOption()

    if face ~= nil and face.name ~= "DefaultFace" then
        local item = FaceManager_Shared.CreateItem(face.id, face.texture)
        table.insert(self.previewItems, item)
    end

    local selectedBodyDetails = self.bodyDetailMenu:getSelectedOptions()
    if selectedBodyDetails ~= nil then
        for i = 1, #selectedBodyDetails do
            local v = selectedBodyDetails[i]
            local item = FaceManager_Shared.CreateItem(v.id, v.texture)
            table.insert(self.previewItems, item)
        end
    end

    if self.otherPreviewItems ~= nil then
        for i = 1, #self.otherPreviewItems do
            local item = self.otherPreviewItems[i]
            table.insert(self.previewItems, item)
        end
    end

    if self.muscleButton:isSelected() then
        table.insert(self.previewItems, self.musclePreviewItem)
    end

    --send the worn customisation items to the preview avatars
    self:setPreviewBodyDetails(self.previewItems)
end

--- Creates and equips all the customisation items to the player
function CharacterCustomisationPanel_Ingame:UpdatePlayerCustomisation()
    if not self.char then return end
    local data = {}

    data.face = self.faceMenu:getSelectedOption()
    data.bodyDetails = self.bodyDetailMenu:getSelectedOptions()
    data.muscleVisuals = self.muscleButton:isSelected()
    data.bodyHairGrowthEnabled = self.hairButton:isSelected()

    ---@cast self any
    sendClientCommand(self.char, "SPNCC", "SetCustomisation", { data = data})
end

--- Reads the player's mod data to set the selected customisation options when opening the menu
function CharacterCustomisationPanel_Ingame:SetPlayerCustomisationFromData()
    if not self.char then return end
    self.data = self.char:getModData().ZLLewdModels

    if not self.data then return end

    self.skintone = self.char:getHumanVisual():getSkinTextureIndex()

    --GET EQUIPPED CUSTOMISATION ITEMS
    self:GetPlayerCustomisationItems()

    --SELECT OPTIONS
    local list = table.newarray()
    for i = 1, #self.data.bodyDetails do
        table.insert(list, self.data.bodyDetails[i].name)
    end
    self.bodyDetailMenu:setSelectedOptions(list)
    self.faceMenu:setSelectedOption(self.data.face.name)

    self.muscleButton:setSelected(self.data.muscleVisuals)
    self.hairButton:setSelected(self.data.bodyHairGrowthEnabled)

    self.otherPreviewItems = table.newarray()
    if self.otherItems ~= nil then
        for i = 1, #self.otherItems do
            local v = self.otherItems[i]
            local item = FaceManager_Shared.CreateItem(v:getType(), v:getVisual():getBaseTexture())
            table.insert(self.otherPreviewItems, item)
        end
    end

    self.musclePreviewItem = self:CreatePreviewMuscleItem()

    self:UpdatePreviewCustomisation()
end

--- Grabs the player's body hair and other details to copy them onto the preview
function CharacterCustomisationPanel_Ingame:GetPlayerCustomisationItems()
    if not self.char then return end
    self.otherItems = table.newarray()
    --STUBBLE HEAD
    local item = FaceManager_Shared.GetWornItem(self.char, SPNCC.ItemBodyLocation.StubbleHead)
    table.insert(self.otherItems, item)

    --STUBBLE BEARD
    local item = FaceManager_Shared.GetWornItem(self.char, SPNCC.ItemBodyLocation.StubbleBeard)
    table.insert(self.otherItems, item)

    --BODY HAIR
    local item = FaceManager_Shared.GetWornItem(self.char, SPNCC.ItemBodyLocation.BodyHair)
    table.insert(self.otherItems, item)
end

--- Creates a preview item for muscle visuals based on player strength
--- @return InventoryItem|nil
function CharacterCustomisationPanel_Ingame:CreatePreviewMuscleItem()
    if not self.char then return nil end
    local muscleLevel = FaceManager_Shared.GetMuscleLevel(self.char:getPerkLevel(Perks.Strength))

    if muscleLevel <= 0 then return nil end

    local id = self.char:isFemale() and SPNCC_Data.Muscle[2] or SPNCC_Data.Muscle[1]

    local textureOffset = 0
    if muscleLevel == 2 then textureOffset = 5 end
    local texture = self.char:getHumanVisual():getSkinTextureIndex() + textureOffset

    local item = FaceManager_Shared.CreateItem(id, texture)

    return item
end

--- Fills the customisation window with face and body detail options
function CharacterCustomisationPanel_Ingame:FillCustomisationWindow()
    if not self.char then return end
    self:setFaceOptions(SPNCC_Data.GetFacesForCharacter(self.char))
    self:setBodyDetailOptions(SPNCC_Data.GetBodyDetailsForCharacter(self.char))
end
