local ____lualib = require('lualib_bundle')
local __TS__New = ____lualib.__TS__New
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____BFUITabDefinition = require('BF/components/UI/BFUITabDefinition')
local BFUITabDefinition = ____BFUITabDefinition.BFUITabDefinition
local ____LactationTab = require('BF/components/UI/tabs/LactationTab')
local LactationTab = ____LactationTab.LactationTab
local ____WombTab = require('BF/components/UI/tabs/WombTab')
local WombTab = ____WombTab.WombTab
____exports.BFUITabDefinition = BFUITabDefinition
____exports.LactationTab = LactationTab
____exports.WombTab = WombTab
--- Default set of BF UI tabs (order matters).
____exports.defaultBFUITabs = {
    __TS__New(WombTab),
    __TS__New(LactationTab)
}
return ____exports
