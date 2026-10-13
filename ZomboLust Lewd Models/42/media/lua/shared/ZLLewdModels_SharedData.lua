--- File: ZomboLust Lewd Models/42/media/lua/shared/ZLLewdModels_SharedData.lua
--- Contains shared data, definitions, and logic for the body hair system.
--- This file acts as a central repository for shaving tables, hair definitions, 
--- and clothing/undressing logic related to body hair visibility.
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust Lewd Models LOADING] ZLLewdModels_SharedData.lua loaded")

--- @class ZLLewdModelsSharedData
local zlSharedData = {}

-- body hair locations
--- @type table<string, boolean>
zlSharedData.BodyHairLocations = {}
zlSharedData.BodyHairLocations["zllewdmodels:chesthair"] = true
zlSharedData.BodyHairLocations["zllewdmodels:armpithair"] = true 
zlSharedData.BodyHairLocations["zllewdmodels:pubichair"] = true 
zlSharedData.BodyHairLocations["zllewdmodels:leghair"] = true 

--- Checks if a BodyLocation is handled by the mod
--- @param bodyLocation ItemBodyLocation -- The location to check
--- @return boolean -- True if the location is modded hair or stubble
function zlSharedData.ModdedLocation(bodyLocation)
    local locStr = bodyLocation:toString()
    if zlSharedData.BodyHairLocations[locStr] or locStr == "zllewdmodels:beardstubble" or 
       locStr == "zllewdmodels:headstubble" then
        return true    
    else
        return false
    end
end

--- @type table<string, string>
zlSharedData.ModLocationID = {} -- internal IDs we use for body hair locations in the moddata
zlSharedData.ModLocationID["zllewdmodels:pubichair"] = "PubicHair"
zlSharedData.ModLocationID["zllewdmodels:chesthair"] = "ChestHair"
zlSharedData.ModLocationID["zllewdmodels:armpithair"] = "ArmpitHair"
zlSharedData.ModLocationID["zllewdmodels:leghair"] = "LegHair"

-- growth timers (in in-game days)
-- stage1 = base state -> intermediate ("visible regrowth")
-- stage2 = intermediate -> full ("clearly regrown")
--- @type table<string, {stage1: {min: integer, range: integer}, stage2: {min: integer, range: integer}}>
zlSharedData.HairGrowthDays = {
    PubicHair  = { stage1 = {min = 2, range = 3}, stage2 = {min = 5, range = 6} },
    ArmpitHair = { stage1 = {min = 2, range = 3}, stage2 = {min = 5, range = 6} },
    ChestHair  = { stage1 = {min = 2, range = 3}, stage2 = {min = 5, range = 6} },
    LegHair    = { stage1 = {min = 3, range = 3}, stage2 = {min = 9, range = 8} },
}

--- Rolls a growth timer duration (in days) for a body hair location
--- @param locKey string -- PubicHair / ArmpitHair / LegHair / ChestHair
--- @param isStage2 boolean -- true if the next transition is intermediate -> full growth
--- @return number
function zlSharedData.rollHairGrowthDays(locKey, isStage2)
    local stage = isStage2 and zlSharedData.HairGrowthDays[locKey].stage2 or zlSharedData.HairGrowthDays[locKey].stage1
    return stage.min + ZombRand(stage.range)
end

--- Rolls a growth timer duration (in days) for beard stubble regrowth
--- @return number
function zlSharedData.rollBeardStubbleDays()
    return 5 + ZombRand(5)
end

--- Rolls a growth timer duration (in days) for head stubble regrowth
--- @return number
function zlSharedData.rollHeadStubbleDays()
    return 7 + ZombRand(5)
end

-- here we store correct display names for body hair styles
--- @type table<string, string>
zlSharedData.CorrectName = {} 
zlSharedData.CorrectName["ZLLewdModels.MaleChest"] = getText("UI_ZLLewdModels_Natural")
zlSharedData.CorrectName["ZLLewdModels.MaleArmpit"] = getText("UI_ZLLewdModels_Natural")
zlSharedData.CorrectName["ZLLewdModels.MalePubicNatural"] = getText("UI_ZLLewdModels_Natural")
zlSharedData.CorrectName["ZLLewdModels.MalePubicStrip"] = getText("UI_ZLLewdModels_Strip")
zlSharedData.CorrectName["ZLLewdModels.MaleLeg"] = getText("UI_ZLLewdModels_Natural")

zlSharedData.CorrectName["ZLLewdModels.FemaleArmpit"] = getText("UI_ZLLewdModels_Natural")
zlSharedData.CorrectName["ZLLewdModels.FemalePubicNatural"] = getText("UI_ZLLewdModels_Natural")
zlSharedData.CorrectName["ZLLewdModels.FemalePubicStrip"] = getText("UI_ZLLewdModels_Strip")
zlSharedData.CorrectName["ZLLewdModels.FemalePubicTrimmed"] = getText("UI_ZLLewdModels_Trimmed")
zlSharedData.CorrectName["ZLLewdModels.FemaleLeg"] = getText("UI_ZLLewdModels_Natural")

