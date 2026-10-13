local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
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
local ____Utils = require('ZLBF/Utils')
local increaseClamped = ____Utils.increaseClamped
local ____ModData = require('ZLBF/components/ModData')
local ModData = ____ModData.ModData
____exports.Player = __TS__Class()
local Player = ____exports.Player
Player.Type = "Player"
__PW__BaseClassExtends(Player)
function Player.prototype.____constructor(self, modKey)
    self.modKey = modKey
    Events.onCreatePlayer:addListener(function(_, player) return self:onCreatePlayer(player) end)
end
function Player.prototype.onCreatePlayer(self, player)
    self.player = player
    if self.modKey then
        self.modData = __TS__New(ModData, {object = player, modKey = self.modKey, defaultData = self.defaultData})
        if not self.data and self.defaultData then
            self.data = self.defaultData
        end
    end
end
function Player.prototype.getBodyPart(self, part)
    if not self.player then
        return nil
    end
    return self.player:getBodyDamage():getBodyPart(part)
end
function Player.prototype.applyBodyEffect(self, part, ____bindingPattern0)
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
function Player.prototype.applyStatEffect(self, ____bindingPattern0)
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
    local current = stats:get(statKey)
    stats:set(
        statKey,
        increaseClamped(current, value, maxValue)
    )
end
function Player.prototype.hasItem(self, itemName, recursive)
    if recursive == nil then
        recursive = false
    end
    local ____opt_2 = self.player
    local ____temp_4 = ____opt_2 and ____opt_2:getInventory():contains(itemName, recursive)
    if ____temp_4 == nil then
        ____temp_4 = false
    end
    return ____temp_4
end
function Player.prototype.haloText(self, props)
    if not self.player then
        return
    end
    local ____props_5 = props
    local text = ____props_5.text
    local style = ____props_5.style
    repeat
        local ____switch19 = style
        local ____cond19 = ____switch19 == "good"
        if ____cond19 then
            HaloTextHelper.addGoodText(self.player, text)
            break
        end
        ____cond19 = ____cond19 or ____switch19 == "bad"
        if ____cond19 then
            HaloTextHelper.addBadText(self.player, text)
            break
        end
        do
            HaloTextHelper.addText(self.player, text)
        end
    until true
end
function Player.prototype.hasTrait(self, trait)
    local ____table_player_6
    if self.player then
        ____table_player_6 = CharacterTraitApi:hasTrait(self.player, trait)
    else
        ____table_player_6 = false
    end
    return ____table_player_6
end
function Player.prototype.addTrait(self, trait)
    if not self.player then
        return
    end
    CharacterTraitApi:addTrait(self.player, trait)
end
function Player.prototype.removeTrait(self, trait)
    if not self.player then
        return
    end
    CharacterTraitApi:removeTrait(self.player, trait)
end
function Player.hasTrait(self, player, trait)
    if not player then
        return false
    end
    return CharacterTraitApi:hasTrait(player, trait)
end
__TS__SetDescriptor(
    Player.prototype,
    "skinColorIndex",
    {get = function(self)
        local ____opt_7 = self.player
        return ____opt_7 and ____opt_7:getHumanVisual():getSkinTextureIndex() or 0
    end},
    true
)
__TS__SetDescriptor(
    Player.prototype,
    "data",
    {
        get = function(self)
            local ____opt_9 = self.modData
            local ____temp_11 = ____opt_9 and ____opt_9.data
            if ____temp_11 == nil then
                ____temp_11 = nil
            end
            return ____temp_11
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
return ____exports
