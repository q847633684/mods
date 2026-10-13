--- File: ZomboLust Lewd Models/42/media/lua/shared/CharacterCustomisation/SPNCC_Bodylocations.lua
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- =============
-- Dependencies
-- =============
require("NPCs/BodyLocations")

local group = BodyLocations.getGroup("Human")
local locations = group:getAllLocations()

--- Adds a new body location to the group and moves it to the top of the rendering order
--- @param name ItemBodyLocation
local function addLocation(name)
    group:getOrCreateLocation(name)
    group:moveLocationToIndex(name, 0)
end

--descending order (muscle is lower than face and bodydetail)
--muscle is lower than face to avoid visual issues if a mod adds full body textures
--Face_Model is highest to avoid floating textures
addLocation(SPNCC.ItemBodyLocation.Face_Model)
addLocation(SPNCC.ItemBodyLocation.BodyDetail2)
addLocation(SPNCC.ItemBodyLocation.StubbleHead)
addLocation(SPNCC.ItemBodyLocation.StubbleBeard)
addLocation(SPNCC.ItemBodyLocation.BodyHair)
addLocation(SPNCC.ItemBodyLocation.BodyDetail)
addLocation(SPNCC.ItemBodyLocation.Face)
addLocation(SPNCC.ItemBodyLocation.Muscle)
addLocation(SPNCC.ItemBodyLocation.Blank)

group:setMultiItem(SPNCC.ItemBodyLocation.BodyDetail, true)
group:setMultiItem(SPNCC.ItemBodyLocation.BodyDetail2, true)
