local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
--- Creates the neutral Lactation state for a fresh authoritative root.
____exports.createDefaultLactationState = function() return {isActive = false, milkAmount = 0, expiration = 0, multiplier = 0} end
return ____exports
