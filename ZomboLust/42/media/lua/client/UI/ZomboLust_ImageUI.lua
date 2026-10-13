-- File: ZomboLust/42/media/lua/client/UI/ZomboLust_ImageUI.lua
-- UI Window for displaying images and animations in ZomboLust
-- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_ImageUI.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"
require "ISUI/ISCollapsableWindow"
require "ISUI/ISImage"

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local math     = math
local tostring = tostring

--- @class ZomboLust_ImageUI : ISCollapsableWindow
--- @field image ISImage -- The image element
--- @field animation table | nil -- Current animation config
--- @field currentFrame integer -- Current frame index
--- @field timer number -- Timer for frame switching
--- @field createChildren function -- Internal UI method
--- @field titleBarHeight function -- Returns the height of the title bar
--- @field getIsVisible function -- Returns visibility state
--- @field setVisible function -- Sets visibility state
--- @field bringToTop function -- Brings the window to the front
--- @field addChild function -- Adds a child element
--- @field addToUIManager function -- Adds the window to the UI manager
--- @field width number -- Width of the window
--- @field height number -- Height of the window
--- @field video any | nil -- The Bink video object
--- @field videoName string | nil -- Current video filename
ZomboLust_ImageUI = ISCollapsableWindow:derive("ZomboLust_ImageUI")

-- Module name for logging
--- @type string
local MODULE_NAME = "ImageUI"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

--- Initialise the UI
---@diagnostic disable-next-line: undefined-field
function ZomboLust_ImageUI:initialise()
    ISCollapsableWindow.initialise(self)
    ZomboLust.debugLog(MODULE_NAME, "initialise: UI initialized")
end

--- Create the children elements of the UI
---@diagnostic disable-next-line: undefined-field
function ZomboLust_ImageUI:createChildren()
    ---@diagnostic disable-next-line: undefined-field
    ISCollapsableWindow.createChildren(self)

    local th = self:titleBarHeight()
    -- Create the image element that fills the window content area
    self.image = ISImage:new(0, th, self.width, self.height - th, nil)
    self.image:initialise()
    self.image.autoScale = true
    self.image:setAnchorRight(true)
    self.image:setAnchorBottom(true)
    self:addChild(self.image)
    ZomboLust.debugLog(MODULE_NAME, "createChildren: Child elements created")
end

--- Sets a single static image
--- @param texturePath string -- Path to the texture (e.g., "media/ui/image.png")
function ZomboLust_ImageUI:setImage(texturePath)
    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "setImage: Setting texture to '%s'", tostring(texturePath))
    end
    local texture = getTexture(texturePath)
    if texture then
        self.image.texture = texture
        self.animation = nil -- Stop any current PNG animation
        self.video = nil -- Stop any current video
        self.videoName = nil
    else
        ZomboLust.errorLog(MODULE_NAME, "setImage: Texture not found at '%s'", tostring(texturePath))
    end
end

--- Sets and plays a Bink video
--- @param videoPath string -- Path to the .bik file (relative to media/videos/)
function ZomboLust_ImageUI:setVideo(videoPath)
    -- IMPORTANT TECHNICAL NOTE:
    -- Bink video files (.bik) MUST be located in the base game's 'ProjectZomboid/media/videos/' directory.
    -- Users MUST manually copy these files from the mod folder to the game's media/videos folder.
    -- This is because Project Zomboid uses an old, hardcoded Bink video engine that does not look into mod directories;
    -- it only searches the root game directory. This is a technical limitation of the Project Zomboid engine
    -- that cannot be bypassed via Lua.
    --
    -- DO NOT ATTEMPT TO PRELOAD THESE VIDEOS AHEAD OF THE STAGE TRANSITION (tried and reverted, 2026-08):
    -- The idea was sound (prefetch the next stage's video during the current stage, via VideoTexture.getOrCreate,
    -- to avoid a decode hitch exactly at the transition) but building the "clip name -> video files" lookup table
    -- it needs is not viable in this codebase:
    --   1. PZ's Lua sandbox has NO API to read a mod's own shipped media/ files at runtime.
    --      getFileReader/getModFileReader only resolve against the mod's private save/cache area
    --      (see their Umbrella docstrings: "relative to the Lua cache root" / "mod's common folder"), never media/AnimSets/.
    --      Attempting it threw a Java IOException per lookup
    --      (the engine tries to CREATE the missing file, which fails because the parent path doesn't exist)
    --      2000+ errors and a 1.5s+ world-load stall from a single OnGameStart scan attempt.
    --   2. The only remaining option was a static table generated once, offline, by scanning the XML
    --      files directly (outside the game) and hand-maintaining it from then on.
    --      That doesn't hold up here: not every install necessarily has the same set of animation clips present on disk, and
    --      a single static list bundled in the base mod would (a) need editing by hand indefinitely,
    --      growing without bound as clips are added, and (b) reference clip names that don't exist on
    --      the machines of players who don't have those particular animations installed.
    -- If this is revisited, the only sound shape is a small lookup fragment generated once, right
    -- alongside whatever adds the new animation clips, and shipped together with them -- never a
    -- single table hand-maintained separately in this base file.
    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "setVideo: Loading video '%s'", tostring(videoPath))
    end

    local th = self:titleBarHeight()
    -- Using the direct Java method VideoTexture.getOrCreate which is more robust
    -- for mod support than the global getVideo() wrapper.
    local v = VideoTexture.getOrCreate(videoPath, math.floor(self.width), math.floor(self.height - th), false)

    if v then
        self.video = v
        self.videoName = videoPath
        self.animation = nil -- Stop any current PNG animation
        if self.image then self.image.texture = nil end -- Clear static image
        if dbg() then
            ZomboLust.debugLog(MODULE_NAME, "setVideo: Video loaded successfully (BinkId: %s)", tostring(v:isValid()))
        end
    else
        ZomboLust.errorLog(MODULE_NAME, "setVideo: Failed to load video via VideoTexture.getOrCreate at '%s'", tostring(videoPath))
    end
