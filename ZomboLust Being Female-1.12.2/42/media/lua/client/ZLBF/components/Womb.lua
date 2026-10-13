local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__New = ____lualib.__TS__New
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local __TS__ObjectDefineProperty = ____lualib.__TS__ObjectDefineProperty
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local BodyPartType = ____pipewrench.BodyPartType
local getText = ____pipewrench.getText
local triggerEvent = ____pipewrench.triggerEvent
local ZombRand = ____pipewrench.ZombRand
local ZombRandFloat = ____pipewrench.ZombRandFloat
local ____SandboxOptions = require('ZLBF/SandboxOptions')
local WombOptions = ____SandboxOptions.WombOptions
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
local ____Player = require('ZLBF/components/Player')
local Player = ____Player.Player
local _____40constants = require('constants')
local CyclePhaseEnum = _____40constants.CyclePhaseEnum
local ITEMS = _____40constants.ITEMS
local ZLBFEventsEnum = _____40constants.ZLBFEventsEnum
local ZLBFTraitsEnum = _____40constants.ZLBFTraitsEnum
local ____PregnancyState = require('ZLBF/components/PregnancyState')
local PregnancyState = ____PregnancyState.PregnancyState
local ____Utils = require('ZLBF/Utils')
local percentageToNumber = ____Utils.percentageToNumber
local trimModuleName = ____Utils.trimModuleName
--- Manages reproductive functions, fertility, and pregnancy-related variables
-- for a player character in the game. Handles cycle tracking, fertility logic.
____exports.Womb = __TS__Class()
local Womb = ____exports.Womb
Womb.Type = "Womb"
__PW__ClassExtendsPatch(Womb, Player)
__TS__ClassExtends(Womb, Player)
function Womb.prototype.____constructor(self)
    Player.prototype.____constructor(self, "ZLBFWomb")
    self.CONSTANTS = {fertilityLevel = 5}
    self.options = {recovery = WombOptions.recovery, capacity = WombOptions.capacity}
    self.Debug = {
        sperm = {
            add = function(amount)
                self.amount = math.min(self.options.capacity, self.amount + amount)
                self.total = self.total + amount
            end,
            remove = function(amount)
                local ____math_max_result_0 = math.max(0, self.amount - amount)
                self.amount = ____math_max_result_0
                return ____math_max_result_0
            end,
            set = function(amount)
                local ____amount_1 = amount
                self.amount = ____amount_1
                return ____amount_1
            end,
            setTotal = function(amount)
                local ____math_max_result_2 = math.max(0, amount)
                self.total = ____math_max_result_2
                return ____math_max_result_2
            end
        },
        cycle = {
            addDay = function(amount)
                if amount == nil then
                    amount = 1
                end
                self.contraceptive = false
                if self.cycleDay < 0 then
                    self.cycleDay = self.cycleDay + 1
                else
                    self.cycleDay = math.max(1, (self.cycleDay + amount) % 29)
                end
            end,
            nextPhase = function()
                if self.pregnancy then
                    return
                end
                if self.cycleDay < 1 then
                    self.cycleDay = 1
                elseif self.cycleDay < 6 then
                    self.cycleDay = 6
                elseif self.cycleDay < 13 then
                    self.cycleDay = 13
                elseif self.cycleDay < 16 then
                    self.cycleDay = 16
                elseif self.cycleDay < 28 then
                    self.cycleDay = 28
                else
                    self.cycleDay = 1
                end
                self.contraceptive = false
            end
        }
    }
    self.defaultData = {
        capacity = self.options.capacity,
        amount = 0,
        total = 0,
        cycleDay = ZombRand(1, 28),
        onContraceptive = false,
        chances = ____exports.Womb.chances,
        fertility = 0
    }
end
function Womb.prototype.onCreatePlayer(self, player)
    Player.prototype.onCreatePlayer(self, player)
    local ____opt_3 = self.data
    self.amount = ____opt_3 and ____opt_3.amount or 0
    Events.everyOneMinute:addListener(function() return self:onEveryMinute() end)
    Events.everyTenMinutes:addListener(function() return self:onEveryTenMinutes() end)
    Events.everyDays:addListener(function() return self:onEveryDay() end)
    __TS__New(Events.EventEmitter, ZLBFEventsEnum.PREGNANCY_UPDATE):addListener(function(data) return self:onPregnancyUpdate(data) end)
    __TS__New(Events.EventEmitter, ZLBFEventsEnum.INTERCOURSE):addListener(function() return self:intercourse() end)
    __TS__New(Events.EventEmitter, ZLBFEventsEnum.MENSTRUAL_EFFECTS):addListener(function() return self:menstruationEffects() end)
