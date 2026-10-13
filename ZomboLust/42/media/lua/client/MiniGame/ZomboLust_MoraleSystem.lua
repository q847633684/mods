-- File: ZomboLust/42/media/lua/client/MiniGame/ZomboLust_MoraleSystem.lua
-- This module handles the Morale (Sadness) mini-game simulation for ZomboLust: penalties,
-- zombie reward, Test Subject effect, and trauma expiry.
-- UI (the ZomboLust_MoraleBar widget) lives in ZomboLust_MoraleUI.lua; the mini-game/cleanup
-- monkey-patches live in ZomboLust_MoraleHooks.lua. Both require this file for ZomboLust_MoraleSystem.
-- @author BlaBla 2026

print("[ZomboLust LOADING] ZomboLust_MoraleSystem.lua loaded")

---@diagnostic disable: inject-field

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Utils"

-- ======================
-- Variables & Constants
-- ======================

ZomboLust_MoraleSystem = ZomboLust_MoraleSystem or {}
ZomboLust_MoraleSystem.BarUI = nil -- Set by ZomboLust_MoraleSystem.Launch (ZomboLust_MoraleUI.lua); also read/written by ZomboLust_MoraleHooks.lua and ZomboLust_OrgasmSystem.lua
ZomboLust_MoraleSystem.MoraleValue = 100
ZomboLust_MoraleSystem.FinalMoraleAtEndOfMiniGame = nil -- Store for later cleanup
ZomboLust_MoraleSystem.FinalZombieAtEndOfMiniGame = nil -- Zombie reference captured at mini-game start, for the health/speed reward applied at cleanup
ZomboLust_MoraleSystem.FinalZombieStartHealthAtEndOfMiniGame = nil -- Zombie's health at mini-game start (restoration reference)
ZomboLust_MoraleSystem.DecayRate = 0.35 -- Points per frame (~21 per second)
ZomboLust_MoraleSystem.IncreasePerPress = 1.75 -- Points per 'X' press
ZomboLust_MoraleSystem.UpdateTickRate = 1

-- Perspective reframing (player controls the zombie): thresholds shared by the live UI reactions
-- (arrow text/sound/pulse, see ZomboLust_MoraleBar in ZomboLust_MoraleUI.lua) and the end-of-encounter zombie reward (ZomboLust_MoraleSystem.ApplyZombieReward).
ZomboLust_MoraleSystem.LowMoraleThreshold = 50
ZomboLust_MoraleSystem.HighMoraleThreshold = 90

-- Module name for logging
--- @type string
local MODULE_NAME = "MoraleSystem"

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

--- Helper to get current difficulty level
--- Exposed on ZomboLust_MoraleSystem (rather than staying local) since ZomboLust_MoraleUI.lua's
--- ZomboLust_MoraleBar:finish() also needs it.
--- @return number -- 1: Casual, 2: Normal, 3: Vicious
function ZomboLust_MoraleSystem.getDifficultyLevel()
    local difficultyLevel = 1 -- Default to Casual
    if PZAPI and PZAPI.ModOptions then
        local options = PZAPI.ModOptions:getOptions("ZomboLust")
        local difficultyOption = options and options:getOption("difficulty")
        if difficultyOption then
            ---@cast difficultyOption umbrella.ModOptions.ComboBox
            difficultyLevel = difficultyOption:getValue()
        end
    end
    return difficultyLevel
end

local getDifficultyLevel = ZomboLust_MoraleSystem.getDifficultyLevel

--- Trauma trait duration (in days) per difficulty level.
--- Shared by Traumatized (see ZLApplyTrauma.lua) and the random negative traits applied below,
--- since both expire through the same ZL_Traumas/CheckTraumaExpiry mechanism.
--- @type table<number, number>
local TRAUMA_DURATION_DAYS = { [1] = 1, [2] = 3, [3] = 7 }

--- Helper to get the trauma trait duration (in days) for the current difficulty
--- @return number
local function getTraumaDurationDays()
    return TRAUMA_DURATION_DAYS[getDifficultyLevel()] or TRAUMA_DURATION_DAYS[1]
end

