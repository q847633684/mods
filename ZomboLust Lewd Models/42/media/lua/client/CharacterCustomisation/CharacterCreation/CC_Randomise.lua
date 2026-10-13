--- File: ZomboLust Lewd Models/42/media/lua/client/CharacterCustomisation/CharacterCreation/CC_Randomise.lua
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- =============
-- Dependencies
-- =============
require("CharacterCustomisation/CharacterCreation/CC_UpdateCharacterPreview")

-- Module name for logging
--- @type string
local MODULE_NAME = "CC_Randomise"

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

local oldOnRandomCharacter = CharacterCreationMain.onRandomCharacter

--- Extends vanilla CharacterCreationMain:onRandomCharacter to randomise customisation
function CharacterCreationMain:onRandomCharacter()
    oldOnRandomCharacter(self)

    self:spn_populate_customisation_window()
    self:spn_randomise_face()
    self:spn_randomise_details()
    self:spn_update_character_customisation()
end

--- Randomises the selected face option
function CharacterCreationMain:spn_randomise_face()
    ZLLewdModels.debugLog(MODULE_NAME, "spn_randomise_face: Randomising face")

    --randomise face
    local faceMenu = self.characterCustomisationPanel.faceMenu
    local faceList = faceMenu:getOptionList()
    local faceCount = #faceList
    local randomFace = nil
    -- Loop until we find a face that can be randomly selected, bounded to avoid hanging if a future face table ever excluded every option
    -- (with the current data there's always at least one eligible face, so the warning fallback below should never actually trigger)
    local attempts = 0
    while attempts < faceCount * 4 do
        attempts = attempts + 1
        randomFace = faceList[ZombRand(faceCount) + 1]
        if randomFace and faceMenu.options[randomFace].randomExcluded ~= true then
            faceMenu:setSelectedOption(randomFace)
            return
        end
    end
    ZLLewdModels.warningLog(MODULE_NAME, "spn_randomise_face: No eligible face found after %d attempts, skipping randomisation", attempts)
end

--- Randomises the selected body detail options
function CharacterCreationMain:spn_randomise_details()

    --randomise body details
    local bodyDetailMenu = self.characterCustomisationPanel.bodyDetailMenu
    local detailList = bodyDetailMenu:getOptionList()
    local detailCount = #detailList
    --need to make a dictionary of options we want to select to avoid duplicates
    local dict = {}
    local minRolls = 0
    local maxRolls = detailCount < 3 and detailCount or 3
    for i = 1, ZombRand(minRolls, maxRolls) do

        --loop until we find an unselected option
        while true do
            local index = ZombRand(0, detailCount + 1)

            if index > 0 then
                if dict[index] == nil and bodyDetailMenu.options[detailList[index]].randomExcluded ~= true then
                    --we rolled a new option so we break the loop
                    dict[index] = true
                    break
                end
                --we havent rolled a new option so we loop again
            else
                --if we get no body detail we break the loop
                break
            end
        end
    end
    --convert the dictionary into a list of indexes we can use
    local list = table.newarray()
    for i,v in pairs(dict) do
        table.insert(list, detailList[i])
    end
    bodyDetailMenu:setSelectedOptions(list)
end
