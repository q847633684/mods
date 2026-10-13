--- File: ZomboLust Lewd Models/42/media/lua/client/CharacterCustomisation/Ingame/IG_SyncBodyDetailsBlood.lua
--- @author Spongie - ZomboLust adaptation by BlaBla 2026
    -- -------------
    --  SYNC BLOOD
    -- -------------
--Blood renders beneath clothing so we need to grab every equipped customisation that supports blood and then copy the body's blood onto them
--this works because clothing still render blood visuals on body parts that they dont have protection for

-- =============
-- Dependencies
-- =============
local FaceManager_Shared = require("CharacterCustomisation/FaceManager_Shared")

local BloodWasJustSynced = false
--- Synchronizes blood and dirt from the character's body to their customisation items
--- @param player IsoPlayer
--- @return void
local function SyncBloodOnClothingUpdated(player)

    -- need to avoid an infinite loop
    if BloodWasJustSynced then
        BloodWasJustSynced = false
        return
    end

    ---@cast FaceManager_Shared FaceManager_Shared
    local item = FaceManager_Shared.GetFirstWornItemWithTag(player, SPNCC.ItemTag.CanHaveBlood)
    if not item then return end

    local playerVisual = player:getHumanVisual()
    -- if FaceManager_Shared.AddBloodAndDirtToItem(item:getVisual(), playerVisual) then

        sendClientCommand(player, "SPNCC", "SyncBlood", { })

        BloodWasJustSynced = true
    -- end
end

    -- -----------------------
    --   SUBSCRIBE TO EVENTS
    -- -----------------------
Events.OnClothingUpdated.Add(SyncBloodOnClothingUpdated)