-- Deferred action helper, centralized in ZomboDesire_Utils.lua
local createDelayedAction = ZomboDesire_Utils.createDelayedAction

-- =================
-- Penalties Logic
-- =================

--- Applies final penalties to the player based on morale level
---@param character IsoPlayer
---@param morale number
function ZomboLust_MoraleSystem.ApplyFinalPenalties(character, morale)
    local difficultyLevel = getDifficultyLevel()
    if difficultyLevel == 1 then return end -- Casual (1) has no consequences

    if morale >= 90 then return end -- 90% and above = No penalty (Valiant and combative)

    ZomboLust.debugLog(MODULE_NAME, "Applying penalties for morale: %.2f", morale)

    -- 1. XP Loss
    ZomboLust_MoraleSystem.ApplyXPLoss(character, morale)

    -- 2. Item Drop (50% or less morale)
    if morale <= 50 then
        ZomboLust_MoraleSystem.DropRandomItem(character)

        -- Vicious (3) adds 50% risk for a second item
        if difficultyLevel == 3 then
            local roll = ZombRand(100)
            ZomboLust.debugLog(MODULE_NAME, "Vicious: Second item roll: %d / 100 (needs < 50)", roll)
            if roll < 50 then
                ZomboLust_MoraleSystem.DropRandomItem(character)
            end
        end
    end

    -- 3. Negative Trait (5% or less morale)
    if morale <= 5 then
        ZomboLust_MoraleSystem.ApplyNegativeTrait(character)

        -- Vicious (3) adds 5% risk for a second trait
        if difficultyLevel == 3 then
            local roll = ZombRand(100)
            ZomboLust.debugLog(MODULE_NAME, "Vicious: Second trait roll: %d / 100 (needs < 5)", roll)
            if roll < 5 then
                ZomboLust_MoraleSystem.ApplyNegativeTrait(character)
            end
        end
    end
end

-- ====================
-- Zombie Reward Logic
-- ====================

--- Rewards the zombie attacker (health restoration + speed bonus) based on how well the player resisted (final morale)
--- @param zombie IsoZombie|nil
--- @param startHealth number|nil -- Zombie's health captured at mini-game start (restoration reference)
--- @param morale number
function ZomboLust_MoraleSystem.ApplyZombieReward(zombie, startHealth, morale)
    ZomboLust.debugLog(MODULE_NAME, "ApplyZombieReward called: zombie=%s startHealth=%s morale=%.2f",
        tostring(zombie), tostring(startHealth), morale)

    if getDifficultyLevel() == 1 then
        ZomboLust.debugLog(MODULE_NAME, "ApplyZombieReward: aborted, difficulty is Casual")
        return -- Casual: no consequences, for the zombie either
    end
    if not zombie or not zombie:isAlive() then
        ZomboLust.debugLog(MODULE_NAME, "ApplyZombieReward: aborted, zombie is nil or not alive (zombie=%s)", tostring(zombie))
        return
    end
    if not startHealth or startHealth <= 0 then
        ZomboLust.debugLog(MODULE_NAME, "ApplyZombieReward: aborted, invalid startHealth (%s)", tostring(startHealth))
        return -- No valid reference to restore towards
    end

    if morale < ZomboLust_MoraleSystem.LowMoraleThreshold then
        ZomboLust.debugLog(MODULE_NAME, "Zombie reward: morale %.2f < %d%%, no reward", morale, ZomboLust_MoraleSystem.LowMoraleThreshold)
        return -- 0-49%: no reward
    end

    -- 50-89%: 50% of the missing health restored. 90-100%: fully restored.
    local healthFraction = (morale >= ZomboLust_MoraleSystem.HighMoraleThreshold) and 1.0 or 0.5

    local currentHealth = zombie:getHealth()
    local missing = startHealth - currentHealth
    if missing > 0 then
        zombie:setHealth(math.min(startHealth, currentHealth + (missing * healthFraction)))
    end

    -- Speed bonus
    local currentSpeedType = zombie:getSpeedType() -- 1 = Sprinter, 2 = Fast Shambler, 3 = Shambler, -1 = unset
    if morale >= ZomboLust_MoraleSystem.HighMoraleThreshold then
        if currentSpeedType ~= 1 then
            -- doZombieSpeed() is used instead of doSprinter() because it keeps walkType in sync
            -- (see ChaosMod's EffectRandomZombiesAreSprinters) - doSprinter() only sets the speedType field,
            -- which the engine's own update loop later resyncs from the stale walkType left
            -- behind by ZomboDesire_ZombHumanUpdate.Zombify(), silently reverting the sprint.
            zombie:doZombieSpeed(1)
        end
    elseif currentSpeedType == 3 or currentSpeedType == -1 then
        zombie:doZombieSpeed(2)
    end

    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "Zombie reward applied: morale=%.2f healthFraction=%.2f health=%.2f/%.2f speedType=%d",
            morale, healthFraction, zombie:getHealth(), startHealth, zombie:getSpeedType())
    end
