local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__New = ____lualib.__TS__New
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local BodyPartType = ____pipewrench.BodyPartType
local getGameTime = ____pipewrench.getGameTime
local triggerEvent = ____pipewrench.triggerEvent
local ZombRand = ____pipewrench.ZombRand
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
local ____client = require('lua_modules/@asledgehammer/pipewrench/client')
local ISTimedActionQueue = ____client.ISTimedActionQueue
local _____40constants = require('constants')
local ITEMS = _____40constants.ITEMS
local BFEventsEnum = _____40constants.BFEventsEnum
local BFTraitsEnum = _____40constants.BFTraitsEnum
local ____BFBirth = require('BF/Actions/BFBirth')
local BFActionBirth = ____BFBirth.BFActionBirth
local ____BFPregnancyStartAnimation = require('BF/Actions/BFPregnancyStartAnimation')
local BFActionPregnancyStartAnimation = ____BFPregnancyStartAnimation.BFActionPregnancyStartAnimation
local ____Player = require('BF/components/Player')
local Player = ____Player.Player
local ____Moodles = require('BF/components/Moodles')
local Moodle = ____Moodles.Moodle
local ____PregnancyState = require('BF/components/PregnancyState')
local PregnancyState = ____PregnancyState.PregnancyState
local ____SandboxOptions = require('BF/SandboxOptions')
local PregnancyOptions = ____SandboxOptions.PregnancyOptions
local ____PregnancyState = require('domain/pregnancy/PregnancyState')
local PregnancyStatus = ____PregnancyState.PregnancyStatus
local createDefaultPregnancyState = ____PregnancyState.createDefaultPregnancyState
--- Coordinates local Pregnancy simulation and birth presentation for the currently bound player.
____exports.Pregnancy = __TS__Class()
local Pregnancy = ____exports.Pregnancy
Pregnancy.Type = "Pregnancy"
__PW__ClassExtendsPatch(Pregnancy, Player)
__TS__ClassExtends(Pregnancy, Player)
function Pregnancy.prototype.____constructor(self, commands, snapshots, births)
    Player.prototype.____constructor(self)
    self.commands = commands
    self.snapshots = snapshots
    self.births = births
    self.characterBinding = {phase = "unbound"}
    self.birthPresentation = {phase = "idle"}
    self.Debug = {
        start = function()
            if not self:isActiveBinding() then
                return
            end
            if self.commands then
                self.commands:setState(__TS__ObjectAssign(
                    {},
                    createDefaultPregnancyState(),
                    {status = PregnancyStatus.PREGNANT}
                ))
                return
            end
            self:start()
        end,
        stop = function()
            if not self:isActiveBinding() then
                return
            end
            if self.commands then
                self.commands:setState(createDefaultPregnancyState())
                return
            end
            self:stop()
        end,
        advance = function(minutes)
            if not self:isActiveBinding() then
                return
            end
            local pregnancy = self.authoritativePregnancy
            if pregnancy.status ~= PregnancyStatus.PREGNANT then
                return
            end
            local current = pregnancy.current
            local duration = self.pregnancyDuration
            local updated = math.min(duration, current + minutes)
            local next = {status = PregnancyStatus.PREGNANT, current = updated, progress = updated / duration, isInLabor = updated == duration}
            if self.commands then
                self.commands:setState(next)
                return
            end
            self:applyLocalPregnancyState(next)
        end,
        advanceToLabor = function()
            if not self:isActiveBinding() then
                return
            end
            local pregnancy = self.authoritativePregnancy
            if pregnancy.status ~= PregnancyStatus.PREGNANT then
                return
            end
            local current = pregnancy.current
            local duration = self.pregnancyDuration
            self.Debug.advance(duration - current - 1)
        end
    }
    local ____opt_0 = self.snapshots
    if ____opt_0 ~= nil then
        ____opt_0:subscribe(function(snapshot) return self:applyAuthoritativeSnapshot(snapshot) end)
    end
    self:installListeners()
