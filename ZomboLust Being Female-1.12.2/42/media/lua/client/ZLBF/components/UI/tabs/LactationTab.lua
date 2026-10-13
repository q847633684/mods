local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local getText = ____pipewrench.getText
local ____ZLBFUITabDefinition = require('ZLBF/components/UI/ZLBFUITabDefinition')
local ZLBFUITabDefinition = ____ZLBFUITabDefinition.ZLBFUITabDefinition
--- Tab implementation for the Lactation tab.
____exports.LactationTab = __TS__Class()
local LactationTab = ____exports.LactationTab
LactationTab.Type = "LactationTab"
__PW__ClassExtendsPatch(LactationTab, ZLBFUITabDefinition)
__TS__ClassExtends(LactationTab, ZLBFUITabDefinition)
function LactationTab.prototype.____constructor(self, ...)
    ZLBFUITabDefinition.prototype.____constructor(self, ...)
    self.id = "Lactation"
    self.TITLE_KEY = "IGUI_ZLBF_UI_Lactation_Title"
    self.ELEMENTS = {image = "lactation-image", title = "lactation-title", level = "lactation-level"}
end
function LactationTab.prototype.build(self, ui, context)
    ui:addImage(self.ELEMENTS.image, "media/ui/lactation/boobs/color-0/normal_empty.png")
    ui:nextLine()
    ui:addText(
        self.ELEMENTS.title,
        getText("IGUI_ZLBF_UI_Milk_Amount"),
        nil,
        "Center"
    )
    ui:addImage(self.ELEMENTS.level, "media/ui/lactation/level/milk_level_0.png")
end
function LactationTab.prototype.update(self, ui, context)
    if not context.lactation then
        return
    end
    local ____context_lactation_images_0 = context.lactation.images
    local breasts = ____context_lactation_images_0.breasts
    local level = ____context_lactation_images_0.level
    local ____opt_1 = ui[self.ELEMENTS.image]
    if ____opt_1 ~= nil then
        ____opt_1:setPath(breasts)
    end
    local ____opt_3 = ui[self.ELEMENTS.level]
    if ____opt_3 ~= nil then
        ____opt_3:setPath(level)
    end
end
return ____exports
