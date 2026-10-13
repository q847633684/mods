--- File: ZomboLust Lewd Models/42/media/lua/shared/ZLLewdModels_HairGrowth.lua
--- Implements daily body hair and stubble growth
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust Lewd Models LOADING] ZLLewdModels_HairGrowth.lua loaded")

-- Module name for logging
--- @type string
local MODULE_NAME = "HairGrowth"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZLLewdModels.isDebug in ZomboLustLewdModels_Main.lua).
--- Calls with cheap/no arguments use ZLLewdModels.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZLLewdModels.isDebug(MODULE_NAME)
end

-- =============
-- Dependencies
-- =============
local zlSharedData = require("ZLLewdModels_SharedData")
local manageBody = require("ZLLewdModels_ManageBody")

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

--- @type table<string, table<string, {full: string, int: string}>>
local growthTable = {
    Female = {
        ["PubicHair"] = { full = "ZLLewdModels.FemalePubicNatural", int = "ZLLewdModels.FemalePubicNatural_Int" },
        ["ArmpitHair"] = { full = "ZLLewdModels.FemaleArmpit", int = "ZLLewdModels.FemaleArmpit_Int" },
        ["LegHair"] = { full = "ZLLewdModels.FemaleLeg", int = "ZLLewdModels.FemaleLeg_Int" },
    },
    Male = {
        ["PubicHair"] = { full = "ZLLewdModels.MalePubicNatural", int = "ZLLewdModels.MalePubicNatural_Int" },
        ["ArmpitHair"] = { full = "ZLLewdModels.MaleArmpit", int = "ZLLewdModels.MaleArmpit_Int" },
        ["LegHair"] = { full = "ZLLewdModels.MaleLeg", int = "ZLLewdModels.MaleLeg_Int" },
        ["ChestHair"] = { full = "ZLLewdModels.MaleChest", int = "ZLLewdModels.MaleChest_Int" },
    }
}

--- Checks whether body hair growth is currently allowed for this player, combining the sandbox master switch
--- (Enabled/Disabled for everyone) with the per-player toggle used when the sandbox setting is "Player Choice".
--- Growth is fully frozen (timers included) while disabled.
--- @param data table -- The player's ZLLewdModels mod data
--- @return boolean
local function isHairGrowthEnabled(data)
    local sandboxSetting = SandboxVars.SPNCharCustom.BodyHairGrowthEnabled
    if sandboxSetting == 1 then return true end
    if sandboxSetting == 2 then return false end
    -- Player Choice: default to enabled if the player never touched the toggle
    if data.bodyHairGrowthEnabled == nil then return true end
    return data.bodyHairGrowthEnabled
end

--- Daily update for body hair growth
--- @param player IsoPlayer -- The player character to update
local function growBodyHair(player)
    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "growBodyHair: Daily growth check for %s", player:getFullName())
    end
    local data = player:getModData().ZLLewdModels
    if not data or not data.DaysTilGrow then return end

    if not isHairGrowthEnabled(data) then
        if dbg() then
            ZLLewdModels.debugLog(MODULE_NAME, "growBodyHair: Growth disabled (sandbox or player choice), skipping.")
        end
        return
    end

    local gender = player:isFemale() and "Female" or "Male"
    local locID = zlSharedData.ModLocationID       

    -- count days since last change
    data.DaysTilGrow.PubicHair = data.DaysTilGrow.PubicHair - 1
    data.DaysTilGrow.ArmpitHair = data.DaysTilGrow.ArmpitHair - 1
    data.DaysTilGrow.LegHair = data.DaysTilGrow.LegHair - 1
    if gender == "Male" then
        data.DaysTilGrow.ChestHair = data.DaysTilGrow.ChestHair - 1
        data.DaysTilGrow.BeardStubble = data.DaysTilGrow.BeardStubble - 1
    end
    -- Fallback for existing saves where DaysTilGrow.HeadStubble was never initialized
    data.DaysTilGrow.HeadStubble = (data.DaysTilGrow.HeadStubble or zlSharedData.rollHeadStubbleDays()) - 1

    local queue = {}

    -- Grow body hair
    for location,_ in pairs(zlSharedData.BodyHairLocations) do
        local locKey = locID[location]
        if locKey and (gender == "Male" or locKey ~= "ChestHair") then
            if data.DaysTilGrow[locKey] <= 0 then
                -- This reset always follows a transition that lands on an intermediate or full
                -- state, so the timer it sets always governs the intermediate -> full stage.
                data.DaysTilGrow[locKey] = zlSharedData.rollHairGrowthDays(locKey, true)

                local currentItem = data[locKey]
                local target = growthTable[gender][locKey]

                if currentItem ~= target.full then
                    if currentItem == target.int then
                        data[locKey] = target.full
                    elseif currentItem == "ZLLewdModels.MalePubicStrip" then -- Men special case
                        data[locKey] = "ZLLewdModels.MalePubicStrip_Int"
                    elseif currentItem == "ZLLewdModels.MalePubicStrip_Int" then
                        data[locKey] = target.full
                    else
                        data[locKey] = target.int
                    end 
                    ZLLewdModels.debugLog(MODULE_NAME, "Growth triggered for %s. New style: %s", locKey, data[locKey])
                    table.insert(queue, {functionName = "EquipBodyHair", args = {bodyLocation = location}})
                end
            end
        end
    end

    -- Grow beard stubble for men
    if gender == "Male" and data.DaysTilGrow.BeardStubble <= 0 then
        data.DaysTilGrow.BeardStubble = zlSharedData.rollBeardStubbleDays()
        if data.BeardStubble == 0 then
            data.BeardStubble = 1
            table.insert(queue, {functionName = "EquipBeardStubble", args = {}})
        end
    end

    -- Grow head stubble
    if data.DaysTilGrow.HeadStubble <= 0 then
        data.DaysTilGrow.HeadStubble = zlSharedData.rollHeadStubbleDays()
        if data.HeadStubble == 0 then
            data.HeadStubble = 1
            table.insert(queue, {functionName = "EquipHeadStubble", args = {}})
        end
    end

    if #queue ~= 0 then
        manageBody.executeQueue(player, queue, true)
    end
end

--- Handler for the EveryDays event
local function manageHairGrowth()
    -- Solo only as requested
    local player = getPlayer()
    if player then
        growBodyHair(player)
    end
end

Events.EveryDays.Add(manageHairGrowth)
