--- File: ZomboLust Lewd Models/42/media/lua/client/ZLLewdModels_MirrorWorldMenu.lua
--- Context menu for mirrors in the world
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust Lewd Models LOADING] ZLLewdModels_MirrorWorldMenu.lua loaded")

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local getText = getText

-- Module name for logging
--- @type string
local MODULE_NAME = "MirrorWorldMenu"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZLLewdModels.isDebug in ZomboLustLewdModels_Main.lua).
--- Calls with cheap/no arguments use ZLLewdModels.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZLLewdModels.isDebug(MODULE_NAME)
end

-- =============
-- Dependencies
-- =============
require "ZomboLustLewdModels_Main"
require "ZLLewdModels_Mirror"

-- ================
-- Module Namespace
-- ================
ZLLewdModels = ZLLewdModels or {}
ZLLewdModels.Mirror = ZLLewdModels.Mirror or {}

--- Checks if a square or its objects contain a mirror
--- @param square IsoGridSquare -- The square to check
--- @param playerObj IsoPlayer -- The player checking for a mirror
--- @return boolean -- True if a mirror is found
function ZLLewdModels.Mirror.isMirrorOnSquare(square, playerObj)
    if not square or not playerObj then return false end

    local objects = square:getObjects()
    local size = objects:size()
    for i = 0, size - 1 do
        local object = objects:get(i)
        local sprite = object:getSprite()

        if sprite then
            local props = sprite:getProperties()
            if props and props:has("IsMirror") then
                -- Check if there's a wall blocking the view
                if not square:isWallTo(playerObj:getCurrentSquare()) then
                    if dbg() then
                        ZLLewdModels.debugLog(MODULE_NAME, "Mirror found via sprite property 'IsMirror' at %d,%d", square:getX(), square:getY())
                    end
                    return true
                end
            end
        end

        -- Check attached animations/sprites (common for some furniture)
        local attached = object:getAttachedAnimSprite()
        if attached then
            local attachedSize = attached:size()
            for j = 0, attachedSize - 1 do
                local attachedSprite = attached:get(j):getParentSprite()
                if attachedSprite then
                    local attachedProps = attachedSprite:getProperties()
                    if attachedProps and attachedProps:has("IsMirror") then
                        if not square:isWallTo(playerObj:getCurrentSquare()) then
                            if dbg() then
                                ZLLewdModels.debugLog(MODULE_NAME, "Mirror found via attached sprite property 'IsMirror' at %d,%d", square:getX(), square:getY())
                            end
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

--- Fills the context menu for world objects
--- @param playerNum integer -- The index of the player who right-clicked
--- @param context any -- The context menu being filled
--- @param worldObjects table -- The list of objects at the clicked position
local function onFillWorldObjectContextMenu(playerNum, context, worldObjects)
    local player = getSpecificPlayer(playerNum)
    if not player or player:isDead() then return end

    -- Get the square where the player clicked
    local clickedSquare = nil
    for i = 1, #worldObjects do
        local obj = worldObjects[i]
        if obj:getSquare() then
            clickedSquare = obj:getSquare()
            break
        end
    end

    if not clickedSquare then return end

    -- Check the clicked square and its immediate neighbors (like the base game does)
    local foundMirror = false
    local px, py, pz = clickedSquare:getX(), clickedSquare:getY(), clickedSquare:getZ()

    local cell = getCell()
    -- We check a small area around the click (3x3 area)
    for x = px - 1, px + 1 do
        for y = py - 1, py + 1 do
            local sq = cell:getGridSquare(x, y, pz)
            if sq and ZLLewdModels.Mirror.isMirrorOnSquare(sq, player) then
                foundMirror = true
                break
            end
        end
        if foundMirror then break end
    end

    if foundMirror then
        ZLLewdModels.debugLog(MODULE_NAME, "Mirror detected in world. Adding menu option.")
        context:addOption(getText("IGUI_ZLLewdModels_Context_LookAtMirror"), player, function()
            ZLLewdModels.Mirror.open(player)
        end)
    end
end

-- Events
Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu)
