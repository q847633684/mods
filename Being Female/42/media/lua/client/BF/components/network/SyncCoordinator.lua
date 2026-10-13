local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
--- Registers the singleton client-side Project Zomboid events used by state synchronization.
____exports.SyncCoordinator = __TS__Class()
local SyncCoordinator = ____exports.SyncCoordinator
SyncCoordinator.Type = "SyncCoordinator"
__PW__BaseClassExtends(SyncCoordinator)
function SyncCoordinator.prototype.____constructor(self, config)
    self.config = config
    Events.everyOneMinute:addListener(function()
        for ____, publisher in ipairs(self.config.minutePublishers) do
            publisher:onEveryOneMinute()
        end
    end)
    Events.onServerCommand:addListener(function(module, command, args)
        for ____, receiver in ipairs(self.config.commandReceivers) do
            receiver:onServerCommand(module, command, args)
        end
    end)
    local function reset()
        return self:resetSession()
    end
    Events.onDisconnect:addListener(reset)
    Events.onConnected:addListener(reset)
end
function SyncCoordinator.prototype.resetSession(self)
    for ____, resettable in ipairs(self.config.sessionResettables) do
        resettable:resetSession()
    end
end
return ____exports
