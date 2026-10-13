local ____lualib = require('lualib_bundle')
local __TS__New = ____lualib.__TS__New
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local isServer = ____pipewrench.isServer
local sendServerCommand = ____pipewrench.sendServerCommand
local _____40constants = require('constants')
local Fluids = _____40constants.Fluids
local BF_NETWORK_MODULE = _____40constants.BF_NETWORK_MODULE
local BF_PROTOCOL_SCHEMA_VERSION = _____40constants.BF_PROTOCOL_SCHEMA_VERSION
local BFNetworkCommand = _____40constants.BFNetworkCommand
local BFSyncStatus = _____40constants.BFSyncStatus
local BFTraitsEnum = _____40constants.BFTraitsEnum
local ____FluidContainerApi = require('components/FluidContainerApi')
local FluidContainerApi = ____FluidContainerApi.FluidContainerApi
local ____RecipeActorState = require('components/RecipeActorState')
local readRecipeActorState = ____RecipeActorState.readRecipeActorState
local resolveRecipeLactation = ____RecipeActorState.resolveRecipeLactation
local ____StateRepository = require('components/state/StateRepository')
local StateRepository = ____StateRepository.StateRepository
local ____BFRecipeTests = require('BFRecipeTests')
local RECIPE_BOTTLE_AMOUNT = ____BFRecipeTests.RECIPE_BOTTLE_AMOUNT
local BFRecipeTests = ____BFRecipeTests.BFRecipeTests
local ____CharacterTraitApi = require('components/CharacterTraitApi')
local CharacterTraitApi = ____CharacterTraitApi.CharacterTraitApi
local ____LactationBalance = require('domain/lactation/LactationBalance')
local addLactaidStimulation = ____LactationBalance.addLactaidStimulation
local applyMilkRemoval = ____LactationBalance.applyMilkRemoval
local lactationDuration = ____LactationBalance.lactationDuration
local ____BFSandboxOptions = require('components/BFSandboxOptions')
local configuredLactationDurationHours = ____BFSandboxOptions.configuredLactationDurationHours
local states = __TS__New(StateRepository)
--- Returns whether this recipe callback is executing on multiplayer server authority.
local function isServerRecipeContext()
    return type(isServer) == "function" and isServer()
end
--- Persists a focused recipe mutation and acknowledges the resulting snapshot in multiplayer.
-- 
-- @param player Callback-supplied actor whose authoritative root is mutated.
-- @param loaded Supported state loaded before any recipe side effect.
-- @param mutate Domain mutation applied only to a supported current authoritative state.
-- @returns Nothing; unsupported future state is preserved without acknowledgement.
local function saveRecipeState(player, loaded, mutate)
    mutate(loaded.state)
    local ____loaded_state_0, ____stateVersion_1 = loaded.state, "stateVersion"
    ____loaded_state_0[____stateVersion_1] = ____loaded_state_0[____stateVersion_1] + 1
    loaded.stateVersion = loaded.state.stateVersion
    states:save(player, loaded.state)
    if not isServerRecipeContext() then
        return
    end
    local response = {
        schemaVersion = BF_PROTOCOL_SCHEMA_VERSION,
        requestId = "recipe-" .. tostring(loaded.stateVersion),
        revision = loaded.stateVersion,
        status = BFSyncStatus.OK,
        data = {snapshot = loaded.state}
    }
    sendServerCommand(player, BF_NETWORK_MODULE, BFNetworkCommand.RECIPE_STATE_RESPONSE, response)
end
--- Returns the actor's configured lactation duration with trait modification applied once.
-- 
-- @param player Recipe actor whose Dairy Cow trait controls duration.
-- @returns Duration in game hours.
local function refreshedLactationDuration(player)
    return lactationDuration(
        configuredLactationDurationHours(),
        CharacterTraitApi:hasTrait(player, BFTraitsEnum.DAIRY_COW)
    )
end
--- Resolves, writes, persists, and acknowledges one actor-scoped Lactation mutation.
-- Single-player keeps its local gameplay backend; multiplayer server callbacks write only the
-- authoritative root.
-- 
-- @param player Callback-supplied actor whose Lactation state changes.
-- @param loaded Supported state loaded before any recipe side effect.
-- @param mutate Pure transformation applied to the resolved complete state.
-- @returns Nothing; local state is updated only in single-player contexts.
local function saveLactation(player, loaded, mutate)
    local actor = readRecipeActorState(player)
    local next = mutate(resolveRecipeLactation(actor))
    if not isServerRecipeContext() then
        player:getModData().BFLactation = next
    end
    saveRecipeState(
        player,
        loaded,
        function(state)
            state.domains.lactation = next
        end
    )
end
--- Synchronizes fields only when a recipe mutates its item in server context.
-- 
-- @param item Authoritatively mutated fluid item to broadcast.
-- @returns Nothing; single-player and client contexts remain local no-ops.
local function syncFluidItem(item)
    if isServerRecipeContext() then
        item:syncItemFields()
    end
