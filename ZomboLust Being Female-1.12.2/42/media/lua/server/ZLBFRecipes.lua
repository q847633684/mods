local ____lualib = require('lualib_bundle')
local __TS__New = ____lualib.__TS__New
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local ZombRandFloat = ____pipewrench.ZombRandFloat
local ____ZLBF = require('ZLBF/ZLBF')
local lactation = ____ZLBF.lactation
local womb = ____ZLBF.womb
local _____40constants = require('constants')
local Fluids = _____40constants.Fluids
local ITEMS = _____40constants.ITEMS
local ____FluidContainerApi = require('components/FluidContainerApi')
local FluidContainerApi = ____FluidContainerApi.FluidContainerApi
ZLBFRecipes = {
    OnTest = {
        TakeContraceptive = function(_item, character)
            if not character:isFemale() then
                return false
            end
            if womb.contraceptive then
                return false
            end
            if womb.pregnancy then
                return false
            end
            return true
        end,
        TakeLactaid = function(_item, character)
            if not character:isFemale() then
                return false
            end
            return true
        end,
        HandExpress = function(item, character)
            if not character:isFemale() then
                return false
            end
            if __TS__New(FluidContainerApi, item):isFull() then
                return false
            end
            return lactation.milkAmount >= lactation.bottleAmount * 2
        end,
        BreastPump = function(item, character)
            if not character:isFemale() then
                return false
            end
            if __TS__New(FluidContainerApi, item):isFull() then
                return false
            end
            return character:isFemale() and lactation.milkAmount >= lactation.bottleAmount
        end,
        ClearSperm = function(_item, character)
            if not character:isFemale() then
                return false
            end
            return womb.amount > 0
        end,
        PushCum = function(item, character)
            if not character:isFemale() then
                return false
            end
            if womb.amount <= 0 then
                return false
            end
            return not __TS__New(FluidContainerApi, item):isFull()
        end,
        BreastFeedBaby = function(_item, character)
            if not character:isFemale() then
                return false
            end
            return lactation.milkAmount >= lactation.bottleAmount
        end,
        BottleFeedBaby = function(item, character)
            if not character:isFemale() then
                return false
            end
            if not character:getInventory():contains(ITEMS.BABY) then
                return false
            end
            local container = __TS__New(FluidContainerApi, item)
            if container.primaryFluid ~= Fluids.HUMAN_MILK then
                return false
            end
            return container.amount >= lactation.bottleAmount
        end
    },
    OnCreate = {
        TakeContraceptive = function()
            womb.contraceptive = true
        end,
        TakeLactaid = function()
            lactation:toggle(true)
            local multiplier = lactation.multiplier + ZombRandFloat(0, 0.3)
            lactation:useMilk(0, multiplier)
        end,
        HandExpress = function(items)
            local container = items:getInputItems(0):get(0)
            local amount = __TS__New(FluidContainerApi, container):fill(Fluids.HUMAN_MILK, lactation.bottleAmount)
            lactation:useMilk(
                amount * 2,
                ZombRandFloat(0.05, 0.1)
            )
        end,
        BreastPump = function(items)
            local container = items:getInputItems(1):get(0)
            local amount = __TS__New(FluidContainerApi, container):fill(Fluids.HUMAN_MILK, lactation.bottleAmount)
            lactation:useMilk(
                amount,
                ZombRandFloat(0.1, 0.2)
            )
        end,
        ClearSperm = function(items)
            local container = items:getInputItems(0):get(0)
            __TS__New(FluidContainerApi, container):clear()
            womb.amount = 0
        end,
        PushCum = function(items)
            local container = items:getInputItems(0):get(0)
            local filledAmount = __TS__New(FluidContainerApi, container):fill(Fluids.SEMEN, womb.amount)
            womb.amount = womb.amount - math.min(womb.amount, filledAmount)
        end,
        BreastFeedBaby = function()
            lactation:useMilk(
                lactation.bottleAmount,
                ZombRandFloat(0.2, 0.5)
            )
        end,
        BottleFeedBaby = function(items)
            local container = items:getInputItems(0):get(0)
            __TS__New(FluidContainerApi, container):clear(lactation.bottleAmount)
        end
    }
}
____exports.ZLBFRecipes = ZLBFRecipes
____exports.ZLBFRecipes = ZLBFRecipes
return ____exports