-- some skin colors receive a slightly different hair item for better visuals
--- @type table<string, table<integer, string>>
zlSharedData.OptimizedBodyHair = { 
    Female = { [4] = "Black2", [5] = "Black2" },
    Male = {}
}

-- table for body hair definitions; used to populate Character Creation Screen (if we implement it)
--- @type table<string, table<string, {items: string[]}>>
zlSharedData.BodyHairDefinitions = {
    Female = {
        ["zllewdmodels:armpithair"] = { items = {"ZLLewdModels.FemaleArmpit"} },
        ["zllewdmodels:pubichair"] = { items = {"ZLLewdModels.FemalePubicStrip", "ZLLewdModels.FemalePubicTrimmed", "ZLLewdModels.FemalePubicNatural"} },
        ["zllewdmodels:leghair"] = { items = {"ZLLewdModels.FemaleLeg"} },
    },
    Male = {
        ["zllewdmodels:chesthair"] = { items = {"ZLLewdModels.MaleChest"} },
        ["zllewdmodels:armpithair"] = { items = {"ZLLewdModels.MaleArmpit"} },
        ["zllewdmodels:pubichair"] = { items = {"ZLLewdModels.MalePubicStrip", "ZLLewdModels.MalePubicNatural"} },
        ["zllewdmodels:leghair"] = { items = {"ZLLewdModels.MaleLeg"} },
    }
}

-- shaving options
--- @type table<string, table<string, {canBeShavedTo: string, optionText: string}[]>>
zlSharedData.ShaveTable = {}
zlSharedData.ShaveTable.Female = {}
zlSharedData.ShaveTable.Female["ZLLewdModels.FemalePubicNatural"] = { 
    {canBeShavedTo = "ZLLewdModels.FemalePubicTrimmed", optionText = getText("UI_ZLLewdModels_PubicTrim")},
    {canBeShavedTo = "ZLLewdModels.FemalePubicStrip", optionText = getText("UI_ZLLewdModels_PubicShaveStrip")} 
}
zlSharedData.ShaveTable.Female["ZLLewdModels.FemalePubicNatural_Int"] = { 
    {canBeShavedTo = "ZLLewdModels.FemalePubicTrimmed", optionText = getText("UI_ZLLewdModels_PubicTrim")},
    {canBeShavedTo = "ZLLewdModels.FemalePubicStrip", optionText = getText("UI_ZLLewdModels_PubicShaveStrip")} 
}
zlSharedData.ShaveTable.Female["ZLLewdModels.FemalePubicTrimmed"] = { 
    {canBeShavedTo = "ZLLewdModels.FemalePubicStrip", optionText = getText("UI_ZLLewdModels_PubicShaveStrip")} 
}

zlSharedData.ShaveTable.Male = {}
zlSharedData.ShaveTable.Male["ZLLewdModels.MalePubicNatural"] = { 
    {canBeShavedTo = "ZLLewdModels.MalePubicStrip", optionText = getText("UI_ZLLewdModels_PubicShaveStrip")} 
}
zlSharedData.ShaveTable.Male["ZLLewdModels.MalePubicNatural_Int"] = { 
    {canBeShavedTo = "ZLLewdModels.MalePubicStrip", optionText = getText("UI_ZLLewdModels_PubicShaveStrip")} 
}
zlSharedData.ShaveTable.Male["ZLLewdModels.MalePubicStrip_Int"] = { 
    {canBeShavedTo = "ZLLewdModels.MalePubicStrip", optionText = getText("UI_ZLLewdModels_PubicShaveStrip")} 
}

-- full beards
--- @type table<string, boolean>
zlSharedData.FullBeards = {}
zlSharedData.FullBeards["Full"] = true
zlSharedData.FullBeards["Long"] = true
zlSharedData.FullBeards["LongScruffy"] = true

-- undressing logic
--- @type table<string, table<string, {exceptions: table<string, boolean>}>>
zlSharedData.UndressLocation = {}
--- @type table<string, table<string, boolean>>
zlSharedData.UndressSpecificItems = { Pubic = {}, Chest = {}, Legs = {} }

--- Internal helper to define undress locations
--- @param bodyPart string -- "Chest", "Pubic" or "Legs"
--- @param location string -- BodyLocation ID (e.g., 'base:shirt')
--- @param exceptions string[] -- Array of FullTypes that are exceptions
local function makeUndressLocation(bodyPart, location, exceptions)
    if not zlSharedData.UndressLocation[bodyPart] then zlSharedData.UndressLocation[bodyPart] = {} end
    zlSharedData.UndressLocation[bodyPart][location] = { exceptions = {} }
    for i = 1, #exceptions do
        local v = exceptions[i]
        zlSharedData.UndressLocation[bodyPart][location]["exceptions"][v] = true
    end
