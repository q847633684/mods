--- File: ZomboDesire/42/media/lua/client/ZomboDesire_ModOptions.lua
--- Allows players to customize various settings
--- @author BlaBla 2025

--- Workaround for tooltip issue in ComboBox mod options
--- @param option table -- The mod option object returned by addComboBox
local function fixComboBoxTooltip(option)
    if not option or option.type ~= "combobox" then return end
    setmetatable(option, {
        __newindex = function(t, k, v)
            rawset(t, k, v)
            -- When MainOptions sets the 'element' (ISComboBox), we inject the tooltip
            if k == "element" and v and t.tooltip then
                v:setToolTipMap({ defaultTooltip = getText(t.tooltip) })
            end
        end
    })
end

local function ZomboDesireModOptions()
    -- Create the options object
    local options = PZAPI.ModOptions:create("ZomboDesire", "ZomboDesire")

    -- Add a title
    options:addTitle(getText("UI_options_ZomboDesire_animationTitle"))

    -- Multiplier for Stage 2 duration
    -- Default: 1 (normal duration), Max: 15 (15x duration)
    -- If ZomboLust is active, the step is increased to 5 (Max: 75)
    local multiplier = options:addComboBox("stage2Multiplier", "UI_options_ZomboDesire_stage2Multiplier", "UI_options_ZomboDesire_stage2Multiplier_tooltip")
    fixComboBoxTooltip(multiplier)
    local isZomboLustActive = getActivatedMods():contains("ZomboLust")
    local step = isZomboLustActive and 5 or 1
    for i = 1, 15 do
        multiplier:addItem(getText("UI_options_ZomboDesire_multiplier_val", i * step), i == 1)
    end

    -- Add a title
    options:addTitle(getText("UI_options_ZomboDesire_escapeTitle"))

    -- Add the escape duration combo box
    -- Values displayed in minutes, but stored internally as index (1-10) which equals minutes
    -- Min: 1 minute, Max: 10 minutes, Default: 3 minutes
    --
    -- Zombie Attraction Penalty System:
    -- When invisibility ends, an audible disturbance is emitted at the player's location,
    -- attracting nearby zombies based on duration (no penalty for very short durations)
    -- Formula: attractionRadius = (escapeDuration - 1) * 10 game units
    --   - 1 minute duration = 0 radius (no penalty)
    --   - 2 minute duration = 10 radius (very local attraction)
    --   - 3 minute duration = 20 radius (local attraction)
    --   - ...
    --   - 10 minute duration = 90 radius (massive attraction)
    local escape = options:addComboBox("escapeDuration", "UI_options_ZomboDesire_escapeDuration", "UI_options_ZomboDesire_escapeDuration_tooltip")
    fixComboBoxTooltip(escape)
    for i = 1, 10 do
        local label = getText("UI_options_ZomboDesire_minutes_val", i)
        if i == 1 then label = getText("UI_options_ZomboDesire_minute_val", i) end
        escape:addItem(label, i == 3)
    end
end

-- Initialize the mod options
ZomboDesireModOptions()
