local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local ISBaseTimedAction = ____pipewrench.ISBaseTimedAction
local triggerEvent = ____pipewrench.triggerEvent
local ____Animation = require('BF/components/Animation')
local ANIMATIONS = ____Animation.ANIMATIONS
local _____40constants = require('constants')
local BFAnimations = _____40constants.BFAnimations
local BFEventsEnum = _____40constants.BFEventsEnum
____exports.BFActionBirth = __TS__Class()
local BFActionBirth = ____exports.BFActionBirth
BFActionBirth.Type = "BFActionBirth"
__PW__ClassExtendsPatch(BFActionBirth, ISBaseTimedAction)
__TS__ClassExtends(BFActionBirth, ISBaseTimedAction)
function BFActionBirth.prototype.____constructor(self, pregnancy, birthId)
    ISBaseTimedAction.prototype.____constructor(self, pregnancy.player)
    ISBaseTimedAction.prototype.derive(self, "BFActionBirth")
    self.pregnancy = pregnancy
    self.birthId = birthId
    self.maxTime = 5500
    self.stopOnWalk = false
    self.stopOnRun = false
    self.stopOnAim = false
end
function BFActionBirth.prototype.isValid(self)
    return true
end
function BFActionBirth.prototype.start(self)
    ISBaseTimedAction.prototype.start(self)
    self:setActionAnim(BFAnimations.BIRTH, nil)
    triggerEvent(BFEventsEnum.ANIMATION_START, ANIMATIONS.BIRTH)
end
function BFActionBirth.prototype.update(self)
    ISBaseTimedAction.prototype.update(self)
    local delta = self:getJobDelta()
    triggerEvent(BFEventsEnum.PREGNANCY_LABOR, delta)
    triggerEvent(BFEventsEnum.ANIMATION_UPDATE, {delta = delta, duration = self.maxTime})
end
function BFActionBirth.prototype.stop(self)
    ISBaseTimedAction.prototype.stop(self)
    triggerEvent(BFEventsEnum.ANIMATION_STOP)
    self.pregnancy:onBirthPresentationStopped(self.birthId)
end
function BFActionBirth.prototype.perform(self)
    ISBaseTimedAction.prototype.perform(self)
    self.pregnancy:birth(self.birthId)
    triggerEvent(BFEventsEnum.ANIMATION_STOP)
end
return ____exports
