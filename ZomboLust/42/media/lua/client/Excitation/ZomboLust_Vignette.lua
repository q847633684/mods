-- File: ZomboLust/42/media/lua/client/Excitation/ZomboLust_Vignette.lua
-- This module handles the sensual vignette overlay effect
-- @author BlaBla 2026

-- =============
-- Dependencies
-- =============
require "ISUI/ISUIElement"

---@class ZomboLust_Vignette : ISUIElement
---@field instance ZomboLust_Vignette
---@field texture Texture
---@field alpha number
---@field maxAlpha number
---@field isPulsing boolean
---@field startTime number
ZomboLust_Vignette = ISUIElement:derive("ZomboLust_Vignette")

function ZomboLust_Vignette:initialise()
    ISUIElement.initialise(self)
end

function ZomboLust_Vignette:createChildren()
end

function ZomboLust_Vignette:prerender()
    if self.alpha <= 0 then return end

    local w = getCore():getScreenWidth()
    local h = getCore():getScreenHeight()

    -- Draw the vignette texture covering the whole screen
    self:drawTextureScaled(self.texture, 0, 0, w, h, self.alpha, 1, 1, 1)
end

function ZomboLust_Vignette:render()
end

function ZomboLust_Vignette:update()
    ISUIElement.update(self)

    -- Handle the smooth alpha pulse
    if self.isPulsing then
        local currentTime = getTimestampMs()
        local elapsed = currentTime - self.startTime

        -- Sensual pulse duration (approx 800ms for full in/out)
        local duration = 800 

        if elapsed >= duration then
            self.alpha = 0
            self.isPulsing = false
        else
            -- Sine wave for smooth breathing feel (0 -> 1 -> 0)
            local progress = elapsed / duration
            self.alpha = math.sin(progress * math.pi) * self.maxAlpha
        end
    end
end

--- Triggers a single pulse effect
--- @param maxAlpha number The peak transparency (0.0 to 1.0)
function ZomboLust_Vignette:triggerPulse(maxAlpha)
    self.maxAlpha = maxAlpha or 0.5
    self.startTime = getTimestampMs()
    self.isPulsing = true
end

function ZomboLust_Vignette:new()
    ---@type ZomboLust_Vignette
    local o = ISUIElement:new(0, 0, 0, 0)
    setmetatable(o, self)
    self.__index = self

    o.texture = getTexture("media/textures/FX/ZomboLust_Vignette.png")
    o.alpha = 0
    o.maxAlpha = 0.5
    o.isPulsing = false
    o.startTime = 0

    o:setAnchorRight(true)
    o:setAnchorBottom(true)
    o:ignoreWidthChange()
    o:ignoreHeightChange()

    return o
end

-- Create the singleton instance
ZomboLust_Vignette.instance = nil

local function initVignette()
    if ZomboLust_Vignette.instance then return end
    ZomboLust_Vignette.instance = ZomboLust_Vignette:new()
    ZomboLust_Vignette.instance:initialise()
    ZomboLust_Vignette.instance:addToUIManager()
end

Events.OnGameStart.Add(initVignette)
