local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
--- Abstract base class for a UI tab in the ZLBF system.
-- 
-- Extend this class to implement a new tab. Each tab must define its unique id, TITLE_KEY,
-- and implement the build and update methods.
____exports.ZLBFUITabDefinition = __TS__Class()
local ZLBFUITabDefinition = ____exports.ZLBFUITabDefinition
ZLBFUITabDefinition.Type = "ZLBFUITabDefinition"
__PW__BaseClassExtends(ZLBFUITabDefinition)
function ZLBFUITabDefinition.prototype.____constructor(self)
end
return ____exports
