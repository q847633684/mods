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
--- Publishes one server-authoritative request to convert a currently owned condom.
____exports.CondomPublisher = __TS__Class()
local CondomPublisher = ____exports.CondomPublisher
CondomPublisher.Type = "CondomPublisher"
__PW__BaseClassExtends(CondomPublisher)
function CondomPublisher.prototype.____constructor(self)
    self.nextRevision = 1
end
function CondomPublisher.prototype.convert(self)
    local ____self_0, ____nextRevision_1 = self, "nextRevision"
    local ____self_nextRevision_2 = ____self_0[____nextRevision_1]
    ____self_0[____nextRevision_1] = ____self_nextRevision_2 + 1
    local revision = ____self_nextRevision_2
    local request = {
        schemaVersion = BF_PROTOCOL_SCHEMA_VERSION,
        requestId = "condom-" .. tostring(revision),
        revision = revision,
        data = {}
    }
    sendClientCommand(
        getPlayer(),
        BF_NETWORK_MODULE,
        BFNetworkCommand.CONVERT_CONDOM_REQUEST,
        request
    )
end
return ____exports
