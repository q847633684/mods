--- File: ZomboLust Lewd Models/42/media/lua/client/CharacterCustomisation/CharacterCreation/CC_LoadAndSaveOutfit.lua
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- Main
CharacterCreationMain.spn_character_customisation_saved = "spncharcustom_saved_outfits.txt";

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local table    = table
local pairs    = pairs
local tostring = tostring
local tonumber = tonumber

local OUTFIT_CHARACTER_CUSTOMISATION_FILE_VERSION = 1;


--- Reads the character customisation save file and returns the data as a table
--- @return table
function CharacterCreationMain.readCharacterCustomisationSaveFile()
    local retVal = {};
    local saveFile = getFileReader(CharacterCreationMain.spn_character_customisation_saved, true);
    if not saveFile then return retVal end
    ---@type number
    local version = 0;
    local line = saveFile:readLine();
    while line ~= nil do
        if luautils.stringStarts(line, "VERSION=") then
            local s = luautils.split(line, "=");
            local n = tonumber(s[2]) or 0
            version = n - n % 1
        elseif version == OUTFIT_CHARACTER_CUSTOMISATION_FILE_VERSION then
            local s = luautils.split(line, ":");
            retVal[s[1]] = s[2];
        end
        line = saveFile:readLine();
    end
    saveFile:close();

    return retVal;
end

--- Writes the character customisation data to the save file
--- @param options table
function CharacterCreationMain.writeCharacterCustomisationSaveFile(options)
    local saveFile = getFileWriter(CharacterCreationMain.spn_character_customisation_saved, true, false); -- overwrite
    if not saveFile then return end
    saveFile:write("VERSION="..tostring(OUTFIT_CHARACTER_CUSTOMISATION_FILE_VERSION).."\n")
    for key,val in pairs(options) do
        saveFile:write(key..":"..val.."\n");
    end
    saveFile:close();
end

--- Extends vanilla CharacterCreationMain:loadOutfit to include customisation data
local originalMainLoadOutfit = CharacterCreationMain.loadOutfit;
--- @param box ISComboBox -- The outfit selection combo box
function CharacterCreationMain:loadOutfit(box)
    originalMainLoadOutfit(self, box)

    local name = box.options[box.selected]
    if name == nil then return end

    -- reset selections before we try to load data
    self.characterCustomisationPanel:setSelectedFace("DefaultFace")
    self.characterCustomisationPanel:clearSelectedBodyDetails()

    local saved_builds = CharacterCreationMain.readCharacterCustomisationSaveFile();
    local build = saved_builds[name]

    --if the save doesnt have character customisation save data then we need to clear the body details
    if build then
        local items = luautils.split(build, ";");
        for i = 1, #items do
            local v = items[i]
            local location = luautils.split(v, "=");
            local options = nil;
            if location[2] then
                options = luautils.split(location[2], "|");
            end
            if options then
                if location[1] == "face" and options[1] then
                    self.characterCustomisationPanel:setSelectedFace(options[1])
                elseif location[1] == "bodyhair" and options[1] then
                    local chestHair = tonumber(options[1]) == 1
                    self.chestHairTickBox:setSelected(1, chestHair)
                elseif location[1] == "bodydetails" then
                    local list = table.newarray()
                    for j = 1, #options do
                        table.insert(list, options[j])
                    end
                    self.characterCustomisationPanel:setSelectedBodyDetails(list)
                end
            end
        end
    end

    self:spn_update_character_customisation()
end

--- Extends vanilla CharacterCreationMain.saveBuildStep2 to include customisation data
local originalMainSaveBuildStep2 = CharacterCreationMain.saveBuildStep2;
--- @param self any -- The CharacterCreationMain instance
--- @param button ISButton -- The save button
--- @param joypadData JoypadData -- Joypad data if applicable
--- @param param2 any -- Unused parameter
function CharacterCreationMain.saveBuildStep2(self, button, joypadData, param2)
    originalMainSaveBuildStep2(self, button, joypadData, param2)

    if not button.parent then return end
    ---@cast button any
    local savename = button.parent.entry:getText()
    if savename == '' then return end

    local builds = CharacterCreationMain.readCharacterCustomisationSaveFile()
    local savestring = ""
    -------------------------------------------------------------------
        -- SAVE FACE
    savestring = savestring .. "face=" .. self.characterCustomisationPanel.faceMenu:getSelectedOption().name .. ";"
    -------------------------------------------------------------------
        -- SAVE CHEST HAIR		 vanilla doesnt save it for female chars
    savestring = savestring .. "bodyhair=" .. (self.chestHairTickBox:isSelected(1) and "1" or "2") .. ";"
    -------------------------------------------------------------------
        -- SAVE BODY DETAILS
    local selectedOptions = self.characterCustomisationPanel.bodyDetailMenu:getSelectedOptionList()
    local bodyDetailsList = table.newarray()
    for i = 1, #selectedOptions do
        table.insert(bodyDetailsList, selectedOptions[i])
    end
    savestring = savestring .. "bodydetails=" .. table.concat(bodyDetailsList, "|") .. ";"
    -------------------------------------------------------------------
        -- FINISHED WRITING SAVE
    -------------------------------------------------------------------
    builds[savename] = savestring
    CharacterCreationMain.writeCharacterCustomisationSaveFile(builds)
end

--- Extends vanilla CharacterCreationMain.deleteBuildStep2 to remove customisation data
local originalMainDeleteBuildStep2 = CharacterCreationMain.deleteBuildStep2;
--- @param self any -- The CharacterCreationMain instance
--- @param button ISButton -- The delete button
--- @param joypadData JoypadData -- Joypad data if applicable
function CharacterCreationMain.deleteBuildStep2(self, button, joypadData)
    originalMainDeleteBuildStep2(self, button, joypadData)

    local delBuild = self.savedBuilds.options[self.savedBuilds.selected]
    --if delBuild == '' then return end

    local builds = CharacterCreationMain.readCharacterCustomisationSaveFile()
    builds[delBuild] = nil

    CharacterCreationMain.writeCharacterCustomisationSaveFile(builds)
end