end
function Pregnancy.prototype.isActiveBinding(self)
    return self.characterBinding.phase == "active" and self.characterBinding.player == self.player
end
function Pregnancy.prototype.applyAuthoritativeSnapshot(self, snapshot)
    if not self:isActiveBinding() then
        return
    end
    local ____opt_2 = self.commands
    local pregnancy = ____opt_2 and ____opt_2.latestDesiredState or snapshot.domains.pregnancy
    local previousStatus = self.lastAppliedStatus
    self.lastAppliedStatus = pregnancy.status
    if pregnancy.status == PregnancyStatus.NOT_PREGNANT then
        local ____opt_4 = self.player
        if ____opt_4 ~= nil then
            ____opt_4:setBlockMovement(false)
        end
        self.birthPresentation = {phase = "idle"}
        self:removeTrait(BFTraitsEnum.PREGNANCY)
        self:resetVariables()
        return
    end
    self:addTrait(BFTraitsEnum.PREGNANCY)
    local presentation = {current = pregnancy.current, progress = pregnancy.progress, isInLabor = pregnancy.isInLabor}
    PregnancyState:set(self.player, presentation)
    local ____opt_6 = self.moodle
    if ____opt_6 ~= nil then
        ____opt_6:moodle(pregnancy.progress)
    end
    triggerEvent(BFEventsEnum.PREGNANCY_UPDATE, presentation)
    if previousStatus == PregnancyStatus.NOT_PREGNANT then
        self:playStartAnimation()
    end
    if pregnancy.isInLabor and not snapshot.domains.birth.pendingBirthId then
        local ____opt_8 = self.births
        if ____opt_8 ~= nil then
            ____opt_8:allocate()
        end
    end
    local pendingBirthId = snapshot.domains.birth.pendingBirthId
    if pendingBirthId and self.birthPresentation.phase == "submitted" and self.birthPresentation.birthId == pendingBirthId then
        local ____opt_10 = self.births
        if ____opt_10 ~= nil then
            ____opt_10:complete(pendingBirthId)
        end
    end
    self:queuePendingBirthPresentation(snapshot, false)
end
function Pregnancy.prototype.queuePendingBirthPresentation(self, snapshot, canResumeInterrupted)
    if not self:isActiveBinding() then
        return
    end
    local pendingBirthId = snapshot.domains.birth.pendingBirthId
    if not snapshot.domains.pregnancy.isInLabor or not pendingBirthId then
        return
    end
    local presentation = self.birthPresentation
    if presentation.phase == "active" then
        return
    end
    if presentation.phase == "submitted" and presentation.birthId == pendingBirthId then
        return
    end
    if presentation.phase == "interrupted" and presentation.birthId == pendingBirthId and not canResumeInterrupted then
        return
    end
    self.birthPresentation = {phase = "active", birthId = pendingBirthId}
    local ____opt_12 = self.player
    if ____opt_12 ~= nil then
        ____opt_12:setBlockMovement(true)
    end
    ISTimedActionQueue.add(__TS__New(BFActionBirth, self, pendingBirthId))
end
function Pregnancy.prototype.queueLegacyBirthPresentation(self, canResumeInterrupted, isInLabor)
    if not self:isActiveBinding() then
        return
    end
    if self.births then
        return
    end
    if not isInLabor then
        return
    end
    local presentation = self.birthPresentation
    if presentation.phase == "active" or presentation.phase == "submitted" then
        return
    end
    if presentation.phase == "interrupted" and not canResumeInterrupted then
        return
    end
    self.birthPresentation = {phase = "active"}
    local ____opt_14 = self.player
    if ____opt_14 ~= nil then
        ____opt_14:setBlockMovement(true)
    end
    ISTimedActionQueue.add(__TS__New(BFActionBirth, self))
