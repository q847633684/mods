--- File: ZomboLust/42/media/lua/client/ZomboLust_ModOptions.lua
--- Allows players to customize ZomboLust specific settings
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

--- Workaround for a second, more severe vanilla limitation than the ComboBox one above
--- @param option table -- The mod option object returned by addSlider
local function fixSliderTooltip(option)
    -- ISSliderPanel (the widget borrowed from the Radio UI, RadioCom/ISUIRadio/ISSliderPanel.lua) only ever shows a
    -- tooltip while the mouse hovers its tiny left/right step buttons, and that tooltip's text is hardcoded
    -- to "UI_Radio_IncreaseStepSize" (a Radio-specific shift-step hint) - unrelated to any mod option's own tooltip.
    -- MainOptions.lua's mod-options panel builder also never wires option.tooltip onto sliders at all
    -- (same class of oversight as the ComboBox one above; verified unfixed as of build 42.20/24909800).
    -- This only patches the ONE ISSliderPanel Lua table instance behind our option
    -- (own-key overrides on that table, never the ISSliderPanel class), so every other slider in the game or in other mods is unaffected.
    -- It makes hovering anywhere on the slider - not just the two arrow buttons - show our tooltip,
    -- matching how every other mod option type already behaves.
    if not option or option.type ~= "slider" then return end
    setmetatable(option, {
        __newindex = function(t, k, v)
            rawset(t, k, v)
            -- When MainOptions sets the 'element' (ISSliderPanel), we inject the tooltip
            if k == "element" and v and t.tooltip then
                local slider = v
                slider.toolTipText = getText(t.tooltip)

                local realDeactivateToolTip = slider.deactivateToolTip
                local origOnMouseMove = slider.onMouseMove
                local origOnMouseMoveOutside = slider.onMouseMoveOutside

                -- Vanilla's onMouseMove calls deactivateToolTip() itself whenever the mouse isn't over the arrow buttons;
                -- swallow that here so hovering the rest of the bar doesn't immediately close the tooltip we're about to (re)show below.
                -- Real cleanup happens only in onMouseMoveOutside, once the mouse actually leaves the slider.
                function slider.deactivateToolTip() end

                function slider:onMouseMove(x, y)
                    origOnMouseMove(self, x, y)
                    self:activateToolTip()
                end

                function slider:onMouseMoveOutside(x, y)
                    origOnMouseMoveOutside(self, x, y)
                    realDeactivateToolTip(self)
                end
            end
        end
    })
end

local function ZomboLustModOptions()
    -- Create the options object
    local options = PZAPI.ModOptions:create("ZomboLust", "ZomboLust")

    -- Add a title
    options:addTitle(getText("UI_options_ZomboLust_difficultyTitle"))

    -- Difficulty selection for sexual animations
    -- 1: Casual (everything unlocked)
    -- 2: Normal (1 month / 2 months)
    -- 3: Vicious (2 months / 4 months)
    local difficulty = options:addComboBox("difficulty", "UI_options_ZomboLust_difficulty", "UI_options_ZomboLust_difficulty_tooltip")
    fixComboBoxTooltip(difficulty)
    
    difficulty:addItem(getText("UI_options_ZomboLust_difficulty_casual"), true)  -- Default
    difficulty:addItem(getText("UI_options_ZomboLust_difficulty_normal"), false)
    difficulty:addItem(getText("UI_options_ZomboLust_difficulty_vicious"), false)

    -- Mini-game outcome inversion: most players approach these mini-games passively
    -- (stay idle to "lose" on purpose) rather than actively aiming for the pink zone.
    -- When enabled (default), staying idle until timeout lets the scene continue,
    -- and stopping the cursor in the pink zone becomes the escape route instead.
    options:addTickBox("invertMinigame", "UI_options_ZomboLust_invertMinigame", true, "UI_options_ZomboLust_invertMinigame_tooltip")

    -- Chance (%) that an "elected" zombie bites instead of triggering the sexual animation, once the player has nothing left to strip.
    -- Read live by ZomboLust_SexualIntentSystem.rollIntent.
    -- Both extremes are safe: 0 = animation only (zombie never bites), 100 = bite only (animation never triggers).
    local biteChance = options:addSlider("biteChance", "UI_options_ZomboLust_biteChance", 0, 100, 1, 35, "UI_options_ZomboLust_biteChance_tooltip")
    fixSliderTooltip(biteChance)

    options:addSeparator()
end

-- Initialize the mod options
ZomboLustModOptions()