end

--- Applies random XP loss to a random skill
---@param character IsoPlayer
---@param morale number
function ZomboLust_MoraleSystem.ApplyXPLoss(character, morale)
    local xpObj = character:getXp()
    local perkList = PerkFactory.PerkList
    ---@type PerkFactory.Perk[]
    local validPerks = {}

    -- Filter perks where level > 0 and exclude passive perks (Strength/Fitness) and Agility category
    for i = 0, perkList:size() - 1 do
        local perk = perkList:get(i)
        local id = perk:getId()
        local parent = perk:getParent()
        local parentName = parent and parent:getName() or ""

        local isStrengthOrFitness = (id == "Strength" or id == "Fitness")
        local isAgility = (parentName == "Agility")

        if character:getPerkLevel(perk) > 0 and not isStrengthOrFitness and not isAgility then
            table.insert(validPerks, perk)
        end
    end

    if #validPerks == 0 then return end

    -- Select a random perk
    local selectedPerk = validPerks[ZombRand(#validPerks) + 1]
    ---@cast selectedPerk PerkFactory.Perk
    local currentLevel = character:getPerkLevel(selectedPerk)

    -- "One box" XP value calculation
    -- We use the XP required for the current level progress, but capped at 1000 XP
    local boxXP = selectedPerk:getXpForLevel(currentLevel + 1)
    local maxLossForFullBox = 1000 -- Maximum XP loss for a "full box"
    local fullBoxValue = math.min(boxXP, maxLossForFullBox)

    local lossAmount = 0
    if morale > 75 then
        lossAmount = math.floor(fullBoxValue / 8)
    elseif morale > 50 then
        lossAmount = math.floor(fullBoxValue / 4)
    elseif morale > 25 then
        lossAmount = math.floor(fullBoxValue / 2)
    else
        lossAmount = math.floor(fullBoxValue)
    end

    if lossAmount > 0 then
        -- Apply negative XP
        xpObj:AddXP(selectedPerk, -lossAmount, false, false, false, true)

        -- Visual Feedback
        HaloTextHelper.addTextWithArrow(character, selectedPerk:getName(), false, HaloTextHelper.getColorRed())

        -- Random Speech
        local speechIdx = ZombRand(1, 11) -- 1 to 10
        local speechKey = "IGUI_ZomboLust_XP_Speech_" .. speechIdx
        character:addLineChatElement(getText(speechKey), 1.0, 0.3, 0.3, UIFont.Dialogue, 30.0, "default", true, true, true, false, false, true)

        if dbg() then
            ZomboLust.debugLog(MODULE_NAME, "XP Loss: Perk=%s, Amount=%.2f, MaxBoxWas=%.2f",
                selectedPerk:getName(), lossAmount, fullBoxValue)
        end
    end
end

--- Drops a random item from the player's inventory
---@param character IsoPlayer
function ZomboLust_MoraleSystem.DropRandomItem(character)
    local inventory = character:getInventory()
    local items = inventory:getItems()
    if items:isEmpty() then return end

    -- Select a random item. Filter to only keep non-equipped items from the main inventory
    local validItems = {}
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if not item:isEquipped() then
            table.insert(validItems, item)
        end
    end

    if #validItems == 0 then return end

    -- Select a random item from the filtered list
    local selectedItem = validItems[ZombRand(#validItems) + 1]

    if selectedItem then
        local square = character:getCurrentSquare()
        if square then
            -- Small random offset for natural placement on the floor
            local offX = ZombRand(100) / 100.0
            local offY = ZombRand(100) / 100.0

            -- Add to world
            square:AddWorldInventoryItem(selectedItem, offX, offY, 0, true)
            -- Remove from player inventory
            character:getInventory():Remove(selectedItem)

            -- Visual Feedback
            local icon = selectedItem:getIcon()
            local iconName = icon and icon:getName() or ""
            local imgTag = ""
            -- Only allow icons that follow the "Item_Name" pattern and aren't full file paths
            -- This prevents issues with third-party mods returning full file paths which break the [img=] tag
            if iconName ~= "" and string.find(iconName, "^Item_") and not string.find(iconName, "[\\/]") then
                local cleanName = iconName
                -- Remove .png extension if it exists (for [img=] compatibility)
                if string.find(cleanName, "%.png$") then
                    cleanName = string.sub(cleanName, 1, -5)
                end
                imgTag = "[img=" .. string.sub(cleanName, 6) .. "]    "
            end

            local msg = imgTag .. getText("IGUI_ZomboLust_ItemLost") .. ": " .. selectedItem:getName()
            character:addLineChatElement(msg, 1.0, 0.3, 0.3, UIFont.Dialogue, 30.0, "default", true, true, true, false, false, true)

            if dbg() then
                ZomboLust.debugLog(MODULE_NAME, "Item Dropped from main inventory to ground: %s", selectedItem:getName())
            end
        end
    end
end

--- Applies a random negative trait to the player
---@param character IsoPlayer
function ZomboLust_MoraleSystem.ApplyNegativeTrait(character)
    ---@type any[]
    local traits = {
        "Cowardly", "Clumsy", "Agoraphobic", "SlowLearner", "RestlessSleeper",
        "Disorganized", "Hemophobic", "Sleepyhead", "ProneToIllness",
        "HeartyAppetite", "HardOfHearing", "Conspicuous", "Smoker",
        "SlowHealer", "WeakStomach", "SlowReader", "ShortSighted",
        "HighThirst", "AllThumbs"
    }

    -- Filter out traits the player already has
    local availableTraits = {}
    local knownTraits = character:getCharacterTraits():getKnownTraits()

    for _, traitName in ipairs(traits) do
        local traitObj = CharacterTrait.get(ResourceLocation.of(traitName))
        if traitObj then
            -- Check if the trait exists in the game (has a definition)
            local traitDef = CharacterTraitDefinition.getCharacterTraitDefinition(traitObj)
            if traitDef then
                -- Check if player already has it by scanning known traits list
                local alreadyHas = false
                for i = 0, knownTraits:size() - 1 do
                    if knownTraits:get(i) == traitObj then
                        alreadyHas = true
                        break
                    end
                end

                if not alreadyHas then
                    table.insert(availableTraits, traitName)
                end
            end
        end
    end

    if #availableTraits > 0 then
        local selectedTraitID = availableTraits[ZombRand(#availableTraits) + 1]
        ---@cast selectedTraitID string

        local traitObj = CharacterTrait.get(ResourceLocation.of(selectedTraitID))
        character:getCharacterTraits():add(traitObj)

        -- Visual Feedback
        local traitDef = CharacterTraitDefinition.getCharacterTraitDefinition(traitObj)
        local traitLabel = traitDef:getLabel()
        local msg = getText("IGUI_ZomboLust_TraitTrauma") .. ": " .. traitLabel
        character:addLineChatElement(msg, 1.0, 0.3, 0.3, UIFont.Dialogue, 30.0, "default", true, true, true, false, false, true)

        -- Trauma Expiry Logic (Temporary Trait, duration varies with difficulty)
        local modData = character:getModData()
        modData.ZL_Traumas = modData.ZL_Traumas or {}
        local currentDay = getGameTime():getDaysSurvived()
        local expiryDay = currentDay + getTraumaDurationDays()

        -- Store expiration info
        table.insert(modData.ZL_Traumas, { traitID = selectedTraitID, expiryDay = expiryDay })

        -- Hope Feedback (delayed speech)
        createDelayedAction(1800, function()
            if character and not character:isDead() then
                character:addLineChatElement(getText("IGUI_ZomboLust_TraitHope"), 0.5, 0.7, 1.0, UIFont.Dialogue, 30.0, "default", true, true, true, false, false, true)
            end
        end)

        -- Special handling for some traits that need immediate stat updates (optional but recommended in PZ)
        if selectedTraitID == "Smoker" then
            -- In B42, smoker stress is handled via NICOTINE_WITHDRAWAL stat
            character:getStats():set(CharacterStat.NICOTINE_WITHDRAWAL, 0.5) -- Make them need a smoke soon
        end

        ZomboLust.debugLog(MODULE_NAME, "Negative Trait Added: %s", selectedTraitID)
    end
end

--- Apply the special effects for the Test Subject trait after a sex act
---@param character IsoPlayer
function ZomboLust_MoraleSystem.ApplyTestSubjectEffect(character)
    local stats = character:getStats()
    local modData = character:getModData()

    -- Source of truth: use ModData if available, fallback to Stat
    local currentInfection = modData.ZL_Infection or stats:get(CharacterStat.ZOMBIE_INFECTION)

    -- Reduce infection by 25% of the CURRENT level.
    -- This prevents jumping to 0 directly if infection is low.
    local newInfection = currentInfection * 0.75
    if newInfection < 0.0 then newInfection = 0.0 end

    -- Update both source of truth and game stat
    modData.ZL_Infection = newInfection
    stats:set(CharacterStat.ZOMBIE_INFECTION, newInfection)

    ZomboLust.debugLog(MODULE_NAME, "Test Subject: Infection reduced. Old: %.4f | New: %.4f | Reduction: %.4f",
        currentInfection, newInfection, currentInfection - newInfection)

    -- XP Bonus/Malus based on thresholds
    local xpAmount = 100 -- Base XP reward/penalty
    local xp = character:getXp()

    if currentInfection > 60 then
        -- Malus: XP loss (AddXP with negative value)
        xp:AddXP(Perks.Strength, -xpAmount)
        xp:AddXP(Perks.Fitness, -xpAmount)
        xp:AddXP(Perks.Sprinting, -xpAmount)
    elseif currentInfection < 40 then
        -- Bonus: XP gain
        xp:AddXP(Perks.Strength, xpAmount)
        xp:AddXP(Perks.Fitness, xpAmount)
        xp:AddXP(Perks.Sprinting, xpAmount)
    end

    -- Visual Feedback
    character:addLineChatElement(getText("IGUI_ZomboLust_InfectionReduced"), 0.2, 0.8, 0.2, UIFont.Dialogue, 30.0, "default", true, true, true, false, false, true)
end

--- Periodic check for expired temporary traits (Traumas)
--- Called EveryDays at 0:00
function ZomboLust_MoraleSystem.CheckTraumaExpiry()
    local character = getPlayer()
    if not character or character:isDead() then return end

    local modData = character:getModData()
    if not modData.ZL_Traumas then return end

    local currentDay = getGameTime():getDaysSurvived()
    local toRemove = {}

    for i, trauma in ipairs(modData.ZL_Traumas) do
        if currentDay >= trauma.expiryDay then
            local traitObj = CharacterTrait.get(ResourceLocation.of(trauma.traitID))
            if traitObj then
                -- Remove the trait from the character
                character:getCharacterTraits():remove(traitObj)

                -- Visual Feedback (Blue/Green for hope/recovery)
                character:addLineChatElement(getText("IGUI_ZomboLust_TraitRecovered"), 0.5, 1.0, 0.5, UIFont.Dialogue, 30.0, "default", true, true, true, false, false, true)

                ZomboLust.debugLog(MODULE_NAME, "Trauma Expired and Removed: %s", trauma.traitID)
            end
            table.insert(toRemove, i)
        end
    end

    -- Clean up modData list in reverse to avoid index shifting
    for i = #toRemove, 1, -1 do
        table.remove(modData.ZL_Traumas, toRemove[i])
    end
end

Events.EveryDays.Add(ZomboLust_MoraleSystem.CheckTraumaExpiry)

return ZomboLust_MoraleSystem
