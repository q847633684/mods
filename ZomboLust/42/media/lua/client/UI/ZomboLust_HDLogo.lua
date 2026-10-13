-- ==============================================================
-- ZomboLust HD Logo Replacement
-- ==============================================================
-- Replaces the main menu title with ZomboLust_Logo.png
-- This implementation wraps the original constructor with
-- clean implementation respecting game conventions.
-- ==============================================================

local hdLogoScale = 2 -- Adjust to 4 if the image is very high resolution
local hdLogoPath = "media/ui/ZomboLust_Logo.png"

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local math = math

local original_MainScreen_new = MainScreen.new
local mainScreenInstance = nil

--- Override the MainScreen:new method to inject our custom logo
--- @param inGame boolean -- Whether the menu is being called from within a running game
--- @return MainScreen -- The instance of the main menu screen
function MainScreen:new(inGame)
    -- Call the original game constructor first
    local o = original_MainScreen_new(self, inGame)

    -- Load our custom logo with texture filtering
    -- We enable texture filtering temporarily for better image quality
    useTextureFiltering(true)
    local customLogo = getTexture(hdLogoPath)
    -- If the texture was successfully loaded, replace the default one
    if customLogo then
        o.logoTexture = customLogo
    end
    useTextureFiltering(false)

    return o
end

--- Clean override of the prerender function to handle HD scaling
function MainScreen:prerender()
    local core = getCore()
    local gameTime = getGameTime()

    ---@diagnostic disable-next-line: param-type-mismatch
    ISPanel.prerender(self)

    if self.inGame then
        self:drawRect(0, 0, self.width, self.height, 0.5, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
        if isQuitCooldown() then
            self.exitOption:setColor(0.5, 0.5, 0.5)
            self.quitToDesktopOption:setColor(0.5, 0.5, 0.5)
        else
            self.exitOption:setColor(1, 1, 1)
            self.quitToDesktopOption:setColor(1, 1, 1)
        end
    end

    if self.delay > 0 then
        if self.firstFrame then
            self.delay = self.delay - UIManager.getMillisSinceLastRender()
        else
            self.firstFrame = true
        end
    end

    local multiplier = gameTime:getMultiplier()
    self.time = self.time + ((1.0 / 60) * multiplier)

    mainScreenInstance = mainScreenInstance or MainScreenState.getInstance()
    if mainScreenInstance and ISDemoPopup.instance == nil then
        local tex = self.logoTexture
        if tex then
            local sw = core:getScreenWidth()
            local w = tex:getWidth() / hdLogoScale
            local h = tex:getHeight() / hdLogoScale

            local resdelta = math.min(self:calcLogoHeight() / h, sw / 1920)
            local x = 50 * (sw / 1920)
            local y = 50 * (sw / 1920)
            w, h = w * resdelta, h * resdelta

            self:drawTextureScaled(tex, x, y, w, h, 1 - (self.warningFade / self.warningFadeMax), 1, 1, 1.0)

            self.warningFade = math.max(0, self.warningFade - ((1.5 / 60) * multiplier))

            local maxWidth = math.max(w / 2, self.maxMenuItemWidth)
            local children = self.bottomPanel:getChildren()
            for i = 1, #children do
                local child = children[i]
                if not child then break end
                if child.Type == "ISLabel" then child:setWidth(maxWidth) end
            end

            self.bottomPanel:setWidth(maxWidth)
            self.bottomPanel:setX(math.max(21, x + (w - self.bottomPanel:getWidth()) / 2)) -- 21 = UI_BORDER_SPACING*2 + JOYPAD_TEX_SIZE + 1 in B42.17
            self.bottomPanel:setY(y + h + 50 * (sw / 1920))
        end
    end
end
