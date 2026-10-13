local ____lualib = require('lualib_bundle')
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFlatMap = ____lualib.__TS__ArrayFlatMap
local __TS__Unpack = ____lualib.__TS__Unpack
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayPush = ____lualib.__TS__ArrayPush
local __TS__New = ____lualib.__TS__New
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
--- Named groups of procedural distribution tables for reusability and clarity.
local TABLE_GROUPS = {
    bathroom = {"BathroomCabinet", "BathroomCounter", "BathroomShelf"},
    bedroomSideTables = {"BedroomSidetable", "BedroomSidetableClassy", "BedroomSidetableRedneck"},
    bedroomDressers = {"BedroomDresser", "BedroomDresserClassy", "BedroomDresserRedneck"},
    hospital = {"HospitalRoomCounter", "HospitalRoomShelves", "MedicalClinicDrugs"},
    hospitalRoom = {"HospitalRoomCounter", "HospitalRoomShelves"},
    medicalStore = {"StoreShelfMedical"},
    toiletriesStore = {"GigamartToiletries"},
    trashBins = {
        "BinBar",
        "BinBathroom",
        "BinCrepe",
        "BinDumpster",
        "BinFireStation",
        "BinGeneric",
        "BinHospital",
        "BinJays",
        "BinSpiffos",
        "SafehouseBin",
        "SafehouseBin_Mid",
        "SafehouseBin_Late"
    }
}
local function createDistributionRules(groups)
    return __TS__ArrayFlatMap(
        groups,
        function(____, group) return __TS__ArrayMap(
            group.items,
            function(____, item) return {itemType = item.itemType, chance = item.chance, tableNames = group.tableNames} end
        ) end
    )
end
local ____temp_1 = {tableNames = TABLE_GROUPS.bathroom, items = {
    {itemType = "BF.Contraceptive", chance = 2},
    {itemType = "BF.Lactaid", chance = 1},
    {itemType = "BF.Condom", chance = 6},
    {itemType = "BF.CondomBox", chance = 4},
    {itemType = "BF.VaginalDouche", chance = 0.5}
}}
local ____temp_2 = {tableNames = TABLE_GROUPS.bedroomSideTables, items = {{itemType = "BF.Contraceptive", chance = 1}, {itemType = "BF.Lactaid", chance = 0.5}}}
local ____array_0 = __TS__SparseArrayNew(__TS__Unpack(TABLE_GROUPS.bedroomDressers))
__TS__SparseArrayPush(
    ____array_0,
    __TS__Unpack(TABLE_GROUPS.bedroomSideTables)
)
--- Default distribution rules for all BF custom items.
-- Defines which items spawn in which procedural loot tables and at what chance weight.
local BF_DISTRIBUTION_GROUPS = {
    ____temp_1,
    ____temp_2,
    {
        tableNames = {__TS__SparseArraySpread(____array_0)},
        items = {{itemType = "BF.Condom", chance = 6}}
    },
    {tableNames = TABLE_GROUPS.bedroomDressers, items = {{itemType = "BF.CondomBox", chance = 1}}},
    {tableNames = TABLE_GROUPS.bedroomSideTables, items = {{itemType = "BF.CondomBox", chance = 2}}},
    {tableNames = TABLE_GROUPS.bedroomSideTables, items = {{itemType = "BF.BreastPump", chance = 0.25}}},
    {tableNames = TABLE_GROUPS.hospital, items = {{itemType = "BF.Contraceptive", chance = 4}, {itemType = "BF.Lactaid", chance = 4}, {itemType = "BF.Condom", chance = 6}, {itemType = "BF.CondomBox", chance = 8}}},
    {tableNames = TABLE_GROUPS.hospitalRoom, items = {{itemType = "BF.BreastPump", chance = 1}, {itemType = "BF.VaginalDouche", chance = 1}}},
    {tableNames = TABLE_GROUPS.medicalStore, items = {{itemType = "BF.Contraceptive", chance = 4}, {itemType = "BF.Lactaid", chance = 2}, {itemType = "BF.BreastPump", chance = 0.5}}},
    {tableNames = TABLE_GROUPS.toiletriesStore, items = {{itemType = "BF.Condom", chance = 6}, {itemType = "BF.CondomBox", chance = 4}, {itemType = "BF.VaginalDouche", chance = 1}}},
    {tableNames = TABLE_GROUPS.trashBins, items = {{itemType = "BF.CondomUsed", chance = 4}}}
}
local BF_DISTRIBUTION_RULES = createDistributionRules(BF_DISTRIBUTION_GROUPS)
--- Low-level adapter for mutating procedural distribution tables.
-- Encapsulates the logic for safely appending items to a distribution table.
local ProceduralDistributionRepository = __TS__Class()
ProceduralDistributionRepository.Type = "ProceduralDistributionRepository"
__PW__BaseClassExtends(ProceduralDistributionRepository)
function ProceduralDistributionRepository.prototype.____constructor(self, list)
    self.list = list
end
function ProceduralDistributionRepository.prototype.appendItem(self, tableName, itemType, chance)
    local distribution = self.list[tableName]
    if not distribution then
        return false
    end
    __TS__ArrayPush(distribution.items, itemType, chance)
    return true
end
--- High-level orchestrator for applying BF distribution rules to the game engine.
-- Iterates through all distribution rules and applies them to their target tables.
local BFDistributionRegistrer = __TS__Class()
BFDistributionRegistrer.Type = "BFDistributionRegistrer"
__PW__BaseClassExtends(BFDistributionRegistrer)
function BFDistributionRegistrer.prototype.____constructor(self, repository, rules)
    self.repository = repository
    self.rules = rules
end
function BFDistributionRegistrer.prototype.apply(self)
    local appliedEntries = 0
    for ____, rule in ipairs(self.rules) do
        for ____, tableName in ipairs(rule.tableNames) do
            if self.repository:appendItem(tableName, rule.itemType, rule.chance) then
                appliedEntries = appliedEntries + 1
            end
        end
    end
    return appliedEntries
end
--- Applies BF distribution rules to procedural loot tables in the game engine.
-- It is automatically invoked on module load.
-- 
-- @param list - Optional distribution list to use; falls back to the global ProceduralDistributions
-- @returns Number of successful injections, or 0 if unavailable
local function applyBFDistributions(list)
    if list == nil then
        list = ProceduralDistributions.list
    end
    local repository = __TS__New(ProceduralDistributionRepository, list)
    local registrer = __TS__New(BFDistributionRegistrer, repository, BF_DISTRIBUTION_RULES)
    return registrer:apply()
end
do
    pcall(function()
        applyBFDistributions()
    end)
end
____exports.BF_DISTRIBUTION_RULES = BF_DISTRIBUTION_RULES
____exports.applyBFDistributions = applyBFDistributions
return ____exports
