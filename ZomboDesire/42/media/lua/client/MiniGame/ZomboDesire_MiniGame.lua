--- File: ZomboDesire/42/media/lua/client/MiniGame/ZomboDesire_MiniGame.lua
--- Mini-game for the Stage 1 Begin animation
--- @author BlaBla 2026 (based on BetterLockpicking)

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_MiniGame.lua loaded")

-- =============
-- Dependencies
-- =============
require "ISUI/ISPanel"

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local tostring = tostring

---@class ZomboDesire_MiniGameConfig
---@field WindowWidth number
---@field WindowHeight number
---@field BarHeight number
---@field MarginX number
---@field MarginY number
---@field DurationSeconds number
---@field ArrowSpeed number
---@field BasePinkSize number
---@field BaseGreenSize number
---@field MsgSuccess string
---@field MsgTimeout string
---@field MsgFailOrange string
---@field MsgFailGreen string

---@class ZomboDesire_MiniGameHandlers
---@field onEnd fun(player: IsoPlayer, result: string, action: ISZomboDesireAnimationAction): string|nil -- May return a corrected result (e.g. success/timeout swapped) for finish() to forward to the OnZomboDesireMiniGameFinish event instead of the raw one

---@class ZomboDesire_MiniGame : ISPanel
---@field character IsoPlayer
---@field action ISZomboDesireAnimationAction
---@field arrowPos number
---@field arrowDir number
---@field timer number
---@field isClosed boolean
---@field pinkSize number
---@field greenSize number
---@field pinkStart number
---@field greenStart number
---@field arrowSpeedMultiplier number
---@field onKeyDownHandler function|nil -- Reference to the Events.OnKeyStartPressed closure, kept so finish() can remove it again
---@field Config ZomboDesire_MiniGameConfig
---@field Handlers ZomboDesire_MiniGameHandlers
---@field calculateZones fun(self: ZomboDesire_MiniGame)
---@field finish fun(self: ZomboDesire_MiniGame, result: string)
---@field onKeyPress fun(self: ZomboDesire_MiniGame, key: number)
---@field new fun(self: ZomboDesire_MiniGame, x: number, y: number, width: number, height: number, character: IsoPlayer, action: ISZomboDesireAnimationAction): ZomboDesire_MiniGame
---@field Launch fun(character: IsoPlayer, action: ISZomboDesireAnimationAction): ZomboDesire_MiniGame
ZomboDesire_MiniGame = ISPanel:derive("ZomboDesire_MiniGame")

--- Module name for logging
---@type string
local MODULE_NAME = "MiniGame"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboDesire.isDebug in ZomboDesire_Main.lua).
--- Calls with cheap/no arguments use ZomboDesire.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboDesire.isDebug(MODULE_NAME)
end

-- ====================
-- Configuration & Hooks
-- ====================

--- Mini-game configuration parameters
---@type ZomboDesire_MiniGameConfig
ZomboDesire_MiniGame.Config = {
    WindowWidth = 340,
    WindowHeight = 140, -- Increased from 120 to fit the static SPACE key hint anchored at the bottom
    BarHeight = 20,
    MarginX = 20,
    MarginY = 40,
    DurationSeconds = 7.0, -- Time before automatic failure (leave 1.0s margin for Stage 1)
    ArrowSpeed = 1.2,    -- Base speed of the cursor
    BasePinkSize = 15,   -- Baseline pink zone size (%). ZomboLust rescales this from Excitation when active
    BaseGreenSize = 30,  -- Baseline green zone size (%), always fixed
    KeyIconMarginBottom = 15, -- Gap (px) between the key hint image and the bottom edge of the panel

    -- Messages for Speech Text
    MsgSuccess = "IGUI_ZomboDesire_MiniGame_Success",
    MsgTimeout = "IGUI_ZomboDesire_MiniGame_Timeout",
    MsgFailOrange = "IGUI_ZomboDesire_MiniGame_FailOrange",
    MsgFailGreen = "IGUI_ZomboDesire_MiniGame_FailGreen",
}

