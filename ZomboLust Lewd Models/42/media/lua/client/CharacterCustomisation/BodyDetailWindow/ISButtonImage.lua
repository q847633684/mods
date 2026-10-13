--- File: ZomboLust Lewd Models/42/media/lua/client/CharacterCustomisation/BodyDetailWindow/ISButtonImage.lua
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- =============
-- Dependencies
-- =============
require("ISUI/ISButton")

local base = ISButton
--- @class ISButtonImage : ISButton
--- @field selected boolean
--- @field image_On Texture
--- @field image_Off Texture
--- @field useSelectedColor boolean
--- @field selectedColors table
ISButtonImage = base:derive("ISButtonImage")

--- Creates a new ISButtonImage instance
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param image_On Texture
--- @param image_Off Texture
--- @param target table
--- @param onclick function
--- @return ISButtonImage
function ISButtonImage:new(x, y, width, height, image_On, image_Off, target, onclick)
    local o = base:new(x, y, width, height, "", target, onclick)
    setmetatable(o, self)
    self.__index = self

    ---@cast o ISButtonImage
    o.selected = false
    o.image_On = image_On
    o.image_Off = image_Off
    o.useSelectedColor = true
    o.selectedColors = {
        [true] = {r = 1, g = 1, b = 1, a = 1},
        [false] = {r = 1, g = 1, b = 1, a = 0.5},
    }
    return o
end

--- Initialises the button and sets the initial image
--- @return void
function ISButtonImage:initialise()
    base.initialise(self)

    self:setImage()
end

--- Handles mouse up event and toggles selection state
--- @param x number
--- @param y number
--- @return void
function ISButtonImage:onMouseUp(x, y)

    if not self:getIsVisible() then
        return
    end
    local process = false
    if self.pressed == true then
        process = true
    end
    self.pressed = false
    if self.enable and (process or self.allowMouseUpProcessing) then
        getSoundManager():playUISound(self.sounds.activate)

        self:setSelected(not self.selected)

        if self.onclick == nil then return end
        self.onclick(self.target, self, self.onClickArgs[1], self.onClickArgs[2], self.onClickArgs[3], self.onClickArgs[4])
    end
end

--- Updates the button's image based on its selection state
--- @return void
function ISButtonImage:setImage()
    self.image = self.selected and self.image_On or self.image_Off
end

--- Returns whether the button is selected
--- @return boolean
function ISButtonImage:isSelected()
    return self.selected
end

--- Sets the button's selection state and updates its image and color
--- @param bool boolean
--- @return void
function ISButtonImage:setSelected(bool)
    self.selected = bool
    self:setImage()

    local color = self.selectedColors[self.selected]
    if not self.useSelectedColor then color = self.selectedColors[true] end

    self:setTextureRGBA(color.r, color.g, color.b, color.a)
end
