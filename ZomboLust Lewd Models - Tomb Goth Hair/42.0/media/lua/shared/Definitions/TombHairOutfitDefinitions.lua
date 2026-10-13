require 'Definitions/HairOutfitDefinitions'

--Punk
local list = {
	"M_Draven",	
	"M_Dollar",
	"F_Reaper",
	"F_Draven",
	"F_GothBob",
	"F_GothBobNobun",	
	"F_SweptFringeLong",
	"F_StraightFringeLong",
	"F_Formalgoth",
	"F_Violet",
	"M_Violent",
	
}
for k,v in pairs(list) do
	local cat = {name = v, onlyFor = "Punk"};
	table.insert(HairOutfitDefinitions.haircutDefinition, cat);
end

--Bandit
local list = {
	"M_Draven",	
	"M_Dollar",
	"F_Reaper",
	"F_Draven",
	"F_GothBob",
	"F_GothBobNobun",	
	"F_SweptFringeLong",
	"F_StraightFringeLong",
	"F_Formalgoth",
	"F_Violet",
	"M_Violent",	
	
}
for k,v in pairs(list) do
	local cat = {name = v, onlyFor = "Bandit"};
	table.insert(HairOutfitDefinitions.haircutDefinition, cat);
end

--Goth
local list = {
	"M_Draven",	
	"M_Dollar",
	"F_Reaper",
	"F_Draven",
	"F_GothBob",
	"F_GothBobNobun",	
	"F_SweptFringeLong",
	"F_StraightFringeLong",
	"F_Formalgoth",
	"F_Violet",
	"M_Violent",	
	
}
for k,v in pairs(list) do
	local cat = {name = v, onlyFor = "Goth"};
	table.insert(HairOutfitDefinitions.haircutDefinition, cat);
end

--Rocker
local list = {
	"M_Draven",	
	"M_Dollar",
	"F_Reaper",
	"F_Draven",
	"F_GothBob",
	"F_GothBobNobun",	
	"F_SweptFringeLong",
	"F_StraightFringeLong",
	"F_Formalgoth",
	"F_Violet",
	"M_Violent",	
	
}
for k,v in pairs(list) do
	local cat = {name = v, onlyFor = "Rocker"};
	table.insert(HairOutfitDefinitions.haircutDefinition, cat);
end

--TombWardrobeRocker
local list = {
	"M_Draven",	
	"M_Dollar",
	"F_Reaper",
	"F_Draven",
	"F_GothBob",
	"F_GothBobNobun",	
	"F_SweptFringeLong",
	"F_StraightFringeLong",
	"F_Formalgoth",
	"F_Violet",
	"M_Violent",	
	
}
for k,v in pairs(list) do
	local cat = {name = v, onlyFor = "Tombwardrobe_Rocker"};
	table.insert(HairOutfitDefinitions.haircutDefinition, cat);
end

--TombWardrobeGoth
local list = {
	"M_Draven",	
	"M_Dollar",
	"F_Reaper",
	"F_Draven",
	"F_GothBob",
	"F_GothBobNobun",	
	"F_SweptFringeLong",
	"F_StraightFringeLong",
	"F_Formalgoth",
	"F_Violet",
	"M_Violent",	
	
}
for k,v in pairs(list) do
	local cat = {name = v, onlyFor = "Tombwardrobe_Goth"};
	table.insert(HairOutfitDefinitions.haircutDefinition, cat);
end

--TombWardrobePure
local list = {
	"M_Draven",	
	"M_Dollar",
	"F_Reaper",
	"F_Draven",
	"F_GothBob",
	"F_GothBobNobun",	
	"F_SweptFringeLong",
	"F_StraightFringeLong",
	"F_Formalgoth",
	"F_Violet",
	"M_Violent",	
	
}
for k,v in pairs(list) do
	local cat = {name = v, onlyFor = "Tombwardrobe_Pure"};
	table.insert(HairOutfitDefinitions.haircutDefinition, cat);
end

--TombWardrobeAssassin
local list = {
	"M_Draven",	
	"M_Dollar",
	"F_Reaper",
	"F_Draven",
	"F_GothBob",
	"F_GothBobNobun",	
	"F_SweptFringeLong",
	"F_StraightFringeLong",
	"F_Formalgoth",
	"F_Violet",
	"M_Violent",	
}
for k,v in pairs(list) do
	local cat = {name = v, onlyFor = "Tombwardrobe_Assassin"};
	table.insert(HairOutfitDefinitions.haircutDefinition, cat);
end



--REMOVE FROM ZOMBIES
local excludedHairs = {
	"F_Enigma",
	"M_Enigma",

}
for k,v in pairs(excludedHairs) do
	local cat = {name = v, onlyFor = "ZombiesDontLike"};
	table.insert(HairOutfitDefinitions.haircutDefinition, cat);
end
