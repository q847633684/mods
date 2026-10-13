local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
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
local isBFSyncStateResponse = ____BFProtocol.isBFSyncStateResponse
--- Publishes one read-only snapshot request and accepts its correlated server response.
-- 
-- The first send is deferred until `EveryOneMinute`, where runtime testing established
-- that `getPlayer()` is available. Connection resets discard correlation so the next
-- minute performs a fresh bootstrap rather than sending from a lifecycle callback.
____exports.SyncPublisher = __TS__Class()
local SyncPublisher = ____exports.SyncPublisher
SyncPublisher.Type = "SyncPublisher"
__PW__BaseClassExtends(SyncPublisher)
function SyncPublisher.prototype.____constructor(self, snapshots)
    self.snapshots = snapshots
    self.nextRevision = 1
end
function SyncPublisher.prototype.resetSession(self)
    self.pending = nil
    self.acknowledged = nil
end
function SyncPublisher.prototype.onEveryOneMinute(self)
    if self.pending or self.acknowledged then
        return
    end
    local player = getPlayer()
    local ____self_0, ____nextRevision_1 = self, "nextRevision"
    local ____self_nextRevision_2 = ____self_0[____nextRevision_1]
    ____self_0[____nextRevision_1] = ____self_nextRevision_2 + 1
    local revision = ____self_nextRevision_2
    local payload = {
        schemaVersion = BF_PROTOCOL_SCHEMA_VERSION,
        requestId = "snapshot-" .. tostring(revision),
        revision = revision,
        data = {}
    }
    self.pending = payload
    print((((("[BF][MP][Client] send " .. BFNetworkCommand.SYNC_STATE_REQUEST) .. " request=") .. payload.requestId) .. " revision=") .. tostring(payload.revision))
    sendClientCommand(player, BF_NETWORK_MODULE, BFNetworkCommand.SYNC_STATE_REQUEST, payload)
end
function SyncPublisher.prototype.onServerCommand(self, module, command, args)
    if module ~= BF_NETWORK_MODULE or command ~= BFNetworkCommand.SYNC_STATE_RESPONSE then
        return
    end
    if not isBFSyncStateResponse(args) then
        print("[BF][MP][Client] ignored malformed SyncStateResponse")
        return
    end
    local pending = self.pending
    if not pending or args.requestId ~= pending.requestId or args.revision ~= pending.revision or args.schemaVersion ~= BF_PROTOCOL_SCHEMA_VERSION then
        print("[BF][MP][Client] ignored uncorrelated SyncStateResponse")
        return
    end
    self.acknowledged = args
    self.pending = nil
    if args.status == BFSyncStatus.OK then
        self.snapshots:apply(args.data.snapshot)
    end
    print((((("[BF][MP][Client] acknowledged " .. args.requestId) .. " revision=") .. tostring(args.revision)) .. " status=") .. args.status)
end
return ____exports
