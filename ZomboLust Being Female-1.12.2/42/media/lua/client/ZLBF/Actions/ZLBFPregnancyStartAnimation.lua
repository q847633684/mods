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
local ZLBFEventsEnum = _____40constants.ZLBFEventsEnum
____exports.ZLBFActionPregnancyStartAnimation = __TS__Class()
local ZLBFActionPregnancyStartAnimation = ____exports.ZLBFActionPregnancyStartAnimation
ZLBFActionPregnancyStartAnimation.Type = "ZLBFActionPregnancyStartAnimation"
__PW__ClassExtendsPatch(ZLBFActionPregnancyStartAnimation, ISBaseTimedAction)
__TS__ClassExtends(ZLBFActionPregnancyStartAnimation, ISBaseTimedAction)
function ZLBFActionPregnancyStartAnimation.prototype.____constructor(self, player)
    ISBaseTimedAction.prototype.____constructor(self, player)
    self.animation = ANIMATIONS.FERTILIZATION
    ISBaseTimedAction.prototype.derive(self, "ZLBFActionPregnancyStartAnimation")
    self.maxTime = 800
    self.stopOnWalk = false
    self.stopOnRun = false
    self.stopOnAim = false
end
function ZLBFActionPregnancyStartAnimation.prototype.start(self)
    ISBaseTimedAction.prototype.start(self)
    triggerEvent(ZLBFEventsEnum.ANIMATION_START, self.animation)
end
function ZLBFActionPregnancyStartAnimation.prototype.isValid(self)
    return true
end
function ZLBFActionPregnancyStartAnimation.prototype.update(self)
    ISBaseTimedAction.prototype.update(self)
    triggerEvent(
        ZLBFEventsEnum.ANIMATION_UPDATE,
        {
            delta = self:getJobDelta(),
            duration = self.maxTime
        }
    )
end
function ZLBFActionPregnancyStartAnimation.prototype.stop(self)
    ISBaseTimedAction.prototype.stop(self)
    triggerEvent(ZLBFEventsEnum.ANIMATION_STOP)
end
function ZLBFActionPregnancyStartAnimation.prototype.perform(self)
    ISBaseTimedAction.prototype.perform(self)
    triggerEvent(ZLBFEventsEnum.ANIMATION_STOP)
end
return ____exports
