--- File: ZomboLust Lewd Models/42/media/lua/server/CharacterCustomisation/ClientCommands.lua
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- =============
-- Dependencies
-- =============
local FaceManager_Server = require("CharacterCustomisation/FaceManager_Server")

local Commands = {}

--- Updates player customisation from client data
--- @param player IsoPlayer
--- @param args table
function Commands.SetCustomisation(player, args)
    FaceManager_Server.SetCustomisation(player, args.data)
end

--- Updates customisation for a new character from client data
--- @param player IsoPlayer
--- @param args table
function Commands.SetCustomisationNewCharacter(player, args)
    FaceManager_Server.SetCustomisationNewCharacter(player, args.data)
end

--- Refreshes all customisation items for the player
--- @param player IsoPlayer
--- @param args table
function Commands.RefreshCustomisation(player, args)
    FaceManager_Server.RefreshCustomisation(player)
end

--- Sends the player's mod data back to the client
--- @param player IsoPlayer
--- @param args table
function Commands.RequestPlayerModData(player, args)
    sendServerCommand(player, "SPNCC", "SetPlayerModData", {data = player:getModData().ZLLewdModels})
end

--- Handles player join logic on the server
--- @param player IsoPlayer
--- @param args table
function Commands.OnPlayerJoin(player, args)
    FaceManager_Server.OnPlayerJoin(player)
end

--- Synchronizes blood visuals from body to customisation items
--- @param player IsoPlayer
--- @param args table
function Commands.SyncBlood(player, args)
    FaceManager_Server.SyncBlood(player)
end

--- Refreshes the player's muscle visual (e.g. after a Strength level-up)
--- @param player IsoPlayer
--- @param args table
function Commands.SetPlayerMuscle(player, args)
    FaceManager_Server.SetPlayerMuscle(player)
end

--- Handles client commands for the SPNCC module
--- @param module string
--- @param command string
--- @param player IsoPlayer
--- @param args table
local function OnClientCommand(module, command, player, args)
    if module == "SPNCC" and Commands[command] then
        -- print(command)
        Commands[command](player, args)
    end
end

Events.OnClientCommand.Add(OnClientCommand --[[@as Callback_OnClientCommand]])
