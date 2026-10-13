local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local sameLactation, replacementsFor
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local getPlayer = ____pipewrench.getPlayer
local sendClientCommand = ____pipewrench.sendClientCommand
local _____40constants = require('constants')
local BF_NETWORK_MODULE = _____40constants.BF_NETWORK_MODULE
local BF_PROTOCOL_SCHEMA_VERSION = _____40constants.BF_PROTOCOL_SCHEMA_VERSION
local BFNetworkCommand = _____40constants.BFNetworkCommand
local BFSyncStatus = _____40constants.BFSyncStatus
local ____BFProtocol = require('BFProtocol')
local isBFPublishLactationStateResponse = ____BFProtocol.isBFPublishLactationStateResponse
--- Publishes complete Lactation simulation and explicitly rebases conflicts onto recipe state.
____exports.LactationPublisher = __TS__Class()
local LactationPublisher = ____exports.LactationPublisher
LactationPublisher.Type = "LactationPublisher"
__PW__BaseClassExtends(LactationPublisher)
function LactationPublisher.prototype.____constructor(self, snapshots)
    self.snapshots = snapshots
    self.nextRevision = 1
    self.pendingMinutes = 0
    self.retryMinutes = 2
end
function LactationPublisher.prototype.resetSession(self)
    self.pending = nil
    self.queued = nil
    self.pendingMinutes = 0
end
function LactationPublisher.prototype.publishState(self, desired, intent)
    if intent == nil then
        intent = replacementsFor(desired)
    end
    if self.pending then
        local ____desired_2 = desired
        local ____opt_0 = self.queued
        self.queued = {
            desired = ____desired_2,
            intent = ____exports.composeLactationIntent(____opt_0 and ____opt_0.intent, intent, desired)
        }
        return
    end
    self:send(desired, intent)
end
function LactationPublisher.prototype.onEveryOneMinute(self)
    if not self.pending then
        return
    end
    self.pendingMinutes = self.pendingMinutes + 1
    if self.pendingMinutes < self.retryMinutes then
        return
    end
    self.pendingMinutes = 0
    self:sendRequest(self.pending.request)
end
function LactationPublisher.prototype.send(self, desired, intent)
    local ____self_3, ____nextRevision_4 = self, "nextRevision"
    local ____self_nextRevision_5 = ____self_3[____nextRevision_4]
    ____self_3[____nextRevision_4] = ____self_nextRevision_5 + 1
    local revision = ____self_nextRevision_5
    local ____BF_PROTOCOL_SCHEMA_VERSION_8 = BF_PROTOCOL_SCHEMA_VERSION
    local ____temp_9 = "lactation-" .. tostring(revision)
    local ____revision_10 = revision
    local ____opt_6 = self.snapshots.snapshot
    local request = {
        schemaVersion = ____BF_PROTOCOL_SCHEMA_VERSION_8,
        requestId = ____temp_9,
        revision = ____revision_10,
        baseStateVersion = ____opt_6 and ____opt_6.stateVersion or 0,
        data = {desired = desired}
    }
    self.pending = {request = request, intent = intent}
    self.pendingMinutes = 0
    self:sendRequest(request)
end
function LactationPublisher.prototype.sendRequest(self, request)
    local desired = request.data.desired
    print((((((("[BF][MP][Client] send PublishLactationStateRequest active=" .. tostring(desired.isActive)) .. " milk=") .. tostring(desired.milkAmount)) .. " expiration=") .. tostring(desired.expiration)) .. " multiplier=") .. tostring(desired.multiplier))
    sendClientCommand(
        getPlayer(),
        BF_NETWORK_MODULE,
        BFNetworkCommand.PUBLISH_LACTATION_STATE_REQUEST,
        request
    )
