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
local isBFAllocateBirthResponse = ____BFProtocol.isBFAllocateBirthResponse
local isBFCompleteBirthResponse = ____BFProtocol.isBFCompleteBirthResponse
--- Requests and correlates one server-owned birth operation allocation.
____exports.BirthPublisher = __TS__Class()
local BirthPublisher = ____exports.BirthPublisher
BirthPublisher.Type = "BirthPublisher"
__PW__BaseClassExtends(BirthPublisher)
function BirthPublisher.prototype.____constructor(self, snapshots)
    self.snapshots = snapshots
    self.nextRevision = 1
    self.snapshots:subscribe(function(snapshot)
        local completion = self.completion
        if completion and snapshot.domains.birth.completedBirthId == completion.data.birthId then
            self.completion = nil
        end
    end)
end
function BirthPublisher.prototype.resetSession(self)
    self.pending = nil
    self.completion = nil
end
function BirthPublisher.prototype.onEveryOneMinute(self)
    if self.completion then
        self:sendCompletion(self.completion)
    end
end
function BirthPublisher.prototype.allocate(self)
    local ____self_pending_2 = self.pending
    if not ____self_pending_2 then
        local ____opt_0 = self.snapshots.snapshot
        ____self_pending_2 = ____opt_0 and ____opt_0.domains.birth.pendingBirthId
    end
    if ____self_pending_2 then
        return
    end
    local ____self_3, ____nextRevision_4 = self, "nextRevision"
    local ____self_nextRevision_5 = ____self_3[____nextRevision_4]
    ____self_3[____nextRevision_4] = ____self_nextRevision_5 + 1
    local revision = ____self_nextRevision_5
    local payload = {
        schemaVersion = BF_PROTOCOL_SCHEMA_VERSION,
        requestId = "birth-allocation-" .. tostring(revision),
        revision = revision,
        data = {}
    }
    self.pending = payload
    print((((("[BF][MP][Client] send " .. BFNetworkCommand.ALLOCATE_BIRTH_REQUEST) .. " request=") .. payload.requestId) .. " revision=") .. tostring(payload.revision))
    sendClientCommand(
        getPlayer(),
        BF_NETWORK_MODULE,
        BFNetworkCommand.ALLOCATE_BIRTH_REQUEST,
        payload
    )
end
function BirthPublisher.prototype.complete(self, birthId)
    if self.completion then
        return
    end
    local ____self_6, ____nextRevision_7 = self, "nextRevision"
    local ____self_nextRevision_8 = ____self_6[____nextRevision_7]
    ____self_6[____nextRevision_7] = ____self_nextRevision_8 + 1
    local revision = ____self_nextRevision_8
    local payload = {
        schemaVersion = BF_PROTOCOL_SCHEMA_VERSION,
        requestId = "birth-completion-" .. tostring(revision),
        revision = revision,
        data = {birthId = birthId}
    }
    self.completion = payload
    self:sendCompletion(payload)
end
function BirthPublisher.prototype.sendCompletion(self, payload)
    local birthId = payload.data.birthId
    print("[BF][MP][Client] send CompleteBirthRequest birthId=" .. birthId)
    sendClientCommand(
        getPlayer(),
        BF_NETWORK_MODULE,
        BFNetworkCommand.COMPLETE_BIRTH_REQUEST,
        payload
    )
end
function BirthPublisher.prototype.onServerCommand(self, module, command, args)
    if module == BF_NETWORK_MODULE and command == BFNetworkCommand.COMPLETE_BIRTH_RESPONSE then
        self:onCompletion(args)
        return
    end
    if module ~= BF_NETWORK_MODULE or command ~= BFNetworkCommand.ALLOCATE_BIRTH_RESPONSE then
        return
    end
    if not isBFAllocateBirthResponse(args) then
        print("[BF][MP][Client] ignored malformed AllocateBirthResponse")
        return
    end
    local pending = self.pending
    if not pending or args.requestId ~= pending.requestId or args.revision ~= pending.revision or args.schemaVersion ~= BF_PROTOCOL_SCHEMA_VERSION then
        print("[BF][MP][Client] ignored uncorrelated AllocateBirthResponse")
        return
    end
    self.pending = nil
    if args.status == BFSyncStatus.OK then
        self.snapshots:apply(args.data.snapshot)
    end
    local birthId = args.data.snapshot.domains.birth.pendingBirthId or "none"
    print((((("[BF][MP][Client] acknowledged " .. args.requestId) .. " status=") .. args.status) .. " pendingBirthId=") .. birthId)
end
function BirthPublisher.prototype.onCompletion(self, args)
    if not isBFCompleteBirthResponse(args) then
        return
    end
    local completion = self.completion
    if not completion or args.requestId ~= completion.requestId or args.revision ~= completion.revision or args.schemaVersion ~= BF_PROTOCOL_SCHEMA_VERSION then
        return
    end
    local compatible = args.status ~= BFSyncStatus.UNSUPPORTED_SCHEMA and args.status ~= BFSyncStatus.UNSUPPORTED_DATA_SCHEMA
    if not compatible then
        return
    end
    local stillPending = args.data.snapshot.domains.birth.pendingBirthId == completion.data.birthId
    if not stillPending then
        self.completion = nil
    end
    local current = self.snapshots.snapshot
    self.snapshots:apply(args.data.snapshot)
    if current and current.stateVersion == args.data.snapshot.stateVersion then
        self.snapshots:notifyCurrent()
    end
    print((("[BF][MP][Client] acknowledged CompleteBirthResponse status=" .. args.status) .. " birthId=") .. completion.data.birthId)
end
return ____exports
