-- File: ZomboLust/42/media/lua/client/MiniGame/ZomboLust_MoraleUI.lua
-- UI widget for the ZomboLust Morale mini-game: the ZomboLust_MoraleBar panel
-- (vertical morale tube, moodle stack, blinking 'X' key, zombie-side threshold reactions and pulsing outline) and its Launch entry point.
-- Simulation/penalties live in ZomboLust_MoraleSystem.lua.
-- @author BlaBla 2026

print("[ZomboLust LOADING] ZomboLust_MoraleUI.lua loaded")

---@diagnostic disable: inject-field

-- =============
-- Dependencies
-- =============
require "ISUI/ISPanel"
require "MiniGame/ZomboLust_MoraleSystem"

-- Module name for logging
--- @type string
local MODULE_NAME = "MoraleUI"

local getDifficultyLevel = ZomboLust_MoraleSystem.getDifficultyLevel

-- ==================
-- Utility Functions
-- ==================

--- Detects whether "curr" crossed "threshold" relative to "prev", and in which direction.
--- @param prev number
--- @param curr number
--- @param threshold number
--- @return "up"|"down"|nil
local function detectCrossing(prev, curr, threshold)
    if prev < threshold and curr >= threshold then return "up" end
    if prev >= threshold and curr < threshold then return "down" end
    return nil
end

