--- Animation Event Handler: Apply Traumatized Trait (ZomboLust)
--- This function is called via XML FrameEvents at a specific time (e.g. 0.800)
--- It applies the Traumatized trait if conditions are met, for a duration
--- that varies with difficulty (1/3/7 days for Casual/Normal/Vicious).
--- @author BlaBla 2026

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Utils"

-- Module name for logging
--- @type string
local MODULE_NAME = "ApplyTrauma"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

-- Deferred action helper, centralized in ZomboDesire_Utils.lua
local createDelayedAction = ZomboDesire_Utils.createDelayedAction

--- Helper to get current difficulty level
--- @return number -- 1: Casual, 2: Normal, 3: Vicious
local function getDifficultyLevel()
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

--- Trauma trait duration (in days) per difficulty level.
--- Shared with the random negative traits applied by ZomboLust_MoraleSystem.ApplyNegativeTrait,
--- since both expire through the same ZL_Traumas/CheckTraumaExpiry mechanism.
--- @type table<number, number>
local TRAUMA_DURATION_DAYS = { [1] = 1, [2] = 3, [3] = 7 }

--- Helper to get the trauma trait duration (in days) for the current difficulty
--- @return number
local function getTraumaDurationDays()
    return TRAUMA_DURATION_DAYS[getDifficultyLevel()] or TRAUMA_DURATION_DAYS[1]
end

--- Deletes the ZombHuman entity and spawns a docile lamb in its place (ZomboLust "Pacify" trait)
--- Only reached from a successful animation completion (this file is only wired to the
--- ZLApplyTrauma FrameEvent in the "End"/"End_Vag" animation XML categories).
--- @param zombie IsoZombie -- The ZombHuman entity to remove and replace
local function transformZombieIntoLamb(zombie)
    if not zombie then
        ZomboLust.errorLog(MODULE_NAME, "Pacify: zombie reference missing for lamb transformation")
        return
    end

    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "Pacify: replacing zombie %d with a lamb", zombie:getID())
    end

    local x = math.floor(zombie:getX())
    local y = math.floor(zombie:getY())
    local z = math.floor(zombie:getZ())

    -- Remove the ZombHuman entity from the world entirely
    zombie:removeFromWorld()
    zombie:removeFromSquare()

    -- Clear the global reference: ZomboDesire_Cleanup.restoreState (which runs later, at true animation end).
    -- Checks this to know the zombie has already been dealt with.
    if ZomboDesire then
        ZomboDesire.originalZombie = nil
    end

    -- Spawn a lamb at the zombie's former position
    ---@diagnostic disable-next-line: undefined-field
    local animalDef = AnimalDefinitions.getDef("lamb")
    if not animalDef then
        ZomboLust.errorLog(MODULE_NAME, "Pacify: failed to get 'lamb' animal definition")
        return
    end

    local breedObject = animalDef:getRandomBreed()
    local lamb = addAnimal(getCell(), x, y, z, "lamb", breedObject, false)
    if not lamb then
        ZomboLust.errorLog(MODULE_NAME, "Pacify: failed to spawn lamb")
        return
    end

    lamb:addToWorld()

    ZomboLust.debugLog(MODULE_NAME, "Pacify: lamb spawned at (%d, %d, %d)", x, y, z)
end

--- Delay (in ticks) the zombie partner stays visible as a skeleton before being killed (ZomboLust "Succubus" trait).
--- PZ runs at ~120 ticks/second, so 120 ticks ~= 1 second.
--- @type number
local SUCCUBUS_SKELETON_DELAY_TICKS = 120

