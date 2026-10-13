local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local getSpecificPlayer = ____pipewrench.getSpecificPlayer
local getText = ____pipewrench.getText
local isDebugEnabled = ____pipewrench.isDebugEnabled
local triggerEvent = ____pipewrench.triggerEvent
local ____client = require('lua_modules/@asledgehammer/pipewrench/client')
local ISToolTip = ____client.ISToolTip
local _____40constants = require('constants')
local ZLBFEventsEnum = _____40constants.ZLBFEventsEnum
____exports.ContextMenu = __TS__Class()
local ContextMenu = ____exports.ContextMenu
ContextMenu.Type = "ContextMenu"
__PW__BaseClassExtends(ContextMenu)
function ContextMenu.prototype.____constructor(self, props)
    local ____props_0 = props
    local lactation = ____props_0.lactation
    local pregnancy = ____props_0.pregnancy
    local womb = ____props_0.womb
    local options = ____props_0.options
    self.lactation = lactation
    self.pregnancy = pregnancy
    self.womb = womb
    Events.onFillWorldObjectContextMenu:addListener(function(playerId, context)
        self:createContextMenu({playerId = playerId, context = context, options = options})
        if isDebugEnabled() then
            self:createDebugContextMenu({playerId = playerId, context = context})
        end
    end)
end
function ContextMenu.prototype.addOption(self, props)
    local ____props_1 = props
    local menu = ____props_1.menu
    local title = ____props_1.title
    local description = ____props_1.description
    local fn = ____props_1.fn
    local tooltip = ISToolTip:new()
    tooltip.description = description
    tooltip:instantiate()
    tooltip:setVisible(false)
    local option = menu:addOption(
        title,
        nil,
        function() return fn(nil) end
    )
    option.toolTip = tooltip
end
function ContextMenu.prototype.createContextMenu(self, props)
    local ____props_2 = props
    local playerId = ____props_2.playerId
    local context = ____props_2.context
    local options = ____props_2.options
    local player = getSpecificPlayer(playerId)
    if not player:isFemale() then
        return
    end
    for ____, ____value in ipairs(options) do
        local title = ____value.title
        local description = ____value.description
        local fn = ____value.fn
        self:addOption({menu = context, title = title, description = description, fn = fn})
    end
end
function ContextMenu.prototype.createDebugContextMenu(self, props)
    local ____props_3 = props
    local playerId = ____props_3.playerId
    local context = ____props_3.context
    local option = context:addOption(getText("ContextMenu_ZLBF_Being_Female_Debug_Title"))
    local submenu = ISContextMenu:getNew(context)
    context:addSubMenu(option, submenu)
    local options = __TS__ArrayMap(
        __TS__ArrayFilter(
            {
                {
                    option = "Add_Sperm",
                    fn = function() return self.womb.Debug.sperm.add(0.1) end
                },
                {
                    option = "Remove_Sperm",
                    fn = function() return self.womb.Debug.sperm.set(0) end
                },
                {
                    option = "Reset_Sperm",
                    fn = function() return self.womb.Debug.sperm.setTotal(0) end
                },
                {
                    option = "Add_Cycle_Day",
                    fn = function() return self.womb.Debug.cycle.addDay(1) end,
                    condition = function() return self.pregnancy.pregnancy == nil end
                },
                {
                    option = "Next_Cycle",
                    fn = function() return self.womb.Debug.cycle.nextPhase() end,
                    condition = function() return self.pregnancy.pregnancy == nil end
                },
                {
                    option = "Milk_Toggle",
                    fn = function() return self.lactation.Debug.toggle(not self.lactation.isLactating) end
                },
                {
                    option = "Milk_Add_Milk",
                    fn = function() return self.lactation.Debug.add(self.lactation.bottleAmount) end,
                    condition = function() return self.lactation.isLactating end
                },
                {
                    option = "Milk_Clear_Milk",
                    fn = function() return self.lactation.Debug.set(0) end,
                    condition = function() return self.lactation.isLactating end
                },
                {
                    option = "Add_Pregnancy",
                    fn = function() return triggerEvent(ZLBFEventsEnum.PREGNANCY_START) end,
                    condition = function() return self.pregnancy.pregnancy == nil end
                },
                {
                    option = "Remove_Pregnancy",
                    fn = function() return triggerEvent(ZLBFEventsEnum.PREGNANCY_STOP) end,
                    condition = function() return self.pregnancy.pregnancy ~= nil end
                },
                {
                    option = "Advance_Pregnancy",
                    fn = function() return self.pregnancy.Debug.advance(60 * 24) end,
                    condition = function() return self.pregnancy.pregnancy ~= nil end
                },
                {
                    option = "Advance_Pregnancy_Labor",
                    fn = function() return self.pregnancy.Debug.advanceToLabor() end,
                    condition = function() return self.pregnancy.pregnancy ~= nil end
                },
                {
                    option = "Intercourse",
                    fn = function() return triggerEvent(ZLBFEventsEnum.INTERCOURSE) end
                },
                {
                    option = "Menstrual_Effects",
                    fn = function() return triggerEvent(ZLBFEventsEnum.MENSTRUAL_EFFECTS) end
                }
            },
            function(____, ____bindingPattern0)
                local condition
                condition = ____bindingPattern0.condition
                return not (condition and not condition())
            end
        ),
        function(____, ____bindingPattern0)
            local fn
            local option
            option = ____bindingPattern0.option
            fn = ____bindingPattern0.fn
            return {
                title = getText(("ContextMenu_" .. option) .. "_Title"),
                description = getText(("ContextMenu_" .. option) .. "_Description"),
                fn = fn
            }
        end
    )
    self:createContextMenu({playerId = playerId, context = submenu, options = options})
end
return ____exports
