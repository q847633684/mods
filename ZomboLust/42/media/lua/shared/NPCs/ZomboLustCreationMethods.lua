-- File: ZomboLust/42/media/lua/shared/NPCs/ZomboLustCreationMethods.lua
-- This module handles the configuration of ZomboLust professions and traits (B42)
-- @author BlaBla 2026

-- =============
-- Dependencies
-- =============
require "NPCs/MainCreationMethods"

ZomboLustCreation = {}

-- Module name for logging
--- @type string
local MODULE_NAME = "CreationMethods"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

-- ======================================
-- Profession Configuration (OnGameBoot)
-- ======================================

ZomboLustCreation.DoProfessions = function()
    -- B42: Native methods like CharacterProfession.getProfession(string) often return nil for modded professions during OnGameBoot.
    -- We use ZomboLustRegistries (initialized in registries.lua) to safely access the Java objects.
    if not ZomboLustRegistries or not ZomboLustRegistries.Professions then
        return
    end

    -- Only profession traits are defined here.
    local profs = ZomboLustRegistries.Professions

    -- Configuration: Prostitute
    local prostitute = CharacterProfessionDefinition.getCharacterProfessionDefinition(profs.prostitute)
    if prostitute then
        -- B42: Many functions now strictly require Trait objects rather than string IDs.
        local traitProv = ZomboLustRegistries.Traits.Provocative
        if traitProv then prostitute:addGrantedTrait(traitProv) end
    end

    -- Configuration: Sex Slave
    local sexslave = CharacterProfessionDefinition.getCharacterProfessionDefinition(profs.sexslave)
    if sexslave then
        local traitDpress = ZomboLustRegistries.Traits.Dpress
        if traitDpress then sexslave:addGrantedTrait(traitDpress) end
    end

    -- Configuration: Sexperiment (Cobaye)
    local sexperiment = CharacterProfessionDefinition.getCharacterProfessionDefinition(profs.sexperiment)
    if sexperiment then
        local traitTestSubject = ZomboLustRegistries.Traits.TestSubject
        if traitTestSubject then sexperiment:addGrantedTrait(traitTestSubject) end
    end
end

-- ==========================
-- Starting Gear (OnNewGame)
-- ==========================

