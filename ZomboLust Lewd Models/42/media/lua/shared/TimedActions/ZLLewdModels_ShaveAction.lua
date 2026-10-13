--- File: ZomboLust Lewd Models/42/media/lua/shared/TimedActions/ZLLewdModels_ShaveAction.lua
--- Implements timed actions for shaving body hair and stubble
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust Lewd Models LOADING] ZLLewdModels_ShaveAction.lua loaded")

-- Module name for logging
--- @type string
local MODULE_NAME = "ShaveAction"

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
local zlClothingChecks = require("ZLLewdModels_ClothingChecks")

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil'
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local table = table
local tostring = tostring

--- @type table<string, boolean>
local isRazor = {
    ["Base.Razor"] = true,
    ["Base.StraightRazor"] = true
}

-- ==================
-- Shave Base Action
-- ==================
-- Shared plumbing for both razor actions below: identical update/start/stop/complete and constructor setup.
-- isValid and perform stay on each subclass since that's where the two actions actually differ
-- (what they check and what they change on the character).

--- @class ZLLewdModels_ShaveBaseAction : ISBaseTimedAction
--- @field item InventoryItem
--- @field jobTextKey string -- Translation key shown as the item's job type while the action runs
ZLLewdModels_ShaveBaseAction = ISBaseTimedAction:derive("ZLLewdModels_ShaveBaseAction")

--- Updates the job delta on the item
function ZLLewdModels_ShaveBaseAction:update()
    local item = self.item
    if item then
        local getJobDelta = self.getJobDelta
        item:setJobDelta(getJobDelta(self))
    end
end

--- Sets up the animation and hand models
function ZLLewdModels_ShaveBaseAction:start()
    if self.item then
        self.item:setJobType(getText(self.jobTextKey))
        self.item:setJobDelta(0.0)
    end
    self:setActionAnim(CharacterActionAnims.Shave)
    self:setOverrideHandModelsString(self.item:getStaticModel() or "DisposableRazor", nil)
end

--- Stops the action and clears job delta
function ZLLewdModels_ShaveBaseAction:stop()
    ISBaseTimedAction.stop(self)
    if self.item then self.item:setJobDelta(0.0) end
end

--- Consumes a charge from the razor
--- @return boolean -- Always returns true to complete the action
function ZLLewdModels_ShaveBaseAction:complete()
    if self.item then
        self.item:UseAndSync()
    end
    return true
end

--- Shared constructor setup for a razor timed action
--- @param character IsoGameCharacter -- The character performing the action
--- @param item InventoryItem -- The razor item being used
--- @param jobTextKey string -- Translation key for the item's job type
--- @return ZLLewdModels_ShaveBaseAction -- The new action instance
function ZLLewdModels_ShaveBaseAction:new(character, item, jobTextKey)
    local o = ISBaseTimedAction.new(self, character)
    ---@cast o ZLLewdModels_ShaveBaseAction
    o.stopOnWalk = true
    o.stopOnRun = true
    o.item = item
    o.jobTextKey = jobTextKey
    o.maxTime = character:isTimedActionInstant() and 1 or 300
    return o
end

-- =======================
-- Shave Body Hair Action
-- =======================

--- @class ZLLewdModels_ShaveBodyHairAction : ZLLewdModels_ShaveBaseAction
--- @field choice string
--- @field bodyLocation string
ZLLewdModels_ShaveBodyHairAction = ZLLewdModels_ShaveBaseAction:derive("ZLLewdModels_ShaveBodyHairAction")

--- Checks if the action can be performed
--- @return boolean -- True if the action is valid
function ZLLewdModels_ShaveBodyHairAction:isValid()
    local item = self.item
    if item then
        local getFullType = item.getFullType
        if isRazor[getFullType(item)] and (not item:isBroken()) and item:getCurrentUses() >= 1 then
            local data = self.character:getModData().ZLLewdModels
            if not data then return false end

            local locID = zlSharedData.ModLocationID
            local bodyLocID = self.bodyLocation

            -- REALISM CHECK: Body part must be bare
            local area = nil
            if bodyLocID == "zllewdmodels:leghair" then area = "Legs"
            elseif bodyLocID == "zllewdmodels:pubichair" then area = "Pubic"
            elseif bodyLocID == "zllewdmodels:armpithair" or bodyLocID == "zllewdmodels:chesthair" then area = "Armpits" end

            if area and zlClothingChecks.isAreaCovered(self.character, area) then
                return false
            end

            if locID[bodyLocID] and data[locID[bodyLocID]] ~= "None" then
                if self.choice == "None" then return true end

                -- Validate special shave options (strip, trimmed)
                local gender = self.character:isFemale() and "Female" or "Male"
                local currentStyle = data[locID[bodyLocID]]
                local shaveTable = zlSharedData.ShaveTable[gender]
                if shaveTable and shaveTable[currentStyle] then
                    local options = shaveTable[currentStyle]
                    for i = 1, #options do
                        local v = options[i]
                        if v.canBeShavedTo == self.choice then return true end
                    end
                end
            end
        end
    end
    return false
end

