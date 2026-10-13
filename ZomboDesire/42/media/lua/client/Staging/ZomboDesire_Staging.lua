--- File: ZomboDesire/42/media/lua/client/Staging/ZomboDesire_Staging.lua
--- Staging everything (ZomboDesire framework)
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_Staging.lua loaded")

-- =============
-- Dependencies
-- =============
--- @class (partial) ZomboDesire_Staging
ZomboDesire_Staging = ZomboDesire_Staging or {}
require "ZomboDesire_Main"             -- handles all flags and debug functions
require "ZomboDesire_AnimationHandler" -- manages specific animations (public and adult)
require "ZomboDesire/ZomboDesire_Init" -- ensure AnimationConfigs loaded
require "ZomboDesire_Utils"            -- utilities for player control management
require "ZomboDesire_Cleanup"          -- cleanup functions for restoring world state

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local floor    = math.floor
local max      = math.max
local abs      = math.abs
local tonumber = tonumber
local tostring = tostring
local ipairs   = ipairs
local pairs    = pairs
local insert   = table.insert
local concat   = table.concat
local newarray = table.newarray
local gmatch   = string.gmatch
local format   = string.format

--- Module name for logging
--- @type string
local MODULE_NAME = "Staging"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboDesire.isDebug in ZomboDesire_Main.lua).
--- Calls with cheap/no arguments use ZomboDesire.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboDesire.isDebug(MODULE_NAME)
end

-- ==================
-- Utility functions
-- ==================

--- Utility function to ensure correct ID display in debug logs
--- @param zombie IsoGameCharacter -- The zombie entity whose ID will be displayed
--- @return string -- A formatted string displaying the zombie's ID
local function getZombieInfoString(zombie)
    if not zombie then return "nil zombie" end
    local id = zombie:getID() or "unknown"
    local persistentID = zombie:getPersistentOutfitID() or 0
    return format("Zombie ID -> %d (persistentID = %d)", id, persistentID)
end

-- ======================================
-- Functions preparation of protagonists
-- ======================================

--- Updates the character interaction state
--- @param player IsoPlayer -- player to update
--- @param zombHuman IsoGameCharacter -- ZombHuman to update
local function updateInteractionState(player, zombHuman)
    player:setVariable("InteractingZombHuman", true)
    zombHuman:setVariable("InteractingPlayer", true)
    ZomboDesire.debugLog(MODULE_NAME, "Updated interaction state for player and ZombHuman")
end

