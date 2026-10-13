-- File: ZomboLust/42/media/lua/client/Excitation/ZomboLust_ExcitationSystem.lua
-- This module handles the Excitation simulation for ZomboLust (pheromones, traits, decay).
-- Several files populating this same ZomboLust_ExcitationSystem table:
--   - Vignette pulse:      ZomboLust_ExcitationVignettePulse.lua
--   - Breathing sounds:    ZomboLust_ExcitationBreathing.lua
--   - Danger Groan (excitation thoughts + zombie-attracting groan): ZomboLust_ExcitationDangerGroan.lua
--   - Swinger partner counter (increment/decay/reset):  ZomboLust_ExcitationSwinger.lua
-- The zombie shove/push-chain ("domino") bonus is a separate system: see ZomboLust_DominoPush in ZomboLust_ZombieDominoPush.lua
-- UI widgets live in ZomboLust_ExcitationUI.lua
-- stimulant/inhibitor item hooks live in ZomboLust_ExcitationStimulantHooks.lua
-- All of the files above require this one for ZomboLust_ExcitationSystem.
-- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_ExcitationSystem.lua loaded")

---@diagnostic disable: inject-field
-- =============
-- Dependencies
-- =============
require "Encounter/ZomboLust_OrgasmSystem"
require "Encounter/ZomboLust_SexualIntentSystem"

-- ======================
-- Variables & Constants
-- ======================

