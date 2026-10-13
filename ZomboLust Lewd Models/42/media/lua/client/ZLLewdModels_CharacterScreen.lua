--- File: ZomboLust Lewd Models/42/media/lua/client/ZLLewdModels_CharacterScreen.lua
--- Adds body hair shaving and character customisation options to the character info screen
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust Lewd Models LOADING] ZLLewdModels_CharacterScreen.lua (Merged with Spongie) loaded")

-- =============
-- Dependencies
-- =============
require "XpSystem/ISUI/ISCharacterScreen"

-- Module name for logging
--- @type string
local MODULE_NAME = "CharacterScreen"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZLLewdModels.isDebug in ZomboLustLewdModels_Main.lua).
--- Calls with cheap/no arguments use ZLLewdModels.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZLLewdModels.isDebug(MODULE_NAME)
end

---@class ISCharacterScreen
---@field hairStyle string
---@field beardStyle string
---@field bodyHairButton ISButton

local zlSharedData = require("ZLLewdModels_SharedData")
--- @type ZLLewdModelsManageBody
local manageBody = require("ZLLewdModels_ManageBody")
--- @type zlClothingChecks
local zlClothingChecks = require("ZLLewdModels_ClothingChecks")
require "TimedActions/ZLLewdModels_ShaveAction"

--- Constants
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
--- @type number
local UI_BORDER_SPACING = 10
--- @type number
local BUTTON_HGT = FONT_HGT_SMALL + 6
local CUSTOMISATION_UPDATE_FRAME_COUNT = 120

-- ==================
-- Utility Functions
-- ==================

--- Forces the player to unequip clothes covering a specific body part (ZLLM)
--- @param player IsoPlayer -- The player character to undress
--- @param bodyPartToShave string -- "Legs", "Chest" (Armpits) or "Pubic"
local function undress(player, bodyPartToShave)
    ZLLewdModels.debugLog(MODULE_NAME, "Undressing player for: %s", bodyPartToShave)

    local area = bodyPartToShave
    if area == "Chest" then area = "Armpits" end

    local items = zlClothingChecks.getCoveringItems(player, area)
    for i = 1, #items do
        local item = items[i]
        local bodyLocation = item:getBodyLocation()
        local name = item:getFullType()

        -- Still check for exceptions defined in SharedData
        local undressTable = zlSharedData.UndressLocation[bodyPartToShave]
        local isException = false
        if undressTable and undressTable[bodyLocation] and undressTable[bodyLocation]["exceptions"][name] then
            isException = true
        end

        if not isException then
            ISTimedActionQueue.add(ISUnequipAction:new(player, item, 50))
        end
    end
end

--- Filter for finding usable razors (ZLLM)
--- @param item InventoryItem -- The item to check
--- @return boolean -- True if the item is a usable razor
local function predicateUsableRazor(item)
    return (not item:isBroken()) and item:getCurrentUses() >= 1
end

--- Predicate for appearance changer items
--- @param item InventoryItem
--- @return boolean
local function predicateAppearanceChanger(item)
	return item:hasTag(SPNCC.ItemTag.AppearanceChanger)
end

--- Predicate for appearance unlocker items
--- @param item InventoryItem
--- @return boolean
local function predicateAppearanceUnlocker(item)
	return item:hasTag(SPNCC.ItemTag.AppearanceUnlocker)
end