end
function Womb.prototype.intercourse(self)
    if not self.player then
        return
    end
    local amountInMilliliters = ZombRand(10, 50)
    local amount = amountInMilliliters / 1000
    self:haloText({
        text = ((getText("IGUI_ZLBF_UI_Sperm") .. " ") .. tostring(amountInMilliliters)) .. " ml",
        style = "good"
    })
    if self:hasItem(ITEMS.CONDOM) then
        local inventory = self.player:getInventory()
        inventory:Remove(trimModuleName(ITEMS.CONDOM))
        inventory:AddItem(ITEMS.CONDOM_USED)
    else
        self.amount = self.amount + amount
        self.total = self.total + amount
        if not self.pregnancy then
            self:impregnate()
        end
    end
end
function Womb.prototype.impregnate(self)
    if self.fertility <= 0 then
        return
    end
    if ZombRandFloat(0, 1) >= 1 - self.fertility then
        self:haloText({
            text = getText("IGUI_ZLBF_UI_Fertilized"),
            style = "good"
        })
        triggerEvent(ZLBFEventsEnum.PREGNANCY_START)
    end
end
function Womb.prototype.onPregnancyUpdate(self, data)
    if not self.pregnancy then
        return
    end
    self.cycleDay = -self.options.recovery
    if data.progress > 0.5 then
        self.amount = 0
    end
end
function Womb.prototype.onEveryMinute(self)
    self.fertility = self:computeFertility()
    triggerEvent(ZLBFEventsEnum.WOMB_UPDATE, self.data)
end
function Womb.prototype.onEveryTenMinutes(self)
    if self.amount <= 0 then
        return
    end
    local amount = ZombRand(0, 5) / 1000
    self.amount = self.amount - math.min(self.amount, amount)
    self:applyWetness()
end
function Womb.prototype.onEveryDay(self)
    self.cycleDay = self.cycleDay + 1
    self.contraceptive = false
    self.data.chances = ____exports.Womb.chances
    if self.phase == CyclePhaseEnum.MENSTRUATION and not self:hasTrait(ZLBFTraitsEnum.NO_MENSTRUAL_CRAMPS) then
        self:menstruationEffects()
    end
end
function Womb.prototype.computeFertilityBonus(self)
    if self:hasTrait(ZLBFTraitsEnum.FERTILE) then
        return 0.25
    end
    if self:hasTrait(ZLBFTraitsEnum.HYPERFERTILE) then
        return 0.5
    end
    return 0
end
function Womb.prototype.computeFertility(self)
    local isInfetile = self:hasTrait(ZLBFTraitsEnum.INFERTILE)
    if not self.data or isInfetile or self.contraceptive or self.pregnancy then
        return 0
    end
    local chance = self.data.chances[self.phase]
    local bonus = self:computeFertilityBonus()
    return math.min(1, chance * (1 + bonus))
end
function Womb.prototype.getCyclePhase(self, day)
    if self.pregnancy then
        return CyclePhaseEnum.PREGNANT
    end
    if day < 1 then
        return CyclePhaseEnum.RECOVERY
    end
    if day < 6 then
        return CyclePhaseEnum.MENSTRUATION
    end
    if day < 13 then
        return CyclePhaseEnum.FOLLICULAR
    end
    if day < 16 then
        return CyclePhaseEnum.OVULATION
    end
    return CyclePhaseEnum.LUTEAL
end
function Womb.prototype.applyWetness(self)
    local amount = ZombRand(10, 100)
    self:applyBodyEffect(BodyPartType.Groin, {wetness = amount})
end
function Womb.prototype.menstruationEffects(self)
    local hasStrongCramps = self:hasTrait(ZLBFTraitsEnum.STRONG_MENSTRUAL_CRAMPS)
    self:applyBodyEffect(
        BodyPartType.Groin,
        {
            bleedTime = ZombRand(1, 5),
            pain = hasStrongCramps and ZombRand(10, 25) or ZombRand(5, 15),
            maxPain = hasStrongCramps and 50 or 25
        }
    )
