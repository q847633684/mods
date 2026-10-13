local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local getPlayer = ____pipewrench.getPlayer
local sendClientCommand = ____pipewrench.sendClientCommand
local _____40constants = require('constants')
local BF_NETWORK_MODULE = _____40constants.BF_NETWORK_MODULE
local BF_PROTOCOL_SCHEMA_VERSION = _____40constants.BF_PROTOCOL_SCHEMA_VERSION
local BFNetworkCommand = _____40constants.BFNetworkCommand
local BFSyncStatus = _____40constants.BFSyncStatus
local ____BFProtocol = require('BFProtocol')
local isBFSetPregnancyStateResponse = ____BFProtocol.isBFSetPregnancyStateResponse
--- Publishes Pregnancy desired state and correlates authoritative responses.
____exports.PregnancyPublisher = __TS__Class()
local PregnancyPublisher = ____exports.PregnancyPublisher
PregnancyPublisher.Type = "PregnancyPublisher"
__PW__BaseClassExtends(PregnancyPublisher)
function PregnancyPublisher.prototype.____constructor(self, snapshots)
    self.snapshots = snapshots
    self.nextRevision = 1
end
function PregnancyPublisher.prototype.resetSession(self)
    self.pending = nil
    self.queued = nil
end
function PregnancyPublisher.prototype.setState(self, desired)
    self:enqueue(desired, {request = BFNetworkCommand.SET_PREGNANCY_STATE_REQUEST, response = BFNetworkCommand.SET_PREGNANCY_STATE_RESPONSE})
end
function PregnancyPublisher.prototype.publishState(self, desired)
    self:enqueue(desired, {request = BFNetworkCommand.PUBLISH_PREGNANCY_STATE_REQUEST, response = BFNetworkCommand.PUBLISH_PREGNANCY_STATE_RESPONSE})
end
function PregnancyPublisher.prototype.enqueue(self, desired, route)
    if self.pending then
        self.queued = {desired = desired, route = route}
        return
    end
    self:send(desired, route)
end
function PregnancyPublisher.prototype.send(self, desired, route)
    local ____self_0, ____nextRevision_1 = self, "nextRevision"
    local ____self_nextRevision_2 = ____self_0[____nextRevision_1]
    ____self_0[____nextRevision_1] = ____self_nextRevision_2 + 1
    local revision = ____self_nextRevision_2
    local payload = {
        schemaVersion = BF_PROTOCOL_SCHEMA_VERSION,
        requestId = "pregnancy-" .. tostring(revision),
        revision = revision,
        data = {desired = desired}
    }
    self.pending = {payload = payload, route = route}
    print((((("[BF][MP][Client] send " .. route.request) .. " request=") .. payload.requestId) .. " revision=") .. tostring(payload.revision))
    sendClientCommand(
        getPlayer(),
        BF_NETWORK_MODULE,
        route.request,
        payload
    )
end
function PregnancyPublisher.prototype.onServerCommand(self, module, command, args)
    local ____temp_6 = module ~= BF_NETWORK_MODULE
    if not ____temp_6 then
        local ____command_5 = command
        local ____opt_3 = self.pending
        ____temp_6 = ____command_5 ~= (____opt_3 and ____opt_3.route.response)
    end
    if ____temp_6 then
        return
    end
    if not isBFSetPregnancyStateResponse(args) then
        return
    end
    local pending = self.pending
    if not pending or args.requestId ~= pending.payload.requestId or args.revision ~= pending.payload.revision or args.schemaVersion ~= BF_PROTOCOL_SCHEMA_VERSION then
        return
    end
    self.pending = nil
    local compatible = args.status ~= BFSyncStatus.UNSUPPORTED_SCHEMA and args.status ~= BFSyncStatus.UNSUPPORTED_DATA_SCHEMA
    if compatible then
        self.snapshots:apply(args.data.snapshot)
    end
    print((((("[BF][MP][Client] acknowledged " .. args.requestId) .. " revision=") .. tostring(args.revision)) .. " status=") .. args.status)
    local queued = self.queued
    self.queued = nil
    if compatible and queued then
        self:send(queued.desired, queued.route)
    end
end
__TS__SetDescriptor(
    PregnancyPublisher.prototype,
    "latestDesiredState",
    {get = function(self)
        local ____opt_7 = self.queued
        local ____temp_11 = ____opt_7 and ____opt_7.desired
        if ____temp_11 == nil then
            local ____opt_9 = self.pending
            ____temp_11 = ____opt_9 and ____opt_9.payload.data.desired
        end
        return ____temp_11
    end},
    true
)
return ____exports
