local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__New = ____lualib.__TS__New
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local BodyPartType = ____pipewrench.BodyPartType
local getGameTime = ____pipewrench.getGameTime
local triggerEvent = ____pipewrench.triggerEvent
local ZombRandFloat = ____pipewrench.ZombRandFloat
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
local _____40utils = require('BF/Utils')
local percentageToNumber = _____40utils.percentageToNumber
local _____40constants = require('constants')
local BFEventsEnum = _____40constants.BFEventsEnum
local BFTraitsEnum = _____40constants.BFTraitsEnum
local ____SandboxOptions = require('BF/SandboxOptions')
local LactationOptions = ____SandboxOptions.LactationOptions
local ____Player = require('BF/components/Player')
local Player = ____Player.Player
local ____Moodles = require('BF/components/Moodles')
local Moodle = ____Moodles.Moodle
local ____PregnancyState = require('BF/components/PregnancyState')
local PregnancyState = ____PregnancyState.PregnancyState
local ____LactationBalance = require('domain/lactation/LactationBalance')
local applyMilkRemoval = ____LactationBalance.applyMilkRemoval
local clampStimulation = ____LactationBalance.clampStimulation
local decayStimulation = ____LactationBalance.decayStimulation
local lactationDuration = ____LactationBalance.lactationDuration
local LACTATION_BALANCE = ____LactationBalance.LACTATION_BALANCE
local metabolicCostFor = ____LactationBalance.metabolicCostFor
local requestedProduction = ____LactationBalance.requestedProduction
--- Lactation management system for a player character.
-- Handles milk production, expiration, pregnancy influence,
-- and visual image resolution based on state.
____exports.Lactation = __TS__Class()
local Lactation = ____exports.Lactation
Lactation.Type = "Lactation"
__PW__ClassExtendsPatch(Lactation, Player)
__TS__ClassExtends(Lactation, Player)
function Lactation.prototype.____constructor(self, snapshots, commands)
    Player.prototype.____constructor(self, "BFLactation")
    self.snapshots = snapshots
    self.commands = commands
    self._bottleAmount = 0.2
    self.publicationSuppressed = false
    self.CONSTANTS = {MAX_LEVEL = 5, AMOUNTS = {MIN = LACTATION_BALANCE.BASE_RATE_MIN, MAX = LACTATION_BALANCE.BASE_RATE_MAX}}
    self.Debug = {
        add = function(amount)
            self.milkAmount = self.milkAmount + amount
            self:publishState({milkAmount = {mode = "delta", value = amount}})
        end,
        remove = function(amount)
            self.milkAmount = self.milkAmount - amount
            self:publishState({milkAmount = {mode = "delta", value = -amount}})
        end,
        set = function(amount)
            self.milkAmount = amount
            self:publishState({milkAmount = {mode = "replace", value = self.milkAmount}})
        end,
        toggle = function(status) return self:toggle(status) end
    }
    self.defaultData = {isActive = false, milkAmount = 0, expiration = LactationOptions.milkExpiration, multiplier = 0}
    local ____opt_0 = self.snapshots
    if ____opt_0 ~= nil then
        ____opt_0:subscribe(function(snapshot) return self:applyAuthoritativeSnapshot(snapshot) end)
    end
end
function Lactation.prototype.applyAuthoritativeSnapshot(self, snapshot)
    local ____opt_2 = self.commands
    local lactation = ____opt_2 and ____opt_2.latestDesiredState or snapshot.domains.lactation
    self.data = __TS__ObjectAssign(
        {},
        lactation,
        {
            milkAmount = math.max(
                0,
                math.min(self.lactationCapacity, lactation.milkAmount)
            ),
            multiplier = clampStimulation(lactation.multiplier)
        }
    )
end
function Lactation.prototype.publishState(self, intent)
    if not self.publicationSuppressed and self.data then
        local ____opt_4 = self.commands
        if ____opt_4 ~= nil then
            ____opt_4:publishState(
                __TS__ObjectAssign({}, self.data),
                intent
            )
        end
    end
end
function Lactation.prototype.applyMutation(self, mutate, intent)
    self.publicationSuppressed = true
    mutate()
    self.publicationSuppressed = false
    self:publishState(intent())
