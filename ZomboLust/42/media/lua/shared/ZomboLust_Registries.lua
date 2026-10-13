--- File: ZomboLust/42/media/lua/shared/ZomboLust_Registries.lua
--- Registers our custom Bukkake BodyLocations into the shared "Human" group.
--
-- RENDERING LOGIC (Build 42):
-- In PZ B42, the order of BodyLocations in the "Human" group determines rendering priority.
-- Locations at the BEGINNING of the list are rendered first (closest to the skin).
-- To ensure Bukkake layers appear UNDERNEATH clothing, we move our locations to the
-- front of the list (index 0) instead of relying on insertion order.
--
-- COMPATIBILITY STRATEGY:
-- getOrCreateLocation/moveLocationToIndex are purely additive - we only ever touch
-- our own Bukkake locations and never clear or rebuild the shared "Human" group, so we
-- can't corrupt or lose locations/relationships belonging to Vanilla or other mods
-- (including ZomboLust Lewd Models) regardless of loading order.
--
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_Registries.lua loaded")

local function addLocations()
    local group = BodyLocations.getGroup("Human")
    if not group then return end

    local myLocationIDs = {
        "ZomboLust:Bukkake_FullFace",
        "ZomboLust:Bukkake_CenteredMouth",
        "ZomboLust:Bukkake_FullBack",
        "ZomboLust:Bukkake_FullChest",
        "ZomboLust:Bukkake_CenteredBreast",
        "ZomboLust:Bukkake_CenteredPussy",
        "ZomboLust:Bukkake_CenteredButt",
        "ZomboLust:Bukkake_UpperThigh",
        "ZomboLust:Bukkake_UpperLegs",
        "ZomboLust:Bukkake_Miscellaneous"
    }

    -- INSERT OUR LOCATIONS AT THE FRONT (Bukkake layers first = under clothing)
    for i = 1, #myLocationIDs do
        local itemLoc = ItemBodyLocation.get(ResourceLocation.of(myLocationIDs[i]))
        if itemLoc then
            local layer = group:getOrCreateLocation(itemLoc)
            layer:setMultiItem(true)
            group:moveLocationToIndex(itemLoc, 0)
        end
    end
end

Events.OnGameBoot.Add(addLocations)
