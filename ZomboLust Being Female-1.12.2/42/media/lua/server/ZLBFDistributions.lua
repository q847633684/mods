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
    store = {"GigamartHousewares"},
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
    },
    drugLocations = {"DrugShackDrugs", "DerelictHouseDrugs"}
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
local ____array_2 = __TS__SparseArrayNew({tableNames = TABLE_GROUPS.bathroom, items = {
    {itemType = "ZLBF.Contraceptive", chance = 21},
    {itemType = "ZLBF.Lactaid", chance = 14},
    {itemType = "ZLBF.Condom", chance = 28},
    {itemType = "ZLBF.CondomBox", chance = 26},
    {itemType = "ZLBF.VaginalDouche", chance = 10}
}}, {tableNames = TABLE_GROUPS.bedroomSideTables, items = {{itemType = "ZLBF.Contraceptive", chance = 14}, {itemType = "ZLBF.Lactaid", chance = 7}}})
local ____array_0 = __TS__SparseArrayNew(__TS__Unpack(TABLE_GROUPS.bedroomDressers))
__TS__SparseArrayPush(
    ____array_0,
    __TS__Unpack(TABLE_GROUPS.bedroomSideTables)
)
__TS__SparseArrayPush(
    ____array_2,
    {
        tableNames = {__TS__SparseArraySpread(____array_0)},
        items = {{itemType = "ZLBF.Condom", chance = 28}, {itemType = "ZLBF.CondomBox", chance = 14}}
    }
)
local ____array_1 = __TS__SparseArrayNew(__TS__Unpack(TABLE_GROUPS.bedroomSideTables))
__TS__SparseArrayPush(____array_1, "BedroomDresserChild")
__TS__SparseArrayPush(
    ____array_2,
    {
        tableNames = {__TS__SparseArraySpread(____array_1)},
        items = {{itemType = "ZLBF.BreastPump", chance = 14}}
    },
    {tableNames = TABLE_GROUPS.hospital, items = {{itemType = "ZLBF.Contraceptive", chance = 21}, {itemType = "ZLBF.Lactaid", chance = 18}, {itemType = "ZLBF.Condom", chance = 18}}},
    {tableNames = TABLE_GROUPS.hospitalRoom, items = {{itemType = "ZLBF.CondomBox", chance = 14}, {itemType = "ZLBF.BreastPump", chance = 18}, {itemType = "ZLBF.VaginalDouche", chance = 14}}},
    {tableNames = TABLE_GROUPS.store, items = {
        {itemType = "ZLBF.Contraceptive", chance = 18},
        {itemType = "ZLBF.Lactaid", chance = 14},
        {itemType = "ZLBF.Condom", chance = 21},
        {itemType = "ZLBF.CondomBox", chance = 28},
        {itemType = "ZLBF.BreastPump", chance = 14},
        {itemType = "ZLBF.VaginalDouche", chance = 10}
    }},
    {tableNames = TABLE_GROUPS.trashBins, items = {{itemType = "ZLBF.CondomUsed", chance = 28}}},
    {tableNames = TABLE_GROUPS.drugLocations, items = {{itemType = "ZLBF.Contraceptive", chance = 10}, {itemType = "ZLBF.Lactaid", chance = 7}, {itemType = "ZLBF.Condom", chance = 18}}}
)
--- Default distribution rules for all ZLBF custom items.
-- Defines which items spawn in which procedural loot tables and at what chance weight.
local ZLBF_DISTRIBUTION_GROUPS = {__TS__SparseArraySpread(____array_2)}
local ZLBF_DISTRIBUTION_RULES = createDistributionRules(ZLBF_DISTRIBUTION_GROUPS)
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
--- High-level orchestrator for applying ZLBF distribution rules to the game engine.
-- Iterates through all distribution rules and applies them to their target tables.
local ZLBFDistributionRegistrer = __TS__Class()
ZLBFDistributionRegistrer.Type = "ZLBFDistributionRegistrer"
__PW__BaseClassExtends(ZLBFDistributionRegistrer)
function ZLBFDistributionRegistrer.prototype.____constructor(self, repository, rules)
    self.repository = repository
    self.rules = rules
end
function ZLBFDistributionRegistrer.prototype.apply(self)
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
--- Applies ZLBF distribution rules to procedural loot tables in the game engine.
-- It is automatically invoked on module load.
-- 
-- @param list - Optional distribution list to use; falls back to the global ProceduralDistributions
-- @returns Number of successful injections, or 0 if unavailable
local function applyZLBFDistributions(list)
    if list == nil then
        list = ProceduralDistributions.list
    end
    local repository = __TS__New(ProceduralDistributionRepository, list)
    local registrer = __TS__New(ZLBFDistributionRegistrer, repository, ZLBF_DISTRIBUTION_RULES)
    return registrer:apply()
end
do
    pcall(function()
        applyZLBFDistributions()
    end)
end
____exports.ZLBF_DISTRIBUTION_RULES = ZLBF_DISTRIBUTION_RULES
____exports.applyZLBFDistributions = applyZLBFDistributions
return ____exports
