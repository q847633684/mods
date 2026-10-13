--- Animation Event Handler: Dynamic Female Voice Sound Effect
--- This function is called when a specific animation frame marker is reached.
--- It automatically detects the player's voice type and plays the corresponding sound.
--- Also applies the ZomboLust "Everydrop" trait effect: this event only ever fires once per
--- "End" category animation, at the moment of an internal oral ejaculation + swallow.
--- Note: Both parameters must be kept even if unused to maintain compatibility with the animation event system

local VoiceUtils = require("AnimationEvents/ZomboLust_VoiceUtils")

-- Module name for logging
--- @type string
local MODULE_NAME = "Everydrop"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
	return ZomboLust.isDebug(MODULE_NAME)
end

--- Hunger relieved (roughly one Moodle level) when Everydrop triggers
--- @type number
local EVERYDROP_HUNGER_RELIEF = 0.2

--- Chance (1-100) of a food poisoning bout when Everydrop triggers
--- @type number
local EVERYDROP_POISON_CHANCE = 25

--- Food Sickness increase (0-100 scale) on a failed roll
--- @type number
local EVERYDROP_POISON_SEVERITY = 30

--- Applies the Everydrop trait effect to a player who just swallowed
--- @param player IsoPlayer
local function applyEverydrop(player)
	local traits = ZomboLustRegistries.Traits
	if not traits or not traits.Everydrop or not player:hasTrait(traits.Everydrop) then return end

	local stats = player:getStats()

	-- 1. Reduce hunger (character is less hungry, but not sated)
	local currentHunger = stats:get(CharacterStat.HUNGER)
	stats:set(CharacterStat.HUNGER, math.max(0, currentHunger - EVERYDROP_HUNGER_RELIEF))

	-- 2. Roll for food poisoning
	local roll = ZombRand(1, 101) -- 1 to 100 inclusive
	local gotSick = roll <= EVERYDROP_POISON_CHANCE
	if gotSick then
		local currentSickness = stats:get(CharacterStat.FOOD_SICKNESS)
		stats:set(CharacterStat.FOOD_SICKNESS, math.min(100, currentSickness + EVERYDROP_POISON_SEVERITY))
	end

	if dbg() then
		ZomboLust.debugLog(MODULE_NAME, "Everydrop triggered: Hunger %.2f -> %.2f, Poison Roll: %d (Chance: %d%%, Sick: %s)",
			currentHunger, stats:get(CharacterStat.HUNGER), roll, EVERYDROP_POISON_CHANCE, tostring(gotSick))
	end
end

---@param action ISZomboDesireAnimationAction -- The animation action instance that triggered this event
---@param parameter string -- The event name passed by the animation system (unused but required for API consistency)
---@return nil
return function(action, parameter)
	local player = action.character

	-- Get the sound name using voice detection utility
	-- Example: Janine -> JanineFellatioSwallow, Caseyjo -> CaseyjoFellatioSwallow
	local soundName = VoiceUtils.GetSoundName(player, "FellatioSwallow")

	-- Play the sound
	player:playSound(soundName)

	-- ZomboLust "Everydrop" trait: no-op if the player doesn't have it
	if player and not player:isZombie() then
		---@cast player IsoPlayer
		applyEverydrop(player)
	end
end