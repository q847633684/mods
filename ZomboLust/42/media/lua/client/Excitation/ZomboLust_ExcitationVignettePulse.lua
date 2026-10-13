-- File: ZomboLust/42/media/lua/client/Excitation/ZomboLust_ExcitationVignettePulse.lua
-- Vignette (heartbeat pulse overlay) side of the Excitation system:
-- triggered by the breathing sound in ZomboLust_ExcitationBreathing.lua, rendered by ZomboLust_Vignette.lua
-- Core simulation lives in ZomboLust_ExcitationSystem.lua
-- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_ExcitationVignettePulse.lua loaded")

---@diagnostic disable: inject-field
-- =============
-- Dependencies
-- =============
require "Excitation/ZomboLust_Vignette"
require "Excitation/ZomboLust_ExcitationSystem"

local getExcitation = ZomboLust_ExcitationSystem.getExcitation

-- ======================
-- Variables & Constants
-- ======================

ZomboLust_ExcitationSystem.isPulsing = false
ZomboLust_ExcitationSystem.pulseStage = 0 -- 0: None, 1: Zooming In, 2: Zooming Out
ZomboLust_ExcitationSystem.pulseTimer = 0

-- ================
-- Logic Functions
-- ================

--- Handles the visual heartbeat pulse effect (Vignette Overlay)
--- @param player IsoPlayer
function ZomboLust_ExcitationSystem.updateVignettePulse(player)
    -- Disable during sex animations to avoid unwanted pulse effects
    if ZomboDesire_AnimationHandler and ZomboDesire_AnimationHandler.currentAnimationAction then
        -- Reset pulse state if an animation starts during a pulse
        if ZomboLust_ExcitationSystem.isPulsing then
            ZomboLust_ExcitationSystem.isPulsing = false
            ZomboLust_ExcitationSystem.pulseStage = 0
        end
        return
    end

    if not ZomboLust_ExcitationSystem.isPulsing then return end
    if not player or player:isDead() then
        ZomboLust_ExcitationSystem.isPulsing = false
        ZomboLust_ExcitationSystem.pulseStage = 0
        return
    end

    -- Trigger the smooth vignette pulse
    if ZomboLust_ExcitationSystem.pulseStage == 1 then
        local excitation = getExcitation(player)
        -- Max alpha based on excitation (60% -> 0.2, 100% -> 0.6)
        local peakAlpha = 0.2 + ((excitation - 60) / 40) * 0.4

        ---@type ZomboLust_Vignette
        local vignette = ZomboLust_Vignette
        if vignette and vignette.instance then
            vignette.instance:triggerPulse(peakAlpha)
        end

        ZomboLust_ExcitationSystem.isPulsing = false
        ZomboLust_ExcitationSystem.pulseStage = 0
    end
end

print("[ZomboLust] Excitation Vignette Pulse Initialized")
