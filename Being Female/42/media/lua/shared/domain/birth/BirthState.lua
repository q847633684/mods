local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
--- Creates the default birth lifecycle state for a player without prior operations.
____exports.createDefaultBirthState = function() return {birthSequence = 0} end
return ____exports
