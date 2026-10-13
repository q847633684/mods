--- File: ZomboDesire/42/media/lua/client/Detection/ZomboDesire_Detection.lua
--- Accurate player-zombie contact detection module
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_Detection.lua loaded")

--- Detection module for checking player-zombie proximity and contact
--- @class ZomboDesire_Detection
local ZomboDesire_Detection = {}

--- Module name for logging
--- @type string
local MODULE_NAME = "Detection"

--- Checks if the player and zombie are actually in contact (adjacent squares)
--- Uses multiple detection methods: simple distance check, state validation, and pathfinding
--- @param player IsoPlayer -- The player to check against
--- @param zombie IsoZombie|IsoGameCharacter -- The zombie or other character to check against
--- @return boolean -- true if adjacent or if a path to adjacency exists, false otherwise
function ZomboDesire_Detection.isAdjacent(player, zombie)
    if not player or not zombie then return false end
    local playerSquare = player:getCurrentSquare()
    local zombieSquare = zombie:getSquare()
    if not playerSquare or not zombieSquare then return false end

    -- Additional check for conditions that might cause problems
    local playerState = player:getCurrentState()
    if playerState and (instanceof(playerState, "ClimbThroughWindowState") or 
                        instanceof(playerState, "ClimbOverFenceState") or 
                        instanceof(playerState, "ClimbOverWallState")) then
        return false
    end

    -- Simple distance verification as a secure alternative
    local diffX = math.abs(playerSquare:getX() - zombieSquare:getX())
    local diffY = math.abs(playerSquare:getY() - zombieSquare:getY())
    if diffX <= 1 and diffY <= 1 and playerSquare:getZ() == zombieSquare:getZ() then
        return true
    end

    -- Using walkAdj with error handling
    local success, result = pcall(function()
        ---@diagnostic disable-next-line: param-type-mismatch
        return luautils.walkAdj(zombie, playerSquare, true)
    end)

    if success then
        ---@cast result boolean
        return result
    else
        -- If an error occurs, use the simple distance check as fallback
        return (diffX <= 1 and diffY <= 1 and playerSquare:getZ() == zombieSquare:getZ())
    end
end

return ZomboDesire_Detection