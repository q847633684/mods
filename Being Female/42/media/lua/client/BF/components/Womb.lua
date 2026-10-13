local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local __TS__New = ____lualib.__TS__New
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
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
local ____SandboxOptions = require('BF/SandboxOptions')
local WombOptions = ____SandboxOptions.WombOptions
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
local ____Player = require('BF/components/Player')
local Player = ____Player.Player
local _____40constants = require('constants')
local CyclePhaseEnum = _____40constants.CyclePhaseEnum
local ITEMS = _____40constants.ITEMS
local BFEventsEnum = _____40constants.BFEventsEnum
local BFTraitsEnum = _____40constants.BFTraitsEnum
local ____PregnancyState = require('BF/components/PregnancyState')
local PregnancyState = ____PregnancyState.PregnancyState
local ____Utils = require('BF/Utils')
local percentageToNumber = ____Utils.percentageToNumber
--- Manages reproductive functions, fertility, and pregnancy-related variables
-- for a player character in the game. Handles cycle tracking, fertility logic.
____exports.Womb = __TS__Class()
local Womb = ____exports.Womb
Womb.Type = "Womb"
__PW__ClassExtendsPatch(Womb, Player)
__TS__ClassExtends(Womb, Player)
function Womb.prototype.____constructor(self, commands, snapshots, condoms)
    Player.prototype.____constructor(self, "BFWomb")
    self.commands = commands
    self.snapshots = snapshots
    self.condoms = condoms
    self.CONSTANTS = {fertilityLevel = 5}
    self.Debug = {
        sperm = {
            add = function(amount)
                self.amount = math.min(self.capacity, self.amount + amount)
                self.total = self.total + amount
                self:publishState()
            end,
            remove = function(amount)
                self.amount = math.max(0, self.amount - amount)
                self:publishState()
            end,
            set = function(amount)
                self.amount = math.max(
                    0,
                    math.min(self.capacity, amount)
                )
                self:publishState()
            end,
            setTotal = function(amount)
                self.total = math.max(0, amount)
                self:publishState()
            end
        },
        cycle = {
            addDay = function(amount)
                if amount == nil then
                    amount = 1
                end
                self.contraceptive = false
                self.cycleDay = self:advanceCycleDay(amount)
                self:publishState()
            end,
            nextPhase = function()
                if self.pregnancyData then
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
                self:publishState()
            end
        }
    }
    self.defaultData = {
        amount = 0,
        total = 0,
        cycleDay = ZombRand(1, 28),
        onContraceptive = false,
        chances = ____exports.Womb.chances,
        fertility = 0
    }
    local ____opt_0 = self.snapshots
    if ____opt_0 ~= nil then
        ____opt_0:subscribe(function(snapshot) return self:applyAuthoritativeSnapshot(snapshot) end)
    end
end
function Womb.prototype.applyAuthoritativeSnapshot(self, snapshot)
    local ____opt_2 = self.commands
    local ____temp_4 = ____opt_2 and ____opt_2.latestDesiredState or snapshot.domains.womb
    local cycleDay = ____temp_4.cycleDay
    local amount = ____temp_4.amount
    local total = ____temp_4.total
    local onContraceptive = ____temp_4.onContraceptive
    if cycleDay ~= nil then
        self.cycleDay = cycleDay
    end
    if amount ~= nil then
        self.amount = math.max(
            0,
            math.min(self.capacity, amount)
        )
    end
    if total ~= nil then
        self.total = total
    end
    if onContraceptive ~= nil then
        self.contraceptive = onContraceptive
    end
end
function Womb.prototype.publishState(self)
    local boundedAmount = __TS__NumberIsFinite(self.amount) and math.max(
        0,
        math.min(self.capacity, self.amount)
    ) or 0
    local boundedTotal = __TS__NumberIsFinite(self.total) and math.max(0, self.total) or 0
    if boundedAmount ~= self.amount then
        self.amount = boundedAmount
    end
    if boundedTotal ~= self.total then
        self.total = boundedTotal
    end
    local ____opt_5 = self.commands
    if ____opt_5 ~= nil then
        ____opt_5:publishState({cycleDay = self.cycleDay, amount = boundedAmount, total = boundedTotal, onContraceptive = self.contraceptive})
    end
end
function Womb.prototype.advanceCycleDay(self, amount)
    if amount == nil then
        amount = 1
    end
    return self.cycleDay < 0 and self.cycleDay + 1 or math.max(1, (self.cycleDay + amount) % 29)
end
function Womb.prototype.onCreatePlayer(self, player)
    Player.prototype.onCreatePlayer(self, player)
    local ____opt_7 = self.data
    self.amount = ____opt_7 and ____opt_7.amount or 0
    local ____opt_9 = self.snapshots
    local snapshot = ____opt_9 and ____opt_9.snapshot
    if snapshot then
        self:applyAuthoritativeSnapshot(snapshot)
    end
    self.amount = math.max(
        0,
        math.min(self.capacity, self.amount)
    )
    Events.everyOneMinute:addListener(function() return self:onEveryMinute() end)
    Events.everyTenMinutes:addListener(function() return self:onEveryTenMinutes() end)
    Events.everyDays:addListener(function() return self:onEveryDay() end)
    __TS__New(Events.EventEmitter, BFEventsEnum.PREGNANCY_UPDATE):addListener(function(data) return self:onPregnancyUpdate(data) end)
    __TS__New(Events.EventEmitter, BFEventsEnum.INTERCOURSE):addListener(function() return self:intercourse() end)
    __TS__New(Events.EventEmitter, BFEventsEnum.MENSTRUAL_EFFECTS):addListener(function() return self:menstruationEffects() end)
