local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____Schema = require('validation/Schema')
local integer = ____Schema.integer
--- Reads and validates Pregnancy recovery configuration in client or server Lua.
____exports.PregnancyRecoveryOptions = __TS__Class()
local PregnancyRecoveryOptions = ____exports.PregnancyRecoveryOptions
PregnancyRecoveryOptions.Type = "PregnancyRecoveryOptions"
__PW__BaseClassExtends(PregnancyRecoveryOptions)
function PregnancyRecoveryOptions.prototype.____constructor(self)
end
function PregnancyRecoveryOptions.prototype.read(self)
    local globals = _G
    local ____opt_2 = globals.SandboxVars
    local ____opt_0 = ____opt_2 and ____opt_2.BF
    local value = ____opt_0 and ____opt_0.PregnancyRecovery
    return ____exports.PregnancyRecoveryOptions.validDays(value) and ({days = value, usedFallback = false}) or ({days = ____exports.PregnancyRecoveryOptions.defaultDays, usedFallback = true})
end
PregnancyRecoveryOptions.defaultDays = 7
PregnancyRecoveryOptions.validDays = integer({minimum = 0, maximum = 56})
return ____exports
