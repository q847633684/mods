local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local __TS__New = ____lualib.__TS__New
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____BFSandboxOptions = require('components/BFSandboxOptions')
local configuredLactationDurationHours = ____BFSandboxOptions.configuredLactationDurationHours
local DEFAULT_OPTIONS = {pregnancy = {duration = 14, recovery = 7}, womb = {capacity = 1}, milk = {expiration = 7, capacity = 1}}
--- Base class for accessing sandbox options with type safety and default fallbacks.
local SandboxOptions = __TS__Class()
SandboxOptions.Type = "SandboxOptions"
__PW__BaseClassExtends(SandboxOptions)
function SandboxOptions.prototype.____constructor(self)
end
function SandboxOptions.prototype.getOption(self, selector, fallback)
    local globals = _G
    local ____selector_2 = selector
    local ____opt_0 = globals.SandboxVars
    local value = ____selector_2(____opt_0 and ____opt_0.BF or ({}))
    return value or fallback
end
--- Pregnancy-specific sandbox options.
local PregnancyOptionsClass = __TS__Class()
PregnancyOptionsClass.Type = "PregnancyOptionsClass"
__PW__ClassExtendsPatch(PregnancyOptionsClass, SandboxOptions)
__TS__ClassExtends(PregnancyOptionsClass, SandboxOptions)
__TS__SetDescriptor(
    PregnancyOptionsClass.prototype,
    "duration",
    {get = function(self)
        local days = self:getOption(
            function(options) return options.PregnancyDuration end,
            DEFAULT_OPTIONS.pregnancy.duration
        )
        return days * 24 * 60
    end},
    true
)
__TS__SetDescriptor(
    PregnancyOptionsClass.prototype,
    "pregnancyRecovery",
    {get = function(self)
        return self:getOption(
            function(options) return options.PregnancyRecovery end,
            DEFAULT_OPTIONS.pregnancy.recovery
        )
    end},
    true
)
--- Womb-specific sandbox options.
local WombOptionsClass = __TS__Class()
WombOptionsClass.Type = "WombOptionsClass"
__PW__ClassExtendsPatch(WombOptionsClass, SandboxOptions)
__TS__ClassExtends(WombOptionsClass, SandboxOptions)
__TS__SetDescriptor(
    WombOptionsClass.prototype,
    "wombCapacity",
    {get = function(self)
        return self:getOption(
            function(options) return options.WombMaxCapacity end,
            DEFAULT_OPTIONS.womb.capacity
        )
    end},
    true
)
__TS__SetDescriptor(
    WombOptionsClass.prototype,
    "wombRecovery",
    {get = function(self)
        return self:getOption(
            function(options) return options.PregnancyRecovery end,
            DEFAULT_OPTIONS.pregnancy.recovery
        )
    end},
    true
)
--- Milk-specific sandbox options.
local LactationOptionsClass = __TS__Class()
LactationOptionsClass.Type = "LactationOptionsClass"
__PW__ClassExtendsPatch(LactationOptionsClass, SandboxOptions)
__TS__ClassExtends(LactationOptionsClass, SandboxOptions)
__TS__SetDescriptor(
    LactationOptionsClass.prototype,
    "milkCapacity",
    {get = function(self)
        return self:getOption(
            function(options) return options.MilkCapacity end,
            DEFAULT_OPTIONS.milk.capacity
        )
    end},
    true
)
__TS__SetDescriptor(
    LactationOptionsClass.prototype,
    "milkExpiration",
    {get = function(self)
        return configuredLactationDurationHours()
    end},
    true
)
____exports.PregnancyOptions = __TS__New(PregnancyOptionsClass)
____exports.WombOptions = __TS__New(WombOptionsClass)
____exports.LactationOptions = __TS__New(LactationOptionsClass)
return ____exports
