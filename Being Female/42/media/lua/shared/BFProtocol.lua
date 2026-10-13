local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local _____40constants = require('constants')
local BFSyncStatus = _____40constants.BFSyncStatus
local ____Schema = require('validation/Schema')
local emptyRecord = ____Schema.emptyRecord
local nonNegativeInteger = ____Schema.nonNegativeInteger
local object = ____Schema.object
local oneOf = ____Schema.oneOf
local positiveInteger = ____Schema.positiveInteger
local ____string = ____Schema.string
local ____PregnancySchema = require('domain/pregnancy/PregnancySchema')
local pregnancyStateSchema = ____PregnancySchema.pregnancyStateSchema
local ____BirthSchema = require('domain/birth/BirthSchema')
local birthStateSchema = ____BirthSchema.birthStateSchema
local ____WombSchema = require('domain/womb/WombSchema')
local wombProgressStateSchema = ____WombSchema.wombProgressStateSchema
local wombStateSchema = ____WombSchema.wombStateSchema
local ____LactationSchema = require('domain/lactation/LactationSchema')
local lactationStateSchema = ____LactationSchema.lactationStateSchema
--- Validator for bounded client-generated request identifiers.
local requestId = ____string({minimumLength = 1, maximumLength = 64})
--- Validator for every status understood by this protocol version.
local syncStatus = oneOf({
    BFSyncStatus.OK,
    BFSyncStatus.INVALID_REQUEST,
    BFSyncStatus.UNSUPPORTED_SCHEMA,
    BFSyncStatus.UNSUPPORTED_DATA_SCHEMA,
    BFSyncStatus.FORBIDDEN
})
--- Runtime schema for authoritative snapshot metadata.
local snapshotSchema = object({
    schemaVersion = positiveInteger,
    stateVersion = nonNegativeInteger,
    domains = object({pregnancy = pregnancyStateSchema, birth = birthStateSchema, womb = wombStateSchema, lactation = lactationStateSchema})
})
--- Runtime schema for untrusted sync-state requests.
local requestSchema = object({schemaVersion = positiveInteger, requestId = requestId, revision = positiveInteger, data = emptyRecord})
--- Runtime schema for untrusted sync-state responses.
local responseSchema = object({
    schemaVersion = positiveInteger,
    requestId = requestId,
    revision = positiveInteger,
    status = syncStatus,
    data = object({snapshot = snapshotSchema})
})
--- Runtime schema for untrusted Pregnancy debug mutation requests.
local setPregnancyStateRequestSchema = object({
    schemaVersion = positiveInteger,
    requestId = requestId,
    revision = positiveInteger,
    data = object({desired = pregnancyStateSchema})
})
--- Runtime schema for an untrusted birth-completion request.
local completeBirthRequestSchema = object({
    schemaVersion = positiveInteger,
    requestId = requestId,
    revision = positiveInteger,
    data = object({birthId = ____string({minimumLength = 1, maximumLength = 128})})
})
--- Runtime schema for an untrusted condom conversion request.
local convertCondomRequestSchema = object({schemaVersion = positiveInteger, requestId = requestId, revision = positiveInteger, data = emptyRecord})
--- Runtime schema for an untrusted Womb progression publication.
local publishWombStateRequestSchema = object({
    schemaVersion = positiveInteger,
    requestId = requestId,
    revision = positiveInteger,
    baseStateVersion = nonNegativeInteger,
    data = object({desired = wombProgressStateSchema})
})
--- Runtime schema for an untrusted complete Lactation publication.
local publishLactationStateRequestSchema = object({
    schemaVersion = positiveInteger,
    requestId = requestId,
    revision = positiveInteger,
    baseStateVersion = nonNegativeInteger,
    data = object({desired = lactationStateSchema})
})
--- Validates an untrusted client-command payload before server code reads it.
-- 
-- @param value Raw value received from Project Zomboid's client-command event.
-- @returns Whether the value is a structurally valid sync-state request.
____exports.isBFSyncStateRequest = requestSchema
--- Validates an untrusted server-command payload before client code reads it.
-- 
-- @param response Raw value received from Project Zomboid's server-command event.
-- @returns Whether the value is a structurally valid sync-state response.
____exports.isBFSyncStateResponse = responseSchema
--- Validates an untrusted Pregnancy debug mutation payload.
-- 
-- @param value Raw value received from Project Zomboid's client-command event.
-- @returns Whether the value is a structurally valid Pregnancy mutation request.
____exports.isBFSetPregnancyStateRequest = setPregnancyStateRequestSchema
--- Validates a Pregnancy mutation response, which uses the standard snapshot envelope.
____exports.isBFSetPregnancyStateResponse = responseSchema
--- Validates a normal Pregnancy progression publication payload.
____exports.isBFPublishPregnancyStateRequest = setPregnancyStateRequestSchema
--- Validates a Pregnancy progression response using the standard snapshot envelope.
____exports.isBFPublishPregnancyStateResponse = responseSchema
--- Validates a birth-allocation request, which carries no client-selected domain data.
____exports.isBFAllocateBirthRequest = requestSchema
--- Validates a birth-allocation response using the standard snapshot envelope.
____exports.isBFAllocateBirthResponse = responseSchema
--- Validates a request to complete a server-issued birth operation.
____exports.isBFCompleteBirthRequest = completeBirthRequestSchema
--- Validates a birth-completion response using the standard snapshot envelope.
____exports.isBFCompleteBirthResponse = responseSchema
--- Validates a request to replace one condom in the player's main inventory.
____exports.isBFConvertCondomRequest = convertCondomRequestSchema
--- Validates client-published reversible Womb cycle progression.
____exports.isBFPublishWombStateRequest = publishWombStateRequestSchema
--- Validates a Womb progression response using the standard snapshot envelope.
____exports.isBFPublishWombStateResponse = responseSchema
--- Validates complete client-simulated Lactation publication.
____exports.isBFPublishLactationStateRequest = publishLactationStateRequestSchema
--- Validates a Lactation publication response using the standard snapshot envelope.
____exports.isBFPublishLactationStateResponse = responseSchema
return ____exports