end
function Pregnancy.prototype.onCreatePlayer(self, player)
    if self.characterBinding.phase == "dead" then
        local ____opt_16 = self.snapshots
        if ____opt_16 ~= nil then
            ____opt_16:resetSession()
        end
    end
    self.characterBinding = {phase = "active", player = player}
    self.birthPresentation = {phase = "idle"}
    self.lastAppliedStatus = nil
    Player.prototype.onCreatePlayer(self, player)
    self.lastMinuteStamp = getGameTime():getMinutesStamp()
    PregnancyState:initialize(player)
    self.moodle = __TS__New(Moodle, {
        player = player,
        name = "Pregnancy",
        type = "Good",
        texture = "media/ui/Moodles/Pregnancy.png",
        tresholds = {0.3, 0.6, 0.8, 0.9}
    })
    local ____opt_18 = self.snapshots
    local snapshot = ____opt_18 and ____opt_18.snapshot
    if snapshot then
        self:applyAuthoritativeSnapshot(snapshot)
    end
end
function Pregnancy.prototype.installListeners(self)
    Events.everyOneMinute:addListener(function() return self:onEveryMinute() end)
    Events.everyHours:addListener(function() return self:onEveryHour() end)
    Events.everyDays:addListener(function() return self:onEveryDay() end)
    Events.onPlayerDeath:addListener(function(deadPlayer) return self:onPlayerDeath(deadPlayer) end)
    __TS__New(Events.EventEmitter, BFEventsEnum.PREGNANCY_START):addListener(function() return self:start() end)
    __TS__New(Events.EventEmitter, BFEventsEnum.PREGNANCY_STOP):addListener(function() return self:stop() end)
    __TS__New(Events.EventEmitter, BFEventsEnum.PREGNANCY_LABOR):addListener(function(delta) return self:onLabor(delta) end)
end
function Pregnancy.prototype.onPlayerDeath(self, deadPlayer)
    if not self:isActiveBinding() or deadPlayer ~= self.characterBinding.player then
        return
    end
    deadPlayer:setBlockMovement(false)
    self.characterBinding = {phase = "dead", player = deadPlayer}
    self.birthPresentation = {phase = "idle"}
    local ____opt_20 = self.commands
    if ____opt_20 ~= nil then
        ____opt_20:resetSession()
    end
    local ____opt_22 = self.births
    if ____opt_22 ~= nil then
        ____opt_22:resetSession()
    end
    local ____opt_24 = self.snapshots
    if ____opt_24 ~= nil then
        ____opt_24:resetSession()
    end
end
function Pregnancy.prototype.resetVariables(self)
    PregnancyState:set(self.player, {progress = 0, current = 0, isInLabor = false})
    local ____opt_26 = self.moodle
    if ____opt_26 ~= nil then
        ____opt_26:moodle(0)
    end
end
function Pregnancy.prototype.applyLocalPregnancyState(self, state)
    local ____opt_28 = self.pregnancy
    local ____temp_30 = ____opt_28 and ____opt_28.isInLabor
    if ____temp_30 == nil then
        ____temp_30 = false
    end
    local previousInLabor = ____temp_30
    PregnancyState:set(self.player, {current = state.current, progress = state.progress, isInLabor = state.isInLabor})
    local ____opt_31 = self.moodle
    if ____opt_31 ~= nil then
        ____opt_31:moodle(state.progress, true)
    end
    triggerEvent(BFEventsEnum.PREGNANCY_UPDATE, self.pregnancy)
    if state.isInLabor and not previousInLabor then
        self:queueLegacyBirthPresentation(false, true)
    end
end
function Pregnancy.prototype.start(self)
    if not self:isActiveBinding() then
        return
    end
    if self.commands then
        local desired = self.commands.latestDesiredState or self.authoritativePregnancy
        if desired.status == PregnancyStatus.PREGNANT then
            return
        end
        self.commands:publishState(__TS__ObjectAssign(
            {},
            createDefaultPregnancyState(),
            {status = PregnancyStatus.PREGNANT}
        ))
        return
    end
    self:addTrait(BFTraitsEnum.PREGNANCY)
    self:resetVariables()
    self:playStartAnimation()