ZomboLustCreation.pStartGear = function(player)
    -- B42: player:getDescriptor():getProfession() is often nil or deprecated.
    -- Use getCharacterProfession() which returns the CharacterProfession object.
    local profession = player:getDescriptor():getCharacterProfession()
    local inventory = player:getInventory()

    local profProstitute = ZomboLustRegistries.Professions.prostitute
    local profSexSlave = ZomboLustRegistries.Professions.sexslave
    local profSexperiment = ZomboLustRegistries.Professions.sexperiment

    if profession == profProstitute then
        -- 7) Purse (Sac à main)
        local purse = inventory:AddItem("Base.Purse")
        if purse and purse:getInventory() then
            local purseInv = purse:getInventory()

            -- 1) Money (Argent) - Random amount
            local moneyAmount = ZombRand(15, 51) -- 15 to 50
            purseInv:AddItems("Base.Money", moneyAmount)

            -- 2) Cigarettes and Lighter
            purseInv:AddItem("Base.CigarettePack")
            purseInv:AddItem("Base.Lighter")

            -- 3) Perfume
            purseInv:AddItem("Base.Perfume")

            -- 4) Eye Makeup (MakeupEyeshadow in B42)
            purseInv:AddItem("Base.MakeupEyeshadow")

            -- 5) Lipstick
            purseInv:AddItem("Base.Lipstick")

            -- 6) Defense Weapon (Random between KitchenKnife and LetterOpener)
            if ZombRand(2) == 0 then
                purseInv:AddItem("Base.KitchenKnife")
            else
                purseInv:AddItem("Base.LetterOpener")
            end

            -- 7) Random Lingerie (Bra and Panties/Underpants)
            ---@type string[]
            local bras = {"Base.Bra_Straps_Black", "Base.Bra_Straps_White", "Base.Bra_Straps_FrillyRed", "Base.Bra_Straps_FrillyPink", "Base.Bra_Straps_AnimalPrint"}
            ---@type string[]
            local undies = {"Base.Underpants_Black", "Base.Underpants_White", "Base.Underpants_RedSpots", "Base.Underpants_AnimalPrint"}

            local braIndex = ZombRand(#bras) + 1
            local undieIndex = ZombRand(#undies) + 1

            purseInv:AddItem(bras[braIndex])
            purseInv:AddItem(undies[undieIndex])
        end
    elseif profession == profSexSlave then
        inventory:AddItem("Base.Leash")
    elseif profession == profSexperiment then
        local briefcase = inventory:AddItem("Base.Briefcase")
        if briefcase and briefcase:getInventory() then
            local briefcaseInv = briefcase:getInventory()
            briefcaseInv:AddItems("Base.MoneyBundle", 5)
            briefcaseInv:AddItem("Base.Pen")
            briefcaseInv:AddItem("Base.Hat_SurgicalMask")
            briefcaseInv:AddItem("Base.OfficialDocument")
        end
    end

    -- Test Subject Initial State
    local traitTestSubject = ZomboLustRegistries.Traits.TestSubject
    if traitTestSubject and player:hasTrait(traitTestSubject) then
        local bodyDamage = player:getBodyDamage()
        bodyDamage:setInfected(false)
        -- B42: Use Stats for Knox Infection
        -- Source of truth stored in ModData to prevent engine reset
        local modData = player:getModData()
        modData.ZL_Infection = 25.0
        player:getStats():set(CharacterStat.ZOMBIE_INFECTION, modData.ZL_Infection)
        -- Ensure standard infection doesn't kill
        bodyDamage:setInfectionTime(-1)

        ZomboLust.debugLog(MODULE_NAME, "Test Subject Initialized: Infection 25 percent | Safety Active")
    elseif not traitTestSubject then
        ZomboLust.errorLog(MODULE_NAME, "TestSubject trait not found in registry!")
    end
end

-- ==================
-- Trait Logic Hooks
-- ==================

ZomboLustCreation.onPlayerUpdate = function(player)
    if not player or player:isDead() then return end

    -- 1. Provocative & Promiscuous effects
    local traitProv = ZomboLustRegistries.Traits.Provocative
    -- B42: player:hasTrait() is now case-sensitive (lowercase 'h') and requires the Trait object.
    -- Using strings in hasTrait() often triggers "expected CharacterTrait but found string" warnings or fails.
    if traitProv and player:hasTrait(traitProv) then
        -- B42: Standard traits are accessed via CharacterTrait.NAME (all caps)
        local traitConspic = CharacterTrait.CONSPICUOUS
        if traitConspic and not player:hasTrait(traitConspic) then
            player:getCharacterTraits():add(traitConspic)
        end

        -- Sound detection increase: Small pulse of sound when moving
        if player:isMoving() and ZombRand(100) < 5 then
            addSound(player, player:getX(), player:getY(), player:getZ(), 8, 8) -- Radius 8
        end
    end

    -- 2. Traum trait effect
    local traitTraum = ZomboLustRegistries.Traits.Traumatized
    -- Declare traitDpress here as it is required for the Traumatized immunity check below
    local traitDpress = ZomboLustRegistries.Traits.Dpress

    if traitTraum and player:hasTrait(traitTraum) then
        -- Dpress characters are immune: remove it immediately and skip logic
        if traitDpress and player:hasTrait(traitDpress) then
            player:getCharacterTraits():remove(traitTraum)
        else
            -- Traumatized effect (inspired by ZomboWin)
            local stats = player:getStats()
            local unhappiness = stats:get(CharacterStat.UNHAPPINESS)
            local stress = stats:get(CharacterStat.STRESS)
            local drunk = stats:get(CharacterStat.INTOXICATION)

            if drunk < 10 then
                -- Rapid increase when sober
                if unhappiness < 60 then
                    stats:set(CharacterStat.UNHAPPINESS, unhappiness + 0.045)
                elseif unhappiness < 100 then
                    stats:set(CharacterStat.UNHAPPINESS, unhappiness + 0.0003)
                end

                if stress < 0.50 then
                    stats:set(CharacterStat.STRESS, stress + 0.00045)
                elseif stress < 1.0 then
                    stats:set(CharacterStat.STRESS, stress + 0.00002)
                end
            elseif drunk > 30 then
                -- Alcohol relief
                local reliefMult = (drunk > 50) and 2 or 1
                if unhappiness > 0 then
                    stats:set(CharacterStat.UNHAPPINESS, unhappiness - (0.06 * reliefMult))
                end
                if stress > 0 then
                    stats:set(CharacterStat.STRESS, stress - (0.0006 * reliefMult))
                end
            end
        end
    end

    -- 3. Dpress trait effect
    if traitDpress and player:hasTrait(traitDpress) then
        local stats = player:getStats()
        local unhappiness = stats:get(CharacterStat.UNHAPPINESS)
        if unhappiness < 58 then
            stats:set(CharacterStat.UNHAPPINESS, unhappiness + 0.005)
        end
    end

    -- 4. Test Subject (Cobaye) Safety & Sync Logic
    local traitTestSubject = ZomboLustRegistries.Traits.TestSubject
    if traitTestSubject and player:hasTrait(traitTestSubject) then
        local bodyDamage = player:getBodyDamage()
        if bodyDamage:isInfected() then
            bodyDamage:setInfected(false)
            bodyDamage:setInfectionTime(-1)
        end

        -- Sync jauge with ModData source of truth (fight engine drain)
        local modData = player:getModData()
        if modData.ZL_Infection then
            local infection = modData.ZL_Infection
            player:getStats():set(CharacterStat.ZOMBIE_INFECTION, infection)

            -- Pain system: Threshold 80% to 100%
            -- Must be in onPlayerUpdate because engine resets pain every tick if no injuries
            if infection > 80.0 then
                -- Scale pain from 0 (at 80%) to 100 (at 100%)
                local targetPain = ((infection - 80.0) / 20.0) * 100.0
                local stats = player:getStats()
                if stats:get(CharacterStat.PAIN) < targetPain then
                    stats:set(CharacterStat.PAIN, targetPain)

                    ZomboLust.debugLog(MODULE_NAME, "Infection Pain applied: %.2f (Infection: %.2f percent)", targetPain, infection)
                end
            end
        end
    end
end

-- ===================================
-- Character Creation & Initialization
-- ===================================

--- Assigns default traits if none from a specific category were selected.
--- @param playerIndex integer
--- @param player IsoPlayer
ZomboLustCreation.onCreatePlayer = function(playerIndex, player)
    if not player or player:isDead() then return end

    local traits = ZomboLustRegistries.Traits
    if not traits then return end

    -- Fornication Category: Ensure at least one trait is present
    local hasFornicationTrait = player:hasTrait(traits.AARP) or 
                               player:hasTrait(traits.InPrime) or 
                               player:hasTrait(traits.LowEffort) or 
                               player:hasTrait(traits.YoungBuck) or
                               player:hasTrait(traits.SpunkDefault)

    if not hasFornicationTrait then
        if traits.SpunkDefault then
            player:getCharacterTraits():add(traits.SpunkDefault)
            if dbg() then
                ZomboLust.debugLog(MODULE_NAME, "Assigned default SpunkDefault trait to player %s", player:getUsername())
            end
        end
    end

    -- Hygiene Category: Ensure at least one trait is present
    local hasHygieneTrait = player:hasTrait(traits.DislikesShowers) or 
                             player:hasTrait(traits.LovesClean) or 
                             player:hasTrait(traits.NeatTidy) or 
                             player:hasTrait(traits.Unkempt)

    if not hasHygieneTrait then
        if traits.NeatTidy then
            player:getCharacterTraits():add(traits.NeatTidy)
            if dbg() then
                ZomboLust.debugLog(MODULE_NAME, "Assigned default NeatTidy trait to player %s", player:getUsername())
            end
        end
    end

    -- SmokesAfter: automatically grants the vanilla Smoker trait
    if traits.SmokesAfter and player:hasTrait(traits.SmokesAfter) then
        local traitSmoker = CharacterTrait.get(ResourceLocation.of("Smoker"))
        if traitSmoker and not player:hasTrait(traitSmoker) then
            player:getCharacterTraits():add(traitSmoker)
            if dbg() then
                ZomboLust.debugLog(MODULE_NAME, "Granted Smoker trait to player %s (SmokesAfter)", player:getUsername())
            end
        end
    end
end

-- =================================
-- Hourly Update for Special Traits
-- =================================

ZomboLustCreation.everyHours = function()
    local player = getPlayer()
    if not player or player:isDead() then return end

    local traitTestSubject = ZomboLustRegistries.Traits.TestSubject
    if traitTestSubject and player:hasTrait(traitTestSubject) then
        local modData = player:getModData()
        local stats = player:getStats()

        -- Default to current stat if modData is missing for some reason
        local currentInfection = modData.ZL_Infection or stats:get(CharacterStat.ZOMBIE_INFECTION)

        -- Infection increase: 1.5 to 2.5 per hour
        -- This ensures ~48% increase per 24h.
        -- 1 act/day: Infection still rises slowly.
        -- 2 acts/day: Infection stabilizes around 45-50%.
        -- 3 acts/day: Required to reach the <40% bonus threshold.
        local increase = ZombRandFloat(1.5, 2.5)
        local newInfection = currentInfection + increase
        if newInfection > 100.0 then newInfection = 100.0 end

        -- Update source of truth
        modData.ZL_Infection = newInfection
        stats:set(CharacterStat.ZOMBIE_INFECTION, newInfection)

        ZomboLust.debugLog(MODULE_NAME, "Hourly Update - Infection: %.4f percent (+%.6f)", newInfection, increase)
    end
end

-- ================
-- Event Listeners
-- ================

Events.OnGameBoot.Add(ZomboLustCreation.DoProfessions)
Events.OnNewGame.Add(ZomboLustCreation.pStartGear)
Events.OnPlayerUpdate.Add(ZomboLustCreation.onPlayerUpdate)
Events.EveryHours.Add(ZomboLustCreation.everyHours)
Events.OnCreatePlayer.Add(ZomboLustCreation.onCreatePlayer)
