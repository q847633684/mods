local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringStartsWith = ____lualib.__TS__StringStartsWith
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
--- Build 42 trait operations for IsoPlayer.
____exports.CharacterTraitApi = __TS__Class()
local CharacterTraitApi = ____exports.CharacterTraitApi
CharacterTraitApi.Type = "CharacterTraitApi"
__PW__BaseClassExtends(CharacterTraitApi)
function CharacterTraitApi.prototype.____constructor(self)
end
function CharacterTraitApi.normalizeTraitId(self, value)
    local normalized = string.lower(__TS__StringTrim(value))
    return __TS__StringStartsWith(normalized, "base:") and string.sub(normalized, 6) or normalized
end
function CharacterTraitApi.resolveTrait(self, traitId)
    local traitLocation = ResourceLocation.of(self:normalizeTraitId(traitId))
    return CharacterTrait.get(traitLocation)
end
function CharacterTraitApi.matchesTraitId(self, trait, traitId)
    local normalizedTraitId = self:normalizeTraitId(traitId)
    local traitName = trait:getName()
    if traitName and self:normalizeTraitId(traitName) == normalizedTraitId then
        return true
    end
    local traitString = tostring(trait)
    return not not traitString and self:normalizeTraitId(traitString) == normalizedTraitId
end
function CharacterTraitApi.hasKnownTrait(self, knownTraits, traitId)
    do
        local index = 0
        while index < knownTraits:size() do
            if self:matchesTraitId(
                knownTraits:get(index),
                traitId
            ) then
                return true
            end
            index = index + 1
        end
    end
    return false
end
function CharacterTraitApi.getCharacterTraits(self, player)
    return player:getCharacterTraits()
end
function CharacterTraitApi.hasTrait(self, player, traitId)
    local characterTraits = self:getCharacterTraits(player)
    local trait = self:resolveTrait(traitId)
    if trait then
        return characterTraits:get(trait)
    end
    return self:hasKnownTrait(
        characterTraits:getKnownTraits(),
        traitId
    )
end
function CharacterTraitApi.addTrait(self, player, traitId)
    local characterTraits = self:getCharacterTraits(player)
    local trait = self:resolveTrait(traitId)
    if trait and not characterTraits:get(trait) then
        characterTraits:add(trait)
    end
end
function CharacterTraitApi.removeTrait(self, player, traitId)
    local characterTraits = self:getCharacterTraits(player)
    local trait = self:resolveTrait(traitId)
    if trait then
        characterTraits:remove(trait)
    end
end
return ____exports
