-- File: ZomboLust/42/media/lua/client/Excitation/ZomboLust_ExcitationBreathing.lua
-- Breathing-sound side of the Excitation system:
-- plays heavy breathing lines above 60% Excitation and kicks off the vignette heartbeat pulse (ZomboLust_ExcitationVignettePulse.lua)
-- Core simulation lives in ZomboLust_ExcitationSystem.lua
-- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_ExcitationBreathing.lua loaded")

---@diagnostic disable: inject-field
-- =============
-- Dependencies
-- =============
require "Excitation/ZomboLust_ExcitationSystem"

-- Module name for logging
--- @type string
local MODULE_NAME = "ExcitationSystem"

local getExcitation = ZomboLust_ExcitationSystem.getExcitation

-- ======================
-- Variables & Constants
-- ======================

ZomboLust_ExcitationSystem.lastBreathTime = 0
ZomboLust_ExcitationSystem.lastBreathSound = ""
---@type string[]
ZomboLust_ExcitationSystem.BreathSounds = {
    "CaseyjoBreathFast",
    "CaseyjoBreathHeavy",
    "CaseyjoBreathInter"
}

-- ================
-- Logic Functions
-- ================

--- Logic for breathing sound based on excitation level
--- @param player IsoPlayer
function ZomboLust_ExcitationSystem.updateBreathing(player)
    if not player or player:isDead() then return end

    -- Disable during sex animations to avoid unwanted sounds
    if ZomboDesire_AnimationHandler and ZomboDesire_AnimationHandler.currentAnimationAction then
        return
    end

    local excitation = getExcitation(player)
    if excitation < 60 then
        ZomboLust_ExcitationSystem.lastBreathTime = 0
        return
    end

    -- Calculate interval between breaths (linear interpolation)
    -- 60% -> 9000ms
    -- 100% -> 3600ms
    local t = (excitation - 60) / 40
    local interval = 9000 - (t * 5400)

    local currentTime = getTimestampMs()
    if currentTime - ZomboLust_ExcitationSystem.lastBreathTime >= interval then
        -- Select a random sound that is different from the last one
        local sounds = ZomboLust_ExcitationSystem.BreathSounds
        local soundIndex = ZombRand(#sounds) + 1
        local selectedSound = sounds[soundIndex]

        if selectedSound == ZomboLust_ExcitationSystem.lastBreathSound then
            soundIndex = (soundIndex % #sounds) + 1
            selectedSound = sounds[soundIndex]
        end

        if not selectedSound then return end

        local emitter = player:getEmitter()
        if emitter then
            local soundID = emitter:playSound(selectedSound)

            -- Adjust volume (reduced by half) and pitch based on gender (Lower for males)
            local pitch = player:isFemale() and 1.0 or 0.7
            if soundID ~= -1 then
                emitter:setVolume(soundID, 0.5)
                emitter:setPitch(soundID, pitch)
            end

            ZomboLust_ExcitationSystem.lastBreathSound = selectedSound
            ZomboLust_ExcitationSystem.lastBreathTime = currentTime

            -- Trigger visual zoom pulse
            if not ZomboLust_ExcitationSystem.isPulsing then
                ZomboLust_ExcitationSystem.isPulsing = true
                ZomboLust_ExcitationSystem.pulseStage = 1
            end

            ZomboLust.debugLog(MODULE_NAME, "Breathing: Played %s | Pitch: %.1f | Interval: %dms",
                selectedSound, pitch, interval)
        end
    end
end

print("[ZomboLust] Excitation Breathing Initialized")
