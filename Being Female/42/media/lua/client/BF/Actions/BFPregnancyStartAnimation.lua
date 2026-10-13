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
local BFEventsEnum = _____40constants.BFEventsEnum
____exports.BFActionPregnancyStartAnimation = __TS__Class()
local BFActionPregnancyStartAnimation = ____exports.BFActionPregnancyStartAnimation
BFActionPregnancyStartAnimation.Type = "BFActionPregnancyStartAnimation"
__PW__ClassExtendsPatch(BFActionPregnancyStartAnimation, ISBaseTimedAction)
__TS__ClassExtends(BFActionPregnancyStartAnimation, ISBaseTimedAction)
function BFActionPregnancyStartAnimation.prototype.____constructor(self, player)
    ISBaseTimedAction.prototype.____constructor(self, player)
    self.animation = ANIMATIONS.FERTILIZATION
    ISBaseTimedAction.prototype.derive(self, "BFActionPregnancyStartAnimation")
    self.maxTime = 800
    self.stopOnWalk = false
    self.stopOnRun = false
    self.stopOnAim = false
end
function BFActionPregnancyStartAnimation.prototype.start(self)
    ISBaseTimedAction.prototype.start(self)
    triggerEvent(BFEventsEnum.ANIMATION_START, self.animation)
end
function BFActionPregnancyStartAnimation.prototype.isValid(self)
    return true
end
function BFActionPregnancyStartAnimation.prototype.update(self)
    ISBaseTimedAction.prototype.update(self)
    triggerEvent(
        BFEventsEnum.ANIMATION_UPDATE,
        {
            delta = self:getJobDelta(),
            duration = self.maxTime
        }
    )
end
function BFActionPregnancyStartAnimation.prototype.stop(self)
    ISBaseTimedAction.prototype.stop(self)
    triggerEvent(BFEventsEnum.ANIMATION_STOP)
end
function BFActionPregnancyStartAnimation.prototype.perform(self)
    ISBaseTimedAction.prototype.perform(self)
    triggerEvent(BFEventsEnum.ANIMATION_STOP)
end
return ____exports