end
function Pregnancy.prototype.playStartAnimation(self)
    if self.player then
        ISTimedActionQueue.add(__TS__New(BFActionPregnancyStartAnimation, self.player))
    end
end
function Pregnancy.prototype.stop(self)
    if not self:isActiveBinding() then
        return
    end
    self:removeTrait(BFTraitsEnum.PREGNANCY)
    self:resetVariables()
end
function Pregnancy.prototype.onLabor(self, delta)
    if not self:isActiveBinding() then
        return
    end
    local ____ = delta
    self:applyBodyEffect(BodyPartType.Groin, {pain = 1, maxPain = 30})
end
function Pregnancy.prototype.onEveryMinute(self)
    if not self:isActiveBinding() then
        return
    end
    local minuteStamp = getGameTime():getMinutesStamp()
    local elapsed = math.max(0, minuteStamp - (self.lastMinuteStamp or minuteStamp - 1))
    self.lastMinuteStamp = minuteStamp
    local pregnancy = self.pregnancy
    if not pregnancy then
        return
    end
    local ____self_commands_35 = self.commands
    if ____self_commands_35 then
        local ____opt_33 = self.snapshots
        ____self_commands_35 = not (____opt_33 and ____opt_33.snapshot)
    end
    if ____self_commands_35 then
        return
    end
    local ____opt_36 = self.snapshots
    local snapshot = ____opt_36 and ____opt_36.snapshot
    if snapshot then
        self:queuePendingBirthPresentation(snapshot, true)
    elseif self.birthPresentation.phase == "interrupted" then
        local ____self_queueLegacyBirthPresentation_39 = self.queueLegacyBirthPresentation
        local ____pregnancy_isInLabor_38 = pregnancy.isInLabor
        if ____pregnancy_isInLabor_38 == nil then
            ____pregnancy_isInLabor_38 = false
        end
        ____self_queueLegacyBirthPresentation_39(self, true, ____pregnancy_isInLabor_38)
    end
    if elapsed == 0 then
        return
    end
    local duration = self.pregnancyDuration
    local current = pregnancy.current
    local ____pregnancy_isInLabor_40 = pregnancy.isInLabor
    if ____pregnancy_isInLabor_40 == nil then
        ____pregnancy_isInLabor_40 = false
    end
    local previousInLabor = ____pregnancy_isInLabor_40
    if current >= duration and previousInLabor then
        return
    end
    local updated = math.min(duration, current + elapsed)
    local isInLabor = updated == duration
    PregnancyState:set(self.player, {current = updated, progress = updated / duration, isInLabor = isInLabor})
    local ____opt_41 = self.commands
    if ____opt_41 ~= nil then
        ____opt_41:publishState({status = PregnancyStatus.PREGNANT, current = updated, progress = updated / duration, isInLabor = isInLabor})
    end
    if isInLabor and not previousInLabor and not self.births then
        self:queueLegacyBirthPresentation(false, true)
    end
    local ____opt_43 = self.moodle
    if ____opt_43 ~= nil then
        ____opt_43:moodle(self.pregnancy.progress, true)
    end
    triggerEvent(BFEventsEnum.PREGNANCY_UPDATE, self.pregnancy)
end
function Pregnancy.prototype.onEveryHour(self)
    if not self:isActiveBinding() then
        return
    end
    if not self.pregnancy then
        return
    end
    local ____self_pregnancy_45 = self.pregnancy
    local progress = ____self_pregnancy_45.progress
    local ____opt_46 = self.moodle
    if ____opt_46 ~= nil then
        ____opt_46:moodle(progress)
    end
    if progress < 0.25 then
        return
    end
    local water = 0.5 * progress / 1440
    self:applyStatEffect({stat = "THIRST", value = water, maxValue = 1})
    local calories = 600 * progress / 1440
    self:applyNutritionEffect({calories = -calories})
