local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
--- Environment-neutral wrapper around one explicitly supplied `IsoPlayer`.
____exports.Player = __TS__Class()
local Player = ____exports.Player
Player.Type = "Player"
__PW__BaseClassExtends(Player)
function Player.prototype.____constructor(self, player)
    self.player = player
end
function Player.prototype.bind(self, player)
    self.player = player
end
__TS__SetDescriptor(
    Player.prototype,
    "identity",
    {get = function(self)
        local player = self.player
        local descriptor = player and player:getDescriptor()
        if not player or not descriptor then
            return nil
        end
        local username = player:getUsername()
        local name = player:getFullName()
        if not username or not name then
            return nil
        end
        return {username = username, name = name}
    end},
    true
)
return ____exports
