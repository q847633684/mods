local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local getText = ____pipewrench.getText
local pipewrenchRequire = ____pipewrench.require
local Events = require('lua_modules/@asledgehammer/pipewrench-events/PipeWrench-Events')
local ____ZLBFUITabs = require('ZLBF/components/UI/ZLBFUITabs')
local defaultZLBFUITabs = ____ZLBFUITabs.defaultZLBFUITabs
____exports.ZLBFUI = __TS__Class()
local ZLBFUI = ____exports.ZLBFUI
ZLBFUI.Type = "ZLBFUI"
__PW__BaseClassExtends(ZLBFUI)
function ZLBFUI.prototype.____constructor(self, props)
    self.tabs = defaultZLBFUITabs
    self.hasBuiltLayout = false
    self.lactation = props.lactation
    self.pregnancy = props.pregnancy
    self.womb = props.womb
    Events.onCreateUI:addListener(function() return self:onCreateUI() end)
    Events.onCreatePlayer:addListener(function(_, player) return self:onCreatePlayer(player) end)
    Events.onPlayerDeath:addListener(function(player) return self:onPlayerDeath(player) end)
    Events.onPostRender:addListener(function() return self:onUpdateUI() end)
end
function ZLBFUI.prototype.onCreatePlayer(self, player)
    self.player = player
    if not self.UI then
        self:onCreateUI()
    end
    if not self.UI then
        return
    end
    local ____opt_0 = self.player
    if not (____opt_0 and ____opt_0:isFemale()) then
        return
    end
    if self.hasBuiltLayout then
        return
    end
    local context = self:getTabContext()
    for ____, tab in ipairs(self.tabs) do
        local tabTitle = getText(tab.TITLE_KEY)
        self.UI:registerTab(tab.id, tabTitle)
        self.UI:setActiveTab(tabTitle)
        tab:build(self.UI, context)
    end
    self.UI:setBorderToAllElements(true)
    self.UI:saveLayout()
    if self.tabs[1] then
        self.UI:setActiveTab(getText(self.tabs[1].TITLE_KEY))
    end
    self.hasBuiltLayout = true
end
function ZLBFUI.prototype.onPlayerDeath(self, player)
    if not self.player or self.player ~= player then
        return
    end
    self:onRemoveUI()
end
function ZLBFUI.prototype.onCreateUI(self)
    pipewrenchRequire("ZLBF/ZLBFTabbedUI")
    self.UI = NewZLBFTabbedUI()
    self.hasBuiltLayout = false
    self.UI:setWidthPixel(200)
    self.UI:setTitle(getText("IGUI_ZLBF_UI_Panel"))
    self.UI:close()
end
function ZLBFUI.prototype.onUpdateUI(self)
    local ____opt_2 = self.UI
    if not (____opt_2 and ____opt_2.isUIVisible) then
        return
    end
    local context = self:getTabContext()
    for ____, tab in ipairs(self.tabs) do
        tab:update(self.UI, context)
    end
end
function ZLBFUI.prototype.onRemoveUI(self)
    if not self.UI then
        return
    end
    self.UI:close()
    self.UI:removeFromUIManager()
    self.UI = nil
    self.hasBuiltLayout = false
end
function ZLBFUI.prototype.getTabContext(self)
    return {player = self.player, lactation = self.lactation, pregnancy = self.pregnancy, womb = self.womb}
end
function ZLBFUI.prototype.toggle(self)
    if not self.UI then
        return
    end
    self.UI:toggle()
end
function ZLBFUI.prototype.isVisible(self)
    if not self.UI then
        return false
    end
    return self.UI.isUIVisible
end
return ____exports
