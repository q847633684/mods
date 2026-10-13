--- Animation Event Handler: SFX
--- This function is called when a specific animation frame marker is reached.

---@param action ISZomboDesireAnimationAction -- The animation action instance that triggered this event
---@param parameter string -- Event parameter
---@return nil
return function(action, parameter)
    -- Play the sound
    action.character:playSound("SFXSexSquish")
end