end
function Womb.prototype.intercourse(self)
    if not self.player then
        return
    end
    local amountInMilliliters = ZombRand(10, 50)
    local amount = amountInMilliliters / 1000
    self:haloText({
        text = ((getText("IGUI_BF_UI_Sperm") .. " ") .. tostring(amountInMilliliters)) .. " ml",
        style = "good"
    })
    local inventory = self.player:getInventory()
    local condom = inventory:getFirstType(ITEMS.CONDOM)
    if condom ~= nil then
        if self.condoms then
            self.condoms:convert()
        else
            inventory:Remove(condom)
            inventory:AddItem(ITEMS.CONDOM_USED)
        end
    else
        self.amount = math.min(self.capacity, self.amount + amount)
        self.total = self.total + amount
        self:publishState()
        if not self.pregnancyData then
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
            text = getText("IGUI_BF_UI_Fertilized"),
            style = "good"
        })
        triggerEvent(BFEventsEnum.PREGNANCY_START)
    end
end
function Womb.prototype.onPregnancyUpdate(self, data)
    if not self.pregnancyData then
        return
    end
    self.cycleDay = -WombOptions.wombRecovery
    if data.progress > 0.5 and self.amount > 0 then
        self.amount = 0
        self:publishState()
    end
end
function Womb.prototype.onEveryMinute(self)
    self.fertility = self:computeFertility()
    triggerEvent(
        BFEventsEnum.WOMB_UPDATE,
        __TS__ObjectAssign({}, self.data, {capacity = self.capacity})
    )
end
function Womb.prototype.onEveryTenMinutes(self)
    if self.amount <= 0 then
        return
    end
    local amount = ZombRand(0, 5) / 1000
    local removed = math.min(self.amount, amount)
    if removed > 0 then
        self.amount = self.amount - removed
        self:publishState()
    end
    self:applyWetness()
end
function Womb.prototype.onEveryDay(self)
    self.cycleDay = self:advanceCycleDay()
    self.contraceptive = false
    self:publishState()
    self.data.chances = ____exports.Womb.chances
    if self.phase == CyclePhaseEnum.MENSTRUATION and not self:hasTrait(BFTraitsEnum.NO_MENSTRUAL_CRAMPS) then
        self:menstruationEffects()
    end
end
function Womb.prototype.computeFertilityBonus(self)
    if self:hasTrait(BFTraitsEnum.FERTILE) then
        return 0.25
    end
    if self:hasTrait(BFTraitsEnum.HYPERFERTILE) then
        return 0.5
    end
    return 0
end
function Womb.prototype.computeFertility(self)
    local isInfetile = self:hasTrait(BFTraitsEnum.INFERTILE)
    if not self.data or isInfetile or self.contraceptive or self.pregnancyData then
        return 0
    end
    local chance = self.data.chances[self.phase]
    local bonus = self:computeFertilityBonus()
    return math.min(1, chance * (1 + bonus))
end
function Womb.prototype.getCyclePhase(self, day)
    if self.pregnancyData then
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
    local hasStrongCramps = self:hasTrait(BFTraitsEnum.STRONG_MENSTRUAL_CRAMPS)
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
            local ____opt_11 = self.data
            return ____opt_11 and ____opt_11.amount or 0
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
        return WombOptions.wombCapacity
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
            local ____opt_13 = self.data
            local ____temp_15 = ____opt_13 and ____opt_13.onContraceptive
            if ____temp_15 == nil then
                ____temp_15 = false
            end
            return ____temp_15
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
            local ____opt_16 = self.data
            return ____opt_16 and ____opt_16.cycleDay or 0
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
            local ____opt_18 = self.data
            return ____opt_18 and ____opt_18.total or 0
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
            local ____opt_20 = self.data
            return ____opt_20 and ____opt_20.fertility or 0
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
            local ____switch79 = self.phase
            local ____cond79 = ____switch79 == CyclePhaseEnum.RECOVERY
            if ____cond79 then
                return "recovery"
            end
            ____cond79 = ____cond79 or ____switch79 == CyclePhaseEnum.PREGNANT
            if ____cond79 then
                local ____opt_22 = self.pregnancyData
                if (____opt_22 and ____opt_22.progress or 0) >= 0.05 then
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
            [CyclePhaseEnum.RECOVERY] = "IGUI_BF_UI_Recovery",
            [CyclePhaseEnum.MENSTRUATION] = "IGUI_BF_UI_Menstruation",
            [CyclePhaseEnum.FOLLICULAR] = "IGUI_BF_UI_Follicular",
            [CyclePhaseEnum.OVULATION] = "IGUI_BF_UI_Ovulation",
            [CyclePhaseEnum.LUTEAL] = "IGUI_BF_UI_Luteal",
            [CyclePhaseEnum.PREGNANT] = "IGUI_BF_UI_Pregnant"
        })[self.phase]
    end},
    true
)
__TS__SetDescriptor(
    Womb.prototype,
    "pregnancyData",
    {get = function(self)
        return PregnancyState:get(self.player)
    end},
    true
)
return ____exports
