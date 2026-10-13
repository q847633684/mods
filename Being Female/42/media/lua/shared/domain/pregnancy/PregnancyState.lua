local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
--- Server-authoritative lifecycle status for the Pregnancy domain.
____exports.PregnancyStatus = PregnancyStatus or ({})
____exports.PregnancyStatus.NOT_PREGNANT = "notPregnant"
____exports.PregnancyStatus.PREGNANT = "pregnant"
--- Creates the default non-pregnant authoritative state.
____exports.createDefaultPregnancyState = function() return {status = ____exports.PregnancyStatus.NOT_PREGNANT, current = 0, progress = 0, isInLabor = false} end
return ____exports
