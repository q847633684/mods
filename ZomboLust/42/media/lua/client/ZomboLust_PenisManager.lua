--- File: ZomboLust/42/media/lua/client/ZomboLust_PenisManager.lua
--- Manager for equipping and removing penis items during animations
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_PenisManager.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"

--- Module name for logging
--- @type string
local MODULE_NAME = "PenisManager"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

--- Main module table for penis management operations
--- @class ZomboLust_PenisManager
ZomboLust_PenisManager = ZomboLust_PenisManager or {}

--- Mapping of penis types to their full item type IDs
--- @type table<string, string>
local PENIS_TYPES = {
    human = "ZomboLust.Penis_Light",
    dog = "ZomboLust.PenisDog",
    horse = "ZomboLust.PenisHorse",
    alien = "ZomboLust.PenisAlien",
    tentacle = "ZomboLust.PenisTentacle",
}

-- =============================================================================================
-- NOTE ON 3D MODELS (BUILD 42 ENGINE BEHAVIOR):
-- For equipped items, the game engine seems to ignore the 'mesh' directive in model scripts.
-- It attempts to load a .fbx file that EXACTLY matches the model name (e.g., Penis_Pale.fbx).
-- To fix the "Failed to load asset" error and ensure visibility, we use 5 identical .fbx files
-- renamed to match each skin variant model name.
-- Yeah, I know... facepalm.
-- =============================================================================================

--- Mapping of skin texture indices to item suffixes
--- @type table<integer, string>
local SKIN_ITEM_SUFFIX = {
    [0] = "_Light",
    [1] = "_Pale",
    [2] = "_Medium",
    [3] = "_Brown",
    [4] = "_Dark",
}

--- Gets the full item type ID for a given penis type
--- @param character IsoGameCharacter -- The character to check for skin color
--- @param penisType string -- The penis type to look up (e.g., "human", "dog")
--- @return string -- The full item type ID, defaults to human penis if type not found
local function getPenisFullType(character, penisType)
    if penisType == "human" and character then
        local suffix = "_Light" -- Default
        ---@cast character IsoZombie|IsoPlayer
        if character.getHumanVisual then
            local hVisual = character:getHumanVisual()
            if hVisual then
                local skinIndex = hVisual:getSkinTextureIndex()
                suffix = SKIN_ITEM_SUFFIX[skinIndex] or "_Light"
            end
        end
        return "ZomboLust.Penis" .. suffix
    end
    return PENIS_TYPES[penisType] or PENIS_TYPES["human"]
end

--- Creates a penis item and adds it to character's inventory
--- @param character IsoGameCharacter -- The character to give the penis to
--- @param penisType string -- The type of penis to create
--- @return InventoryItem|nil -- The created penis item, or nil if creation failed
local function givePenisToCharacter(character, penisType)
    if not character then return nil end

    local penisFullType = getPenisFullType(character, penisType)
    local inv = character:getInventory()
    if not inv then
        ZomboLust.errorLog(MODULE_NAME, "Character has no inventory!")
        return nil
    end

    -- Use instanceItem and addItem (lowercase)
    -- AddItem(string) seems to throw InvocationTargetException for zombies on client
    ZomboLust.debugLog(MODULE_NAME, "Attempting to instanceItem: %s", tostring(penisFullType))

    local penis = nil
    local success, err = pcall(function()
        penis = instanceItem(penisFullType)
    end)

    if not success or not penis then
        -- No usable fallback exists: InventoryItemFactory is a Java-only class,
        -- never exposed to Lua as a global table (only instanceItem/getItem are).
        ZomboLust.errorLog(MODULE_NAME, "instanceItem failed for %s. Error: %s", tostring(penisFullType), tostring(err))
        return nil
    end

    inv:addItem(penis)

    ZomboLust.debugLog(MODULE_NAME, "Created %s item for character", penisFullType)
    return penis
end

--- Ensures the penis item is equipped in the character's secondary hand
--- Removes any existing secondary hand item if needed
--- @param character IsoGameCharacter -- The character to equip the penis to
--- @param penisItem InventoryItem -- The penis item to equip
--- @param penisType string -- The type of penis being equipped
local function ensurePenisInSecondaryHand(character, penisItem, penisType)
    if not character or not penisItem then return end

    local secondaryHand = character:getSecondaryHandItem()
    if secondaryHand and secondaryHand:getFullType() == getPenisFullType(character, penisType) then
        ZomboLust.debugLog(MODULE_NAME, "%s penis is already in secondary hand", penisType)
        return
    end

    if secondaryHand then
        if dbg() then
            ZomboLust.debugLog(MODULE_NAME, "Removing item from secondary hand %s", secondaryHand:getType())
        end
        ---@diagnostic disable-next-line: param-type-mismatch
        character:setSecondaryHandItem(nil)
    end

    character:setSecondaryHandItem(penisItem)
    ZomboLust.debugLog(MODULE_NAME, "%s penis equipped in secondary hand", penisType)