--- Searches for a usable razor in the player's inventory and bags (ZLLM)
--- @param player IsoPlayer -- The player character to search
--- @return InventoryItem|nil -- The found razor item, or nil if none found
local function searchRazor(player)
    local playerInv = player:getInventory()
    local razor = playerInv:getFirstTypeEval("Base.Razor", predicateUsableRazor)
    if razor == nil then
        razor = playerInv:getFirstTypeEval("Base.StraightRazor", predicateUsableRazor)
    end
    -- Also search bags (simplified)
    if razor == nil then
        local items = playerInv:getItems()
        for i=1,items:size() do
            local item = items:get(i-1)
            if instanceof(item, "InventoryContainer") then
                ---@cast item InventoryContainer
                razor = item:getInventory():getFirstTypeEval("Base.Razor", predicateUsableRazor)
                if not razor then razor = item:getInventory():getFirstTypeEval("Base.StraightRazor", predicateUsableRazor) end
                if razor then break end
            end
        end
    end
    if razor == nil then
        ZLLewdModels.debugLog(MODULE_NAME, "No usable razor found in inventory or bags.")
    end
    return razor
end

-- ==========================
-- Shaving Actions (ZLLM)
-- ==========================

--- Callback for the shave option in the context menu
--- @param player IsoPlayer -- The player performing the shave
--- @param choice string -- Target style
--- @param bodyLocation ItemBodyLocation -- The body location being shaved
local function onShaveBodyHairZLLM(player, choice, bodyLocation)
    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "onShaveBodyHair: Choice=%s, Location=%s", choice, bodyLocation:toString())
    end
    local razor = searchRazor(player)
    if razor then
        ISWorldObjectContextMenu.equip(player, player:getPrimaryHandItem(), razor, true)

        local locationID = bodyLocation:toString()
        if locationID == "zllewdmodels:leghair" then
            undress(player, "Legs")
        elseif locationID == "zllewdmodels:armpithair" or locationID == "zllewdmodels:chesthair" then
            if locationID == "zllewdmodels:chesthair" then
                local backpack = player:getWornItem(ItemBodyLocation.BACK)
                if backpack then  
                    ISInventoryPaneContextMenu.dropItem(backpack, player:getIndex())
                end                    
            end
            undress(player, "Chest")
        elseif locationID == "zllewdmodels:pubichair" then
            undress(player, "Pubic")	       	
        end

        ISTimedActionQueue.add(ZLLewdModels_ShaveBodyHairAction:new(player, choice, locationID, razor))
    end				
end

--- Callback for the shave stubble option (ZLLM)
--- @param player IsoPlayer
--- @param isBeard boolean
local function onShaveStubbleZLLM(player, isBeard)
    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "onShaveStubble: isBeard=%s", tostring(isBeard))
    end
    local razor = searchRazor(player)
    if razor then
        if not isBeard then
            if player:getClothingItem_Head() ~= nil then
                ISTimedActionQueue.add(ISUnequipAction:new(player, player:getClothingItem_Head(), 50))
            end
        end
        ISWorldObjectContextMenu.equip(player, player:getPrimaryHandItem(), razor, true)
        ISTimedActionQueue.add(ZLLewdModels_ShaveStubbleAction:new(player, isBeard, razor))
    end
end

-- ==========================
-- UI Context Menus
-- ==========================

--- @type table<string, string>
local UIText = {
    ["zllewdmodels:pubichair"] = "UI_ZLLewdModels_PubicHair",
    ["zllewdmodels:chesthair"] = "UI_ZLLewdModels_ChestHair",
    ["zllewdmodels:armpithair"] = "UI_ZLLewdModels_ArmpitHair",
    ["zllewdmodels:leghair"] = "UI_ZLLewdModels_LegHair"
}

