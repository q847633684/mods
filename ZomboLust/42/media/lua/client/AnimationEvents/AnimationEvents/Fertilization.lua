--- File: ZomboLust/42/media/lua/client/AnimationEvents/AnimationEvents/Fertilization.lua
--- Dummy event handler for Fertilization.
--- This file is used when the "ZomboLust Being Female" sub-mod is NOT enabled.
--- When "ZomboLust Being Female" IS enabled, its own Fertilization.lua will override this one.

---@param action table -- The animation action instance
---@param parameter string -- Event parameter
---@return nil
return function(action, parameter)
    -- This event is intentionally empty in the core mod.
    -- It is handled by the "ZomboLust Being Female" sub-mod.
    -- print("[ZomboLust] Fertilization event triggered but sub-mod 'ZomboLust Being Female' is not active.")
end
