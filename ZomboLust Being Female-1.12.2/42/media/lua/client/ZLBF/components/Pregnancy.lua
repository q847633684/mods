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
local ZombRand = ____pipewrench.ZombRand
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
local ____client = require('lua_modules/@asledgehammer/pipewrench/client')
local ISTimedActionQueue = ____client.ISTimedActionQueue
local _____40constants = require('constants')
local ITEMS = _____40constants.ITEMS
local ZLBFEventsEnum = _____40constants.ZLBFEventsEnum
local ZLBFTraitsEnum = _____40constants.ZLBFTraitsEnum
local ____ZLBFBirth = require('ZLBF/Actions/ZLBFBirth')
local ZLBFActionBirth = ____ZLBFBirth.ZLBFActionBirth
local ____ZLBFPregnancyStartAnimation = require('ZLBF/Actions/ZLBFPregnancyStartAnimation')
local ZLBFActionPregnancyStartAnimation = ____ZLBFPregnancyStartAnimation.ZLBFActionPregnancyStartAnimation
local ____Player = require('ZLBF/components/Player')
local Player = ____Player.Player
local ____Moodles = require('ZLBF/components/Moodles')
local Moodle = ____Moodles.Moodle
local ____PregnancyState = require('ZLBF/components/PregnancyState')
local PregnancyState = ____PregnancyState.PregnancyState
local ____SandboxOptions = require('ZLBF/SandboxOptions')
local PregnancyOptions = ____SandboxOptions.PregnancyOptions
____exports.Pregnancy = __TS__Class()
local Pregnancy = ____exports.Pregnancy
Pregnancy.Type = "Pregnancy"
__PW__ClassExtendsPatch(Pregnancy, Player)
__TS__ClassExtends(Pregnancy, Player)
function Pregnancy.prototype.____constructor(self)
    Player.prototype.____constructor(self)
    self.Debug = {
        advance = function(minutes)
            if not self.pregnancy then
                return
            end
            local ____self_pregnancy_0 = self.pregnancy
            local current = ____self_pregnancy_0.current
            local duration = self.duration
            local updated = math.min(duration, current + minutes)
            PregnancyState:set(self.player, {current = updated, progress = updated / duration, isInLabor = updated == duration})
        end,
        advanceToLabor = function()
            if not self.pregnancy then
                return
            end
            local ____self_pregnancy_1 = self.pregnancy
            local current = ____self_pregnancy_1.current
            if current == nil then
                current = 0
            end
            local duration = self.duration
            self.Debug.advance(duration - current - 1)
        end
    }
end
function Pregnancy.prototype.onCreatePlayer(self, player)
    Player.prototype.onCreatePlayer(self, player)
    PregnancyState:initialize(player)
    self.moodle = __TS__New(Moodle, {
        player = player,
        name = "Pregnancy",
        type = "Good",
        texture = "media/ui/Moodles/Pregnancy.png",
        tresholds = {0.3, 0.6, 0.8, 0.9}
    })
    Events.everyOneMinute:addListener(function() return self:onEveryMinute() end)
    Events.everyHours:addListener(function() return self:onEveryHour() end)
    Events.everyDays:addListener(function() return self:onEveryDay() end)
    __TS__New(Events.EventEmitter, ZLBFEventsEnum.PREGNANCY_START):addListener(function() return self:start() end)
    __TS__New(Events.EventEmitter, ZLBFEventsEnum.PREGNANCY_STOP):addListener(function() return self:stop() end)
    __TS__New(Events.EventEmitter, ZLBFEventsEnum.PREGNANCY_LABOR):addListener(function(delta) return self:onLabor(delta) end)
end
function Pregnancy.prototype.resetVariables(self)
    PregnancyState:set(self.player, {progress = 0, current = 0, isInLabor = false})
    local ____opt_2 = self.moodle
    if ____opt_2 ~= nil then
        ____opt_2:moodle(0)
    end
end
function Pregnancy.prototype.start(self)
    self:addTrait(ZLBFTraitsEnum.PREGNANCY)
    self:resetVariables()
    if self.player then
        ISTimedActionQueue.add(__TS__New(ZLBFActionPregnancyStartAnimation, self.player))
    end
end
function Pregnancy.prototype.stop(self)
    self:removeTrait(ZLBFTraitsEnum.PREGNANCY)
    self:resetVariables()
end
function Pregnancy.prototype.onLabor(self, _delta)
    self:applyBodyEffect(BodyPartType.Groin, {pain = 1, maxPain = 30})
end
function Pregnancy.prototype.onEveryMinute(self)
    if not self.pregnancy then
        return
    end
    local duration = self.duration
    local ____self_pregnancy_4 = self.pregnancy
    local current = ____self_pregnancy_4.current
    local ____self_pregnancy_isInLabor_5 = self.pregnancy.isInLabor
    if ____self_pregnancy_isInLabor_5 == nil then
        ____self_pregnancy_isInLabor_5 = false
    end
    local previousInLabor = ____self_pregnancy_isInLabor_5
    local updated = current + 1 > duration and duration or current + 1
    local isInLabor = updated == duration
    PregnancyState:set(self.player, {current = updated, progress = updated / duration, isInLabor = isInLabor})
    if isInLabor and not previousInLabor then
        self.player:setBlockMovement(true)
        ISTimedActionQueue.add(__TS__New(ZLBFActionBirth, self))
    end
    local ____opt_6 = self.moodle
    if ____opt_6 ~= nil then
        ____opt_6:moodle(self.pregnancy.progress, true)
    end
    triggerEvent(ZLBFEventsEnum.PREGNANCY_UPDATE, self.pregnancy)
end
function Pregnancy.prototype.onEveryHour(self)
    if not self.pregnancy then
        return
    end
    local ____self_pregnancy_8 = self.pregnancy
    local progress = ____self_pregnancy_8.progress
    local ____opt_9 = self.moodle
    if ____opt_9 ~= nil then
        ____opt_9:moodle(progress)
    end
    if progress < 0.25 then
        return
    end
    local stats = self.player:getStats()
    local water = 0.5 * progress / 1440
    stats:set(
        CharacterStat.THIRST,
        math.min(
            1,
            stats:get(CharacterStat.THIRST) + water
        )
    )
    local nutrition = self.player:getNutrition()
    local calories = 600 * progress / 1440
    nutrition:setCalories(math.max(
        -2200,
        nutrition:getCalories() - calories
    ))
end
function Pregnancy.prototype.onEveryDay(self)
    if not self.pregnancy then
        return
    end
    local ____self_pregnancy_11 = self.pregnancy
    local progress = ____self_pregnancy_11.progress
    if progress < 0.05 or progress > 0.33 then
        return
    end
    self.player:getBodyDamage():setFoodSicknessLevel(50 + ZombRand(0, 50))
end
function Pregnancy.prototype.birth(self)
    if not self.player then
        return
    end
    self.player:getInventory():AddItem(ITEMS.BABY)
    self.player:setBlockMovement(false)
    self:applyStatEffect({stat = "FATIGUE", value = 0.75, maxValue = 0.75})
    self:stop()
end
__TS__SetDescriptor(
    Pregnancy.prototype,
    "duration",
    {get = function(self)
        return PregnancyOptions.duration
    end},
    true
)
__TS__SetDescriptor(
    Pregnancy.prototype,
    "pregnancy",
    {get = function(self)
        return PregnancyState:get(self.player)
    end},
    true
)
return ____exports