--- Populates the body hair shaving context menu
--- @param self ISCharacterScreen -- The character screen UI instance
--- @param button ISButton -- The button that triggered the menu
local function bodyHairMenuZLLM(self, button)
    ZLLewdModels.debugLog(MODULE_NAME, "Populating body hair menu")
    local player = self.char
    local gender = player:isFemale() and "Female" or "Male"
    local data = player:getModData().ZLLewdModels
    if not data then
        ZLLewdModels.errorLog(MODULE_NAME, "ModData.ZLLewdModels is nil for player: %s", player:getFullName())
        return
    end
    local context = ISContextMenu.get(player:getIndex(), button:getAbsoluteX(), button:getAbsoluteY() + button:getHeight())
    local hasRazor = searchRazor(player) ~= nil

    -- Stubble options
    if not player:isFemale() then
        local currentBeard = getBeardStylesInstance():FindStyle(player:getHumanVisual():getBeardModel())
        local beardID = currentBeard and currentBeard:getName() or nil
        if data.BeardStubble == 1 and (not zlSharedData.FullBeards[beardID]) then
            local beardOption = context:addOption(getText("UI_ZLLewdModels_Stubble") .. ": " .. getText("UI_ZLLewdModels_Shave"), player, onShaveStubbleZLLM, true)
            if not hasRazor then self:addTooltip(beardOption, getText("UI_ZLLewdModels_RequireRazor")) end
        end
    end

    if data.HeadStubble == 1 and player:getHumanVisual():getHairModel() == "Bald" then
        local headOption = context:addOption(getText("UI_ZLLewdModels_HeadStubble") .. ": " .. getText("UI_ZLLewdModels_Shave"), player, onShaveStubbleZLLM, false)
        if not hasRazor then self:addTooltip(headOption, getText("UI_ZLLewdModels_RequireRazor")) end
    end

    local locID = zlSharedData.ModLocationID
    local shaveTable = zlSharedData.ShaveTable[gender]

    for locIDStr, _ in pairs(zlSharedData.BodyHairLocations) do
        local locRes = ResourceLocation.of(locIDStr)
        local location = ItemBodyLocation.get(locRes)

        if location then
            local locStr = location:toString()
            if gender == "Male" or locStr ~= "zllewdmodels:chesthair" then
                local currentStyle = data[locID[locStr]]
                if currentStyle ~= "None" then
                    -- Special styles
                    if shaveTable[currentStyle] then
                        for _, v in pairs(shaveTable[currentStyle]) do
                            local option = context:addOption(getText(UIText[locStr]) .. ": " .. v.optionText, player, onShaveBodyHairZLLM, v.canBeShavedTo, location)
                            if not hasRazor then self:addTooltip(option, getText("UI_ZLLewdModels_RequireRazor")) end
                        end
                    end
                    -- Shave All
                    local shaveAllText = (locID[locStr] == "PubicHair") and "UI_ZLLewdModels_PubicShaveComp" or "UI_ZLLewdModels_Shave"
                    local option = context:addOption(getText(UIText[locStr]) .. ": " .. getText(shaveAllText), player, onShaveBodyHairZLLM, "None", location)
                    if not hasRazor then self:addTooltip(option, getText("UI_ZLLewdModels_RequireRazor")) end
                end
            end
        end
    end
end

--- Opens the Spongie customisation menu
--- @param button ISButton
function ISCharacterScreen:customisationMenuSpongie(button)
	local FaceManager_Shared = require("CharacterCustomisation/FaceManager_Shared")
	self.CharCustomWindow = FaceManager_Shared.OpenCharacterCustomisationWindow(self.char, false)
	if not self.CharCustomWindow then return end

    self.CharCustomWindow.onClose = function()
        self.customisationButton.enable = true
		self.CharCustomWindow = nil
    end
    self.customisationButton.enable = false

	local allowChange = SandboxVars.SPNCharCustom.AllowCustomisationChange
	local allowFaceChange = (allowChange == 1) or (allowChange == 2)
	local allowBodyDetailsChange = (allowChange == 1) or (allowChange == 3)

	self.CharCustomWindow.faceMenu:setVisible(allowFaceChange or self.playerHasAppearanceChanger)
	self.CharCustomWindow.bodyDetailMenu:setVisible(allowBodyDetailsChange or self.playerHasAppearanceChanger)
	self.CharCustomWindow:setLockedOptionsVisible(self.playerHasAppearanceUnlocker)
end

-- ==========================
-- Patches
-- ==========================

