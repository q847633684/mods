--- File: ZomboLust Lewd Models/42/media/lua/client/CharacterCustomisation/ServerCommands.lua
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

local SPNCC_Commands = {}
local Commands = {}

--- Merges the server's authoritative customisation fields into the player's mod data and triggers a model reset.
--- Merges rather than replaces the table because ZLLewdModels (hair growth) shares the same mod data key
--- and must not be wiped out by a customisation-only payload from the server.
--- @param args table contains the data to set
--- @return void
function Commands.SetPlayerModData(args)
    local player = getPlayer()
    local data = player:getModData().ZLLewdModels or {}
    for k, v in pairs(args.data) do
        data[k] = v
    end
    player:getModData().ZLLewdModels = data
    player:resetModel()
    triggerEvent("OnClothingUpdated", player)
end

--- Updates specific values in the player's mod data
--- @param args table contains the values to update
--- @return void
function Commands.SetPlayerModDataValues(args)
    local player = getPlayer()
    local data = player:getModData().ZLLewdModels
    if not data then return end
    for k, v in pairs(args.values) do
        data[k] = v
    end
    player:resetModel()
    triggerEvent("OnClothingUpdated", player)
end

--- Opens the character customisation window
--- @param args table
--- @return void
function Commands.OpenCharacterCustomisationWindow(args)
    local FaceManager_Shared = require("CharacterCustomisation/FaceManager_Shared")
    FaceManager_Shared.OpenCharacterCustomisationWindow(getPlayer(), true)
end

--- Triggers the OnClothingUpdated event and resets the player model
--- @param args table
--- @return void
function Commands.OnClothingUpdated(args)
    local player = getPlayer()
    triggerEvent("OnClothingUpdated", player)
    player:resetModel()
end

--- Handles server commands for the SPNCC module
--- @param module string
--- @param command string
--- @param args table
--- @return void
local function onServerCommand(module, command, args)
    if module == "SPNCC" and Commands[command] then
        -- print(command)
        Commands[command](args)
    end
end

Events.OnServerCommand.Add(onServerCommand --[[@as Callback_OnServerCommand]])
