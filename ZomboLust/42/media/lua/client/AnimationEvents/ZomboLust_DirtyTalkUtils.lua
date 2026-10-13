--- File: ZomboLust/42/media/lua/client/AnimationEvents/ZomboLust_DirtyTalkUtils.lua
--- Utility module for handling Dirty Talk (Halo Text) during animations
--- @author BlaBla 2026

local DirtyTalkUtils = {}

-- Module name for logging
--- @type string
local MODULE_NAME = "DirtyTalkUtils"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

--- Probability for the character to speak (5%)
local CHANCE_TO_SPEAK = 5

--- Table to keep track of the last displayed phrase index per character and category
--- to avoid immediate repetitions.
--- @type table<number, table<string, number>>
local lastIndices = {}

--- Displays a random "Dirty Talk" line as a Halo text over the character
--- @param action table The animation action instance
--- @param category string The category name (e.g., "Sex_ZombieMale")
function DirtyTalkUtils.DisplayDirtyTalk(action, category)
    if not action or not action.character then return end

    -- 5% chance check
    local roll = ZombRand(100)
    ZomboLust.debugLog(MODULE_NAME, "DirtyTalk roll for '%s': %d (Needs < %d)", category, roll, CHANCE_TO_SPEAK)

    if roll >= CHANCE_TO_SPEAK then return end

    ---@type IsoGameCharacter
    local character = action.character
    local baseKey = "IGUI_ZomboLust_DirtyTalk_" .. category

    -- Find all available variants (IGUI_..._1, IGUI_..._2, etc.)
    local variants = {}
    local i = 1
    while i < 50 do -- Safety limit
        local key = baseKey .. "_" .. i
        local text = getText(key)
        -- If getText returns the key itself, it means the translation is missing
        if text == key then break end
        table.insert(variants, text)
        i = i + 1
    end

    -- Fallback to the base key if no variants found (for backward compatibility or simpler setup)
    if #variants == 0 then
        local text = getText(baseKey)
        if text ~= baseKey then
            table.insert(variants, text)
        end
    end

    -- If we found some text, pick one randomly and display it
    if #variants > 0 then
        local charID = character:getID()
        local lastIdx = lastIndices[charID] and lastIndices[charID][category]

        local idx = ZombRand(#variants) + 1

        -- Avoid repeating the same phrase if there are multiple variants
        if #variants > 1 and idx == lastIdx then
            idx = (idx % #variants) + 1
        end

        -- Update last index for this character and category
        lastIndices[charID] = lastIndices[charID] or {}
        lastIndices[charID][category] = idx

        local selectedText = variants[idx]
        if not selectedText then return end

        ZomboLust.debugLog(MODULE_NAME, "Selected phrase for '%s': \"%s\"", category, selectedText)

        -- Color logic: Random interpolation between Cyan (0, 255, 255) and Purple/Mauve (153, 50, 204)
        local t = ZombRand(101) / 100
        local r = math.floor(0 + (153 - 0) * t)
        local g = math.floor(255 + (50 - 255) * t)
        local b = math.floor(255 + (204 - 255) * t)

        -- Display text
        character:Say(selectedText, r / 255, g / 255, b / 255, UIFont.Handwritten, 15.0, "default")
    end
end

return DirtyTalkUtils