local originalCreate = ISCharacterScreen.create
--- Extends vanilla ISCharacterScreen:create to add ZLLM and Spongie buttons
function ISCharacterScreen:create()
    originalCreate(self)

    -- ZLLM Button
    self.bodyHairButton = ISButton:new(0, 0, 70, BUTTON_HGT, getText("UI_ZLLewdModels_ButtonBodyHair"), self, bodyHairMenuZLLM)
    self.bodyHairButton:initialise()
    self.bodyHairButton:instantiate()
    self.bodyHairButton.borderColor.a = 0.3
    self.bodyHairButton:setVisible(false)
    self:addChild(self.bodyHairButton)

    -- Spongie Customisation Button
    self.customisationButton = ISButton:new(0, 0, 70, BUTTON_HGT, getText("IGUI_PlayerStats_Change"), self, ISCharacterScreen.customisationMenuSpongie)
    self.customisationButton:initialise()
    self.customisationButton:instantiate()
    self.customisationButton.borderColor.a = 0.3
    self.customisationButton:setVisible(false)
    self:addChild(self.customisationButton)
end

--- Returns a localized summary of current body hair
--- @param self ISCharacterScreen -- The character screen UI instance
--- @return string -- Localized summary text
local function getBodyHairSummary(self)
    local player = self.char
    local data = player:getModData().ZLLewdModels
    if not data then return "" end
    local gender = player:isFemale() and "Female" or "Male"
    if gender == "Female" then
        if data.PubicHair == "None" and data.ArmpitHair == "None" and data.LegHair == "None" then
            return getText("UI_ZLLewdModels_None")
        elseif data.PubicHair == "ZLLewdModels.FemalePubicNatural" and data.ArmpitHair == "ZLLewdModels.FemaleArmpit" and data.LegHair == "ZLLewdModels.FemaleLeg" then
            return getText("UI_ZLLewdModels_Full")
        else
            return getText("UI_ZLLewdModels_Some")
        end
    else
        if data.PubicHair == "None" and data.ArmpitHair == "None" and data.LegHair == "None" and data.ChestHair == "None" then
            return getText("UI_ZLLewdModels_None")
        elseif data.PubicHair == "ZLLewdModels.MalePubicNatural" and data.ArmpitHair == "ZLLewdModels.MaleArmpit"
             and data.LegHair == "ZLLewdModels.MaleLeg" and data.ChestHair == "ZLLewdModels.MaleChest" then
            return getText("UI_ZLLewdModels_Full")
        else
            return getText("UI_ZLLewdModels_Some")
        end
    end
end

