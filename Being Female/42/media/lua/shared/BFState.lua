local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____PregnancyState = require('domain/pregnancy/PregnancyState')
local createDefaultPregnancyState = ____PregnancyState.createDefaultPregnancyState
local ____BirthState = require('domain/birth/BirthState')
local createDefaultBirthState = ____BirthState.createDefaultBirthState
local ____WombState = require('domain/womb/WombState')
local createDefaultWombState = ____WombState.createDefaultWombState
local ____LactationState = require('domain/lactation/LactationState')
local createDefaultLactationState = ____LactationState.createDefaultLactationState
--- Creates every authoritative domain with its current default state.
____exports.createDefaultDomains = function() return {
    pregnancy = createDefaultPregnancyState(),
    birth = createDefaultBirthState(),
    womb = createDefaultWombState(),
    lactation = createDefaultLactationState()
} end
return ____exports
