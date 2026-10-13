local ____lualib = require('lualib_bundle')
local __TS__New = ____lualib.__TS__New
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local _____40constants = require('constants')
local Fluids = _____40constants.Fluids
local ITEMS = _____40constants.ITEMS
local BFTraitsEnum = _____40constants.BFTraitsEnum
local ____FluidContainerApi = require('components/FluidContainerApi')
local FluidContainerApi = ____FluidContainerApi.FluidContainerApi
local ____RecipeActorState = require('components/RecipeActorState')
local readRecipeActorState = ____RecipeActorState.readRecipeActorState
local resolveRecipeLactation = ____RecipeActorState.resolveRecipeLactation
local ____CharacterTraitApi = require('components/CharacterTraitApi')
local CharacterTraitApi = ____CharacterTraitApi.CharacterTraitApi
local ____PregnancyState = require('domain/pregnancy/PregnancyState')
local PregnancyStatus = ____PregnancyState.PregnancyStatus
--- Standard recipe transfer volume in liters.
____exports.RECIPE_BOTTLE_AMOUNT = 0.2
--- Resolves Pregnancy with authoritative status before explicit legacy status or trait presence.
local function isPregnant(character)
    local actor = readRecipeActorState(character)
    local ____opt_0 = actor.authoritative
    local authoritative = ____opt_0 and ____opt_0.pregnancy.status
    if authoritative ~= nil then
        return authoritative == PregnancyStatus.PREGNANT
    end
    local ____opt_2 = actor.pregnancy
    local legacyStatus = ____opt_2 and ____opt_2.status
    if legacyStatus ~= nil then
        return legacyStatus == PregnancyStatus.PREGNANT
    end
    return CharacterTraitApi:hasTrait(character, BFTraitsEnum.PREGNANCY)
end
--- Shared-safe callbacks used by both client recipe menus and server validation.
-- Every callback is read-only and resolves state from its supplied character.
____exports.BFRecipeTests = {
    TakeContraceptive = function(_item, character)
        if not character:isFemale() then
            return false
        end
        local actor = readRecipeActorState(character)
        local ____opt_4 = actor.authoritative
        local ____temp_8 = ____opt_4 and ____opt_4.womb.onContraceptive
        if ____temp_8 == nil then
            local ____opt_6 = actor.womb
            ____temp_8 = ____opt_6 and ____opt_6.onContraceptive
        end
        if ____temp_8 then
            return false
        end
        local ____opt_9 = actor.authoritative
        local ____temp_13 = ____opt_9 and ____opt_9.womb.cycleDay
        if ____temp_13 == nil then
            local ____opt_11 = actor.womb
            ____temp_13 = ____opt_11 and ____opt_11.cycleDay
        end
        if (____temp_13 or 0) < 1 then
            return false
        end
        return not isPregnant(character)
    end,
    TakeLactaid = function(_item, character) return character:isFemale() end,
    HandExpress = function(item, character) return character:isFemale() and not __TS__New(FluidContainerApi, item):isFull() and resolveRecipeLactation(readRecipeActorState(character)).milkAmount >= ____exports.RECIPE_BOTTLE_AMOUNT * 2 end,
    BreastPump = function(item, character) return character:isFemale() and not __TS__New(FluidContainerApi, item):isFull() and resolveRecipeLactation(readRecipeActorState(character)).milkAmount >= ____exports.RECIPE_BOTTLE_AMOUNT end,
    ClearSperm = function(_item, character)
        local actor = readRecipeActorState(character)
        local ____temp_19 = character:isFemale()
        if ____temp_19 then
            local ____opt_14 = actor.authoritative
            local ____temp_18 = ____opt_14 and ____opt_14.womb.amount
            if ____temp_18 == nil then
                local ____opt_16 = actor.womb
                ____temp_18 = ____opt_16 and ____opt_16.amount
            end
            ____temp_19 = (____temp_18 or 0) > 0
        end
        return ____temp_19
    end,
    PushCum = function(item, character)
        local actor = readRecipeActorState(character)
        local ____temp_25 = character:isFemale()
        if ____temp_25 then
            local ____opt_20 = actor.authoritative
            local ____temp_24 = ____opt_20 and ____opt_20.womb.amount
            if ____temp_24 == nil then
                local ____opt_22 = actor.womb
                ____temp_24 = ____opt_22 and ____opt_22.amount
            end
            ____temp_25 = (____temp_24 or 0) > 0
        end
        return ____temp_25 and not __TS__New(FluidContainerApi, item):isFull()
    end,
    BreastFeedBaby = function(_item, character) return character:isFemale() and resolveRecipeLactation(readRecipeActorState(character)).milkAmount >= ____exports.RECIPE_BOTTLE_AMOUNT end,
    BottleFeedBaby = function(item, character)
        if not character:isFemale() or not character:getInventory():contains(ITEMS.BABY) then
            return false
        end
        local container = __TS__New(FluidContainerApi, item)
        return container.primaryFluid == Fluids.HUMAN_MILK and container.amount >= ____exports.RECIPE_BOTTLE_AMOUNT
    end
}
BFRecipes = BFRecipes or ({})
BFRecipes.OnTest = ____exports.BFRecipeTests
return ____exports
