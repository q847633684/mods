local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____Schema = require('validation/Schema')
local ____string = ____Schema.string
--- Maximum persisted character-identity length accepted from stored or item ModData.
____exports.CHARACTER_ID_MAXIMUM_LENGTH = 64
--- Validates a bounded, non-empty server-generated character identity.
____exports.characterIdSchema = ____string({minimumLength = 1, maximumLength = ____exports.CHARACTER_ID_MAXIMUM_LENGTH})
return ____exports
