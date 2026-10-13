--- File: ZomboLust/42/media/lua/client/MiniGame/ZomboLust_MiniGameOverride.lua
--- Overrides ZomboDesire_MiniGame logic with Lust-specific penalties (scratches/health loss)
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_MiniGameOverride.lua loaded")

-- =============
-- Dependencies
-- =============
require "MiniGame/ZomboDesire_MiniGame" -- Ensure the original mini-game is loaded
require "Clothing/ZomboLust_ClothingStripForZombHuman"

--- Module name for logging
---@type string
local MODULE_NAME = "MiniGame"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

-- Loose base-game .wav files (media/sound/PZ_*.wav), same pools as ZomboLust_MoraleUI.lua's reactToThresholdCrossing
-- (duplicated here rather than shared, since that file's locals aren't exported).
-- Note: DISPLEASED, not PLEASED => this fires on mini-game failure, i.e. the zombie failing to catch its victim.
local DISPLEASED_SOUNDS_MALE = { "PZ_MaleDeath_01", "PZ_MaleDeath_02", "PZ_MaleDeath_03", "PZ_MaleDeath_04", "PZ_MaleDeath_05", "PZ_MaleDeath_06", "PZ_MaleDeath_07" }
local DISPLEASED_SOUNDS_FEMALE = { "PZ_Female_zombie_Death_01", "PZ_Female_zombie_Death_02", "PZ_Female_zombie_Death_03", "PZ_Female_zombie_Death_04" }
-- Same value as ZomboLust_MoraleUI.lua's EXCITATION_SOUND_VOLUME (1.0 = normal volume - 0.35 = 35%)
local FAIL_SOUND_VOLUME = 0.35

--- Whether the "invertMinigame" mod option is enabled (default: true).
--- Most players approach these mini-games passively (stay idle to "lose" on purpose) rather than actively aiming for the pink zone.
--- When active, staying idle until timeout lets the scene continue,
--- and stopping the cursor in the pink zone becomes the escape route instead - see the result-swap in Handlers.onEnd below.
--- @return boolean
local function isMinigameInverted()
    local options = PZAPI and PZAPI.ModOptions and PZAPI.ModOptions:getOptions("ZomboLust")
    local option = options and options:getOption("invertMinigame")
    if not option then return false end
    ---@cast option umbrella.ModOptions.TickBox
    return option:getValue() == true
end

-- Save original handler to keep success logic
local originalOnEnd = ZomboDesire_MiniGame.Handlers.onEnd

-- ==========================================================
-- ZomboDesire_MiniGame Extension via Lifecycle Events
-- Influence the pink zone size based on Player's Excitation
-- ==========================================================

--- Rescales the pink zone size (baseline already computed by ZomboDesire_MiniGame:calculateZones) based on the player's current Excitation
--- @param miniGame ZomboDesire_MiniGame
local function onCalculateZones(miniGame)
    local player = miniGame.character
    local excitation = (player and player:getModData().ZL_Excitation) or 0

    -- Size multiplier logic:
    -- 0% -> 0.05 (almost invisible)
    -- 25% -> 1.0 (baseline size)
    -- 50% -> 2.0 (2x size)
    -- 75% -> 3.0 (3x size)
    -- 100% -> 4.0 (4x size)
    ---@type number
    local multiplier = excitation / 25
    if multiplier < 0.05 then multiplier = 0.05 end

    miniGame.pinkSize = math.floor((ZomboDesire_MiniGame.Config.BasePinkSize * multiplier) + 0.5)

    -- Re-roll pinkStart: ZomboDesire_MiniGame:calculateZones already randomized it using the un-scaled baseline pinkSize
    miniGame.pinkStart = ZombRand(10, 90 - miniGame.pinkSize)
end

-- ===========
-- Static Data
-- ===========