--- Turns the zombie partner into a skeleton (ZomboLust "Succubus" trait, pre-kill step).
--- Only reached from a successful animation completion, see transformZombieIntoLamb() above.
--- @param zombie IsoZombie -- The zombie to turn into a skeleton
local function transformZombieIntoSkeleton(zombie)
    if not zombie then
        ZomboLust.errorLog(MODULE_NAME, "Succubus: zombie reference missing for skeleton transformation")
        return
    end

    if zombie:isSkeleton() then return end

    -- Clear live-zombie outfit visuals too, not only wornItems
    local itemVisuals = zombie:getItemVisuals()
    if itemVisuals then
        itemVisuals:clear()
    end

    zombie:clearWornItems()
    zombie:clearAttachedItems()

    local visual = zombie:getHumanVisual()
    if visual then
        -- Important: a named human skin overrides skinTextureIndex in Java, so it must be cleared first
        ---@diagnostic disable-next-line: param-type-mismatch
        visual:setSkinTextureName(nil)

        -- Vanilla skeleton corpses use texture index 1 or 2
        visual:setSkinTextureIndex(math.floor(ZombRand(1, 3)))

        visual:setHairModel("")
        visual:setBeardModel("")

        local bodyVisuals = visual:getBodyVisuals()
        if bodyVisuals then
            bodyVisuals:clear()
        end
    end

    zombie:setSkeleton(true)
    zombie:onWornItemsChanged()
    zombie:resetModelNextFrame()

    -- Release ZomboDesire's reference now rather than at the delayed kill below:
    -- this zombie's fate is already sealed, and ZomboDesire_Cleanup.restoreState (running shortly after, at
    -- true animation end) must see it as already handled - otherwise it would Zombify() it,
    -- reviving it as a normal AI-controlled zombie for the rest of the skeleton delay.
    if ZomboDesire then
        ZomboDesire.originalZombie = nil
    end

    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "Succubus: zombie %d transformed into a skeleton", zombie:getID())
    end
end

