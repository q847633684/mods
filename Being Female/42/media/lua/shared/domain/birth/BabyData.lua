local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____Schema = require('validation/Schema')
local object = ____Schema.object
local oneOf = ____Schema.oneOf
local positiveInteger = ____Schema.positiveInteger
local ____string = ____Schema.string
local ____CharacterIdentity = require('domain/CharacterIdentity')
local characterIdSchema = ____CharacterIdentity.characterIdSchema
--- Runtime schema for baby item metadata read from untrusted item ModData.
____exports.babyDataSchema = object({
    schemaVersion = oneOf({1}),
    birthId = ____string({minimumLength = 1, maximumLength = 128}),
    motherCharacterId = characterIdSchema,
    motherUsername = ____string({minimumLength = 1, maximumLength = 64}),
    motherName = ____string({minimumLength = 1, maximumLength = 128}),
    birthSequence = positiveInteger
})
--- Creates immutable metadata for a server-allocated baby item.
-- 
-- @param input Named server-owned operation and mother identity captured at birth.
-- @returns Metadata to attach before the item enters an inventory.
____exports.createBabyData = function(input) return {
    schemaVersion = 1,
    birthId = input.birthId,
    motherCharacterId = input.motherCharacterId,
    motherUsername = input.mother.username,
    motherName = input.mother.name,
    birthSequence = input.birthSequence
} end
return ____exports