-- Map penalties based on difficulty and result
-- NOTE: "timeout" is intentionally 0/0 on every difficulty.
-- Perspective is reframed so the player controls the zombie attacker (see Control Prompt section below): a timeout means the
-- zombie waited too long and its victim got away unscathed, unlike fail_orange/fail_green where
-- the victim escapes but still gets hurt in the process.
-- This map is looked up AFTER the invertMinigame swap in Handlers.onEnd, so with that option active
-- the 0/0 "timeout" tier ends up applying to the pink zone instead (see the swap comment there).
local penaltyMap = {
	[2] = { -- Difficulty Level 2: Normal
		timeout = { health = 0, scratches = 0 },      -- 0% (victim escapes unscathed)
		fail_orange = { health = 5, scratches = 1 },  -- 5%
		fail_green = { health = 2, scratches = 0 }    -- 2%
	},
	[3] = { -- Difficulty Level 3: Vicious
		timeout = { health = 0, scratches = 0 },      -- 0% (victim escapes unscathed)
		fail_orange = { health = 10, scratches = 2 }, -- 10%
		fail_green = { health = 5, scratches = 1 }    -- 5%
	}
}

-- Possible body parts for scratches (arms/hands)
---@type integer[]
local possibleParts = {
	BodyPartType.ToIndex(BodyPartType.UpperArm_L),
	BodyPartType.ToIndex(BodyPartType.UpperArm_R),
	BodyPartType.ToIndex(BodyPartType.ForeArm_L),
	BodyPartType.ToIndex(BodyPartType.ForeArm_R),
	BodyPartType.ToIndex(BodyPartType.Hand_L),
	BodyPartType.ToIndex(BodyPartType.Hand_R)
}

-- ========================================================================
-- Control Prompt (perspective reframing)
-- Displays "You control the zombie! Rape her/him!" between the panel's top
-- edge and the color bar (read first, top-to-bottom) so players understand
-- they're aiming FOR the pink zone as the attacker, not trying to avoid it
-- as the victim.
-- ========================================================================

-- Bold SDF font instead of the panel's usual bitmap font, for extra readability.
-- Vanilla PZ already relies on this exact font (UIFont.SdfBold) to draw translated street
-- name labels on the world map for every supported language (see UIWorldMap.renderStreetLabel),
-- so its glyph coverage - including non-Latin scripts like Thai - is expected to match Large's.
---@type UIFont
local CONTROL_PROMPT_FONT = UIFont.SdfBold

