local ____lualib = require('lualib_bundle')
local __TS__New = ____lualib.__TS__New
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____ZLBFUITabDefinition = require('ZLBF/components/UI/ZLBFUITabDefinition')
local ZLBFUITabDefinition = ____ZLBFUITabDefinition.ZLBFUITabDefinition
local ____LactationTab = require('ZLBF/components/UI/tabs/LactationTab')
local LactationTab = ____LactationTab.LactationTab
local ____WombTab = require('ZLBF/components/UI/tabs/WombTab')
local WombTab = ____WombTab.WombTab
____exports.ZLBFUITabDefinition = ZLBFUITabDefinition
____exports.LactationTab = LactationTab
____exports.WombTab = WombTab
--- Default set of ZLBF UI tabs (order matters).
____exports.defaultZLBFUITabs = {
    __TS__New(WombTab),
    __TS__New(LactationTab)
}
return ____exports