end

--- Starts playing an animation sequence
--- @param prefix string -- Prefix for the PNG files (e.g., "media/ui/anim_")
--- @param frameCount integer -- Number of frames in the sequence
--- @param fps integer -- Frames per second
function ZomboLust_ImageUI:playAnimation(prefix, frameCount, fps)
    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "playAnimation: Starting animation sequence '%s' (%d frames at %d FPS)", tostring(prefix), frameCount, fps or 30)
    end
    self.animation = {
        prefix = prefix,
        frameCount = frameCount,
        fps = fps or 30,
        frameTime = 1000 / (fps or 30)
    }
    self.currentFrame = 1
    self.timer = 0
    self.video = nil -- Stop any current video
    self.videoName = nil
    self:updateAnimationFrame()
end

--- Updates the image to the current animation frame
function ZomboLust_ImageUI:updateAnimationFrame()
    if not self.animation then return end

    local path = self.animation.prefix .. self.currentFrame .. ".png"
    local texture = getTexture(path)
    if texture then
        self.image.texture = texture
    else
        ZomboLust.warningLog(MODULE_NAME, "updateAnimationFrame: Missing frame texture at '%s'", path)
    end
end

--- Overrides the update method to handle animation timing
---@diagnostic disable-next-line: undefined-field
function ZomboLust_ImageUI:update()
    ISCollapsableWindow.update(self)

    -- Handle PNG sequences
    local anim = self.animation
    if anim and self:getIsVisible() then
        self.timer = self.timer + UIManager.getMillisSinceLastRender()
        if self.timer >= anim.frameTime then
            self.timer = 0
            self.currentFrame = self.currentFrame + 1
            if self.currentFrame > anim.frameCount then
                self.currentFrame = 1 -- Loop animation
                ZomboLust.debugLog(MODULE_NAME, "update: Animation looped for '%s'", anim.prefix)
            end
            self:updateAnimationFrame()
        end
    end
end

--- Overrides the prerender method to render video frames
---@diagnostic disable-next-line: undefined-field
function ZomboLust_ImageUI:prerender()
    ISCollapsableWindow.prerender(self)

    local video = self.video
    if video and self:getIsVisible() then
        local th = self:titleBarHeight()
        -- Render the next frame of the Bink video
        video:RenderFrame()
        -- Draw the video as a texture scaled to the window size
        self:drawTextureScaled(video, 0, th, self.width, self.height - th, 1, 1, 1, 1)
    end
end

--- Close the UI window and stop any animation or video
function ZomboLust_ImageUI:close()
    ZomboLust.debugLog(MODULE_NAME, "close: Closing UI window")
    self:setVisible(false)
    self:clear()
end

--- Stops any current playback (video or animation) and clears the image
function ZomboLust_ImageUI:clear()
    ZomboLust.debugLog(MODULE_NAME, "clear: Stopping all playback")
    self.animation = nil
    self.video = nil
    self.videoName = nil
    if self.image then self.image.texture = nil end
end

--- Constructor
--- @param x number -- X position
--- @param y number -- Y position
--- @param width number -- Width
--- @param height number -- Height
--- @return ZomboLust_ImageUI -- Returns the instance
function ZomboLust_ImageUI:new(x, y, width, height)
    local o = ISCollapsableWindow:new(x, y, width, height)
    ---@cast o ZomboLust_ImageUI
    setmetatable(o, self)
    self.__index = self

    o.title = "ZomboLust Sexual Activity Viewer"
    o.resizable = true
    o.animation = nil
    o.currentFrame = 1
    o.timer = 0

    return o
end

--- PERSISTENCE: Saves the window layout (position, size, visibility)
--- Called by ISLayoutManager
function ZomboLust_ImageUI:SaveLayout(name, layout)
    ISLayoutManager.DefaultSaveWindow(self, layout)
end

--- PERSISTENCE: Restores the window layout (position, size, visibility)
--- Called by ISLayoutManager
function ZomboLust_ImageUI:RestoreLayout(name, layout)
    ISLayoutManager.DefaultRestoreWindow(self, layout)
end

return ZomboLust_ImageUI
