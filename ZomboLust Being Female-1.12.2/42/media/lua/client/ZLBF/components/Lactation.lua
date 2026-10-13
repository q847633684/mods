local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__New = ____lualib.__TS__New
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local BodyPartType = ____pipewrench.BodyPartType
local triggerEvent = ____pipewrench.triggerEvent
local ZombRandFloat = ____pipewrench.ZombRandFloat
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
local _____40utils = require('ZLBF/Utils')
local percentageToNumber = _____40utils.percentageToNumber
local _____40constants = require('constants')
local ZLBFEventsEnum = _____40constants.ZLBFEventsEnum
local ZLBFTraitsEnum = _____40constants.ZLBFTraitsEnum
local ____SandboxOptions = require('ZLBF/SandboxOptions')
local LactationOptions = ____SandboxOptions.LactationOptions
local ____Player = require('ZLBF/components/Player')
local Player = ____Player.Player
local ____Moodles = require('ZLBF/components/Moodles')
local Moodle = ____Moodles.Moodle
local ____PregnancyState = require('ZLBF/components/PregnancyState')
local PregnancyState = ____PregnancyState.PregnancyState
--- Lactation management system for a player character.
-- Handles milk production, expiration, pregnancy influence,
-- and visual image resolution based on state.
____exports.Lactation = __TS__Class()
local Lactation = ____exports.Lactation
Lactation.Type = "Lactation"
__PW__ClassExtendsPatch(Lactation, Player)
__TS__ClassExtends(Lactation, Player)
function Lactation.prototype.____constructor(self)
    Player.prototype.____constructor(self, "ZLBFLactation")
    self._bottleAmount = 0.2
    self.CONSTANTS = {MAX_LEVEL = 5, AMOUNTS = {MIN = 0.002, MAX = 0.01}}
    self.options = {expiration = LactationOptions.expiration, capacity = LactationOptions.capacity}
    self.Debug = {
        add = function(amount)
            local ____self_0, ____milkAmount_1 = self, "milkAmount"
            local ____self_milkAmount_2 = ____self_0[____milkAmount_1] + amount
            ____self_0[____milkAmount_1] = ____self_milkAmount_2
            return ____self_milkAmount_2
        end,
        remove = function(amount)
            local ____self_3, ____milkAmount_4 = self, "milkAmount"
            local ____self_milkAmount_5 = ____self_3[____milkAmount_4] - amount
            ____self_3[____milkAmount_4] = ____self_milkAmount_5
            return ____self_milkAmount_5
        end,
        set = function(amount)
            local ____amount_6 = amount
            self.milkAmount = ____amount_6
            return ____amount_6
        end,
        toggle = function(status) return self:toggle(status) end
    }
    self.defaultData = {isActive = false, milkAmount = 0, expiration = self.options.expiration, multiplier = 0}
end
function Lactation.prototype.onCreatePlayer(self, player)
    Player.prototype.onCreatePlayer(self, player)
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
    __TS__New(Events.EventEmitter, ZLBFEventsEnum.PREGNANCY_UPDATE):addListener(function(data) return self:onPregnancyUpdate(data) end)
    __TS__New(Events.EventEmitter, ZLBFEventsEnum.LACTATION_UPDATE):addListener(function(data) return self:onLactationUpdate(data) end)
end
function Lactation.prototype.onPregnancyUpdate(self, data)
    if not self.pregnancy then
        return
    end
    local ____data_7 = data
    local progress = ____data_7.progress
    if progress < 0.5 then
        return
    end
    self:toggle(true)
    self:useMilk(0, progress)
end
function Lactation.prototype.onLactationUpdate(self, data)
    if not self.isLactating then
        return
    end
    local multiplier = 1 + self.multiplier
    local amount = ZombRandFloat(self.CONSTANTS.AMOUNTS.MIN, self.CONSTANTS.AMOUNTS.MAX) * multiplier
    self.milkAmount = math.min(self.capacity, self.milkAmount + amount)
end
function Lactation.prototype.onEveryMinute(self)
    local ____opt_8 = self.moodle
    if ____opt_8 ~= nil then
        ____opt_8:moodle(self.percentage, true)
    end
    triggerEvent(ZLBFEventsEnum.LACTATION_UPDATE, self.data)
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
    self.multiplier = math.max(0, self.multiplier - 0.1)
    self.expiration = math.max(0, self.expiration - 1)
    local ____opt_10 = self.moodle
    if ____opt_10 ~= nil then
        ____opt_10:moodle(self.percentage)
    end
    if self.expiration == 0 then
        self:toggle(false)
    end
end
function Lactation.prototype.toggle(self, status)
    self.isLactating = status
    self.expiration = self.options.expiration
    if not status then
        self.data = {isActive = false, expiration = self.options.expiration, milkAmount = 0, multiplier = 0}
        local ____opt_12 = self.moodle
        if ____opt_12 ~= nil then
            ____opt_12:moodle(0)
        end
    end
end
function Lactation.prototype.useMilk(self, amount, multiplier)
    if not self.data then
        return
    end
    amount = math.min(amount, self.milkAmount)
    self.multiplier = math.max(0, multiplier or 0)
    self.expiration = self.options.expiration
    if self:hasTrait(ZLBFTraitsEnum.DAIRY_COW) then
        self.multiplier = self.multiplier * 1.25
        self.expiration = self.expiration * 1.25
    end
    self:remove(amount)
end
function Lactation.prototype.remove(self, amount)
    self.milkAmount = math.max(0, self.milkAmount - amount)
end
__TS__SetDescriptor(
    Lactation.prototype,
    "pregnancy",
    {get = function(self)
        return PregnancyState:get(self.player)
    end},
    true
)
__TS__SetDescriptor(
    Lactation.prototype,
    "images",
    {get = function(self)
        local function getState()
            local ____opt_14 = self.pregnancy
            local progress = ____opt_14 and ____opt_14.progress or 0
            if progress < 0.4 then
                return "normal"
            end
            return "pregnant_" .. (progress < 0.7 and "early" or "late")
        end
        local state = getState()
        local fullness = self.milkAmount > self.capacity / 2 and "full" or "empty"
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
        return self.milkAmount / self.capacity * 100
    end},
    true
)
__TS__SetDescriptor(
    Lactation.prototype,
    "isLactating",
    {
        get = function(self)
            local ____opt_16 = self.data
            local ____temp_18 = ____opt_16 and ____opt_16.isActive
            if ____temp_18 == nil then
                ____temp_18 = false
            end
            return ____temp_18
        end,
        set = function(self, value)
            self.data.isActive = value
        end
    },
    true
)
__TS__SetDescriptor(
    Lactation.prototype,
    "capacity",
    {get = function(self)
        return self.options.capacity
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
            local ____opt_19 = self.data
            return ____opt_19 and ____opt_19.milkAmount or 0
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
            if self:hasTrait(ZLBFTraitsEnum.DAIRY_COW) then
                self.data.expiration = value * 1.25
            end
            self.data.expiration = value
        end
    },
    true
)
return ____exports
