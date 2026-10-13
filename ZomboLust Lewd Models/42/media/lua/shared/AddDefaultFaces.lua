--- File: ZomboLust Lewd Models/42/media/lua/shared/AddDefaultFaces.lua
--- @author Spongie - ZomboLust adaptation by BlaBla 2026

-- =============
-- Dependencies
-- =============
local SPNCC_Data = require("CharacterCustomisation/SPNCC_Data")
-- local FM_Presets = require("CharacterCustomisation/FM_Presets")

    -- ----------------------
    --  	MALE FACES
    -- ----------------------
local MaleFaces = {
    --------------------------
    {	name = "Frank",
        id = "Base.Face_Frank",
    },
    --------------------------
    {	name = "James",
        id = "Base.Face_James",
    },
    --------------------------
    {	name = "Chris",
        id = "Base.Face_Chris",
    },
    --------------------------
    {	name = "Hank",
        id = "Base.Face_Hank",
    },
}
    -- ----------------------
    --  	FEMALE FACES
    -- ----------------------
local FemaleFaces = {
    --------------------------
    {	name = "CaseyJo",
        id = "Base.Face_CaseyJo",
    },
    --------------------------
    {	name = "Janine",
        id = "Base.Face_Janine",
    },
    --------------------------
    {	name = "Maryanne",
        id = "Base.Face_Maryanne",
    },
    --------------------------
    {	name = "Vicky",
        id = "Base.Face_Vicky",
    },
}

for i = 1, #MaleFaces do
    local v = MaleFaces[i]
    SPNCC_Data.AddMaleFaceData(v)
end
for i = 1, #FemaleFaces do
    local v = FemaleFaces[i]
    SPNCC_Data.AddFemaleFaceData(v)
end
