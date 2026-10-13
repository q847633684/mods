local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
--- Creates the neutral complete Womb state for a fresh authoritative root.
____exports.createDefaultWombState = function() return {cycleDay = 1, amount = 0, total = 0, onContraceptive = false} end
return ____exports
