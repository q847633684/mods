--- File: ZomboLust Lewd Models/42/media/lua/client/CharacterCustomisation/CharacterCreation/CC_UpdateCharacterPreview.lua
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- =============
-- Dependencies
-- =============
local FaceManager_Shared = require("CharacterCustomisation/FaceManager_Shared")
local SPNCC_Data = require("CharacterCustomisation/SPNCC_Data")

-- Module name for logging
--- @type string
local MODULE_NAME = "CC_UpdateCharacterPreview"

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
local string   = string
local table    = table
local tostring = tostring

CharacterCreationMain.wornCustomisationItems = {}
CharacterCreationMain.bodyHairOptions = { stubbleHead = false, stubbleBeard = false, bodyHair = false }

--- Refreshes the preview character by removing previous body details and adding selected ones
--- @return void
function CharacterCreationMain:spn_update_character_customisation()
    local mainScreen = MainScreen.instance
    if not mainScreen then return end
    ZLLewdModels.debugLog(MODULE_NAME, "spn_update_character_customisation: Start")
    local desc = mainScreen.desc

    local skinVisual = desc:getHumanVisual()
    local skinIndexBefore = skinVisual:getSkinTextureIndex()

    -- Call vanilla setAvatarFromUI first so that ZLLM customisations are applied on top
    -- and won't be overwritten by vanilla's clothing panel updates
    self:setAvatarFromUI()

    local skinIndexAfter = skinVisual:getSkinTextureIndex()
    if skinIndexBefore ~= skinIndexAfter then
        ZLLewdModels.warningLog(MODULE_NAME, "spn_update_character_customisation: Skin index CHANGED after setAvatarFromUI! " .. tostring(skinIndexBefore) .. " -> " .. tostring(skinIndexAfter))
    end

    local bodySkinIndex = skinVisual:getSkinTextureIndex()
    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "spn_update_character_customisation: Body SkinTextureIndex=" .. tostring(bodySkinIndex))
    end

    local wornItems = desc:getWornItems()

    -- Robust removal: find and remove any item at an spncc location
    -- We iterate backwards because we are removing from the list
    for i = wornItems:size() - 1, 0, -1 do
        local wornItem = wornItems:get(i)
        local location = wornItem:getLocation()
        local item = wornItem:getItem()
        if location and string.find(tostring(location), "spncc:") then
            if dbg() then
                ZLLewdModels.debugLog(MODULE_NAME, "Removing existing custom item: " .. tostring(item:getFullType()) .. " at " .. tostring(location))
            end
            wornItems:remove(item)
        end
    end

    -- Also clear the tracked table just in case
    self.wornCustomisationItems = {}

    self:spn_update_face()
    self:spn_update_body_details()
    -- self:spn_update_body_hair()
    self:spn_update_body_muscle()
    self:spn_equip_customisation_items()
    self:spn_store_character_data()

    self:spn_set_preview_bodydetails(self.wornCustomisationItems)

    ZLLewdModels.debugLog(MODULE_NAME, "spn_update_character_customisation: End")
end

--- Updates the face preview item
--- @return void
function CharacterCreationMain:spn_update_face()
    local faceMenu = self.characterCustomisationPanel.faceMenu
    local face = faceMenu:getSelectedOption()

    if face == nil then
        if dbg() then
            ZLLewdModels.debugLog(MODULE_NAME, "spn_update_face: No custom face selected (selectedOptions count=" .. tostring(faceMenu:getSelectedOptionCount()) .. ")")
        end
        return
    end
    if face.name == "DefaultFace" then
        ZLLewdModels.debugLog(MODULE_NAME, "spn_update_face: DefaultFace selected, skipping item creation")
        return
    end
    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "spn_update_face: Creating face item for " .. tostring(face.name) .. " (ID: " .. tostring(face.id) .. ") with texture " .. tostring(face.texture))
    end
    local item = FaceManager_Shared.CreateItem(face.id, face.texture)
    table.insert(self.wornCustomisationItems, item)
end

