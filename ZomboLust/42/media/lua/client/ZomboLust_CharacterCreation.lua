-- File: ZomboLust/42/media/lua/client/ZomboLust_CharacterCreation.lua
-- Prevent Bukkake locations from showing in clothing panel
-- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_CharacterCreation.lua loaded")

-- Module name for logging
--- @type string
local MODULE_NAME = "CharacterCreation"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
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
local tostring = tostring

local originalCreateClothingComboDebug = CharacterCreationMain.createClothingComboDebug

--- Extends vanilla CharacterCreationMain:createClothingComboDebug to hide Bukkake locations
--- @param bodyLocation string
--- @return void
function CharacterCreationMain:createClothingComboDebug(bodyLocation)
    if bodyLocation and string.find(bodyLocation, "[Bb][Uu][Kk][Kk][Aa][Kk][Ee]") then
        if dbg() then
            ZomboLust.debugLog(MODULE_NAME, "createClothingComboDebug: Skipping Bukkake location " .. tostring(bodyLocation))
        end
        return
    end
    originalCreateClothingComboDebug(self, bodyLocation)
end