ZomboLust_ExcitationSystem = ZomboLust_ExcitationSystem or {}
ZomboLust_ExcitationSystem.PheromoneRadius = 2.0
ZomboLust_ExcitationSystem.IncreasePerZombie = 0.005
ZomboLust_ExcitationSystem.IndoorMultiplier = 2.0
ZomboLust_ExcitationSystem.DecayPerTenMinutes = 3.0
ZomboLust_ExcitationSystem.ExcitationToIntoxRatio = 0.75 -- 100% excitation = 75% drunk
ZomboLust_ExcitationSystem.StimulantMultiplier = 1.5 -- 50% increase when on stimulants (Coffee, Vitamins)
ZomboLust_ExcitationSystem.StimulantDuration = 120 -- Minutes the effect lasts (2 hours)
ZomboLust_ExcitationSystem.MaskMultiplier = 0.25 -- 75% reduction when wearing a mask (matching base game logic based on 25.0 defense)
-- Horde Fear (overrides pheromone arousal when too many zombies close in)
ZomboLust_ExcitationSystem.HordeRadius = 6.0 -- Wider than PheromoneRadius: a horde is spotted before it's in touching range
ZomboLust_ExcitationSystem.HordeZombieThreshold = 6 -- Strictly more than 5 zombies within HordeRadius counts as a horde
ZomboLust_ExcitationSystem.HordeFearDecayPerZombie = 0.01 -- Per-zombie decay rate while a horde is present (same tick-rate convention as IncreasePerZombie)
ZomboLust_ExcitationSystem.HordeFearDecayCap = 15 -- Zombie count above this no longer increases the fear decay rate (diminishing returns)
ZomboLust_ExcitationSystem.HordePanicDecayMultiplier = 1.5 -- Extra decay multiplier when Panic moodle is also maxed WHILE a horde is present (never triggers from Panic alone, avoids false positives from Agoraphobia/Claustrophobic)
ZomboLust_ExcitationSystem.PanicMoodleMaxLevel = 4 -- Vanilla moodle levels run 0-4
-- Trait
ZomboLust_ExcitationSystem.PromiscuousMultiplier = 1.25 -- 25% increase for Promiscuous trait
ZomboLust_ExcitationSystem.SwingerPartnerLimit = 2 -- Max partners per 24h before the Swinger penalty applies
ZomboLust_ExcitationSystem.SwingerMultiplier = 0.75 -- 25% decrease for Swinger trait beyond the partner limit
ZomboLust_ExcitationSystem.LewdPassiveGainPerTick = 0.004 -- Flat Excitation gain per frame-equivalent for Lewd trait (scaled by UpdateTickRate and game speed, same convention as IncreasePerZombie). Total gained per 10-min decay cycle is speed-independent: ~1850 * this value (empirically measured) -> ~7.4 per cycle, net +4.4 after the -3.00 decay
ZomboLust_ExcitationSystem.WimpMultiplier = 0.5 -- 50% decrease for Wimp trait
ZomboLust_ExcitationSystem.WimpAnxietyBreakpoint = 25 -- Excitation % where the steep early segment ends (Stress = Breakpoint/100 there)
ZomboLust_ExcitationSystem.WimpAnxietyMaxStress = 0.85 -- Stress value reached at 100% Excitation
ZomboLust_ExcitationSystem.NymphomaniacMultiplier = 1.35 -- 35% increase for Nymphomaniac trait (pheromone effect only, per trait description)
ZomboLust_ExcitationSystem.NymphomaniacMinExcitation = 25 -- Incompressible Excitation floor for Nymphomaniac trait
ZomboLust_ExcitationSystem.NymphomaniacDiscomfortFloor = 20.0 -- Constant Discomfort floor (Level 1 moodle, same value as Herpes flare-up) for Nymphomaniac trait
ZomboLust_ExcitationSystem.NymphomaniacGroinPainValue = 10 -- Constant Level 1 groin pain (same value as Chlamydia/Gonorrhea flare-up) for Nymphomaniac trait
ZomboLust_ExcitationSystem.NymphomaniacEnduranceRestore = 0.3 -- One-off Endurance increase (0.0-1.0 scale) applied when a defeat sex animation ends (instead of Traumatized) for Nymphomaniac trait. Replaces the former Boredom bump, which vanilla's Excitation->Intoxication coupling permanently neutralizes for this trait (pzwiki: "At 20%% drunkenness, boredom decreases at 200%%", and Nymphomaniac's incompressible Excitation floor keeps Intoxication permanently above that).
ZomboLust_ExcitationSystem.SmokesAfterMultiplier = 0.65 -- 35% decrease for SmokesAfter trait
ZomboLust_ExcitationSystem.NoColdShowersMultiplier = 0.85 -- 15% decrease for NoColdShowers trait (outside + raining)
ZomboLust_ExcitationSystem.MisandristStressBump = 0.35 -- One-off Stress increase (0.0-1.0 scale) applied when a sex animation ends with a male partner, for Misandrist trait. Raised from 0.25 - that value landed exactly on the confirmed Moodles_Stress_lvl1 threshold (0.25) with zero margin, so it could silently miss the moodle (float rounding / passive per-tick Stress decay / a strict "> " engine comparison). (ZLApplyTrauma.lua)
ZomboLust_ExcitationSystem.MisandristUnhappinessBump = 25 -- Starting Morale mini-game penalty (0-100 scale) applied under the same condition, for Misandrist trait, so it feeds both the final Unhappiness write and ApplyFinalPenalties' severity tiers. (ZomboLust_MoraleBar:initialise() in ZomboLust_MoraleSystem.lua)
ZomboLust_ExcitationSystem.MisogynistStressBump = 0.35 -- One-off Stress increase (0.0-1.0 scale) applied when a sex animation ends with a female partner, for Misogynist trait. Raised from 0.25 for the same margin-of-safety reason as MisandristStressBump above. (ZLApplyTrauma.lua)
ZomboLust_ExcitationSystem.MisogynistUnhappinessBump = 25 -- Starting Morale mini-game penalty (0-100 scale) applied under the same condition, for Misogynist trait, so it feeds both the final Unhappiness write and ApplyFinalPenalties' severity tiers. (ZomboLust_MoraleBar:initialise() in ZomboLust_MoraleSystem.lua)
ZomboLust_ExcitationSystem.DrinkerHeavyGainMultiplier = 0.7
ZomboLust_ExcitationSystem.DrinkerHeavyDecayMultiplier = 2.0
ZomboLust_ExcitationSystem.DrinkerLightGainMultiplier = 1.2
ZomboLust_ExcitationSystem.DrinkerNoobDecayMultiplier = 0.5
-- Miscellaneous
ZomboLust_ExcitationSystem.UpdateTickRate = 30 -- Scan every 30 frames (~1/2 second at 60fps)
local updateCounter = 0

-- Module name for logging
--- @type string
local MODULE_NAME = "ExcitationSystem"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

-- ==================
-- Utility Functions
-- ==================

--- Gets the current excitation level of the player
--- @param player IsoPlayer
--- @return number
function ZomboLust_ExcitationSystem.getExcitation(player)
    if not player then return 0 end
    local modData = player:getModData()
    modData.ZL_Excitation = modData.ZL_Excitation or 0
    return modData.ZL_Excitation
end

local getExcitation = ZomboLust_ExcitationSystem.getExcitation

