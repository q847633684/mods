local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__New = ____lualib.__TS__New
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local HaloTextHelper = ____pipewrench.HaloTextHelper
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
local ____CharacterTraitApi = require('components/CharacterTraitApi')
local CharacterTraitApi = ____CharacterTraitApi.CharacterTraitApi
local ____Utils = require('BF/Utils')
local increaseClamped = ____Utils.increaseClamped
local ____ModData = require('BF/components/ModData')
local ModData = ____ModData.ModData
local ____Player = require('components/Player')
local SharedPlayer = ____Player.Player
____exports.LocalPlayer = __TS__Class()
local LocalPlayer = ____exports.LocalPlayer
LocalPlayer.Type = "LocalPlayer"
__PW__ClassExtendsPatch(LocalPlayer, SharedPlayer)
__TS__ClassExtends(LocalPlayer, SharedPlayer)
function LocalPlayer.prototype.____constructor(self, modKey)
    SharedPlayer.prototype.____constructor(self)
    self.modKey = modKey
    Events.onCreatePlayer:addListener(function(_, player) return self:onCreatePlayer(player) end)
end
function LocalPlayer.prototype.onCreatePlayer(self, player)
    self:bind(player)
    if self.modKey then
        self.modData = __TS__New(ModData, {object = player, modKey = self.modKey, defaultData = self.defaultData})
        if not self.data and self.defaultData then
            self.data = self.defaultData
        end
    end
end
function LocalPlayer.prototype.getBodyPart(self, part)
    if not self.player then
        return nil
    end
    return self.player:getBodyDamage():getBodyPart(part)
end
function LocalPlayer.prototype.applyBodyEffect(self, part, ____bindingPattern0)
    if ____bindingPattern0 == nil then
        ____bindingPattern0 = {}
    end
    local wetness
    local bleedTime
    local maxPain
    local pain
    pain = ____bindingPattern0.pain
    if pain == nil then
        pain = 0
    end
    maxPain = ____bindingPattern0.maxPain
    bleedTime = ____bindingPattern0.bleedTime
    if bleedTime == nil then
        bleedTime = 0
    end
    wetness = ____bindingPattern0.wetness
    if wetness == nil then
        wetness = 0
    end
    local bodyPart = self:getBodyPart(part)
    if not bodyPart then
        return
    end
    if pain > 0 then
        local current = bodyPart:getAdditionalPain()
        bodyPart:setAdditionalPain(increaseClamped(current, pain, maxPain))
    end
    if bleedTime > 0 then
        local current = bodyPart:getBleedingTime()
        bodyPart:setBleedingTime(increaseClamped(current, bleedTime))
    end
    if wetness > 0 then
        local current = bodyPart:getWetness()
        bodyPart:setWetness(increaseClamped(current, wetness))
    end
end
function LocalPlayer.prototype.applyStatEffect(self, ____bindingPattern0)
    local maxValue
    local value
    local stat
    stat = ____bindingPattern0.stat
    value = ____bindingPattern0.value
    maxValue = ____bindingPattern0.maxValue
    local ____opt_0 = self.player
    local stats = ____opt_0 and ____opt_0:getStats()
    if not stats then
        return
    end
    local statKey = CharacterStat[stat]
    if maxValue == nil then
        stats:add(statKey, value)
        return
    end
    stats:set(
        statKey,
        increaseClamped(
            stats:get(statKey),
            value,
            maxValue
        )
    )
end
function LocalPlayer.prototype.getStatValue(self, stat, fallback)
    if fallback == nil then
        fallback = 0
    end
    local ____opt_2 = self.player
    local stats = ____opt_2 and ____opt_2:getStats()
    if not stats then
        return fallback
    end
    return stats:get(CharacterStat[stat])
end
function LocalPlayer.prototype.applyNutritionEffect(self, effects)
    local ____opt_4 = self.player
    local nutrition = ____opt_4 and ____opt_4:getNutrition()
    if not nutrition then
        return
    end
    if effects.calories ~= nil then
        nutrition:setCalories(nutrition:getCalories() + effects.calories)
    end
    if effects.carbohydrates ~= nil then
        nutrition:setCarbohydrates(nutrition:getCarbohydrates() + effects.carbohydrates)
    end
    if effects.lipids ~= nil then
        nutrition:setLipids(nutrition:getLipids() + effects.lipids)
    end
    if effects.proteins ~= nil then
        nutrition:setProteins(nutrition:getProteins() + effects.proteins)
    end
end
function LocalPlayer.prototype.hasItem(self, itemName, recursive)
    if recursive == nil then
        recursive = false
    end
    local ____opt_6 = self.player
    local ____temp_8 = ____opt_6 and ____opt_6:getInventory():contains(itemName, recursive)
    if ____temp_8 == nil then
        ____temp_8 = false
    end
    return ____temp_8
end
function LocalPlayer.prototype.haloText(self, props)
    if not self.player then
        return
    end
    local ____props_9 = props
    local text = ____props_9.text
    local style = ____props_9.style
    repeat
        local ____switch28 = style
        local ____cond28 = ____switch28 == "good"
        if ____cond28 then
            HaloTextHelper.addGoodText(self.player, text)
            break
        end
        ____cond28 = ____cond28 or ____switch28 == "bad"
        if ____cond28 then
            HaloTextHelper.addBadText(self.player, text)
            break
        end
        do
            HaloTextHelper.addText(self.player, text)
        end
    until true
end
function LocalPlayer.prototype.hasTrait(self, trait)
    local ____table_player_10
    if self.player then
        ____table_player_10 = CharacterTraitApi:hasTrait(self.player, trait)
    else
        ____table_player_10 = false
    end
    return ____table_player_10
end
function LocalPlayer.prototype.addTrait(self, trait)
    if not self.player then
        return
    end
    CharacterTraitApi:addTrait(self.player, trait)
end
function LocalPlayer.prototype.removeTrait(self, trait)
    if not self.player then
        return
    end
    CharacterTraitApi:removeTrait(self.player, trait)
end
function LocalPlayer.hasTrait(self, player, trait)
    if not player then
        return false
    end
    return CharacterTraitApi:hasTrait(player, trait)
end
__TS__SetDescriptor(
    LocalPlayer.prototype,
    "skinColorIndex",
    {get = function(self)
        local ____opt_11 = self.player
        return ____opt_11 and ____opt_11:getHumanVisual():getSkinTextureIndex() or 0
    end},
    true
)
__TS__SetDescriptor(
    LocalPlayer.prototype,
    "data",
    {
        get = function(self)
            local ____opt_13 = self.modData
            local ____temp_15 = ____opt_13 and ____opt_13.data
            if ____temp_15 == nil then
                ____temp_15 = nil
            end
            return ____temp_15
        end,
        set = function(self, value)
            if not self.modData then
                return
            end
            self.modData.data = value
        end
    },
    true
)
____exports.Player = ____exports.LocalPlayer
return ____exports
