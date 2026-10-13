--- File: ZomboLust Lewd Models/42/media/lua/client/ZLLewdModels_CharacterInit.lua
--- Handles character initialization and random body hair assignment
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust Lewd Models LOADING] ZLLewdModels_CharacterInit.lua loaded")

-- =============
-- Dependencies
-- =============
require("ZLLewdModels_Registries")
local _zlSharedData = require("ZLLewdModels_SharedData")
local manageBody = require("ZLLewdModels_ManageBody")
local modDataMigration = require("ZLLewdModels_ModDataMigration")
local _Regs = ZLLewdModelsRegistries

-- Module name for logging
--- @type string
local MODULE_NAME = "CharacterInit"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZLLewdModels.isDebug in ZomboLustLewdModels_Main.lua).
--- Calls with cheap/no arguments use ZLLewdModels.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZLLewdModels.isDebug(MODULE_NAME)
end

--- Randomizes the body hair state for a new character
--- @param player IsoPlayer -- The player character to randomize
local function randomizeModData(player)
    local isFemale = player:isFemale()
    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "Randomizing ModData for new player: %s", player:getFullName())
    end
    local data = player:getModData()
    data.ZLLewdModels = data.ZLLewdModels or {}
    local zlData = data.ZLLewdModels

    zlData.ModVersion = "B42"

    local gender = isFemale and "Female" or "Male"
    local draw = ZombRand(100) -- 0-99
    ZLLewdModels.debugLog(MODULE_NAME, "Draw value: %d (Gender: %s)", draw, gender)

    -- Initialize defaults
    zlData.PubicHair = "None"
    zlData.ArmpitHair = "None"
    zlData.LegHair = "None"
    zlData.ChestHair = "None"
    zlData.BeardStubble = 0
    zlData.HeadStubble = 0

    if draw < 33 then
        ZLLewdModels.debugLog(MODULE_NAME, "Randomization category: Glabre")
        -- 33% Glabre: Already "None"
    elseif draw < 66 then
        ZLLewdModels.debugLog(MODULE_NAME, "Randomization category: Partial")
        -- 33% Partial: Randomly Natural for each zone
        if ZombRand(100) < 50 then zlData.PubicHair = "ZLLewdModels." .. gender .. "PubicNatural" end
        if ZombRand(100) < 50 then zlData.ArmpitHair = "ZLLewdModels." .. gender .. "Armpit" end
        if ZombRand(100) < 50 then zlData.LegHair = "ZLLewdModels." .. gender .. "Leg" end
        if gender == "Male" and ZombRand(100) < 50 then zlData.ChestHair = "ZLLewdModels.MaleChest" end
    else
        ZLLewdModels.debugLog(MODULE_NAME, "Randomization category: Full")
        -- 34% Full: All Natural
        zlData.PubicHair = "ZLLewdModels." .. gender .. "PubicNatural"
        zlData.ArmpitHair = "ZLLewdModels." .. gender .. "Armpit"
        zlData.LegHair = "ZLLewdModels." .. gender .. "Leg"
        if gender == "Male" then zlData.ChestHair = "ZLLewdModels.MaleChest" end
    end

    -- Initialize growth timers
    zlData.DaysTilGrow = {}
    zlData.DaysTilGrow.PubicHair = _zlSharedData.rollHairGrowthDays("PubicHair", false)
    zlData.DaysTilGrow.ArmpitHair = _zlSharedData.rollHairGrowthDays("ArmpitHair", false)
    zlData.DaysTilGrow.LegHair = _zlSharedData.rollHairGrowthDays("LegHair", false)
    zlData.DaysTilGrow.ChestHair = _zlSharedData.rollHairGrowthDays("ChestHair", false)
    zlData.DaysTilGrow.BeardStubble = _zlSharedData.rollBeardStubbleDays()
    zlData.DaysTilGrow.HeadStubble = _zlSharedData.rollHeadStubbleDays()

    ZLLewdModels.debugLog(MODULE_NAME, "Randomization complete. Pubic: %s, Armpit: %s, Leg: %s, Chest: %s",
        zlData.PubicHair, zlData.ArmpitHair, zlData.LegHair, zlData.ChestHair)
end

--- Initializes the 3D hair models based on character state
--- @param player IsoPlayer -- The player character to initialize
local function initBody(player)
    local isFemale = player:isFemale()
    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "Initializing 3D body models for: %s", player:getFullName())
    end
    local queue = {
        {functionName = "EquipBodyHair", args = {bodyLocation = "zllewdmodels:pubichair"}},
        {functionName = "EquipBodyHair", args = {bodyLocation = "zllewdmodels:leghair"}},
        {functionName = "EquipBodyHair", args = {bodyLocation = "zllewdmodels:armpithair"}},
        {functionName = "EquipHeadStubble", args = {}}
    }

    if not isFemale then
        table.insert(queue, {functionName = "EquipBodyHair", args = {bodyLocation = "zllewdmodels:chesthair"}})
        table.insert(queue, {functionName = "EquipBeardStubble", args = {}})      
    end

    manageBody.executeQueue(player, queue, true)
end

--- Handler for the OnCreatePlayer event
--- @param playerIndex integer -- The index of the player (0 for local)
--- @param player IsoPlayer -- The player instance
local function onCreatePlayer(playerIndex, player)
    if not player then 
        ZLLewdModels.errorLog(MODULE_NAME, "onCreatePlayer called with nil player for playerIndex: %d", playerIndex)
        return 
    end

    ZLLewdModels.debugLog(MODULE_NAME, "OnCreatePlayer triggered for playerIndex: %d", playerIndex)

    local data = player:getModData()
    modDataMigration.migrateLegacyModData(data)
    if not data.ZLLewdModels or not data.ZLLewdModels.ModVersion then
        ZLLewdModels.debugLog(MODULE_NAME, "New player detected or mod version mismatch. Initializing...")
        randomizeModData(player)
        initBody(player)
    else
        ZLLewdModels.debugLog(MODULE_NAME, "Existing player detected (Version: %s). Refreshing visuals...", data.ZLLewdModels.ModVersion)
        -- Existing player, just refresh visuals
        initBody(player)
    end
end

Events.OnCreatePlayer.Add(onCreatePlayer)
