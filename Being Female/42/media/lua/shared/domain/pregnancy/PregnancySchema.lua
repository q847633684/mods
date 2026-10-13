local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____PregnancyState = require('domain/pregnancy/PregnancyState')
local PregnancyStatus = ____PregnancyState.PregnancyStatus
local ____Schema = require('validation/Schema')
local boolean = ____Schema.boolean
local nonNegativeInteger = ____Schema.nonNegativeInteger
local number = ____Schema.number
local object = ____Schema.object
local oneOf = ____Schema.oneOf
--- Runtime schema for persisted and networked Pregnancy domain state.
____exports.pregnancyStateSchema = object({
    status = oneOf({PregnancyStatus.NOT_PREGNANT, PregnancyStatus.PREGNANT}),
    current = nonNegativeInteger,
    progress = number({minimum = 0, maximum = 1}),
    isInLabor = boolean
})
return ____exports