--- Handlers that can be overridden by other mods (like ZomboLust).
--- Already a safe extension point as-is: Handlers.onEnd is re-read from this table on every call (see finish() below),
--- not captured into a local once, so reassigning it here (or from another mod's own file)
--- takes effect immediately with no need for an event/monkey-patch of any kind.
---@type ZomboDesire_MiniGameHandlers
ZomboDesire_MiniGame.Handlers = {
    --- Called when the game ends
    --- @param player IsoPlayer
    --- @param result string -- "success", "fail_orange", "fail_green", "timeout"
    --- @param action ISZomboDesireAnimationAction -- The animation action instance
    onEnd = function(player, result, action)
        local config = ZomboDesire_MiniGame.Config

        local msgKey = ""
        local r, g, b = 1.0, 1.0, 1.0

        if result == "success" then
            ZomboDesire.debugLog(MODULE_NAME, "Mini-game SUCCESS")
            msgKey = config.MsgSuccess
            r, g, b = 1.0, 0.4, 0.7 -- Pink
        elseif result == "timeout" then
            msgKey = config.MsgTimeout
            r, g, b = 1.0, 0.5, 0.0 -- Orange
        elseif result == "fail_orange" then
            msgKey = config.MsgFailOrange
            r, g, b = 1.0, 0.5, 0.0 -- Orange
        elseif result == "fail_green" then
            msgKey = config.MsgFailGreen
            r, g, b = 0.0, 1.0, 0.0 -- Green
        end

        -- Default behavior: Speech Text logic + forceStop
        if msgKey ~= "" then
            player:getEmitter():playSound("ZombieVoiceGeneric")
            local msg = getText(msgKey)
            player:addLineChatElement(msg, r, g, b)
        end

        if result ~= "success" and action and action.forceStop then
            -- Use the current active action if possible to ensure it stops even if stage changed
            local currentAction = ZomboDesire_AnimationHandler.currentAnimationAction
            if currentAction and currentAction.forceStop then
                currentAction:forceStop()
            else
                action:forceStop()
            end
        end
    end
}

-- ====================
-- Implementation
-- ====================

--- Initializes the mini-game UI panel
---@diagnostic disable-next-line: duplicate-set-field
function ZomboDesire_MiniGame:initialise()
    ISPanel.initialise(self)

    self.arrowPos = 0
    self.arrowDir = 1
    self.timer = ZomboDesire_MiniGame.Config.DurationSeconds * 60 -- Approx 60 ticks per second
    self.isClosed = false

    self:calculateZones()

    -- For external mods (like ZomboLust) to extend initialise() without monkey-patching it -
    -- e.g. resizing the panel or adding custom fields for a later prerender() extension.
    triggerEvent("OnZomboDesireMiniGameInitialise", self)
end

--- Calculates the positions/baseline sizes of the mini-game's color zones, and the cursor speed multiplier based on stamina
---@diagnostic disable-next-line: duplicate-set-field
function ZomboDesire_MiniGame:calculateZones()
    local endurance = self.character:getStats():get(CharacterStat.ENDURANCE)

    -- Baseline zone sizes (fixed). ZomboLust rescales pinkSize from Excitation
    -- when active; without it (ZomboDesire alone), these baselines are used as-is.
    self.pinkSize = ZomboDesire_MiniGame.Config.BasePinkSize
    self.greenSize = ZomboDesire_MiniGame.Config.BaseGreenSize

    -- Stamina-dependent cursor speed multiplier
    -- Full (1.0) -> calm, near-immobile cursor. Empty (0.0) -> out of breath, fast cursor.
    -- Same 0.05x-4.0x range as the Excitation-based multiplier (ZomboLust, pink zone size)
    if endurance >= 0.9 then -- Full
        self.arrowSpeedMultiplier = 0.05
    elseif endurance >= 0.6 then -- High
        self.arrowSpeedMultiplier = 1.0
    elseif endurance >= 0.3 then -- Low
        self.arrowSpeedMultiplier = 2.25
    else -- Exhausted
        self.arrowSpeedMultiplier = 4.0
    end

    -- Randomize positions (avoiding edges)
    -- Ensure green doesn't fully overlap pink in a way that hides it or make it too easy
    self.pinkStart = ZombRand(10, 90 - self.pinkSize)
    self.greenStart = ZombRand(5, 95 - self.greenSize)

    -- For external mods (like ZomboLust) to override the baseline zone sizes/positions computed above
    -- (e.g. rescaling pinkSize from an Excitation stat) without monkey-patching this method.
    -- Subscribers mutate self.pinkSize/pinkStart/etc. in place.
    triggerEvent("OnZomboDesireMiniGameCalculateZones", self)
end

--- Draws the colored bars (Orange background, Green, Pink)
---@diagnostic disable-next-line: duplicate-set-field
function ZomboDesire_MiniGame:prerender()
    ISPanel.prerender(self)

    local config = ZomboDesire_MiniGame.Config
    local x = config.MarginX
    local y = config.MarginY
    local w = self.width - (x * 2)
    local h = config.BarHeight

    -- Orange Background (Full Bar) - universal "light danger"
    self:drawRect(x, y, w, h, 0.8, 1, 0.5, 0)

    -- Green Zone - universal "safety"
    local gX = x + (self.greenStart * w / 100)
    local gW = (self.greenSize or 20) * w / 100
    self:drawRect(gX, y, gW, h, 0.8, 0, 1, 0)

    -- Pink Zone - universal "love/desire"
    local pX = x + (self.pinkStart * w / 100)
    local pW = (self.pinkSize or 10) * w / 100
    self:drawRect(pX, y, pW, h, 0.8, 1, 0.4, 0.7)

    -- Border
    self:drawRectBorder(x, y, w, h, 1, 0.4, 0.4, 0.4)

    -- SPACE Key Hint (centered under the colored bar, so it stays correctly placed
    -- regardless of the bar's width - which varies with the panel's language/font).
    -- Uses the texture's actual size rather than config.KeyIconSize: Key_SPACE_48.png is a wide pill shape
    -- (the "48" is its height only), not a square icon.
    local keyTex = getTexture("media/ui/Keys/48/Key_SPACE_48.png")
    if keyTex then
        local keyW = keyTex:getWidth()
        local keyH = keyTex:getHeight()
        local keyX = x + ((w - keyW) / 2)
        local keyY = self.height - keyH - config.KeyIconMarginBottom
        self:drawTexture(keyTex, keyX, keyY, 1, 1, 1, 1)
    end

    -- For external mods (like ZomboLust) to draw extra content on top of the bar without
    -- monkey-patching this method - e.g. custom prompt text set up in an OnZomboDesireMiniGameInitialise subscriber.
    triggerEvent("OnZomboDesireMiniGamePrerender", self)
end

--- Updates the arrow cursor movement and handle timeout
---@diagnostic disable-next-line: duplicate-set-field
function ZomboDesire_MiniGame:render()
    ISPanel.render(self)

    local config = ZomboDesire_MiniGame.Config
    local x = config.MarginX
    local y = config.MarginY
    local w = self.width - (x * 2)
    local h = config.BarHeight
    local millis = UIManager.getMillisSinceLastRender()
    if isGamePaused() then millis = 0 end

    -- Update Arrow Position
    local speed = config.ArrowSpeed * (self.arrowSpeedMultiplier or 1.0) * millis * 0.12
    self.arrowPos = self.arrowPos + (speed * self.arrowDir)

    if self.arrowPos >= 100 then
        self.arrowPos = 100
        self.arrowDir = -1
    elseif self.arrowPos <= 0 then
        self.arrowPos = 0
        self.arrowDir = 1
    end

    -- Draw Arrow (Cursor)
    local arrowX = x + (self.arrowPos * w / 100)
    local tex = getTexture("media/textures/BetLock_arrow.png")
    if tex then
        self:drawTexture(tex, arrowX - (tex:getWidth() / 2), y + h + 5, 1, 1, 1, 1)
    else
        -- Fallback if texture missing
        self:drawRect(arrowX - 2, y + h, 4, 10, 1, 1, 1, 1)
    end

    -- Update Timeout
    if not self.isClosed then
        self.timer = self.timer - (millis * 0.06)
        if self.timer <= 0 then
            self:finish("timeout")
        end
    end
end

--- Handle key press events for player interaction
--- @param key number -- The key code of the pressed key
---@diagnostic disable-next-line: duplicate-set-field
function ZomboDesire_MiniGame:onKeyPress(key)
    if self.isClosed or isGamePaused() then return end

    if key == Keyboard.KEY_SPACE then
        local pos = self.arrowPos
        local pinkEnd = self.pinkStart + (self.pinkSize or 10)
        local greenEnd = self.greenStart + (self.greenSize or 20)

        if pos >= self.pinkStart and pos <= pinkEnd then
            self:finish("success")
        elseif pos >= self.greenStart and pos <= greenEnd then
            self:finish("fail_green")
        else
            self:finish("fail_orange")
        end
    end
end

--- Finalizes the mini-game and triggers result handler
--- @param result string -- The game outcome: "success", "fail_orange", "fail_green", "timeout", "interrupted"
---@diagnostic disable-next-line: duplicate-set-field
function ZomboDesire_MiniGame:finish(result)
    if self.isClosed then return end
    self.isClosed = true

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Mini-game finished with result: %s", tostring(result))
    end

    -- Handlers.onEnd may return a corrected result (e.g. ZomboLust's invertMinigame option
    -- swaps success/timeout internally) - if it does, that's the result external listeners
    -- (the event below) should see too, not the raw pre-swap one.
    local finalResult = result
    if result ~= "interrupted" then
        finalResult = ZomboDesire_MiniGame.Handlers.onEnd(self.character, result, self.action) or result
    end

    self:setVisible(false)
    self:removeFromUIManager()

    -- Events.*.Remove() matches by function identity, not source text, so the closure
    -- stored at launch time in onKeyDownHandler can be removed here just fine.
    if self.onKeyDownHandler then
        Events.OnKeyStartPressed.Remove(self.onKeyDownHandler)
        self.onKeyDownHandler = nil
    end

    -- For external mods (like ZomboLust) to react to the mini-game finishing without
    -- monkey-patching this method - e.g. closing an extra UI panel of their own.
    -- Fires past the isClosed guard above, so a redundant re-entrant finish() call doesn't re-fire it.
    triggerEvent("OnZomboDesireMiniGameFinish", self, finalResult)
end

--- Constructor for the mini-game UI
--- @param x number -- X screen coordinate
--- @param y number -- Y screen coordinate
--- @param width number -- Panel width
--- @param height number -- Panel height
--- @param character IsoPlayer -- Character who is interacting
--- @param action ISZomboDesireAnimationAction -- The parent animation action
--- @return ZomboDesire_MiniGame -- The created instance
---@diagnostic disable-next-line: duplicate-set-field
function ZomboDesire_MiniGame:new(x, y, width, height, character, action)
    ---@type ZomboDesire_MiniGame
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    ---@diagnostic disable-next-line: inject-field
    self.__index = self

    o.character = character
    o.action = action
    o.moveWithMouse = true
    o:setWantKeyEvents(true)

    return o
end

--- Static method to launch the game for the player
--- @param character IsoPlayer -- The player character
--- @param action ISZomboDesireAnimationAction -- The parent animation action
--- @return ZomboDesire_MiniGame -- The active UI instance
---@diagnostic disable-next-line: duplicate-set-field
function ZomboDesire_MiniGame.Launch(character, action)
    local width = ZomboDesire_MiniGame.Config.WindowWidth
    local height = ZomboDesire_MiniGame.Config.WindowHeight
    local x = (getCore():getScreenWidth() / 2) - (width / 2)
    local y = (getCore():getScreenHeight() / 2) + 150 -- Positioned below the characters

    local ui = ZomboDesire_MiniGame:new(x, y, width, height, character, action)
    ui:initialise()
    ui:addToUIManager()

    -- Global key listener registration in PZ style
    local function onKeyDown(key)
        if ui and ui:getIsVisible() then
            ui:onKeyPress(key)
        end
    end

    -- Keep a reference on the instance so finish() can remove this exact closure later.
    -- Events.*.Remove() matches by function identity (not source text), so holding onto
    -- the same reference we pass to Add() here is all that's needed to unregister it.
    ---@diagnostic disable-next-line: inject-field
    ui.onKeyDownHandler = onKeyDown
    Events.OnKeyStartPressed.Add(onKeyDown)

    -- For external mods (like ZomboLust) to launch their own UI alongside this one without monkey-patching this method.
    triggerEvent("OnZomboDesireMiniGameLaunch", ui, character, action)

    return ui
end

return ZomboDesire_MiniGame
