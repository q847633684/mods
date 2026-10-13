local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local isDebugEnabled = ____pipewrench.isDebugEnabled
local sendServerCommand = ____pipewrench.sendServerCommand
local instanceItem = ____pipewrench.instanceItem
local _____40constants = require('constants')
local BF_STATE_SCHEMA_VERSION = _____40constants.BF_STATE_SCHEMA_VERSION
local BF_NETWORK_MODULE = _____40constants.BF_NETWORK_MODULE
local BF_PROTOCOL_SCHEMA_VERSION = _____40constants.BF_PROTOCOL_SCHEMA_VERSION
local ITEMS = _____40constants.ITEMS
local BFTraitsEnum = _____40constants.BFTraitsEnum
local BFNetworkCommand = _____40constants.BFNetworkCommand
local BFSyncStatus = _____40constants.BFSyncStatus
local ____BFProtocol = require('BFProtocol')
local isBFSetPregnancyStateRequest = ____BFProtocol.isBFSetPregnancyStateRequest
local isBFAllocateBirthRequest = ____BFProtocol.isBFAllocateBirthRequest
local isBFCompleteBirthRequest = ____BFProtocol.isBFCompleteBirthRequest
local isBFConvertCondomRequest = ____BFProtocol.isBFConvertCondomRequest
local isBFPublishWombStateRequest = ____BFProtocol.isBFPublishWombStateRequest
local isBFPublishLactationStateRequest = ____BFProtocol.isBFPublishLactationStateRequest
local isBFSyncStateRequest = ____BFProtocol.isBFSyncStateRequest
local ____StateRepository = require('components/state/StateRepository')
local StateRepository = ____StateRepository.StateRepository
local ____PregnancyReconciler = require('domain/pregnancy/PregnancyReconciler')
local PregnancyReconciler = ____PregnancyReconciler.PregnancyReconciler
local ____PregnancyState = require('domain/pregnancy/PregnancyState')
local createDefaultPregnancyState = ____PregnancyState.createDefaultPregnancyState
local PregnancyStatus = ____PregnancyState.PregnancyStatus
local ____CharacterTraitApi = require('components/CharacterTraitApi')
local CharacterTraitApi = ____CharacterTraitApi.CharacterTraitApi
local ____BirthState = require('domain/birth/BirthState')
local createDefaultBirthState = ____BirthState.createDefaultBirthState
local ____BirthOperationAllocator = require('components/BirthOperationAllocator')
local BirthOperationAllocator = ____BirthOperationAllocator.BirthOperationAllocator
local ____Player = require('components/Player')
local Player = ____Player.Player
local ____BabyData = require('domain/birth/BabyData')
local createBabyData = ____BabyData.createBabyData
local ____PregnancyRecoveryOptions = require('components/PregnancyRecoveryOptions')
local PregnancyRecoveryOptions = ____PregnancyRecoveryOptions.PregnancyRecoveryOptions
local ____WombState = require('domain/womb/WombState')
local createDefaultWombState = ____WombState.createDefaultWombState
local ____LactationState = require('domain/lactation/LactationState')
local createDefaultLactationState = ____LactationState.createDefaultLactationState
--- Validates and handles BF commands received in the server execution context.
____exports.CommandHandler = __TS__Class()
local CommandHandler = ____exports.CommandHandler
CommandHandler.Type = "CommandHandler"
__PW__BaseClassExtends(CommandHandler)
function CommandHandler.prototype.____constructor(self, states, pregnancy, births, recovery)
    if states == nil then
        states = __TS__New(StateRepository)
    end
    if pregnancy == nil then
        pregnancy = __TS__New(PregnancyReconciler)
    end
    if births == nil then
        births = __TS__New(BirthOperationAllocator)
    end
    if recovery == nil then
        recovery = __TS__New(PregnancyRecoveryOptions)
    end
    self.states = states
    self.pregnancy = pregnancy
    self.births = births
    self.recovery = recovery
