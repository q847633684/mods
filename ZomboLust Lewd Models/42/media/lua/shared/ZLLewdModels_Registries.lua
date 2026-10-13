--- File: ZomboLust Lewd Models/42/media/lua/shared/ZLLewdModels_Registries.lua
--- Registers our custom BodyLocations into the shared "Human" group.
--
-- RENDERING LOGIC (Build 42):
-- In PZ B42, the order of BodyLocations in the "Human" group determines rendering priority.
-- Locations at the BEGINNING of the list are rendered first (closest to the skin).
-- To ensure custom layers like Body Hair appear UNDERNEATH clothing, we move our
-- locations to the front of the list (index 0) instead of relying on insertion order.
--
-- COMPATIBILITY STRATEGY:
-- getOrCreateLocation/moveLocationToIndex are purely additive - we only ever touch
-- our own 6 locations and never clear or rebuild the shared "Human" group, so we
-- can't corrupt or lose locations/relationships belonging to Vanilla or other mods
-- regardless of loading order.
--
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust Lewd Models LOADING] ZLLewdModels_Registries.lua loaded")

local function addLocations()
    local group = BodyLocations.getGroup("Human")
    if not group then return end

    local regs = ZLLewdModelsRegistries

    -- INSERT OUR LOCATIONS AT THE FRONT (Hair first = under clothing)
    if regs then
        local myLocs = {regs.ChestHair, regs.ArmpitHair, regs.PubicHair, regs.LegHair, regs.BeardStubble, regs.HeadStubble}
        for i = 1, #myLocs do
            local v = myLocs[i]
            if v then
                group:getOrCreateLocation(v)
                group:moveLocationToIndex(v, 0)
            end
        end
    end

    -- FINAL TOUCHES (Hiding hair under clothes)
    local pubic = regs and regs.PubicHair
    if pubic then
        local pubicLoc = group:getOrCreateLocation(pubic)
        local hideUnder = {
            ItemBodyLocation.UNDERWEAR_BOTTOM, ItemBodyLocation.UNDERWEAR, 
            ItemBodyLocation.TORSO1LEGS1, ItemBodyLocation.LEGS1, 
            ItemBodyLocation.PANTS, ItemBodyLocation.FULL_SUIT, ItemBodyLocation.BATH_ROBE
        }
        for i = 1, #hideUnder do
            local itemLoc = hideUnder[i]
            if itemLoc then group:setHideModel(itemLoc, pubic) end
        end
    end
end

Events.OnGameBoot.Add(addLocations)

return ZLLewdModelsRegistries
