--- File: ZomboLust/42/media/lua/client/AnimationEvents/AnimationEvents/ZLShowImage.lua
--- Animation Event: Shows an image or animation in the ZomboLust UI
--- @author BlaBla 2026

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local tostring      = tostring
local tonumber      = tonumber
local string_find   = string.find
local string_gmatch = string.gmatch
local table_insert  = table.insert

-- Module name for logging
local MODULE_NAME = "ImageUI"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

--- @param action ISZomboDesireAnimationAction -- The animation action object
--- @param eventName string -- The name of the event (e.g., 'ZLShowImage')
--- @param parameter string -- Video file (e.g., 'my_video.bik'), static image (e.g., 'media/ui/image.png') or PNG sequence ('prefix,frameCount,fps')
return function(action, eventName, parameter)
    ZomboLust.debugLog(MODULE_NAME, "handler called -> eventName: %s, parameter: %s", tostring(eventName), tostring(parameter))

    if not parameter or parameter == "" then
        ZomboLust.warningLog(MODULE_NAME, "handler: parameter is nil or empty, nothing to show")
        return
    end

    if not ZomboLust.UI then
        ZomboLust.errorLog(MODULE_NAME, "handler: ZomboLust.UI is not initialized!")
        return
    end

    ---@type ZomboLust_ImageUI
    local ui = ZomboLust.UI

    -- Special case: Stop playback
    if parameter == "Stop" or parameter == "stop" then
        ZomboLust.debugLog(MODULE_NAME, "handler: Received Stop command")
        ui:close()
        return
    end

    ui:setVisible(true)
    ui:bringToTop()

    -- Check if it's a Bink video (.bik)
    if string_find(parameter, "%.bik$") then
        local character = action.character
        local prefix = ""

        if character:isFemale() then
            -- Get skin texture index (0=Argent, 1-2=Blanc, 3=Brun, 4+=Sombre)
            local skinIndex = character:getHumanVisual():getSkinTextureIndex()
            local colorStr = "Blanc"
            if skinIndex == 0 then colorStr = "Argent"
            elseif skinIndex == 1 or skinIndex == 2 then colorStr = "Blanc"
            elseif skinIndex == 3 then colorStr = "Brun"
            else colorStr = "Sombre"
            end
            prefix = "ZL_" .. colorStr .. "_"
        else
            -- For male characters, the prefix is always ZL_Zombie_
            prefix = "ZL_Zombie_"
        end

        parameter = prefix .. parameter
        ZomboLust.debugLog(MODULE_NAME, "handler: Reconstructed parameter with prefix: %s -> Playing Bink video", parameter)
        ui:setVideo(parameter)
    -- Check if it's an animation sequence (parameter contains commas)
    elseif string_find(parameter, ",", 1, true) then
        -- Format: prefix,frameCount,fps
        local parts = {}
        for part in string_gmatch(parameter, '([^,]+)') do
            table_insert(parts, part)
        end

        if #parts < 2 then
            ZomboLust.errorLog(MODULE_NAME, "handler: invalid animation parameter format: '%s'. Expected 'prefix,frameCount[,fps]'", parameter)
            return
        end

        local prefix = parts[1]
        ---@cast prefix string
        local frameCount = tonumber(parts[2])
        local fps = tonumber(parts[3]) or 30

        if not frameCount then
            ZomboLust.errorLog(MODULE_NAME, "handler: frameCount is not a valid number in parameter '%s'", parameter)
            return
        end

        ---@cast frameCount integer
        ---@cast fps integer
        ZomboLust.debugLog(MODULE_NAME, "handler: Playing animation: %s (%d frames, %d FPS)", prefix, frameCount, fps)
        ui:playAnimation(prefix, frameCount, fps)
    else
        -- Static image
        ZomboLust.debugLog(MODULE_NAME, "handler: Showing static image: %s", parameter)
        ui:setImage(parameter)
    end
end
