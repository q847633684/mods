-- File: ZomboLust/42/media/lua/client/Excitation/ZomboLust_ExcitationDangerGroan.lua
-- "Danger Groan" side of the Excitation system:
-- random thoughts above 60% Excitation that also slip out as an audible, vanilla-effort-groan-like moan attracting nearby zombies
-- Core simulation lives in ZomboLust_ExcitationSystem.lua
-- Single-player only: checkExcitationThoughts hardcodes getSpecificPlayer(0), see the Architecture Assumption note in ZomboLust_Main.lua
-- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_ExcitationDangerGroan.lua loaded")

---@diagnostic disable: inject-field
-- =============
-- Dependencies
-- =============
require "Excitation/ZomboLust_ExcitationSystem"

local ZomboLust_VoiceUtils = require("AnimationEvents/ZomboLust_VoiceUtils")

-- Module name for logging
--- @type string
local MODULE_NAME = "ExcitationSystem"

local getExcitation = ZomboLust_ExcitationSystem.getExcitation

-- ======================
-- Variables & Constants
-- ======================

-- Danger Groan (checkExcitationThoughts) - vanilla effort/pain groans that also attract zombies.
-- Radius anchored on the vanilla base Shout noise radius
-- (20 tiles, from the decompiled Callout(): WorldSoundManager.addSound(this, x, y, z, 20, 50))
-- and the Whistle item's real ShoutMultiplier (2.0, from items/normal.txt) to build the curve:
--   60% Excitation -> 0.5x base radius (10)
--   80% Excitation -> 1.0x base radius (20, matches a plain vanilla shout)
--   100% Excitation -> 2.0x base radius (40, matches a Whistle-boosted shout)
ZomboLust_ExcitationSystem.GroanBaseShoutRadius = 20
ZomboLust_ExcitationSystem.GroanBaseShoutVolume = 50
-- No male voice assets exist in this mod yet, so male players reuse the female moan lines,
-- pitched down (same convention as the BreathSounds pitch handling in ZomboLust_ExcitationBreathing.lua).
ZomboLust_ExcitationSystem.GroanMalePitch = 0.7

-- ==================
-- Utility Functions
-- ==================

--- Computes the zombie-attraction radius multiplier for the Danger Groan, from the current Excitation.
--- Two-segment linear curve anchored on 3 points: 60% -> 0.5x, 80% -> 1.0x (vanilla shout), 100% -> 2.0x (Whistle-equivalent).
--- @param excitation number
--- @return number
local function getGroanRadiusMultiplier(excitation)
    if excitation <= 80 then
        local t = (excitation - 60) / 20
        return 0.5 + t * 0.5
    end

    local t = (excitation - 80) / 20
    return 1.0 + t * 1.0
end

--- Selects the Danger Groan intensity tier from the current Excitation.
--- 60-70% -> Mild, 70-80% -> Medium, 80-100% -> Hot (matches ZomboLust_<Voice>_Moan_<Tier>_Long sound scripts).
--- @param excitation number
--- @return string
local function getGroanTier(excitation)
    if excitation < 70 then
        return "Mild"
    elseif excitation < 80 then
        return "Medium"
    end
    return "Hot"
end

-- ================
-- Logic Functions
-- ================

--- Plays a ZomboLust moan (Mild/Medium/Hot, matching the character's own voice) and attracts nearby
--- zombies to the source, simulating the fact that the moan is loud enough to be heard close by.
--- Radius scales with Excitation via getGroanRadiusMultiplier (same mechanism as the base game's Shout, just player-triggered).
--- @param player IsoPlayer
--- @param excitation number
local function playDangerGroan(player, excitation)
    local tier = getGroanTier(excitation)
    local soundName = ZomboLust_VoiceUtils.GetSoundName(player, "Moan" .. tier .. "Long")

    local emitter = player:getEmitter()
    if emitter then
        -- No male voice assets exist in this mod yet: male players reuse the female moan lines,
        -- pitched down (same convention as updateBreathing in ZomboLust_ExcitationBreathing.lua).
        local soundID = emitter:playSound(soundName)
        if not player:isFemale() and soundID and soundID ~= -1 then
            emitter:setPitch(soundID, ZomboLust_ExcitationSystem.GroanMalePitch)
        end
    end

    local multiplier = getGroanRadiusMultiplier(excitation)
    local radius = math.floor(ZomboLust_ExcitationSystem.GroanBaseShoutRadius * multiplier)
    addSound(player, math.floor(player:getX()), math.floor(player:getY()), math.floor(player:getZ()), radius, ZomboLust_ExcitationSystem.GroanBaseShoutVolume)

    ZomboLust.debugLog(MODULE_NAME, "Danger Groan: Played %s (Tier: %s) | Radius: %.1f (x%.2f) | Excitation: %.2f%%",
        soundName, tier, radius, multiplier, excitation)
end

--- Handles random thoughts when excitation is high (> 60%)
local function checkExcitationThoughts()
    local player = getSpecificPlayer(0)
    if not player or player:isDead() then return end

    -- Disable thoughts during sex animations to avoid overlap with "Dirty Talk"
    if ZomboDesire_AnimationHandler and ZomboDesire_AnimationHandler.currentAnimationAction then
        return
    end

    local excitation = getExcitation(player)
    if excitation <= 60 then return end

    -- Random frequency: 7% chance every minute if excitation > 60%
    if ZombRand(100) >= 7 then return end

    local isFemale = player:isFemale()
    local variants = {}

    -- Find all available generic thoughts
    local i = 1
    while true do
        local key = "IGUI_ZomboLust_ExcitationThought_Generic_" .. i
        local text = getText(key)
        if text == key then break end
        table.insert(variants, text)
        i = i + 1
    end

    -- Find all available gender-specific thoughts
    local genderStr = isFemale and "Female" or "Male"
    i = 1
    while true do
        local key = "IGUI_ZomboLust_ExcitationThought_" .. genderStr .. "_" .. i
        local text = getText(key)
        if text == key then break end
        table.insert(variants, text)
        i = i + 1
    end

    -- If we found some text, pick one randomly and display it
    if #variants > 0 then
        local selectedText = variants[ZombRand(#variants) + 1]
        if not selectedText then return end

        -- Color logic: Random interpolation between Cyan (0, 255, 255) and Purple/Mauve (153, 50, 204)
        local t = ZombRand(101) / 100
        local r = math.floor(0 + (153 - 0) * t)
        local g = math.floor(255 + (50 - 255) * t)
        local b = math.floor(255 + (204 - 255) * t)

        -- Display text
        player:Say(selectedText, r / 255, g / 255, b / 255, UIFont.Handwritten, 15.0, "default")

        -- Danger Groan - the excitation thought also slips out as an audible groan,
        -- attracting nearby zombies (radius grows with Excitation, see getGroanRadiusMultiplier)
        playDangerGroan(player, excitation)

        ZomboLust.debugLog(MODULE_NAME, "Excitation thought triggered: \"%s\" (Excitation: %.2f%%)", selectedText, excitation)
    end
end

Events.EveryOneMinute.Add(checkExcitationThoughts)

print("[ZomboLust] Excitation Danger Groan Initialized")
