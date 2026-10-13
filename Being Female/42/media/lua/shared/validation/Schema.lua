local ____lualib = require('lualib_bundle')
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local __TS__NumberIsInteger = ____lualib.__TS__NumberIsInteger
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
--- Validates that a runtime value is a non-null Lua table/object.
____exports.record = function(value) return type(value) == "table" and value ~= nil end
--- Validates a runtime boolean value.
____exports.boolean = function(value) return type(value) == "boolean" end
--- Creates a validator for finite numbers within optional inclusive bounds.
-- 
-- @param options Optional minimum and maximum values.
-- @returns Validator for bounded finite numbers.
____exports.number = function(____bindingPattern0)
    if ____bindingPattern0 == nil then
        ____bindingPattern0 = {}
    end
    local maximum
    local minimum
    minimum = ____bindingPattern0.minimum
    maximum = ____bindingPattern0.maximum
    return function(value)
        if type(value) ~= "number" or not __TS__NumberIsFinite(value) then
            return false
        end
        if minimum ~= nil and value < minimum then
            return false
        end
        if maximum ~= nil and value > maximum then
            return false
        end
        return true
    end
end
--- Creates a validator for finite integers within optional inclusive bounds.
-- 
-- @param options Optional minimum and maximum values.
-- @returns Validator for bounded finite integers.
____exports.integer = function(____bindingPattern0)
    if ____bindingPattern0 == nil then
        ____bindingPattern0 = {}
    end
    local maximum
    local minimum
    minimum = ____bindingPattern0.minimum
    maximum = ____bindingPattern0.maximum
    return function(value)
        if type(value) ~= "number" or not __TS__NumberIsFinite(value) or not __TS__NumberIsInteger(value) then
            return false
        end
        if minimum ~= nil and value < minimum then
            return false
        end
        if maximum ~= nil and value > maximum then
            return false
        end
        return true
    end
end
--- Validates any finite integer.
____exports.finiteInteger = ____exports.integer()
--- Validates a finite integer greater than or equal to zero.
____exports.nonNegativeInteger = ____exports.integer({minimum = 0})
--- Validates a finite integer greater than zero.
____exports.positiveInteger = ____exports.integer({minimum = 1})
--- Creates a validator for a field that may be absent from a Lua table.
-- 
-- @param validator Validator used when the field is present.
-- @returns Validator accepting either an absent value or the supplied value shape.
____exports.optional = function(validator)
    return function(value) return value == nil or validator(value) end
end
--- Creates a validator for strings within optional inclusive length bounds.
-- 
-- @param options Optional minimum and maximum string lengths.
-- @returns Validator for bounded strings.
____exports.string = function(____bindingPattern0)
    if ____bindingPattern0 == nil then
        ____bindingPattern0 = {}
    end
    local maximumLength
    local minimumLength
    minimumLength = ____bindingPattern0.minimumLength
    maximumLength = ____bindingPattern0.maximumLength
    return function(value)
        if type(value) ~= "string" then
            return false
        end
        if minimumLength ~= nil and #value < minimumLength then
            return false
        end
        if maximumLength ~= nil and #value > maximumLength then
            return false
        end
        return true
    end
end
--- Creates a validator that accepts one value from a fixed set.
-- 
-- @param values Supported literal or enum values.
-- @returns Validator for members of the supplied set.
____exports.oneOf = function(values)
    return function(value)
        for ____, supported in ipairs(values) do
            if value == supported then
                return true
            end
        end
        return false
    end
end
--- Validates a Lua table/object that contains no keys.
____exports.emptyRecord = function(value) return ____exports.record(value) and #__TS__ObjectKeys(value) == 0 end
--- Creates a validator for a nested object shape.
-- Unknown additional fields are allowed so schema-versioned envelopes remain forward-compatible.
-- 
-- @param shape Validator for every required property.
-- @returns Validator for objects containing the required validated properties.
____exports.object = function(shape)
    return function(value)
        if not ____exports.record(value) then
            return false
        end
        local keys = __TS__ObjectKeys(shape)
        for ____, key in ipairs(keys) do
            local validate = shape[key]
            if not validate(value[key]) then
                return false
            end
        end
        return true
    end
end
return ____exports