--- Sets the excitation level of the player (clamped 0-100, with an incompressible floor for the Nymphomaniac trait)
--- @param player IsoPlayer
--- @param value number
function ZomboLust_ExcitationSystem.setExcitation(player, value)
    if not player then return end
    local modData = player:getModData()

    local floor = 0
    local traitNympho = ZomboLustRegistries.Traits.Nymphomaniac
    if traitNympho and player:hasTrait(traitNympho) then
        floor = ZomboLust_ExcitationSystem.NymphomaniacMinExcitation
    end

    modData.ZL_Excitation = math.max(floor, math.min(100, value))
end

local setExcitation = ZomboLust_ExcitationSystem.setExcitation

--- Checks if the player is wearing a protective mask/face cover
--- @param player IsoPlayer
--- @return boolean
local function hasExcitationDefense(player)
    if not player then return false end

    -- Check for items with CorpseSicknessDefense property
    local wornItems = player:getWornItems()
    for i = 0, wornItems:size() - 1 do
        local item = wornItems:get(i):getItem()
        if not item then return false end

        -- getCorpseSicknessDefense() only exists on Clothing; worn slots can also
        -- hold non-Clothing items (backpacks, weapons on back, etc. in B42)
        if instanceof(item, "Clothing") then
            ---@type number
            local defense = 0
            defense = (item --[[@as Clothing]]):getCorpseSicknessDefense()

            if defense > 0 then
                local fullType = item:getFullType()
                local lowerType = string.lower(fullType)

                -- Identify if it's a "High-End" protection mask (Gas Mask or Respirator)
                local isHighEndMask = string.find(lowerType, "gasmask") or string.find(lowerType, "respirator")

                -- Detection logic:
                -- 1. High-End masks ONLY protect if they have a filter (Defense > 25, usually 100)
                -- 2. Simple masks (Bandana, Surgical) ALWAYS protect if they have their base defense (25)
                local isProtected = false
                if isHighEndMask then
                    if defense > 25 then
                        isProtected = true
                    end
                else
                    if defense >= 25 then
                        isProtected = true
                    end
                end

                if dbg() then
                    ZomboLust.debugLog(MODULE_NAME, "Checking Item: %s | Defense: %.2f | isHighEnd: %s | Protected: %s",
                        fullType, defense, tostring(isHighEndMask ~= nil), tostring(isProtected))
                end

                if isProtected then
                    return true
                end
            end
        end
    end

    return false
end

--- Computes the target Stress value for the Wimp trait from the current Excitation.
--- Two-segment curve: a steep rise from 0 to WimpAnxietyBreakpoint% (reaching Moodles_Stress_lvl1 right at the breakpoint),
--- then a much gentler rise up to WimpAnxietyMaxStress at 100%
--- (crossing Moodles_Stress_lvl2 around the midpoint and Moodles_Stress_lvl3 near 87-90%, never reaching Moodles_Stress_lvl4).
--- @param excitation number
--- @return number
local function getWimpAnxietyTarget(excitation)
    local breakpoint = ZomboLust_ExcitationSystem.WimpAnxietyBreakpoint
    if excitation <= breakpoint then
        return excitation / 100
    end

    local breakpointStress = breakpoint / 100
    local t = (excitation - breakpoint) / (100 - breakpoint)
    return breakpointStress + t * (ZomboLust_ExcitationSystem.WimpAnxietyMaxStress - breakpointStress)
end

-- ================
-- Logic Functions
-- ================

--- Lewd/Nymphomaniac traits: flat, constant passive Excitation gain, regardless of surroundings.
--- Deliberately independent of any native stat (Boredom, Intoxication, ...):
--- a Boredom-linked version was tried first but got neutralized by this mod's own Excitation->Intoxication coupling
--- (high Excitation raises Intoxication, which suppresses native Boredom,
--- which cuts off the very signal driving the gain - a closed feedback loop with no clean fix).
--- @param player IsoPlayer
local function updateLewdPassiveExcitation(player)
    local traitLewd = ZomboLustRegistries.Traits.Lewd
    local traitNympho = ZomboLustRegistries.Traits.Nymphomaniac
    local hasLewd = traitLewd and player:hasTrait(traitLewd)
    local hasNympho = traitNympho and player:hasTrait(traitNympho)
    if not hasLewd and not hasNympho then return end

    -- Same scaling convention as the pheromone gain below: normalizes for game speed and the throttled update rate.
    local multiplier = getGameTime():getMultiplier() * ZomboLust_ExcitationSystem.UpdateTickRate
    local increase = ZomboLust_ExcitationSystem.LewdPassiveGainPerTick * multiplier

    local current = getExcitation(player)
    setExcitation(player, current + increase)

    ZomboLust.debugLog(MODULE_NAME, "Lewd/Nymphomaniac: Passive gain +%.4f -> Excitation %.2f%%", increase, getExcitation(player))