--- Updates the body details preview items
--- @return void
function CharacterCreationMain:spn_update_body_details()
    local selectedBodyDetails = self.characterCustomisationPanel.bodyDetailMenu:getSelectedOptions()
    if selectedBodyDetails == nil then return end
    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "spn_update_body_details: Updating " .. tostring(#selectedBodyDetails) .. " body details")
    end
    for i = 1, #selectedBodyDetails do
        local bodydetail = selectedBodyDetails[i]
        if bodydetail then
            if dbg() then
                ZLLewdModels.debugLog(MODULE_NAME, "spn_update_body_details: Adding " .. tostring(bodydetail.name) .. " with texture " .. tostring(bodydetail.texture))
            end
            local item = FaceManager_Shared.CreateItem(bodydetail.id, bodydetail.texture)
            table.insert(self.wornCustomisationItems, item)
        end
    end
end

--- Updates the body hair and stubble preview items
--- @return void
function CharacterCreationMain:spn_update_body_hair()
    local mainScreen = MainScreen.instance
    if not self.hairStubbleTickBox or not mainScreen then return end

    local desc = mainScreen.desc
    local bodyHairOptions = self.bodyHairOptions

    bodyHairOptions.stubbleHead = self.hairStubbleTickBox:isSelected(1)
    bodyHairOptions.stubbleBeard = self.beardStubbleTickBox:isSelected(1)
    bodyHairOptions.bodyHair = self.chestHairTickBox:isSelected(1)

    local function addBodyHair(itemName)
        local item = FaceManager_Shared.CreateItem(itemName, desc:getHumanVisual():getSkinTextureIndex())
        table.insert(self.wornCustomisationItems, item)
    end
    if bodyHairOptions.stubbleHead then
        addBodyHair(SPNCC_Data.StubbleHead)
    end
    if bodyHairOptions.stubbleBeard then
        addBodyHair(SPNCC_Data.StubbleBeard)
    end
    if bodyHairOptions.bodyHair then
        local name = desc:isFemale() and SPNCC_Data.BodyHair[2] or SPNCC_Data.BodyHair[1]
        addBodyHair(name)
    end
end

--- Updates the body muscle preview item
--- @return void
function CharacterCreationMain:spn_update_body_muscle()
    local mainScreen = MainScreen.instance
    local isSelected = self.characterCustomisationPanel.muscleButton:isSelected()
    ZLLewdModels.debugLog(MODULE_NAME, "spn_update_body_muscle: MuscleVisuals=" .. tostring(SandboxVars.SPNCharCustom.MuscleVisuals) .. " muscleButton:isSelected()=" .. tostring(isSelected))
    if SandboxVars.SPNCharCustom.MuscleVisuals == 2 or not isSelected or not mainScreen then
        ZLLewdModels.debugLog(MODULE_NAME, "spn_update_body_muscle: Early return (sandbox disabled, button not selected, or no mainScreen)")
        return
    end
    local desc = mainScreen.desc

    local muscleLevel = self:spn_getMuscleLevel()
    ZLLewdModels.debugLog(MODULE_NAME, "spn_update_body_muscle: muscleLevel=" .. tostring(muscleLevel))

    if muscleLevel <= 0 then return end

    local id = desc:isFemale() and SPNCC_Data.Muscle[2] or SPNCC_Data.Muscle[1]

    local textureOffset = 0
    if muscleLevel == 2 then textureOffset = 5 end
    local texture = desc:getHumanVisual():getSkinTextureIndex() + textureOffset

    ZLLewdModels.debugLog(MODULE_NAME, "spn_update_body_muscle: Adding muscle item id=" .. tostring(id) .. " texture=" .. tostring(texture))
    local item = FaceManager_Shared.CreateItem(id, texture)

    table.insert(self.wornCustomisationItems, item)
end

--- Gets the muscle level based on the player's strength trait in the character creation screen
--- @return integer
function CharacterCreationMain:spn_getMuscleLevel()
    -- Reads the Strength value straight from vanilla's own listboxXpBoost,
    -- so it inherits a known vanilla display bug (confirmed in B42.20.4 stable):
    -- clicking "Reset Stats" removes the Strong trait but does not refresh this listbox's cached Strength value back down from 9 to 5,
    -- only switching profession away and back forces a recompute.
    -- Not fixable on our side; if a level looks stale here, check vanilla's own stat display first before assuming a ZLLM regression.
    if not CharacterCreationProfession.instance or not CharacterCreationProfession.instance.listboxXpBoost then
        ZLLewdModels.debugLog(MODULE_NAME, "spn_getMuscleLevel: No CharacterCreationProfession.instance.listboxXpBoost, returning 0")
        return 0
    end
    local items = CharacterCreationProfession.instance.listboxXpBoost.items
    ZLLewdModels.debugLog(MODULE_NAME, "spn_getMuscleLevel: Scanning " .. tostring(#items) .. " listboxXpBoost items, looking for text=" .. tostring(PerkFactory.getPerkName(Perks.Strength)))
    for i = 1, #items do
        local v = items[i]
        if v then
            ZLLewdModels.debugLog(MODULE_NAME, "spn_getMuscleLevel: item[" .. tostring(i) .. "] text=" .. tostring(v.text) .. " level=" .. tostring(v.item and v.item.level))
        end
        if v and v.text == PerkFactory.getPerkName(Perks.Strength) then
            ZLLewdModels.debugLog(MODULE_NAME, "spn_getMuscleLevel: Matched Strength, level=" .. tostring(v.item.level) .. " -> muscleLevel=" .. tostring(FaceManager_Shared.GetMuscleLevel(v.item.level)))
            return FaceManager_Shared.GetMuscleLevel(v.item.level)
        end
    end
    return 0
end

--- Equips all prepared customisation items to the preview character
--- @return void
function CharacterCreationMain:spn_equip_customisation_items()
    local mainScreen = MainScreen.instance
    if not mainScreen then return end
    local desc = mainScreen.desc
    if self.wornCustomisationItems == nil then return end
    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "spn_equip_customisation_items: Equipping " .. tostring(#self.wornCustomisationItems) .. " items")
    end
    for i = 1, #self.wornCustomisationItems do
        local v = self.wornCustomisationItems[i]
        if v then
            if dbg() then
                ZLLewdModels.debugLog(MODULE_NAME, "spn_equip_customisation_items: Equipping " .. tostring(v:getFullType()) .. " at " .. tostring(v:getBodyLocation()))
            end
            desc:setWornItem(v:getBodyLocation(), v)
        end
    end
end

--- Stores the current character customisation data for persistence
--- @return void
function CharacterCreationMain:spn_store_character_data()
    local clientData = require("CharacterCustomisation/CharacterCreation/StoredCharacterData")

    clientData.face = {name = "DefaultFace", id = "DefaultFace"}
    local face = self.characterCustomisationPanel.faceMenu:getSelectedOption()
    if face then
        clientData.face = {name = face.name, id = face.id, texture = face.texture}
    end
    local bodyDetails = {}
    local selectedBodyDetails = self.characterCustomisationPanel.bodyDetailMenu:getSelectedOptions()
    if selectedBodyDetails then
        for i = 1, #selectedBodyDetails do
            local v = selectedBodyDetails[i]
            if v then
                local item = {name = v.name, id = v.id, texture = v.texture}
                table.insert(bodyDetails, item)
            end
        end
    end
    clientData.bodyDetails = bodyDetails

    -- clientData.bodyHair = self.bodyHairOptions.bodyHair

    -- clientData.stubbleHead = self.bodyHairOptions.stubbleHead

    -- clientData.stubbleBeard = self.bodyHairOptions.stubbleBeard

    -- clientData.muscleVisuals = self.characterCustomisationPanel.muscleButton:isSelected()

    -- clientData.bodyHairGrowthEnabled = self.characterCustomisationPanel.hairButton:isSelected()
end

-- ------------------------------
--   BODY DETAIL PREVIEW AVATAR
-- ------------------------------

--- Updates the preview avatar in the customisation window
--- @param bodyDetails table
function CharacterCreationMain:spn_set_preview_bodydetails(bodyDetails)
    if self.characterCustomisationPanel then 
        self.characterCustomisationPanel:setPreviewBodyDetails(bodyDetails)
    end
end
