-- File: ZomboLust/42/media/lua/client/Clothing/ZomboLust_ClothingStripForZombHuman.lua
-- Clothing stripping system for ZombHuman NPCs in ZomboLust
-- Manages removal of ZombHuman clothing before animations
-- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_ClothingStripForZombHuman.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"
require "Clothing/ZomboLust_ClothingStrip"

-- Module name for logging
--- @type string
local MODULE_NAME = "ClothingStripForZombHuman"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

-- ================
-- Module Namespace
-- ================
--- Main namespace
--- @type table
ZomboLust_ClothingStripForZombHuman = {}

-- Locations to IGNORE for ZombHumans (head, socks, shoes)
-- We normalize these to lowercase without "base:" prefix
local IgnoredLocations = {
    ["fullsuithead"] = true,
    ["maskfull"] = true,
    ["maskeyes"] = true,
    ["mask"] = true,
    ["hat"] = true,
    ["shoes"] = true,
    ["socks"] = true,
}

--- Normalize a location string (remove base: and lowercase)
--- @param loc string -- The raw body location string (e.g., "Base:Shoes")
--- @return string -- The normalized location in lowercase without prefix (e.g., "shoes")
local function normalizeLoc(loc)
    if not loc then return "" end
    return string.match(loc:lower(), "([^:]+)$") or ""
end

