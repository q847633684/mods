local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____Schema = require('validation/Schema')
local boolean = ____Schema.boolean
local integer = ____Schema.integer
local number = ____Schema.number
local object = ____Schema.object
local optional = ____Schema.optional
--- Valid recovery and menstrual-cycle range supported by the current Womb model.
local cycleDay = integer({minimum = -56, maximum = 28})
--- Maximum sperm volume supported by the declared Womb capacity sandbox range.
local amount = number({minimum = 0, maximum = 3})
--- Valid cumulative sperm volume.
local total = number({minimum = 0})
--- Runtime schema for persisted and replicated Womb state.
____exports.wombStateSchema = object({cycleDay = cycleDay, amount = amount, total = total, onContraceptive = boolean})
--- Runtime schema for concrete client-published reversible Womb state.
____exports.wombProgressStateSchema = object({
    cycleDay = cycleDay,
    amount = amount,
    total = total,
    onContraceptive = optional(boolean)
})
return ____exports
