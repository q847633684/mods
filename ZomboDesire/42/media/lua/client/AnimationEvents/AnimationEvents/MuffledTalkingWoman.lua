--- Animation Event Handler: Sound Effect
--- This function is called when a specific animation frame marker is reached.
--- @param action ISZomboDesireAnimationAction -- The animation action instance that triggered this event
--- @param parameter string -- The event name passed by the animation system (unused but required for API consistency)
--- @return nil
-- Note: Both parameters must be kept even if unused to maintain compatibility with the animation event system
return function(action, parameter)
    action.character:playSound("ZomboDesireMuffledTalkingWoman")
end