end

-- ==================================
-- Pheromone Gain Trait Multipliers
-- ==================================
-- Each entry below owns its own condition, and resolvePheromoneTraitMultiplier just multiplies together whichever ones apply.
-- Add a new trait's pheromone influence by adding an entry here.

--- @class ZL_PheromoneTraitEntry
--- @field trait string -- Key into ZomboLustRegistries.Traits
--- @field compute fun(player: IsoPlayer, ctx: table): number -- Returns the multiplier to apply once player:hasTrait(trait) is confirmed
--- @field exclusiveGroup string|nil -- If set, only the first trait a player has within the same group applies

--- @type ZL_PheromoneTraitEntry[]
local PheromoneTraitMultipliers = {
    { trait = "Promiscuous",  compute = function() return ZomboLust_ExcitationSystem.PromiscuousMultiplier end },
    { trait = "Nymphomaniac", compute = function() return ZomboLust_ExcitationSystem.NymphomaniacMultiplier end },
    {
        trait = "Swinger",
        compute = function(player)
            if ZomboLust_ExcitationSystem.getSwingerPartnerCount(player) > ZomboLust_ExcitationSystem.SwingerPartnerLimit then
                return ZomboLust_ExcitationSystem.SwingerMultiplier
            end
            return 1.0
        end,
    },
    { trait = "Wimp",        compute = function() return ZomboLust_ExcitationSystem.WimpMultiplier end },
    { trait = "SmokesAfter", compute = function() return ZomboLust_ExcitationSystem.SmokesAfterMultiplier end },
    {
        trait = "NoColdShowers",
        compute = function(_, ctx)
            if ctx.sq and ctx.sq:isOutside() and getClimateManager():isRaining() then
                return ZomboLust_ExcitationSystem.NoColdShowersMultiplier
            end
            return 1.0
        end,
    },
    -- Drinker traits are mutually exclusive in the base game trait picker
    -- The exclusiveGroup below keeps that guarantee even if that ever changes
    {
        trait = "DrinkerHeavy",
        exclusiveGroup = "Drinker",
        compute = function() return ZomboLust_ExcitationSystem.DrinkerHeavyGainMultiplier end,
    },
    {
        trait = "DrinkerLight",
        exclusiveGroup = "Drinker",
        compute = function(_, ctx)
            if ctx.current > 50 then return ZomboLust_ExcitationSystem.DrinkerLightGainMultiplier end
            return 1.0
        end,
    },
    {
        trait = "DrinkerNoob",
        exclusiveGroup = "Drinker",
        compute = function(_, ctx)
            if ctx.current > 25 then return 1.0 + ((ctx.current - 25) / 50) end
            return 1.0
        end,
    },
}

--- Resolves the combined pheromone-gain multiplier from every applicable entry in PheromoneTraitMultipliers above
--- @param player IsoPlayer
--- @param ctx table -- {current: number, sq: IsoGridSquare|nil}
--- @return number
local function resolvePheromoneTraitMultiplier(player, ctx)
    local total = 1.0
    local groupApplied = {}
    for i = 1, #PheromoneTraitMultipliers do
        local entry = PheromoneTraitMultipliers[i]
        local group = entry.exclusiveGroup
        if not group or not groupApplied[group] then
            local traitId = ZomboLustRegistries.Traits[entry.trait]
            if traitId and player:hasTrait(traitId) then
                total = total * entry.compute(player, ctx)
                if group then groupApplied[group] = true end
            end
        end
    end
    return total
end

