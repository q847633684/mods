--- File: ZomboLust Lewd Models/42/media/lua/server/CharacterCustomisation/IG_RemoveOnZombification.lua
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- =============
-- Dependencies
-- =============
local FaceManager_Server = require("CharacterCustomisation/FaceManager_Server")

-- ---------------------------
--   REMOVE FACE FROM ZOMBIE
-- ---------------------------

--- Event handler for OnCharacterDeath to remove specific customisation items if zombified
--- @param character IsoGameCharacter
local function removeOnZombification(character)
    if instanceof(character, "IsoPlayer") and not instanceof(character, "IsoAnimal") then 
        if character:getBodyDamage():IsInfected() == false then return end
        FaceManager_Server.RemoveItemsWithTag(character, SPNCC.ItemTag.RemoveOnZombification)
    end
end

Events.OnCharacterDeath.Add(removeOnZombification)
