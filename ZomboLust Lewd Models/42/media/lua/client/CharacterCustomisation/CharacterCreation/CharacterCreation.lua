--- File: ZomboLust Lewd Models/42/media/lua/client/CharacterCustomisation/CharacterCreation/CharacterCreation.lua
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- =============
-- Dependencies
-- =============
local SPNCC_Data = require("CharacterCustomisation/SPNCC_Data")
require("CharacterCustomisation/CharacterCreation/CC_UpdateCharacterPreview")

-- Module name for logging
--- @type string
local MODULE_NAME = "CharacterCreation"

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
local string = string
local table  = table

--- Constants
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local BUTTON_HGT = FONT_HGT_SMALL + 6

--- Refreshes the customisation window when gender or skintone changes
--- @return void
function CharacterCreationMain:refreshCustomisationWindow()
    local mainScreen = MainScreen.instance
    if not self.characterCustomisationPanel or not mainScreen then return end
    ZLLewdModels.debugLog(MODULE_NAME, "refreshCustomisationWindow: Start")

    local desc = mainScreen.desc
    local skinIndex = desc:getHumanVisual():getSkinTextureIndex()
    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "refreshCustomisationWindow: Current SkinTextureIndex=" .. tostring(skinIndex))
    end

    self.characterCustomisationPanel:syncDescVisuals()
    --tell the menus to show or hide locked options
    self.characterCustomisationPanel:setLockedOptionsVisible(isDebugEnabled())
    -- self.characterCustomisationPanel:refreshOptions()

    self:spn_populate_customisation_window()

    self:spn_update_character_customisation()
    ZLLewdModels.debugLog(MODULE_NAME, "refreshCustomisationWindow: End")
end

--- Fills all combo boxes in the customisation window
--- @return void
function CharacterCreationMain:spn_populate_customisation_window()
    local mainScreen = MainScreen.instance
    if not mainScreen then return end
    local desc = mainScreen.desc
    ZLLewdModels.debugLog(MODULE_NAME, "spn_populate_customisation_window: Populating menus")

    local list = SPNCC_Data.GetFacesForCharacter(desc)
    self.characterCustomisationPanel:setFaceOptions(list)

    list = SPNCC_Data.GetBodyDetailsForCharacter(desc)
    self.characterCustomisationPanel:setBodyDetailOptions(list)
end

--- Creates the character customisation window and the button to open it
--- @return void
function CharacterCreationMain:createCharacterCustomisationWindow()
    local comboHgt = FONT_HGT_SMALL + 3 * 2

    --create the character customisation window
    self.characterCustomisationPanel = CharacterCustomisationPanel:new()

    self.characterCustomisationPanel.onBodyDetailSelected = function(info)
        -- a body detail has been clicked so we need to refresh the body detail visuals
        self:spn_update_character_customisation()
    end
    self.characterCustomisationPanel:initialise()

    local mainScreen = MainScreen.instance
    if mainScreen then
        self.characterCustomisationPanel:setDesc(mainScreen.desc)
    end

    self.characterCustomisationPanel.onClose = function()
        self:removeChild(self.characterCustomisationPanel)
        self.characterCustomisationPanel:setCapture(false)
        local customisationButton = self.customisationButton
        ---@cast customisationButton any
        customisationButton.expanded = false
    end
end

--- Shows the customisation menu when the button is clicked
--- @return void
function CharacterCreationMain:spn_showCustomisationMenu()
    if not self.characterCustomisationPanel then return end

    local customisationButton = self.customisationButton
    ---@cast customisationButton any
    customisationButton.expanded = true

    --hide the muscle tickbox if player choice is disabled
    ZLLewdModels.debugLog(MODULE_NAME, "spn_showCustomisationMenu: MuscleVisuals=" .. tostring(SandboxVars.SPNCharCustom.MuscleVisuals) .. " -> muscleButton visible=" .. tostring(SandboxVars.SPNCharCustom.MuscleVisuals == 3))
    self.characterCustomisationPanel.muscleButton:setVisible(SandboxVars.SPNCharCustom.MuscleVisuals == 3)

    self.characterCustomisationPanel:syncDescVisuals()
    self.characterCustomisationPanel:setAvatarDescs()
    self.characterCustomisationPanel:setPreviewBodyDetails(self.wornCustomisationItems)

    self:removeChild(self.characterCustomisationPanel)
    self:addChild(self.characterCustomisationPanel)

    local width = self:getWidth()
    local height = self:getHeight()
    self.characterCustomisationPanel:setX( (width/2) - (self.characterCustomisationPanel:getWidth()/2) )
    self.characterCustomisationPanel:setY( (height/2) - (self.characterCustomisationPanel:getHeight()/2) )

    self.characterCustomisationPanel:setCapture(true)
end