--- Picks one random scratched body part on the player, if any.
--- @param player IsoPlayer
--- @return BodyPart|nil part
local function pickSuccubusHealTarget(player)
    local bodyParts = player:getBodyDamage():getBodyParts()

    ---@type BodyPart[]
    local candidates = {}

    for i = 0, bodyParts:size() - 1 do
        local part = bodyParts:get(i)
        if part and part:scratched() then
            candidates[#candidates + 1] = part
        end
    end

    if #candidates == 0 then return nil end

    return candidates[ZombRand(#candidates) + 1]
end

--- Succube "life drain": heals one random scratch on the player - flavor for "the succube absorbs the zombie's life force".
--- Does nothing if the player has no active scratch.
--- @param player IsoPlayer
local function healSuccubusPlayer(player)
    if not player then return end

    local part = pickSuccubusHealTarget(player)
    if not part then return end

    part:setScratchTime(0)
    part:setScratched(false, true)

    -- Halo feedback: green text with an upward arrow
    HaloTextHelper.addTextWithArrow(player, getText("IGUI_ZomboLust_HaloText_ScratchHealed"), true, HaloTextHelper.getColorGreen())

    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "Succubus: life drain healed player's %s (scratch)", tostring(part:getType()))
    end
end

--- Instantly kills the zombie partner (ZomboLust "Succubus" trait).
--- Mirrors a stealth backstab: no player animation is played, the zombie simply dies in a single hit.
--- Only reached from a successful animation completion, see transformZombieIntoLamb() above.
--- Expects transformZombieIntoSkeleton() to have already run (and cleared ZomboDesire.originalZombie).
--- @param zombie IsoZombie -- The zombie to kill
local function killZombiePartner(zombie)
    if not zombie then
        ZomboLust.errorLog(MODULE_NAME, "Succubus: zombie reference missing for kill")
        return
    end

    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "Succubus: killing zombie %d", zombie:getID())
    end

    -- Stop the zombie's current sounds so the kill stays as quiet as possible
    local emitter = zombie:getEmitter()
    if emitter then
        emitter:stopAll()
    end

    -- Kill instantly, without gore (bGory=false)
    ---@diagnostic disable-next-line: param-type-mismatch
    zombie:Kill(nil, false)

    -- Clear the global reference: see transformZombieIntoLamb() above
    if ZomboDesire then
        ZomboDesire.originalZombie = nil
    end
end

--- Sound definitions for the Succubus post-kill laugh
--- Each entry bundles several clips (see ZomboLust_Kate_Laugh_Long.txt / _Short.txt) -
--- the engine already picks a random clip within a sound when playSound() is called,
--- so only the Long/Short choice needs to be made here
--- @type string[]
local SUCCUBUS_LAUGH_SOUNDS = { "KateLaughLong", "KateLaughShort" }

--- Delay (in ticks) before playing the Succubus laugh
--- @type number
local SUCCUBUS_LAUGH_DELAY_TICKS = 150

--- Plays a random victory laugh on the player after a Succubus kill
--- @param player IsoPlayer -- The player who should laugh
local function playSuccubusLaugh(player)
    if not player then return end

    local soundName = SUCCUBUS_LAUGH_SOUNDS[ZombRand(#SUCCUBUS_LAUGH_SOUNDS) + 1]
    local emitter = player:getEmitter()
    if emitter then
        ---@diagnostic disable-next-line: param-type-mismatch
        local soundID = emitter:playSound(soundName)

        -- Adjust volume and pitch based on gender (same treatment as ZomboLust_ExcitationSystem.updateBreathing)
        local pitch = player:isFemale() and 1.0 or 0.7
        if soundID ~= -1 then
            emitter:setVolume(soundID, 1.0)
            emitter:setPitch(soundID, pitch)
        end

        if dbg() then
            ZomboLust.debugLog(MODULE_NAME, "Succubus: playing laugh sound %s (soundID=%s)", soundName, tostring(soundID))
        end
    end
end

---@param action ISZomboDesireAnimationAction -- The animation action instance that triggered this event
---@param parameter string -- The event name passed by the animation system (unused)
---@return nil
return function(action, parameter)
    local player = action.character
    if not player or player:isZombie() then return end
    ---@cast player IsoPlayer

    -- Get the zombie from the action, or fall back to the current global zombie reference
    local zombie = action.zombHuman
    if not zombie and ZomboDesire_AnimationHandler then
        zombie = ZomboDesire_AnimationHandler.currentZombHuman
    end

    -- Difficulty check: Normal (2) or Vicious (3) required for hygiene and disease logic
    local difficulty = getDifficultyLevel()
    if difficulty > 1 then
        -- We require the hygiene module here
        ---@type ZomboLust_HygieneDisease
        local ZomboLust_Hygiene = require "ZomboLust_HygieneDisease"
        if ZomboLust_Hygiene and ZomboLust_Hygiene.rollForDisease then
            ZomboLust_Hygiene.rollForDisease(player, zombie)
        end
    end

    -- ZomboLust "Pacify"/"Succubus" traits: decide the zombie partner's fate on a successful completion.
    -- Runs unconditionally, before the Traumatized/Dpress/Nymphomaniac checks
    -- below (which can `return` early), since it must not be skipped by those.
    if zombie and ZomboLustRegistries and ZomboLustRegistries.Traits then
        local isPacifyActive = ZomboLustRegistries.Traits.Pacify and player:hasTrait(ZomboLustRegistries.Traits.Pacify)
        local isSuccubusActive = ZomboLustRegistries.Traits.Succubus and player:hasTrait(ZomboLustRegistries.Traits.Succubus)

        if isPacifyActive then
            transformZombieIntoLamb(zombie)
        elseif isSuccubusActive then
            -- Succube: drain the zombie's flesh into a skeleton first, then let the kill land
            -- after a short delay so the transformation is visible before it collapses
            transformZombieIntoSkeleton(zombie)

            -- Life drain: the absorbed life force heals a scratch on the player
            healSuccubusPlayer(player)

            createDelayedAction(SUCCUBUS_SKELETON_DELAY_TICKS, function()
                killZombiePartner(zombie)

                -- Delayed so the laugh isn't drowned out by the tail-end sounds of the animation
                createDelayedAction(SUCCUBUS_LAUGH_DELAY_TICKS, function()
                    if player and not player:isDead() then
                        playSuccubusLaugh(player)
                    end
                end)
            end)
        end
    end

    -- ZomboLust "Misandrist"/"Misogynist" traits: one-off Stress penalty based on the zombie partner's actual gender (not the player's).
    -- Runs unconditionally, alongside the Pacify/Succubus block above, since it must apply regardless of Traumatized/Dpress immunity
    -- or the Nymphomaniac branch below (which can `return` early), and regardless of difficulty
    -- (Stress is never touched by the Morale mini-game system, unlike Unhappiness).
    -- Checking the partner's gender rather than assuming "player is female = male partner" keeps
    -- this correct once same-gender encounters become possible (future Lesbian/Gay sub-mods).
    -- NOTE: the matching Unhappiness penalty is NOT applied here - it's folded into the Morale
    -- mini-game's starting value instead (ZomboLust_MoraleBar:initialise() in ZomboLust_MoraleSystem.lua),
    -- so it correctly feeds both the final Unhappiness write and ApplyFinalPenalties' severity
    -- tiers (XP loss/item drop/negative trait) on Normal/Vicious, rather than being invisible to them.
    if zombie and ZomboLustRegistries and ZomboLustRegistries.Traits then
        local traitMisandrist = ZomboLustRegistries.Traits.Misandrist
        local traitMisogynist = ZomboLustRegistries.Traits.Misogynist
        local isMisandristActive = traitMisandrist and player:hasTrait(traitMisandrist) and not zombie:isFemale()
        local isMisogynistActive = traitMisogynist and player:hasTrait(traitMisogynist) and zombie:isFemale()

        if isMisandristActive or isMisogynistActive then
            local stats = player:getStats()
            local stressBump = isMisandristActive and ZomboLust_ExcitationSystem.MisandristStressBump or ZomboLust_ExcitationSystem.MisogynistStressBump

            stats:set(CharacterStat.STRESS, math.min(1.0, stats:get(CharacterStat.STRESS) + stressBump))

            ZomboLust.debugLog(MODULE_NAME, "%s: Stress +%.2f (partner gender: %s)",
                isMisandristActive and "Misandrist" or "Misogynist", stressBump, zombie:isFemale() and "F" or "M")
        end
    end

    local traitTraum = ZomboLustRegistries.Traits.Traumatized
    local traitDpress = ZomboLustRegistries.Traits.Dpress
    local traitNympho = ZomboLustRegistries.Traits.Nymphomaniac

    -- 0. Conditions check: No trauma if already traumatized or has Depression trait (immunity)
    if player:hasTrait(traitTraum) or (traitDpress and player:hasTrait(traitDpress)) then
        return
    end

    -- 1. Nymphomaniac: never traumatized, but gets an Endurance restore instead.
    -- Not a Boredom bump anymore: vanilla's Excitation->Intoxication coupling permanently
    -- neutralizes Boredom for this trait (pzwiki: "At 20% drunkenness, boredom decreases at 200%",
    -- and Nymphomaniac's incompressible Excitation floor keeps Intoxication permanently above that threshold).
    -- Endurance has no such documented interaction with Intoxication, so a plain one-off
    -- write is safe here - no reassert-loop countermeasure needed like Wimp/Masochist/Discomfort use.
    if traitNympho and player:hasTrait(traitNympho) then
        local stats = player:getStats()
        local currentEndurance = stats:get(CharacterStat.ENDURANCE)
        stats:set(CharacterStat.ENDURANCE, math.min(1.0, currentEndurance + ZomboLust_ExcitationSystem.NymphomaniacEnduranceRestore))

        ZomboLust.debugLog(MODULE_NAME, "Nymphomaniac: Traumatized immunity, Endurance +%.2f instead", ZomboLust_ExcitationSystem.NymphomaniacEnduranceRestore)
        return
    end

    -- 2. Add the trait
    player:getCharacterTraits():add(traitTraum)

    -- 3. Register expiry for the existing removal system (in ZomboLust_MoraleSystem.lua)
    -- Duration varies with difficulty: Casual 1 day, Normal 3 days, Vicious 7 days
    local currentDay = getGameTime():getDaysSurvived()
    local expiryDay = currentDay + getTraumaDurationDays()

    local modData = player:getModData()
    modData.ZL_Traumas = modData.ZL_Traumas or {}

    table.insert(modData.ZL_Traumas, {
        traitID = "ZomboLust:Traumatized", -- Full ID required for ResourceLocation in MoraleSystem
        expiryDay = expiryDay
    })

    -- 4. Visual feedback with a small delay (10 ticks)
    createDelayedAction(10, function()
        if not player or player:isDead() then return end

        -- Get the label for the Traumatized trait
        local traitDef = CharacterTraitDefinition.getCharacterTraitDefinition(traitTraum)
        local traitLabel = traitDef and traitDef:getLabel() or "Traumatized"

        -- Construct message: "Trauma: Traumatisée"
        local msg = getText("IGUI_ZomboLust_TraitTrauma") .. ": " .. traitLabel

        -- Display above character head with identical parameters to MoraleSystem's ApplyNegativeTrait
        player:addLineChatElement(msg, 1.0, 0.3, 0.3, UIFont.Dialogue, 30.0, "default", true, true, true, false, false, true)

        -- Optional Debug
        ZomboLust.debugLog(MODULE_NAME, "Trauma applied via Animation Event: %s (Expires day %d)", traitLabel, expiryDay)
    end)

    -- 5. Hope Feedback (delayed speech)
    -- Using a timed callback to show the hope message after the initial shock (1800 ticks = ~30s)
    createDelayedAction(1800, function()
        if player and not player:isDead() then
            player:addLineChatElement(getText("IGUI_ZomboLust_TraitHope"), 0.5, 0.7, 1.0, UIFont.Dialogue, 30.0, "default", true, true, true, false, false, true)
        end
    end)
end
