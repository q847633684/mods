--- Animation Event Handler: FemaleMasturbationShlick
--- This function is called when the animation frame marker "FemaleMasturbationShlick" is reached.

---@param action ISZomboDesireAnimationAction -- The animation action instance that triggered this event
---@param parameter string -- Event parameter (unused here)
---@return nil
return function(action, parameter)
    -- Play the sound
    action.character:playSound("FemaleMasturbationShlick")
end
