local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____Schema = require('validation/Schema')
local nonNegativeInteger = ____Schema.nonNegativeInteger
local object = ____Schema.object
local optional = ____Schema.optional
local ____string = ____Schema.string
--- Runtime schema for persisted and networked birth lifecycle state.
____exports.birthStateSchema = object({
    birthSequence = nonNegativeInteger,
    pendingBirthId = optional(____string({minimumLength = 1, maximumLength = 128})),
    completedBirthId = optional(____string({minimumLength = 1, maximumLength = 128}))
})
return ____exports