local originalRender = ISCharacterScreen.render
--- Overrides render to position the body hair summary and buttons (Merged ZLLM & Spongie)
function ISCharacterScreen:render()
    originalRender(self)

    -- Update Refresh Timer for Customisation Data
    self.customisationRefreshTimer = (self.customisationRefreshTimer or CUSTOMISATION_UPDATE_FRAME_COUNT) + 1
	if self.customisationRefreshTimer >= CUSTOMISATION_UPDATE_FRAME_COUNT then
		self.customisationRefreshTimer = 0
		self.playerChoiceEnabled = (SandboxVars.SPNCharCustom.BodyHairGrowthEnabled == 3) or (SandboxVars.SPNCharCustom.MuscleVisuals == 3)
		self.customisationChangeEnabled = SandboxVars.SPNCharCustom.AllowCustomisationChange ~= 4
		self.playerHasAppearanceChanger = isDebugEnabled() or (isClient() and isAdmin()) or self.char:getInventory():containsEvalRecurse(predicateAppearanceChanger)
		self.playerHasAppearanceUnlocker = isDebugEnabled() or (isClient() and isAdmin()) or self.char:getInventory():containsEvalRecurse(predicateAppearanceUnlocker)
		self.playerCanChangeAppearance = self.playerHasAppearanceChanger or self.customisationChangeEnabled or self.playerChoiceEnabled

        -- Optimization Cache (ZLLM)
        self.summaryTextZLLM = getBodyHairSummary(self)
        self.hairWidthZLLM = getTextManager():MeasureStringX(UIFont.Small, self.hairStyle)
        self.beardWidthZLLM = (self.char:isFemale() and 0) or getTextManager():MeasureStringX(UIFont.Small, self.beardStyle)
        self.bodyHairWidthZLLM = getTextManager():MeasureStringX(UIFont.Small, self.summaryTextZLLM)
        self.labelBodyHairZLLM = getText("UI_ZLLewdModels_BodyHairLabel")
	end

    -- Positioning Logic
    local hairWidth = self.hairWidthZLLM or 0
    local beardWidth = self.beardWidthZLLM or 0
    local summary = self.summaryTextZLLM or ""
    local bodyHairWidth = self.bodyHairWidthZLLM or 0

    local textWid = hairWidth
    if beardWidth > textWid then textWid = beardWidth end
    if bodyHairWidth > textWid then textWid = bodyHairWidth end

    local buttonsX = self.xOffset + 10 + textWid + 10

    local yPos = self.char:isFemale() and self.hairButton:getY() or self.beardButton:getY()
    yPos = yPos + BUTTON_HGT + UI_BORDER_SPACING

    -- 1. ZLLM Body Hair
    self:drawTextRight(self.labelBodyHairZLLM or "", self.xOffset, yPos, 1, 1, 1, 1, UIFont.Small)
    self:drawText(summary, self.xOffset + 10, yPos, 1, 1, 1, 0.5, UIFont.Small)

    local data = self.char:getModData().ZLLewdModels
    local currentBeard = getBeardStylesInstance():FindStyle(self.char:getHumanVisual():getBeardModel())
    local beardID = currentBeard and currentBeard:getName() or nil
    local hasBeardStubble = data and data.BeardStubble == 1 and (not zlSharedData.FullBeards[beardID]) and not self.char:isFemale()
    local hasHeadStubble = data and data.HeadStubble == 1 and self.char:getHumanVisual():getHairModel() == "Bald"

    self.bodyHairButton:setVisible(true)
    self.bodyHairButton:setX(buttonsX)
    self.bodyHairButton:setY(yPos)
    self.bodyHairButton.enable = (summary ~= getText("UI_ZLLewdModels_None")) or hasBeardStubble or hasHeadStubble
    self.bodyHairButton.tooltip = not self.bodyHairButton.enable and getText("UI_ZLLewdModels_NoBodyHair") or nil

    yPos = yPos + BUTTON_HGT + UI_BORDER_SPACING

    -- 2. Spongie Customisation
    if self.playerCanChangeAppearance then
        self:drawTextRight(getText("UI_characreation_appearance"), self.xOffset, yPos, 1, 1, 1, 1, UIFont.Small)
        self.customisationButton:setVisible(true)
        self.customisationButton.enable = not self.CharCustomWindow
        self.customisationButton:setX(buttonsX)
        self.customisationButton:setY(yPos)
        yPos = yPos + BUTTON_HGT + UI_BORDER_SPACING
    else
        self.customisationButton:setVisible(false)
    end

    -- Shift literature button
    if self.literatureButton then self.literatureButton:setY(yPos) end
end

-- Stubble display in beard style (ZLLM)
local originalLoadBeardAndHairStyle = ISCharacterScreen.loadBeardAndHairStyle
--- Overrides loadBeardAndHairStyle to display "Stubble" instead of "None" when applicable
function ISCharacterScreen:loadBeardAndHairStyle()
    originalLoadBeardAndHairStyle(self)
    if not self.char:isFemale() then
        local data = self.char:getModData().ZLLewdModels
        local currentBeard = getBeardStylesInstance():FindStyle(self.char:getHumanVisual():getBeardModel())
        if data and data.BeardStubble == 1 and (not currentBeard or currentBeard:getLevel() <= 0) then
            self.beardStyle = getText("UI_ZLLewdModels_Stubble")
        end
    end
end