--- Applies the changes to body hair state
function ZLLewdModels_ShaveBodyHairAction:perform()
    if self.item then self.item:setJobDelta(0.0) end

    if dbg() then
        ZLLewdModels.debugLog(MODULE_NAME, "ShaveBodyHairAction: Shaving %s to %s", tostring(self.bodyLocation), tostring(self.choice))
    end

    local locID = zlSharedData.ModLocationID
    local bodyLocID = self.bodyLocation
    local data = self.character:getModData().ZLLewdModels

    if not data then
        ZLLewdModels.errorLog(MODULE_NAME, "perform: ModData is nil for %s", tostring(self.character:getFullName()))
        return
    end

    if not locID[bodyLocID] then
        ZLLewdModels.errorLog(MODULE_NAME, "perform: Invalid bodyLocation %s", tostring(bodyLocID))
        return
    end

    data.DaysTilGrow[locID[bodyLocID]] = zlSharedData.rollHairGrowthDays(locID[bodyLocID], false)
    data[locID[bodyLocID]] = self.choice

    local queue = {
        {functionName = "EquipBodyHair", args = {bodyLocation = bodyLocID}},
    }
    manageBody.executeQueue(self.character, queue, true)

    ISBaseTimedAction.perform(self)
end

--- Constructor for the shave body hair action
--- @param character IsoGameCharacter -- The character performing the action
--- @param choice string -- The target hair style ID (e.g., 'None')
--- @param bodyLocation string -- Resource ID of the body location
--- @param item InventoryItem -- The razor item being used
--- @return ZLLewdModels_ShaveBodyHairAction -- The new action instance
function ZLLewdModels_ShaveBodyHairAction:new(character, choice, bodyLocation, item)
    local o = ZLLewdModels_ShaveBaseAction.new(self, character, item, "UI_ZLLewdModels_ShaveJob")
    ---@cast o ZLLewdModels_ShaveBodyHairAction
    o.choice = choice
    o.bodyLocation = bodyLocation
    return o
end

-- =====================
-- Shave Stubble Action
-- =====================

--- @class ZLLewdModels_ShaveStubbleAction : ZLLewdModels_ShaveBaseAction
--- @field isBeard boolean
ZLLewdModels_ShaveStubbleAction = ZLLewdModels_ShaveBaseAction:derive("ZLLewdModels_ShaveStubbleAction")

--- Checks if the action can be performed
--- @return boolean -- True if the character has stubble and a razor
function ZLLewdModels_ShaveStubbleAction:isValid()
    local data = self.character:getModData().ZLLewdModels
    if not data then return false end

    local item = self.item
    if item and self.character:getInventory():contains(item) then
        local getFullType = item.getFullType
        if isRazor[getFullType(item)] and (not item:isBroken()) and item:getCurrentUses() >= 1 then
            if self.isBeard then
                local visual = self.character:getHumanVisual()
                local getBeardModel = visual.getBeardModel
                local currentBeard = getBeardStylesInstance():FindStyle(getBeardModel(visual))
                local beardID = currentBeard and currentBeard:getName() or nil
                if data.BeardStubble == 1 and (not zlSharedData.FullBeards[beardID]) then
                    return true
                end
            else
                -- REALISM CHECK: Head must be bare for head stubble
                if zlClothingChecks.isAreaCovered(self.character, "Head") then
                    return false
                end

                if data.HeadStubble == 1 and self.character:getHumanVisual():getHairModel() == "Bald" then
                    return true
                end
            end
        end
    end

    return false
end

--- Applies the changes to stubble state
function ZLLewdModels_ShaveStubbleAction:perform()
    if self.item then self.item:setJobDelta(0.0) end

    local data = self.character:getModData().ZLLewdModels
    if not data then
        ZLLewdModels.errorLog(MODULE_NAME, "perform: ModData is nil for %s", tostring(self.character:getFullName()))
        return
    end

    local queue = {}

    if self.isBeard then
        ZLLewdModels.debugLog(MODULE_NAME, "ShaveStubbleAction: Shaving beard stubble")
        self.character:resetBeardGrowingTime()
        data.BeardStubble = 0
        data.DaysTilGrow.BeardStubble = zlSharedData.rollBeardStubbleDays()
        table.insert(queue, {functionName = "EquipBeardStubble", args = {}})
    else
        ZLLewdModels.debugLog(MODULE_NAME, "ShaveStubbleAction: Shaving head stubble")
        self.character:resetHairGrowingTime()
        data.HeadStubble = 0
        data.DaysTilGrow.HeadStubble = zlSharedData.rollHeadStubbleDays()
        table.insert(queue, {functionName = "EquipHeadStubble", args = {}})
    end

    manageBody.executeQueue(self.character, queue, true)

    ISBaseTimedAction.perform(self)
end

--- Consumes a charge from the razor and resets growth time
--- @return boolean -- Always returns true to complete the action
function ZLLewdModels_ShaveStubbleAction:complete()
    ZLLewdModels_ShaveBaseAction.complete(self)
    if self.isBeard then
        self.character:resetBeardGrowingTime()
    else
        self.character:resetHairGrowingTime()
    end
    return true
end

--- Constructor for the shave stubble action
--- @param character IsoGameCharacter -- The character performing the action
--- @param isBeard boolean -- True for beard, false for head
--- @param item InventoryItem -- The razor item being used
--- @return ZLLewdModels_ShaveStubbleAction -- The new action instance
function ZLLewdModels_ShaveStubbleAction:new(character, isBeard, item)
    local o = ZLLewdModels_ShaveBaseAction.new(self, character, item, "UI_ZLLewdModels_ShaveStubbleJob")
    ---@cast o ZLLewdModels_ShaveStubbleAction
    o.isBeard = isBeard
    return o
end
