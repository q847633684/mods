local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local getText = ____pipewrench.getText
local ____BFUITabDefinition = require('BF/components/UI/BFUITabDefinition')
local BFUITabDefinition = ____BFUITabDefinition.BFUITabDefinition
local ____Utils = require('BF/Utils')
local valueInMilliliters = ____Utils.valueInMilliliters
--- Tab implementation for the Lactation tab.
____exports.LactationTab = __TS__Class()
local LactationTab = ____exports.LactationTab
LactationTab.Type = "LactationTab"
__PW__ClassExtendsPatch(LactationTab, BFUITabDefinition)
__TS__ClassExtends(LactationTab, BFUITabDefinition)
function LactationTab.prototype.____constructor(self, ...)
    BFUITabDefinition.prototype.____constructor(self, ...)
    self.id = "Lactation"
    self.TITLE_KEY = "IGUI_BF_UI_Lactation_Title"
    self.ELEMENTS = {image = "lactation-image", title = "lactation-title", level = "lactation-level", amount = "lactation-amount"}
end
function LactationTab.prototype.build(self, ui, context)
    local ____ = context
    ui:addImage(self.ELEMENTS.image, "media/ui/lactation/boobs/color-0/normal_empty.png")
    ui:nextLine()
    ui:addText(
        self.ELEMENTS.title,
        getText("IGUI_BF_UI_Milk_Amount"),
        nil,
        "Center"
    )
    ui:addImage(self.ELEMENTS.level, "media/ui/lactation/level/milk_level_0.png")
    ui:addText(self.ELEMENTS.amount, "0 ml", nil, "Center")
end
function LactationTab.prototype.update(self, ui, context)
    if not context.lactation then
        return
    end
    local ____context_lactation_0 = context.lactation
    local images = ____context_lactation_0.images
    local milkAmount = ____context_lactation_0.milkAmount
    local ____images_1 = images
    local breasts = ____images_1.breasts
    local level = ____images_1.level
    local ____opt_2 = ui[self.ELEMENTS.image]
    if ____opt_2 ~= nil then
        ____opt_2:setPath(breasts)
    end
    local ____opt_4 = ui[self.ELEMENTS.level]
    if ____opt_4 ~= nil then
        ____opt_4:setPath(level)
    end
    local ____opt_6 = ui[self.ELEMENTS.amount]
    if ____opt_6 ~= nil then
        ____opt_6:setText(tostring(valueInMilliliters(milkAmount)) .. " ml")
    end
end
return ____exports
