--- File: ZomboLust Lewd Models/42/media/lua/client/CharacterCustomisation/Ingame/IG_PlayerJoin.lua
--- @author Spongie - ZomboLust adaptation by BlaBla 2026
    -- --------------------------------------------
    --   SET UP MOD DATA AFTER CHARACTER CREATION
    -- --------------------------------------------
-- When the character spawns from character creation we send their customisation to the server so it can be saved in mod data

local OnNewCharacterTimer = 0
--- Callback that runs shortly after a new character is created to send customisation data to the server
--- @return void
local function OnNewCharacter()
    OnNewCharacterTimer = OnNewCharacterTimer - 1
    if OnNewCharacterTimer > 0 then return end
    Events.OnPlayerUpdate.Remove(OnNewCharacter)
    local clientData = require("CharacterCustomisation/CharacterCreation/StoredCharacterData")	--data we stored during character creation
    sendClientCommand(getPlayer(), "SPNCC", "SetCustomisationNewCharacter", { data = clientData})
end

--- Event handler for OnNewGame to start the customisation sync timer
--- @param player IsoPlayer
--- @return void
local function onNewGame(player)
    OnNewCharacterTimer = 3
    Events.OnPlayerUpdate.Add(OnNewCharacter)
end

local OnPlayerJoinTimer = 0
--- Callback that runs shortly after a player joins to handle mod data initialization
--- @return void
local function OnPlayerJoin()
    OnPlayerJoinTimer = OnPlayerJoinTimer - 1
    if OnPlayerJoinTimer > 0 then return end
    Events.OnPlayerUpdate.Remove(OnPlayerJoin)

    local player = getPlayer()
    sendClientCommand(player, "SPNCC", "OnPlayerJoin", { })

    --singleplayer only
    if isClient() or isServer() then return end
    local data = player:getModData().ZLLewdModels
    if data and data.hasCustomised then return end
    local FaceManager_Shared = require("CharacterCustomisation/FaceManager_Shared")
    FaceManager_Shared.OpenCharacterCustomisationWindow(player, true)
end

--- Event handler for OnCreatePlayer to start the join initialization timer
--- @param playerNum integer
--- @param player IsoPlayer
--- @return void
local function onCreatePlayer(playerNum, player)
    -- print("onCreatePlayer")
    OnPlayerJoinTimer = 6
    Events.OnPlayerUpdate.Add(OnPlayerJoin)
end

    -- -----------------------
    --   SUBSCRIBE TO EVENTS
    -- -----------------------
Events.OnNewGame.Add(onNewGame)
Events.OnCreatePlayer.Add(onCreatePlayer)
