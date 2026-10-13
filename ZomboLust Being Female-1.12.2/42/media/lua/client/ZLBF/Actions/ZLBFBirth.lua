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
local ____Animation = require('ZLBF/components/Animation')
local ANIMATIONS = ____Animation.ANIMATIONS
local _____40constants = require('constants')
local ZLBFAnimations = _____40constants.ZLBFAnimations
local ZLBFEventsEnum = _____40constants.ZLBFEventsEnum
____exports.ZLBFActionBirth = __TS__Class()
local ZLBFActionBirth = ____exports.ZLBFActionBirth
ZLBFActionBirth.Type = "ZLBFActionBirth"
__PW__ClassExtendsPatch(ZLBFActionBirth, ISBaseTimedAction)
__TS__ClassExtends(ZLBFActionBirth, ISBaseTimedAction)
function ZLBFActionBirth.prototype.____constructor(self, pregnancy)
    ISBaseTimedAction.prototype.____constructor(self, pregnancy.player)
    ISBaseTimedAction.prototype.derive(self, "ZLBFActionBirth")
    self.pregnancy = pregnancy
    self.maxTime = 5500
    self.stopOnWalk = false
    self.stopOnRun = false
    self.stopOnAim = false
end
function ZLBFActionBirth.prototype.isValid(self)
    return true
end
function ZLBFActionBirth.prototype.start(self)
    ISBaseTimedAction.prototype.start(self)
    self:setActionAnim(ZLBFAnimations.BIRTH, nil)
    triggerEvent(ZLBFEventsEnum.ANIMATION_START, ANIMATIONS.BIRTH)
end
function ZLBFActionBirth.prototype.update(self)
    ISBaseTimedAction.prototype.update(self)
    local delta = self:getJobDelta()
    triggerEvent(ZLBFEventsEnum.PREGNANCY_LABOR, delta)
    triggerEvent(ZLBFEventsEnum.ANIMATION_UPDATE, {delta = delta, duration = self.maxTime})
end
function ZLBFActionBirth.prototype.stop(self)
    triggerEvent(ZLBFEventsEnum.ANIMATION_STOP)
end
function ZLBFActionBirth.prototype.perform(self)
    ISBaseTimedAction.prototype.perform(self)
    self.pregnancy:birth()
    triggerEvent(ZLBFEventsEnum.ANIMATION_STOP)
end
return ____exports
