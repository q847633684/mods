local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__Unpack = ____lualib.__TS__Unpack
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local ZombRandBetween = ____pipewrench.ZombRandBetween
local getTexture = ____pipewrench.getTexture
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
local ____Utils = require('ZLBF/Utils')
local createArray = ____Utils.createArray
local percentageToNumber = ____Utils.percentageToNumber
local repeatArray = ____Utils.repeatArray
local _____40constants = require('constants')
local ITEMS = _____40constants.ITEMS
local ZLBFEventsEnum = _____40constants.ZLBFEventsEnum
--- External Identifiers of the type of animation to play.
____exports.ANIMATIONS = ANIMATIONS or ({})
____exports.ANIMATIONS.INTERCOURSE = "intercourse"
____exports.ANIMATIONS.BIRTH = "birth"
____exports.ANIMATIONS.FERTILIZATION = "fertilization"
local ____exports_ANIMATIONS_INTERCOURSE_4 = ____exports.ANIMATIONS.INTERCOURSE
local ____array_1 = __TS__SparseArrayNew(__TS__Unpack(repeatArray({
    0,
    1,
    2,
    3,
    4,
    3,
    2,
    1
}, 20)))
__TS__SparseArrayPush(
    ____array_1,
    __TS__Unpack(createArray(10))
)
local ____array_3 = __TS__SparseArrayNew(
    {
        name = "intercourse",
        steps = {__TS__SparseArraySpread(____array_1)},
        loop = 1,
        fullnessSupport = {"empty", "full"}
    },
    {
        name = "intercourse-v1",
        steps = createArray(171),
        loop = 1,
        fullnessSupport = {"empty"}
    },
    {
        name = "intercourse-v2",
        steps = createArray(13),
        loop = 20,
        fullnessSupport = {"full"}
    },
    {
        name = "intercourse-v3",
        steps = createArray(29),
        loop = 20
    },
    {
        name = "intercourse-v4",
        steps = createArray(30),
        loop = 20,
        fullnessSupport = {"empty"}
    }
)
local ____array_2 = __TS__SparseArrayNew(__TS__Unpack(repeatArray({
    0,
    1,
    2,
    3,
    2,
    1
}, 20)))
__TS__SparseArrayPush(
    ____array_2,
    __TS__Unpack(createArray(12))
)
__TS__SparseArrayPush(
    ____array_3,
    {
        name = "pregnant",
        steps = {__TS__SparseArraySpread(____array_2)},
        loop = 1,
        pregnancy = true
    },
    {
        name = "pregnant-v1",
        steps = createArray(15),
        loop = 20,
        pregnancy = true
    },
    {
        name = "pregnant-v2",
        steps = createArray(3),
        loop = 20,
        pregnancy = true
    },
    {
        name = "condom",
        steps = createArray(7),
        loop = 4,
        condom = true
    },
    {
        name = "condom-v1",
        steps = createArray(30),
        loop = 20,
        condom = true,
        fullnessSupport = {"empty"}
    },
    {
        name = "condom-v2",
        steps = createArray(24),
        loop = 20,
        condom = true,
        fullnessSupport = {"empty"}
    }
)
--- Manages womb image rendering for both animated scenes and idle still frames.
-- 
-- The current image path is stored in the static {@link Animation.wombImage} property
-- so that UI components can read it without holding a direct reference to this instance.
-- 
-- Subscribes to three game events via {@link ZLBFEventsEnum}:
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
    __TS__New(Events.EventEmitter, ZLBFEventsEnum.ANIMATION_START):addListener(function(animation) return self:onAnimationStart(animation) end)
    __TS__New(Events.EventEmitter, ZLBFEventsEnum.ANIMATION_UPDATE):addListener(function(data) return self:onAnimation(data) end)
    __TS__New(Events.EventEmitter, ZLBFEventsEnum.ANIMATION_STOP):addListener(function() return self:onAnimationStop() end)
    __TS__New(Events.EventEmitter, ZLBFEventsEnum.IMAGE):addListener(function() return self:onImage() end)
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
        local animationVariants = ____exports.Animation.defaultAnimations[animation]
        if not animationVariants or #animationVariants == 0 then
            ____exports.Animation.animation = nil
            return
        end
        local selectableVariants = self:filterVariants(animationVariants)
        local variantIndex = ZombRandBetween(0, #selectableVariants - 1)
        ____exports.Animation.animation = selectableVariants[variantIndex + 1] or selectableVariants[1]
    else
        ____exports.Animation.animation = animation
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
Animation.defaultAnimations = {
    [____exports_ANIMATIONS_INTERCOURSE_4] = {__TS__SparseArraySpread(____array_3)},
    [____exports.ANIMATIONS.BIRTH] = {
        {
            name = "birth",
            steps = createArray(12),
            loop = 1,
            birth = true
        },
        {
            name = "birth-v1",
            steps = createArray(20),
            loop = 1,
            birth = true
        },
        {
            name = "birth-v2",
            steps = createArray(29),
            loop = 1,
            birth = true
        },
        {
            name = "birth-v3",
            steps = createArray(76),
            loop = 1,
            birth = true
        }
    },
    [____exports.ANIMATIONS.FERTILIZATION] = {
        {
            name = "fertilization",
            steps = createArray(29),
            loop = 1,
            fertilization = true
        },
        {
            name = "fertilization-v1",
            steps = createArray(31),
            loop = 1,
            fertilization = true
        },
        {
            name = "fertilization-v2",
            steps = createArray(26),
            loop = 1,
            fertilization = true
        },
        {
            name = "fertilization-v3",
            steps = createArray(32),
            loop = 1,
            fertilization = true
        },
        {
            name = "fertilization-v4",
            steps = createArray(13),
            loop = 1,
            fertilization = true
        }
    }
}
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
        local ____self_womb_5 = self.womb
        local pregnancy = ____self_womb_5.pregnancy
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
        local ____self_womb_6 = self.womb
        local pregnancy = ____self_womb_6.pregnancy
        local amount = ____self_womb_6.amount
        local capacity = ____self_womb_6.capacity
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