end
--- Preflights recipe side effects without overwriting a future state schema.
-- 
-- @param player Callback actor whose authoritative root controls mutation support.
-- @returns Supported state, or undefined when the persisted schema cannot be mutated.
local function loadRecipeState(player)
    local loaded = states:load(player)
    return loaded.supported and loaded or nil
end
BFRecipes = {
    OnTest = BFRecipeTests,
    OnCreate = {
        TakeContraceptive = function(_items, character)
            local player = character
            local loaded = loadRecipeState(player)
            if not loaded then
                return
            end
            local actor = readRecipeActorState(character)
            if not isServerRecipeContext() and actor.womb then
                actor.womb.onContraceptive = true
            end
            saveRecipeState(
                player,
                loaded,
                function(state)
                    state.domains.womb = __TS__ObjectAssign({}, state.domains.womb, {onContraceptive = true})
                end
            )
        end,
        TakeLactaid = function(_items, character)
            local player = character
            local loaded = loadRecipeState(player)
            if not loaded then
                return
            end
            saveLactation(
                player,
                loaded,
                function(current) return __TS__ObjectAssign(
                    {},
                    current,
                    {
                        isActive = true,
                        expiration = refreshedLactationDuration(player),
                        multiplier = addLactaidStimulation(current.multiplier)
                    }
                ) end
            )
        end,
        HandExpress = function(items, character)
            local player = character
            local loaded = loadRecipeState(player)
            if not loaded then
                return
            end
            local container = items:getInputItems(0):get(0)
            local amount = __TS__New(FluidContainerApi, container):fill(Fluids.HUMAN_MILK, RECIPE_BOTTLE_AMOUNT)
            syncFluidItem(container)
            saveLactation(
                player,
                loaded,
                function(current) return applyMilkRemoval(
                    current,
                    amount * 2,
                    refreshedLactationDuration(player)
                ) end
            )
        end,
        BreastPump = function(items, character)
            local player = character
            local loaded = loadRecipeState(player)
            if not loaded then
                return
            end
            local container = items:getInputItems(1):get(0)
            local amount = __TS__New(FluidContainerApi, container):fill(Fluids.HUMAN_MILK, RECIPE_BOTTLE_AMOUNT)
            syncFluidItem(container)
            saveLactation(
                player,
                loaded,
                function(current) return applyMilkRemoval(
                    current,
                    amount,
                    refreshedLactationDuration(player)
                ) end
            )
        end,
        ClearSperm = function(items, character)
            local player = character
            local loaded = loadRecipeState(player)
            if not loaded then
                return
            end
            local container = items:getInputItems(0):get(0)
            __TS__New(FluidContainerApi, container):clear()
            syncFluidItem(container)
            local actor = readRecipeActorState(character)
            if not isServerRecipeContext() and actor.womb then
                actor.womb.amount = 0
            end
            saveRecipeState(
                player,
                loaded,
                function(state)
                    state.domains.womb = __TS__ObjectAssign({}, state.domains.womb, {amount = 0})
                end
            )
        end,
        PushCum = function(items, character)
            local player = character
            local loaded = loadRecipeState(player)
            if not loaded then
                return
            end
            local actor = readRecipeActorState(character)
            local ____opt_2 = actor.authoritative
            local ____temp_6 = ____opt_2 and ____opt_2.womb.amount
            if ____temp_6 == nil then
                local ____opt_4 = actor.womb
                ____temp_6 = ____opt_4 and ____opt_4.amount
            end
            local current = ____temp_6 or 0
            local container = items:getInputItems(0):get(0)
            local filled = __TS__New(FluidContainerApi, container):fill(Fluids.SEMEN, current)
            syncFluidItem(container)
            local remaining = current - math.min(current, filled)
            if not isServerRecipeContext() and actor.womb then
                actor.womb.amount = remaining
            end
            saveRecipeState(
                player,
                loaded,
                function(state)
                    state.domains.womb = __TS__ObjectAssign({}, state.domains.womb, {amount = remaining})
                end
            )
        end,
        BreastFeedBaby = function(_items, character)
            local player = character
            local loaded = loadRecipeState(player)
            if not loaded then
                return
            end
            saveLactation(
                player,
                loaded,
                function(current) return applyMilkRemoval(
                    current,
                    RECIPE_BOTTLE_AMOUNT,
                    refreshedLactationDuration(player)
                ) end
            )
        end,
        BottleFeedBaby = function(items, character)
            if not loadRecipeState(character) then
                return
            end
            local container = items:getInputItems(0):get(0)
            __TS__New(FluidContainerApi, container):clear(RECIPE_BOTTLE_AMOUNT)
            syncFluidItem(container)
        end
    }
}
____exports.BFRecipes = BFRecipes
____exports.BFRecipes = BFRecipes
return ____exports
