local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
--- Wrapper around `object.getModData()` to ensure the data can be retrieve type safely
____exports.ModData = __TS__Class()
local ModData = ____exports.ModData
ModData.Type = "ModData"
__PW__BaseClassExtends(ModData)
function ModData.prototype.____constructor(self, ____bindingPattern0)
    local defaultData
    local modKey
    local object
    object = ____bindingPattern0.object
    modKey = ____bindingPattern0.modKey
    defaultData = ____bindingPattern0.defaultData
    self.object = object
    self.modKey = modKey
    self.defaultData = defaultData
end
__TS__SetDescriptor(
    ModData.prototype,
    "data",
    {
        get = function(self)
            if not self.object:getModData()[self.modKey] then
                self.object:getModData()[self.modKey] = self.defaultData
            end
            return self.object:getModData()[self.modKey]
        end,
        set = function(self, value)
            self.object:getModData()[self.modKey] = value
        end
    },
    true
)
return ____exports
