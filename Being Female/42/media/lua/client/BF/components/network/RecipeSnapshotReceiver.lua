local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local _____40constants = require('constants')
local BF_NETWORK_MODULE = _____40constants.BF_NETWORK_MODULE
local BF_PROTOCOL_SCHEMA_VERSION = _____40constants.BF_PROTOCOL_SCHEMA_VERSION
local BFNetworkCommand = _____40constants.BFNetworkCommand
local ____BFProtocol = require('BFProtocol')
local isBFSyncStateResponse = ____BFProtocol.isBFSyncStateResponse
--- Applies unsolicited authoritative snapshots emitted by server recipe callbacks.
____exports.RecipeSnapshotReceiver = __TS__Class()
local RecipeSnapshotReceiver = ____exports.RecipeSnapshotReceiver
RecipeSnapshotReceiver.Type = "RecipeSnapshotReceiver"
__PW__BaseClassExtends(RecipeSnapshotReceiver)
function RecipeSnapshotReceiver.prototype.____constructor(self, snapshots)
    self.snapshots = snapshots
end
function RecipeSnapshotReceiver.prototype.onServerCommand(self, module, command, args)
    if module ~= BF_NETWORK_MODULE or command ~= BFNetworkCommand.RECIPE_STATE_RESPONSE or not isBFSyncStateResponse(args) or args.schemaVersion ~= BF_PROTOCOL_SCHEMA_VERSION then
        return
    end
    self.snapshots:apply(args.data.snapshot)
end
return ____exports
