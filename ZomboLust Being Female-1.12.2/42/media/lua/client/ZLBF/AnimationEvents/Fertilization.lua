local ____lualib = require('lualib_bundle')
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local getActivatedMods = ____pipewrench.getActivatedMods
local triggerEvent = ____pipewrench.triggerEvent
local _____40constants = require('constants')
local MODS = _____40constants.MODS
local ZLBFEventsEnum = _____40constants.ZLBFEventsEnum
local function hasTag(tag, tags)
    for key, value in pairs(tags) do
        if __TS__ArrayIncludes({key, value}, tag) then
            return true
        end
    end
    return false
end
function ____exports.onAnimationEvent(actionInstance, _eventName, _parameter)
    if not getActivatedMods():contains(MODS.ZOMBOLUST) then
        return
    end
    if not ZomboDesire or not ZomboDesire.AnimationConfigs then
        return
    end
    local ____actionInstance_0 = actionInstance
    local character = ____actionInstance_0.character
    local stageConfig = ____actionInstance_0.stageConfig
    if character:isZombie() or not character:isFemale() then
        return
    end
    if not (stageConfig and stageConfig.animName) then
        return
    end
    local ____stageConfig_3 = stageConfig
    local animName = ____stageConfig_3.animName
    local globalConfig = ZomboDesire.AnimationConfigs[animName]
    if not globalConfig then
        return
    end
    local tags = globalConfig.tags or globalConfig.Tags or ({})
    local hasPregnancyTag = hasTag("Pregnancy", tags)
    if hasPregnancyTag then
        triggerEvent(ZLBFEventsEnum.INTERCOURSE)
    end
end
return ____exports
