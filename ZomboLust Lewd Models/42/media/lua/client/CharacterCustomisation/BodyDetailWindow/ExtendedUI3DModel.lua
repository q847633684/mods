--- File: ZomboLust Lewd Models/42/media/lua/client/CharacterCustomisation/BodyDetailWindow/ExtendedUI3DModel.lua
--- Taken from Improved Hair Menu by duckduckquak
--- This is a UI element that extends ISUI3DModel with click detection
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local math = math

-- require("ISUI/ISUI3DModel")
local base = ISUI3DModel
--- @class ISUI3DModelExt : ISUI3DModel
--- @field hasDragged boolean
--- @field onSelect function|nil
--- @field selectable boolean
--- @field texture_avatar_background Texture
ISUI3DModelExt = base:derive("ISUI3DModelExt")

--- Creates a new ISUI3DModelExt instance
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @return ISUI3DModelExt
function ISUI3DModelExt:new(x, y, width, height)
    local o = base.new(self, x, y, width, height)
    ---@cast o ISUI3DModelExt
    o.hasDragged = false
    o.onSelect = nil
    o.selectable = true
    o.texture_avatar_background = getTexture("media/ui/avatarBackground.png")
    return o
end

--- Renders the background texture before the 3D model
function ISUI3DModelExt:prerender()
    base.prerender(self)
    self:drawTextureScaled(self.texture_avatar_background, 0, 0, self.width, self.height, 1, 1, 1, 1)
end

--- Handles mouse movement and drag detection
--- @param dx number
--- @param dy number
function ISUI3DModelExt:onMouseMove(dx, dy)
    -- NOTE: This is mostly repeated but it preserves the vanilla code
    if self.mouseDown then
        if math.abs(self.dragX + dx) > 40 then
            self.hasDragged = true
        end
    end
    base.onMouseMove(self, dx, dy)
end

--- Handles mouse button release to detect clicks vs drags
--- @param x number
--- @param y number
function ISUI3DModelExt:onMouseUp(x, y)
    if self.mouseDown then
        if self.hasDragged == false then
            self:select()
        end
    end
    self.hasDragged = false
    base.onMouseUp(self, x, y)
end

--- Handles mouse button release outside the element
--- @param x number
--- @param y number
function ISUI3DModelExt:onMouseUpOutside(x, y)
    if self.mouseDown then
        if self.hasDragged == false then
            self:select()
        end
    end
    self.hasDragged = false
    base.onMouseUpOutside(self, x, y)
end

--- Triggers the onSelect callback if selectable
function ISUI3DModelExt:select()
    if self.selectable and self.onSelect then
        self.onSelect(self)
    end
end