end
function LactationPublisher.prototype.onServerCommand(self, module, command, args)
    if module ~= BF_NETWORK_MODULE or command ~= BFNetworkCommand.PUBLISH_LACTATION_STATE_RESPONSE or not isBFPublishLactationStateResponse(args) or args.schemaVersion ~= BF_PROTOCOL_SCHEMA_VERSION then
        return
    end
    local pending = self.pending
    if not pending or args.requestId ~= pending.request.requestId or args.revision ~= pending.request.revision then
        return
    end
    self.pending = nil
    self.pendingMinutes = 0
    local compatible = args.status ~= BFSyncStatus.UNSUPPORTED_SCHEMA and args.status ~= BFSyncStatus.UNSUPPORTED_DATA_SCHEMA
    if not compatible then
        self.queued = nil
        return
    end
    self.snapshots:apply(args.data.snapshot)
    local authoritative = args.data.snapshot.domains.lactation
    local queued = self.queued
    local optimistic = queued or ({desired = pending.request.data.desired, intent = pending.intent})
    self.queued = nil
    local pendingAccepted = sameLactation(authoritative, pending.request.data.desired)
    local replayIntent = pendingAccepted and (queued and queued.intent or ({})) or (queued and ____exports.composeLactationIntent(pending.intent, queued.intent, queued.desired) or pending.intent)
    local accepted = sameLactation(authoritative, optimistic.desired)
    print((((((((("[BF][MP][Client] acknowledged PublishLactationStateResponse status=" .. args.status) .. " active=") .. tostring(authoritative.isActive)) .. " milk=") .. tostring(authoritative.milkAmount)) .. " expiration=") .. tostring(authoritative.expiration)) .. " multiplier=") .. tostring(authoritative.multiplier))
    if accepted then
        self.snapshots:notifyCurrent()
        return
    end
    local rebased = ____exports.rebaseLactationState(replayIntent, authoritative)
    if sameLactation(rebased, authoritative) then
        self.snapshots:notifyCurrent()
        return
    end
    self:send(
        rebased,
        replacementsFor(rebased)
    )
end
__TS__SetDescriptor(
    LactationPublisher.prototype,
    "latestDesiredState",
    {get = function(self)
        local ____opt_13 = self.queued
        local ____temp_17 = ____opt_13 and ____opt_13.desired
        if ____temp_17 == nil then
            local ____opt_15 = self.pending
            ____temp_17 = ____opt_15 and ____opt_15.request.data.desired
        end
        return ____temp_17
    end},
    true
)
--- Composes sequential queued intent without inferring semantics from numeric differences.
-- A replacement supersedes prior work; a delta after replacement adjusts the replacement
-- to the latest complete desired value; consecutive deltas accumulate.
-- 
-- @param current Already-coalesced intent from the pending desired to the prior queued state.
-- @param next Explicit intent for the newest local mutation.
-- @param desired Complete state after applying `next`, used when adjusting a replacement.
-- @returns Intent representing the whole queued mutation sequence.
____exports.composeLactationIntent = function(current, next, desired)
    local function compose(previous, following, value)
        if not following then
            return previous
        end
        if following.mode == "replace" then
            return following
        end
        if (previous and previous.mode) == "replace" then
            return {mode = "replace", value = value}
        end
        return {mode = "delta", value = (previous and previous.value or 0) + following.value}
    end
    return {
        isActive = next.isActive or current and current.isActive,
        milkAmount = compose(current and current.milkAmount, next.milkAmount, desired.milkAmount),
        expiration = compose(current and current.expiration, next.expiration, desired.expiration),
        multiplier = compose(current and current.multiplier, next.multiplier, desired.multiplier)
    }
end
--- Applies typed replacement/delta intent over authoritative recipe-owned state.
-- 
-- @param intent Explicit per-field mutation semantics supplied by the simulation component.
-- @param authoritative Latest server-owned state, potentially changed by a recipe.
-- @returns Complete rebased state with numeric values clamped at zero.
____exports.rebaseLactationState = function(intent, authoritative)
    local function numeric(operation, current)
        return not operation and current or math.max(0, operation.mode == "replace" and operation.value or current + operation.value)
    end
    local ____opt_30 = intent.isActive
    local ____temp_32 = ____opt_30 and ____opt_30.value
    if ____temp_32 == nil then
        ____temp_32 = authoritative.isActive
    end
    return {
        isActive = ____temp_32,
        milkAmount = numeric(intent.milkAmount, authoritative.milkAmount),
        expiration = numeric(intent.expiration, authoritative.expiration),
        multiplier = numeric(intent.multiplier, authoritative.multiplier)
    }
end
--- Returns whether two complete Lactation states are field-equivalent.
sameLactation = function(left, right) return left.isActive == right.isActive and left.milkAmount == right.milkAmount and left.expiration == right.expiration and left.multiplier == right.multiplier end
--- Creates explicit full-replacement intent for an already rebased state.
replacementsFor = function(state) return {isActive = {mode = "replace", value = state.isActive}, milkAmount = {mode = "replace", value = state.milkAmount}, expiration = {mode = "replace", value = state.expiration}, multiplier = {mode = "replace", value = state.multiplier}} end
return ____exports
