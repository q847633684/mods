local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local _____40constants = require('constants')
local BFTraitsEnum = _____40constants.BFTraitsEnum
local ____CharacterTraitApi = require('components/CharacterTraitApi')
local CharacterTraitApi = ____CharacterTraitApi.CharacterTraitApi
local ____ModData = require('BF/components/ModData')
local ModData = ____ModData.ModData
local DEFAULT_PREGNANCY_DATA = {current = 0, progress = 0, isInLabor = false}
____exports.PregnancyState = __TS__Class()
local PregnancyState = ____exports.PregnancyState
PregnancyState.Type = "PregnancyState"
__PW__BaseClassExtends(PregnancyState)
function PregnancyState.prototype.____constructor(self)
end
function PregnancyState.getStore(self, player)
    return __TS__New(ModData, {object = player, modKey = self.modKey, defaultData = DEFAULT_PREGNANCY_DATA})
end
function PregnancyState.initialize(self, player)
    self:getStore(player)
end
function PregnancyState.get(self, player)
    if not player then
        return nil
    end
    if not CharacterTraitApi:hasTrait(player, BFTraitsEnum.PREGNANCY) then
        return nil
    end
    return self:getStored(player)
end
function PregnancyState.getStored(self, player)
    if not player then
        return nil
    end
    return self:getStore(player).data or nil
end
function PregnancyState.set(self, player, value)
    if not player then
        return
    end
    self:getStore(player).data = value
end
PregnancyState.modKey = "BFPregnancy"
return ____exports