end
function CommandHandler.prototype.onClientCommand(self, module, command, player, args)
    if module ~= BF_NETWORK_MODULE then
        return
    end
    if not player then
        print(("[BF][MP][Server] ignored " .. command) .. " before player binding")
        return
    end
    repeat
        local ____switch6 = command
        local ____cond6 = ____switch6 == BFNetworkCommand.SYNC_STATE_REQUEST
        if ____cond6 then
            self:syncState(player, args)
            return
        end
        ____cond6 = ____cond6 or ____switch6 == BFNetworkCommand.SET_PREGNANCY_STATE_REQUEST
        if ____cond6 then
            self:setPregnancyState(player, args, BFNetworkCommand.SET_PREGNANCY_STATE_RESPONSE, true)
            return
        end
        ____cond6 = ____cond6 or ____switch6 == BFNetworkCommand.PUBLISH_PREGNANCY_STATE_REQUEST
        if ____cond6 then
            self:setPregnancyState(player, args, BFNetworkCommand.PUBLISH_PREGNANCY_STATE_RESPONSE, false)
            return
        end
        ____cond6 = ____cond6 or ____switch6 == BFNetworkCommand.ALLOCATE_BIRTH_REQUEST
        if ____cond6 then
            self:allocateBirth(player, args)
            return
        end
        ____cond6 = ____cond6 or ____switch6 == BFNetworkCommand.COMPLETE_BIRTH_REQUEST
        if ____cond6 then
            self:completeBirth(player, args)
            return
        end
        ____cond6 = ____cond6 or ____switch6 == BFNetworkCommand.CONVERT_CONDOM_REQUEST
        if ____cond6 then
            self:convertCondom(player, args)
            return
        end
        ____cond6 = ____cond6 or ____switch6 == BFNetworkCommand.PUBLISH_WOMB_STATE_REQUEST
        if ____cond6 then
            self:publishWombState(player, args)
            return
        end
        ____cond6 = ____cond6 or ____switch6 == BFNetworkCommand.PUBLISH_LACTATION_STATE_REQUEST
        if ____cond6 then
            self:publishLactationState(player, args)
            break
        end
    until true
end
function CommandHandler.prototype.convertCondom(self, player, args)
    if not isBFConvertCondomRequest(args) then
        return
    end
    if args.schemaVersion ~= BF_PROTOCOL_SCHEMA_VERSION or player:isDead() then
        return
    end
    local inventory = player:getInventory()
    local condom = inventory:getFirstType(ITEMS.CONDOM)
    if not condom then
        return
    end
    local used = instanceItem(ITEMS.CONDOM_USED)
    if not used then
        return
    end
    inventory:Remove(condom)
    sendRemoveItemFromContainer(inventory, condom)
    inventory:AddItem(used)
    sendAddItemToContainer(inventory, used)
end
function CommandHandler.prototype.publishLactationState(self, player, args)
    if not isBFPublishLactationStateRequest(args) then
        return
    end
    local loaded = self:loadForProtocol(player, args.schemaVersion)
    local status = self:loadStatus(args.schemaVersion, loaded)
    if status == BFSyncStatus.OK and (loaded and loaded.supported) and args.baseStateVersion == loaded.stateVersion then
        local desired = args.data.desired
        local current = loaded.state.domains.lactation
        if current.isActive ~= desired.isActive or current.milkAmount ~= desired.milkAmount or current.expiration ~= desired.expiration or current.multiplier ~= desired.multiplier then
            loaded.state.domains.lactation = __TS__ObjectAssign({}, desired)
            local ____loaded_state_2, ____stateVersion_3 = loaded.state, "stateVersion"
            ____loaded_state_2[____stateVersion_3] = ____loaded_state_2[____stateVersion_3] + 1
            loaded.stateVersion = loaded.state.stateVersion
            self.states:save(player, loaded.state)
        end
    end
    self:sendSnapshot(
        player,
        BFNetworkCommand.PUBLISH_LACTATION_STATE_RESPONSE,
        args,
        status,
        loaded
    )
end
function CommandHandler.prototype.publishWombState(self, player, args)
    if not isBFPublishWombStateRequest(args) then
        return
    end
    local loaded = self:loadForProtocol(player, args.schemaVersion)
    local status = self:loadStatus(args.schemaVersion, loaded)
    if status == BFSyncStatus.OK and (loaded and loaded.supported) then
        local desired = args.data.desired
        local womb = loaded.state.domains.womb
        local clearsContraceptive = womb.onContraceptive == true and desired.onContraceptive == false
        local acceptedBase = args.baseStateVersion == loaded.stateVersion
        local acceptedClear = not clearsContraceptive or desired.cycleDay ~= womb.cycleDay
        if acceptedBase and acceptedClear and (womb.cycleDay ~= desired.cycleDay or womb.amount ~= desired.amount or womb.total ~= desired.total or desired.onContraceptive ~= nil and womb.onContraceptive ~= desired.onContraceptive) then
            local ____loaded_state_domains_10 = loaded.state.domains
            local ____desired_cycleDay_7 = desired.cycleDay
            local ____desired_amount_8 = desired.amount
            local ____desired_total_9 = desired.total
            local ____desired_onContraceptive_6 = desired.onContraceptive
            if ____desired_onContraceptive_6 == nil then
                ____desired_onContraceptive_6 = womb.onContraceptive
            end
            ____loaded_state_domains_10.womb = {cycleDay = ____desired_cycleDay_7, amount = ____desired_amount_8, total = ____desired_total_9, onContraceptive = ____desired_onContraceptive_6}
            local ____loaded_state_11, ____stateVersion_12 = loaded.state, "stateVersion"
            ____loaded_state_11[____stateVersion_12] = ____loaded_state_11[____stateVersion_12] + 1
            loaded.stateVersion = loaded.state.stateVersion
            self.states:save(player, loaded.state)
        end
    end
    self:sendSnapshot(
        player,
        BFNetworkCommand.PUBLISH_WOMB_STATE_RESPONSE,
        args,
        status,
        loaded
    )
