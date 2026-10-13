--- Animation Event Handler: Dynamic Female Voice Sound Effect
--- This function is called when a specific animation frame marker is reached.
--- It automatically detects the player's voice type and plays the corresponding sound.
--- Note: Both parameters must be kept even if unused to maintain compatibility with the animation event system

local VoiceUtils = require("AnimationEvents/ZomboLust_VoiceUtils")

---@param action ISZomboDesireAnimationAction -- The animation action instance that triggered this event
---@param parameter string -- The event name passed by the animation system (unused but required for API consistency)
---@return nil
return function(action, parameter)
	-- Get the sound name using voice detection utility
	-- Example: Janine -> JanineRapeScreamDryShort, Caseyjo -> CaseyjoRapeScreamDryShort
	local soundName = VoiceUtils.GetSoundName(action.character, "RapeScreamDryShort")

	-- Play the sound
	action.character:playSound(soundName)
end