--- Strip the ZombHuman of all removable clothing items and drop them on the floor
--- @param zombHuman IsoZombie -- The ZombHuman NPC
function ZomboLust_ClothingStripForZombHuman.stripZombHuman(zombHuman)
    if not zombHuman then
        ZomboLust.errorLog(MODULE_NAME, "stripZombHuman -> Invalid parameter (zombHuman is nil)")
        return
    end

    ZomboLust.debugLog(MODULE_NAME, "stripZombHuman -> Starting full stripping of ZombHuman")

    -- 1. Get Visuals
    local itemVisuals = zombHuman:getItemVisuals()
    if not itemVisuals then
        ZomboLust.warningLog(MODULE_NAME, "stripZombHuman -> ZombHuman has no ItemVisuals!")
        return
    end

    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "stripZombHuman -> Visuals count: %d", itemVisuals:size())
    end

    local keptVisuals = {}
    local itemsToCreate = {}

    -- Map of locations from the shared removal order
    local removalMap = {}
    local removalOrder = ZomboLust_ClothingStrip.ClothingRemovalOrder
    for i = 1, #removalOrder do
        local location = removalOrder[i]
        removalMap[normalizeLoc(tostring(location))] = true
    end

    -- Identify what to keep and what to remove
    local itemVisualsSize = itemVisuals:size()
    for i = 0, itemVisualsSize - 1 do
        local visual = itemVisuals:get(i)
        if visual then
            local itemType = tostring(visual:getItemType())
            local scriptItem = getScriptManager():getItem(itemType)
            local rawLocation = scriptItem and scriptItem:getBodyLocation() or "Unknown"
            local location = normalizeLoc(tostring(rawLocation))

            if dbg() then
                ZomboLust.debugLog(MODULE_NAME, "stripZombHuman -> Found visual: %s at location: %s (normalized: %s)", itemType, tostring(rawLocation), location)
            end

            -- Check if this location should be ignored (kept)
            if IgnoredLocations[location] or not removalMap[location] then
                ZomboLust.debugLog(MODULE_NAME, "stripZombHuman -> Keeping visual: %s", itemType)
                table.insert(keptVisuals, visual)
            else
                ZomboLust.debugLog(MODULE_NAME, "stripZombHuman -> Removing visual: %s", itemType)
                table.insert(itemsToCreate, itemType)
            end
        end
    end

    -- 2. Rebuild Visuals
    itemVisuals:clear()
    for i = 1, #keptVisuals do
        local visual = keptVisuals[i]
        if visual then
            itemVisuals:add(visual)
        end
    end

    -- 3. Create, Wear-out, and Scatter physical items
    local centerSquare = zombHuman:getSquare()
    if not centerSquare then return end

    for i = 1, #itemsToCreate do
        local itemType = itemsToCreate[i]
        if itemType then
            local item = instanceItem(itemType)
            if not item or not instanceof(item, "Clothing") then
                -- Fallback for non-clothing items
                if item then centerSquare:AddWorldInventoryItem(item, 0.5, 0.5, 0.0) end
                -- continue/skip to next itemType
            else
                ---@cast item Clothing
                local visual = item:getVisual()
                local coveredParts = BloodClothingType.getCoveredParts(item:getBloodClothingType())

                if coveredParts then
                    -- A. Add random wear and tear (Dirt, Blood, Holes)
                    ---@type number
                    local totalBlood = 0.0
                    ---@type number
                    local totalDirt = 0.0
                    local partsCount = coveredParts:size()

                    for j = 0, partsCount - 1 do
                        local part = coveredParts:get(j)

                        -- Random Blood (0.0 - 0.7)
                        if ZombRand(100) < 70 then
                            local bloodAmt = (ZombRand(70) / 100)
                            item:setBlood(part, bloodAmt)
                            if visual then visual:setBlood(part, bloodAmt) end
                            totalBlood = totalBlood + bloodAmt
                        end

                        -- Random Dirt (0.0 - 0.8)
                        if ZombRand(100) < 80 then
                            local dirtAmt = (ZombRand(80) / 100)
                            item:setDirt(part, dirtAmt)
                            if visual then visual:setDirt(part, dirtAmt) end
                            totalDirt = totalDirt + dirtAmt
                        end

                        -- Random Holes (20% chance per part)
                        if ZombRand(100) < 20 and visual then
                            visual:setHole(part)
                            -- Holes on visual also update the item's condition/description automatically in B42
                        end
                    end

                    -- Set global levels for inventory bars (0 - 100 range)
                    if partsCount > 0 then
                        -- Calculate percentage (0-100)
                        -- We use a moderate multiplier (1.5) for a better balance between visual and stats
                        local rawBlood = (totalBlood / partsCount) * 150
                        local rawDirt = (totalDirt / partsCount) * 150

                        -- Apply min(100) and floor to integer (val - val % 1)
                        local finalBlood = rawBlood < 100 and rawBlood or 100
                        finalBlood = finalBlood - finalBlood % 1

                        local finalDirt = rawDirt < 100 and rawDirt or 100
                        finalDirt = finalDirt - finalDirt % 1
                        item:setBloodLevel(finalBlood)
                        ---@diagnostic disable-next-line: undefined-field
                        item:setDirtiness(finalDirt)
                        ZomboLust.debugLog(MODULE_NAME, "stripZombHuman -> Stats set - Blood: %d%%, Dirt: %d%%", finalBlood, finalDirt)
                    end
                end

                -- B. Scatter on nearby squares
                local offX, offY = ZombRand(3) - 1, ZombRand(3) - 1
                local targetSquare = getCell():getGridSquare(centerSquare:getX() + offX, centerSquare:getY() + offY, centerSquare:getZ())

                -- Fallback to center if target is invalid (wall, etc)
                if not targetSquare or not targetSquare:isFree(false) then
                    targetSquare = centerSquare
                end

                -- Fine positioning within the square
                local fineX, fineY = (ZombRand(100) / 100) * 0.6 + 0.2, (ZombRand(100) / 100) * 0.6 + 0.2
                targetSquare:AddWorldInventoryItem(item, fineX, fineY, 0.0)
                ZomboLust.debugLog(MODULE_NAME, "stripZombHuman -> Created, dirtied, and scattered real item: %s to offset [%d, %d]", itemType, offX, offY)
            end
        end
    end

    -- Update visuals
    zombHuman:resetModelNextFrame()

    -- 4. Play sound
    if #itemsToCreate > 0 then
        getSoundManager():PlayWorldSound('SFXClothingRip', true, zombHuman:getCurrentSquare(), 0, 4, 1, false)
        ZomboLust.debugLog(MODULE_NAME, "stripZombHuman -> Played SFXClothingRip because %d items were stripped", #itemsToCreate)
    else
        ZomboLust.debugLog(MODULE_NAME, "stripZombHuman -> No items stripped (zombHuman already naked or only accessories), skipping SFXClothingRip")
    end

    ZomboLust.debugLog(MODULE_NAME, "stripZombHuman -> Successfully stripped zombHuman visuals and dropped items")
end

return ZomboLust_ClothingStripForZombHuman
