--- File: ZomboLust/42/media/lua/client/ZomboLust_HygieneDisease.lua
--- This module handles the hygiene calculation and disease contraction logic for ZomboLust.
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_HygieneDisease.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Utils"

---@class ZomboLust_HygieneDisease
local ZomboLust_HygieneDisease = {}

-- Module name for logging
--- @type string
local MODULE_NAME = "HygieneDisease"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

-- Syphilis Hallucination tracking
-- Module-local, not per-player modData: single-player only, see the Architecture Assumption note
-- in ZomboLust_Main.lua before relying on this across multiple simultaneous local players.
local hallucinationZombies = {}
local SYPHILIS_MAX_HALLUCINATIONS = 6
local SYPHILIS_SPAWN_DIST_MIN = 12
local SYPHILIS_SPAWN_DIST_MAX = 20
local SYPHILIS_FADE_DIST = 8.0

-- ==================
-- Utility Functions
-- ==================

--- Helper to update Syphilis hallucinations
--- @param player IsoPlayer
local function updateSyphilisHallucinations(player)
    local px, py = player:getX(), player:getY()
    local pheroRad = (ZomboLust_ExcitationSystem and ZomboLust_ExcitationSystem.PheromoneRadius) or 2.0
    
    for i = #hallucinationZombies, 1, -1 do
        local zombie = hallucinationZombies[i]
        if not zombie or zombie:isDead() or not zombie:getSquare() then
            table.remove(hallucinationZombies, i)
        else
            local zx, zy = zombie:getX(), zombie:getY()
            local dx, dy = zx - px, zy - py
            local dist = math.sqrt(dx * dx + dy * dy)
            
            if dist <= pheroRad then
                zombie:removeFromWorld()
                table.remove(hallucinationZombies, i)
            else
                -- Move towards player: Force the pathfinding and ensure they are walking
                zombie:pathToLocationF(px, py, player:getZ())
                zombie:faceThisObject(player)
                
                -- Opacity logic
                if dist < SYPHILIS_FADE_DIST then
                    -- Linear fade from SYPHILIS_FADE_DIST to pheroRad
                    -- 1.0 at SYPHILIS_FADE_DIST, 0.05 at pheroRad
                    local alpha = 0.05 + (0.95 * (dist - pheroRad) / (SYPHILIS_FADE_DIST - pheroRad))
                    zombie:setTargetAlpha(math.max(0.05, alpha))
                else
                    zombie:setTargetAlpha(1.0)
                end
            end
        end
    end
end

--- Helper to spawn a Syphilis hallucination zombie
--- @param player IsoPlayer
local function spawnSyphilisHallucination(player)
    if #hallucinationZombies >= SYPHILIS_MAX_HALLUCINATIONS then return end

    local x, y = player:getX(), player:getY()
    local dist = ZombRandFloat(SYPHILIS_SPAWN_DIST_MIN, SYPHILIS_SPAWN_DIST_MAX)
    local angle = ZombRandFloat(0, 2 * math.pi)
    local spawnX = math.floor(x + dist * math.cos(angle))
    local spawnY = math.floor(y + dist * math.sin(angle))
    local spawnZ = math.floor(player:getZ())
    
    local sq = getCell():getGridSquare(spawnX, spawnY, spawnZ)
    if not sq or not sq:isFree(false) then return end

    local zombies = addZombiesInOutfit(spawnX, spawnY, spawnZ, 1, "Tourist", 50, false, false, false, false, false, false, 1.0)
    if zombies and zombies:size() > 0 then
        local zombie = zombies:get(0)
        if zombie then
            zombie:setUseless(true)
            zombie:setNoTeeth(true)
            ---@diagnostic disable-next-line: param-type-mismatch
            zombie:setTarget(nil)
            zombie:getModData().ZL_IsHallucination = true
            table.insert(hallucinationZombies, zombie)
        end
    end
end

-- Deferred action helper, centralized in ZomboDesire_Utils.lua
local createDelayedAction = ZomboDesire_Utils.createDelayedAction