end
function Lactation.prototype.onCreatePlayer(self, player)
    self.defaultData.expiration = LactationOptions.milkExpiration
    Player.prototype.onCreatePlayer(self, player)
    self.lastMinuteStamp = getGameTime():getMinutesStamp()
    local ____opt_6 = self.snapshots
    local snapshot = ____opt_6 and ____opt_6.snapshot
    if snapshot then
        self:applyAuthoritativeSnapshot(snapshot)
    end
    self.milkAmount = math.max(
        0,
        math.min(self.lactationCapacity, self.milkAmount)
    )
    self.moodle = __TS__New(Moodle, {
        player = player,
        name = "Engorgement",
        type = "Bad",
        texture = "media/ui/Moodles/Engorgement.png",
        tresholds = {0.3, 0.6, 0.8, 0.9}
    })
    Events.everyOneMinute:addListener(function() return self:onEveryMinute() end)
    Events.everyTenMinutes:addListener(function() return self:onEveryTenMinutes() end)
    Events.everyHours:addListener(function() return self:onEveryHour() end)
    __TS__New(Events.EventEmitter, BFEventsEnum.PREGNANCY_UPDATE):addListener(function(data) return self:onPregnancyUpdate(data) end)
end
function Lactation.prototype.onPregnancyUpdate(self, data)
    if not self.lactationPregnancyData then
        return
    end
    local ____data_8 = data
    local progress = ____data_8.progress
    if progress < 0.5 then
        return
    end
    self:applyMutation(
        function()
            self:toggle(true)
        end,
        function() return {isActive = {mode = "replace", value = true}, expiration = {mode = "replace", value = self.expiration}} end
    )
end
function Lactation.prototype.onEveryMinute(self)
    local ____opt_9 = self.commands
    if ____opt_9 ~= nil then
        ____opt_9:onEveryOneMinute()
    end
    local minuteStamp = getGameTime():getMinutesStamp()
    local elapsed = math.max(0, minuteStamp - (self.lastMinuteStamp or minuteStamp - 1))
    self.lastMinuteStamp = minuteStamp
    if self.isLactating and elapsed > 0 then
        self:produce(elapsed)
    end
    local ____opt_11 = self.moodle
    if ____opt_11 ~= nil then
        ____opt_11:moodle(self.percentage, true)
    end
    triggerEvent(BFEventsEnum.LACTATION_UPDATE, self.data)
end
function Lactation.prototype.produce(self, elapsedMinutes)
    local previousMilk = self.milkAmount
    local previousMultiplier = self.multiplier
    local previousExpiration = self.expiration
    local activeMinutes = math.min(elapsedMinutes, previousExpiration * 60)
    local hasDairyCow = self:hasTrait(BFTraitsEnum.DAIRY_COW)
    local requested = requestedProduction({
        baseRatePerMinute = ZombRandFloat(self.CONSTANTS.AMOUNTS.MIN, self.CONSTANTS.AMOUNTS.MAX),
        elapsedMinutes = activeMinutes,
        stimulation = previousMultiplier,
        hasDairyCow = hasDairyCow,
        thirst = self:getStatValue("THIRST"),
        hunger = self:getStatValue("HUNGER")
    })
    self.milkAmount = math.min(self.lactationCapacity, previousMilk + requested)
    local produced = self.milkAmount - previousMilk
    self.multiplier = decayStimulation(previousMultiplier, activeMinutes)
    self.expiration = math.max(0, previousExpiration - elapsedMinutes / 60)
    if produced > 0 then
        local cost = metabolicCostFor(produced)
        self:applyStatEffect({stat = "THIRST", value = cost.thirst, maxValue = 1})
        self:applyNutritionEffect({calories = -cost.calories, carbohydrates = -cost.carbohydrates, lipids = -cost.lipids, proteins = -cost.proteins})
    end
    local expired = self.expiration == 0
    if expired then
        self:resetInactiveState()
        local ____opt_13 = self.moodle
        if ____opt_13 ~= nil then
            ____opt_13:moodle(0)
        end
    end
    self:publishState({isActive = expired and ({mode = "replace", value = false}) or nil, milkAmount = expired and ({mode = "replace", value = 0}) or ({mode = "delta", value = self.milkAmount - previousMilk}), expiration = expired and ({mode = "replace", value = self.expiration}) or ({mode = "delta", value = self.expiration - previousExpiration}), multiplier = expired and ({mode = "replace", value = 0}) or ({mode = "delta", value = self.multiplier - previousMultiplier})})
end
function Lactation.prototype.onEveryTenMinutes(self)
    if not self.isLactating then
        return
    end
    local modifier = percentageToNumber(self.percentage, 25)
    self:applyBodyEffect(BodyPartType.Torso_Upper, {pain = modifier, maxPain = 10, wetness = modifier})
end
function Lactation.prototype.onEveryHour(self)
    if not self.isLactating then
        return
    end
    local ____opt_15 = self.moodle
    if ____opt_15 ~= nil then
        ____opt_15:moodle(self.percentage)
    end
