local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local _____40constants = require('constants')
local BF_STATE_SCHEMA_VERSION = _____40constants.BF_STATE_SCHEMA_VERSION
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local getRandomUUID = ____pipewrench.getRandomUUID
local ____BirthSchema = require('domain/birth/BirthSchema')
local birthStateSchema = ____BirthSchema.birthStateSchema
local ____LactationSchema = require('domain/lactation/LactationSchema')
local lactationStateSchema = ____LactationSchema.lactationStateSchema
local ____PregnancySchema = require('domain/pregnancy/PregnancySchema')
local pregnancyStateSchema = ____PregnancySchema.pregnancyStateSchema
local ____PregnancyReconciler = require('domain/pregnancy/PregnancyReconciler')
local PregnancyReconciler = ____PregnancyReconciler.PregnancyReconciler
local ____WombSchema = require('domain/womb/WombSchema')
local wombStateSchema = ____WombSchema.wombStateSchema
local ____BFState = require('BFState')
local createDefaultDomains = ____BFState.createDefaultDomains
local ____Schema = require('validation/Schema')
local nonNegativeInteger = ____Schema.nonNegativeInteger
local positiveInteger = ____Schema.positiveInteger
local record = ____Schema.record
local ____CharacterIdentity = require('domain/CharacterIdentity')
local characterIdSchema = ____CharacterIdentity.characterIdSchema
--- Normalizes persisted BF state and protects future schemas from accidental downgrade.
____exports.StateMigrator = __TS__Class()
local StateMigrator = ____exports.StateMigrator
StateMigrator.Type = "StateMigrator"
__PW__BaseClassExtends(StateMigrator)
function StateMigrator.prototype.____constructor(self, pregnancy, createCharacterId)
    if pregnancy == nil then
        pregnancy = __TS__New(PregnancyReconciler)
    end
    if createCharacterId == nil then
        createCharacterId = getRandomUUID
    end
    self.pregnancy = pregnancy
    self.createCharacterId = createCharacterId
end
function StateMigrator.prototype.createDefault(self)
    return {
        schemaVersion = BF_STATE_SCHEMA_VERSION,
        characterId = self.createCharacterId(),
        stateVersion = 0,
        domains = createDefaultDomains()
    }
end
function StateMigrator.prototype.migrate(self, persisted)
    if not record(persisted) then
        return self:supported(self:createDefault())
    end
    local persistedSchemaVersion = persisted.schemaVersion
    if positiveInteger(persistedSchemaVersion) and persistedSchemaVersion > BF_STATE_SCHEMA_VERSION then
        return {
            supported = false,
            schemaVersion = persistedSchemaVersion,
            stateVersion = nonNegativeInteger(persisted.stateVersion) and persisted.stateVersion or 0
        }
    end
    if persistedSchemaVersion ~= BF_STATE_SCHEMA_VERSION then
        return self:migrateOlder(persisted)
    end
    if not self:isCurrentState(persisted) then
        return self:supported(self:createDefault())
    end
    return self:supported(self:canonicalize(persisted))
end
function StateMigrator.prototype.migrateOlder(self, persisted)
    repeat
        local ____switch10 = persisted.schemaVersion
        do
            return self:supported(self:createDefault())
        end
    until true
end
function StateMigrator.prototype.isCurrentState(self, value)
    if not characterIdSchema(value.characterId) then
        return false
    end
    return self:hasValidStateAndDomains(value)
end
function StateMigrator.prototype.hasValidStateAndDomains(self, value)
    if not nonNegativeInteger(value.stateVersion) or not record(value.domains) then
        return false
    end
    local domains = value.domains
    if not pregnancyStateSchema(domains.pregnancy) or not birthStateSchema(domains.birth) or not wombStateSchema(domains.womb) or not lactationStateSchema(domains.lactation) then
        return false
    end
    return self.pregnancy:isConsistent(domains.pregnancy)
end
function StateMigrator.prototype.canonicalize(self, state)
    local birth = state.domains.birth
    local pregnancy = state.domains.pregnancy
    local womb = state.domains.womb
    local lactation = state.domains.lactation
    return {
        schemaVersion = BF_STATE_SCHEMA_VERSION,
        characterId = state.characterId,
        stateVersion = state.stateVersion,
        domains = {
            pregnancy = {status = pregnancy.status, current = pregnancy.current, progress = pregnancy.progress, isInLabor = pregnancy.isInLabor},
            birth = __TS__ObjectAssign({birthSequence = birth.birthSequence}, birth.pendingBirthId ~= nil and ({pendingBirthId = birth.pendingBirthId}) or ({}), birth.completedBirthId ~= nil and ({completedBirthId = birth.completedBirthId}) or ({})),
            womb = {cycleDay = womb.cycleDay, amount = womb.amount, total = womb.total, onContraceptive = womb.onContraceptive},
            lactation = {isActive = lactation.isActive, milkAmount = lactation.milkAmount, expiration = lactation.expiration, multiplier = lactation.multiplier}
        }
    }
end
function StateMigrator.prototype.supported(self, state)
    return {supported = true, schemaVersion = state.schemaVersion, stateVersion = state.stateVersion, state = state}
end
return ____exports