-- --------------------------------------------------
--   ADD CUSTOMISATION BUTTON AT THE VERY BOTTOM
-- --------------------------------------------------
local originalCreateBeardTypeBtn = CharacterCreationMain.createBeardTypeBtn
--- Extends vanilla CharacterCreationMain:createBeardTypeBtn to add ZLLM button at the end
--- @return void
function CharacterCreationMain:createBeardTypeBtn()
    originalCreateBeardTypeBtn(self)

    -- Add a small space before our section
    self.yOffset = self.yOffset + 10

    -- Add "Body" (Corps) header to match vanilla style
    local lbl = ISLabel:new(0, self.yOffset, FONT_HGT_MEDIUM, getText("UI_characreation_body"), 1, 1, 1, 1, UIFont.Medium, true);
    lbl:initialise();
    lbl:instantiate();
    self.characterPanel:addChild(lbl);
    table.insert(self.characterPanel.reposTable, lbl)

    local rect = ISRect:new(0, self.yOffset + FONT_HGT_MEDIUM + 5, 0, 1, 1, 0.3, 0.3, 0.3);
    rect:setAnchorRight(false);
    rect:initialise();
    rect:instantiate();
    self.characterPanel:addChild(rect);
    table.insert(self.characterPanel.dividerResizeTable, rect)

    self.yOffset = self.yOffset + FONT_HGT_MEDIUM + 15;

    -- Create the "Personalize" button
    local customisationButtonWidth = 300 -- Standard width for controls

    self.customisationButton = ISButton:new(0, self.yOffset, customisationButtonWidth, BUTTON_HGT, getText("UI_characreation_charapanel"), self, CharacterCreationMain.spn_showCustomisationMenu)
    self.customisationButton:initialise()
    self.customisationButton:instantiate()
    local customisationButton = self.customisationButton
    ---@cast customisationButton any
    customisationButton.isButton = nil -- NOTE: We don't want this button to be picked up by the vanilla joypad functions
    customisationButton.expanded = false
    customisationButton.attachedMenu = self.characterCustomisationPanel
    self.characterPanel:addChild(self.customisationButton)
    table.insert(self.characterPanel.repos3Table, self.customisationButton)
    table.insert(self.characterPanel.comboResizeTable, self.customisationButton)

    self.yOffset = self.yOffset + BUTTON_HGT + 20
end

-- -----------------------
--   ADD BUTTONS TO MENU
-- -----------------------

-- No need to override positionRelativeToScrollBar if we use vanilla tables properly

local originalCharacterCreationMainCreate = CharacterCreationMain.create
---@diagnostic disable-next-line: duplicate-set-field
--- Extends vanilla CharacterCreationMain.create to add customisation window
--- @return void
function CharacterCreationMain.create(self)
    originalCharacterCreationMainCreate(self)

    --Create char custom window
    self:createCharacterCustomisationWindow()

    --Fill menus with options
    self:spn_populate_customisation_window()

    self:spn_randomise_face()
    -- self:spn_randomise_details()
    self:spn_update_character_customisation()
end

--- Extends vanilla CharacterCreationMain:setVisible to refresh customisation window
local originalCharacterCreationMainSetVisible = CharacterCreationMain.setVisible
---@diagnostic disable-next-line: duplicate-set-field
--- @param bVisible boolean
--- @param joypadData table|nil
--- @return void
function CharacterCreationMain:setVisible(bVisible, joypadData)
    originalCharacterCreationMainSetVisible(self, bVisible, joypadData)

    local mainScreen = MainScreen.instance
    if bVisible and mainScreen and mainScreen.desc then
        if self.characterCustomisationPanel then
            --set visible muscles when sandbox settings are changed
            ZLLewdModels.debugLog(MODULE_NAME, "setVisible: MuscleVisuals=" .. tostring(SandboxVars.SPNCharCustom.MuscleVisuals) .. " -> muscleButton selected=" .. tostring(SandboxVars.SPNCharCustom.MuscleVisuals ~= 2))
            self.characterCustomisationPanel.muscleButton:setSelected(SandboxVars.SPNCharCustom.MuscleVisuals ~= 2)
        end
        self:refreshCustomisationWindow()
    end
end

-- --------------------------------------------------
--   PREVENT ZLLM LOCATIONS FROM SHOWING IN CLOTHING PANEL
-- --------------------------------------------------
local originalCreateClothingComboDebug = CharacterCreationMain.createClothingComboDebug
--- Extends vanilla CharacterCreationMain:createClothingComboDebug to hide ZLLM locations
--- @param bodyLocation string
--- @return void
function CharacterCreationMain:createClothingComboDebug(bodyLocation)
    if bodyLocation then
        local locLower = string.lower(bodyLocation)
        if string.find(locLower, "spncc") or string.find(locLower, "zllewdmodels") then
            if dbg() then
                ZLLewdModels.debugLog(MODULE_NAME, "createClothingComboDebug: Skipping ZLLM location " .. tostring(bodyLocation))
            end
            return
        end
    end
    originalCreateClothingComboDebug(self, bodyLocation)
end