--- Scans for zombies in proximity and increases excitation
--- @param player IsoPlayer
local function updateExcitation(player)
    if not player or player:isDead() then return end

    -- Visual pulse and breathing logic (runs every frame for timing accuracy)
    -- Both live in their own files (ZomboLust_ExcitationVignettePulse.lua / ZomboLust_ExcitationBreathing.lua)
    -- but attach to this same ZomboLust_ExcitationSystem table.
    ZomboLust_ExcitationSystem.updateVignettePulse(player)
    ZomboLust_ExcitationSystem.updateBreathing(player)

    -- ======================================================================
    -- ZomboLust: Wimp Anxiety (Stress proportional to Excitation)
    -- Runs every frame (unthrottled), not in the throttled section below:
    -- the engine decays Stress on its own each frame when nothing it
    -- recognizes justifies it, so a periodic push here would get eroded
    -- between our updates (same class of issue as Discomfort's
    -- internalDiscomfort countermeasure in ZomboLust_Physiology.lua).
    -- Also needs to stay reachable during sex animations, unlike the
    -- pheromone/intoxication logic further below which returns early there.
    -- ======================================================================
    local traitWimp = ZomboLustRegistries.Traits.Wimp
    if traitWimp and player:hasTrait(traitWimp) then
        local stats = player:getStats()
        local currentStress = stats:get(CharacterStat.STRESS)
        local targetStress = getWimpAnxietyTarget(getExcitation(player))
        if targetStress > currentStress then
            stats:set(CharacterStat.STRESS, targetStress)
        end
    end

    -- ======================================================================================
    -- ZomboLust: Nymphomaniac (constant Discomfort + groin Pain floors)
    -- Runs every frame (unthrottled) and stays reachable during sex animations,
    -- for the same reason as the Wimp Stress push above: the engine decays
    -- these stats on its own, so a periodic push here would get eroded between our updates.
    -- ======================================================================================
    local traitNympho = ZomboLustRegistries.Traits.Nymphomaniac
    if traitNympho and player:hasTrait(traitNympho) then
        local stats = player:getStats()
        local currentDiscomfort = stats:get(CharacterStat.DISCOMFORT)
        if currentDiscomfort < ZomboLust_ExcitationSystem.NymphomaniacDiscomfortFloor then
            stats:set(CharacterStat.DISCOMFORT, ZomboLust_ExcitationSystem.NymphomaniacDiscomfortFloor)
        end

        if player:getMoodles():getMoodleLevel(MoodleType.PAIN) < 1 then
            local groin = player:getBodyDamage():getBodyPart(BodyPartType.Groin)
            if groin then
                groin:setAdditionalPain(ZomboLust_ExcitationSystem.NymphomaniacGroinPainValue)
            end
        end
    end

    -- Optimization: Skip frames
    updateCounter = updateCounter + 1
    if updateCounter < ZomboLust_ExcitationSystem.UpdateTickRate then return end
    updateCounter = 0

    -- ==========================================
    -- ZomboLust: Sex Animation Excitation Logic
    -- ==========================================
    local animAction = ZomboDesire_AnimationHandler and ZomboDesire_AnimationHandler.currentAnimationAction
    if animAction and animAction.character == player and animAction.stageConfig then
        local actorConfig = animAction.stageConfig.actorConfig
        local totalStages = actorConfig and actorConfig.stages and #actorConfig.stages or 0
        local currentStageIndex = animAction.stageConfig.nextStageIndex - 1

        -- 1. If 3 stages -> No increase
        if totalStages == 3 then
            ZomboLust.debugLog(MODULE_NAME, "Animation with 3 stages: Excitation increase disabled")
            return
        end

        -- 2. If 5 stages -> Dedicated increase system
        if totalStages == 5 then
            -- Retrieve multiplier N (1-15, but we use the real value 5-75)
            local modOptions = PZAPI.ModOptions:getOptions("ZomboDesire")
            ---@type number
            local multiplier = 1
            if modOptions then
                local option = modOptions:getOption("stage2Multiplier")
                if option and option.getValue then
                    local index = tonumber(option:getValue()) or 1
                    local step = getActivatedMods():contains("ZomboLust") and 5 or 1
                    multiplier = index * step
                end
            end

            -- Target a TOTAL gross gain for the whole animation
            -- We target 70% gross gain to compensate for periodic decay and reach 100% (orgasm) towards the end of stage 4
            local totalTargetGain = 70.0
            local g1_5_total = 5.0 -- Total gain for stage 1 (and 5)

            -- Duration of the current action in frames (includes synchronization padding and multiplier N)
            local currentActionDuration = animAction.maxTime or 200

            ---@type number
            local finalIncrease = 0
            ---@type number
            local randomness = 0

            if currentStageIndex == 1 or currentStageIndex == 5 then
                -- Distribute g1_5_total over the actual duration of the stage (approx 384 frames : 240 * 1.6 = 384 frames)
                finalIncrease = (g1_5_total / currentActionDuration) * ZomboLust_ExcitationSystem.UpdateTickRate
            elseif currentStageIndex >= 2 and currentStageIndex <= 4 then
                -- Distribute the remaining gain (total - g1&5) over the 3 central stages
                local centralTotalGain = (totalTargetGain - (g1_5_total * 2)) / 3
                finalIncrease = (centralTotalGain / currentActionDuration) * ZomboLust_ExcitationSystem.UpdateTickRate

                -- Random variation (More impact for central stages)
                if currentStageIndex == 2 then
                    randomness = (ZombRand(21) - 10) / 100 -- +/- 10%
                elseif currentStageIndex == 3 then
                    randomness = (ZombRand(41) - 15) / 100 -- -15% to +25%
                elseif currentStageIndex == 4 then
                    randomness = (ZombRand(81) - 20) / 100 -- -20% to +60%
                end

                finalIncrease = finalIncrease * (1 + randomness)
            end

            if finalIncrease > 0 then
                local current = getExcitation(player)
                setExcitation(player, current + finalIncrease)

                -- ==================================
                -- ZomboLust: Orgasm Trigger (Case 2)
                -- ==================================
                if getExcitation(player) >= 100 then
                    if ZomboLust_OrgasmSystem and ZomboLust_OrgasmSystem.triggerOrgasmCase2 then
                        ZomboLust_OrgasmSystem.triggerOrgasmCase2(player)
                    end
                end

                ZomboLust.debugLog(MODULE_NAME, "Sex Anim (Stage %d/5, N=%d): Excitation +%.4f (Var: %d%%) | Total: %.2f%%",
                    currentStageIndex, multiplier, finalIncrease, math.floor(randomness * 100), getExcitation(player))
            end

            -- Skip the normal pheromone logic
            return
        end
    end

    -- A dragged corpse doesn't emit pheromones, and any nearby living zombie
    -- makes the player drop the corpse immediately, so there is no gain to compute here
    if player:isDraggingCorpse() then
        ZomboLust.debugLog(MODULE_NAME, "Excitation increase blocked: player is dragging a corpse")
        return
    end

    -- ================================================================
    -- ZomboLust: Lewd Trait (flat passive excitation)
    -- Fully independent path: does not touch the pheromone multiplier
    -- stack below, and does not depend on nearby zombies.
    -- ================================================================
    updateLewdPassiveExcitation(player)

    -- =====================================
    -- Normal Excitation Logic (Pheromones)
    -- =====================================
    local cell = player:getCell()
    local zombieList = cell:getZombieList()
    local px, py, pz = player:getX(), player:getY(), player:getZ()
    local radiusSq = ZomboLust_ExcitationSystem.PheromoneRadius * ZomboLust_ExcitationSystem.PheromoneRadius
    local hordeRadiusSq = ZomboLust_ExcitationSystem.HordeRadius * ZomboLust_ExcitationSystem.HordeRadius
    local nearbyZombies = 0
    local hordeZombies = 0

    -- ZomboLust: Sexual Intent System - refresh the "nothing left to strip" ModData flag and prepare this pass's adjacency scan
    -- (reuses this same zombie loop below instead of running a second dedicated scan over the zombie list)
    if ZomboLust_SexualIntentSystem then
        ZomboLust_SexualIntentSystem.updateUndressedFlag(player)
        ZomboLust_SexualIntentSystem.scanTick = ZomboLust_SexualIntentSystem.scanTick + 1
    end
    local playerSquare = player:getCurrentSquare()

    for i = 0, zombieList:size() - 1 do
        local zombie = zombieList:get(i)
        if zombie and zombie:isAlive() and zombie:getZ() == pz then
            local zx, zy = zombie:getX(), zombie:getY()
            local dx, dy = zx - px, zy - py
            local distSq = dx * dx + dy * dy
            if distSq <= radiusSq then
                nearbyZombies = nearbyZombies + 1
            end
            if distSq <= hordeRadiusSq then
                hordeZombies = hordeZombies + 1
            end

            -- ZomboLust: Sexual Intent System - roll (or refresh) the elected/bite intent for opposite-gender zombies within 1 tile
            -- (same Chebyshev adjacency test as ZomboDesire_Detection.isAdjacent, so this matches the actual collision range)
            if ZomboLust_SexualIntentSystem and playerSquare then
                local zombieSquare = zombie:getSquare()
                if zombieSquare then
                    local diffX = math.abs(playerSquare:getX() - zombieSquare:getX())
                    local diffY = math.abs(playerSquare:getY() - zombieSquare:getY())
                    if diffX <= 1 and diffY <= 1 then
                        ZomboLust_SexualIntentSystem.scanProximity(player, zombie)
                    end
                end
            end
        end
    end

    if ZomboLust_SexualIntentSystem then
        ZomboLust_SexualIntentSystem.purgeStale()
    end

    -- ==========================================================================
    -- ZomboLust: Horde Fear
    -- Too many zombies closing in overrides pheromone arousal:
    -- fear takes over and excitation decreases instead of rising.
    -- Panic only ever amplifies this decay (never triggers it alone), so traits
    -- like Agoraphobia/Claustrophobic that cause unrelated panic can't
    -- falsely suppress excitation when no horde is actually present.
    -- ==========================================================================
    if hordeZombies >= ZomboLust_ExcitationSystem.HordeZombieThreshold then
        local current = getExcitation(player)
        if current > 0 then
            local multiplier = getGameTime():getMultiplier() * ZomboLust_ExcitationSystem.UpdateTickRate
            local fearZombies = math.min(hordeZombies, ZomboLust_ExcitationSystem.HordeFearDecayCap)

            local panicMultiplier = 1.0
            if player:getMoodles():getMoodleLevel(MoodleType.PANIC) >= ZomboLust_ExcitationSystem.PanicMoodleMaxLevel then
                panicMultiplier = ZomboLust_ExcitationSystem.HordePanicDecayMultiplier
            end

            local decrease = fearZombies * ZomboLust_ExcitationSystem.HordeFearDecayPerZombie * multiplier * panicMultiplier
            setExcitation(player, current - decrease)

            ZomboLust.debugLog(MODULE_NAME, "Horde fear: %d zombies in range | Excitation: %.2f%% (-%.4f) | PanicMult: %.2f",
                hordeZombies, getExcitation(player), decrease, panicMultiplier)
        end
    elseif nearbyZombies > 0 then
        -- Beta-blockers cancel excitation increase
        if player:getBetaDelta() > 0 then
            ZomboLust.debugLog(MODULE_NAME, "Excitation increase blocked by Beta-blockers")
        else
            local current = getExcitation(player)
            -- Multiplier to normalize across frame rates and frequency
            local multiplier = getGameTime():getMultiplier() * ZomboLust_ExcitationSystem.UpdateTickRate

            -- Environmental influence
            local envMultiplier = 1.0
            local sq = player:getSquare()
            if sq and not sq:isOutside() then
                envMultiplier = ZomboLust_ExcitationSystem.IndoorMultiplier
            end

            -- Stimulant influence
            local stimMultiplier = 1.0
            local modData = player:getModData()
            if modData.ZL_StimulantTimer and modData.ZL_StimulantTimer > 0 then
                stimMultiplier = ZomboLust_ExcitationSystem.StimulantMultiplier
            end

            -- Mask influence
            local maskMultiplier = 1.0
            if hasExcitationDefense(player) then
                maskMultiplier = ZomboLust_ExcitationSystem.MaskMultiplier
            end

            -- Trait-driven influence (Promiscuous, Nymphomaniac, Swinger, Wimp, SmokesAfter, NoColdShowers, Drinker*):
            -- see PheromoneTraitMultipliers / resolvePheromoneTraitMultiplier above.
            local traitMultiplier = resolvePheromoneTraitMultiplier(player, { current = current, sq = sq })

            local increase = nearbyZombies * ZomboLust_ExcitationSystem.IncreasePerZombie * multiplier * envMultiplier * stimMultiplier * maskMultiplier * traitMultiplier
            setExcitation(player, current + increase)

            -- if dbg() then
                -- ZomboLust.debugLog(MODULE_NAME, "Zombies in pheromone range: %d | Excitation: %.2f%% (+%.4f) | Indoor: %s",
                --     nearbyZombies, getExcitation(player), increase, tostring(envMultiplier > 1.0))
            -- end
        end
    end

    -- Apply Intoxication effect (Blur and Drunk moodle)
    -- Blocked if Beta-blockers are active
    local excitationValue = getExcitation(player)
    if excitationValue > 0 and player:getBetaDelta() <= 0 then
        local stats = player:getStats()
        local currentIntox = stats:get(CharacterStat.INTOXICATION)
        local targetIntox = excitationValue * ZomboLust_ExcitationSystem.ExcitationToIntoxRatio

        -- Only push intoxication up to the target level
        if targetIntox > currentIntox then
            stats:set(CharacterStat.INTOXICATION, targetIntox)
        end
    end

    -- ==================================
    -- ZomboLust: Orgasm Trigger (Case 1)
    -- ==================================
    if getExcitation(player) >= 100 then
        if ZomboLust_OrgasmSystem and ZomboLust_OrgasmSystem.triggerOrgasmCase1 then
            ZomboLust_OrgasmSystem.triggerOrgasmCase1(player)
        end
    end
