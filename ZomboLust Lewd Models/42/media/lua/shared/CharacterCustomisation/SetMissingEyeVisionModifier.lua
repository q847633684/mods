--- File: ZomboLust Lewd Models/42/media/lua/shared/CharacterCustomisation/SetMissingEyeVisionModifier.lua
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- =============
-- Dependencies
-- =============
local SPNCC_Data = require("CharacterCustomisation/SPNCC_Data")

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local pairs = pairs

--- Applies vision penalty to items tagged as missing eyes based on sandbox settings
local function SetMissingEyeVisionPenalty()
    if SPNCC_Data.MissingEyes == nil then return end

    local MissingEyeVisionModifier = SandboxVars.SPNCharCustom.MissingEyeVisionModifier
    local scriptManager = ScriptManager.instance
    local paramString = "VisionModifier = " .. MissingEyeVisionModifier

    for _, v in pairs(SPNCC_Data.MissingEyes) do
        local item = scriptManager:getItem(v)
        if item then
            item:DoParam(paramString)
        end
    end
end

--- Event handler for OnInitGlobalModData to apply vision penalties
local function OnInitGlobalModData()
    SetMissingEyeVisionPenalty()
end
Events.OnInitGlobalModData.Add(OnInitGlobalModData)