end
function CommandHandler.prototype.completeBirth(self, player, args)
    if not isBFCompleteBirthRequest(args) then
        return
    end
    local loaded = self:loadForProtocol(player, args.schemaVersion)
    local status = self:loadStatus(args.schemaVersion, loaded)
    if status == BFSyncStatus.OK and player:isDead() then
        status = BFSyncStatus.INVALID_REQUEST
    elseif status == BFSyncStatus.OK and (loaded and loaded.supported) then
        local birth = loaded.state.domains.birth
        if birth.completedBirthId == args.data.birthId then
        elseif birth.pendingBirthId ~= args.data.birthId then
            status = BFSyncStatus.INVALID_REQUEST
        else
            local mother = __TS__New(Player, player).identity
            if not mother then
                status = BFSyncStatus.INVALID_REQUEST
            else
                local baby = instanceItem(ITEMS.BABY)
                if not baby then
                    status = BFSyncStatus.INVALID_REQUEST
                else
                    local babyData = createBabyData({birthId = args.data.birthId, motherCharacterId = loaded.state.characterId, mother = mother, birthSequence = birth.birthSequence})
                    baby:getModData().BF = babyData
                    local inventory = player:getInventory()
                    inventory:AddItem(baby)
                    sendAddItemToContainer(inventory, baby)
                    loaded.state.domains.birth = {birthSequence = birth.birthSequence, completedBirthId = args.data.birthId}
                    loaded.state.domains.pregnancy = createDefaultPregnancyState()
                    local recovery = self.recovery:read()
                    loaded.state.domains.womb = __TS__ObjectAssign({}, loaded.state.domains.womb, {cycleDay = recovery.days == 0 and 1 or -recovery.days})
                    if recovery.usedFallback then
                        print("[BF][MP][Server] invalid PregnancyRecovery; using default=7")
                    end
                    local ____loaded_state_15, ____stateVersion_16 = loaded.state, "stateVersion"
                    ____loaded_state_15[____stateVersion_16] = ____loaded_state_15[____stateVersion_16] + 1
                    loaded.stateVersion = loaded.state.stateVersion
                    self.states:save(player, loaded.state)
                    self:applyPregnancyTrait(player, PregnancyStatus.NOT_PREGNANT)
                    print((((("[BF][MP][Server] completed birth player=" .. mother.username) .. " birthId=") .. babyData.birthId) .. " motherName=") .. mother.name)
                end
            end
        end
    end
    self:sendSnapshot(
        player,
        BFNetworkCommand.COMPLETE_BIRTH_RESPONSE,
        args,
        status,
        loaded
    )
end
function CommandHandler.prototype.allocateBirth(self, player, args)
    if not isBFAllocateBirthRequest(args) then
        print("[BF][MP][Server] rejected malformed birth allocation from " .. player:getUsername())
        return
    end
    local loaded = self:loadForProtocol(player, args.schemaVersion)
    local status = self:loadStatus(args.schemaVersion, loaded)
    if status == BFSyncStatus.OK and player:isDead() then
        status = BFSyncStatus.INVALID_REQUEST
    elseif status == BFSyncStatus.OK and (loaded and loaded.supported) then
        local pregnancy = loaded.state.domains.pregnancy
        if pregnancy.status ~= PregnancyStatus.PREGNANT or not pregnancy.isInLabor then
            status = BFSyncStatus.INVALID_REQUEST
        else
            local allocation = self.births:allocate(loaded.state.domains.birth, loaded.state.characterId)
            if allocation.changed then
                loaded.state.domains.birth = allocation.state
                local ____loaded_state_19, ____stateVersion_20 = loaded.state, "stateVersion"
                ____loaded_state_19[____stateVersion_20] = ____loaded_state_19[____stateVersion_20] + 1
                loaded.stateVersion = loaded.state.stateVersion
                self.states:save(player, loaded.state)
            end
            print((((("[BF][MP][Server] birth allocation player=" .. player:getUsername()) .. " birthId=") .. allocation.birthId) .. " changed=") .. tostring(allocation.changed))
        end
    end
    self:sendSnapshot(
        player,
        BFNetworkCommand.ALLOCATE_BIRTH_RESPONSE,
        args,
        status,
        loaded
    )