end

--- Equips a penis item to a male player character
--- Creates the penis item, adds it to inventory, and equips it to secondary hand
--- Does nothing if character is not male
--- @param character IsoPlayer -- The player character to equip the penis to
--- @param penisType? string -- The type of penis to equip (defaults to "human")
function ZomboLust_PenisManager.equipPenisForPlayer(character, penisType)
    if not character then return end

    penisType = penisType or "human"

    if character:isFemale() then
        ZomboLust.warningLog(MODULE_NAME, "Character is not male, skipping penis equipment")
        return
    end

    ZomboLust.debugLog(MODULE_NAME, "Equipping %s penis to Player", penisType)

    local penis = givePenisToCharacter(character, penisType)
    if penis then
        ensurePenisInSecondaryHand(character, penis, penisType)
    end
end

--- Equips a penis item to a male ZombHuman character
--- Creates the penis item and equips it directly to secondary hand
--- Does nothing if character is not male
--- @param character IsoZombie -- The ZombHuman character to equip the penis to
--- @param penisType? string -- The type of penis to equip (defaults to "human")
function ZomboLust_PenisManager.equipPenisForZombHuman(character, penisType)
    if not character then return end

    penisType = penisType or "human"

    if character:isFemale() then
        ZomboLust.warningLog(MODULE_NAME, "ZombHuman is not male, skipping penis equipment")
        return
    end

    ZomboLust.debugLog(MODULE_NAME, "Equipping %s penis to ZombHuman (Direct)", penisType)

    local penis = givePenisToCharacter(character, penisType)
    if penis then
        -- Direct equipment bypasses the ZombHuman task system
        -- This ensures the penis is visible DURING the animation
        ensurePenisInSecondaryHand(character, penis, penisType)

        -- Also update ZombHuman's internal variable so it knows something is in the secondary hand
        character:setVariable("ZombHumanSecondary", getPenisFullType(character, penisType))
        if dbg() then
            ZomboLust.debugLog(MODULE_NAME, "Direct equipment successful for %s", getPenisFullType(character, penisType))
        end
    else
        ZomboLust.errorLog(MODULE_NAME, "Failed to create penis for ZombHuman")
    end
end

--- Removes all penis items from a character
--- Removes from primary hand, secondary hand, and inventory
--- Uses unequip actions for players and direct removal for ZombHumans
--- @param character IsoGameCharacter -- The character to remove penis items from
function ZomboLust_PenisManager.removePenis(character)
    if not character then return end

    ZomboLust.debugLog(MODULE_NAME, "Removing all penis items from character")

    local isPlayer = instanceof(character, "IsoPlayer")
    local primaryItem = character:getPrimaryHandItem()
    local secondaryItem = character:getSecondaryHandItem()

    if primaryItem and string.find(primaryItem:getType(), "Penis", 1, true) then
        ZomboLust.debugLog(MODULE_NAME, "Removing penis from primary hand")
        if isPlayer then
            ---@diagnostic disable-next-line: param-type-mismatch
            ISTimedActionQueue.add(ISUnequipAction:new(character, primaryItem, 1))
        else
            ---@diagnostic disable-next-line: param-type-mismatch
            character:setPrimaryHandItem(nil)
        end
    end

    if secondaryItem and string.find(secondaryItem:getType(), "Penis", 1, true) then
        ZomboLust.debugLog(MODULE_NAME, "Removing penis from secondary hand")
        if isPlayer then
            ---@diagnostic disable-next-line: param-type-mismatch
            ISTimedActionQueue.add(ISUnequipAction:new(character, secondaryItem, 1))
        else
            ---@diagnostic disable-next-line: param-type-mismatch
            character:setSecondaryHandItem(nil)
        end
    end

    local inventory = character:getInventory()
    if inventory then
        local items = inventory:getItems()
        for i = items:size() - 1, 0, -1 do
            local item = items:get(i)
            if item and string.find(item:getType(), "Penis", 1, true) then
                if dbg() then
                    ZomboLust.debugLog(MODULE_NAME, "Removing penis item from inventory: %s", item:getType())
                end
                inventory:Remove(item)
            end
        end
    end
end

return ZomboLust_PenisManager
