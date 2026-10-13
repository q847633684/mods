local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
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
local isBFPublishWombStateResponse = ____BFProtocol.isBFPublishWombStateResponse
--- Publishes reversible Womb contents and cycle progression and applies responses.
____exports.WombPublisher = __TS__Class()
local WombPublisher = ____exports.WombPublisher
WombPublisher.Type = "WombPublisher"
__PW__BaseClassExtends(WombPublisher)
function WombPublisher.prototype.____constructor(self, snapshots)
    self.snapshots = snapshots
    self.nextRevision = 1
end
function WombPublisher.prototype.resetSession(self)
    self.pending = nil
    self.queued = nil
end
function WombPublisher.prototype.publishState(self, desired)
    if self.pending then
        self.queued = desired
        return
    end
    self:send(desired)
end
function WombPublisher.prototype.send(self, desired)
    local ____self_0, ____nextRevision_1 = self, "nextRevision"
    local ____self_nextRevision_2 = ____self_0[____nextRevision_1]
    ____self_0[____nextRevision_1] = ____self_nextRevision_2 + 1
    local revision = ____self_nextRevision_2
    local ____BF_PROTOCOL_SCHEMA_VERSION_5 = BF_PROTOCOL_SCHEMA_VERSION
    local ____temp_6 = "womb-" .. tostring(revision)
    local ____revision_7 = revision
    local ____opt_3 = self.snapshots.snapshot
    local payload = {
        schemaVersion = ____BF_PROTOCOL_SCHEMA_VERSION_5,
        requestId = ____temp_6,
        revision = ____revision_7,
        baseStateVersion = ____opt_3 and ____opt_3.stateVersion or 0,
        data = {desired = desired}
    }
    self.pending = payload
    print((((("[BF][MP][Client] send PublishWombStateRequest cycleDay=" .. tostring(desired.cycleDay)) .. " amount=") .. tostring(desired.amount)) .. " total=") .. tostring(desired.total))
    sendClientCommand(
        getPlayer(),
        BF_NETWORK_MODULE,
        BFNetworkCommand.PUBLISH_WOMB_STATE_REQUEST,
        payload
    )
end
function WombPublisher.prototype.onServerCommand(self, module, command, args)
    if module ~= BF_NETWORK_MODULE or command ~= BFNetworkCommand.PUBLISH_WOMB_STATE_RESPONSE or not isBFPublishWombStateResponse(args) or args.schemaVersion ~= BF_PROTOCOL_SCHEMA_VERSION then
        return
    end
    local pending = self.pending
    if not pending or args.requestId ~= pending.requestId or args.revision ~= pending.revision then
        return
    end
    self.pending = nil
    local compatible = args.status ~= BFSyncStatus.UNSUPPORTED_SCHEMA and args.status ~= BFSyncStatus.UNSUPPORTED_DATA_SCHEMA
    if compatible then
        self.snapshots:apply(args.data.snapshot)
    end
    print((((((("[BF][MP][Client] acknowledged PublishWombStateResponse status=" .. args.status) .. " cycleDay=") .. tostring(args.data.snapshot.domains.womb.cycleDay)) .. " amount=") .. tostring(args.data.snapshot.domains.womb.amount)) .. " total=") .. tostring(args.data.snapshot.domains.womb.total))
    local queued = self.queued
    self.queued = nil
    if compatible then
        local authoritative = args.data.snapshot.domains.womb
        local desired = queued or pending.data.desired
        local reconciled = desired.cycleDay == authoritative.cycleDay and authoritative.onContraceptive ~= nil and __TS__ObjectAssign({}, desired, {onContraceptive = authoritative.onContraceptive}) or desired
        local unapplied = authoritative.cycleDay ~= nil and authoritative.cycleDay ~= reconciled.cycleDay or authoritative.amount ~= nil and authoritative.amount ~= reconciled.amount or authoritative.total ~= nil and authoritative.total ~= reconciled.total or authoritative.onContraceptive ~= nil and authoritative.onContraceptive ~= reconciled.onContraceptive
        if unapplied then
            self:send(reconciled)
        end
    end
end
__TS__SetDescriptor(
    WombPublisher.prototype,
    "latestDesiredState",
    {get = function(self)
        local ____self_queued_10 = self.queued
        if ____self_queued_10 == nil then
            local ____opt_8 = self.pending
            ____self_queued_10 = ____opt_8 and ____opt_8.data.desired
        end
        return ____self_queued_10
    end},
    true
)
return ____exports
