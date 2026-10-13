--- File: ZomboLust Lewd Models/42/media/lua/client/CharacterCustomisation/Ingame/IG_CharacterMuscle.lua
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

local pendingMusclePlayer = nil

--- Sends the queued muscle sync from the main thread
--- @return void
local function sendPendingMuscleSync()
    -- applyTraits() calls LevelPerk once per level in a loop
    -- (e.g. a multi-level Strength gain from an admin command or XP boost fires onLevelPerk several times in the same tick).
    -- Deferring to OnPlayerUpdate and dropping re-entrant calls while one is already pending collapses those into
    -- a single sync instead of sending one redundant SetPlayerMuscle command per level gained.
    -- Thanks to Nephilim
    Events.OnPlayerUpdate.Remove(sendPendingMuscleSync)
    local player = pendingMusclePlayer
    pendingMusclePlayer = nil
    if not player then return end

    sendClientCommand(player, "SPNCC", "SetPlayerMuscle", { })
end

--- Event handler for LevelPerk to update muscle visuals when strength increases
--- @param player IsoPlayer
--- @param perk any
--- @param level integer
local function onLevelPerk(player, perk, level)
    if perk:getType() ~= Perks.Strength:getType() then return end
    if pendingMusclePlayer then return end

    pendingMusclePlayer = player
    Events.OnPlayerUpdate.Add(sendPendingMuscleSync)
end

    -- -----------------------
    --   SUBSCRIBE TO EVENTS
    -- -----------------------
Events.LevelPerk.Add(onLevelPerk)
