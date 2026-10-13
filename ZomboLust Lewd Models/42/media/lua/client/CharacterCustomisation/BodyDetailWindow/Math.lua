--- File: ZomboLust Lewd Models/42/media/lua/client/CharacterCustomisation/BodyDetailWindow/Math.lua
--- Taken from Improved Hair Menu by duckduckquak
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

--- @class SpnCharCustomMath
SpnCharCustomMath = SpnCharCustomMath or {}
--- @class SpnCharCustomMathUtils
SpnCharCustomMath.math = SpnCharCustomMath.math or {}

--- Wraps a value within a min and max range
--- @param value number
--- @param min number
--- @param max number
--- @return number
function SpnCharCustomMath.math.wrap(value, min, max)
    if value < min then
        return max
    elseif value > max then
        return min
    else
        return value
    end
end

--- Returns the sign of a number
--- @param x number
--- @return number
function SpnCharCustomMath.math.sign(x)
    return x>0 and 1 or x<0 and -1 or 0
end

--- Clamps a value between a min and max range
--- @param value number
--- @param min number
--- @param max number
--- @return number
function SpnCharCustomMath.math.clamp(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    else
        return value
    end
end

return SpnCharCustomMath