--- Handles player items based on ZomboLust difficulty settings (Unequip/Drop/Damage)
--- @param player IsoPlayer -- The player whose items will be handled
function ZomboDesire_Staging.handlePlayerItems(player)
    if not player then return end

    ---@type integer
    local difficulty = 1 -- Default to Casual (1). ZomboDesire alone has no difficulty levels, so we treat it as Casual.
    if ZomboDesire.IsZomboLustActive then
        local modOptions = PZAPI.ModOptions:getOptions("ZomboLust")
        if modOptions then
            local option = modOptions:getOption("difficulty")
            if option then
                ---@cast option any
                difficulty = floor(tonumber(option:getValue()) or 1)
            end
        end
    end

    local primary = player:getPrimaryHandItem()
    local secondary = player:getSecondaryHandItem()

    -- Create a list of unique items to process (avoids double-processing two-handed weapons)
    local itemsToProcess = {}
    if primary then itemsToProcess[primary] = true end
    if secondary then itemsToProcess[secondary] = true end

    ZomboDesire.debugLog(MODULE_NAME, "Handling player items (Difficulty index: %d)", difficulty)

    for item, _ in pairs(itemsToProcess) do
        ---@cast item InventoryItem
        local itemType = item:getType()
        -- Difficulty: 1 = Casual, 2 = Normal, 3 = Vicious
        if difficulty == 1 then
            -- Casual: Just unequip (stays in inventory)
            ZomboDesire.debugLog(MODULE_NAME, "Unequipping item %s (Casual)", itemType)
            -- No action needed here for inventory, we'll set hands to nil and call sync functions later
        else
            -- Normal (2) or Vicious (3): Drop item on ground

            -- Icon and Name for HaloText
            local icon = item:getIcon()
            local iconName = icon and icon:getName() or ""
            local imgTag = ""
            if iconName ~= "" and string.find(iconName, "Item_") then
                imgTag = "[img=" .. string.sub(iconName, 6) .. "]"
            end
            local itemName = item:getDisplayName()

            if difficulty == 3 and instanceof(item, "HandWeapon") then
                -- Vicious: Apply random condition loss (10-50% of current condition)
                ---@cast item HandWeapon
                local currentCond = item:getCondition()
                local lossPercent = 10 + ZombRand(41) -- 10% to 50%
                local loss = floor(currentCond * (lossPercent / 100))
                local finalCond = max(0, currentCond - loss)
                item:setCondition(finalCond, false)

                -- Display damaged text
                player:addLineChatElement(imgTag .. "    " .. getText("IGUI_ZomboDesire_Halo_ItemDamaged") .. " " .. itemName, 
                    1.0, 0.3, 0.3, UIFont.Dialogue, 30.0, "default", true, true, true, false, false, true)

                ZomboDesire.debugLog(MODULE_NAME, "Vicious mode: Item %s damaged by %d%% (%d -> %d)",
                    itemType, lossPercent, currentCond, finalCond)
            end

            -- Drop item on current square
            local square = player:getCurrentSquare()
            if square then
                -- Display lost text
                player:addLineChatElement(imgTag .. "    " .. getText("IGUI_ZomboDesire_Halo_ItemLost") .. " " .. itemName, 
                    1.0, 0.3, 0.3, UIFont.Dialogue, 30.0, "default", true, true, true, false, false, true)

                ZomboDesire.debugLog(MODULE_NAME, "Dropping item %s on ground", itemType)
                -- Small random offset for natural placement
                local offX = ZombRand(100) / 100.0
                local offY = ZombRand(100) / 100.0
                square:AddWorldInventoryItem(item, offX, offY, 0, true)
                player:getInventory():Remove(item)
            end
        end
    end

    -- Real unequip logic to ensure items are no longer considered "in hand"
    ---@diagnostic disable-next-line: param-type-mismatch
    player:setPrimaryHandItem(nil)
    ---@diagnostic disable-next-line: param-type-mismatch
    player:setSecondaryHandItem(nil)

    -- Force inventory UI refresh and sync
    if player:getInventory() then
        player:getInventory():setDrawDirty(true)
    end

    -- This global call updates the inventory pane if it's open
    ---@diagnostic disable-next-line: undefined-global
    if ISInventoryPage and ISInventoryPage.dirtyUI then
        ---@diagnostic disable-next-line: undefined-global
        ISInventoryPage.dirtyUI()
    end
end