-- Same RGB values as HaloTextHelper.java's own COLOR_GREEN/COLOR_RED constants.
-- Kept as plain Lua tables instead of calling HaloTextHelper.getColorGreen()/getColorRed() and reading .r/.g/.b off the returned Java ColorRGB object:
-- that field access silently returns nil through Kahlua's Java bridge
-- (confirmed in-game - "__concat not defined for operands: null and ]", right-to-left concatenation meant color.b was the first operand evaluated).
-- The rest of this file only ever passes a ColorRGB object stright into another Java method
-- (e.g. HaloTextHelper.addTextWithArrow in ZomboLust_MoraleSystem.lua's ApplyXPLoss), which reads its fields Java-side and never hits this problem.
local EXCITATION_UP_COLOR = { r = 137, g = 232, b = 148 }
local EXCITATION_DOWN_COLOR = { r = 255, g = 105, b = 97 }
-- 1.0 = normal volume - 0.35 = 35%
local EXCITATION_SOUND_VOLUME = 0.35

-- Loose base-game .wav files (media/sound/PZ_*.wav).
-- playVocals() builds its clip name from the character's voice prefix,
-- which is silenced for ZombHuman (see ZombHumanUpdate.lua's setVoicePrefix("ZombHuman") call).
local PLEASED_SOUNDS_MALE = { "PZ_MaleZombie_01", "PZ_MaleZombie_02", "PZ_MaleZombie_03", "PZ_MaleZombie_04", "PZ_MaleZombie_05", "PZ_MaleZombie_06", "PZ_MaleZombie_07", "PZ_MaleZombie_08" }
local DISPLEASED_SOUNDS_MALE = { "PZ_MaleDeath_01", "PZ_MaleDeath_02", "PZ_MaleDeath_03", "PZ_MaleDeath_04", "PZ_MaleDeath_05", "PZ_MaleDeath_06", "PZ_MaleDeath_07" }
local PLEASED_SOUNDS_FEMALE = { "PZ_Female_zombie_01", "PZ_Female_zombie_02", "PZ_Female_zombie_03", "PZ_Female_zombie_04", "PZ_Female_zombie_05", "PZ_Female_zombie_06", "PZ_Female_zombie_07", "PZ_Female_zombie_08", "PZ_Female_zombie_09" }
local DISPLEASED_SOUNDS_FEMALE = { "PZ_Female_zombie_Death_01", "PZ_Female_zombie_Death_02", "PZ_Female_zombie_Death_03", "PZ_Female_zombie_Death_04" }

-- Cooldown (ms) applied after a threshold-reaction sound is played, keyed by the same gender/direction split as the sound pools above.
-- Sized just above each pool's longest clip so a new groan can never start while the previous one is still audible.
local SOUND_COOLDOWN_MS_MALE_PLEASED = 3500
local SOUND_COOLDOWN_MS_MALE_DISPLEASED = 1500
local SOUND_COOLDOWN_MS_FEMALE_PLEASED = 2000
local SOUND_COOLDOWN_MS_FEMALE_DISPLEASED = 2000

--- Reacts, from the zombie's perspective, to the player's morale crossing a threshold
--- @param zombie IsoZombie
--- @param player IsoPlayer
--- @param isUp boolean
--- @return number cooldownMs How long, in ms, no further threshold reaction should be allowed
local function reactToThresholdCrossing(zombie, player, isUp)
    local color = isUp and EXCITATION_UP_COLOR or EXCITATION_DOWN_COLOR
    local arrowFile = isUp and "ArrowUp.png" or "ArrowDown.png"
    -- The "[img=media/ui/ArrowUp.png,r,g,b]" tag reproduces exactly what addTextWithArrow builds internally for the arrow icon.
    local msg = getText("IGUI_ZomboLust_Excitation") .. " [img=media/ui/" .. arrowFile .. "," .. color.r .. "," .. color.g .. "," .. color.b .. "]"
    zombie:addLineChatElement(msg, color.r / 255, color.g / 255, color.b / 255, UIFont.Dialogue, 30.0, "default", true, true, true, true, false, true)

    -- Random variant per gender/direction, so the same groan doesn't repeat every crossing.
    ---@type string[]
    local pool
    local cooldownMs
    local isFemale = zombie:isFemale()
    if isFemale then
        pool = isUp and PLEASED_SOUNDS_FEMALE or DISPLEASED_SOUNDS_FEMALE
        cooldownMs = isUp and SOUND_COOLDOWN_MS_FEMALE_PLEASED or SOUND_COOLDOWN_MS_FEMALE_DISPLEASED
    else
        pool = isUp and PLEASED_SOUNDS_MALE or DISPLEASED_SOUNDS_MALE
        cooldownMs = isUp and SOUND_COOLDOWN_MS_MALE_PLEASED or SOUND_COOLDOWN_MS_MALE_DISPLEASED
    end
    ---@type string
    ---@diagnostic disable-next-line: undefined-field
    local soundName = pool[ZombRand(#pool) + 1]

    -- The sound is played through the PLAYER's emitter: a ZombHuman is deliberately voice-muted by the framework
    -- (ZombHumanUpdate.ZombHumanize calls desc:setVoicePrefix("ZombHuman").
    local emitter = player:getEmitter()
    local soundId = emitter:playSound(soundName)
    if soundId ~= -1 then
        emitter:setVolume(soundId, EXCITATION_SOUND_VOLUME)
    end

    ZomboLust.debugLog(MODULE_NAME, "Threshold reaction sound: %s -> playSound returned %s", soundName, tostring(soundId))

    ZomboLust.debugLog(MODULE_NAME, "Zombie threshold reaction: %s", isUp and "UP (pleased)" or "DOWN (displeased)")

    return cooldownMs
end

-- =============
-- UI Component
-- =============

---@class ZomboLust_MoraleBar : ISPanel
---@field character IsoPlayer
---@field action ISZomboDesireAnimationAction
---@field morale number
---@field isClosed boolean
---@field zombie IsoZombie|nil -- Resolved once at initialise(); the zombie this reframing is "about"
---@field zombieStartHealth number|nil -- Zombie's health at mini-game start (reward restoration reference)
---@field lastMoraleForThresholds number -- Previous-frame morale, used to edge-detect threshold crossings
---@field pulseElapsedMs number -- Elapsed time accumulator for the zombie's pulsing outline
---@field soundCooldownRemainingMs number -- Time left before another threshold reaction (text+sound) is allowed
---@field onKeyPress fun(self: ZomboLust_MoraleBar, key: number)
ZomboLust_MoraleBar = ISPanel:derive("ZomboLust_MoraleBar")

--- Constructor for the morale bar UI
---@param x number
---@param y number
---@param width number
---@param height number
---@param character IsoPlayer
---@param action ISZomboDesireAnimationAction
---@return ZomboLust_MoraleBar
function ZomboLust_MoraleBar:new(x, y, width, height, character, action)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    o:noBackground()
    o.character = character
    o.action = action
    o.morale = 100
    o.isClosed = false
    o.moveWithMouse = false
    o.blinkTimer = 0
    o.blinkState = false
    o.onKeyDown = nil
    o.zombie = nil
    o.zombieStartHealth = nil
    o.lastMoraleForThresholds = 100
    o.pulseElapsedMs = 0
    o.soundCooldownRemainingMs = 0
    o:setWantKeyEvents(true)
    return o
end

--- Initializes the morale bar state
function ZomboLust_MoraleBar:initialise()
    ISPanel.initialise(self)

    -- Initial morale based on character's current unhappiness
    -- PZ Unhappiness level is 0 to 100 (100 being most sad)
    local stats = self.character:getStats()
    local unhappiness = stats:get(CharacterStat.UNHAPPINESS)
    self.morale = math.max(0, math.min(100, 100 - unhappiness))

    -- ZomboLust "Misandrist"/"Misogynist" traits: starting morale penalty based on the zombie partner's actual gender (not the player's).
    -- Applied here (mini-game start) rather than as a direct post-hoc stat write,
    -- so the penalty is baked into self.morale and correctly feeds both finish()'s Unhappiness write AND ApplyFinalPenalties' severity tiers
    -- (XP loss/item drop/negative trait) below - a stat write after the fact would reach neither reliably.
    -- Checking the partner's gender rather than assuming "player is female = male partner" keeps
    -- this correct once same-gender encounters become possible (future Lesbian/Gay sub-mods).
    local zombie = self.action and self.action.zombHuman
    if not zombie and ZomboDesire_AnimationHandler then
        zombie = ZomboDesire_AnimationHandler.currentZombHuman
    end

    -- Captured once here: the zombie reference and its starting health, used both by the live
    -- UI reactions below (arrow text/sound/pulse) and by the end-of-encounter health/speed
    -- reward (ZomboLust_MoraleSystem.ApplyZombieReward, applied later during cleanup - see finish()).
    self.zombie = zombie
    self.zombieStartHealth = zombie and zombie:getHealth() or nil
    self.lastMoraleForThresholds = self.morale
    self.pulseElapsedMs = 0
    self.soundCooldownRemainingMs = 0

    if zombie and ZomboLustRegistries and ZomboLustRegistries.Traits then
        local traitMisandrist = ZomboLustRegistries.Traits.Misandrist
        local traitMisogynist = ZomboLustRegistries.Traits.Misogynist
        local isMisandristActive = traitMisandrist and self.character:hasTrait(traitMisandrist) and not zombie:isFemale()
        local isMisogynistActive = traitMisogynist and self.character:hasTrait(traitMisogynist) and zombie:isFemale()

        if isMisandristActive or isMisogynistActive then
            local penalty = isMisandristActive and ZomboLust_ExcitationSystem.MisandristUnhappinessBump or ZomboLust_ExcitationSystem.MisogynistUnhappinessBump
            self.morale = math.max(0, self.morale - penalty)

            ZomboLust.debugLog(MODULE_NAME, "%s: Starting morale penalty -%.2f -> %.2f (partner gender: %s)",
                isMisandristActive and "Misandrist" or "Misogynist", penalty, self.morale, zombie:isFemale() and "F" or "M")
        end
    end
end

--- Draws the morale bar UI components
function ZomboLust_MoraleBar:prerender()
    if self.isClosed then return end

    local w = self.width
    local h = self.height
    local barW = 20
    local barH = h - 20
    local barX = (w - barW) / 2
    local barY = 10

    -- 1. Draw Tube Background (Dark Grey)
    self:drawRect(barX, barY, barW, barH, 0.6, 0.1, 0.1, 0.1)

    -- 2. Draw Morale Fill (Vertical - fills from bottom to top)
    local fillH = (self.morale / 100) * barH
    local fillY = barY + (barH - fillH)

    -- Color interpolation based on morale (Red at 0, Green at 100)
    local r = 1.0 - (self.morale / 100)
    local g = self.morale / 100
    local b = 0.2

    self:drawRect(barX, fillY, barW, fillH, 0.8, r, g, b)

    -- 3. Draw Border
    self:drawRectBorder(barX, barY, barW, barH, 1, 0.4, 0.4, 0.4)

    -- 4. Draw Moodles on the right
    local moodleX = barX + barW + 5
    local moodleSize = 32
    local bgTex = getTexture("media/ui/Moodles/32/_Moodles_BGsolid.png")
    local sadTex = getTexture("media/ui/Moodles/32/Mood_Sad.png")
    local happyTex = getTexture("media/ui/Moodles/32/Mood_Happy.png")

    -- Moodle stack configuration (Bottom to Top)
    local moodles = {
        { tex = sadTex, color = {r=0.9, g=0.0, b=0.0}, y = barY + barH - moodleSize }, -- Severely Depressed
        { tex = sadTex, color = {r=0.9, g=0.3, b=0.0}, y = barY + (barH * 0.75) - moodleSize }, -- Very Depressed
        { tex = sadTex, color = {r=0.9, g=0.6, b=0.0}, y = barY + (barH * 0.5) - moodleSize }, -- Depressed
        { tex = sadTex, color = {r=0.9, g=0.9, b=0.0}, y = barY + (barH * 0.25) - moodleSize }, -- Unhappy
        { tex = happyTex, color = {r=0.0, g=0.8, b=0.0}, y = barY } -- Happy
    }

    for _, m in ipairs(moodles) do
        -- Draw Background
        self:drawTexture(bgTex, moodleX, m.y, 1, m.color.r, m.color.g, m.color.b)
        -- Draw Icon
        self:drawTexture(m.tex, moodleX, m.y, 1, 1, 1, 1)
    end

    -- 5. Draw Blinking 'X' Key
    local keySize = 64
    local keyX = moodleX + moodleSize + 10
    local keyY = barY + barH - keySize

    -- Update blink timer (125ms interval)
    local millis = UIManager.getMillisSinceLastRender()
    if not isGamePaused() then
        self.blinkTimer = self.blinkTimer + millis
        if self.blinkTimer >= 125 then
            self.blinkState = not self.blinkState
            self.blinkTimer = 0
        end
    end

    local keyTexName = self.blinkState and "media/ui/Keys/64/Key_X_Red_64.png" or "media/ui/Keys/64/Key_X_64.png"
    local keyTex = getTexture(keyTexName)
    if keyTex then
        self:drawTexture(keyTex, keyX, keyY, 1, 1, 1, 1)
    end
end

--- Checks whether morale just crossed a threshold since the last frame
--- @param millis number Time elapsed since the previous frame, used to tick down the sound cooldown
function ZomboLust_MoraleBar:checkMoraleThresholds(millis)
    self.soundCooldownRemainingMs = math.max(0, self.soundCooldownRemainingMs - millis)

    if not self.zombie or not self.zombie:isAlive() then
        self.lastMoraleForThresholds = self.morale
        return
    end

    local prev = self.lastMoraleForThresholds
    local curr = self.morale

    -- Cooldown gates the whole reaction (text bubble + sound), not just the sound:
    -- while it's active the crossing is entirely ignored, so the zombie doesn't visibly react without groaning.
    local cross50 = detectCrossing(prev, curr, ZomboLust_MoraleSystem.LowMoraleThreshold)
    if cross50 and self.soundCooldownRemainingMs <= 0 then
        self.soundCooldownRemainingMs = reactToThresholdCrossing(self.zombie, self.character, cross50 == "up")
    end

    local cross90 = detectCrossing(prev, curr, ZomboLust_MoraleSystem.HighMoraleThreshold)
    if cross90 and self.soundCooldownRemainingMs <= 0 then
        self.soundCooldownRemainingMs = reactToThresholdCrossing(self.zombie, self.character, cross90 == "up")
    end

    self.lastMoraleForThresholds = curr
end

--- Reasserts a pulsing white outline on the zombie, faster as morale rises
--- @param millis number
function ZomboLust_MoraleBar:updateZombiePulse(millis)
    if not self.zombie or not self.zombie:isAlive() then return end

    -- Must be reasserted every frame (not set once): a single setHighlighted/setOutlineHighlight call does not stick
    -- on an AI-controlled zombie, since its own update loop resets the flag.
    self.pulseElapsedMs = self.pulseElapsedMs + millis

    local periodMs
    if self.morale >= ZomboLust_MoraleSystem.HighMoraleThreshold then
        periodMs = 300 -- very fast pulse
    elseif self.morale >= ZomboLust_MoraleSystem.LowMoraleThreshold then
        periodMs = 650 -- fast pulse
    else
        periodMs = 1500 -- slow pulse
    end

    -- Floor kept just above 0 (not exactly 0) so the outline still fades all the way down without any risk of a jarring on/off snap at the exact trough
    local phase = (self.pulseElapsedMs % periodMs) / periodMs
    local alpha = 0.05 + 0.95 * ((math.sin(phase * 2 * math.pi) + 1) / 2)

    local playerNum = self.character:getIndex()
    self.zombie:setHighlighted(playerNum, true, false)
    self.zombie:setHighlightColor(playerNum, 1.0, 1.0, 1.0, alpha)
    self.zombie:setOutlineHighlight(playerNum, true)
    self.zombie:setOutlineHighlightCol(playerNum, 1.0, 1.0, 1.0, alpha)
end

--- Updates the morale decay and checks for interruption
function ZomboLust_MoraleBar:render()
    if self.isClosed then return end

    local millis = UIManager.getMillisSinceLastRender()
    if isGamePaused() then millis = 0 end

    -- Update Morale Decay
    local decayRate = ZomboLust_MoraleSystem.DecayRate
    local profSexSlave = ZomboLustRegistries.Professions.sexslave
    if profSexSlave and self.character:getDescriptor():getCharacterProfession() == profSexSlave then
        decayRate = decayRate * 1.25
    end

    local decay = decayRate * (millis * 0.06)
    self.morale = math.max(0, self.morale - decay)

    -- Zombie-side reinforcement of the "you control the zombie" perspective:
    -- edge-triggered text/sound on threshold crossings, plus a continuous pulsing outline.
    self:checkMoraleThresholds(millis)
    self:updateZombiePulse(millis)

    -- Check if animation action is still valid/running
    if not self.action or not ZomboDesire_AnimationHandler.currentAnimationAction or ZomboDesire_AnimationHandler.currentAnimationAction ~= self.action then
        self:finish("interrupted")
    end
end

--- Handles the 'X' key press to increase morale
---@param key number
function ZomboLust_MoraleBar:onKeyPress(key)
    if self.isClosed or isGamePaused() then return end

    -- Listen for 'X' key (Keyboard.KEY_X)
    if key == Keyboard.KEY_X then
        self.morale = math.min(100, self.morale + ZomboLust_MoraleSystem.IncreasePerPress)

        ZomboLust.debugLog(MODULE_NAME, "Morale boost: %.2f", self.morale)
    end
end

--- Finalizes the morale mini-game and applies results
---@param result string
function ZomboLust_MoraleBar:finish(result)
    if self.isClosed then return end
    self.isClosed = true

    ZomboLust.debugLog(MODULE_NAME, "finish() called with result=%s (action=%s currentAction=%s)",
        tostring(result), tostring(self.action), tostring(ZomboDesire_AnimationHandler.currentAnimationAction))

    -- Apply final result to character's unhappiness.
    -- The final bar value (0-100) becomes the new morale state.
    -- PZ UnhappynessLevel: 0 = Happy, 100 = Depressed.
    -- Our morale: 100 = Happy, 0 = Depressed.
    -- Casual (1) difficulty ignores unhappiness changes.
    local difficultyLevel = getDifficultyLevel()
    if difficultyLevel > 1 then
        local stats = self.character:getStats()
        local newUnhappiness = 100 - self.morale

        -- Masochist: being overwhelmed (low morale) is a source of comfort, not distress
        local traitMasochist = ZomboLustRegistries.Traits.Masochist
        if traitMasochist and self.character:hasTrait(traitMasochist) then
            newUnhappiness = self.morale
        end

        stats:set(CharacterStat.UNHAPPINESS, newUnhappiness)

        ZomboLust.debugLog(MODULE_NAME, "Morale game finished. Final Morale: %.2f | New PZ Unhappiness: %.2f", self.morale, newUnhappiness)
    else
        ZomboLust.debugLog(MODULE_NAME, "Morale game finished. Difficulty is Casual: Unhappiness not updated.")
    end

    self:setVisible(false)
    self:removeFromUIManager()

    if self.onKeyDown then
        Events.OnKeyStartPressed.Remove(self.onKeyDown)
        self.onKeyDown = nil
    end

    -- Clear the pulsing outline so it doesn't linger on the zombie after the bar closes
    if self.zombie and self.zombie:isAlive() then
        self.zombie:setHighlighted(false)
    end

    -- Apply penalties only if the validation mini-game was a success (animation continues)
    if result == "success" then
        ZomboLust_MoraleSystem.FinalMoraleAtEndOfMiniGame = self.morale
        ZomboLust_MoraleSystem.FinalZombieAtEndOfMiniGame = self.zombie
        ZomboLust_MoraleSystem.FinalZombieStartHealthAtEndOfMiniGame = self.zombieStartHealth
        -- ZomboLust_MoraleSystem.ApplyFinalPenalties(self.character, self.morale) -- We delay this until cleanup
    else
        ZomboLust_MoraleSystem.FinalMoraleAtEndOfMiniGame = nil
        ZomboLust_MoraleSystem.FinalZombieAtEndOfMiniGame = nil
        ZomboLust_MoraleSystem.FinalZombieStartHealthAtEndOfMiniGame = nil
    end
end

-- =============
-- Launch Logic
-- =============

--- Launches the morale mini-game for a player
---@param character IsoPlayer
---@param action ISZomboDesireAnimationAction
---@return ZomboLust_MoraleBar
function ZomboLust_MoraleSystem.Launch(character, action)
    local width = 160
    local height = 250

    -- Position: Fixed right of player
    local screenW = getCore():getScreenWidth()
    local screenH = getCore():getScreenHeight()
    local x = (screenW / 2) + 120 -- 120 pixels to the right of center
    local y = (screenH / 2) - (height / 2)

    ---@type ZomboLust_MoraleBar
    local ui = ZomboLust_MoraleBar:new(x, y, width, height, character, action)
    ui:initialise()
    ui:addToUIManager()

    ZomboLust_MoraleSystem.BarUI = ui

    -- Keyboard listener
    ui.onKeyDown = function(key)
        if ui and ui:getIsVisible() then
            ui:onKeyPress(key)
        end
    end
    Events.OnKeyStartPressed.Add(ui.onKeyDown)

    return ui
end

print("[ZomboLust] Morale UI Initialized")
