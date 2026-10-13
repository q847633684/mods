--- File: ZomboLust Lewd Models/42/media/lua/shared/ZLLewdModels_RazorMod.lua
--- Modifies vanilla razors to be drainable with some uses
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust Lewd Models LOADING] ZLLewdModels_RazorMod.lua loaded")

-- Module name for logging
--- @type string
local MODULE_NAME = "RazorMod"

--- Modifies script definitions for vanilla razors
local function modifyVanillaRazors()
    local scriptMgr = ScriptManager.instance
    -- Base Razor: 8 uses
    local razor = scriptMgr:getItem("Base.Razor")
    if razor then
        razor:DoParam("ItemType = base:drainable")
        razor:DoParam("UseDelta = 0.125")
        razor:DoParam("UseWhileEquipped = FALSE")
        razor:DoParam("cantBeConsolided = TRUE")
        ZLLewdModels.debugLog(MODULE_NAME, "Modified Base.Razor: 8 uses")
    end

    -- Straight Razor: 12 uses
    local straightRazor = scriptMgr:getItem("Base.StraightRazor")
    if straightRazor then
        straightRazor:DoParam("ItemType = base:drainable")
        straightRazor:DoParam("UseDelta = 0.08333")
        straightRazor:DoParam("UseWhileEquipped = FALSE")
        straightRazor:DoParam("cantBeConsolided = TRUE")
        ZLLewdModels.debugLog(MODULE_NAME, "Modified Base.StraightRazor: 12 uses")
    end
end

Events.OnGameBoot.Add(modifyVanillaRazors)