-- SdfBold renders noticeably larger than Large at the same nominal size (it's a different font family, not a bold variant of Large).
-- Scale it down to visually match Large's height instead - cheap and lossless since SDF fonts are distance-field based,
-- so shrinking them never pixelates.
-- Computed once (needs the font system to be ready, so not at file load time) and cached.
local controlPromptZoomCache = nil
--- @return number
local function getControlPromptZoom()
	local zoom = controlPromptZoomCache
	if not zoom then
		local textManager = getTextManager()
		-- getFontHeight has no @return annotation in the type stubs, hence the explicit cast.
		zoom = (textManager:getFontHeight(UIFont.Large) / textManager:getFontHeight(CONTROL_PROMPT_FONT)) --[[@as number]]
		controlPromptZoomCache = zoom
	end
	---@cast zoom number
	return zoom
end

--- Width, in screen pixels, of "text" drawn at CONTROL_PROMPT_FONT with the size-matching zoom applied.
--- @param text string
--- @return number
local function measureControlPromptWidth(text)
	return getTextManager():MeasureStringX(CONTROL_PROMPT_FONT, text) * getControlPromptZoom()
end

-- Pulsing color cycle so the prompt stays noticeable instead of blending into the background:
-- dark red -> light red -> vivid red -> light red -> (loops back to dark red).
-- Each of the 4 stops is held for CONTROL_PROMPT_PULSE_STEP_MS, cross-faded smoothly in between,
-- and timed off getTimestampMs() so the pulse speed is identical regardless of the player's FPS.
local CONTROL_PROMPT_PULSE_STEP_MS = 250
local CONTROL_PROMPT_PULSE_COLORS = {
	{ r = 0.85, g = 0.08, b = 0.08 }, -- dark red (original)
	{ r = 1.00, g = 0.45, b = 0.45 }, -- light red
	{ r = 1.00, g = 0.05, b = 0.05 }, -- vivid red
	{ r = 1.00, g = 0.45, b = 0.45 }, -- light red
}

--- Returns the current pulsing color of the control prompt text, cross-fading between
--- CONTROL_PROMPT_PULSE_COLORS' stops based on real elapsed time.
--- @return number, number, number -- r, g, b (0-1)
local function getControlPromptColor()
	local stopCount = #CONTROL_PROMPT_PULSE_COLORS
	local cycleMs = CONTROL_PROMPT_PULSE_STEP_MS * stopCount
	local elapsedInCycle = getTimestampMs() % cycleMs
	local segmentFloat = elapsedInCycle / CONTROL_PROMPT_PULSE_STEP_MS

	local segmentIndex = math.floor(segmentFloat) + 1
	local localT = segmentFloat - math.floor(segmentFloat)

	local colorA = assert(CONTROL_PROMPT_PULSE_COLORS[segmentIndex])
	local colorB = assert(CONTROL_PROMPT_PULSE_COLORS[(segmentIndex % stopCount) + 1])

	local r = colorA.r + (colorB.r - colorA.r) * localT
	local g = colorA.g + (colorB.g - colorA.g) * localT
	local b = colorA.b + (colorB.b - colorA.b) * localT
	return r, g, b
end

-- NOTE: no permanent Config.MarginY/WindowHeight bump here.
-- The panel's original top gap (Config.MarginY, unmodified) is reused as-is:
-- text HEIGHT only depends on the font/UI scale, not on the language, so one line always fits that original space.
-- Only text WIDTH varies by language, which is already handled below by widening the panel.
-- The one edge case is a language whose translation is long enough to wrap onto 2 lines
-- (see wrapControlPromptText) - prerender below clamps that case so it stays inside the panel
-- instead of overflowing above it, rather than reserving extra height for everyone up front.

--- Splits text into multiple lines so no line exceeds maxWidth at CONTROL_PROMPT_FONT's zoomed size.
--- Used as a fallback for languages whose translation doesn't fit even after widening the panel to its screen-width cap.
--- @param text string
--- @param maxWidth number
--- @return string[]
local function wrapControlPromptText(text, maxWidth)
	local lines = {}
	local currentLine = ""

	for word in text:gmatch("%S+") do
		local candidate = (currentLine == "") and word or (currentLine .. " " .. word)
		if currentLine == "" or measureControlPromptWidth(candidate) <= maxWidth then
			currentLine = candidate
		else
			table.insert(lines, currentLine)
			currentLine = word
		end
	end
	if currentLine ~= "" then
		table.insert(lines, currentLine)
	end

	return lines
end

--- Resizes the panel's width to fit the localized control prompt text and pre-computes the lines/font drawn by the onPrerender extension below
--- @param miniGame ZomboDesire_MiniGame
local function onInitialise(miniGame)
	-- Skip the "you control the zombie" reframing text entirely when invertMinigame is active:
	-- the player is meant to keep thinking of themselves as the victim, idling on purpose to lose.
	if isMinigameInverted() then return end

	local config = ZomboDesire_MiniGame.Config
	local font = CONTROL_PROMPT_FONT

	local msgKey = miniGame.character:isFemale()
		and "IGUI_ZomboLust_MiniGame_ControlPrompt_Female"
		or "IGUI_ZomboLust_MiniGame_ControlPrompt_Male"
	local text = getText(msgKey)

	local maxWidth = (getCore():getScreenWidth() * 0.9) - (config.MarginX * 2)
	local lines = { text }
	local textWidth = measureControlPromptWidth(text)
	if textWidth > maxWidth then
		lines = wrapControlPromptText(text, maxWidth)
		textWidth = 0
		for _, line in ipairs(lines) do
			textWidth = math.max(textWidth, measureControlPromptWidth(line))
		end
	end

	-- Widen the panel (keeping it centered) if the text needs more room than the baseline width,
	-- capped so an extreme language can never overflow the screen.
	local neededWidth = math.min(getCore():getScreenWidth() * 0.9, math.max(config.WindowWidth, textWidth + (config.MarginX * 2)))
	if neededWidth > miniGame.width then
		local centerX = miniGame.x + (miniGame.width / 2)
		miniGame:setWidth(neededWidth)
		miniGame:setX(centerX - (neededWidth / 2))
	end

	-- These fields aren't part of the base framework's class declaration, hence the disables below.
	---@diagnostic disable-next-line: inject-field
	miniGame.controlPromptLines = lines
	---@diagnostic disable-next-line: inject-field
	miniGame.controlPromptFont = font
end

--- Draws the control prompt text in the reserved band above the bar
--- @param miniGame ZomboDesire_MiniGame
local function onPrerender(miniGame)
	---@diagnostic disable-next-line: undefined-field
	local promptLines = miniGame.controlPromptLines
	if not promptLines then return end

	---@diagnostic disable-next-line: undefined-field
	local font = miniGame.controlPromptFont or CONTROL_PROMPT_FONT
	local zoom = getControlPromptZoom()
	local fontHeight = getTextManager():getFontHeight(font) * zoom

	-- Vertically center the text block within the panel's original top gap (above the bar).
	-- Clamped to a small minimum so a rare 2-line wrap doesn't push above the panel's top edge.
	local blockHeight = fontHeight * #promptLines
	local startY = math.max(2.0, (ZomboDesire_MiniGame.Config.MarginY - blockHeight) / 2)

	local pulseR, pulseG, pulseB = getControlPromptColor()
	for i, line in ipairs(promptLines) do
		-- drawTextCentre has no zoomed variant, so center manually against the zoomed width.
		local lineX = (miniGame.width / 2) - (measureControlPromptWidth(line) / 2)
		local lineY = startY + ((i - 1) * fontHeight)
		miniGame:drawTextZoomed(line, lineX, lineY, zoom, pulseR, pulseG, pulseB, 1, font)
	end
end

-- Ensure the events exist before subscribing (ZomboDesire must be loaded and up to date)
if Events.OnZomboDesireMiniGameCalculateZones and Events.OnZomboDesireMiniGameInitialise and Events.OnZomboDesireMiniGamePrerender then
	Events.OnZomboDesireMiniGameCalculateZones.Add(onCalculateZones)
	Events.OnZomboDesireMiniGameInitialise.Add(onInitialise)
	Events.OnZomboDesireMiniGamePrerender.Add(onPrerender)
else
	ZomboLust.errorLog(MODULE_NAME, "ZomboDesire mini-game lifecycle events not found (ZomboDesire missing or outdated)! Excitation-scaled zones and control prompt disabled.")
end

--- Stops the current animation sequence
--- @param action ISBaseTimedAction|nil -- The action to stop
local function stopAnimationAction(action)
	if not action or not action.forceStop then return end
	
	-- Check if stage changed in the meantime
	local currentAction = ZomboDesire_AnimationHandler.currentAnimationAction
	if currentAction and currentAction.forceStop then
		currentAction:forceStop()
	else
		action:forceStop()
	end
end

-- New handler for ZomboLust.
-- Unlike calculateZones/initialise/prerender above, this is NOT a monkey-patch:
-- Handlers.onEnd is a plain table field that ZomboDesire_MiniGame:finish() re-reads on every call
-- (see the comment on ZomboDesire_MiniGame.Handlers in ZomboDesire_MiniGame.lua),
-- so reassigning it here is already the framework's intended extension point - no event needed.
ZomboDesire_MiniGame.Handlers.onEnd = function(player, result, action)
	-- invertMinigame: swap "success" (pink zone) and "timeout" before anything else runs,
	-- so every branch below (success stripping, penaltyMap lookup, message/color) applies unchanged to the swapped outcome.
	-- fail_orange/fail_green are untouched by design.
	-- This also means the swap is difficulty-agnostic: penaltyMap[level]["timeout"] is 0/0 on every difficulty tier,
	-- so the pink zone becomes the "escape unscathed" outcome regardless of Normal/Vicious.
	if isMinigameInverted() then
		if result == "timeout" then
			result = "success"
		elseif result == "success" then
			result = "timeout"
		end
	end

	-- Success logic
	if result == "success" then
		-- Strip the ZombHuman before the sequence continues (animation Stage 2)
		local zombHuman = (action and action.stageConfig and action.stageConfig.zombHuman) or ZomboDesire_AnimationHandler.currentZombHuman
		if zombHuman then
			if dbg() then
				ZomboLust.debugLog(MODULE_NAME, "Success! Stripping ZombHuman %s", zombHuman:getModData().isZombHuman and "ZombHuman" or "Zombie")
			end
			ZomboLust_ClothingStripForZombHuman.stripZombHuman(zombHuman)
		else
			ZomboLust.warningLog(MODULE_NAME, "Mini-game success but no ZombHuman found to strip!")
		end

		-- ZomboLust: Track partner count for the Swinger trait (24h window)
		if ZomboLust_ExcitationSystem and ZomboLust_ExcitationSystem.incrementSwingerPartnerCount then
			ZomboLust_ExcitationSystem.incrementSwingerPartnerCount(player)
		end

		-- Temporary override of the success message key to use Lust's message
		local oldMsg = ZomboDesire_MiniGame.Config.MsgSuccess
		ZomboDesire_MiniGame.Config.MsgSuccess = "IGUI_ZomboLust_MiniGame_Success"
		
		originalOnEnd(player, result, action)
		
		-- Restore framework default message
		ZomboDesire_MiniGame.Config.MsgSuccess = oldMsg
		-- Report the (possibly invertMinigame-swapped) result back to finish(),
		-- so OnZomboDesireMiniGameFinish carries "success" too, not the raw pre-swap value.
		return result
	end

	-- For Lust, we replace the simple Speech Text with damage/scratches
	local difficultyLevel = 1 -- Default to Casual
	if PZAPI and PZAPI.ModOptions then
		local options = PZAPI.ModOptions:getOptions("ZomboLust")
		local difficultyOption = options and options:getOption("difficulty")
		if difficultyOption then
			---@cast difficultyOption umbrella.ModOptions.ComboBox
			difficultyLevel = difficultyOption:getValue()
		end
	end

	-- Apply penalties only if difficulty is not Casual (1)
    if difficultyLevel > 1 then
        local bodyDamage = player:getBodyDamage()
        local healthDrop = 0
        local scratchesCount = 0

        local currentPenalty = penaltyMap[difficultyLevel] and penaltyMap[difficultyLevel][result]
        if currentPenalty then
            healthDrop = currentPenalty.health
            scratchesCount = currentPenalty.scratches
        end

        -- Apply Health Reduction (General health is 0-100)
        if healthDrop > 0 then
            bodyDamage:ReduceGeneralHealth(healthDrop)
        end

        -- Apply Scratches to random body parts (arms/hands)
        local bodyParts = bodyDamage:getBodyParts()
        for _ = 1, scratchesCount do
            local index = ZombRand(#possibleParts) + 1
            local partIdx = possibleParts[index]
            if partIdx then
                local part = bodyParts:get(partIdx)
                if part then
                    part:setScratched(true, true)
                end
            end
        end
        
        ZomboLust.debugLog(MODULE_NAME, "Penalties applied for difficulty %d.", difficultyLevel)
    else
        ZomboLust.debugLog(MODULE_NAME, "Mini-game failed but difficulty is Casual: No penalties applied.")
    end

	-- Play sound feedback: random gendered groan from the involved zombie
	local zombHumanForSound = (action and action.stageConfig and action.stageConfig.zombHuman) or ZomboDesire_AnimationHandler.currentZombHuman
	if zombHumanForSound then
		---@type string[]
		local pool = zombHumanForSound:isFemale() and DISPLEASED_SOUNDS_FEMALE or DISPLEASED_SOUNDS_MALE
		---@type string
		---@diagnostic disable-next-line: undefined-field, assign-type-mismatch
		local soundName = pool[ZombRand(#pool) + 1]
		local emitter = player:getEmitter()
		local soundId = emitter:playSound(soundName)
		if soundId ~= -1 then
			emitter:setVolume(soundId, FAIL_SOUND_VOLUME)
		end
	end

	-- Visual feedback for the penalty with Speech Text and colors
    local msgKey = ""
    local r, g, b = 1.0, 1.0, 1.0

    if result == "timeout" then
        msgKey = "IGUI_ZomboLust_MiniGame_Timeout"
        r, g, b = 0.0, 1.0, 0.0 -- Green (unscathed escape, same tier as fail_green)
    elseif result == "fail_orange" then
        msgKey = "IGUI_ZomboLust_MiniGame_FailOrange"
        r, g, b = 1.0, 0.5, 0.0 -- Orange
    elseif result == "fail_green" then
        msgKey = "IGUI_ZomboLust_MiniGame_FailGreen"
        r, g, b = 0.0, 1.0, 0.0 -- Green
    end

    if msgKey ~= "" then
        player:addLineChatElement(getText(msgKey), r, g, b)
    end

	-- Always forceStop the action if it exists to terminate the sequence
	stopAnimationAction(action)

	-- Report the (possibly invertMinigame-swapped) result back to finish()
	return result
end

ZomboLust.debugLog(MODULE_NAME, "ZomboDesire_MiniGame logic overridden with injuries and health loss.")