end
function CommandHandler.prototype.syncState(self, player, args)
    if not isBFSyncStateRequest(args) then
        print("[BF][MP][Server] rejected malformed request from " .. player:getUsername())
        return
    end
    local state = self:loadForProtocol(player, args.schemaVersion)
    local status = self:loadStatus(args.schemaVersion, state)
    if status == BFSyncStatus.OK and (state and state.supported) then
        self:applyPregnancyTrait(player, state.state.domains.pregnancy.status)
    end
    self:sendSnapshot(
        player,
        BFNetworkCommand.SYNC_STATE_RESPONSE,
        args,
        status,
        state
    )
end
function CommandHandler.prototype.setPregnancyState(self, player, args, responseCommand, debugOnly)
    if not isBFSetPregnancyStateRequest(args) then
        print("[BF][MP][Server] rejected malformed Pregnancy request from " .. player:getUsername())
        return
    end
    local loaded = self:loadForProtocol(player, args.schemaVersion)
    local status = self:loadStatus(args.schemaVersion, loaded)
    if status == BFSyncStatus.OK and debugOnly and not isDebugEnabled() then
        status = BFSyncStatus.FORBIDDEN
    end
    if status == BFSyncStatus.OK and (loaded and loaded.supported) then
        local reconciliation = self.pregnancy:reconcile(loaded.state.domains.pregnancy, args.data.desired)
        if not reconciliation.valid then
            status = BFSyncStatus.INVALID_REQUEST
        else
            if reconciliation.changed then
                loaded.state.domains.pregnancy = reconciliation.state
                local ____loaded_state_25, ____stateVersion_26 = loaded.state, "stateVersion"
                ____loaded_state_25[____stateVersion_26] = ____loaded_state_25[____stateVersion_26] + 1
                loaded.stateVersion = loaded.state.stateVersion
                self.states:save(player, loaded.state)
            end
            self:applyPregnancyTrait(player, reconciliation.state.status)
        end
    end
    self:sendSnapshot(
        player,
        responseCommand,
        args,
        status,
        loaded
    )
end
function CommandHandler.prototype.loadForProtocol(self, player, schemaVersion)
    return schemaVersion == BF_PROTOCOL_SCHEMA_VERSION and self.states:load(player) or nil
end
function CommandHandler.prototype.loadStatus(self, schemaVersion, state)
    if schemaVersion ~= BF_PROTOCOL_SCHEMA_VERSION then
        return BFSyncStatus.UNSUPPORTED_SCHEMA
    end
    return state and state.supported and BFSyncStatus.OK or BFSyncStatus.UNSUPPORTED_DATA_SCHEMA
end
function CommandHandler.prototype.applyPregnancyTrait(self, player, status)
    if status == PregnancyStatus.PREGNANT then
        CharacterTraitApi:addTrait(player, BFTraitsEnum.PREGNANCY)
        return
    end
    CharacterTraitApi:removeTrait(player, BFTraitsEnum.PREGNANCY)
end
function CommandHandler.prototype.snapshot(self, state)
    return {
        schemaVersion = state and state.schemaVersion or BF_STATE_SCHEMA_VERSION,
        stateVersion = state and state.stateVersion or 0,
        domains = {
            pregnancy = state and state.supported and state.state.domains.pregnancy or createDefaultPregnancyState(),
            birth = state and state.supported and state.state.domains.birth or createDefaultBirthState(),
            womb = state and state.supported and state.state.domains.womb or createDefaultWombState(),
            lactation = state and state.supported and state.state.domains.lactation or createDefaultLactationState()
        }
    }
end
function CommandHandler.prototype.sendSnapshot(self, player, command, request, status, state)
    local response = {
        schemaVersion = BF_PROTOCOL_SCHEMA_VERSION,
        requestId = request.requestId,
        revision = request.revision,
        status = status,
        data = {snapshot = self:snapshot(state)}
    }
    print((((("[BF][MP][Server] reply " .. response.requestId) .. " revision=") .. tostring(response.revision)) .. " status=") .. response.status)
    sendServerCommand(player, BF_NETWORK_MODULE, command, response)
end
return ____exports
