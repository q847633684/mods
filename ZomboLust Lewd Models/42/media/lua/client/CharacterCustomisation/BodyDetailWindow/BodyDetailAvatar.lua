--- File: ZomboLust Lewd Models/42/media/lua/client/CharacterCustomisation/BodyDetailWindow/BodyDetailAvatar.lua
--- Based on Improved Hair Menu by duckduckquak
--- This is a UI element that previews a customisation change
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- =============
-- Dependencies
-- =============
require("CharacterCustomisation/BodyDetailWindow/ExtendedUI3DModel")

--- @class BodyDetailAvatar : ISUI3DModelExt
--- @field visualItem table
--- @field desc SurvivorDesc
--- @field cursor boolean
--- @field tooltipEnabled boolean
--- @field tooltipUI ISToolTip
--- @field panelIndex number
--- @field onSelect function|nil
BodyDetailAvatar = ISUI3DModelExt:derive("BodyDetailAvatar")

local FaceManager_Shared = require("CharacterCustomisation/FaceManager_Shared")

--- Creates a new BodyDetailAvatar instance
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @return BodyDetailAvatar
function BodyDetailAvatar:new(x, y, width, height)
    local o = ISUI3DModelExt.new(self, x, y, width, height)
    ---@cast o BodyDetailAvatar
    o.visualItem = {name = "UNINITIALIZED", id = "UNINITIALIZED", texture = 0, selected = false, icon = nil,
                    locked = false, direction = IsoDirections.S, zoom = 0, yoffset = 0, xoffset = 0}
    o.desc = nil
    o.cursor = false
    o.tooltipEnabled = false
    return o
end

--- Instantiates the UI element and sets initial state
function BodyDetailAvatar:instantiate()
    ISUI3DModelExt.instantiate(self)
    self:setState("idle")
    self:setIsometric(false)
    self:setViewSettings()
end

-- function BodyDetailAvatar:render()
-- 	ISUI3DModelExt.render(self)
-- end

--- Sets the survivor description for the avatar
--- @param desc SurvivorDesc
function BodyDetailAvatar:setDesc(desc)
    self.desc = desc
end

--- Sets the visual item data
--- @param args table
function BodyDetailAvatar:setVisualItem(args)
    self.visualItem = args
end

--- Applies the visual item to the avatar preview
--- @param selectedFace table|nil
function BodyDetailAvatar:applyVisual(selectedFace)
    --[[ XXX:
        Because visuals are a table reference, any changes we make to the preview avatar here will affect all other avatars.
        To work around this we need to make the changes we need, set the visual to the preview avatar, and then revert the changes we made

        This works because passing the visual to the 3d avatar makes a copy of the visual because of java stuff that i dont understand.
        Essentially when we call setSurvivorDesc() we are pushing the current visuals onto the preview avatar instead of passing a reference to them.
     ]]
    if not self.visualItem.display then return end

    local visual = self.desc
    local wornItems = visual:getWornItems()
    local item = nil

    --if the avatar is for a face then we need to removes the equipped face
    local face
    if selectedFace and selectedFace.bodylocation then
        face = visual:getWornItem(selectedFace.bodylocation)
        wornItems:remove(face)
    end

    -- ADD THE ITEM TO THE PREVIEW
    if self.visualItem and self.visualItem.id ~= "" then
        item = instanceItem(self.visualItem.id)
        if item ~= nil then
            FaceManager_Shared.SetItemTexture(item, self.visualItem.texture)
            visual:setWornItem(item:getBodyLocation(), item)
        end
    end

    -- COPIES THE VISUAL TO THE AVATAR
    self:setSurvivorDesc(self.desc)

    --NOW WE RESET THE PREVIEW BACK TO DEFAULT!!!!!

    if item then wornItems:remove(item) end

    --need to have the original face added back as well
    if selectedFace and selectedFace.bodylocation and face then
        visual:setWornItem(selectedFace.bodylocation, face)
    end
end

--- Updates the 3D view settings (direction, zoom, offsets)
function BodyDetailAvatar:setViewSettings()
    self:setDirection(self.visualItem.direction)
    self:setZoom(self.visualItem.zoom)
    self:setYOffset(self.visualItem.yoffset)
    self:setXOffset(self.visualItem.xoffset)
    
end

--- Sets the cursor state and manages tooltip visibility
--- @param state boolean
function BodyDetailAvatar:setCursor(state)
    self.cursor = state
    if not self.tooltipEnabled then return end
    if state == true then
        self:showTooltip()
    else
        self:hideTooltip()
    end
end

--- Shows the tooltip for the visual item
function BodyDetailAvatar:showTooltip()
    if not self.tooltipUI then
        self.tooltipUI = ISToolTip:new()
        self.tooltipUI:setOwner(self)
        self.tooltipUI:setVisible(false)
        self.tooltipUI:setAlwaysOnTop(true)
        self.tooltipUI.maxLineWidth = 300
    end
    if not self.tooltipUI:getIsVisible() then
        self.tooltipUI:addToUIManager()
        self.tooltipUI:setVisible(true)
    end
    self.tooltipUI.description = self.visualItem.display
    self.tooltipUI:setDesiredPosition(self:getAbsoluteX() + self:getWidth(), self:getAbsoluteY())
end

--- Hides the tooltip
function BodyDetailAvatar:hideTooltip()
    if self.tooltipUI and self.tooltipUI:getIsVisible() then
        self.tooltipUI:setVisible(false)
        self.tooltipUI:removeFromUIManager()
    end
end