end

-- define undress locations
makeUndressLocation("Chest", "base:torsoextra", {})
makeUndressLocation("Chest", "base:torsoextravest", {})
makeUndressLocation("Chest", "base:jacket", {})
makeUndressLocation("Chest", "base:jackethat", {})
makeUndressLocation("Chest", "base:jacketsuit", {})
makeUndressLocation("Chest", "base:jacket_bulky", {})
makeUndressLocation("Chest", "base:jackethat_bulky", {})
makeUndressLocation("Chest", "base:jacket_down", {})
makeUndressLocation("Chest", "base:sweater", {})
makeUndressLocation("Chest", "base:sweaterhat", {})
makeUndressLocation("Chest", "base:fullsuit", {})
makeUndressLocation("Chest", "base:fullsuithead", {})
makeUndressLocation("Chest", "base:fulltop", {})
makeUndressLocation("Chest", "base:bathrobe", {})
makeUndressLocation("Chest", "base:fannypackfront", {})
makeUndressLocation("Chest", "base:fannypackback", {})
makeUndressLocation("Chest", "base:shirt", {})
makeUndressLocation("Chest", "base:shortsleeveshirt", {})
makeUndressLocation("Chest", "base:tshirt", {})
makeUndressLocation("Chest", "base:dress", {})
makeUndressLocation("Chest", "base:tanktop", {})
makeUndressLocation("Chest", "base:torso1legs1", {})
makeUndressLocation("Chest", "base:underwear", {"Base.SwimTrunks_Blue", "Base.SwimTrunks_Green", "Base.SwimTrunks_Red", "Base.SwimTrunks_Yellow"})
makeUndressLocation("Chest", "base:underweartop", {})
makeUndressLocation("Chest", "base:bodycostume", {})
makeUndressLocation("Chest", "base:boilersuit", {})
makeUndressLocation("Chest", "base:fullrobe", {})

makeUndressLocation("Pubic", "base:torsoextravestbullet", {})
makeUndressLocation("Pubic", "base:pants_skinny", {})
makeUndressLocation("Pubic", "base:pants", {})
makeUndressLocation("Pubic", "base:pantsextra", {})
makeUndressLocation("Pubic", "base:shortpants", {})
makeUndressLocation("Pubic", "base:shortsshort", {})
makeUndressLocation("Pubic", "base:skirt", {})
makeUndressLocation("Pubic", "base:longskirt", {})
makeUndressLocation("Pubic", "base:dress", {})
makeUndressLocation("Pubic", "base:longdress", {})
makeUndressLocation("Pubic", "base:fullsuit", {})
makeUndressLocation("Pubic", "base:boilersuit", {})
makeUndressLocation("Pubic", "base:fullsuithead", {})
makeUndressLocation("Pubic", "base:legs1", {})
makeUndressLocation("Pubic", "base:torso1legs1", {})
makeUndressLocation("Pubic", "base:underwear_bottom", {})
makeUndressLocation("Pubic", "base:underwear", {})
makeUndressLocation("Pubic", "base:bathrobe", {})
makeUndressLocation("Pubic", "base:fullrobe", {})
makeUndressLocation("Pubic", "base:bodycostume", {})

makeUndressLocation("Legs", "base:torsoextra", {"Base.Vest_Waistcoat", "Base.Vest_WaistcoatTINT", "Base.Vest_Waistcoat_GigaMart"})
makeUndressLocation("Legs", "base:shoes", {})
makeUndressLocation("Legs", "base:bathrobe", {})
makeUndressLocation("Legs", "base:fullsuit", {})
makeUndressLocation("Legs", "base:fullsuithead", {})
makeUndressLocation("Legs", "base:dress", {})
makeUndressLocation("Legs", "base:longdress", {})
makeUndressLocation("Legs", "base:skirt", {})
makeUndressLocation("Legs", "base:pants", {})
makeUndressLocation("Legs", "base:torso1legs1", {})
makeUndressLocation("Legs", "base:legs1", {})
makeUndressLocation("Legs", "base:socks", {})
makeUndressLocation("Legs", "base:underwearextra1", {})
makeUndressLocation("Legs", "base:jacket_down", {})
makeUndressLocation("Legs", "base:jackethat", {})
makeUndressLocation("Legs", "base:shortpants", {})
makeUndressLocation("Legs", "base:shortsshort", {})
makeUndressLocation("Legs", "base:longskirt", {})
makeUndressLocation("Legs", "base:pantsextra", {})
makeUndressLocation("Legs", "base:boilersuit", {})
makeUndressLocation("Legs", "base:fullrobe", {})
makeUndressLocation("Legs", "base:bodycostume", {})

return zlSharedData
