local ____lualib = require('lualib_bundle')
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local ____exports = {}
--- Converts a fractional value in liters to whole milliliters.
-- Rounds to the nearest integer.
-- 
-- @param value - The value in liters (e.g., 0.25 for 250ml).
-- @returns The rounded milliliter amount, e.g., `250`.
____exports.valueInMilliliters = function(value) return math.floor(value * 1000 + 0.5) end
--- Given a percentage and an arbitrary number, returns the corresponding number between 0 and the number
-- 
-- @param percentage the percentage to be converted into an arbirary number
-- @param maxNumber the number that represents the Max
-- @returns
____exports.percentageToNumber = function(percentage, maxNumber)
    percentage = math.min(100, percentage)
    percentage = math.max(0, percentage)
    return math.floor(percentage / 100 * maxNumber)
end
--- Applies a positive delta to a value with optional upper bound,
-- ensuring the result never decreases below the current value.
-- 
-- This is the core invariant for effect application:
-- - Values are only increased (never reduced)
-- - A delta is added to the current value
-- - The result can be capped by `max` if provided
-- 
-- @param current - The current value.
-- @param delta - The amount to add. Negative values are effectively ignored.
-- @param max - Optional upper bound for the resulting value.
-- @returns The updated value, guaranteed to be >= current.
____exports.increaseClamped = function(current, delta, max)
    local next = current + math.max(0, delta)
    local bounded = max ~= nil and math.min(max, next) or next
    return math.max(current, bounded)
end
--- Repeats a frame sequence a fixed number of times using TSTL-safe loops.
-- 
-- @param steps The sequence of frame indices to repeat.
-- @param times The number of times to repeat the sequence.
-- @returns A new array with the repeated sequence.
-- @remarks This function is necessary because TSTL does not support certain array methods like `new Array(times)`.
____exports.repeatArray = function(steps, times)
    local result = {}
    do
        local i = 0
        while i < times do
            for ____, step in ipairs(steps) do
                result[#result + 1] = step
            end
            i = i + 1
        end
    end
    return result
end
--- Creates an array of sequential numbers from 0 to length - 1.
-- 
-- @param length The length of the array to create.
-- @returns An array containing numbers from 0 to length - 1.
____exports.createArray = function(length)
    local steps = {}
    do
        local index = 0
        while index < length do
            steps[#steps + 1] = index
            index = index + 1
        end
    end
    return steps
end
--- Trims the module prefix from an item name.
-- For example, "BF.Condom" becomes "Condom".
-- 
-- @param name The full name with module prefix.
-- @returns The trimmed item name without the module prefix.
____exports.trimModuleName = function(name)
    local parts = __TS__StringSplit(name, ".")
    return parts[#parts]
end
return ____exports