end

--- Decreases excitation over time
--- Single-player only: hardcodes getSpecificPlayer(0), see the Architecture Assumption note in ZomboLust_Main.lua
local function decayExcitation()
    local player = getSpecificPlayer(0)
    if not player then return end

    -- Handle Stimulant Timer Decay
    local modData = player:getModData()
    if modData.ZL_StimulantTimer and modData.ZL_StimulantTimer > 0 then
        -- Decay based on 10 minutes (matching the event frequency)
        modData.ZL_StimulantTimer = math.max(0, modData.ZL_StimulantTimer - 10)
        if modData.ZL_StimulantTimer == 0 then
            ZomboLust.debugLog(MODULE_NAME, "Stimulant effect expired")
        end
    end

    local current = getExcitation(player)
    if current > 0 then
        local decayValue = ZomboLust_ExcitationSystem.DecayPerTenMinutes

        -- Personality: Drinker Traits influence (Decay)
        -- If no trait is selected, decayValue remains ZomboLust_ExcitationSystem.DecayPerTenMinutes (default behavior)
        if player:hasTrait(ZomboLustRegistries.Traits.DrinkerHeavy) then
            -- Heavy drinker: Faster decay (recovers quickly)
            decayValue = decayValue * ZomboLust_ExcitationSystem.DrinkerHeavyDecayMultiplier
        elseif player:hasTrait(ZomboLustRegistries.Traits.DrinkerNoob) then
            -- Noob drinker: Slower decay (stays excited longer)
            decayValue = decayValue * ZomboLust_ExcitationSystem.DrinkerNoobDecayMultiplier
        end

        setExcitation(player, current - decayValue)
        ZomboLust.debugLog(MODULE_NAME, "Periodic decay applied. Excitation: %.2f%% (-%.2f)", getExcitation(player), decayValue)
    end