end
__TS__SetDescriptor(
    Womb.prototype,
    "amount",
    {
        get = function(self)
            local ____opt_5 = self.data
            return ____opt_5 and ____opt_5.amount or 0
        end,
        set = function(self, value)
            self.data.amount = value
        end
    },
    true
)
__TS__SetDescriptor(
    Womb.prototype,
    "capacity",
    {get = function(self)
        local ____opt_7 = self.data
        return ____opt_7 and ____opt_7.capacity or self.options.capacity
    end},
    true
)
__TS__ObjectDefineProperty(
    Womb,
    "chances",
    {get = function(self)
        return {
            [CyclePhaseEnum.PREGNANT] = 0,
            [CyclePhaseEnum.RECOVERY] = 0,
            [CyclePhaseEnum.MENSTRUATION] = ZombRandFloat(0, 0.3),
            [CyclePhaseEnum.FOLLICULAR] = ZombRandFloat(0, 0.4),
            [CyclePhaseEnum.OVULATION] = ZombRandFloat(0.85, 1),
            [CyclePhaseEnum.LUTEAL] = ZombRandFloat(0, 0.3)
        }
    end}
)
__TS__SetDescriptor(
    Womb.prototype,
    "contraceptive",
    {
        get = function(self)
            local ____opt_9 = self.data
            local ____temp_11 = ____opt_9 and ____opt_9.onContraceptive
            if ____temp_11 == nil then
                ____temp_11 = false
            end
            return ____temp_11
        end,
        set = function(self, value)
            self.data.onContraceptive = value
        end
    },
    true
)
__TS__SetDescriptor(
    Womb.prototype,
    "cycleDay",
    {
        get = function(self)
            local ____opt_12 = self.data
            return ____opt_12 and ____opt_12.cycleDay or 0
        end,
        set = function(self, value)
            self.data.cycleDay = value
        end
    },
    true
)
__TS__SetDescriptor(
    Womb.prototype,
    "total",
    {
        get = function(self)
            local ____opt_14 = self.data
            return ____opt_14 and ____opt_14.total or 0
        end,
        set = function(self, value)
            self.data.total = value
        end
    },
    true
)
__TS__SetDescriptor(
    Womb.prototype,
    "fertility",
    {
        get = function(self)
            local ____opt_16 = self.data
            return ____opt_16 and ____opt_16.fertility or 0
        end,
        set = function(self, value)
            self.data.fertility = value
        end
    },
    true
)
__TS__SetDescriptor(
    Womb.prototype,
    "fertilityLevelStatus",
    {get = function(self)
        repeat
            local ____switch67 = self.phase
            local ____cond67 = ____switch67 == CyclePhaseEnum.RECOVERY
            if ____cond67 then
                return "recovery"
            end
            ____cond67 = ____cond67 or ____switch67 == CyclePhaseEnum.PREGNANT
            if ____cond67 then
                local ____opt_18 = self.pregnancy
                if (____opt_18 and ____opt_18.progress or 0) >= 0.05 then
                    return "pregnant"
                end
                return "fertilized"
            end
            do
                return percentageToNumber(self.fertility * 100, self.CONSTANTS.fertilityLevel)
            end
        until true
    end},
    true
)
__TS__SetDescriptor(
    Womb.prototype,
    "phase",
    {get = function(self)
        return self:getCyclePhase(self.cycleDay)
    end},
    true
)
__TS__SetDescriptor(
    Womb.prototype,
    "phaseTranslation",
    {get = function(self)
        return ({
            [CyclePhaseEnum.RECOVERY] = "IGUI_ZLBF_UI_Recovery",
            [CyclePhaseEnum.MENSTRUATION] = "IGUI_ZLBF_UI_Menstruation",
            [CyclePhaseEnum.FOLLICULAR] = "IGUI_ZLBF_UI_Follicular",
            [CyclePhaseEnum.OVULATION] = "IGUI_ZLBF_UI_Ovulation",
            [CyclePhaseEnum.LUTEAL] = "IGUI_ZLBF_UI_Luteal",
            [CyclePhaseEnum.PREGNANT] = "IGUI_ZLBF_UI_Pregnant"
        })[self.phase]
    end},
    true
)
__TS__SetDescriptor(
    Womb.prototype,
    "pregnancy",
    {get = function(self)
        return PregnancyState:get(self.player)
    end},
    true
)
return ____exports
