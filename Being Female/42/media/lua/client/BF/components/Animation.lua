local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local ZombRandBetween = ____pipewrench.ZombRandBetween
local getTexture = ____pipewrench.getTexture
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
local ____Utils = require('BF/Utils')
local percentageToNumber = ____Utils.percentageToNumber
local _____40constants = require('constants')
local ITEMS = _____40constants.ITEMS
local BFEventsEnum = _____40constants.BFEventsEnum
local ____AnimationRegistry = require('BF/components/AnimationRegistry')
local animationRegistry = ____AnimationRegistry.animationRegistry
do
    local ____AnimationRegistry = require('BF/components/AnimationRegistry')
    ____exports.ANIMATIONS = ____AnimationRegistry.ANIMATIONS
end
--- Manages womb image rendering for both animated scenes and idle still frames.
-- 
-- The current image path is stored in the static {@link Animation.wombImage} property
-- so that UI components can read it without holding a direct reference to this instance.
-- 
-- Subscribes to three game events via {@link BFEventsEnum}:
-- - `ANIMATION_START` → {@link onAnimationStart} — initializes the animation.
-- - `ANIMATION`      → {@link onAnimation}  — updates the frame for the active scene.
-- - `ANIMATION_STOP` → {@link onAnimationStop} — marks the animation as inactive.
-- - `IMAGE`          → {@link onImage}       — refreshes the idle womb image.
____exports.Animation = __TS__Class()
local Animation = ____exports.Animation
Animation.Type = "Animation"
__PW__BaseClassExtends(Animation)
function Animation.prototype.____constructor(self, womb)
    self.womb = womb
    __TS__New(Events.EventEmitter, BFEventsEnum.ANIMATION_START):addListener(function(animation) return self:onAnimationStart(animation) end)
    __TS__New(Events.EventEmitter, BFEventsEnum.ANIMATION_UPDATE):addListener(function(data) return self:onAnimation(data) end)
    __TS__New(Events.EventEmitter, BFEventsEnum.ANIMATION_STOP):addListener(function() return self:onAnimationStop() end)
    __TS__New(Events.EventEmitter, BFEventsEnum.IMAGE):addListener(function() return self:onImage() end)
end
function Animation.prototype.filterVariants(self, animations)
    local hasCondom = self.womb:hasItem(ITEMS.CONDOM)
    local isPregnant = self.pregnancyStatus == "pregnant"
    local fullness = self.fullness
    return __TS__ArrayFilter(
        animations,
        function(____, ____bindingPattern0)
            local fertilization
            local birth
            local fullnessSupport
            local pregnancy
            local condom
            condom = ____bindingPattern0.condom
            pregnancy = ____bindingPattern0.pregnancy
            fullnessSupport = ____bindingPattern0.fullnessSupport
            birth = ____bindingPattern0.birth
            fertilization = ____bindingPattern0.fertilization
            if birth then
                return true
            end
            if fertilization then
                return true
            end
            if isPregnant and pregnancy ~= true then
                return false
            end
            if not isPregnant and pregnancy == true then
                return false
            end
            if hasCondom and condom ~= true then
                return false
            end
            if not hasCondom and condom == true then
                return false
            end
            if fullnessSupport and not __TS__ArrayIncludes(fullnessSupport, fullness) then
                return false
            end
            return true
        end
    )
end
function Animation.prototype.preloadFrames(self, ____bindingPattern0)
    local fullnessSupport
    local steps
    local path
    local name
    name = ____bindingPattern0.name
    path = ____bindingPattern0.path
    if path == nil then
        path = "media/ui/animation"
    end
    steps = ____bindingPattern0.steps
    fullnessSupport = ____bindingPattern0.fullnessSupport
    if fullnessSupport == nil then
        fullnessSupport = {}
    end
    local variantsToLoad = #fullnessSupport > 0 and fullnessSupport or ({nil})
    for ____, variant in ipairs(variantsToLoad) do
        local basePath = table.concat(
            __TS__ArrayFilter(
                {path, name, variant},
                function(____, part) return part ~= nil end
            ),
            "/"
        )
        for ____, step in ipairs(steps) do
            pcall(
                getTexture,
                ((basePath .. "/") .. tostring(step)) .. ".png"
            )
        end
    end