--- Select a random animation from the available configurations
--- @param requiredTags table -- Tags that the animation must have
--- @param forceModTag string|nil -- Optional tag to force ("Desire" or "Lust"). If provided, overrides default behavior
--- @return string|nil -- Name of the selected animation or nil if no animation is available
local function selectRandomAnimation(requiredTags, forceModTag)
    local configs = ZomboDesire.AnimationConfigs or {}
    ---@cast configs table
    local validAnims = newarray()
    requiredTags = requiredTags or {}

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "forceModTag value INSIDE selectRandomAnimation function -> %s", tostring(forceModTag or "nil"))
    end

    -- If forceModTag is provided, use it instead of default "Desire" tag
    local allowedForceGroup = {}
    if forceModTag then
        local filteredTags = newarray()
        for _, tag in ipairs(requiredTags) do
            if tag ~= "Desire" and tag ~= "Lust" and tag ~= forceModTag then
                insert(filteredTags, tag)
            end
        end
        requiredTags = filteredTags

        -- Split by comma to support OR logic for sub-tags
        local tags = {}
        for tag in gmatch(forceModTag, "([^,]+)") do
            insert(tags, tag)
        end

        if #tags > 1 then
            insert(requiredTags, tags[1])
            for i = 2, #tags do
                insert(allowedForceGroup, tags[i])
            end
        else
            insert(requiredTags, forceModTag)
        end
    end

    -- If relative position is set, add it to required tags
    if ZomboDesire.relativePosition then
        insert(requiredTags, ZomboDesire.relativePosition)
    end

    -- If zombie gender tag is set, add it to required tags
    if ZomboDesire.zombieGenderTag then
        insert(requiredTags, ZomboDesire.zombieGenderTag)
    end

    -- If object interaction tag is set, add it to required tags
    if ZomboDesire.objectInteractionTag then
        insert(requiredTags, ZomboDesire.objectInteractionTag)
    end

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Selecting animation with tags -> %s", concat(requiredTags, ", "))
    end

    -- Filter animations by tags
    for name, config in pairs(configs) do
        local hasAllTags = true
        local hasUnwantedObjectTag = false
        local configTags = config.tags

        -- Check if animation has all required tags
        if configTags then
            for _, requiredTag in ipairs(requiredTags) do
                local hasTag = false
                for _, tag in ipairs(configTags) do
                    if tag == requiredTag then
                        hasTag = true
                        break
                    end
                end

                if not hasTag then
                    hasAllTags = false
                    break
                end
            end
        else
            if #requiredTags > 0 then
                hasAllTags = false
            end
        end

        -- Check if animation has any object interaction tag when none is required
        if hasAllTags and not ZomboDesire.objectInteractionTag and configTags then
            for _, tag in ipairs(configTags) do
                if tag == "Standing against" or tag == "Leaning over" or 
                   tag == "Sitting on" or tag == "Lying on" or tag == "On stairs" then
                    hasUnwantedObjectTag = true
                    break
                end
            end
        end

        -- Matches force group (OR logic)
        local matchesForceGroup = true
        if hasAllTags and not hasUnwantedObjectTag and #allowedForceGroup > 0 then
            matchesForceGroup = false
            if configTags then
                for _, forceTag in ipairs(allowedForceGroup) do
                    for _, tag in ipairs(configTags) do
                        if tag == forceTag then
                            matchesForceGroup = true
                            break
                        end
                    end
                    if matchesForceGroup then break end
                end
            end
        end

        if hasAllTags and matchesForceGroup and not hasUnwantedObjectTag then
            insert(validAnims, name)
        end
    end

    ZomboDesire.debugLog(MODULE_NAME, "%d valid animations found matching tags", #validAnims)

    if #validAnims == 0 then
        ZomboDesire.errorLog(MODULE_NAME, "No animation configs available matching required tags")
        return nil
    end

    local animName = validAnims[ZombRand(#validAnims) + 1]
    ZomboDesire.debugLog(MODULE_NAME, "Selected animation '%s'", animName)
    return animName
end

--- Plays the animation selected via AnimationHandler
--- @param player IsoPlayer -- player participating in the animation
--- @param zombHuman IsoGameCharacter -- ZombHuman participating in the animation
--- @param animName string -- Name of the animation to play
local function playSelectedAnimation(player, zombHuman, animName)
    if not animName then
        ZomboDesire.errorLog(MODULE_NAME, "Unable to play animation - invalid animation name")
        return false
    end

    ZomboDesire.debugLog(MODULE_NAME, "Animation selected AFTER selectRandomAnimation -> %s", animName)
    ZomboDesire.debugLog(MODULE_NAME, "Invoking AnimationHandler for anim -> %s", animName)
    ZomboDesire_AnimationHandler.playAnimation(player, zombHuman, animName)
    return true
end

--- Main function for preparing protagonists for a scene
--- @param player IsoPlayer -- player participating in the scene
--- @param zombHuman IsoGameCharacter -- ZombHuman participating in the scene
--- @param forceModTag string|nil -- Optional tag to force ("Desire" or "Lust")
--- @return boolean -- true if preparation was successful
local function preparationProtagonists(player, zombHuman, forceModTag)
    if not player or not zombHuman then
        ZomboDesire.errorLog(MODULE_NAME, "Invalid parameters for preparationProtagonists")
        return false
    end

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "forceModTag value received in preparationProtagonists -> %s", tostring(forceModTag or "nil"))
    end

    -- Step 1 : Update interaction state
    updateInteractionState(player, zombHuman)

    -- Step 2 : Select a random animation
    local requiredTags = {forceModTag or "Desire"}
    local animName = selectRandomAnimation(requiredTags, forceModTag)
    if not animName then
        return false
    end

    -- Step 3 : Handle player items (Unequip/Drop/Damage)
    ZomboDesire_Staging.handlePlayerItems(player)

    -- Step 4 : Provide penis item if needed (ZomboLust integration)
    if ZomboDesire.IsZomboLustActive and ZomboLust_PenisManager then
        ---@type any
        local animConfig = ZomboDesire.AnimationConfigs[animName]
        if animConfig and animConfig.needsPenis and animConfig.actors then
            ZomboDesire.debugLog(MODULE_NAME, "Providing penis for animation '%s' (type %s)", animName, animConfig.needsPenis)

            for _, actor in ipairs(animConfig.actors) do
                local characterKey = actor.character

                if characterKey == "Player" and not player:isFemale() then
                    ZomboDesire.debugLog(MODULE_NAME, "Equipping %s penis to Player", animConfig.needsPenis)
                    ZomboLust_PenisManager.equipPenisForPlayer(player, animConfig.needsPenis)
                elseif characterKey == "ZombHuman0" and not zombHuman:isFemale() then
                    ZomboDesire.debugLog(MODULE_NAME, "Equipping %s penis to ZombHuman0", animConfig.needsPenis)
                    ZomboLust_PenisManager.equipPenisForZombHuman(zombHuman, animConfig.needsPenis)
                end
            end
        end
    end

    -- Step 5 : Play selected animation
    playSelectedAnimation(player, zombHuman, animName)

    return true
end

-- ==================================
-- Validation and recovery functions
-- ==================================

--- Check if ZombHumanization is complete
--- @return boolean -- true if ZombHumanization is completed
local function checkZombHumanizeCompleted()
    if not ZomboDesire.ZombHumanizeCompleted then
        ZomboDesire.errorLog(MODULE_NAME, "ZombHumanize not completed yet!")
        return false
    end

    -- Reset the flag for the next iteration
    ZomboDesire.ZombHumanizeCompleted = false
    ZomboDesire.debugLog(MODULE_NAME, "ZombHumanization completed, proceeding to next steps")
    return true
end

--- Check if protagonists are valid for scene
--- @param player IsoPlayer -- player instance
--- @param zombHuman IsoGameCharacter -- ZombHuman instance
--- @return boolean -- true if both protagonists are valid
local function validateProtagonists(player, zombHuman)
    if not player or not zombHuman then
        ZomboDesire.errorLog(MODULE_NAME, "Aborting startScene due to missing parameters.")
        return false
    end

    -- Position validation
    local currentPlayerX = player:getX()
    local currentPlayerY = player:getY()
    local currentZombHumanX = zombHuman:getX()
    local currentZombHumanY = zombHuman:getY()

    if ZomboDesire.animationStartPositions.playerX and ZomboDesire.animationStartPositions.playerY and 
       ZomboDesire.animationStartPositions.zombieX and ZomboDesire.animationStartPositions.zombieY then
        local playerDeltaX = abs(currentPlayerX - ZomboDesire.animationStartPositions.playerX)
        local playerDeltaY = abs(currentPlayerY - ZomboDesire.animationStartPositions.playerY)
        local zombHumanDeltaX = abs(currentZombHumanX - ZomboDesire.animationStartPositions.zombieX)
        local zombHumanDeltaY = abs(currentZombHumanY - ZomboDesire.animationStartPositions.zombieY)

        local POSITION_TOLERANCE = 1.20
        if (playerDeltaX > POSITION_TOLERANCE or playerDeltaY > POSITION_TOLERANCE) or
           (zombHumanDeltaX > POSITION_TOLERANCE or zombHumanDeltaY > POSITION_TOLERANCE) then

            ZomboDesire.warningLog(MODULE_NAME, "Protagonist moved during setup - Aborting")
            ZomboDesire.debugLog(MODULE_NAME, "Player: Start(%.3f, %.3f) Current(%.3f, %.3f) Delta(%.3f, %.3f)",
                ZomboDesire.animationStartPositions.playerX, ZomboDesire.animationStartPositions.playerY,
                currentPlayerX, currentPlayerY, playerDeltaX, playerDeltaY)
            ZomboDesire.debugLog(MODULE_NAME, "ZombHuman: Start(%.3f, %.3f) Current(%.3f, %.3f) Delta(%.3f, %.3f)",
                ZomboDesire.animationStartPositions.zombieX, ZomboDesire.animationStartPositions.zombieY,
                currentZombHumanX, currentZombHumanY, zombHumanDeltaX, zombHumanDeltaY)

            ZomboDesire_Utils.sayAnimationInterrupted(player)
            ZomboDesire_Cleanup.restoreState(player)
            return false
        end
    end

    return true
end

--- Manages setting up a scene between a player and a ZombHuman
--- @param player IsoPlayer -- The player who triggered the command
--- @param zombHuman IsoGameCharacter -- The ZombHuman involved
--- @param forceModTag string|nil -- Optional tag to force
function ZomboDesire_Staging.startScene(player, zombHuman, forceModTag)
    ZomboDesire.debugLog(MODULE_NAME, "startScene started")

    -- Step 1 : Check if ZombHumanization is done
    if not checkZombHumanizeCompleted() then
        return
    end

    -- Step 2 : Check if the protagonists are valid
    if not validateProtagonists(player, zombHuman) then
        return
    end

    -- Step 3 : Prepare and launch scene
    preparationProtagonists(player, zombHuman, forceModTag)
end
