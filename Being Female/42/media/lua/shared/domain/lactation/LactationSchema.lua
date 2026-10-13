local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____Schema = require('validation/Schema')
local boolean = ____Schema.boolean
local number = ____Schema.number
local object = ____Schema.object
--- Runtime validator for complete persisted Lactation state.
____exports.lactationStateSchema = object({
    isActive = boolean,
    milkAmount = number({minimum = 0}),
    expiration = number({minimum = 0}),
    multiplier = number({minimum = 0})
})
return ____exports