-- Functions in the 'Core Logic' section are called from ZLApplyTrauma.lua

-- ==========
-- Core Logic
-- ==========

--- Calculates the overall grime level of a character and rolls for potential disease contraction.
--- @param player IsoPlayer -- The player character to check
--- @param zombie IsoZombie|nil -- The zombie character involved in the act
function ZomboLust_HygieneDisease.rollForDisease(player, zombie)
    if not player or player:isZombie() then return end

    local traits = ZomboLustRegistries.Traits
    if not traits then return end

    -- DEBUG LOGS
    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "Checking Gonorrhea effect: Zombie=%s, HasTrait=%s",
            tostring(zombie), tostring(player:hasTrait(traits.Gonorrhea)))
    end

    -- 0. Special Gonorrhea effect: Ignite the zombie
    if zombie and player:hasTrait(traits.Gonorrhea) then
        ZomboLust.debugLog(MODULE_NAME, "Gonorrhea effect: Conditions met, starting timer (300 ticks)")
        -- Short delay to ensure it happens around the end of the animation/cleanup
        createDelayedAction(300, function()
            ZomboLust.debugLog(MODULE_NAME, "Gonorrhea effect: Timer finished, checking zombie...")
            if zombie and not zombie:isDead() then
                zombie:SetOnFire()
                ZomboLust.debugLog(MODULE_NAME, "Gonorrhea effect: Zombie ignited!")
            else
                ZomboLust.debugLog(MODULE_NAME, "Gonorrhea effect: Action failed (Zombie nil, dead or invalid reference)")
            end
        end)
    end

    -- 1. Calculate Grime
    -- We sum blood and dirt across all body parts.
    -- Each part (22 total) contributes to the visual mess.
    -- Observations show that blood and dirt together cap at ~1.0 visual impact per part.
    -- Total max is therefore 22.0.
    local visual = player:getHumanVisual()
    if not visual then return end

    ---@type number
    local totalGrime = 0
    local maxIdx = BloodBodyPartType.MAX:index()
    for i = 1, maxIdx do
        local part = BloodBodyPartType.FromIndex(i - 1)
        if part then
            totalGrime = totalGrime + (visual:getBlood(part) or 0) + (visual:getDirt(part) or 0)
        end
    end

    -- Convert to percentage (0% to 100%)
    -- Based on a realistic maximum of 22.0
    local grimePercentage = (totalGrime / 22.0) * 100
    if grimePercentage > 100 then grimePercentage = 100 end

    -- 2. Determine base diseaseChance
    -- 0-33%: 2%
    -- 34-66%: 4%
    -- 67-100%: 6%
    local diseaseChance = 2
    if grimePercentage >= 67 then
        diseaseChance = 6
    elseif grimePercentage >= 34 then
        diseaseChance = 4
    end

    -- 3. Apply Trait Filters
    local traits = ZomboLustRegistries.Traits
    if not traits then return end

    -- AIDS: Permanent +2% disease chance
    if player:hasTrait(traits.Aids) then
        diseaseChance = diseaseChance + 2
    end

    if player:hasTrait(traits.DislikesShowers) then
        diseaseChance = diseaseChance + 4
    elseif player:hasTrait(traits.Unkempt) then
        diseaseChance = diseaseChance + 2
    elseif player:hasTrait(traits.LovesClean) then
        diseaseChance = diseaseChance - 2
    end
    -- NeatTidy: +0% / -0% (No change)

    -- Ensure chance is not negative
    if diseaseChance < 0 then diseaseChance = 0 end

    -- 4. Roll for disease contraction
    local roll = ZombRand(1, 101) -- 1 to 100 inclusive
    if roll <= diseaseChance then
        -- 5. Select a random disease
        ---@type {id: string, trait: any, incurable?: boolean}[]
        local diseases = {
            { id = "ZomboLust:Aids", trait = traits.Aids, incurable = true },
            { id = "ZomboLust:Chlamydia", trait = traits.Chlamydia },
            { id = "ZomboLust:Gonorrhea", trait = traits.Gonorrhea },
            { id = "ZomboLust:Herpes", trait = traits.Herpes },
            { id = "ZomboLust:Syphilis", trait = traits.Syphilis }
        }

        local index = ZombRand(#diseases) + 1
        local selection = diseases[index]
        if not selection then return end

        local selectedTrait = selection.trait
        local traitID = selection.id

        if selectedTrait then
            -- Add the trait (or reset if already present)
            player:getCharacterTraits():add(selectedTrait)

            -- 6. Register for expiry (except Aids/incurable)
            if not selection.incurable then
                local currentDay = getGameTime():getDaysSurvived()
                local expiryDay = currentDay + 7

                local modData = player:getModData()
                modData.ZL_Diseases = modData.ZL_Diseases or {}

                -- Reset duration if already present
                local updated = false
                for _, entry in ipairs(modData.ZL_Diseases) do
                    if entry.traitID == traitID then
                        entry.expiryDay = expiryDay
                        updated = true
                        break
                    end
                end

                if not updated then
                    table.insert(modData.ZL_Diseases, {
                        traitID = traitID,
                        expiryDay = expiryDay
                    })
                end
            end

            -- 7. Delayed visual and audio feedback
            -- 7a. Vomiting animation and sound (1800 ticks delay)
            ZomboLust.debugLog(MODULE_NAME, "Disease Contracted: Scheduling vomit animation (1800 ticks)")
            createDelayedAction(1800, function()
                if dbg() then
                    ZomboLust.debugLog(MODULE_NAME, "Vomit Timer finished, triggering animation for %s", player:getUsername())
                end
                if player and not player:isDead() then
                    -- Block controls to prevent interruption
                    if ZomboDesire_Utils and ZomboDesire_Utils.disablePlayerControls then
                        ZomboDesire_Utils.disablePlayerControls(player)
                    end

                    player:StopAllActionQueue()
                    player:playEmote("vomit")
                    local sound = player:getDescriptor():getVoicePrefix() .. "Vomit"
                    player:getEmitter():playVocals(sound)

                    -- Optional: add some ground stains
                    for i = 1, 8 do
                        local bx = player:getX() - 0.5 + ZombRandFloat(0.1, 0.9)
                        local by = player:getY() - 0.5 + ZombRandFloat(0.1, 0.9)
                        local bz = player:getZ()
                        player:getChunk():addBloodSplat(bx, by, bz, math.floor(ZombRand(10)))
                    end

                    -- Restore controls after the animation (65 frames @ 30fps ~ 130 ticks + buffer)
                    createDelayedAction(140, function()
                        if player and ZomboDesire_Utils and ZomboDesire_Utils.enablePlayerControls then
                            ZomboDesire_Utils.enablePlayerControls(player)
                            if dbg() then
                                ZomboLust.debugLog(MODULE_NAME, "Vomit animation finished, restoring controls for %s", player:getUsername())
                            end
                        end
                    end)
                end
            end)

            -- 7b. Final visual feedback (speech) (2000 ticks delay)
            createDelayedAction(2000, function() -- ~3s after vomiting starts
                if dbg() then
                    ZomboLust.debugLog(MODULE_NAME, "Vomit Speech Timer finished, triggering dialogue for %s", player:getUsername())
                end
                if player and not player:isDead() then
                    player:addLineChatElement(getText("IGUI_ZomboLust_DiseaseContracted"), 0.8, 0.2, 0.2, UIFont.Dialogue, 30.0, "default", true, true, true, false, false, true)
                end
            end)

            ZomboLust.debugLog(MODULE_NAME, "Disease Contracted: %s (Chance: %d%%, Roll: %d, Grime: %.2f%%)",
                traitID, diseaseChance, roll, grimePercentage)
        end
    else
        ZomboLust.debugLog(MODULE_NAME, "Disease Roll Failed (Safe): Chance: %d%%, Roll: %d, Grime: %.2f%%",
            diseaseChance, roll, grimePercentage)
    end
end

--- Periodic check for expired diseases
--- Called EveryDays at 0:00
function ZomboLust_HygieneDisease.checkDiseaseExpiry()
    local character = getPlayer()
    if not character or character:isDead() then return end

    local modData = character:getModData()
    if not modData.ZL_Diseases then return end

    local currentDay = getGameTime():getDaysSurvived()
    local toRemove = {}

    for i, disease in ipairs(modData.ZL_Diseases) do
        if currentDay >= disease.expiryDay then
            local traitObj = CharacterTrait.get(ResourceLocation.of(disease.traitID))
            if traitObj then
                -- Remove the trait from the character
                character:getCharacterTraits():remove(traitObj)

                -- Visual Feedback
                character:addLineChatElement(getText("IGUI_ZomboLust_TraitRecovered"), 0.5, 1.0, 0.5, UIFont.Dialogue, 30.0, "default", true, true, true, false, false, true)

                ZomboLust.debugLog(MODULE_NAME, "Disease Expired and Removed: %s", disease.traitID)
            end
            table.insert(toRemove, i)
        end
    end

    -- Clean up modData list in reverse to avoid index shifting
    for i = #toRemove, 1, -1 do
        table.remove(modData.ZL_Diseases, toRemove[i])
    end
end

-- ==========================
-- Disease Effects (Gameplay)
-- ==========================

--- Marks a per-player, per-key event as "already handled this hour", returning true only
--- the FIRST time it's called for a given hour (subsequent calls within the same hour return false).
--- Used both for gameplay triggers that should fire once per hour (Syphilis's sound + hallucination spawn)
--- and to throttle debug logging inside a per-tick effect function - for the latter, always call as "dbg() and onceThisHour(...)" (in that order)
--- so the modData slot is only consumed while debugging is actually on.
--- @param player IsoPlayer
--- @param key string -- ModData key, unique per disease/effect (e.g. "ZL_ChlamydiaDebug")
--- @param hour integer -- Current game hour (getGameTime():getHour())
--- @return boolean
local function onceThisHour(player, key, hour)
    local modData = player:getModData()
    if modData[key] == hour then return false end
    modData[key] = hour
    return true
end

--- Applies a constant minimum groin pain floor, only when the current Pain moodle level hasn't already reached moodleLevelFloor on its own
--- (0: None, 1: Slight, 2: Pain, 3: Severe, 4: Agony) - avoids fighting player-caused pain that's already higher.
--- @param player IsoPlayer
--- @param moodleLevelFloor integer
--- @param painValue number
--- @return boolean -- True if the floor was applied (groin part found and moodle below floor)
local function applyGroinPainFloor(player, moodleLevelFloor, painValue)
    if player:getMoodles():getMoodleLevel(MoodleType.PAIN) >= moodleLevelFloor then return false end
    local groin = player:getBodyDamage():getBodyPart(BodyPartType.Groin)
    if not groin then return false end
    groin:setAdditionalPain(painValue)
    return true
end

--- Apply effects for Chlamydia: Intermittent pain and constant endurance drain.
--- @param player IsoPlayer
local function applyChlamydiaEffects(player)
    local stats = player:getStats()

    -- 1. Intermittent Pain Flare-up (4h on, 2h off - 6h cycle)
    local hour = getGameTime():getHour()
    local isFlareUp = (hour % 6 < 4)
    if isFlareUp then
        local applied = applyGroinPainFloor(player, 1, 10) -- Level 1 pain is around 10
        if applied and dbg() and onceThisHour(player, "ZL_ChlamydiaDebug", hour) then
            ZomboLust.debugLog(MODULE_NAME, "Chlamydia: Pain flare-up active (Hour: %d)", hour)
        end
    end

    -- 2. Constant Endurance Drain (Weakness)
    -- Drain 0.0001 per update tick.
    local currentEndurance = stats:get(CharacterStat.ENDURANCE)
    stats:set(CharacterStat.ENDURANCE, currentEndurance - 0.0001)
end

--- Apply effects for Gonorrhea: Intermittent pain and periodic fever.
--- @param player IsoPlayer
local function applyGonorrheaEffects(player)
    local stats = player:getStats()

    -- 1. Intermittent Pain Flare-up (4h on, 2h off - 6h cycle)
    local hour = getGameTime():getHour()
    local isPainFlareUp = (hour % 6 < 4)
    if isPainFlareUp then
        local applied = applyGroinPainFloor(player, 1, 10)
        if applied and dbg() and onceThisHour(player, "ZL_GonorrheaDebug", hour) then
            ZomboLust.debugLog(MODULE_NAME, "Gonorrhea: Pain flare-up active (Hour: %d)", hour)
        end
    end

    -- 2. Periodic Fever (3h on, 3h off - 6h cycle, offset by 3h from pain for variety)
    local isFeverPhase = ((hour + 3) % 6 < 3)
    if isFeverPhase then
        local currentTemp = stats:get(CharacterStat.TEMPERATURE)
        if currentTemp < 39.0 then
            -- Increase temperature towards feverish levels
            stats:set(CharacterStat.TEMPERATURE, currentTemp + 0.01)
            if dbg() and currentTemp < 37.5 then -- Log only at start of fever
                ZomboLust.debugLog(MODULE_NAME, "Gonorrhea: Fever phase active (Hour: %d, Temp: %.2f)", hour, currentTemp)
            end
        end
    end
end

--- Apply effects for Herpes: Periodic fever, stress and discomfort.
--- @param player IsoPlayer
local function applyHerpesEffects(player)
    local stats = player:getStats()
    local hour = getGameTime():getHour()

    -- 8h cycle: 4h active flare-up, 4h remission
    local isFlareUp = (hour % 8 < 4)

    if isFlareUp then
        -- 1. Light Fever (Target 38.5)
        local currentTemp = stats:get(CharacterStat.TEMPERATURE)
        if currentTemp < 38.5 then
            stats:set(CharacterStat.TEMPERATURE, currentTemp + 0.01)
        end

        -- 2. Stress Increase
        local currentStress = stats:get(CharacterStat.STRESS)
        if currentStress < 0.5 then
            stats:set(CharacterStat.STRESS, currentStress + 0.001)
        end

        -- 3. Discomfort (Level 1 ~ 20.0)
        local currentDiscomfort = stats:get(CharacterStat.DISCOMFORT)
        if currentDiscomfort < 20.0 then
            stats:set(CharacterStat.DISCOMFORT, 20.0)
        end

        if dbg() and onceThisHour(player, "ZL_HerpesDebug", hour) then
            ZomboLust.debugLog(MODULE_NAME, "Herpes: Flare-up active (Hour: %d, Temp: %.2f, Stress: %.2f)", hour, currentTemp, currentStress)
        end
    end
end

--- Apply effects for Syphilis: Mental confusion (Insanity), fatigue and constant pain.
--- @param player IsoPlayer
local function applySyphilisEffects(player)
    local stats = player:getStats()
    local hour = getGameTime():getHour()

    -- 1. Constant low-level Pain (Level 2)
    local painApplied = applyGroinPainFloor(player, 2, 25)
    if painApplied and dbg() and onceThisHour(player, "ZL_SyphilisPainDebug", hour) then
        ZomboLust.debugLog(MODULE_NAME, "Syphilis: Constant groin pain applied (Value: 25, Hour: %d)", hour)
    end

    -- 2. Flare-up cycle (12h cycle: 2h active, 10h remission)
    local isFlareUp = (hour % 12 < 2)
    local cm = ClimateManager.getInstance()

    if isFlareUp then
        -- Fatigue increase
        local currentFatigue = stats:get(CharacterStat.FATIGUE)
        if currentFatigue < 1.0 then
            stats:set(CharacterStat.FATIGUE, currentFatigue + 0.0005)
        end

        -- Hallucination logic: Update and spawn
        updateSyphilisHallucinations(player)

        -- Visual effect (Insanity) - Black and White
        if cm then
            local desat = cm:getClimateFloat(ClimateManager.FLOAT_DESATURATION)
            if desat then
                desat:setEnableOverride(true)
                desat:setOverride(1.0, 1.0)
            end
        end

        -- Sound effect and Initial Spawn (Trigger once at start of flare-up)
        if onceThisHour(player, "ZL_SyphilisDebug", hour) then
            player:playSound("insane1")

            -- Initial spawn of hallucinations
            for i = 1, SYPHILIS_MAX_HALLUCINATIONS do
                spawnSyphilisHallucination(player)
            end

            ZomboLust.debugLog(MODULE_NAME, "Syphilis: Flare-up active (Hour: %d, Fatigue: %.2f)", hour, currentFatigue)
        end

        -- Occasional respawn during flare-up
        if #hallucinationZombies < SYPHILIS_MAX_HALLUCINATIONS and ZombRand(600) == 0 then
            spawnSyphilisHallucination(player)
        end
    else
        -- End of flare-up: Reset visual effect and cleanup hallucinations
        if #hallucinationZombies > 0 then
            for i = #hallucinationZombies, 1, -1 do
                local zombie = hallucinationZombies[i]
                if zombie then zombie:removeFromWorld() end
                table.remove(hallucinationZombies, i)
            end
        end

        if cm then
            local desat = cm:getClimateFloat(ClimateManager.FLOAT_DESATURATION)
            if desat then
                desat:setEnableOverride(false)
            end
        end
    end
end

--- Apply effects for AIDS: Permanent fatigue, high infection risk.
--- @param player IsoPlayer
local function applyAidsEffects(player)
    local stats = player:getStats()
    local bodyDamage = player:getBodyDamage()
    local hour = getGameTime():getHour()

    -- 1. Permanent Level 1 Fatigue Floor (Drowsy moodle starts at 0.3)
    local currentFatigue = stats:get(CharacterStat.FATIGUE)
    if currentFatigue < 0.31 then
        stats:set(CharacterStat.FATIGUE, 0.31)
        currentFatigue = 0.31
    end

    -- 2. Constant Fatigue Increase (Chronic exhaustion)
    -- Adds 0.0002 per tick, making the character tire significantly faster than normal
    stats:set(CharacterStat.FATIGUE, currentFatigue + 0.0002)

    if dbg() and onceThisHour(player, "ZL_AidsDebug", hour) then
        ZomboLust.debugLog(MODULE_NAME, "AIDS: Chronic fatigue active (Fatigue: %.2f, Hour: %d)", stats:get(CharacterStat.FATIGUE), hour)
    end

    -- 2. Vulnerability: Higher wound infection risk
    local bodyParts = bodyDamage:getBodyParts()
    for i = 0, bodyParts:size() - 1 do
        local part = bodyParts:get(i)
        -- If wounded and not yet infected, roll for infection (very low chance per tick, but frequent)
        if (part:scratched() or part:isCut() or part:deepWounded()) and not part:IsInfected() then
            if ZombRand(10000) < 5 then -- ~0.05% chance per tick
                part:SetInfected(true)
                if dbg() then
                    ZomboLust.debugLog(MODULE_NAME, "AIDS: Wound on %s became infected due to immunodeficiency", tostring(part:getType()))
                end
            end
        end
    end
end

--- Long-term deterioration for AIDS: Weight loss and stat decay.
--- Called via EveryDays
local function updateAidsDeterioration()
    local player = getPlayer()
    if not player or player:isDead() then return end

    local traits = ZomboLustRegistries.Traits
    if not traits or not player:hasTrait(traits.Aids) then return end

    local modData = player:getModData()
    local currentDay = getGameTime():getDaysSurvived()

    -- 1. Periodic Weight Loss (-5kg every 4 to 6 days)
    modData.ZL_AidsWeightNextCheck = modData.ZL_AidsWeightNextCheck or (currentDay + ZombRand(4, 7))

    if currentDay >= modData.ZL_AidsWeightNextCheck then
        local nutrition = player:getNutrition()
        local currentWeight = nutrition:getWeight()
        nutrition:setWeight(currentWeight - 5.0)

        -- Schedule next check
        modData.ZL_AidsWeightNextCheck = currentDay + ZombRand(4, 7)

        ZomboLust.debugLog(MODULE_NAME, "AIDS: Severe weight loss triggered (-5kg). New weight: %.2f", currentWeight - 5.0)
    end

    -- 2. Stat Decay (Strength and Fitness decay slowly over time, floor at level 3)
    local strength = player:getPerkLevel(Perks.Strength)
    local fitness = player:getPerkLevel(Perks.Fitness)

    if strength > 3 and ZombRand(100) < 20 then -- 20% chance per day to lose XP
        player:getXp():AddXP(Perks.Strength, -50, false, false, false)
    end

    if fitness > 3 and ZombRand(100) < 20 then
        player:getXp():AddXP(Perks.Fitness, -50, false, false, false)
    end
end

--- Main dispatcher for disease effects called on every player update.
--- @param player IsoPlayer
function ZomboLust_HygieneDisease.onPlayerUpdate(player)
    if not player or player:isDead() or player:isZombie() then
        -- Cleanup hallucinations if player is no longer valid/alive
        if #hallucinationZombies > 0 then
            for i = #hallucinationZombies, 1, -1 do
                local zombie = hallucinationZombies[i]
                if zombie then zombie:removeFromWorld() end
                table.remove(hallucinationZombies, i)
            end
        end

        -- Clear the Syphilis desaturation filter if the player died during an active flare-up:
        -- applySyphilisEffects() only disables it in its own "remission" branch,
        -- which this early return prevents from ever running again, leaving
        -- the black & white filter stuck on (potentially into the next character).
        if player and player:isDead() then
            local cm = ClimateManager.getInstance()
            if cm then
                local desat = cm:getClimateFloat(ClimateManager.FLOAT_DESATURATION)
                if desat then
                    desat:setEnableOverride(false)
                end
            end
        end

        return
    end

    local traits = ZomboLustRegistries.Traits
    if not traits then return end

    -- Check for each disease and call its specific function
    if player:hasTrait(traits.Chlamydia) then
        applyChlamydiaEffects(player)
    end
    if player:hasTrait(traits.Gonorrhea) then
        applyGonorrheaEffects(player)
    end
    if player:hasTrait(traits.Herpes) then
        applyHerpesEffects(player)
    end
    if player:hasTrait(traits.Syphilis) then
        applySyphilisEffects(player)
    elseif #hallucinationZombies > 0 then
        -- Cleanup hallucinations if trait was removed (e.g. cured)
        for i = #hallucinationZombies, 1, -1 do
            local zombie = hallucinationZombies[i]
            if zombie then zombie:removeFromWorld() end
            table.remove(hallucinationZombies, i)
        end
    end
    if player:hasTrait(traits.Aids) then
        applyAidsEffects(player)
    end

    -- Optional: Periodic debug log for active diseases (once per game hour)
    if dbg() then
        local hour = getGameTime():getHour()
        ---@diagnostic disable-next-line: undefined-field
        if not ZomboLust_HygieneDisease._lastDebugHour or ZomboLust_HygieneDisease._lastDebugHour ~= hour then
            ZomboLust_HygieneDisease._lastDebugHour = hour
            ZomboLust.debugLog(MODULE_NAME, "Updating disease effects for %s (Hour: %d)", player:getUsername(), hour)
        end
    end
end

Events.EveryDays.Add(ZomboLust_HygieneDisease.checkDiseaseExpiry)
Events.EveryDays.Add(updateAidsDeterioration)
Events.OnPlayerUpdate.Add(ZomboLust_HygieneDisease.onPlayerUpdate)

return ZomboLust_HygieneDisease