end
function Animation.prototype.onAnimationStart(self, animation)
    if type(animation) == "string" then
        local animationVariants = ____exports.Animation.availableAnimations[animation]
        if not animationVariants or #animationVariants == 0 then
            ____exports.Animation.animation = nil
            return
        end
        local selectableVariants = self:filterVariants(animationVariants)
        if #selectableVariants == 0 then
            ____exports.Animation.animation = nil
            return
        end
        local variantIndex = ZombRandBetween(0, #selectableVariants - 1)
        ____exports.Animation.animation = selectableVariants[variantIndex + 1] or selectableVariants[1]
    else
        ____exports.Animation.animation = self:filterVariants({animation})[1]
    end
    if ____exports.Animation.animation ~= nil then
        self:preloadFrames(____exports.Animation.animation)
    end
end
function Animation.prototype.onAnimation(self, ____bindingPattern0)
    local duration
    local delta
    delta = ____bindingPattern0.delta
    duration = ____bindingPattern0.duration
    if not ____exports.Animation.animation then
        return
    end
    local ____exports_Animation_animation_0 = ____exports.Animation.animation
    local name = ____exports_Animation_animation_0.name
    local path = ____exports_Animation_animation_0.path
    if path == nil then
        path = "media/ui/animation"
    end
    local steps = ____exports_Animation_animation_0.steps
    local loop = ____exports_Animation_animation_0.loop
    if loop == nil then
        loop = 1
    end
    local fullnessSupport = ____exports_Animation_animation_0.fullnessSupport
    if fullnessSupport == nil then
        fullnessSupport = {}
    end
    local loopDuration = duration / loop
    local currentLoopDelta = delta * duration % loopDuration
    local stepDuration = loopDuration / #steps
    local stepIndex = math.floor(currentLoopDelta / stepDuration) % #steps
    local step = steps[stepIndex + 1]
    local fullness = self.fullness
    local fullnessPath = __TS__ArrayIncludes(fullnessSupport, fullness) and fullness or nil
    local finalPath = table.concat(
        __TS__ArrayFilter(
            {path, name, fullnessPath},
            function(____, part) return part ~= nil end
        ),
        "/"
    )
    ____exports.Animation.wombImage = ((finalPath .. "/") .. tostring(step)) .. ".png"
end
function Animation.prototype.onAnimationStop(self)
    ____exports.Animation.animation = nil
end
function Animation.prototype.onImage(self)
    if ____exports.Animation.animation then
        return
    end
    ____exports.Animation.wombImage = ((((("media/ui/womb/" .. self.pregnancyStatus) .. "/womb_") .. self.pregnancyStatus) .. "_") .. tostring(self.imageIndex)) .. ".png"
end
Animation.wombImage = "media/ui/womb/normal/womb_normal_0.png"
Animation.availableAnimations = animationRegistry.animations
Animation.defaultAnimations = ____exports.Animation.availableAnimations
__TS__SetDescriptor(
    Animation.prototype,
    "fullness",
    {get = function(self)
        return self.womb.amount > self.womb.capacity / 2 and "full" or "empty"
    end},
    true
)
__TS__SetDescriptor(
    Animation.prototype,
    "pregnancyStatus",
    {get = function(self)
        local pregnancy = self.womb.pregnancyData
        if not pregnancy then
            return "normal"
        end
        if pregnancy.progress > 0.05 then
            return "pregnant"
        end
        return "conception"
    end},
    true
)
__TS__SetDescriptor(
    Animation.prototype,
    "imageIndex",
    {get = function(self)
        local ____self_womb_1 = self.womb
        local amount = ____self_womb_1.amount
        local capacity = ____self_womb_1.capacity
        local pregnancy = self.womb.pregnancyData
        if pregnancy and pregnancy.progress > 0.05 then
            local percentage = (pregnancy.progress > 0.9 and 1 or pregnancy.progress) * 100
            return percentageToNumber(percentage, 6)
        end
        if amount == 0 then
            return 0
        end
        local percentage = math.floor(amount / capacity * 100)
        local index = percentageToNumber(percentage, 17)
        return math.max(1, index)
    end},
    true
)
return ____exports