end
function Pregnancy.prototype.onEveryDay(self)
    if not self:isActiveBinding() then
        return
    end
    if not self.pregnancy then
        return
    end
    local ____self_pregnancy_48 = self.pregnancy
    local progress = ____self_pregnancy_48.progress
    if progress < 0.05 or progress > 0.33 then
        return
    end
    self:applyStatEffect({
        stat = "FOOD_SICKNESS",
        value = 50 + ZombRand(0, 50)
    })
end
function Pregnancy.prototype.birth(self, birthId)
    if not self:isActiveBinding() or not self.player then
        return
    end
    local ____opt_51 = self.snapshots
    local ____opt_49 = ____opt_51 and ____opt_51.snapshot
    local pendingBirthId = ____opt_49 and ____opt_49.domains.birth.pendingBirthId
    if self.births then
        if not birthId or birthId ~= pendingBirthId then
            return
        end
        local presentation = self.birthPresentation
        if presentation.phase ~= "active" or presentation.birthId ~= birthId then
            return
        end
        self.birthPresentation = {phase = "submitted", birthId = birthId}
        self.player:setBlockMovement(false)
        self.births:complete(birthId)
        return
    end
    self.birthPresentation = {phase = "idle"}
    self.player:getInventory():AddItem(ITEMS.BABY)
    self.player:setBlockMovement(false)
    self:applyStatEffect({stat = "FATIGUE", value = 0.75, maxValue = 0.75})
    self:stop()
end
function Pregnancy.prototype.onBirthPresentationStopped(self, birthId)
    if not self:isActiveBinding() then
        return
    end
    local presentation = self.birthPresentation
    if presentation.phase ~= "active" or presentation.birthId ~= birthId then
        return
    end
    self.birthPresentation = {phase = "interrupted", birthId = birthId}
    local ____opt_53 = self.player
    if ____opt_53 ~= nil then
        ____opt_53:setBlockMovement(false)
    end
end
__TS__SetDescriptor(
    Pregnancy.prototype,
    "pregnancyDuration",
    {get = function(self)
        return PregnancyOptions.duration
    end},
    true
)
__TS__SetDescriptor(
    Pregnancy.prototype,
    "authoritativePregnancy",
    {get = function(self)
        local ____opt_57 = self.snapshots
        local ____opt_55 = ____opt_57 and ____opt_57.snapshot
        local authoritative = ____opt_55 and ____opt_55.domains.pregnancy
        if authoritative then
            return authoritative
        end
        local ____local = PregnancyState:get(self.player)
        if not ____local then
            return createDefaultPregnancyState()
        end
        local ____PregnancyStatus_PREGNANT_60 = PregnancyStatus.PREGNANT
        local ____local_current_61 = ____local.current
        local ____local_progress_62 = ____local.progress
        local ____local_isInLabor_59 = ____local.isInLabor
        if ____local_isInLabor_59 == nil then
            ____local_isInLabor_59 = false
        end
        return {status = ____PregnancyStatus_PREGNANT_60, current = ____local_current_61, progress = ____local_progress_62, isInLabor = ____local_isInLabor_59}
    end},
    true
)
__TS__SetDescriptor(
    Pregnancy.prototype,
    "pregnancy",
    {get = function(self)
        if not self:isActiveBinding() then
            return nil
        end
        local ____opt_65 = self.snapshots
        local ____opt_63 = ____opt_65 and ____opt_65.snapshot
        local authoritative = ____opt_63 and ____opt_63.domains.pregnancy
        if authoritative then
            if authoritative.status == PregnancyStatus.NOT_PREGNANT then
                return nil
            end
            return PregnancyState:getStored(self.player) or ({current = authoritative.current, progress = authoritative.progress, isInLabor = authoritative.isInLabor})
        end
        return PregnancyState:get(self.player)
    end},
    true
)
return ____exports
