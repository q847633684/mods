local ____lualib = require('lualib_bundle')
local __TS__New = ____lualib.__TS__New
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
local _____40constants = require('constants')
local BFEventsEnum = _____40constants.BFEventsEnum
--- Public BF custom events registered before components and external integrations use them.
local BF_EVENTS = {
    BFEventsEnum.PREGNANCY_UPDATE,
    BFEventsEnum.LACTATION_UPDATE,
    BFEventsEnum.WOMB_UPDATE,
    BFEventsEnum.INTERCOURSE,
    BFEventsEnum.MENSTRUAL_EFFECTS,
    BFEventsEnum.PREGNANCY_START,
    BFEventsEnum.PREGNANCY_STOP,
    BFEventsEnum.PREGNANCY_LABOR,
    BFEventsEnum.ANIMATION_START,
    BFEventsEnum.ANIMATION_UPDATE,
    BFEventsEnum.ANIMATION_STOP,
    BFEventsEnum.IMAGE
}
--- Guards module-level BF event registration against duplicate initialization.
local installed = false
--- Registers every public BF custom event with Project Zomboid's Lua event manager.
-- Repeated calls are safe and do not register an event more than once through this module.
____exports.installBFEvents = function()
    if installed then
        return
    end
    installed = true
    for ____, event in ipairs(BF_EVENTS) do
        __TS__New(Events.EventEmitter, event)
    end
end
return ____exports