end
function Lactation.prototype.toggle(self, status)
    self.isLactating = status
    self.expiration = self.refreshedDuration
    if not status then
        self:resetInactiveState()
        local ____opt_17 = self.moodle
        if ____opt_17 ~= nil then
            ____opt_17:moodle(0)
        end
    end
    local ____self_publishState_23 = self.publishState
    local ____temp_21 = {mode = "replace", value = self.isLactating}
    local ____temp_22 = {mode = "replace", value = self.expiration}
    local ____status_19
    if status then
        ____status_19 = nil
    else
        ____status_19 = {mode = "replace", value = self.milkAmount}
    end
    local ____status_20
    if status then
        ____status_20 = nil
    else
        ____status_20 = {mode = "replace", value = self.multiplier}
    end
    ____self_publishState_23(self, {isActive = ____temp_21, expiration = ____temp_22, milkAmount = ____status_19, multiplier = ____status_20})
end
function Lactation.prototype.useMilk(self, amount)
    if not self.data then
        return
    end
    local previousMilk = self.milkAmount
    local previousMultiplier = self.multiplier
    local next = applyMilkRemoval(self.data, amount, self.refreshedDuration)
    self.milkAmount = next.milkAmount
    self.expiration = next.expiration
    self.multiplier = next.multiplier
    local removed = previousMilk - self.milkAmount
    self:publishState({milkAmount = {mode = "delta", value = -removed}, expiration = removed > 0 and ({mode = "replace", value = self.expiration}) or nil, multiplier = {mode = "delta", value = self.multiplier - previousMultiplier}})
end
function Lactation.prototype.resetInactiveState(self)
    self.isLactating = false
    self.milkAmount = 0
    self.expiration = LactationOptions.milkExpiration
    self.multiplier = 0
end
__TS__SetDescriptor(
    Lactation.prototype,
    "lactationPregnancyData",
    {get = function(self)
        return PregnancyState:get(self.player)
    end},
    true
)
__TS__SetDescriptor(
    Lactation.prototype,
    "refreshedDuration",
    {get = function(self)
        return lactationDuration(
            LactationOptions.milkExpiration,
            self:hasTrait(BFTraitsEnum.DAIRY_COW)
        )
    end},
    true
)
__TS__SetDescriptor(
    Lactation.prototype,
    "images",
    {get = function(self)
        local function getState()
            local ____opt_24 = self.lactationPregnancyData
            local progress = ____opt_24 and ____opt_24.progress or 0
            if progress < 0.4 then
                return "normal"
            end
            return "pregnant_" .. (progress < 0.7 and "early" or "late")
        end
        local state = getState()
        local fullness = self.milkAmount > self.lactationCapacity / 2 and "full" or "empty"
        local level = percentageToNumber(self.percentage, self.CONSTANTS.MAX_LEVEL)
        return {
            breasts = ((((("media/ui/lactation/boobs/color-" .. tostring(self.skinColorIndex)) .. "/") .. state) .. "_") .. fullness) .. ".png",
            level = ("media/ui/lactation/level/milk_level_" .. tostring(level)) .. ".png"
        }
    end},
    true
)
__TS__SetDescriptor(
    Lactation.prototype,
    "percentage",
    {get = function(self)
        return self.milkAmount / self.lactationCapacity * 100
    end},
    true
)
__TS__SetDescriptor(
    Lactation.prototype,
    "isLactating",
    {
        get = function(self)
            local ____opt_26 = self.data
            local ____temp_28 = ____opt_26 and ____opt_26.isActive
            if ____temp_28 == nil then
                ____temp_28 = false
            end
            return ____temp_28
        end,
        set = function(self, value)
            self.data.isActive = value
        end
    },
    true
)
__TS__SetDescriptor(
    Lactation.prototype,
    "lactationCapacity",
    {get = function(self)
        return LactationOptions.milkCapacity
    end},
    true
)
__TS__SetDescriptor(
    Lactation.prototype,
    "bottleAmount",
    {get = function(self)
        return self._bottleAmount
    end},
    true
)
__TS__SetDescriptor(
    Lactation.prototype,
    "milkAmount",
    {
        get = function(self)
            local ____opt_29 = self.data
            return ____opt_29 and ____opt_29.milkAmount or 0
        end,
        set = function(self, amount)
            self.data.milkAmount = amount
        end
    },
    true
)
__TS__SetDescriptor(
    Lactation.prototype,
    "multiplier",
    {
        get = function(self)
            return self.data.multiplier
        end,
        set = function(self, value)
            self.data.multiplier = value
        end
    },
    true
)
__TS__SetDescriptor(
    Lactation.prototype,
    "expiration",
    {
        get = function(self)
            return self.data.expiration
        end,
        set = function(self, value)
            self.data.expiration = value
        end
    },
    true
)
return ____exports
