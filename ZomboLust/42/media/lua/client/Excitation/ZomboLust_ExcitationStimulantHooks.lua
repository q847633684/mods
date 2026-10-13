-- File: ZomboLust/42/media/lua/client/Excitation/ZomboLust_ExcitationStimulantHooks.lua
-- Detects stimulant (Coffee, Vitamins, Caffeine Pills, Tea) and inhibitor (Beta-blockers, Coffee Liqueur)
-- consumption by monkey-patching the four vanilla actions that can produce it,
-- and feeds the result into the Excitation system's ZL_StimulantTimer ModData.
-- Simulation lives in ZomboLust_ExcitationSystem.lua; UI lives in ZomboLust_ExcitationUI.lua.
-- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_ExcitationStimulantHooks.lua loaded")

-- =============
-- Dependencies
-- =============
require "Excitation/ZomboLust_ExcitationSystem"
require "TimedActions/ISEatFoodAction"
require "TimedActions/ISTakePillAction"
require "TimedActions/ISDrinkFluidAction"
require "TimedActions/ISDrinkFromBottle"

-- Module name for logging
--- @type string
local MODULE_NAME = "ExcitationStimulants"

--- Detects stimulant/inhibitor items being consumed and updates ZL_StimulantTimer accordingly.
--- Hooked into 4 different vanilla TimedActions below since eating, taking a pill, and drinking
--- (both the B42 fluid system and the legacy bottle system) are all separate action classes.
--- @param character IsoPlayer
--- @param item InventoryItem
local function onEatStimulant(character, item)
    if not character or not instanceof(character, "IsoPlayer") then return end
    if not item then return end

    local fullType = item:getFullType()
    local modData = character:getModData()

    -- Icon logic (stripping "Item_" prefix from icon name)
    local icon = item:getIcon()
    local iconName = icon and icon:getName() or ""
    local imgTag = ""
    if iconName ~= "" and string.find(iconName, "Item_") then
        imgTag = "[img=" .. string.sub(iconName, 6) .. "]"
    end

    -- Stimulants (Vitamins, Coffee, Tea, Caffeine Pills)
    -- getFoodType() only exists on Food, not the generic InventoryItem type of the item param above,
    -- hence the isFood() guard and the cast (same convention as the Clothing cast in hasExcitationDefense, ZomboLust_ExcitationSystem.lua).
    local isStimulantFood = false
    if item:isFood() then
        local foodType = (item --[[@as Food]]):getFoodType()
        isStimulantFood = foodType == "Coffee" or foodType == "Tea"
    end

    if fullType == "Base.PillsVitamins" or fullType == "Base.Coffee2" or fullType == "Base.CaffeinePills" or fullType == "Base.Teabag2" or isStimulantFood then
        modData.ZL_StimulantTimer = ZomboLust_ExcitationSystem.StimulantDuration

        -- Green (0.0, 1.0, 0.0)
        character:addLineChatElement(imgTag .. "    " .. getText("IGUI_ZomboLust_Halo_Stimulated"),
            0.0, 1.0, 0.0, UIFont.Dialogue, 30.0, "default", true, true, true, false, false, true)

        ZomboLust.debugLog(MODULE_NAME, "Stimulant consumed: %s | Effect duration set to %d minutes", fullType, ZomboLust_ExcitationSystem.StimulantDuration)

    -- Inhibitors (Beta-blockers, Coffee Liqueur)
    elseif fullType == "Base.PillsBeta" or fullType == "Base.CoffeeLiquer" or fullType == "Base.CoffeeLiqueur" then
        -- Red (1.0, 0.3, 0.3)
        character:addLineChatElement(imgTag .. "    " .. getText("IGUI_ZomboLust_Halo_Inhibited"),
            1.0, 0.3, 0.3, UIFont.Dialogue, 30.0, "default", true, true, true, false, false, true)

        ZomboLust.debugLog(MODULE_NAME, "Inhibitor consumed: %s", fullType)
    end
end

-- Hook into ISEatFoodAction to detect eating coffee
local original_ISEatFoodAction_perform = ISEatFoodAction.perform
function ISEatFoodAction:perform()
    onEatStimulant(self.character, self.item)
    original_ISEatFoodAction_perform(self)
end

-- Hook into ISTakePillAction to detect taking vitamins
local original_ISTakePillAction_perform = ISTakePillAction.perform
function ISTakePillAction:perform()
    onEatStimulant(self.character, self.item)
    original_ISTakePillAction_perform(self)
end

-- Hook into ISDrinkFluidAction to detect drinking liqueur (B42 Fluid system)
local original_ISDrinkFluidAction_perform = ISDrinkFluidAction.perform
function ISDrinkFluidAction:perform()
    onEatStimulant(self.character, self.item)
    original_ISDrinkFluidAction_perform(self)
end

-- Hook into ISDrinkFromBottle to detect drinking liqueur (Legacy/Bottle system)
local original_ISDrinkFromBottle_perform = ISDrinkFromBottle.perform
function ISDrinkFromBottle:perform()
    onEatStimulant(self.character, self.item)
    original_ISDrinkFromBottle_perform(self)
end

print("[ZomboLust] Excitation Stimulant Hooks Initialized")
