local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local getText = ____pipewrench.getText
local triggerEvent = ____pipewrench.triggerEvent
local ____Animation = require('ZLBF/components/Animation')
local Animation = ____Animation.Animation
local ____Player = require('ZLBF/components/Player')
local Player = ____Player.Player
local ____Utils = require('ZLBF/Utils')
local valueInMilliliters = ____Utils.valueInMilliliters
local ____ZLBFUITabDefinition = require('ZLBF/components/UI/ZLBFUITabDefinition')
local ZLBFUITabDefinition = ____ZLBFUITabDefinition.ZLBFUITabDefinition
local _____40constants = require('constants')
local ZLBFEventsEnum = _____40constants.ZLBFEventsEnum
local ZLBFTraitsEnum = _____40constants.ZLBFTraitsEnum
--- Tab implementation for the Womb tab.
____exports.WombTab = __TS__Class()
local WombTab = ____exports.WombTab
WombTab.Type = "WombTab"
__PW__ClassExtendsPatch(WombTab, ZLBFUITabDefinition)
__TS__ClassExtends(WombTab, ZLBFUITabDefinition)
function WombTab.prototype.____constructor(self, ...)
    ZLBFUITabDefinition.prototype.____constructor(self, ...)
    self.id = "Womb"
    self.TITLE_KEY = "IGUI_ZLBF_UI_Womb_Title"
    self.ELEMENTS = {womb = {title = "womb-title", image = "womb-image"}, sperm = {currentTitle = "womb-sperm-current-title", currentAmount = "womb-sperm-current-amount", totalTitle = "womb-sperm-total-title", totalAmount = "womb-sperm-total-amount"}, cycle = {title = "womb-cycle-title", phaseTitle = "womb-cycle-phase-title", phaseValue = "womb-cycle-phase-value"}, fertility = {title = "womb-fertility-title", levelValue = "womb-fertility-level-value", levelImage = "womb-fertility-level-image", eggImage = "womb-fertility-egg-image"}}
end
function WombTab.prototype.build(self, ui, context)
    ui:nextLine()
    ui:addImage(self.ELEMENTS.womb.image, "media/ui/womb/normal/womb_normal_0.png")
    ui:nextLine()
    ui:addText(
        self.ELEMENTS.sperm.currentTitle,
        getText("IGUI_ZLBF_UI_Current"),
        nil,
        "Center"
    )
    ui:addText(self.ELEMENTS.sperm.currentAmount, "0 ml", nil, "Center")
    ui:nextLine()
    ui:addText(
        self.ELEMENTS.sperm.totalTitle,
        getText("IGUI_ZLBF_UI_Total"),
        nil,
        "Center"
    )
    ui:addText(self.ELEMENTS.sperm.totalAmount, "0 ml", nil, "Center")
    ui:nextLine()
    if not context.player or not Player:hasTrait(context.player, ZLBFTraitsEnum.INFERTILE) then
        ui:addText(
            self.ELEMENTS.fertility.title,
            getText("IGUI_ZLBF_UI_Fertility"),
            nil,
            "Center"
        )
        ui:nextLine()
        ui:addText(self.ELEMENTS.fertility.levelValue, "100%", nil, "Center")
        ui:addImage(self.ELEMENTS.fertility.levelImage, "media/ui/fertility/level/fertility_level_5.png")
        ui:addImage(self.ELEMENTS.fertility.eggImage, "media/ui/fertility/egg/egg_default.png", {height = 26})
        ui:nextLine()
    end
    ui:addText(
        self.ELEMENTS.cycle.title,
        getText("IGUI_ZLBF_UI_Cycle"),
        nil,
        "Center"
    )
    ui:nextLine()
    ui:addText(
        self.ELEMENTS.cycle.phaseTitle,
        getText("IGUI_ZLBF_UI_Phase"),
        nil,
        "Center"
    )
    ui:addText(self.ELEMENTS.cycle.phaseValue, "", nil, "Center")
end
function WombTab.prototype.update(self, ui, context)
    if not context.womb then
        return
    end
    local ____context_womb_0 = context.womb
    local phaseTranslation = ____context_womb_0.phaseTranslation
    local fertility = ____context_womb_0.fertility
    local amount = ____context_womb_0.amount
    local total = ____context_womb_0.total
    local fertilityLevelStatus = ____context_womb_0.fertilityLevelStatus
    local ____opt_1 = context.pregnancy
    local pregnancy = ____opt_1 and ____opt_1.pregnancy
    triggerEvent(ZLBFEventsEnum.IMAGE)
    local ____opt_3 = ui[self.ELEMENTS.sperm.currentAmount]
    if ____opt_3 ~= nil then
        ____opt_3:setText(valueInMilliliters(amount))
    end
    local ____opt_5 = ui[self.ELEMENTS.sperm.totalAmount]
    if ____opt_5 ~= nil then
        ____opt_5:setText(valueInMilliliters(total))
    end
    local ____opt_7 = ui[self.ELEMENTS.womb.image]
    if ____opt_7 ~= nil then
        ____opt_7:setPath(Animation.wombImage)
    end
    if not context.player or Player:hasTrait(context.player, ZLBFTraitsEnum.INFERTILE) then
        return
    end
    local ____opt_9 = ui[self.ELEMENTS.cycle.phaseValue]
    if ____opt_9 ~= nil then
        ____opt_9:setText(getText(phaseTranslation))
    end
    local progress = pregnancy and pregnancy.progress or fertility
    local ____opt_11 = ui[self.ELEMENTS.fertility.levelValue]
    if ____opt_11 ~= nil then
        ____opt_11:setText(tostring(math.floor(progress * 100)) .. "%")
    end
    local ____opt_13 = ui[self.ELEMENTS.fertility.levelImage]
    if ____opt_13 ~= nil then
        ____opt_13:setPath(("media/ui/fertility/level/fertility_level_" .. tostring(fertilityLevelStatus)) .. ".png")
    end
    local eggImage = type(fertilityLevelStatus) ~= "number" and fertilityLevelStatus or "default"
    local ____opt_15 = ui[self.ELEMENTS.fertility.eggImage]
    if ____opt_15 ~= nil then
        ____opt_15:setPath(("media/ui/fertility/egg/egg_" .. eggImage) .. ".png")
    end
end
return ____exports
