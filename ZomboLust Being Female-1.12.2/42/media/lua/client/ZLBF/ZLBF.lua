local ____lualib = require('lualib_bundle')
local __TS__New = ____lualib.__TS__New
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____Lactation = require('ZLBF/components/Lactation')
local Lactation = ____Lactation.Lactation
local ____Womb = require('ZLBF/components/Womb')
local Womb = ____Womb.Womb
local ____ZLBFUI = require('ZLBF/components/ZLBFUI')
local ZLBFUI = ____ZLBFUI.ZLBFUI
local ____Pregnancy = require('ZLBF/components/Pregnancy')
local Pregnancy = ____Pregnancy.Pregnancy
local ____ContextMenu = require('ZLBF/components/ContextMenu')
local ContextMenu = ____ContextMenu.ContextMenu
local ____Animation = require('ZLBF/components/Animation')
local Animation = ____Animation.Animation
____exports.lactation = __TS__New(Lactation)
____exports.womb = __TS__New(Womb)
____exports.pregnancy = __TS__New(Pregnancy)
____exports.animation = __TS__New(Animation, ____exports.womb)
____exports.UI = __TS__New(ZLBFUI, {lactation = ____exports.lactation, pregnancy = ____exports.pregnancy, womb = ____exports.womb})
____exports.contextMenu = __TS__New(ContextMenu, {lactation = ____exports.lactation, pregnancy = ____exports.pregnancy, womb = ____exports.womb, options = {}})
return ____exports