end

-- =================
-- Event Management
-- =================

--- Ensures the Nymphomaniac Excitation floor applies immediately when the player character is created
--- (new game or save load), instead of waiting for the next natural setExcitation call.
--- @param _ number -- Player index (unused)
--- @param player IsoPlayer
local function onCreatePlayerNymphomaniacFloor(_, player)
    if not player then return end
    local traitNympho = ZomboLustRegistries.Traits.Nymphomaniac
    if traitNympho and player:hasTrait(traitNympho) then
        setExcitation(player, getExcitation(player))
    end
end

--- Clears all Excitation-related state (bar, pink screen overlay, pulse/breathing state)
--- the instant the player dies, instead of leaving it displayed until the
--- death screen choice creates/loads a different player object.
--- Writes modData.ZL_Excitation directly (bypassing setExcitation) since the
--- Nymphomaniac trait floor must not keep the bar/overlay visible on a corpse.
--- @param player IsoPlayer
local function onPlayerDeathResetExcitation(player)
    if not player then return end

    local modData = player:getModData()
    modData.ZL_Excitation = 0
    modData.ZL_StimulantTimer = 0

    ZomboLust_ExcitationSystem.isPulsing = false
    ZomboLust_ExcitationSystem.pulseStage = 0
    ZomboLust_ExcitationSystem.lastBreathTime = 0

    ZomboLust.debugLog(MODULE_NAME, "Player died: Excitation reset to 0 (bar and pink overlay cleared)")
end

Events.OnCreatePlayer.Add(onCreatePlayerNymphomaniacFloor)
Events.OnPlayerUpdate.Add(updateExcitation)
Events.EveryTenMinutes.Add(decayExcitation)
Events.OnPlayerDeath.Add(onPlayerDeathResetExcitation)

print("[ZomboLust] Excitation System Initialized")
