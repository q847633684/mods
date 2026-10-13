local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local ____exports = {}
--- Default configured lactation duration in days.
local DEFAULT_LACTATION_DURATION_DAYS = 7
--- Reads the configured base lactation duration in hours in any Lua execution context.
-- 
-- @returns Configured MilkExpiration days converted to game hours.
____exports.configuredLactationDurationHours = function()
    local globals = _G
    local ____opt_2 = globals.SandboxVars
    local ____opt_0 = ____opt_2 and ____opt_2.BF
    return (____opt_0 and ____opt_0.MilkExpiration or DEFAULT_LACTATION_DURATION_DAYS) * 24
end
return ____exports
