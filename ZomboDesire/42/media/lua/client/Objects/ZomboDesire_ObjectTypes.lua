--- File: ZomboDesire/42/media/lua/client/Objects/ZomboDesire_ObjectTypes.lua
--- Contains all detectable object types for ZomboDesire framework
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_ObjectTypes.lua loaded")

--- Module table for object types detection
--- @class ZomboDesire_ObjectTypes
local ZomboDesire_ObjectTypes = {}

--- Module name for logging
--- @type string
local MODULE_NAME = "ObjectTypes"

--- Table of objects to be detected with their information
--- Each entry contains a type name and a list of sprite configurations
--- @type table[]
ZomboDesire_ObjectTypes.objectTypes = {
    -- Sort by logical order of pages https://pzwiki.net/wiki/Furniture
    -- ****************************************************************
    -- /!\ Caution /!\
    -- When you want to make distinctions within the same group of objects sharing the same prefix, the order is important !
    -- Place the most specific object types before the more generic ones.
    -- First, the specific objects with their full spriteNames, and below them,
    -- the generic objects with just the spriteNames prefix (for example: Fridge).

    -- Appliances / Communication
    {
        type = "TV", 
        spriteNames = {
            -- Premium Technologies Television
            {name = "appliances_television_01_0", direction = IsoDirections.E},
            {name = "appliances_television_01_1", direction = IsoDirections.S},
            {name = "appliances_television_01_2", direction = IsoDirections.W},
            {name = "appliances_television_01_3", direction = IsoDirections.N},

            -- ValuTech Television
            {name = "appliances_television_01_4", direction = IsoDirections.S},
            {name = "appliances_television_01_5", direction = IsoDirections.E},
            {name = "appliances_television_01_6", direction = IsoDirections.N},
            {name = "appliances_television_01_7", direction = IsoDirections.W},

            -- Old Television
            {name = "appliances_television_01_8", direction = IsoDirections.E},
            {name = "appliances_television_01_9", direction = IsoDirections.S},
            {name = "appliances_television_01_10", direction = IsoDirections.W},
            {name = "appliances_television_01_11", direction = IsoDirections.N}
        }
    },

    -- Appliances / Cooking appliances
    {
        type = "Large Modern Cooker", 
        spriteNames = {
            {name = "appliances_cooking_01_40", direction = IsoDirections.E},
            {name = "appliances_cooking_01_41", direction = IsoDirections.E},
            {name = "appliances_cooking_01_42", direction = IsoDirections.S},
            {name = "appliances_cooking_01_43", direction = IsoDirections.S},
            {name = "appliances_cooking_01_48", direction = IsoDirections.W},
            {name = "appliances_cooking_01_49", direction = IsoDirections.W},
            {name = "appliances_cooking_01_50", direction = IsoDirections.N},
            {name = "appliances_cooking_01_51", direction = IsoDirections.N}
        }
    },
    {
        type = "BakeOMatic Industrial", 
        spriteNames = {
            {name = "appliances_cooking_01_64", direction = IsoDirections.E},
            {name = "appliances_cooking_01_65", direction = IsoDirections.S},
            {name = "appliances_cooking_01_66", direction = IsoDirections.W},
            {name = "appliances_cooking_01_67", direction = IsoDirections.N}
        }
    },
    {
        type = "Green Oven", 
        spriteNames = {
            {name = "appliances_cooking_01_0", direction = IsoDirections.E},
            {name = "appliances_cooking_01_1", direction = IsoDirections.S},
            {name = "appliances_cooking_01_2", direction = IsoDirections.W},
            {name = "appliances_cooking_01_3", direction = IsoDirections.N}
        }
    },
    {
        type = "Red Oven", 
        spriteNames = {
            {name = "appliances_cooking_01_8", direction = IsoDirections.E},
            {name = "appliances_cooking_01_9", direction = IsoDirections.S},
            {name = "appliances_cooking_01_10", direction = IsoDirections.W},
            {name = "appliances_cooking_01_11", direction = IsoDirections.N}
        }
    },
    {
        type = "Modern Oven", 
        spriteNames = {
            {name = "appliances_cooking_01_12", direction = IsoDirections.E},
            {name = "appliances_cooking_01_13", direction = IsoDirections.S},
            {name = "appliances_cooking_01_14", direction = IsoDirections.W},
            {name = "appliances_cooking_01_15", direction = IsoDirections.N}
        }
    },
    {
        type = "Industrial Oven", 
        spriteNames = {
            {name = "appliances_cooking_01_20", direction = IsoDirections.E},
            {name = "appliances_cooking_01_21", direction = IsoDirections.S},
            {name = "appliances_cooking_01_22", direction = IsoDirections.W},
            {name = "appliances_cooking_01_23", direction = IsoDirections.N}
        }
    },
    {
        type = "Fryers Club Industrial 2000 Oven", 
        spriteNames = {
            {name = "appliances_cooking_01_52", direction = IsoDirections.E},
            {name = "appliances_cooking_01_53", direction = IsoDirections.S},
            {name = "appliances_cooking_01_54", direction = IsoDirections.W},
            {name = "appliances_cooking_01_55", direction = IsoDirections.N}
        }
    },
    {
        type = "Old Stove Oven", 
        spriteNames = {
            {name = "appliances_cooking_01_16", direction = IsoDirections.E},
            {name = "appliances_cooking_01_17", direction = IsoDirections.S}
        }
    },
    {
        type = "Crafted Oven", 
        spriteNames = {
            {name = "crafted_05_4", direction = IsoDirections.N},
            {name = "crafted_05_5", direction = IsoDirections.W},
            {name = "crafted_05_6", direction = IsoDirections.E},
            {name = "crafted_05_7", direction = IsoDirections.S}
        }
    },
    -- Original direction non-existent
    {
        type = "Metal Drum", 
        spriteNames = {
            {name = "industry_01_22", direction = IsoDirections.S},
            {name = "industry_01_23", direction = IsoDirections.S},
            {name = "location_military_generic_01_6", direction = IsoDirections.S},
            {name = "location_military_generic_01_7", direction = IsoDirections.S},
            {name = "location_military_generic_01_14", direction = IsoDirections.S},
            {name = "location_military_generic_01_15", direction = IsoDirections.S}
        }
    },
    -- Original direction non-existent
    {
        type = "Crafted Metal Drum", 
        spriteNames = {
            {name = "crafted_01_24", direction = IsoDirections.S},
            {name = "crafted_01_25", direction = IsoDirections.S},
            {name = "crafted_01_26", direction = IsoDirections.S},
            {name = "crafted_01_27", direction = IsoDirections.S},
            {name = "crafted_01_28", direction = IsoDirections.S},
            {name = "crafted_01_29", direction = IsoDirections.S},
            {name = "crafted_01_30", direction = IsoDirections.S},
            {name = "crafted_01_31", direction = IsoDirections.S},
            {name = "crafted_01_32", direction = IsoDirections.S}
        }
    },
    -- Original direction non-existent
    {
        type = "Barbecue", 
        spriteNames = {
            {name = "appliances_cooking_01_35", direction = IsoDirections.S}
        }
    },
    {
        type = "Jorge Foreguy Barbecue", 
        spriteNames = {
            {name = "appliances_cooking_01_44", direction = IsoDirections.S},
            {name = "appliances_cooking_01_45", direction = IsoDirections.E},
            {name = "appliances_cooking_01_46", direction = IsoDirections.N},
            {name = "appliances_cooking_01_47", direction = IsoDirections.W}
        }
    },
    {
        type = "Full Jorge Foreguy Barbecue", 
        spriteNames = {
            {name = "appliances_cooking_01_36", direction = IsoDirections.S},
            {name = "appliances_cooking_01_37", direction = IsoDirections.E},
            {name = "appliances_cooking_01_38", direction = IsoDirections.N},
            {name = "appliances_cooking_01_39", direction = IsoDirections.W}
        }
    },

    -- Appliances / Fridges
    {
        type = "Mini Fridge", 
        spriteNames = {
            {name = "appliances_refrigeration_01_24", direction = IsoDirections.E},
            {name = "appliances_refrigeration_01_25", direction = IsoDirections.S},
            {name = "appliances_refrigeration_01_26", direction = IsoDirections.W},
            {name = "appliances_refrigeration_01_27", direction = IsoDirections.N}
        }
    },
    {
        type = "Popsicle Fridge", 
        spriteNames = {
            {name = "appliances_refrigeration_01_20", direction = IsoDirections.E},
            {name = "appliances_refrigeration_01_21", direction = IsoDirections.E},
            {name = "appliances_refrigeration_01_38", direction = IsoDirections.S},
            {name = "appliances_refrigeration_01_39", direction = IsoDirections.S}
        }
    },
    {
        type = "Chest Freezer", 
        spriteNames = {
            {name = "appliances_refrigeration_01_48", direction = IsoDirections.S},
            {name = "appliances_refrigeration_01_49", direction = IsoDirections.E},
            {name = "appliances_refrigeration_01_50", direction = IsoDirections.N},
            {name = "appliances_refrigeration_01_51", direction = IsoDirections.W}
        }
    },
    {
        type = "Built-in Trailer Fridge", 
        spriteNames = {
            {name = "location_trailer_02_10", direction = IsoDirections.N},
            {name = "location_trailer_02_11", direction = IsoDirections.W},
            {name = "location_trailer_02_16", direction = IsoDirections.S},
            {name = "location_trailer_02_17", direction = IsoDirections.E}
        }
    },
    {
        type = "Fridge", 
        spriteNames = {
            -- White Fridge
            {name = "appliances_refrigeration_01_0", direction = IsoDirections.S},
            {name = "appliances_refrigeration_01_1", direction = IsoDirections.E},
            {name = "appliances_refrigeration_01_2", direction = IsoDirections.N},
            {name = "appliances_refrigeration_01_3", direction = IsoDirections.W},

            -- Blue Fridge
            {name = "appliances_refrigeration_01_4", direction = IsoDirections.S},
            {name = "appliances_refrigeration_01_5", direction = IsoDirections.E},
            {name = "appliances_refrigeration_01_6", direction = IsoDirections.N},
            {name = "appliances_refrigeration_01_7", direction = IsoDirections.W},

            -- Steel Fridge
            {name = "appliances_refrigeration_01_8", direction = IsoDirections.S},
            {name = "appliances_refrigeration_01_9", direction = IsoDirections.E},
            {name = "appliances_refrigeration_01_10", direction = IsoDirections.N},
            {name = "appliances_refrigeration_01_11", direction = IsoDirections.W},

            -- Green Fridge
            {name = "appliances_refrigeration_01_12", direction = IsoDirections.S},
            {name = "appliances_refrigeration_01_13", direction = IsoDirections.E},
            {name = "appliances_refrigeration_01_14", direction = IsoDirections.N},
            {name = "appliances_refrigeration_01_15", direction = IsoDirections.W},

            -- Red Fridge
            {name = "appliances_refrigeration_01_32", direction = IsoDirections.S},
            {name = "appliances_refrigeration_01_33", direction = IsoDirections.E},
            {name = "appliances_refrigeration_01_34", direction = IsoDirections.N},
            {name = "appliances_refrigeration_01_35", direction = IsoDirections.W}
        }
    },
    {
        type = "Other Fridge", 
        spriteNames = {
            -- Large Fridge
            {name = "appliances_refrigeration_01_16", direction = IsoDirections.E},
            {name = "appliances_refrigeration_01_17", direction = IsoDirections.E},
            {name = "appliances_refrigeration_01_18", direction = IsoDirections.S},
            {name = "appliances_refrigeration_01_19", direction = IsoDirections.S},
            {name = "appliances_refrigeration_01_44", direction = IsoDirections.W},
            {name = "appliances_refrigeration_01_45", direction = IsoDirections.W},
            {name = "appliances_refrigeration_01_46", direction = IsoDirections.N},
            {name = "appliances_refrigeration_01_47", direction = IsoDirections.N},

            -- Industrial Fridge
            {name = "appliances_refrigeration_01_22", direction = IsoDirections.S},
            {name = "appliances_refrigeration_01_23", direction = IsoDirections.E},
            {name = "appliances_refrigeration_01_36", direction = IsoDirections.N},
            {name = "appliances_refrigeration_01_37", direction = IsoDirections.W},

            -- Plain Fridge
            {name = "appliances_refrigeration_01_28", direction = IsoDirections.S},
            {name = "appliances_refrigeration_01_29", direction = IsoDirections.E},
            {name = "appliances_refrigeration_01_30", direction = IsoDirections.N},
            {name = "appliances_refrigeration_01_31", direction = IsoDirections.W},

            -- White Industrial Fridge
            {name = "appliances_refrigeration_01_40", direction = IsoDirections.S},
            {name = "appliances_refrigeration_01_41", direction = IsoDirections.E},
            {name = "appliances_refrigeration_01_42", direction = IsoDirections.N},
            {name = "appliances_refrigeration_01_43", direction = IsoDirections.W}	
        }
    },
    {
        type = "Generic Cooled Shelves", 
        spriteNames = {
            {name = "location_shop_generic_01_64", direction = IsoDirections.S},
            {name = "location_shop_generic_01_65", direction = IsoDirections.S},
            {name = "location_shop_generic_01_66", direction = IsoDirections.S},
            {name = "location_shop_generic_01_67", direction = IsoDirections.E},
            {name = "location_shop_generic_01_68", direction = IsoDirections.E},
            {name = "location_shop_generic_01_69", direction = IsoDirections.E}
        }
    },
    {
        type = "White Display Counter", 
        spriteNames = {
            {name = "location_shop_generic_01_80", direction = IsoDirections.S},
            {name = "location_shop_generic_01_81", direction = IsoDirections.S},
            {name = "location_shop_generic_01_82", direction = IsoDirections.S},
            {name = "location_shop_generic_01_83", direction = IsoDirections.E},
            {name = "location_shop_generic_01_84", direction = IsoDirections.E},
            {name = "location_shop_generic_01_85", direction = IsoDirections.E}
        }
    },

    -- Appliances / Washing machines
    {
        type = "Clothes Dryer", 
        spriteNames = {
            {name = "appliances_laundry_01_12", direction = IsoDirections.S},
            {name = "appliances_laundry_01_13", direction = IsoDirections.E},
            {name = "appliances_laundry_01_14", direction = IsoDirections.N},
            {name = "appliances_laundry_01_15", direction = IsoDirections.W}
        }
    },
    {
        type = "Washing Machine", 
        spriteNames = {
            {name = "appliances_laundry_01_4", direction = IsoDirections.S},
            {name = "appliances_laundry_01_5", direction = IsoDirections.E},
            {name = "appliances_laundry_01_6", direction = IsoDirections.N},
            {name = "appliances_laundry_01_7", direction = IsoDirections.W}
        }
    },
    {
        type = "Blue Combo WasherDryer", 
        spriteNames = {
            {name = "appliances_laundry_01_0", direction = IsoDirections.S},
            {name = "appliances_laundry_01_1", direction = IsoDirections.E},
            {name = "appliances_laundry_01_2", direction = IsoDirections.N},
            {name = "appliances_laundry_01_3", direction = IsoDirections.W}
        }
    },

    -- Appliances / Other
    {
        type = "CeroSec Terminal", 
        spriteNames = {
            {name = "appliances_com_01_52", direction = IsoDirections.S},
            {name = "appliances_com_01_53", direction = IsoDirections.E},
            {name = "appliances_com_01_54", direction = IsoDirections.N},
            {name = "appliances_com_01_55", direction = IsoDirections.W}
        }
    },
    {
        type = "Security Terminal", 
        spriteNames = {
            {name = "security_01_0", direction = IsoDirections.S},
            {name = "security_01_1", direction = IsoDirections.E},
            {name = "security_01_2", direction = IsoDirections.N},
            {name = "security_01_3", direction = IsoDirections.W}
        }
    },
    {
        type = "Kaboom Arcade", 
        spriteNames = {
            {name = "recreational_01_20", direction = IsoDirections.S},
            {name = "recreational_01_21", direction = IsoDirections.E},
            {name = "recreational_01_22", direction = IsoDirections.W},
            {name = "recreational_01_23", direction = IsoDirections.N}
        }
    },
    {
        type = "Dr Oids Arcade", 
        spriteNames = {
            {name = "recreational_01_16", direction = IsoDirections.S},
            {name = "recreational_01_17", direction = IsoDirections.E},
            {name = "recreational_01_18", direction = IsoDirections.W},
            {name = "recreational_01_19", direction = IsoDirections.N}
        }
    },
    -- Need direction adjustment
    {
        type = "PAWS Pinball", 
        spriteNames = {
            {name = "recreational_01_24", direction = IsoDirections.S},
            {name = "recreational_01_25", direction = IsoDirections.E},
            {name = "recreational_01_26", direction = IsoDirections.S},
            {name = "recreational_01_27", direction = IsoDirections.E}
        }
    },
    -- ****************************************************************
    -- Plumbing / Sinks
    {
        type = "White Standing Sink", 
        spriteNames = {
            {name = "fixtures_sinks_01_12", direction = IsoDirections.S},
            {name = "fixtures_sinks_01_13", direction = IsoDirections.E},
            {name = "fixtures_sinks_01_28", direction = IsoDirections.N},
            {name = "fixtures_sinks_01_29", direction = IsoDirections.W}
        }
    },
    {
        type = "White Hanging Sink", 
        spriteNames = {
            {name = "fixtures_sinks_01_14", direction = IsoDirections.S},
            {name = "fixtures_sinks_01_15", direction = IsoDirections.E},
            {name = "fixtures_sinks_01_30", direction = IsoDirections.N},
            {name = "fixtures_sinks_01_31", direction = IsoDirections.W}
        }
    },
    {
        type = "Fancy Hanging Sink", 
        spriteNames = {
            {name = "fixtures_sinks_01_24", direction = IsoDirections.S},
            {name = "fixtures_sinks_01_25", direction = IsoDirections.E}
        }
    },
    {
        type = "Large Industrial Sink", 
        spriteNames = {
            {name = "fixtures_sinks_01_32", direction = IsoDirections.E},
            {name = "fixtures_sinks_01_33", direction = IsoDirections.S},
            {name = "fixtures_sinks_01_34", direction = IsoDirections.W},
            {name = "fixtures_sinks_01_35", direction = IsoDirections.N}
        }
    },

    -- Plumbing / Baths and showers
    {
        type = "Large Deluxe Bath", 
        spriteNames = {
            {name = "fixtures_bathroom_01_24", direction = IsoDirections.E},
            {name = "fixtures_bathroom_01_25", direction = IsoDirections.E},
            {name = "fixtures_bathroom_01_26", direction = IsoDirections.S},
            {name = "fixtures_bathroom_01_27", direction = IsoDirections.S},
            {name = "fixtures_bathroom_01_52", direction = IsoDirections.W},
            {name = "fixtures_bathroom_01_53", direction = IsoDirections.W},
            {name = "fixtures_bathroom_01_54", direction = IsoDirections.N},
            {name = "fixtures_bathroom_01_55", direction = IsoDirections.N}
        }
    },
    -- Not on the wiki list
    -- Original direction non-existent
    {
        type = "Shower screen", 
        spriteNames = {
            {name = "fixtures_bathroom_01_34", direction = IsoDirections.E},
            {name = "fixtures_bathroom_01_35", direction = IsoDirections.S}
        }
    },

    -- Plumbing / Toilets
    {
        type = "Fancy Toilet", 
        spriteNames = {
            {name = "fixtures_bathroom_01_0", direction = IsoDirections.S},
            {name = "fixtures_bathroom_01_1", direction = IsoDirections.E},
            {name = "fixtures_bathroom_01_2", direction = IsoDirections.W},
            {name = "fixtures_bathroom_01_3", direction = IsoDirections.N}
        }
    },
    {
        type = "Low Toilet", 
        spriteNames = {
            {name = "fixtures_bathroom_01_4", direction = IsoDirections.S},
            {name = "fixtures_bathroom_01_5", direction = IsoDirections.E},
            {name = "fixtures_bathroom_01_6", direction = IsoDirections.W},
            {name = "fixtures_bathroom_01_7", direction = IsoDirections.N}
        }
    },
    {
        type = "Hanging Toilet", 
        spriteNames = {
            {name = "fixtures_bathroom_01_8", direction = IsoDirections.S},
            {name = "fixtures_bathroom_01_9", direction = IsoDirections.E},
            {name = "fixtures_bathroom_01_10", direction = IsoDirections.N},
            {name = "fixtures_bathroom_01_11", direction = IsoDirections.W}
        }
    },
    {
        type = "Chemical Toilet", 
        spriteNames = {
            {name = "fixtures_bathroom_02_4", direction = IsoDirections.S},
            {name = "fixtures_bathroom_02_5", direction = IsoDirections.E},
            {name = "fixtures_bathroom_02_14", direction = IsoDirections.W},
            {name = "fixtures_bathroom_02_15", direction = IsoDirections.N}
        }
    },
    {
        type = "Wooden Toilet", 
        spriteNames = {
            {name = "fixtures_bathroom_02_24", direction = IsoDirections.E},
            {name = "fixtures_bathroom_02_25", direction = IsoDirections.S},
            {name = "fixtures_bathroom_02_26", direction = IsoDirections.W},
            {name = "fixtures_bathroom_02_27", direction = IsoDirections.N}
        }
    },

    -- Plumbing / Other
    {
        type = "Water Dispenser", 
        spriteNames = {
            {name = "location_business_office_generic_01_48", direction = IsoDirections.E},
            {name = "location_business_office_generic_01_49", direction = IsoDirections.S},
            {name = "location_business_office_generic_01_56", direction = IsoDirections.W},
            {name = "location_business_office_generic_01_57", direction = IsoDirections.N}
        }
    },
    {
        type = "Empty Water Dispenser", 
        spriteNames = {
            {name = "location_business_office_generic_01_58", direction = IsoDirections.E},
            {name = "location_business_office_generic_01_59", direction = IsoDirections.S},
            {name = "location_business_office_generic_01_60", direction = IsoDirections.W},
            {name = "location_business_office_generic_01_61", direction = IsoDirections.N}
        }
    },
    -- ****************************************************************
    -- Comfort / Beds
    {
        type = "Twin Beds", 
        spriteNames = {
            {name = "furniture_bedding_01_36", direction = IsoDirections.E},
            {name = "furniture_bedding_01_37", direction = IsoDirections.E},
            {name = "furniture_bedding_01_38", direction = IsoDirections.S},
            {name = "furniture_bedding_01_39", direction = IsoDirections.S}
        }
    },
    {
        type = "Bunk Beds", 
        spriteNames = {
            {name = "furniture_bedding_01_84", direction = IsoDirections.S},
            {name = "furniture_bedding_01_85", direction = IsoDirections.S},
            {name = "furniture_bedding_01_86", direction = IsoDirections.E},
            {name = "furniture_bedding_01_87", direction = IsoDirections.E}
        }
    },
    {
        type = "Fancy Bed", 
        spriteNames = {
            {name = "furniture_bedding_01_0", direction = IsoDirections.S},
            {name = "furniture_bedding_01_1", direction = IsoDirections.S},
            {name = "furniture_bedding_01_2", direction = IsoDirections.E},
            {name = "furniture_bedding_01_3", direction = IsoDirections.E},
            {name = "furniture_bedding_01_68", direction = IsoDirections.N},
            {name = "furniture_bedding_01_69", direction = IsoDirections.N},
            {name = "furniture_bedding_01_70", direction = IsoDirections.W},
            {name = "furniture_bedding_01_71", direction = IsoDirections.W}
        }
    },
    {
        type = "Large Fancy Bed", 
        spriteNames = {
            {name = "furniture_bedding_01_4", direction = IsoDirections.S},
            {name = "furniture_bedding_01_5", direction = IsoDirections.S},
            {name = "furniture_bedding_01_6", direction = IsoDirections.S},
            {name = "furniture_bedding_01_7", direction = IsoDirections.S},
            {name = "furniture_bedding_01_12", direction = IsoDirections.E},
            {name = "furniture_bedding_01_13", direction = IsoDirections.E},
            {name = "furniture_bedding_01_14", direction = IsoDirections.E},
            {name = "furniture_bedding_01_15", direction = IsoDirections.E},
            {name = "furniture_bedding_01_72", direction = IsoDirections.N},
            {name = "furniture_bedding_01_73", direction = IsoDirections.N},
            {name = "furniture_bedding_01_74", direction = IsoDirections.N},
            {name = "furniture_bedding_01_75", direction = IsoDirections.N},
            {name = "furniture_bedding_01_80", direction = IsoDirections.W},
            {name = "furniture_bedding_01_81", direction = IsoDirections.W},
            {name = "furniture_bedding_01_82", direction = IsoDirections.W},
            {name = "furniture_bedding_01_83", direction = IsoDirections.W}
        }
    },
    {
        type = "Blue Bed", 
        spriteNames = {
            {name = "furniture_bedding_01_8", direction = IsoDirections.S},
            {name = "furniture_bedding_01_9", direction = IsoDirections.S},
            {name = "furniture_bedding_01_10", direction = IsoDirections.E},
            {name = "furniture_bedding_01_11", direction = IsoDirections.E},
            {name = "furniture_bedding_01_76", direction = IsoDirections.N},
            {name = "furniture_bedding_01_77", direction = IsoDirections.N},
            {name = "furniture_bedding_01_78", direction = IsoDirections.W},
            {name = "furniture_bedding_01_79", direction = IsoDirections.W}
        }
    },
    {
        type = "Large Modern Bed", 
        spriteNames = {
            {name = "furniture_bedding_01_16", direction = IsoDirections.W},
            {name = "furniture_bedding_01_17", direction = IsoDirections.W},
            {name = "furniture_bedding_01_18", direction = IsoDirections.W},
            {name = "furniture_bedding_01_19", direction = IsoDirections.W},
            {name = "furniture_bedding_01_20", direction = IsoDirections.N},
            {name = "furniture_bedding_01_21", direction = IsoDirections.N},
            {name = "furniture_bedding_01_22", direction = IsoDirections.N},
            {name = "furniture_bedding_01_23", direction = IsoDirections.N},
            {name = "furniture_bedding_01_24", direction = IsoDirections.S},
            {name = "furniture_bedding_01_25", direction = IsoDirections.S},
            {name = "furniture_bedding_01_26", direction = IsoDirections.S},
            {name = "furniture_bedding_01_27", direction = IsoDirections.S},
            {name = "furniture_bedding_01_28", direction = IsoDirections.E},
            {name = "furniture_bedding_01_29", direction = IsoDirections.E},
            {name = "furniture_bedding_01_30", direction = IsoDirections.E},
            {name = "furniture_bedding_01_31", direction = IsoDirections.E}
        }
    },
    {
        type = "Simple Bed", 
        spriteNames = {
            {name = "furniture_bedding_01_32", direction = IsoDirections.E},
            {name = "furniture_bedding_01_33", direction = IsoDirections.E},
            {name = "furniture_bedding_01_34", direction = IsoDirections.S},
            {name = "furniture_bedding_01_35", direction = IsoDirections.S},
            {name = "furniture_bedding_01_60", direction = IsoDirections.W},
            {name = "furniture_bedding_01_61", direction = IsoDirections.W},
            {name = "furniture_bedding_01_62", direction = IsoDirections.N},
            {name = "furniture_bedding_01_63", direction = IsoDirections.N}
        }
    },
    {
        type = "Large Oak Bed", 
        spriteNames = {
            {name = "furniture_bedding_01_40", direction = IsoDirections.E},
            {name = "furniture_bedding_01_41", direction = IsoDirections.E},
            {name = "furniture_bedding_01_42", direction = IsoDirections.E},
            {name = "furniture_bedding_01_43", direction = IsoDirections.E},
            {name = "furniture_bedding_01_44", direction = IsoDirections.S},
            {name = "furniture_bedding_01_45", direction = IsoDirections.S},
            {name = "furniture_bedding_01_46", direction = IsoDirections.S},
            {name = "furniture_bedding_01_47", direction = IsoDirections.S},
            {name = "furniture_bedding_01_48", direction = IsoDirections.W},
            {name = "furniture_bedding_01_49", direction = IsoDirections.W},
            {name = "furniture_bedding_01_50", direction = IsoDirections.W},
            {name = "furniture_bedding_01_51", direction = IsoDirections.W},
            {name = "furniture_bedding_01_52", direction = IsoDirections.N},
            {name = "furniture_bedding_01_53", direction = IsoDirections.N},
            {name = "furniture_bedding_01_54", direction = IsoDirections.N},
            {name = "furniture_bedding_01_55", direction = IsoDirections.N}
        }
    },
    {
        type = "Stretcher Bed", 
        spriteNames = {
            {name = "furniture_bedding_01_56", direction = IsoDirections.S},
            {name = "furniture_bedding_01_57", direction = IsoDirections.S},
            {name = "furniture_bedding_01_58", direction = IsoDirections.E},
            {name = "furniture_bedding_01_59", direction = IsoDirections.E}
        }
    },
    {
        type = "Baby Crib Bed", 
        spriteNames = {
            {name = "furniture_bedding_01_88", direction = IsoDirections.S},
            {name = "furniture_bedding_01_89", direction = IsoDirections.S},
            {name = "furniture_bedding_01_90", direction = IsoDirections.E},
            {name = "furniture_bedding_01_91", direction = IsoDirections.E},
            {name = "furniture_bedding_01_92", direction = IsoDirections.S},
            {name = "furniture_bedding_01_93", direction = IsoDirections.S},
            {name = "furniture_bedding_01_94", direction = IsoDirections.E},
            {name = "furniture_bedding_01_95", direction = IsoDirections.E}
        }
    },
    {
        type = "Gurney Bed", 
        spriteNames = {
            {name = "location_community_medical_01_72", direction = IsoDirections.S},
            {name = "location_community_medical_01_73", direction = IsoDirections.S},
            {name = "location_community_medical_01_74", direction = IsoDirections.E},
            {name = "location_community_medical_01_75", direction = IsoDirections.E}
        }
    },
    {
        type = "Dentist Patient Bed", 
        spriteNames = {
            {name = "location_community_medical_01_0", direction = IsoDirections.E},
            {name = "location_community_medical_01_1", direction = IsoDirections.E},
            {name = "location_community_medical_01_2", direction = IsoDirections.S},
            {name = "location_community_medical_01_3", direction = IsoDirections.S},
            {name = "location_community_medical_01_4", direction = IsoDirections.W},
            {name = "location_community_medical_01_5", direction = IsoDirections.W},
            {name = "location_community_medical_01_6", direction = IsoDirections.N},
            {name = "location_community_medical_01_7", direction = IsoDirections.N}
        }
    },
    {
        type = "Large Medical Bed", 
        spriteNames = {
            {name = "location_community_medical_01_16", direction = IsoDirections.E},
            {name = "location_community_medical_01_17", direction = IsoDirections.E},
            {name = "location_community_medical_01_18", direction = IsoDirections.W},
            {name = "location_community_medical_01_19", direction = IsoDirections.W},
            {name = "location_community_medical_01_20", direction = IsoDirections.S},
            {name = "location_community_medical_01_21", direction = IsoDirections.S},
            {name = "location_community_medical_01_22", direction = IsoDirections.N},
            {name = "location_community_medical_01_23", direction = IsoDirections.N}
        }
    },
    {
        type = "Patient Bed", 
        spriteNames = {
            {name = "location_community_medical_01_32", direction = IsoDirections.E},
            {name = "location_community_medical_01_33", direction = IsoDirections.E},
            {name = "location_community_medical_01_34", direction = IsoDirections.S},
            {name = "location_community_medical_01_35", direction = IsoDirections.S}
        }
    },
    {
        type = "Police Prisoners Bed", 
        spriteNames = {
            {name = "location_community_police_01_24", direction = IsoDirections.E},
            {name = "location_community_police_01_25", direction = IsoDirections.E},
            {name = "location_community_police_01_26", direction = IsoDirections.S},
            {name = "location_community_police_01_27", direction = IsoDirections.S},
            {name = "location_community_police_01_28", direction = IsoDirections.N},
            {name = "location_community_police_01_29", direction = IsoDirections.N},
            {name = "location_community_police_01_30", direction = IsoDirections.W},
            {name = "location_community_police_01_31", direction = IsoDirections.W}
        }
    },

    -- Comfort / Couches
    {
        type = "Red Comfy Couch", 
        spriteNames = {
            {name = "furniture_seating_indoor_01_0", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_01_1", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_01_2", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_01_3", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_01_4", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_01_5", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_01_6", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_01_7", direction = IsoDirections.N}
        }
    },
    {
        type = "Green Comfy Couch", 
        spriteNames = {
            {name = "furniture_seating_indoor_01_16", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_01_17", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_01_18", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_01_19", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_01_20", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_01_21", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_01_22", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_01_23", direction = IsoDirections.W}
        }
    },
    {
        type = "Purple Rattan Couch", 
        spriteNames = {
            {name = "furniture_seating_indoor_01_24", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_01_25", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_01_26", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_01_27", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_01_28", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_01_29", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_01_30", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_01_31", direction = IsoDirections.N}
        }
    },
    {
        type = "White Lazy Couch", 
        spriteNames = {
            {name = "furniture_seating_indoor_02_24", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_25", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_26", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_27", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_28", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_02_29", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_02_30", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_02_31", direction = IsoDirections.N}
        }
    },
    {
        type = "Blue Rattan Couch", 
        spriteNames = {
            {name = "furniture_seating_indoor_02_32", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_33", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_34", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_35", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_36", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_02_37", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_02_38", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_02_39", direction = IsoDirections.N}
        }
    },
    {
        type = "Brown Lazy Couch", 
        spriteNames = {
            {name = "furniture_seating_indoor_02_48", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_49", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_50", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_51", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_52", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_02_53", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_02_54", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_02_55", direction = IsoDirections.N}
        }
    },
    {
        type = "Grey Lazy Couch", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_8", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_9", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_10", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_11", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_12", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_13", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_14", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_15", direction = IsoDirections.N}
        }
    },
    {
        type = "Yellow Modern Couch", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_16", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_17", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_18", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_19", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_20", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_21", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_22", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_23", direction = IsoDirections.N}
        }
    },
    {
        type = "Blue Comfy Couch", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_32", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_33", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_34", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_35", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_36", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_37", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_38", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_39", direction = IsoDirections.W}
        }
    },
    {
        type = "Victorian C1 Couch", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_72", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_73", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_74", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_75", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_76", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_77", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_78", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_79", direction = IsoDirections.W}
        }
    },
    {
        type = "Victorian C2 Couch", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_88", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_89", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_90", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_91", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_92", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_93", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_94", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_95", direction = IsoDirections.W}
        }
    },
    {
        type = "Victorian C3 Couch", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_104", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_105", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_106", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_107", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_108", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_109", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_110", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_111", direction = IsoDirections.W}
        }
    },
    {
        type = "Victorian C4 Couch", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_112", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_113", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_114", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_115", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_116", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_117", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_118", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_119", direction = IsoDirections.W}
        }
    },
    {
        type = "Victorian C5 Couch", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_128", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_129", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_130", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_131", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_132", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_133", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_134", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_135", direction = IsoDirections.W}
        }
    },
    {
        type = "Victorian C6 Couch", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_136", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_137", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_138", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_139", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_140", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_141", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_142", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_143", direction = IsoDirections.W}
        }
    },

    -- Comfort / Chairs
    {
        type = "Crafted Chair", 
        spriteNames = {
            {name = "carpentry_01_40", direction = IsoDirections.S},
            {name = "carpentry_01_41", direction = IsoDirections.E},
            {name = "carpentry_01_42", direction = IsoDirections.N},
            {name = "carpentry_01_43", direction = IsoDirections.W}
        }
    },
    {
        type = "Green Comfy Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_01_8", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_01_9", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_01_10", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_01_11", direction = IsoDirections.N}
        }
    },
    {
        type = "Orange Modern Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_01_12", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_01_13", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_01_14", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_01_15", direction = IsoDirections.N}
        }
    },
    {
        type = "Purple Rattan Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_01_32", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_01_33", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_01_34", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_01_35", direction = IsoDirections.N}
        }
    },
    {
        type = "White Fancy Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_01_36", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_01_37", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_01_38", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_01_39", direction = IsoDirections.N}
        }
    },
    {
        type = "Red Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_01_40", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_01_41", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_01_42", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_01_43", direction = IsoDirections.N}
        }
    },
    {
        type = "White Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_01_44", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_01_45", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_60", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_61", direction = IsoDirections.N}
        }
    },
    {
        type = "Black Office Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_01_48", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_01_49", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_01_50", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_01_51", direction = IsoDirections.N}
        }
    },
    {
        type = "Green Wooden Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_01_56", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_01_57", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_01_58", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_01_59", direction = IsoDirections.N}
        }
    },
    {
        type = "Folding Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_01_60", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_01_61", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_01_62", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_01_63", direction = IsoDirections.W}
        }
    },
    {
        type = "Dark Wooden Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_02_0", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_1", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_2", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_02_3", direction = IsoDirections.W}
        }
    },
    {
        type = "Wooden Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_02_4", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_5", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_6", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_02_7", direction = IsoDirections.N}
        }
    },
    {
        type = "Red Wooden Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_02_8", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_9", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_10", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_02_11", direction = IsoDirections.N}
        }
    },
    {
        type = "Blue Plastic Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_02_12", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_13", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_14", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_02_15", direction = IsoDirections.N}
        }
    },
    {
        type = "White Lazy Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_02_20", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_21", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_22", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_02_23", direction = IsoDirections.N}
        }
    },
    {
        type = "Blue Rattan Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_02_40", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_41", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_42", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_02_43", direction = IsoDirections.N}
        }
    },
    {
        type = "Brown Lazy Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_02_44", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_45", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_46", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_02_47", direction = IsoDirections.N}
        }
    },
    {
        type = "White Wooden Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_02_56", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_57", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_58", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_02_59", direction = IsoDirections.W}
        }
    },
    {
        type = "Grey Lazy Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_4", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_5", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_6", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_7", direction = IsoDirections.N}
        }
    },
    {
        type = "Blue Comfy Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_24", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_25", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_26", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_27", direction = IsoDirections.N}
        }
    },
    {
        type = "Yellow Modern Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_28", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_29", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_30", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_31", direction = IsoDirections.N}
        }
    },
    {
        type = "Black Fancy Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_40", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_41", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_42", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_43", direction = IsoDirections.N}
        }
    },
    {
        type = "Purple Wooden Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_44", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_45", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_46", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_47", direction = IsoDirections.N}
        }
    },
    {
        type = "Dark Blue Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_48", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_49", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_50", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_51", direction = IsoDirections.N}
        }
    },
    {
        type = "White Simple Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_56", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_57", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_58", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_59", direction = IsoDirections.N}
        }
    },
    {
        type = "Grey Plastic Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_68", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_69", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_70", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_71", direction = IsoDirections.N}
        }
    },
    {
        type = "Victorian 1 Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_80", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_81", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_82", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_83", direction = IsoDirections.W}
        }
    },
    {
        type = "Victorian 2 Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_84", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_85", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_86", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_87", direction = IsoDirections.W}
        }
    },
    {
        type = "Victorian 3 Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_96", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_97", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_98", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_99", direction = IsoDirections.W}
        }
    },
    {
        type = "Victorian 4 Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_100", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_101", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_102", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_103", direction = IsoDirections.W}
        }
    },
    {
        type = "Victorian 5 Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_120", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_121", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_122", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_123", direction = IsoDirections.W}
        }
    },
    {
        type = "Victorian 6 Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_124", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_125", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_126", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_127", direction = IsoDirections.W}
        }
    },
    {
        type = "Rocking Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_144", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_145", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_146", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_147", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_148", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_149", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_150", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_151", direction = IsoDirections.W}
        }
    },
    {
        type = "Plastic Chair", 
        spriteNames = {
            {name = "furniture_seating_outdoor_01_16", direction = IsoDirections.E},
            {name = "furniture_seating_outdoor_01_17", direction = IsoDirections.S},
            {name = "furniture_seating_outdoor_01_18", direction = IsoDirections.N},
            {name = "furniture_seating_outdoor_01_19", direction = IsoDirections.W}
        }
    },
    {
        type = "Beach Chair", 
        spriteNames = {
            {name = "furniture_seating_outdoor_01_24", direction = IsoDirections.S},
            {name = "furniture_seating_outdoor_01_25", direction = IsoDirections.S},
            {name = "furniture_seating_outdoor_01_26", direction = IsoDirections.E},
            {name = "furniture_seating_outdoor_01_27", direction = IsoDirections.E},
            {name = "furniture_seating_outdoor_01_28", direction = IsoDirections.N},
            {name = "furniture_seating_outdoor_01_29", direction = IsoDirections.N},
            {name = "furniture_seating_outdoor_01_30", direction = IsoDirections.W},
            {name = "furniture_seating_outdoor_01_31", direction = IsoDirections.W}
        }
    },
    {
        type = "Blue Theater Chair", 
        spriteNames = {
            {name = "location_entertainment_theatre_01_0", direction = IsoDirections.E},
            {name = "location_entertainment_theatre_01_1", direction = IsoDirections.S},
            {name = "location_entertainment_theatre_01_2", direction = IsoDirections.W},
            {name = "location_entertainment_theatre_01_3", direction = IsoDirections.N}
        }
    },
    {
        type = "Red Theatre Chair", 
        spriteNames = {
            {name = "location_entertainment_theatre_01_88", direction = IsoDirections.E},
            {name = "location_entertainment_theatre_01_89", direction = IsoDirections.S},
            {name = "location_entertainment_theatre_01_90", direction = IsoDirections.W},
            {name = "location_entertainment_theatre_01_91", direction = IsoDirections.N}
        }
    },
    {
        type = "Pile o Crepe Chair", 
        spriteNames = {
            {name = "location_restaurant_pileocrepe_01_40", direction = IsoDirections.E},
            {name = "location_restaurant_pileocrepe_01_41", direction = IsoDirections.S},
            {name = "location_restaurant_pileocrepe_01_42", direction = IsoDirections.W},
            {name = "location_restaurant_pileocrepe_01_43", direction = IsoDirections.N}
        }
    },
    {
        type = "Spiffo Dinner Chair", 
        spriteNames = {
            {name = "location_restaurant_spiffos_02_24", direction = IsoDirections.S},
            {name = "location_restaurant_spiffos_02_25", direction = IsoDirections.E},
            {name = "location_restaurant_spiffos_02_26", direction = IsoDirections.N},
            {name = "location_restaurant_spiffos_02_27", direction = IsoDirections.W}
        }
    },
    {
        type = "Salon Chair", 
        spriteNames = {
            {name = "location_services_beauty_01_0", direction = IsoDirections.W},
            {name = "location_services_beauty_01_1", direction = IsoDirections.E},
            {name = "location_services_beauty_01_2", direction = IsoDirections.S},
            {name = "location_services_beauty_01_3", direction = IsoDirections.N}
        }
    },
    {
        type = "Mall Chair", 
        spriteNames = {
            {name = "location_shop_mall_01_40", direction = IsoDirections.S},
            {name = "location_shop_mall_01_41", direction = IsoDirections.E},
            {name = "location_shop_mall_01_42", direction = IsoDirections.N},
            {name = "location_shop_mall_01_43", direction = IsoDirections.W}
        }
    },
    -- Not on the wiki list
    {
        type = "Grey Chair", 
        spriteNames = {
            {name = "furniture_seating_indoor_01_52", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_01_53", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_01_54", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_01_55", direction = IsoDirections.N}
        }
    },

    -- Comfort / Benches
    {
        type = "Wooden Bench", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_66", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_67", direction = IsoDirections.N}
        }
    },
    {
        type = "Park Bench", 
        spriteNames = {
            {name = "furniture_seating_outdoor_01_0", direction = IsoDirections.S},
            {name = "furniture_seating_outdoor_01_1", direction = IsoDirections.S},
            {name = "furniture_seating_outdoor_01_2", direction = IsoDirections.E},
            {name = "furniture_seating_outdoor_01_3", direction = IsoDirections.E},
            {name = "furniture_seating_outdoor_01_4", direction = IsoDirections.N},
            {name = "furniture_seating_outdoor_01_5", direction = IsoDirections.N},
            {name = "furniture_seating_outdoor_01_6", direction = IsoDirections.W},
            {name = "furniture_seating_outdoor_01_7", direction = IsoDirections.W}
        }
    },
    {
        type = "Log Bench", 
        spriteNames = {
            {name = "crafted_02_56", direction = IsoDirections.E},
            {name = "crafted_02_57", direction = IsoDirections.E},
            {name = "crafted_02_58", direction = IsoDirections.S},
            {name = "crafted_02_59", direction = IsoDirections.S}
        }
    },
    {
        type = "Sturdy Bench", 
        spriteNames = {
            {name = "furniture_seating_indoor_02_16", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_17", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_18", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_19", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_52", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_53", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_03_54", direction = IsoDirections.N},
            {name = "furniture_seating_indoor_03_55", direction = IsoDirections.N}
        }
    },
    {
        type = "Long Wooden Bench", 
        spriteNames = {
            {name = "furniture_seating_indoor_02_60", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_61", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_02_62", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_02_63", direction = IsoDirections.E}
        }
    },
    {
        type = "Sports Bench", 
        spriteNames = {
            {name = "furniture_seating_indoor_03_0", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_1", direction = IsoDirections.S},
            {name = "furniture_seating_indoor_03_2", direction = IsoDirections.E},
            {name = "furniture_seating_indoor_03_3", direction = IsoDirections.E}
        }
    },
    {
        type = "Fancy Outdoors Bench", 
        spriteNames = {
            {name = "furniture_seating_outdoor_01_8", direction = IsoDirections.E},
            {name = "furniture_seating_outdoor_01_9", direction = IsoDirections.E},
            {name = "furniture_seating_outdoor_01_10", direction = IsoDirections.S},
            {name = "furniture_seating_outdoor_01_11", direction = IsoDirections.S},
            {name = "furniture_seating_outdoor_01_12", direction = IsoDirections.N},
            {name = "furniture_seating_outdoor_01_13", direction = IsoDirections.N},
            {name = "furniture_seating_outdoor_01_14", direction = IsoDirections.W},
            {name = "furniture_seating_outdoor_01_15", direction = IsoDirections.W}
        }
    },
    {
        type = "Oakwood Bench", 
        spriteNames = {
            {name = "furniture_seating_outdoor_01_20", direction = IsoDirections.S},
            {name = "furniture_seating_outdoor_01_21", direction = IsoDirections.S},
            {name = "furniture_seating_outdoor_01_22", direction = IsoDirections.E},
            {name = "furniture_seating_outdoor_01_23", direction = IsoDirections.E}
        }
    },
    {
        type = "Birchwood Bench", 
        spriteNames = {
            {name = "furniture_seating_outdoor_01_32", direction = IsoDirections.S},
            {name = "furniture_seating_outdoor_01_33", direction = IsoDirections.S},
            {name = "furniture_seating_outdoor_01_34", direction = IsoDirections.E},
            {name = "furniture_seating_outdoor_01_35", direction = IsoDirections.E}
        }
    },
    {
        type = "Brick Mall Bench", 
        spriteNames = {
            {name = "location_shop_mall_01_32", direction = IsoDirections.E},
            {name = "location_shop_mall_01_33", direction = IsoDirections.E},
            {name = "location_shop_mall_01_34", direction = IsoDirections.S},
            {name = "location_shop_mall_01_35", direction = IsoDirections.S},
            {name = "location_shop_mall_01_36", direction = IsoDirections.W},
            {name = "location_shop_mall_01_37", direction = IsoDirections.W},
            {name = "location_shop_mall_01_38", direction = IsoDirections.N},
            {name = "location_shop_mall_01_39", direction = IsoDirections.N}
        }
    },
    {
        type = "Low Bench Trailer", 
        spriteNames = {
            {name = "location_trailer_02_8", direction = IsoDirections.E},
            {name = "location_trailer_02_9", direction = IsoDirections.S}
        }
    },

    -- Comfort / Stools
    {
        type = "Wooden Bar Stool", 
        spriteNames = {
            {name = "crafted_02_93", direction = IsoDirections.E},
            {name = "crafted_02_94", direction = IsoDirections.S}
        }
    },
    {
        type = "Branch Stool", 
        spriteNames = {
            {name = "crafted_04_112", direction = IsoDirections.E},
            {name = "crafted_04_113", direction = IsoDirections.S}
        }
    },
    -- Not on the wiki list
    {
        type = "Large Bar Stool", 
        spriteNames = {
            {name = "location_restaurant_bar_01_25", direction = IsoDirections.S}
        }
    },
    {
        type = "Bar Stool", 
        spriteNames = {
            {name = "location_restaurant_bar_01_26", direction = IsoDirections.S}
        }
    },
    {
        type = "50s Bar Stool", 
        spriteNames = {
            {name = "location_restaurant_diner_01_42", direction = IsoDirections.S}
        }
    },
    {
        type = "Piano Stool", 
        spriteNames = {
            {name = "recreational_01_10", direction = IsoDirections.S},
            {name = "recreational_01_11", direction = IsoDirections.S},
            {name = "recreational_01_14", direction = IsoDirections.E},
            {name = "recreational_01_15", direction = IsoDirections.E}
        }
    },
    -- Original direction non-existent
    {
        type = "Drum Stool", 
        spriteNames = {
            {name = "recreational_01_62", direction = IsoDirections.S}
        }
    },

    -- Comfort / Seats
    {
        type = "Hanging Seat", 
        spriteNames = {
            {name = "location_community_police_01_32", direction = IsoDirections.N},
            {name = "location_community_police_01_33", direction = IsoDirections.E},
            {name = "location_community_police_01_34", direction = IsoDirections.S},
            {name = "location_community_police_01_35", direction = IsoDirections.W}
        }
    },
    {
        type = "Leather Bar Seat", 
        spriteNames = {
            {name = "location_restaurant_bar_01_8", direction = IsoDirections.N},
            {name = "location_restaurant_bar_01_9", direction = IsoDirections.N},
            {name = "location_restaurant_bar_01_10", direction = IsoDirections.W},
            {name = "location_restaurant_bar_01_11", direction = IsoDirections.W},
            {name = "location_restaurant_bar_01_12", direction = IsoDirections.E},
            {name = "location_restaurant_bar_01_13", direction = IsoDirections.E},
            {name = "location_restaurant_bar_01_14", direction = IsoDirections.S},
            {name = "location_restaurant_bar_01_15", direction = IsoDirections.S}
        }
    },
    {
        type = "50s Seat", 
        spriteNames = {
            {name = "location_restaurant_diner_01_32", direction = IsoDirections.S},
            {name = "location_restaurant_diner_01_33", direction = IsoDirections.S},
            {name = "location_restaurant_diner_01_34", direction = IsoDirections.E},
            {name = "location_restaurant_diner_01_35", direction = IsoDirections.E},
            {name = "location_restaurant_diner_01_36", direction = IsoDirections.N},
            {name = "location_restaurant_diner_01_37", direction = IsoDirections.N},
            {name = "location_restaurant_diner_01_38", direction = IsoDirections.W},
            {name = "location_restaurant_diner_01_39", direction = IsoDirections.W}
        }
    },
    {
        type = "Blue Seat", 
        spriteNames = {
            {name = "location_restaurant_pileocrepe_01_24", direction = IsoDirections.E},
            {name = "location_restaurant_pileocrepe_01_25", direction = IsoDirections.E},
            {name = "location_restaurant_pileocrepe_01_26", direction = IsoDirections.W},
            {name = "location_restaurant_pileocrepe_01_27", direction = IsoDirections.W},
            {name = "location_restaurant_pileocrepe_01_28", direction = IsoDirections.S},
            {name = "location_restaurant_pileocrepe_01_29", direction = IsoDirections.S},
            {name = "location_restaurant_pileocrepe_01_30", direction = IsoDirections.N},
            {name = "location_restaurant_pileocrepe_01_31", direction = IsoDirections.N}
        }
    },
    {
        type = "Pizza Whirled Seat", 
        spriteNames = {
            {name = "location_restaurant_pizzawhirled_01_40", direction = IsoDirections.E},
            {name = "location_restaurant_pizzawhirled_01_41", direction = IsoDirections.E},
            {name = "location_restaurant_pizzawhirled_01_42", direction = IsoDirections.W},
            {name = "location_restaurant_pizzawhirled_01_43", direction = IsoDirections.W},
            {name = "location_restaurant_pizzawhirled_01_44", direction = IsoDirections.S},
            {name = "location_restaurant_pizzawhirled_01_45", direction = IsoDirections.S},
            {name = "location_restaurant_pizzawhirled_01_46", direction = IsoDirections.N},
            {name = "location_restaurant_pizzawhirled_01_47", direction = IsoDirections.N}
        }
    },
    {
        type = "Spiffo Lounge Seat", 
        spriteNames = {
            {name = "location_restaurant_spiffos_02_16", direction = IsoDirections.E},
            {name = "location_restaurant_spiffos_02_17", direction = IsoDirections.E},
            {name = "location_restaurant_spiffos_02_18", direction = IsoDirections.W},
            {name = "location_restaurant_spiffos_02_19", direction = IsoDirections.W},
            {name = "location_restaurant_spiffos_02_20", direction = IsoDirections.S},
            {name = "location_restaurant_spiffos_02_21", direction = IsoDirections.S},
            {name = "location_restaurant_spiffos_02_22", direction = IsoDirections.N},
            {name = "location_restaurant_spiffos_02_23", direction = IsoDirections.N}
        }
    },
    {
        type = "Trailer Fixed Seat", 
        spriteNames = {
            {name = "location_trailer_02_0", direction = IsoDirections.E},
            {name = "location_trailer_02_1", direction = IsoDirections.E},
            {name = "location_trailer_02_2", direction = IsoDirections.S},
            {name = "location_trailer_02_3", direction = IsoDirections.S},
            {name = "location_trailer_02_4", direction = IsoDirections.W},
            {name = "location_trailer_02_5", direction = IsoDirections.W},
            {name = "location_trailer_02_6", direction = IsoDirections.N},
            {name = "location_trailer_02_7", direction = IsoDirections.N}
        }
    },

    -- Comfort / Other
    {
        type = "Church Pew", 
        spriteNames = {
            {name = "location_community_church_small_01_48", direction = IsoDirections.E},
            {name = "location_community_church_small_01_49", direction = IsoDirections.E},
            {name = "location_community_church_small_01_50", direction = IsoDirections.E},
            {name = "location_community_church_small_01_51", direction = IsoDirections.S},
            {name = "location_community_church_small_01_52", direction = IsoDirections.S},
            {name = "location_community_church_small_01_53", direction = IsoDirections.S},
            {name = "location_community_church_small_01_56", direction = IsoDirections.N},
            {name = "location_community_church_small_01_57", direction = IsoDirections.N},
            {name = "location_community_church_small_01_58", direction = IsoDirections.N},
            {name = "location_community_church_small_01_59", direction = IsoDirections.W},
            {name = "location_community_church_small_01_60", direction = IsoDirections.W},
            {name = "location_community_church_small_01_61", direction = IsoDirections.W}
        }
    },
    {
        type = "Orange Futon", 
        spriteNames = {
            {name = "furniture_seating_indoor_01_46", direction = IsoDirections.W},
            {name = "furniture_seating_indoor_01_47", direction = IsoDirections.N}
        }
    },
    -- ****************************************************************
    -- Tables
    -- Need direction adjustment
    {
        type = "Picnic Table", 
        spriteNames = {
            {name = "camping_01_8", direction = IsoDirections.W},
            {name = "camping_01_9", direction = IsoDirections.W},
            {name = "camping_01_10", direction = IsoDirections.E},
            {name = "camping_01_11", direction = IsoDirections.E},
            {name = "camping_01_12", direction = IsoDirections.S},
            {name = "camping_01_13", direction = IsoDirections.S},
            {name = "camping_01_14", direction = IsoDirections.N},
            {name = "camping_01_15", direction = IsoDirections.N}
        }
    },
    {
        type = "Large Wooden Table", 
        spriteNames = {
            {name = "crafted_02_88", direction = IsoDirections.E},
            {name = "crafted_02_89", direction = IsoDirections.E},
            {name = "crafted_02_90", direction = IsoDirections.S},
            {name = "crafted_02_91", direction = IsoDirections.S}
        }
    },
    {
        type = "Long Branch Low Table", 
        spriteNames = {
            {name = "crafted_04_108", direction = IsoDirections.S},
            {name = "crafted_04_109", direction = IsoDirections.S},
            {name = "crafted_04_110", direction = IsoDirections.E},
            {name = "crafted_04_111", direction = IsoDirections.E}
        }
    },
    {
        type = "Quality Crafted Table", 
        spriteNames = {
            {name = "furniture_storage_01_52", direction = IsoDirections.S},
            {name = "furniture_storage_01_53", direction = IsoDirections.E},
            {name = "furniture_storage_01_54", direction = IsoDirections.W},
            {name = "furniture_storage_01_55", direction = IsoDirections.N}
        }
    },
    {
        type = "Long Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_4", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_5", direction = IsoDirections.E}
        }
    },
    -- Original direction non-existent
    {
        type = "Oak Round Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_6", direction = IsoDirections.S}
        }
    },
    -- Original direction non-existent
    {
        type = "Light Round Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_7", direction = IsoDirections.S}
        }
    },
    {
        type = "Large Brown Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_8", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_9", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_10", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_11", direction = IsoDirections.E}
        }
    },
    {
        type = "Long Light Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_12", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_13", direction = IsoDirections.S}
        }
    },
    -- Original direction non-existent
    {
        type = "Round Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_14", direction = IsoDirections.S}
        }
    },
    -- Original direction non-existent
    {
        type = "Fancy Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_15", direction = IsoDirections.S}
        }
    },
    -- Original direction non-existent
    {
        type = "Fancy Dark Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_16", direction = IsoDirections.S}
        }
    },
    {
        type = "Large Dark Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_17", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_18", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_19", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_20", direction = IsoDirections.S}
        }
    },
    {
        type = "Long Dark Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_21", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_22", direction = IsoDirections.E}
        }
    },
    -- Original direction non-existent
    {
        type = "Dark Round Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_23", direction = IsoDirections.S}
        }
    },
    -- Not on the wiki list
    {
        type = "Large Light Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_24", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_25", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_26", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_27", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_28", direction = IsoDirections.W},
            {name = "furniture_tables_high_01_29", direction = IsoDirections.W},
            {name = "furniture_tables_high_01_30", direction = IsoDirections.N},
            {name = "furniture_tables_high_01_31", direction = IsoDirections.N}
        }
    },
    {
        type = "Large Oak Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_32", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_33", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_34", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_35", direction = IsoDirections.S}
        }
    },
    {
        type = "Broad White Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_36", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_37", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_38", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_39", direction = IsoDirections.E}
        }
    },
    {
        type = "Large Dark Wooden Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_40", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_41", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_42", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_43", direction = IsoDirections.E}
        }
    },
    {
        type = "Plastic Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_44", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_45", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_46", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_47", direction = IsoDirections.E}
        }
    },
    {
        type = "Large Smooth Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_48", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_49", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_50", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_51", direction = IsoDirections.S}
        }
    },
    {
        type = "Large Simple Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_52", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_53", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_54", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_55", direction = IsoDirections.E}
        }
    },
    {
        type = "Large Plastic Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_56", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_57", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_58", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_59", direction = IsoDirections.E}
        }
    },
    {
        type = "Large Light Oak Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_60", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_61", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_62", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_63", direction = IsoDirections.E}
        }
    },
    {
        type = "Long Low Table", 
        spriteNames = {
            {name = "furniture_tables_low_01_0", direction = IsoDirections.E},
            {name = "furniture_tables_low_01_1", direction = IsoDirections.E},
            {name = "furniture_tables_low_01_14", direction = IsoDirections.S},
            {name = "furniture_tables_low_01_15", direction = IsoDirections.S}
        }
    },
    {
        type = "Fancy Low Table", 
        spriteNames = {
            {name = "furniture_tables_low_01_2", direction = IsoDirections.E},
            {name = "furniture_tables_low_01_3", direction = IsoDirections.S}
        }
    },
    {
        type = "Long Fancy Low Table", 
        spriteNames = {
            {name = "furniture_tables_low_01_4", direction = IsoDirections.S},
            {name = "furniture_tables_low_01_5", direction = IsoDirections.S},
            {name = "furniture_tables_low_01_6", direction = IsoDirections.E},
            {name = "furniture_tables_low_01_7", direction = IsoDirections.E}
        }
    },
    {
        type = "Fancy Low Glass Table", 
        spriteNames = {
            {name = "furniture_tables_low_01_8", direction = IsoDirections.S},
            {name = "furniture_tables_low_01_9", direction = IsoDirections.S},
            {name = "furniture_tables_low_01_10", direction = IsoDirections.E},
            {name = "furniture_tables_low_01_11", direction = IsoDirections.E}
        }
    },
    {
        type = "Brown Low Table", 
        spriteNames = {
            {name = "furniture_tables_low_01_12", direction = IsoDirections.E},
            {name = "furniture_tables_low_01_13", direction = IsoDirections.S}
        }
    },
    {
        type = "Light Low Table", 
        spriteNames = {
            {name = "furniture_tables_low_01_16", direction = IsoDirections.E},
            {name = "furniture_tables_low_01_17", direction = IsoDirections.S}
        }
    },
    {
        type = "Black Low Modern Table", 
        spriteNames = {
            {name = "furniture_tables_low_01_18", direction = IsoDirections.E},
            {name = "furniture_tables_low_01_19", direction = IsoDirections.S}
        }
    },
    {
        type = "Low Plastic Table", 
        spriteNames = {
            {name = "furniture_tables_low_01_20", direction = IsoDirections.S},
            {name = "furniture_tables_low_01_21", direction = IsoDirections.E}
        }
    },
    {
        type = "50s Diner Table", 
        spriteNames = {
            {name = "location_restaurant_diner_01_6", direction = IsoDirections.S},
            {name = "location_restaurant_diner_01_7", direction = IsoDirections.S},
            {name = "location_restaurant_diner_01_14", direction = IsoDirections.E},
            {name = "location_restaurant_diner_01_15", direction = IsoDirections.E}
        }
    },
    {
        type = "Brown Picnic Table", 
        spriteNames = {
            {name = "location_restaurant_generic_01_0", direction = IsoDirections.S},
            {name = "location_restaurant_generic_01_1", direction = IsoDirections.S},
            {name = "location_restaurant_generic_01_2", direction = IsoDirections.S},
            {name = "location_restaurant_generic_01_3", direction = IsoDirections.S},
            {name = "location_restaurant_generic_01_4", direction = IsoDirections.E},
            {name = "location_restaurant_generic_01_5", direction = IsoDirections.E},
            {name = "location_restaurant_generic_01_6", direction = IsoDirections.E},
            {name = "location_restaurant_generic_01_7", direction = IsoDirections.E}
        }
    },
    {
        type = "Blue Picnic Table", 
        spriteNames = {
            {name = "location_restaurant_generic_01_8", direction = IsoDirections.S},
            {name = "location_restaurant_generic_01_9", direction = IsoDirections.S},
            {name = "location_restaurant_generic_01_10", direction = IsoDirections.S},
            {name = "location_restaurant_generic_01_11", direction = IsoDirections.S},
            {name = "location_restaurant_generic_01_12", direction = IsoDirections.E},
            {name = "location_restaurant_generic_01_13", direction = IsoDirections.E},
            {name = "location_restaurant_generic_01_14", direction = IsoDirections.E},
            {name = "location_restaurant_generic_01_15", direction = IsoDirections.E}
        }
    },
    {
        type = "Large Bleached Table", 
        spriteNames = {
            {name = "location_restaurant_pileocrepe_01_32", direction = IsoDirections.S},
            {name = "location_restaurant_pileocrepe_01_33", direction = IsoDirections.S},
            {name = "location_restaurant_pileocrepe_01_34", direction = IsoDirections.E},
            {name = "location_restaurant_pileocrepe_01_35", direction = IsoDirections.E}
        }
    },
    {
        type = "Light Wood Restaurant Table", 
        spriteNames = {
            {name = "location_restaurant_pileocrepe_01_36", direction = IsoDirections.S},
            {name = "location_restaurant_pileocrepe_01_37", direction = IsoDirections.E}
        }
    },
    {
        type = "Pizza Whirled Table", 
        spriteNames = {
            {name = "location_restaurant_pizzawhirled_01_48", direction = IsoDirections.E},
            {name = "location_restaurant_pizzawhirled_01_49", direction = IsoDirections.E},
            {name = "location_restaurant_pizzawhirled_01_50", direction = IsoDirections.S},
            {name = "location_restaurant_pizzawhirled_01_51", direction = IsoDirections.S}
        }
    },
    {
        type = "Spiffo Type B Table", 
        spriteNames = {
            {name = "location_restaurant_spiffos_02_32", direction = IsoDirections.E},
            {name = "location_restaurant_spiffos_02_33", direction = IsoDirections.E},
            {name = "location_restaurant_spiffos_02_34", direction = IsoDirections.S},
            {name = "location_restaurant_spiffos_02_35", direction = IsoDirections.S}
        }
    },
    {
        type = "Spiffo Type A Table", 
        spriteNames = {
            {name = "location_restaurant_spiffos_02_36", direction = IsoDirections.S},
            {name = "location_restaurant_spiffos_02_37", direction = IsoDirections.S},
            {name = "location_restaurant_spiffos_02_38", direction = IsoDirections.E},
            {name = "location_restaurant_spiffos_02_39", direction = IsoDirections.E}
        }
    },
    {
        type = "Lightwood Trailer Table", 
        spriteNames = {
            {name = "location_trailer_02_12", direction = IsoDirections.E},
            {name = "location_trailer_02_13", direction = IsoDirections.E},
            {name = "location_trailer_02_14", direction = IsoDirections.S},
            {name = "location_trailer_02_15", direction = IsoDirections.S}
        }
    },
    {
        type = "Pool Table", 
        spriteNames = {
            {name = "recreational_01_2", direction = IsoDirections.S},
            {name = "recreational_01_3", direction = IsoDirections.S},
            {name = "recreational_01_6", direction = IsoDirections.E},
            {name = "recreational_01_7", direction = IsoDirections.E}
        }
    },
    -- Not on the wiki list
    {
        type = "Large Dark Oak Table", 
        spriteNames = {
            {name = "furniture_tables_high_01_0", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_1", direction = IsoDirections.S},
            {name = "furniture_tables_high_01_2", direction = IsoDirections.E},
            {name = "furniture_tables_high_01_3", direction = IsoDirections.E}
        }
    },
    {
        type = "Mall Table", 
        spriteNames = {
            {name = "location_shop_mall_01_48", direction = IsoDirections.S},
            {name = "location_shop_mall_01_49", direction = IsoDirections.S},
            {name = "location_shop_mall_01_50", direction = IsoDirections.E},
            {name = "location_shop_mall_01_51", direction = IsoDirections.E}
        }
    },
    -- ****************************************************************
    -- Storage / Counters
    {
        type = "Bar Corner", 
        spriteNames = {
            {name = "carpentry_02_16", direction = IsoDirections.N},
            {name = "carpentry_02_18", direction = IsoDirections.E},
            {name = "carpentry_02_20", direction = IsoDirections.S},
            {name = "carpentry_02_22", direction = IsoDirections.W},
            {name = "carpentry_02_24", direction = IsoDirections.N},
            {name = "carpentry_02_26", direction = IsoDirections.E},
            {name = "carpentry_02_28", direction = IsoDirections.S},
            {name = "carpentry_02_30", direction = IsoDirections.W},
            {name = "carpentry_02_32", direction = IsoDirections.N},
            {name = "carpentry_02_34", direction = IsoDirections.E},
            {name = "carpentry_02_36", direction = IsoDirections.S},
            {name = "carpentry_02_38", direction = IsoDirections.W}
        }
    },
    {
        type = "Bar Element", 
        spriteNames = {
            {name = "carpentry_02_19", direction = IsoDirections.E},
            {name = "carpentry_02_27", direction = IsoDirections.E},
            {name = "carpentry_02_35", direction = IsoDirections.E}
        }
    },
    {
        type = "Crude Metal Corner Counter", 
        spriteNames = {
            {name = "crafted_05_24", direction = IsoDirections.N},
            {name = "crafted_05_26", direction = IsoDirections.E},
            {name = "crafted_05_28", direction = IsoDirections.S},
            {name = "crafted_05_30", direction = IsoDirections.W}
        }
    },
    {
        type = "Crude Metal Counter", 
        spriteNames = {
            {name = "crafted_05_25", direction = IsoDirections.N},
            {name = "crafted_05_27", direction = IsoDirections.E},
            {name = "crafted_05_29", direction = IsoDirections.S},
            {name = "crafted_05_31", direction = IsoDirections.W}
        }
    },
    {
        type = "Modern Corner Counter", 
        spriteNames = {
            {name = "fixtures_counters_01_0", direction = IsoDirections.N},
            {name = "fixtures_counters_01_2", direction = IsoDirections.E},
            {name = "fixtures_counters_01_4", direction = IsoDirections.S},
            {name = "fixtures_counters_01_6", direction = IsoDirections.W}
        }
    },
    {
        type = "Modern Counter", 
        spriteNames = {
            {name = "fixtures_counters_01_1", direction = IsoDirections.N},
            {name = "fixtures_counters_01_3", direction = IsoDirections.E},
            {name = "fixtures_counters_01_5", direction = IsoDirections.S},
            {name = "fixtures_counters_01_7", direction = IsoDirections.W}
        }
    },
    {
        type = "Wooden Corner Counter", 
        spriteNames = {
            {name = "fixtures_counters_01_8", direction = IsoDirections.N},
            {name = "fixtures_counters_01_10", direction = IsoDirections.E},
            {name = "fixtures_counters_01_12", direction = IsoDirections.S},
            {name = "fixtures_counters_01_14", direction = IsoDirections.W}
        }
    },
    {
        type = "Wooden Counter", 
        spriteNames = {
            {name = "fixtures_counters_01_9", direction = IsoDirections.N},
            {name = "fixtures_counters_01_11", direction = IsoDirections.E},
            {name = "fixtures_counters_01_13", direction = IsoDirections.S},
            {name = "fixtures_counters_01_15", direction = IsoDirections.W}
        }
    },
    {
        type = "Metal Counter Corner", 
        spriteNames = {
            {name = "fixtures_counters_01_32", direction = IsoDirections.N},
            {name = "fixtures_counters_01_34", direction = IsoDirections.E},
            {name = "fixtures_counters_01_36", direction = IsoDirections.S},
            {name = "fixtures_counters_01_38", direction = IsoDirections.W}
        }
    },
    {
        type = "Metal Counter", 
        spriteNames = {
            {name = "fixtures_counters_01_33", direction = IsoDirections.N},
            {name = "fixtures_counters_01_35", direction = IsoDirections.E},
            {name = "fixtures_counters_01_37", direction = IsoDirections.S},
            {name = "fixtures_counters_01_39", direction = IsoDirections.W}
        }
    },
    {
        type = "Birchwood Corner Counter", 
        spriteNames = {
            {name = "fixtures_counters_01_40", direction = IsoDirections.N},
            {name = "fixtures_counters_01_42", direction = IsoDirections.E},
            {name = "fixtures_counters_01_44", direction = IsoDirections.S},
            {name = "fixtures_counters_01_46", direction = IsoDirections.W}
        }
    },
    {
        type = "Birchwood Counter", 
        spriteNames = {
            {name = "fixtures_counters_01_41", direction = IsoDirections.N},
            {name = "fixtures_counters_01_43", direction = IsoDirections.E},
            {name = "fixtures_counters_01_45", direction = IsoDirections.S},
            {name = "fixtures_counters_01_47", direction = IsoDirections.W}
        }
    },
    {
        type = "Oak Corner Counter", 
        spriteNames = {
            {name = "fixtures_counters_01_48", direction = IsoDirections.N},
            {name = "fixtures_counters_01_50", direction = IsoDirections.E},
            {name = "fixtures_counters_01_52", direction = IsoDirections.S},
            {name = "fixtures_counters_01_54", direction = IsoDirections.W}
        }
    },
    {
        type = "Oak Counter", 
        spriteNames = {
            {name = "fixtures_counters_01_49", direction = IsoDirections.N},
            {name = "fixtures_counters_01_51", direction = IsoDirections.E},
            {name = "fixtures_counters_01_53", direction = IsoDirections.S},
            {name = "fixtures_counters_01_55", direction = IsoDirections.W}
        }
    },
    {
        type = "Dark Corner Counter", 
        spriteNames = {
            {name = "fixtures_counters_01_56", direction = IsoDirections.N},
            {name = "fixtures_counters_01_58", direction = IsoDirections.E},
            {name = "fixtures_counters_01_60", direction = IsoDirections.S},
            {name = "fixtures_counters_01_62", direction = IsoDirections.W}
        }
    },
    {
        type = "Dark Counter", 
        spriteNames = {
            {name = "fixtures_counters_01_57", direction = IsoDirections.N},
            {name = "fixtures_counters_01_59", direction = IsoDirections.E},
            {name = "fixtures_counters_01_61", direction = IsoDirections.S},
            {name = "fixtures_counters_01_63", direction = IsoDirections.W}
        }
    },
    {
        type = "Green Corner Counter", 
        spriteNames = {
            {name = "fixtures_counters_01_64", direction = IsoDirections.N},
            {name = "fixtures_counters_01_66", direction = IsoDirections.E},
            {name = "fixtures_counters_01_68", direction = IsoDirections.S},
            {name = "fixtures_counters_01_70", direction = IsoDirections.W}
        }
    },
    {
        type = "Green Counter", 
        spriteNames = {
            {name = "fixtures_counters_01_65", direction = IsoDirections.N},
            {name = "fixtures_counters_01_67", direction = IsoDirections.E},
            {name = "fixtures_counters_01_69", direction = IsoDirections.S},
            {name = "fixtures_counters_01_71", direction = IsoDirections.W}
        }
    },
    {
        type = "White Corner Counter", 
        spriteNames = {
            {name = "fixtures_counters_01_72", direction = IsoDirections.N},
            {name = "fixtures_counters_01_74", direction = IsoDirections.E},
            {name = "fixtures_counters_01_76", direction = IsoDirections.S},
            {name = "fixtures_counters_01_78", direction = IsoDirections.W}
        }
    },
    {
        type = "White Counter", 
        spriteNames = {
            {name = "fixtures_counters_01_73", direction = IsoDirections.N},
            {name = "fixtures_counters_01_75", direction = IsoDirections.E},
            {name = "fixtures_counters_01_77", direction = IsoDirections.S},
            {name = "fixtures_counters_01_79", direction = IsoDirections.W}
        }
    },
    {
        type = "Glass Theater Counter", 
        spriteNames = {
            {name = "location_entertainment_theatre_01_4", direction = IsoDirections.N},
            {name = "location_entertainment_theatre_01_5", direction = IsoDirections.E},
            {name = "location_entertainment_theatre_01_6", direction = IsoDirections.S},
            {name = "location_entertainment_theatre_01_7", direction = IsoDirections.W}
        }
    },
    {
        type = "Theater Corner Counter", 
        spriteNames = {
            {name = "location_entertainment_theatre_01_8", direction = IsoDirections.N},
            {name = "location_entertainment_theatre_01_10", direction = IsoDirections.E},
            {name = "location_entertainment_theatre_01_12", direction = IsoDirections.S},
            {name = "location_entertainment_theatre_01_14", direction = IsoDirections.W}
        }
    },
    {
        type = "Theater Counter", 
        spriteNames = {
            {name = "location_entertainment_theatre_01_9", direction = IsoDirections.N},
            {name = "location_entertainment_theatre_01_11", direction = IsoDirections.E},
            {name = "location_entertainment_theatre_01_13", direction = IsoDirections.S},
            {name = "location_entertainment_theatre_01_15", direction = IsoDirections.W}
        }
    },
    -- Original direction non-existent
    {
        type = "Square Theater Counter", 
        spriteNames = {
            {name = "location_entertainment_theatre_01_16", direction = IsoDirections.S}
        }
    },
    {
        type = "Motel Counter", 
        spriteNames = {
            {name = "location_hospitality_sunstarmotel_02_12", direction = IsoDirections.N},
            {name = "location_hospitality_sunstarmotel_02_13", direction = IsoDirections.E},
            {name = "location_hospitality_sunstarmotel_02_14", direction = IsoDirections.S},
            {name = "location_hospitality_sunstarmotel_02_15", direction = IsoDirections.W}
        }
    },
    {
        type = "Bar Corner Counter", 
        spriteNames = {
            {name = "location_restaurant_bar_01_0", direction = IsoDirections.N},
            {name = "location_restaurant_bar_01_2", direction = IsoDirections.W},
            {name = "location_restaurant_bar_01_4", direction = IsoDirections.S},
            {name = "location_restaurant_bar_01_6", direction = IsoDirections.E}
        }
    },
    {
        type = "Bar Counter", 
        spriteNames = {
            {name = "location_restaurant_bar_01_1", direction = IsoDirections.N},
            {name = "location_restaurant_bar_01_3", direction = IsoDirections.W},
            {name = "location_restaurant_bar_01_5", direction = IsoDirections.S},
            {name = "location_restaurant_bar_01_7", direction = IsoDirections.E}
        }
    },
    {
        type = "Oak Corner Bar Counter", 
        spriteNames = {
            {name = "location_restaurant_bar_01_56", direction = IsoDirections.N},
            {name = "location_restaurant_bar_01_58", direction = IsoDirections.W},
            {name = "location_restaurant_bar_01_60", direction = IsoDirections.S},
            {name = "location_restaurant_bar_01_62", direction = IsoDirections.E}
        }
    },
    {
        type = "Oak Bar Counter", 
        spriteNames = {
            {name = "location_restaurant_bar_01_57", direction = IsoDirections.N},
            {name = "location_restaurant_bar_01_59", direction = IsoDirections.W},
            {name = "location_restaurant_bar_01_61", direction = IsoDirections.S},
            {name = "location_restaurant_bar_01_63", direction = IsoDirections.E}
        }
    },
    {
        type = "White Striped Corner Counter", 
        spriteNames = {
            {name = "location_restaurant_pie_01_40", direction = IsoDirections.N},
            {name = "location_restaurant_pie_01_42", direction = IsoDirections.E},
            {name = "location_restaurant_pie_01_44", direction = IsoDirections.S},
            {name = "location_restaurant_pie_01_46", direction = IsoDirections.W}
        }
    },
    {
        type = "White Striped Counter", 
        spriteNames = {
            {name = "location_restaurant_pie_01_41", direction = IsoDirections.N},
            {name = "location_restaurant_pie_01_43", direction = IsoDirections.E},
            {name = "location_restaurant_pie_01_45", direction = IsoDirections.S},
            {name = "location_restaurant_pie_01_47", direction = IsoDirections.W}
        }
    },
    {
        type = "Seahorse Coffee Corner Counter", 
        spriteNames = {
            {name = "location_restaurant_seahorse_01_40", direction = IsoDirections.N},
            {name = "location_restaurant_seahorse_01_42", direction = IsoDirections.E},
            {name = "location_restaurant_seahorse_01_44", direction = IsoDirections.S},
            {name = "location_restaurant_seahorse_01_46", direction = IsoDirections.W}
        }
    },
    {
        type = "Seahorse Coffee Counter", 
        spriteNames = {
            {name = "location_restaurant_seahorse_01_41", direction = IsoDirections.N},
            {name = "location_restaurant_seahorse_01_43", direction = IsoDirections.E},
            {name = "location_restaurant_seahorse_01_45", direction = IsoDirections.S},
            {name = "location_restaurant_seahorse_01_47", direction = IsoDirections.W}
        }
    },
    {
        type = "Spiffo Corner Counter", 
        spriteNames = {
            {name = "location_restaurant_spiffos_01_56", direction = IsoDirections.E},
            {name = "location_restaurant_spiffos_01_58", direction = IsoDirections.N},
            {name = "location_restaurant_spiffos_01_60", direction = IsoDirections.S},
            {name = "location_restaurant_spiffos_01_62", direction = IsoDirections.W}
        }
    },
    {
        type = "Spiffo Counter", 
        spriteNames = {
            {name = "location_restaurant_spiffos_01_57", direction = IsoDirections.N},
            {name = "location_restaurant_spiffos_01_59", direction = IsoDirections.E},
            {name = "location_restaurant_spiffos_01_61", direction = IsoDirections.S},
            {name = "location_restaurant_spiffos_01_63", direction = IsoDirections.W}
        }
    },
    {
        type = "Fossoil Corner Counter", 
        spriteNames = {
            {name = "location_shop_fossoil_01_16", direction = IsoDirections.N},
            {name = "location_shop_fossoil_01_18", direction = IsoDirections.E},
            {name = "location_shop_fossoil_01_20", direction = IsoDirections.S},
            {name = "location_shop_fossoil_01_22", direction = IsoDirections.W}
        }
    },
    {
        type = "Fossoil Counter", 
        spriteNames = {
            {name = "location_shop_fossoil_01_17", direction = IsoDirections.N},
            {name = "location_shop_fossoil_01_19", direction = IsoDirections.E},
            {name = "location_shop_fossoil_01_21", direction = IsoDirections.S},
            {name = "location_shop_fossoil_01_23", direction = IsoDirections.W}
        }
    },
    {
        type = "Fossoil Low Shelves", 
        spriteNames = {
            {name = "location_shop_fossoil_01_70", direction = IsoDirections.S},
            {name = "location_shop_fossoil_01_71", direction = IsoDirections.E}
        }
    },
    {
        type = "Red Corner Counter", 
        spriteNames = {
            {name = "location_shop_gas2go_01_16", direction = IsoDirections.N},
            {name = "location_shop_gas2go_01_18", direction = IsoDirections.E},
            {name = "location_shop_gas2go_01_20", direction = IsoDirections.S},
            {name = "location_shop_gas2go_01_22", direction = IsoDirections.W}
        }
    },
    {
        type = "Red Counter", 
        spriteNames = {
            {name = "location_shop_gas2go_01_17", direction = IsoDirections.N},
            {name = "location_shop_gas2go_01_19", direction = IsoDirections.E},
            {name = "location_shop_gas2go_01_21", direction = IsoDirections.S},
            {name = "location_shop_gas2go_01_23", direction = IsoDirections.W}
        }
    },
    {
        type = "Gas2Go Low Shelves", 
        spriteNames = {
            {name = "location_shop_gas2go_01_30", direction = IsoDirections.S},
            {name = "location_shop_gas2go_01_31", direction = IsoDirections.E}
        }
    },
    {
        type = "Zippee Corner Counter", 
        spriteNames = {
            {name = "location_shop_zippee_01_16", direction = IsoDirections.N},
            {name = "location_shop_zippee_01_18", direction = IsoDirections.E},
            {name = "location_shop_zippee_01_20", direction = IsoDirections.S},
            {name = "location_shop_zippee_01_22", direction = IsoDirections.W}
        }
    },
    {
        type = "Zippee Counter", 
        spriteNames = {
            {name = "location_shop_zippee_01_17", direction = IsoDirections.N},
            {name = "location_shop_zippee_01_19", direction = IsoDirections.E},
            {name = "location_shop_zippee_01_21", direction = IsoDirections.S},
            {name = "location_shop_zippee_01_23", direction = IsoDirections.W}
        }
    },
    {
        type = "Zippee Display Counter", 
        spriteNames = {
            {name = "location_shop_zippee_01_58", direction = IsoDirections.W},
            {name = "location_shop_zippee_01_59", direction = IsoDirections.N}
        }
    },
    {
        type = "Trailer Counter", 
        spriteNames = {
            {name = "location_trailer_02_18", direction = IsoDirections.S},
            {name = "location_trailer_02_19", direction = IsoDirections.E},
            {name = "location_trailer_02_20", direction = IsoDirections.N},
            {name = "location_trailer_02_21", direction = IsoDirections.W}
        }
    },
    {
        type = "Oak Employee Bank Counter", 
        spriteNames = {
            {name = "location_business_bank_01_24", direction = IsoDirections.E},
            {name = "location_business_bank_01_25", direction = IsoDirections.E},
            {name = "location_business_bank_01_26", direction = IsoDirections.S},
            {name = "location_business_bank_01_27", direction = IsoDirections.S},
            {name = "location_business_bank_01_28", direction = IsoDirections.W},
            {name = "location_business_bank_01_29", direction = IsoDirections.W},
            {name = "location_business_bank_01_30", direction = IsoDirections.N},
            {name = "location_business_bank_01_31", direction = IsoDirections.N}
        }
    },
    {
        type = "Employee Bank Counter", 
        spriteNames = {
            {name = "location_business_bank_01_32", direction = IsoDirections.E},
            {name = "location_business_bank_01_33", direction = IsoDirections.E},
            {name = "location_business_bank_01_34", direction = IsoDirections.S},
            {name = "location_business_bank_01_35", direction = IsoDirections.S},
            {name = "location_business_bank_01_36", direction = IsoDirections.W},
            {name = "location_business_bank_01_37", direction = IsoDirections.W},
            {name = "location_business_bank_01_38", direction = IsoDirections.N},
            {name = "location_business_bank_01_39", direction = IsoDirections.N}
        }
    },
    {
        type = "Oak Bank Counter", 
        spriteNames = {
            {name = "location_business_bank_01_48", direction = IsoDirections.E},
            {name = "location_business_bank_01_49", direction = IsoDirections.E},
            {name = "location_business_bank_01_50", direction = IsoDirections.S},
            {name = "location_business_bank_01_51", direction = IsoDirections.S},
            {name = "location_business_bank_01_52", direction = IsoDirections.W},
            {name = "location_business_bank_01_53", direction = IsoDirections.W},
            {name = "location_business_bank_01_54", direction = IsoDirections.N},
            {name = "location_business_bank_01_55", direction = IsoDirections.N}
        }
    },
    {
        type = "Bank Counter", 
        spriteNames = {
            {name = "location_business_bank_01_56", direction = IsoDirections.E},
            {name = "location_business_bank_01_57", direction = IsoDirections.E},
            {name = "location_business_bank_01_58", direction = IsoDirections.S},
            {name = "location_business_bank_01_59", direction = IsoDirections.S},
            {name = "location_business_bank_01_60", direction = IsoDirections.W},
            {name = "location_business_bank_01_61", direction = IsoDirections.W},
            {name = "location_business_bank_01_62", direction = IsoDirections.N},
            {name = "location_business_bank_01_63", direction = IsoDirections.N}
        }
    },
    {
        type = "Low Motel Counter", 
        spriteNames = {
            {name = "location_hospitality_sunstarmotel_02_20", direction = IsoDirections.N},
            {name = "location_hospitality_sunstarmotel_02_21", direction = IsoDirections.E},
            {name = "location_hospitality_sunstarmotel_02_22", direction = IsoDirections.S},
            {name = "location_hospitality_sunstarmotel_02_23", direction = IsoDirections.W}
        }
    },
    {
        type = "Diner Corner Counter", 
        spriteNames = {
            {name = "location_restaurant_diner_01_24", direction = IsoDirections.N},
            {name = "location_restaurant_diner_01_26", direction = IsoDirections.E},
            {name = "location_restaurant_diner_01_28", direction = IsoDirections.S},
            {name = "location_restaurant_diner_01_30", direction = IsoDirections.W}
        }
    },
    {
        type = "Diner Counter", 
        spriteNames = {
            {name = "location_restaurant_diner_01_25", direction = IsoDirections.N},
            {name = "location_restaurant_diner_01_27", direction = IsoDirections.E},
            {name = "location_restaurant_diner_01_29", direction = IsoDirections.S},
            {name = "location_restaurant_diner_01_31", direction = IsoDirections.W}
        }
    },
    {
        type = "Corner A Glass", 
        spriteNames = {
            {name = "location_restaurant_generic_01_24", direction = IsoDirections.S},
            {name = "location_restaurant_generic_01_27", direction = IsoDirections.E},
            {name = "location_restaurant_generic_01_34", direction = IsoDirections.N},
            {name = "location_restaurant_generic_01_37", direction = IsoDirections.W}
        }
    },
    {
        type = "Middle Glass", 
        spriteNames = {
            {name = "location_restaurant_generic_01_25", direction = IsoDirections.S},
            {name = "location_restaurant_generic_01_28", direction = IsoDirections.E},
            {name = "location_restaurant_generic_01_33", direction = IsoDirections.N},
            {name = "location_restaurant_generic_01_36", direction = IsoDirections.W}
        }
    },
    {
        type = "Corner B Glass", 
        spriteNames = {
            {name = "location_restaurant_generic_01_26", direction = IsoDirections.S},
            {name = "location_restaurant_generic_01_29", direction = IsoDirections.E},
            {name = "location_restaurant_generic_01_32", direction = IsoDirections.N},
            {name = "location_restaurant_generic_01_35", direction = IsoDirections.W}
        }
    },
    {
        type = "Pizza Whirled Corner Counter", 
        spriteNames = {
            {name = "location_restaurant_pizzawhirled_01_32", direction = IsoDirections.N},
            {name = "location_restaurant_pizzawhirled_01_34", direction = IsoDirections.E},
            {name = "location_restaurant_pizzawhirled_01_36", direction = IsoDirections.S},
            {name = "location_restaurant_pizzawhirled_01_38", direction = IsoDirections.W}
        }
    },
    {
        type = "Pizza Whirled Counter", 
        spriteNames = {
            {name = "location_restaurant_pizzawhirled_01_33", direction = IsoDirections.N},
            {name = "location_restaurant_pizzawhirled_01_35", direction = IsoDirections.E},
            {name = "location_restaurant_pizzawhirled_01_37", direction = IsoDirections.S},
            {name = "location_restaurant_pizzawhirled_01_39", direction = IsoDirections.W}
        }
    },
    {
        type = "Generic Shop Corner Counter", 
        spriteNames = {
            {name = "location_shop_generic_01_16", direction = IsoDirections.N},
            {name = "location_shop_generic_01_18", direction = IsoDirections.E},
            {name = "location_shop_generic_01_20", direction = IsoDirections.S},
            {name = "location_shop_generic_01_22", direction = IsoDirections.W}
        }
    },
    {
        type = "Generic Shop Counter", 
        spriteNames = {
            {name = "location_shop_generic_01_17", direction = IsoDirections.N},
            {name = "location_shop_generic_01_19", direction = IsoDirections.E},
            {name = "location_shop_generic_01_21", direction = IsoDirections.S},
            {name = "location_shop_generic_01_23", direction = IsoDirections.W}
        }
    },
    {
        type = "Rounded Glass Display Counter", 
        spriteNames = {
            {name = "location_shop_generic_01_32", direction = IsoDirections.E},
            {name = "location_shop_generic_01_33", direction = IsoDirections.E},
            {name = "location_shop_generic_01_34", direction = IsoDirections.S},
            {name = "location_shop_generic_01_35", direction = IsoDirections.S}
        }
    },
    {
        type = "White Display Counter", 
        spriteNames = {
            {name = "location_shop_generic_01_80", direction = IsoDirections.S},
            {name = "location_shop_generic_01_81", direction = IsoDirections.S},
            {name = "location_shop_generic_01_82", direction = IsoDirections.S},
            {name = "location_shop_generic_01_83", direction = IsoDirections.E},
            {name = "location_shop_generic_01_84", direction = IsoDirections.E},
            {name = "location_shop_generic_01_85", direction = IsoDirections.E}
        }
    },
    {
        type = "Shop Display Counter", 
        spriteNames = {
            {name = "location_shop_generic_01_88", direction = IsoDirections.S},
            {name = "location_shop_generic_01_89", direction = IsoDirections.E},
            {name = "location_shop_generic_01_90", direction = IsoDirections.W},
            {name = "location_shop_generic_01_91", direction = IsoDirections.N}
        }
    },
    {
        type = "Glass Corner Display Counter", 
        spriteNames = {
            {name = "location_shop_generic_01_96", direction = IsoDirections.S},
            {name = "location_shop_generic_01_98", direction = IsoDirections.W},
            {name = "location_shop_generic_01_100", direction = IsoDirections.N},
            {name = "location_shop_generic_01_102", direction = IsoDirections.E}
        }
    },
    {
        type = "Glass Display Counter", 
        spriteNames = {
            {name = "location_shop_generic_01_97", direction = IsoDirections.S},
            {name = "location_shop_generic_01_99", direction = IsoDirections.W},
            {name = "location_shop_generic_01_101", direction = IsoDirections.N},
            {name = "location_shop_generic_01_103", direction = IsoDirections.E}
        }
    },
    {
        type = "Greene Grocery Display Counter", 
        spriteNames = {
            {name = "location_shop_greenes_01_24", direction = IsoDirections.S},
            {name = "location_shop_greenes_01_25", direction = IsoDirections.E},
            {name = "location_shop_greenes_01_26", direction = IsoDirections.W},
            {name = "location_shop_greenes_01_27", direction = IsoDirections.N}
        }
    },
    {
        type = "Grocery Trapezoid Counter", 
        spriteNames = {
            {name = "location_shop_greenes_01_28", direction = IsoDirections.S},
            {name = "location_shop_greenes_01_29", direction = IsoDirections.E},
            {name = "location_shop_greenes_01_30", direction = IsoDirections.W},
            {name = "location_shop_greenes_01_31", direction = IsoDirections.N}
        }
    },

    -- Storage / Shelves
    -- Low style
    {
        type = "Branch Shelves", 
        spriteNames = {
            {name = "crafted_04_88", direction = IsoDirections.S},
            {name = "crafted_04_89", direction = IsoDirections.N},
            {name = "crafted_04_90", direction = IsoDirections.E},
            {name = "crafted_04_91", direction = IsoDirections.W}
        }
    },
    {
        type = "Low Shelves", 
        spriteNames = {
            {name = "crafted_05_50", direction = IsoDirections.S},
            {name = "crafted_05_51", direction = IsoDirections.W}
        }
    },
    {
        type = "Large Low Shelves", 
        spriteNames = {
            {name = "furniture_shelving_01_19", direction = IsoDirections.S},
            {name = "furniture_shelving_01_23", direction = IsoDirections.E},
            {name = "furniture_shelving_01_51", direction = IsoDirections.N},
            {name = "furniture_shelving_01_55", direction = IsoDirections.W}
        }
    },
    {
        type = "Corner A Shelves", 
        spriteNames = {
            {name = "furniture_shelving_01_16", direction = IsoDirections.S},
            {name = "furniture_shelving_01_20", direction = IsoDirections.E},
            {name = "furniture_shelving_01_50", direction = IsoDirections.N},
            {name = "furniture_shelving_01_54", direction = IsoDirections.W}
        }
    },
    {
        type = "Middle Shelves", 
        spriteNames = {
            {name = "furniture_shelving_01_17", direction = IsoDirections.S},
            {name = "furniture_shelving_01_21", direction = IsoDirections.E},
            {name = "furniture_shelving_01_49", direction = IsoDirections.N},
            {name = "furniture_shelving_01_53", direction = IsoDirections.W}
        }
    },
    {
        type = "Corner B Shelves", 
        spriteNames = {
            {name = "furniture_shelving_01_18", direction = IsoDirections.S},
            {name = "furniture_shelving_01_22", direction = IsoDirections.E},
            {name = "furniture_shelving_01_48", direction = IsoDirections.N},
            {name = "furniture_shelving_01_52", direction = IsoDirections.W}
        }
    },
    {
        type = "Comics Shop Shelves", 
        spriteNames = {
            {name = "location_shop_generic_01_0", direction = IsoDirections.E},
            {name = "location_shop_generic_01_1", direction = IsoDirections.S}
        }
    },
    {
        type = "Trapezoid Shop Shelves", 
        spriteNames = {
            {name = "location_shop_generic_01_92", direction = IsoDirections.S},
            {name = "location_shop_generic_01_93", direction = IsoDirections.E},
            {name = "location_shop_generic_01_94", direction = IsoDirections.W},
            {name = "location_shop_generic_01_95", direction = IsoDirections.N}
        }
    },
    {
        type = "Generic Shop Shelves", 
        spriteNames = {
            {name = "location_shop_generic_01_108", direction = IsoDirections.E},
            {name = "location_shop_generic_01_109", direction = IsoDirections.S}
        }
    },
    {
        type = "Small Drying Rack", 
        spriteNames = {
            {name = "crafted_05_74", direction = IsoDirections.S},
            {name = "crafted_05_75", direction = IsoDirections.E}
        }
    },
    {
        type = "Large Drying Rack", 
        spriteNames = {
            {name = "crafted_05_80", direction = IsoDirections.S},
            {name = "crafted_05_81", direction = IsoDirections.S},
            {name = "crafted_05_82", direction = IsoDirections.S},
            {name = "crafted_05_83", direction = IsoDirections.S},
            {name = "crafted_05_84", direction = IsoDirections.E},
            {name = "crafted_05_85", direction = IsoDirections.E},
            {name = "crafted_05_86", direction = IsoDirections.E},
            {name = "crafted_05_87", direction = IsoDirections.E}
        }
    },
    {
        type = "Medium Drying Rack", 
        spriteNames = {
            {name = "crafted_05_108", direction = IsoDirections.S},
            {name = "crafted_05_109", direction = IsoDirections.S},
            {name = "crafted_05_110", direction = IsoDirections.E},
            {name = "crafted_05_111", direction = IsoDirections.E}
        }
    },
    -- Original direction non-existent
    {
        type = "Bowling Rack", 
        spriteNames = {
            {name = "recreational_sports_01_61", direction = IsoDirections.E},
            {name = "recreational_sports_01_62", direction = IsoDirections.E}
        }
    },
    -- High style
    {
        type = "Big Wall Corner Shelves", 
        spriteNames = {
            {name = "furniture_shelving_01_8", direction = IsoDirections.S}
        }
    },
    {
        type = "Big Wall Shelves", 
        spriteNames = {
            {name = "furniture_shelving_01_9", direction = IsoDirections.S},
            {name = "furniture_shelving_01_10", direction = IsoDirections.E}
        }
    },
    {
        type = "Large Metal Shelves", 
        spriteNames = {
            {name = "furniture_shelving_01_24", direction = IsoDirections.E},
            {name = "furniture_shelving_01_25", direction = IsoDirections.E},
            {name = "furniture_shelving_01_26", direction = IsoDirections.S},
            {name = "furniture_shelving_01_27", direction = IsoDirections.S}
        }
    },
    {
        type = "Oakwood Shelves", 
        spriteNames = {
            {name = "furniture_shelving_01_40", direction = IsoDirections.S},
            {name = "furniture_shelving_01_41", direction = IsoDirections.E},
            {name = "furniture_shelving_01_42", direction = IsoDirections.W},
            {name = "furniture_shelving_01_43", direction = IsoDirections.N}
        }
    },
    {
        type = "White Fancy Shelves", 
        spriteNames = {
            {name = "furniture_shelving_01_44", direction = IsoDirections.S},
            {name = "furniture_shelving_01_45", direction = IsoDirections.E},
            {name = "furniture_shelving_01_46", direction = IsoDirections.W},
            {name = "furniture_shelving_01_47", direction = IsoDirections.N}
        }
    },
    {
        type = "Metal Locker", 
        spriteNames = {
            {name = "furniture_storage_02_0", direction = IsoDirections.S},
            {name = "furniture_storage_02_1", direction = IsoDirections.E},
            {name = "furniture_storage_02_2", direction = IsoDirections.N},
            {name = "furniture_storage_02_3", direction = IsoDirections.W}
        }
    },
    {
        type = "Large Rental Shelves", 
        spriteNames = {
            {name = "location_entertainment_theatre_01_120", direction = IsoDirections.S},
            {name = "location_entertainment_theatre_01_121", direction = IsoDirections.S},
            {name = "location_entertainment_theatre_01_122", direction = IsoDirections.E},
            {name = "location_entertainment_theatre_01_123", direction = IsoDirections.E},
            {name = "location_entertainment_theatre_01_124", direction = IsoDirections.N},
            {name = "location_entertainment_theatre_01_125", direction = IsoDirections.N},
            {name = "location_entertainment_theatre_01_126", direction = IsoDirections.W},
            {name = "location_entertainment_theatre_01_127", direction = IsoDirections.W}
        }
    },
    {
        type = "Small Rental Shelves", 
        spriteNames = {
            {name = "location_entertainment_theatre_01_128", direction = IsoDirections.S},
            {name = "location_entertainment_theatre_01_129", direction = IsoDirections.S},
            {name = "location_entertainment_theatre_01_130", direction = IsoDirections.E},
            {name = "location_entertainment_theatre_01_131", direction = IsoDirections.E},
            {name = "location_entertainment_theatre_01_132", direction = IsoDirections.N},
            {name = "location_entertainment_theatre_01_133", direction = IsoDirections.N},
            {name = "location_entertainment_theatre_01_134", direction = IsoDirections.W},
            {name = "location_entertainment_theatre_01_135", direction = IsoDirections.W}
        }
    },
    {
        type = "Left Bar Wall Bar", 
        spriteNames = {
            {name = "location_restaurant_bar_01_29", direction = IsoDirections.S},
            {name = "location_restaurant_bar_01_37", direction = IsoDirections.E}
        }
    },
    {
        type = "Bar Wall Bar", 
        spriteNames = {
            {name = "location_restaurant_bar_01_30", direction = IsoDirections.S},
            {name = "location_restaurant_bar_01_38", direction = IsoDirections.E}
        }
    },
    {
        type = "Right Bar Wall Bar", 
        spriteNames = {
            {name = "location_restaurant_bar_01_31", direction = IsoDirections.S},
            {name = "location_restaurant_bar_01_39", direction = IsoDirections.E}
        }
    },
    {
        type = "Blue Magazine Shelf", 
        spriteNames = {
            {name = "location_shop_fossoil_01_34", direction = IsoDirections.S},
            {name = "location_shop_fossoil_01_35", direction = IsoDirections.S},
            {name = "location_shop_fossoil_01_36", direction = IsoDirections.E},
            {name = "location_shop_fossoil_01_37", direction = IsoDirections.E},
            {name = "location_shop_fossoil_01_64", direction = IsoDirections.W},
            {name = "location_shop_fossoil_01_65", direction = IsoDirections.W},
            {name = "location_shop_fossoil_01_66", direction = IsoDirections.N},
            {name = "location_shop_fossoil_01_67", direction = IsoDirections.N}
        }
    },
    {
        type = "Beige Magazine Shop Shelves", 
        spriteNames = {
            {name = "location_shop_generic_01_2", direction = IsoDirections.S},
            {name = "location_shop_generic_01_3", direction = IsoDirections.E}
        }
    },
    {
        type = "Beige Rack Shop Shelves", 
        spriteNames = {
            {name = "location_shop_generic_01_8", direction = IsoDirections.S},
            {name = "location_shop_generic_01_9", direction = IsoDirections.S},
            {name = "location_shop_generic_01_10", direction = IsoDirections.S},
            {name = "location_shop_generic_01_11", direction = IsoDirections.S},
            {name = "location_shop_generic_01_12", direction = IsoDirections.E},
            {name = "location_shop_generic_01_13", direction = IsoDirections.E},
            {name = "location_shop_generic_01_14", direction = IsoDirections.E},
            {name = "location_shop_generic_01_15", direction = IsoDirections.E}
        }
    },
    -- Not on the wiki list
    -- Original direction non-existent
    {
        type = "Regular Magasine Rack", 
        spriteNames = {
            {name = "location_shop_generic_01_24", direction = IsoDirections.S},
            {name = "location_shop_generic_01_25", direction = IsoDirections.S},
            {name = "location_shop_generic_01_26", direction = IsoDirections.E},
            {name = "location_shop_generic_01_27", direction = IsoDirections.E}
        }
    },
    {
        type = "Large Clothes Rack", 
        spriteNames = {
            {name = "location_shop_generic_01_36", direction = IsoDirections.E},
            {name = "location_shop_generic_01_37", direction = IsoDirections.E},
            {name = "location_shop_generic_01_38", direction = IsoDirections.S},
            {name = "location_shop_generic_01_39", direction = IsoDirections.S}
        }
    },
    {
        type = "Small Clothes Rack", 
        spriteNames = {
            {name = "location_shop_generic_01_48", direction = IsoDirections.E},
            {name = "location_shop_generic_01_49", direction = IsoDirections.E},
            {name = "location_shop_generic_01_50", direction = IsoDirections.S},
            {name = "location_shop_generic_01_51", direction = IsoDirections.S}
        }
    },
    -- Original direction non-existent
    {
        type = "Clothes Stand", 
        spriteNames = {
            {name = "location_shop_generic_01_52", direction = IsoDirections.S}
        }
    },
    {
        type = "Open Wardrobe", 
        spriteNames = {
            {name = "location_shop_generic_01_56", direction = IsoDirections.E},
            {name = "location_shop_generic_01_57", direction = IsoDirections.E},
            {name = "location_shop_generic_01_58", direction = IsoDirections.E},
            {name = "location_shop_generic_01_59", direction = IsoDirections.S},
            {name = "location_shop_generic_01_60", direction = IsoDirections.S},
            {name = "location_shop_generic_01_61", direction = IsoDirections.S}
        }
    },
    {
        type = "Wooden Shop Shelves", 
        spriteNames = {
            {name = "location_shop_generic_01_62", direction = IsoDirections.S},
            {name = "location_shop_generic_01_63", direction = IsoDirections.E}
        }
    },
    {
        type = "Large Shop Shelves", 
        spriteNames = {
            {name = "location_shop_generic_01_72", direction = IsoDirections.S},
            {name = "location_shop_generic_01_73", direction = IsoDirections.S},
            {name = "location_shop_generic_01_74", direction = IsoDirections.E},
            {name = "location_shop_generic_01_75", direction = IsoDirections.E},
            {name = "location_shop_generic_01_76", direction = IsoDirections.N},
            {name = "location_shop_generic_01_77", direction = IsoDirections.N},
            {name = "location_shop_generic_01_78", direction = IsoDirections.W},
            {name = "location_shop_generic_01_79", direction = IsoDirections.W}
        }
    },
    {
        type = "Fancy Wooden Shop Shelves", 
        spriteNames = {
            {name = "location_shop_generic_01_86", direction = IsoDirections.S},
            {name = "location_shop_generic_01_87", direction = IsoDirections.E}
        }
    },
    {
        type = "Greene Grocery Shelves", 
        spriteNames = {
            {name = "location_shop_greenes_01_56", direction = IsoDirections.S},
            {name = "location_shop_greenes_01_57", direction = IsoDirections.S},
            {name = "location_shop_greenes_01_58", direction = IsoDirections.S},
            {name = "location_shop_greenes_01_59", direction = IsoDirections.S},
            {name = "location_shop_greenes_01_60", direction = IsoDirections.E},
            {name = "location_shop_greenes_01_61", direction = IsoDirections.E},
            {name = "location_shop_greenes_01_62", direction = IsoDirections.E},
            {name = "location_shop_greenes_01_63", direction = IsoDirections.E}
        }
    },
    {
        type = "Zippee Low Wall Shelves", 
        spriteNames = {
            {name = "location_shop_zippee_01_4", direction = IsoDirections.S},
            {name = "location_shop_zippee_01_5", direction = IsoDirections.E}
        }
    },
    {
        type = "Red Magazine Shelf", 
        spriteNames = {
            {name = "location_shop_zippee_01_24", direction = IsoDirections.S},
            {name = "location_shop_zippee_01_25", direction = IsoDirections.S},
            {name = "location_shop_zippee_01_26", direction = IsoDirections.W},
            {name = "location_shop_zippee_01_27", direction = IsoDirections.W},
            {name = "location_shop_zippee_01_32", direction = IsoDirections.E},
            {name = "location_shop_zippee_01_33", direction = IsoDirections.E},
            {name = "location_shop_zippee_01_34", direction = IsoDirections.N},
            {name = "location_shop_zippee_01_35", direction = IsoDirections.N}
        }
    },
    {
        type = "Long Shelves", 
        spriteNames = {
            {name = "location_shop_generic_01_40", direction = IsoDirections.S},
            {name = "location_shop_generic_01_41", direction = IsoDirections.S},
            {name = "location_shop_generic_01_42", direction = IsoDirections.S},
            {name = "location_shop_generic_01_43", direction = IsoDirections.S},
            {name = "location_shop_generic_01_44", direction = IsoDirections.E},
            {name = "location_shop_generic_01_45", direction = IsoDirections.E},
            {name = "location_shop_generic_01_46", direction = IsoDirections.E},
            {name = "location_shop_generic_01_47", direction = IsoDirections.E}
        }
    },
    {
        type = "Zippee Shelves Rack", 
        spriteNames = {
            {name = "location_shop_zippee_01_8", direction = IsoDirections.S},
            {name = "location_shop_zippee_01_9", direction = IsoDirections.S},
            {name = "location_shop_zippee_01_10", direction = IsoDirections.S},
            {name = "location_shop_zippee_01_11", direction = IsoDirections.S},
            {name = "location_shop_zippee_01_12", direction = IsoDirections.E},
            {name = "location_shop_zippee_01_13", direction = IsoDirections.E},
            {name = "location_shop_zippee_01_14", direction = IsoDirections.E},
            {name = "location_shop_zippee_01_15", direction = IsoDirections.E}
        }
    },

    -- Storage / Cabinets
    {
        type = "China Cabinet", 
        spriteNames = {
            {name = "furniture_storage_02_32", direction = IsoDirections.E},
            {name = "furniture_storage_02_33", direction = IsoDirections.E},
            {name = "furniture_storage_02_34", direction = IsoDirections.S},
            {name = "furniture_storage_02_35", direction = IsoDirections.S},
            {name = "furniture_storage_02_36", direction = IsoDirections.W},
            {name = "furniture_storage_02_37", direction = IsoDirections.W},
            {name = "furniture_storage_02_38", direction = IsoDirections.N},
            {name = "furniture_storage_02_39", direction = IsoDirections.N}
        }
    },
    {
        type = "Red Mobile Tool Cabinet", 
        spriteNames = {
            {name = "location_business_machinery_01_32", direction = IsoDirections.S},
            {name = "location_business_machinery_01_33", direction = IsoDirections.E},
            {name = "location_business_machinery_01_34", direction = IsoDirections.N},
            {name = "location_business_machinery_01_35", direction = IsoDirections.W}
        }
    },
    {
        type = "Gray File Cabinet", 
        spriteNames = {
            {name = "location_business_office_generic_01_16", direction = IsoDirections.S},
            {name = "location_business_office_generic_01_17", direction = IsoDirections.E},
            {name = "location_business_office_generic_01_24", direction = IsoDirections.N},
            {name = "location_business_office_generic_01_25", direction = IsoDirections.W}
        }
    },
    {
        type = "White File Cabinet", 
        spriteNames = {
            {name = "location_business_office_generic_01_32", direction = IsoDirections.S},
            {name = "location_business_office_generic_01_33", direction = IsoDirections.E},
            {name = "location_business_office_generic_01_34", direction = IsoDirections.N},
            {name = "location_business_office_generic_01_35", direction = IsoDirections.W}
        }
    },

    -- Storage / Desks
    -- Original direction non-existent
    {
        type = "Office Desk", 
        spriteNames = {
            {name = "location_business_office_generic_01_0", direction = IsoDirections.E},
            {name = "location_business_office_generic_01_1", direction = IsoDirections.E},
            {name = "location_business_office_generic_01_2", direction = IsoDirections.E},
            {name = "location_business_office_generic_01_3", direction = IsoDirections.S},
            {name = "location_business_office_generic_01_4", direction = IsoDirections.S},
            {name = "location_business_office_generic_01_5", direction = IsoDirections.S},
            {name = "location_business_office_generic_01_6", direction = IsoDirections.S},
            {name = "location_business_office_generic_01_8", direction = IsoDirections.N},
            {name = "location_business_office_generic_01_9", direction = IsoDirections.N},
            {name = "location_business_office_generic_01_10", direction = IsoDirections.N},
            {name = "location_business_office_generic_01_11", direction = IsoDirections.N},
            {name = "location_business_office_generic_01_12", direction = IsoDirections.N},
            {name = "location_business_office_generic_01_13", direction = IsoDirections.N},
            {name = "location_business_office_generic_01_14", direction = IsoDirections.N},
            {name = "location_business_office_generic_01_40", direction = IsoDirections.E},
            {name = "location_business_office_generic_01_41", direction = IsoDirections.E},
            {name = "location_business_office_generic_01_42", direction = IsoDirections.S},
            {name = "location_business_office_generic_01_43", direction = IsoDirections.S},
            {name = "location_business_office_generic_01_44", direction = IsoDirections.N},
            {name = "location_business_office_generic_01_45", direction = IsoDirections.N},
            {name = "location_business_office_generic_01_46", direction = IsoDirections.W},
            {name = "location_business_office_generic_01_47", direction = IsoDirections.W}
        }
    },
    {
        type = "Dark School Bench", 
        spriteNames = {
            {name = "location_community_school_01_4", direction = IsoDirections.E},
            {name = "location_community_school_01_5", direction = IsoDirections.S},
            {name = "location_community_school_01_6", direction = IsoDirections.N},
            {name = "location_community_school_01_7", direction = IsoDirections.W}
        }
    },
    {
        type = "Light School Bench", 
        spriteNames = {
            {name = "location_community_school_01_12", direction = IsoDirections.E},
            {name = "location_community_school_01_13", direction = IsoDirections.S},
            {name = "location_community_school_01_14", direction = IsoDirections.N},
            {name = "location_community_school_01_15", direction = IsoDirections.W}
        }
    },

    -- Storage / Dressers
    -- Low style
    {
        type = "Fancy Drawers", 
        spriteNames = {
            {name = "furniture_storage_01_8", direction = IsoDirections.E},
            {name = "furniture_storage_01_9", direction = IsoDirections.S},
            {name = "furniture_storage_01_10", direction = IsoDirections.W},
            {name = "furniture_storage_01_11", direction = IsoDirections.N}
        }
    },
    {
        type = "Fancy Oak Drawers", 
        spriteNames = {
            {name = "furniture_storage_01_12", direction = IsoDirections.E},
            {name = "furniture_storage_01_13", direction = IsoDirections.S},
            {name = "furniture_storage_01_14", direction = IsoDirections.W},
            {name = "furniture_storage_01_15", direction = IsoDirections.N}
        }
    },
    {
        type = "Dark Fancy Drawers", 
        spriteNames = {
            {name = "furniture_storage_01_32", direction = IsoDirections.E},
            {name = "furniture_storage_01_33", direction = IsoDirections.S},
            {name = "furniture_storage_01_34", direction = IsoDirections.W},
            {name = "furniture_storage_01_35", direction = IsoDirections.N}
        }
    },
    {
        type = "Mirror And Drawers", 
        spriteNames = {
            {name = "furniture_storage_01_40", direction = IsoDirections.W},
            {name = "furniture_storage_01_41", direction = IsoDirections.N},
            {name = "furniture_storage_01_42", direction = IsoDirections.E},
            {name = "furniture_storage_01_43", direction = IsoDirections.S},
            {name = "furniture_storage_01_64", direction = IsoDirections.W},
            {name = "furniture_storage_01_65", direction = IsoDirections.N},
            {name = "furniture_storage_01_66", direction = IsoDirections.E},
            {name = "furniture_storage_01_67", direction = IsoDirections.S}
        }
    },
    {
        type = "Light Wood Drawers", 
        spriteNames = {
            {name = "furniture_storage_01_44", direction = IsoDirections.W},
            {name = "furniture_storage_01_45", direction = IsoDirections.N},
            {name = "furniture_storage_01_46", direction = IsoDirections.E},
            {name = "furniture_storage_01_47", direction = IsoDirections.S}
        }
    },
    {
        type = "Bedroom Drawers", 
        spriteNames = {
            {name = "furniture_storage_01_48", direction = IsoDirections.S},
            {name = "furniture_storage_01_49", direction = IsoDirections.E},
            {name = "furniture_storage_01_50", direction = IsoDirections.W},
            {name = "furniture_storage_01_51", direction = IsoDirections.N}
        }
    },
    -- Not on the wiki list
    {
        type = "Medical Drawers", 
        spriteNames = {
            {name = "location_community_medical_01_36", direction = IsoDirections.E},
            {name = "location_community_medical_01_37", direction = IsoDirections.S},
            {name = "location_community_medical_01_38", direction = IsoDirections.W},
            {name = "location_community_medical_01_39", direction = IsoDirections.N}
        }
    },
    -- High style
    {
        type = "Fancy White Wardrobe", 
        spriteNames = {
            {name = "furniture_storage_01_0", direction = IsoDirections.E},
            {name = "furniture_storage_01_1", direction = IsoDirections.E},
            {name = "furniture_storage_01_2", direction = IsoDirections.S},
            {name = "furniture_storage_01_3", direction = IsoDirections.S},
            {name = "furniture_storage_01_4", direction = IsoDirections.W},
            {name = "furniture_storage_01_5", direction = IsoDirections.W},
            {name = "furniture_storage_01_6", direction = IsoDirections.N},
            {name = "furniture_storage_01_7", direction = IsoDirections.N}
        }
    },
    {
        type = "Fancy Oak Wardrobe", 
        spriteNames = {
            {name = "furniture_storage_01_16", direction = IsoDirections.E},
            {name = "furniture_storage_01_17", direction = IsoDirections.E},
            {name = "furniture_storage_01_18", direction = IsoDirections.S},
            {name = "furniture_storage_01_19", direction = IsoDirections.S},
            {name = "furniture_storage_01_20", direction = IsoDirections.W},
            {name = "furniture_storage_01_21", direction = IsoDirections.W},
            {name = "furniture_storage_01_22", direction = IsoDirections.N},
            {name = "furniture_storage_01_23", direction = IsoDirections.N}
        }
    },
    {
        type = "Dark Fancy Wardrobe", 
        spriteNames = {
            {name = "furniture_storage_01_24", direction = IsoDirections.E},
            {name = "furniture_storage_01_25", direction = IsoDirections.E},
            {name = "furniture_storage_01_26", direction = IsoDirections.S},
            {name = "furniture_storage_01_27", direction = IsoDirections.S},
            {name = "furniture_storage_01_28", direction = IsoDirections.N},
            {name = "furniture_storage_01_29", direction = IsoDirections.N},
            {name = "furniture_storage_01_30", direction = IsoDirections.W},
            {name = "furniture_storage_01_31", direction = IsoDirections.W}
        }
    },
    {
        type = "Large Wardrobe", 
        spriteNames = {
            {name = "furniture_storage_01_36", direction = IsoDirections.E},
            {name = "furniture_storage_01_37", direction = IsoDirections.E},
            {name = "furniture_storage_01_38", direction = IsoDirections.S},
            {name = "furniture_storage_01_39", direction = IsoDirections.S},
            {name = "furniture_storage_02_20", direction = IsoDirections.W},
            {name = "furniture_storage_02_21", direction = IsoDirections.W},
            {name = "furniture_storage_02_22", direction = IsoDirections.N},
            {name = "furniture_storage_02_23", direction = IsoDirections.N}
        }
    },
    {
        type = "Light Wood Wardrobe", 
        spriteNames = {
            {name = "furniture_storage_01_56", direction = IsoDirections.E},
            {name = "furniture_storage_01_57", direction = IsoDirections.E},
            {name = "furniture_storage_01_58", direction = IsoDirections.S},
            {name = "furniture_storage_01_59", direction = IsoDirections.S},
            {name = "furniture_storage_01_60", direction = IsoDirections.W},
            {name = "furniture_storage_01_61", direction = IsoDirections.W},
            {name = "furniture_storage_01_62", direction = IsoDirections.N},
            {name = "furniture_storage_01_63", direction = IsoDirections.N}
        }
    },
    {
        type = "White Wardrobe", 
        spriteNames = {
            {name = "furniture_storage_02_40", direction = IsoDirections.E},
            {name = "furniture_storage_02_41", direction = IsoDirections.E},
            {name = "furniture_storage_02_42", direction = IsoDirections.S},
            {name = "furniture_storage_02_43", direction = IsoDirections.S},
            {name = "furniture_storage_02_44", direction = IsoDirections.W},
            {name = "furniture_storage_02_45", direction = IsoDirections.W},
            {name = "furniture_storage_02_46", direction = IsoDirections.N},
            {name = "furniture_storage_02_47", direction = IsoDirections.N}
        }
    },

    -- Storage / Lockers
    {
        type = "Crude Tall Locker", 
        spriteNames = {
            {name = "crafted_05_16", direction = IsoDirections.S},
            {name = "crafted_05_17", direction = IsoDirections.E},
            {name = "crafted_05_19", direction = IsoDirections.E}
        }
    },
    {
        type = "Crude Wall Locker", 
        spriteNames = {
            {name = "crafted_05_20", direction = IsoDirections.S},
            {name = "crafted_05_21", direction = IsoDirections.E},
            {name = "crafted_05_22", direction = IsoDirections.N},
            {name = "crafted_05_23", direction = IsoDirections.W}
        }
    },
    {
        type = "Blue Wall Locker", 
        spriteNames = {
            {name = "furniture_storage_02_4", direction = IsoDirections.E},
            {name = "furniture_storage_02_5", direction = IsoDirections.S},
            {name = "furniture_storage_02_6", direction = IsoDirections.W},
            {name = "furniture_storage_02_7", direction = IsoDirections.N}
        }
    },
    {
        type = "Small Locker", 
        spriteNames = {
            {name = "furniture_storage_02_8", direction = IsoDirections.S},
            {name = "furniture_storage_02_9", direction = IsoDirections.E}
        }
    },
    {
        type = "Big Locker", 
        spriteNames = {
            {name = "furniture_storage_02_12", direction = IsoDirections.E},
            {name = "furniture_storage_02_13", direction = IsoDirections.S},
            {name = "furniture_storage_02_14", direction = IsoDirections.W},
            {name = "furniture_storage_02_15", direction = IsoDirections.N}
        }
    },
    {
        type = "Military Locker", 
        spriteNames = {
            {name = "location_military_generic_01_22", direction = IsoDirections.S},
            {name = "location_military_generic_01_23", direction = IsoDirections.E},
            {name = "location_military_generic_01_30", direction = IsoDirections.N},
            {name = "location_military_generic_01_31", direction = IsoDirections.W}
        }
    },

    -- Storage / Crates
    -- Original direction non-existent
    {
        type = "Wooden Crate", 
        spriteNames = {
            {name = "carpentry_01_16", direction = IsoDirections.S},
            {name = "carpentry_01_19", direction = IsoDirections.S}
        }
    },
    {
        type = "Metal Crate", 
        spriteNames = {
            {name = "constructedobjects_01_44", direction = IsoDirections.N},
            {name = "constructedobjects_01_45", direction = IsoDirections.W},
            {name = "constructedobjects_01_46", direction = IsoDirections.S},
            {name = "constructedobjects_01_47", direction = IsoDirections.E}
        }
    },
    {
        type = "Fancy Metal Crate", 
        spriteNames = {
            {name = "crafted_05_44", direction = IsoDirections.N}
        }
    },
    -- Original direction non-existent
    {
        type = "Large Cardboard Box", 
        spriteNames = {
            {name = "furniture_storage_02_16", direction = IsoDirections.S},
            {name = "furniture_storage_02_17", direction = IsoDirections.S},
            {name = "furniture_storage_02_18", direction = IsoDirections.S},
            {name = "furniture_storage_02_19", direction = IsoDirections.S},
            {name = "furniture_storage_02_24", direction = IsoDirections.S},
            {name = "furniture_storage_02_25", direction = IsoDirections.S},
            {name = "furniture_storage_02_26", direction = IsoDirections.S},
            {name = "furniture_storage_02_27", direction = IsoDirections.S}
        }
    },
    -- Original direction non-existent
    {
        type = "Military Crate", 
        spriteNames = {
            {name = "location_military_generic_01_0", direction = IsoDirections.S},
            {name = "location_military_generic_01_1", direction = IsoDirections.S},
            {name = "location_military_generic_01_2", direction = IsoDirections.S},
            {name = "location_military_generic_01_3", direction = IsoDirections.S},
            {name = "location_military_generic_01_4", direction = IsoDirections.S},
            {name = "location_military_generic_01_5", direction = IsoDirections.S},
            {name = "location_military_generic_01_8", direction = IsoDirections.S},
            {name = "location_military_generic_01_9", direction = IsoDirections.S},
            {name = "location_military_generic_01_10", direction = IsoDirections.S},
            {name = "location_military_generic_01_11", direction = IsoDirections.S},
            {name = "location_military_generic_01_12", direction = IsoDirections.S},
            {name = "location_military_generic_01_13", direction = IsoDirections.S}
        }
    },
    {
        type = "Cardboard Box", 
        spriteNames = {
            {name = "trashcontainers_01_24", direction = IsoDirections.S},
            {name = "trashcontainers_01_25", direction = IsoDirections.E}
        }
    },
    {
        type = "Battered Cardboard Box", 
        spriteNames = {
            {name = "trashcontainers_01_26", direction = IsoDirections.S},
            {name = "trashcontainers_01_27", direction = IsoDirections.E}
        }
    },
    -- Original direction non-existent
    {
        type = "Small Crate", 
        spriteNames = {
            {name = "location_shop_greenes_01_35", direction = IsoDirections.S}
        }
    },

    -- Storage / Displays
    {
        type = "Glass Display Stand", 
        spriteNames = {
            {name = "location_restaurant_pie_01_48", direction = IsoDirections.E},
            {name = "location_restaurant_pie_01_49", direction = IsoDirections.E},
            {name = "location_restaurant_pie_01_50", direction = IsoDirections.S},
            {name = "location_restaurant_pie_01_51", direction = IsoDirections.S}
        }
    },
    {
        type = "Pie Display Stand", 
        spriteNames = {
            {name = "location_restaurant_pie_01_52", direction = IsoDirections.S},
            {name = "location_restaurant_pie_01_53", direction = IsoDirections.E},
            {name = "location_restaurant_pie_01_54", direction = IsoDirections.N},
            {name = "location_restaurant_pie_01_55", direction = IsoDirections.W}
        }
    },
    {
        type = "Glass Display", 
        spriteNames = {
            {name = "location_restaurant_pizzawhirled_01_64", direction = IsoDirections.E},
            {name = "location_restaurant_pizzawhirled_01_65", direction = IsoDirections.E},
            {name = "location_restaurant_pizzawhirled_01_66", direction = IsoDirections.S},
            {name = "location_restaurant_pizzawhirled_01_67", direction = IsoDirections.S}
        }
    },
    {
        type = "Seahorse Coffee Glass Display", 
        spriteNames = {
            {name = "location_restaurant_seahorse_01_56", direction = IsoDirections.S},
            {name = "location_restaurant_seahorse_01_57", direction = IsoDirections.S},
            {name = "location_restaurant_seahorse_01_58", direction = IsoDirections.E},
            {name = "location_restaurant_seahorse_01_59", direction = IsoDirections.E}
        }
    },

    -- Storage / Mail boxes
    {
        type = "Public Mail Box", 
        spriteNames = {
            {name = "street_decoration_01_8", direction = IsoDirections.S},
            {name = "street_decoration_01_9", direction = IsoDirections.E},
            {name = "street_decoration_01_10", direction = IsoDirections.N},
            {name = "street_decoration_01_11", direction = IsoDirections.W}
        }
    },

    -- Storage / Mannequins
    -- Original direction non-existent
    {
        type = "Scarecrow", 
        spriteNames = {
            {name = "location_farm_accesories_01_36", direction = IsoDirections.S}
        }
    },
    -- Original direction non-existent
    {
        type = "Mannequin", 
        spriteNames = {
            {name = "location_shop_mall_01_65", direction = IsoDirections.S},
            {name = "location_shop_mall_01_66", direction = IsoDirections.S},
            {name = "location_shop_mall_01_67", direction = IsoDirections.S},
            {name = "location_shop_mall_01_68", direction = IsoDirections.S},
            {name = "location_shop_mall_01_69", direction = IsoDirections.S},
            {name = "location_shop_mall_01_70", direction = IsoDirections.S},
            {name = "location_shop_mall_01_73", direction = IsoDirections.S},
            {name = "location_shop_mall_01_74", direction = IsoDirections.S},
            {name = "location_shop_mall_01_75", direction = IsoDirections.S},
            {name = "location_shop_mall_01_76", direction = IsoDirections.S}
        }
    },

    -- Storage / Bins
    {
        type = "Garbage Bin", 
        spriteNames = {
            {name = "location_restaurant_pizzawhirled_01_17", direction = IsoDirections.S},
            {name = "location_restaurant_pizzawhirled_01_18", direction = IsoDirections.E}
        }
    },
    {
        type = "Spiffo Garbage Bin", 
        spriteNames = {
            {name = "location_restaurant_spiffos_01_30", direction = IsoDirections.S},
            {name = "location_restaurant_spiffos_01_31", direction = IsoDirections.E}
        }
    },
    {
        type = "Fossoil Garbage Bin", 
        spriteNames = {
            {name = "location_shop_fossoil_01_32", direction = IsoDirections.S},
            {name = "location_shop_fossoil_01_33", direction = IsoDirections.E}
        }
    },
    -- Original direction non-existent
    {
        type = "Mall Garbage Bin", 
        spriteNames = {
            {name = "location_shop_mall_01_44", direction = IsoDirections.S}
        }
    },
    {
        type = "Wheelie Bin", 
        spriteNames = {
            {name = "trashcontainers_01_0", direction = IsoDirections.S},
            {name = "trashcontainers_01_1", direction = IsoDirections.E},
            {name = "trashcontainers_01_2", direction = IsoDirections.N},
            {name = "trashcontainers_01_3", direction = IsoDirections.W}
        }
    },
    -- Original direction non-existent
    {
        type = "Recycle Bin", 
        spriteNames = {
            {name = "trashcontainers_01_16", direction = IsoDirections.S}
        }
    },
    -- Original direction non-existent
    {
        type = "Green Garbage Bin", 
        spriteNames = {
            {name = "trashcontainers_01_17", direction = IsoDirections.S}
        }
    },
    {
        type = "Gray Garbage Bin", 
        spriteNames = {
            {name = "trashcontainers_01_18", direction = IsoDirections.S},
            {name = "trashcontainers_01_19", direction = IsoDirections.E}
        }
    },
    -- Original direction non-existent
    {
        type = "Public Garbage Bin", 
        spriteNames = {
            {name = "trashcontainers_01_21", direction = IsoDirections.S}
        }
    },
    -- Dumpsters
    {
        type = "Blue Dumpster", 
        spriteNames = {
            {name = "trashcontainers_01_8", direction = IsoDirections.E},
            {name = "trashcontainers_01_9", direction = IsoDirections.E},
            {name = "trashcontainers_01_10", direction = IsoDirections.S},
            {name = "trashcontainers_01_11", direction = IsoDirections.S}
        }
    },
    {
        type = "Orange Dumpster", 
        spriteNames = {
            {name = "trashcontainers_01_12", direction = IsoDirections.E},
            {name = "trashcontainers_01_13", direction = IsoDirections.E},
            {name = "trashcontainers_01_14", direction = IsoDirections.S},
            {name = "trashcontainers_01_15", direction = IsoDirections.S}
        }
    },

    -- Storage / Other
    {
        type = "Slurp Burp Soda Machine", 
        spriteNames = {
            {name = "location_shop_zippee_01_56", direction = IsoDirections.S},
            {name = "location_shop_zippee_01_57", direction = IsoDirections.E}
        }
    },
    {
        type = "Large Machine", 
        spriteNames = {
            {name = "location_shop_accessories_01_16", direction = IsoDirections.E},
            {name = "location_shop_accessories_01_17", direction = IsoDirections.S},
            {name = "location_shop_accessories_01_28", direction = IsoDirections.E},
            {name = "location_shop_accessories_01_29", direction = IsoDirections.E}
        }
    },
    -- ****************************************************************
    -- Workstations
    {
        type = "Branch Workbench", 
        spriteNames = {
            {name = "crafted_04_96", direction = IsoDirections.S},
            {name = "crafted_04_97", direction = IsoDirections.S},
            {name = "crafted_04_98", direction = IsoDirections.E},
            {name = "crafted_04_99", direction = IsoDirections.E},
            {name = "crafted_04_100", direction = IsoDirections.N},
            {name = "crafted_04_101", direction = IsoDirections.N},
            {name = "crafted_04_102", direction = IsoDirections.W},
            {name = "crafted_04_103", direction = IsoDirections.W}
        }
    },
    {
        type = "Wood Top Workbench", 
        spriteNames = {
            {name = "location_business_machinery_01_16", direction = IsoDirections.S},
            {name = "location_business_machinery_01_17", direction = IsoDirections.S},
            {name = "location_business_machinery_01_18", direction = IsoDirections.E},
            {name = "location_business_machinery_01_19", direction = IsoDirections.E},
            {name = "location_business_machinery_01_20", direction = IsoDirections.N},
            {name = "location_business_machinery_01_21", direction = IsoDirections.N},
            {name = "location_business_machinery_01_22", direction = IsoDirections.W},
            {name = "location_business_machinery_01_23", direction = IsoDirections.W}
        }
    },
    {
        type = "Complex Loom", 
        spriteNames = {
            {name = "crafted_04_72", direction = IsoDirections.S},
            {name = "crafted_04_73", direction = IsoDirections.E},
            {name = "crafted_04_74", direction = IsoDirections.N},
            {name = "crafted_04_75", direction = IsoDirections.W}
        }
    },
    {
        type = "Simple Loom", 
        spriteNames = {
            {name = "crafted_04_80", direction = IsoDirections.S},
            {name = "crafted_04_81", direction = IsoDirections.S},
            {name = "crafted_04_83", direction = IsoDirections.E},
            {name = "crafted_04_84", direction = IsoDirections.E}
        }
    },
    {
        type = "Simple Pottery Wheel", 
        spriteNames = {
            {name = "crafted_01_64", direction = IsoDirections.S},
            {name = "crafted_01_65", direction = IsoDirections.S},
            {name = "crafted_01_66", direction = IsoDirections.E},
            {name = "crafted_01_67", direction = IsoDirections.E}
        }
    },
    {
        type = "Modern Pottery Wheel", 
        spriteNames = {
            {name = "crafted_01_88", direction = IsoDirections.S},
            {name = "crafted_01_89", direction = IsoDirections.S},
            {name = "crafted_01_90", direction = IsoDirections.E},
            {name = "crafted_01_91", direction = IsoDirections.E},
            {name = "crafted_01_92", direction = IsoDirections.N},
            {name = "crafted_01_93", direction = IsoDirections.N},
            {name = "crafted_01_94", direction = IsoDirections.W},
            {name = "crafted_01_95", direction = IsoDirections.W}
        }
    },
    -- ****************************************************************
    -- Decorations / Sculptures
    {
        type = "Male Bust", 
        spriteNames = {
            {name = "location_entertainment_gallery_02_48", direction = IsoDirections.E},
            {name = "location_entertainment_gallery_02_51", direction = IsoDirections.S}
        }
    },
    {
        type = "Female Bust", 
        spriteNames = {
            {name = "location_entertainment_gallery_02_49", direction = IsoDirections.E},
            {name = "location_entertainment_gallery_02_50", direction = IsoDirections.S}
        }
    },
    -- Original direction non-existent
    {
        type = "Female Statue", 
        spriteNames = {
            {name = "location_entertainment_gallery_02_52", direction = IsoDirections.S}
        }
    },
    -- Original direction non-existent
    {
        type = "Male Statue", 
        spriteNames = {
            {name = "location_entertainment_gallery_02_53", direction = IsoDirections.S}
        }
    },
    -- Original direction non-existent
    {
        type = "Gallery Toilet", 
        spriteNames = {
            {name = "location_entertainment_gallery_02_56", direction = IsoDirections.S}
        }
    },
    {
        type = "Gallery Bed", 
        spriteNames = {
            {name = "location_entertainment_gallery_02_57", direction = IsoDirections.S},
            {name = "location_entertainment_gallery_02_58", direction = IsoDirections.S},
            {name = "location_entertainment_gallery_02_60", direction = IsoDirections.E}
        }
    },
    -- Not on the wiki list
    {
        type = "Famous Man Statue", 
        spriteNames = {
            {name = "location_entertainment_gallery_02_54", direction = IsoDirections.S},
            {name = "location_entertainment_gallery_02_55", direction = IsoDirections.S}
        }
    },
    -- Not on the wiki list
    {
        type = "Giant Horseman Statue", 
        spriteNames = {
            {name = "location_entertainment_gallery_02_72", direction = IsoDirections.S},
            {name = "location_entertainment_gallery_02_73", direction = IsoDirections.S},
            {name = "location_entertainment_gallery_02_74", direction = IsoDirections.S},
            {name = "location_entertainment_gallery_02_77", direction = IsoDirections.E}
        }
    },
    -- Not on the wiki list
    -- Original direction non-existent
    {
        type = "Giant Horse Statue", 
        spriteNames = {
            {name = "location_entertainment_gallery_02_88", direction = IsoDirections.S},
            {name = "location_entertainment_gallery_02_89", direction = IsoDirections.S},
            {name = "location_entertainment_gallery_02_90", direction = IsoDirections.S},
            {name = "location_entertainment_gallery_02_91", direction = IsoDirections.S},
            {name = "location_entertainment_gallery_02_95", direction = IsoDirections.E}
        }
    },

    -- Decorations / Phones
    {
        type = "Pay Phones", 
        spriteNames = {
            {name = "street_decoration_01_38", direction = IsoDirections.E},
            {name = "street_decoration_01_39", direction = IsoDirections.S}
        }
    },

    -- Decorations / Other
    -- Original direction non-existent
    {
        type = "Bird Bath", 
        spriteNames = {
            {name = "vegetation_ornamental_01_50", direction = IsoDirections.S},
            {name = "vegetation_ornamental_01_51", direction = IsoDirections.S}
        }
    },
    {
        type = "Mall Map", 
        spriteNames = {
            {name = "location_shop_mall_01_45", direction = IsoDirections.E},
            {name = "location_shop_mall_01_46", direction = IsoDirections.S}
        }
    },
    -- ****************************************************************
    -- Signs
    {
        type = "Ominous Sign", 
        spriteNames = {
            {name = "location_community_church_small_01_62", direction = IsoDirections.S},
            {name = "location_community_church_small_01_63", direction = IsoDirections.S}
        }
    },
    -- Nothing to stand against
    -- Need direction adjustment
    --[[
    {
        type = "Spiffo Arrow Sign", 
        spriteNames = {
            {name = "location_restaurant_spiffos_02_56", direction = IsoDirections.S},
            {name = "location_restaurant_spiffos_02_57", direction = IsoDirections.E},
            {name = "location_restaurant_spiffos_02_58", direction = IsoDirections.E},
            {name = "location_restaurant_spiffos_02_59", direction = IsoDirections.S}
        }
    },
    ]]
    {
        type = "For Sale Sign", 
        spriteNames = {
            {name = "location_shop_accessories_genericsigns_01_6", direction = IsoDirections.S},
            {name = "location_shop_accessories_genericsigns_01_7", direction = IsoDirections.E}
        }
    },
    {
        type = "Blowout Sign", 
        spriteNames = {
            {name = "location_shop_bargNclothes_01_38", direction = IsoDirections.S},
            {name = "location_shop_bargNclothes_01_39", direction = IsoDirections.S}
        }
    },
    {
        type = "Sale Sign", 
        spriteNames = {
            {name = "location_shop_generic_01_70", direction = IsoDirections.E},
            {name = "location_shop_generic_01_71", direction = IsoDirections.S}
        }
    },
    -- Nothing to stand against
    --[[
    {
        type = "Inmates Road Sign", 
        spriteNames = {
            {name = "location_community_police_01_42", direction = IsoDirections.E},
            {name = "location_community_police_01_43", direction = IsoDirections.E}
        }
    },
    {
        type = "Rest Area Road Sign", 
        spriteNames = {
            {name = "street_roadsigns_01_32", direction = IsoDirections.S},
            {name = "street_roadsigns_01_33", direction = IsoDirections.S},
            {name = "street_roadsigns_01_38", direction = IsoDirections.E},
            {name = "street_roadsigns_01_39", direction = IsoDirections.E},
            {name = "street_roadsigns_01_40", direction = IsoDirections.W},
            {name = "street_roadsigns_01_41", direction = IsoDirections.W},
            {name = "street_roadsigns_01_48", direction = IsoDirections.N},
            {name = "street_roadsigns_01_49", direction = IsoDirections.N}
        }
    },
    {
        type = "Muldraugh Road Sign", 
        spriteNames = {
            {name = "street_roadsigns_01_34", direction = IsoDirections.E},
            {name = "street_roadsigns_01_35", direction = IsoDirections.E}
        }
    },
    {
        type = "West Point Road Sign", 
        spriteNames = {
            {name = "street_roadsigns_01_36", direction = IsoDirections.S},
            {name = "street_roadsigns_01_37", direction = IsoDirections.S}
        }
    },
    {
        type = "Rosewood Road Sign", 
        spriteNames = {
            {name = "street_roadsigns_01_42", direction = IsoDirections.S},
            {name = "street_roadsigns_01_43", direction = IsoDirections.S},
            {name = "street_roadsigns_01_44", direction = IsoDirections.N},
            {name = "street_roadsigns_01_45", direction = IsoDirections.N}
        }
    },
    {
        type = "March Ridge Road Sign", 
        spriteNames = {
            {name = "street_roadsigns_01_46", direction = IsoDirections.S},
            {name = "street_roadsigns_01_47", direction = IsoDirections.S}
        }
    },
    {
        type = "Rest Area South Road Sign", 
        spriteNames = {
            {name = "street_roadsigns_01_50", direction = IsoDirections.S},
            {name = "street_roadsigns_01_51", direction = IsoDirections.S}
        }
    },
    ]]
    -- From here on nothing is in the Wiki
    {
        type = "What Missing Sign", 
        spriteNames = {
            {name = "signs_church_0", direction = IsoDirections.S},
            {name = "signs_church_1", direction = IsoDirections.S}
        }
    },
    {
        type = "Hungry Desert Sign", 
        spriteNames = {
            {name = "signs_church_2", direction = IsoDirections.E},
            {name = "signs_church_3", direction = IsoDirections.E}
        }
    },
    {
        type = "Burn In Hell Sign", 
        spriteNames = {
            {name = "signs_church_4", direction = IsoDirections.S},
            {name = "signs_church_5", direction = IsoDirections.S}
        }
    },
    {
        type = "Jesus Carry Sign", 
        spriteNames = {
            {name = "signs_church_6", direction = IsoDirections.E},
            {name = "signs_church_7", direction = IsoDirections.E}
        }
    },
    {
        type = "Jesus Save Sign", 
        spriteNames = {
            {name = "signs_church_8", direction = IsoDirections.S},
            {name = "signs_church_9", direction = IsoDirections.S}
        }
    },
    {
        type = "Lord Shepherd Sign", 
        spriteNames = {
            {name = "signs_church_10", direction = IsoDirections.E},
            {name = "signs_church_11", direction = IsoDirections.E}
        }
    },
    {
        type = "God Knox Sign", 
        spriteNames = {
            {name = "signs_church_12", direction = IsoDirections.S},
            {name = "signs_church_13", direction = IsoDirections.S}
        }
    },
    {
        type = "Service Daily Sign", 
        spriteNames = {
            {name = "signs_church_14", direction = IsoDirections.E},
            {name = "signs_church_15", direction = IsoDirections.E}
        }
    },
    {
        type = "God Watching Sign", 
        spriteNames = {
            {name = "signs_church_16", direction = IsoDirections.S},
            {name = "signs_church_17", direction = IsoDirections.S}
        }
    },
    {
        type = "Satan Domain Sign", 
        spriteNames = {
            {name = "signs_church_18", direction = IsoDirections.E},
            {name = "signs_church_19", direction = IsoDirections.E}
        }
    },
    {
        type = "Evening Service Sign", 
        spriteNames = {
            {name = "signs_church_20", direction = IsoDirections.S},
            {name = "signs_church_21", direction = IsoDirections.S}
        }
    },
    {
        type = "Devious Gooses Sign", 
        spriteNames = {
            {name = "signs_church_22", direction = IsoDirections.E},
            {name = "signs_church_23", direction = IsoDirections.E}
        }
    },
    {
        type = "Chris Died Sign", 
        spriteNames = {
            {name = "signs_church_24", direction = IsoDirections.S},
            {name = "signs_church_25", direction = IsoDirections.S}
        }
    },
    {
        type = "Lord Forsaken Sign", 
        spriteNames = {
            {name = "signs_church_26", direction = IsoDirections.E},
            {name = "signs_church_27", direction = IsoDirections.E}
        }
    },
    {
        type = "To 19 Sign", 
        spriteNames = {
            {name = "signs_church_28", direction = IsoDirections.S},
            {name = "signs_church_29", direction = IsoDirections.S}
        }
    },
    {
        type = "God Will Sign", 
        spriteNames = {
            {name = "signs_church_30", direction = IsoDirections.E},
            {name = "signs_church_31", direction = IsoDirections.E}
        }
    },
    {
        type = "No Credit Sign", 
        spriteNames = {
            {name = "signs_one-off_01_104", direction = IsoDirections.S},
            {name = "signs_one-off_01_105", direction = IsoDirections.S}
        }
    },
    {
        type = "Pony Roam Sign", 
        spriteNames = {
            {name = "signs_one-off_01_24", direction = IsoDirections.S},
            {name = "signs_one-off_01_25", direction = IsoDirections.S},
            {name = "signs_one-off_01_26", direction = IsoDirections.S}
        }
    },
    --[[
    {
        type = "Riverside Suites Sign", 
        spriteNames = {
            {name = "signs_one-off_01_112", direction = IsoDirections.S},
            {name = "signs_one-off_01_113", direction = IsoDirections.S},
            {name = "signs_one-off_01_114", direction = IsoDirections.S}
        }
    },
    ]]
    {
        type = "Sunstarmotel Sign", 
        spriteNames = {
            {name = "location_hospitality_sunstarmotel_02_6", direction = IsoDirections.S},
            {name = "location_hospitality_sunstarmotel_02_7", direction = IsoDirections.S}
        }
    },
    {
        type = "Advertising Mall", 
        spriteNames = {
            {name = "advertising_02_0", direction = IsoDirections.E},
            {name = "advertising_02_1", direction = IsoDirections.S}
        }
    },
    {
        type = "Hodgetts Sign", 
        spriteNames = {
            {name = "signs_one-off_07_276", direction = IsoDirections.E},
            {name = "signs_one-off_07_277", direction = IsoDirections.E},
            {name = "signs_one-off_07_278", direction = IsoDirections.E}
        }
    },
    -- ****************************************************************
    -- Plants
    -- Low style
    -- Original direction non-existent
    {
        type = "Raised Plantbed", 
        spriteNames = {
            {name = "vegetation_indoor_01_8", direction = IsoDirections.S},
            {name = "vegetation_indoor_01_16", direction = IsoDirections.S},
            {name = "vegetation_indoor_01_24", direction = IsoDirections.S},
            {name = "vegetation_indoor_01_32", direction = IsoDirections.S}
        }
    },
    -- Original direction non-existent
    {
        type = "Single Stacked Hay", 
        spriteNames = {
            {name = "vegetation_farm_01_8", direction = IsoDirections.E},
            {name = "vegetation_farm_01_9", direction = IsoDirections.E},
            {name = "vegetation_farm_01_16", direction = IsoDirections.S},
            {name = "vegetation_farm_01_17", direction = IsoDirections.S}
        }
    },
    {
        type = "Low Hedge", 
        spriteNames = {
            {name = "vegetation_ornamental_01_4", direction = IsoDirections.S},
            {name = "vegetation_ornamental_01_5", direction = IsoDirections.E}
        }
    },
    {
        type = "Low Corner Hedge", 
        spriteNames = {
            {name = "vegetation_ornamental_01_6", direction = IsoDirections.S},
            {name = "vegetation_ornamental_01_7", direction = IsoDirections.N},
            {name = "vegetation_ornamental_01_12", direction = IsoDirections.W},
            {name = "vegetation_ornamental_01_13", direction = IsoDirections.E}
        }
    },
    -- High style
    -- Original direction non-existent
    {
        type = "Double Stacked Hay", 
        spriteNames = {
            {name = "vegetation_farm_01_10", direction = IsoDirections.E},
            {name = "vegetation_farm_01_11", direction = IsoDirections.E},
            {name = "vegetation_farm_01_18", direction = IsoDirections.S},
            {name = "vegetation_farm_01_19", direction = IsoDirections.S}
        }
    },
    {
        type = "Tall Hedge", 
        spriteNames = {
            {name = "vegetation_ornamental_01_0", direction = IsoDirections.S},
            {name = "vegetation_ornamental_01_1", direction = IsoDirections.E}
        }
    },
    {
        type = "Tall Corner Hedge", 
        spriteNames = {
            {name = "vegetation_ornamental_01_2", direction = IsoDirections.S},
            {name = "vegetation_ornamental_01_3", direction = IsoDirections.N},
            {name = "vegetation_ornamental_01_10", direction = IsoDirections.W},
            {name = "vegetation_ornamental_01_11", direction = IsoDirections.E}
        }
    },
    -- ****************************************************************
    -- Miscellaneous
    -- Low style
    {
        type = "Large Metal Trough", 
        spriteNames = {
            {name = "location_farm_accesories_01_27", direction = IsoDirections.W},
            {name = "location_farm_accesories_01_28", direction = IsoDirections.W},
            {name = "location_farm_accesories_01_29", direction = IsoDirections.W}
        }
    },
    {
        type = "Small Metal Trough", 
        spriteNames = {
            {name = "location_farm_accesories_01_34", direction = IsoDirections.W},
            {name = "location_farm_accesories_01_35", direction = IsoDirections.W}
        }
    },
    {
        type = "Laundry Cart", 
        spriteNames = {
            {name = "appliances_laundry_01_24", direction = IsoDirections.N},
            {name = "appliances_laundry_01_25", direction = IsoDirections.W}
        }
    },
    {
        type = "Road Block", 
        spriteNames = {
            {name = "construction_01_8", direction = IsoDirections.S},
            {name = "construction_01_9", direction = IsoDirections.E}
        }
    },
    {
        type = "Flat Coffin", 
        spriteNames = {
            {name = "crafted_04_44", direction = IsoDirections.E},
            {name = "crafted_04_45", direction = IsoDirections.E},
            {name = "crafted_04_46", direction = IsoDirections.S},
            {name = "crafted_04_47", direction = IsoDirections.S},
            {name = "crafted_04_48", direction = IsoDirections.N},
            {name = "crafted_04_49", direction = IsoDirections.N},
            {name = "crafted_04_50", direction = IsoDirections.W}
        }
    },
    {
        type = "Upright Coffin", 
        spriteNames = {
            {name = "crafted_04_51", direction = IsoDirections.W},
            {name = "crafted_04_52", direction = IsoDirections.E},
            {name = "crafted_04_53", direction = IsoDirections.S},
            {name = "crafted_04_54", direction = IsoDirections.W},
            {name = "crafted_04_55", direction = IsoDirections.N}
        }
    },
    {
        type = "Round Gravestone", 
        spriteNames = {
            {name = "location_community_cemetary_01_0", direction = IsoDirections.S},
            {name = "location_community_cemetary_01_1", direction = IsoDirections.E}
        }
    },
    {
        type = "Arched Gravestone", 
        spriteNames = {
            {name = "location_community_cemetary_01_2", direction = IsoDirections.S},
            {name = "location_community_cemetary_01_3", direction = IsoDirections.E}
        }
    },
    {
        type = "Square Gravestone", 
        spriteNames = {
            {name = "location_community_cemetary_01_4", direction = IsoDirections.S},
            {name = "location_community_cemetary_01_5", direction = IsoDirections.E}
        }
    },
    {
        type = "Battered Gravestone", 
        spriteNames = {
            {name = "location_community_cemetary_01_8", direction = IsoDirections.S},
            {name = "location_community_cemetary_01_9", direction = IsoDirections.E}
        }
    },
    {
        type = "Decorated Altar", 
        spriteNames = {
            {name = "location_community_church_small_01_40", direction = IsoDirections.S},
            {name = "location_community_church_small_01_41", direction = IsoDirections.S},
            {name = "location_community_church_small_01_42", direction = IsoDirections.E},
            {name = "location_community_church_small_01_43", direction = IsoDirections.E}
        }
    },
    -- Original direction non-existent
    {
        type = "Brick Planter", 
        spriteNames = {
            {name = "location_shop_mall_01_47", direction = IsoDirections.S}
        }
    },
    {
        type = "Western Piano", 
        spriteNames = {
            {name = "recreational_01_8", direction = IsoDirections.S},
            {name = "recreational_01_9", direction = IsoDirections.S},
            {name = "recreational_01_12", direction = IsoDirections.E},
            {name = "recreational_01_13", direction = IsoDirections.E}
        }
    },
    {
        type = "Black Grand Piano", 
        spriteNames = {
            {name = "recreational_01_40", direction = IsoDirections.S},
            {name = "recreational_01_41", direction = IsoDirections.S},
            {name = "recreational_01_42", direction = IsoDirections.S},
            {name = "recreational_01_43", direction = IsoDirections.S},
            {name = "recreational_01_44", direction = IsoDirections.S},
            {name = "recreational_01_45", direction = IsoDirections.S},
            {name = "recreational_01_48", direction = IsoDirections.E},
            {name = "recreational_01_49", direction = IsoDirections.E},
            {name = "recreational_01_50", direction = IsoDirections.E},
            {name = "recreational_01_51", direction = IsoDirections.E},
            {name = "recreational_01_52", direction = IsoDirections.E},
            {name = "recreational_01_53", direction = IsoDirections.E}
        }
    },
    -- High style
    {
        type = "Standing Vault", 
        spriteNames = {
            {name = "location_business_bank_01_42", direction = IsoDirections.S},
            {name = "location_business_bank_01_43", direction = IsoDirections.E},
            {name = "location_business_bank_01_44", direction = IsoDirections.N},
            {name = "location_business_bank_01_45", direction = IsoDirections.W}
        }
    },
    -- Original direction non-existent
    {
        type = "Angelic Gravestone", 
        spriteNames = {
            {name = "location_community_cemetary_01_11", direction = IsoDirections.S}
        }
    },
    -- Not on the wiki list
    {
        type = "Cairn", 
        spriteNames = {
            {name = "location_community_cemetary_01_30", direction = IsoDirections.S}
        }
    },
    {
        type = "Lectern Stand", 
        spriteNames = {
            {name = "location_community_church_small_01_44", direction = IsoDirections.S},
            {name = "location_community_church_small_01_45", direction = IsoDirections.E},
            {name = "location_community_church_small_01_46", direction = IsoDirections.N},
            {name = "location_community_church_small_01_47", direction = IsoDirections.W}
        }
    },
    -- Not on the wiki list
    -- Original direction non-existent
    {
        type = "Large Fountain", 
        spriteNames = {
            {name = "location_community_park_01_41", direction = IsoDirections.S},
            {name = "location_community_park_01_45", direction = IsoDirections.E}
        }
    },
    {
        type = "Childrens Play Castle", 
        spriteNames = {
            {name = "location_community_park_01_50", direction = IsoDirections.S},
            {name = "location_community_park_01_51", direction = IsoDirections.N},
            {name = "location_community_park_01_52", direction = IsoDirections.E}
        }
    },
    {
        type = "Small Soda Machine", 
        spriteNames = {
            {name = "location_shop_accessories_01_18", direction = IsoDirections.E},
            {name = "location_shop_accessories_01_19", direction = IsoDirections.S},
            {name = "location_shop_accessories_01_30", direction = IsoDirections.E},
            {name = "location_shop_accessories_01_31", direction = IsoDirections.E}
        }
    },
    {
        type = "Oldies Jukebox", 
        spriteNames = {
            {name = "recreational_01_0", direction = IsoDirections.E},
            {name = "recreational_01_1", direction = IsoDirections.S}
        }
    },
    {
        type = "Pool Cue Stand", 
        spriteNames = {
            {name = "recreational_01_4", direction = IsoDirections.E},
            {name = "recreational_01_5", direction = IsoDirections.S}
        }
    },
    {
        type = "Security Wall Monitors", 
        spriteNames = {
            {name = "security_01_4", direction = IsoDirections.S},
            {name = "security_01_5", direction = IsoDirections.E}
        }
    },
    -- Not on the wiki list
    {
        type = "Large Animal Feeder", 
        spriteNames = {
            {name = "location_farm_accesories_01_4", direction = IsoDirections.E},
            {name = "location_farm_accesories_01_5", direction = IsoDirections.E},
            {name = "location_farm_accesories_01_6", direction = IsoDirections.S},
            {name = "location_farm_accesories_01_7", direction = IsoDirections.S}
        }
    },
    {
        type = "DogHouse", 
        spriteNames = {
            {name = "location_farm_accesories_01_8", direction = IsoDirections.E},
            {name = "location_farm_accesories_01_9", direction = IsoDirections.S},
            {name = "location_farm_accesories_01_10", direction = IsoDirections.W},
            {name = "location_farm_accesories_01_11", direction = IsoDirections.N}
        }
    },
    {
        type = "Small Animal Feeder", 
        spriteNames = {
            {name = "location_farm_accesories_01_14", direction = IsoDirections.E},
            {name = "location_farm_accesories_01_15", direction = IsoDirections.S}
        }
    },
    {
        type = "Large Metal Feeder With Roof", 
        spriteNames = {
            {name = "location_farm_accesories_01_16", direction = IsoDirections.S},
            {name = "location_farm_accesories_01_17", direction = IsoDirections.S},
            {name = "location_farm_accesories_01_19", direction = IsoDirections.E},
            {name = "location_farm_accesories_01_20", direction = IsoDirections.S},
            {name = "location_farm_accesories_01_22", direction = IsoDirections.E},
            {name = "location_farm_accesories_01_23", direction = IsoDirections.E}
        }
    },
    -- Reversal of directions required
    {
        type = "Long Cattle Feeder", 
        spriteNames = {
            {name = "location_farm_accesories_01_24", direction = IsoDirections.S},
            {name = "location_farm_accesories_01_25", direction = IsoDirections.S},
            {name = "location_farm_accesories_01_26", direction = IsoDirections.S},
            {name = "location_farm_accesories_01_27", direction = IsoDirections.E},
            {name = "location_farm_accesories_01_28", direction = IsoDirections.E},
            {name = "location_farm_accesories_01_29", direction = IsoDirections.E}
        }
    },
    -- Reversal of directions required
    {
        type = "Short Cattle Feeder", 
        spriteNames = {
            {name = "location_farm_accesories_01_32", direction = IsoDirections.S},
            {name = "location_farm_accesories_01_33", direction = IsoDirections.S},
            {name = "location_farm_accesories_01_34", direction = IsoDirections.E},
            {name = "location_farm_accesories_01_35", direction = IsoDirections.E}
        }
    },
    {
        type = "Chicken Coop", 
        spriteNames = {
            {name = "location_farm_accesories_01_42", direction = IsoDirections.E},
            {name = "location_farm_accesories_01_43", direction = IsoDirections.E},
            {name = "location_farm_accesories_01_48", direction = IsoDirections.S},
            {name = "location_farm_accesories_01_50", direction = IsoDirections.S},
            {name = "location_farm_accesories_01_51", direction = IsoDirections.S},
            {name = "location_farm_accesories_01_52", direction = IsoDirections.E},
            {name = "location_farm_accesories_01_54", direction = IsoDirections.E},
            {name = "location_farm_accesories_01_58", direction = IsoDirections.E},
            {name = "location_farm_accesories_01_59", direction = IsoDirections.E},
            {name = "location_farm_accesories_01_64", direction = IsoDirections.S},
            {name = "location_farm_accesories_01_66", direction = IsoDirections.S},
            {name = "location_farm_accesories_01_67", direction = IsoDirections.S},
            {name = "location_farm_accesories_01_68", direction = IsoDirections.E},
            {name = "location_farm_accesories_01_70", direction = IsoDirections.E}
        }
    },
    -- Not on the wiki list (Withdraw 41 + 42 + 44 + 47)
    {
        type = "Fitness Contraption", 
        spriteNames = {
            {name = "recreational_sports_01_40", direction = IsoDirections.S},
            {name = "recreational_sports_01_43", direction = IsoDirections.E},
            {name = "recreational_sports_01_45", direction = IsoDirections.N},
            {name = "recreational_sports_01_46", direction = IsoDirections.W}
        }
    },

    -- ****************************************************************
    -- Structural elements
    -- Wall
    {
        type = "Wall", 
        spriteNames = {
            -- Exterior Walls - House 01
            {name = "walls_exterior_house_01_0", direction = IsoDirections.W},
            {name = "walls_exterior_house_01_1", direction = IsoDirections.N},
            {name = "walls_exterior_house_01_2", direction = IsoDirections.W},
            {name = "walls_exterior_house_01_4", direction = IsoDirections.W},
            {name = "walls_exterior_house_01_5", direction = IsoDirections.N},
            {name = "walls_exterior_house_01_6", direction = IsoDirections.W},
            {name = "walls_exterior_house_01_16", direction = IsoDirections.W},
            {name = "walls_exterior_house_01_17", direction = IsoDirections.N},
            {name = "walls_exterior_house_01_18", direction = IsoDirections.W},
            {name = "walls_exterior_house_01_20", direction = IsoDirections.W},
            {name = "walls_exterior_house_01_21", direction = IsoDirections.N},
            {name = "walls_exterior_house_01_22", direction = IsoDirections.W},
            {name = "walls_exterior_house_01_32", direction = IsoDirections.W},
            {name = "walls_exterior_house_01_33", direction = IsoDirections.N},
            {name = "walls_exterior_house_01_34", direction = IsoDirections.W},
            {name = "walls_exterior_house_01_48", direction = IsoDirections.W},
            {name = "walls_exterior_house_01_49", direction = IsoDirections.N},
            {name = "walls_exterior_house_01_50", direction = IsoDirections.W},
            {name = "walls_exterior_house_01_52", direction = IsoDirections.W},
            {name = "walls_exterior_house_01_53", direction = IsoDirections.N},
            {name = "walls_exterior_house_01_54", direction = IsoDirections.W},

            -- Exterior Walls - House 02
            {name = "walls_exterior_house_02_0", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_1", direction = IsoDirections.N},
            {name = "walls_exterior_house_02_2", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_4", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_5", direction = IsoDirections.N},
            {name = "walls_exterior_house_02_6", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_16", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_17", direction = IsoDirections.N},
            {name = "walls_exterior_house_02_18", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_20", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_21", direction = IsoDirections.N},
            {name = "walls_exterior_house_02_22", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_32", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_33", direction = IsoDirections.N},
            {name = "walls_exterior_house_02_34", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_36", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_37", direction = IsoDirections.N},
            {name = "walls_exterior_house_02_38", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_48", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_49", direction = IsoDirections.N},
            {name = "walls_exterior_house_02_50", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_52", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_53", direction = IsoDirections.N},
            {name = "walls_exterior_house_02_54", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_64", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_65", direction = IsoDirections.N},
            {name = "walls_exterior_house_02_66", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_68", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_69", direction = IsoDirections.N},
            {name = "walls_exterior_house_02_70", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_80", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_81", direction = IsoDirections.N},
            {name = "walls_exterior_house_02_82", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_84", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_85", direction = IsoDirections.N},
            {name = "walls_exterior_house_02_86", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_96", direction = IsoDirections.W},
            {name = "walls_exterior_house_02_97", direction = IsoDirections.N},
            {name = "walls_exterior_house_02_98", direction = IsoDirections.W},

            -- Exterior Walls - Wooden 01
            {name = "walls_exterior_wooden_01_0", direction = IsoDirections.W},
            {name = "walls_exterior_wooden_01_1", direction = IsoDirections.N},
            {name = "walls_exterior_wooden_01_2", direction = IsoDirections.W},
            {name = "walls_exterior_wooden_01_24", direction = IsoDirections.W},
            {name = "walls_exterior_wooden_01_25", direction = IsoDirections.N},
            {name = "walls_exterior_wooden_01_26", direction = IsoDirections.W},
            {name = "walls_exterior_wooden_01_28", direction = IsoDirections.W},
            {name = "walls_exterior_wooden_01_29", direction = IsoDirections.N},
            {name = "walls_exterior_wooden_01_30", direction = IsoDirections.W},
            {name = "walls_exterior_wooden_01_40", direction = IsoDirections.W},
            {name = "walls_exterior_wooden_01_41", direction = IsoDirections.N},
            {name = "walls_exterior_wooden_01_42", direction = IsoDirections.W},
            {name = "walls_exterior_wooden_01_44", direction = IsoDirections.W},
            {name = "walls_exterior_wooden_01_45", direction = IsoDirections.N},
            {name = "walls_exterior_wooden_01_46", direction = IsoDirections.W},
            {name = "walls_exterior_wooden_01_64", direction = IsoDirections.W},
            {name = "walls_exterior_wooden_01_65", direction = IsoDirections.N},
            {name = "walls_exterior_wooden_01_66", direction = IsoDirections.W},
            {name = "walls_exterior_wooden_01_68", direction = IsoDirections.W},
            {name = "walls_exterior_wooden_01_69", direction = IsoDirections.N},
            {name = "walls_exterior_wooden_01_70", direction = IsoDirections.W},

            -- Exterior Walls - Wooden 02
            {name = "walls_exterior_wooden_02_0", direction = IsoDirections.W},
            {name = "walls_exterior_wooden_02_1", direction = IsoDirections.N},
            {name = "walls_exterior_wooden_02_2", direction = IsoDirections.W},

            -- Garage Walls
            {name = "walls_garage_01_32", direction = IsoDirections.W},
            {name = "walls_garage_01_33", direction = IsoDirections.N},
            {name = "walls_garage_01_34", direction = IsoDirections.W},
            {name = "walls_garage_01_36", direction = IsoDirections.W},
            {name = "walls_garage_01_37", direction = IsoDirections.N},
            {name = "walls_garage_01_38", direction = IsoDirections.W},
            {name = "walls_garage_02_16", direction = IsoDirections.W},
            {name = "walls_garage_02_17", direction = IsoDirections.N},
            {name = "walls_garage_02_18", direction = IsoDirections.W},

            -- Interior Walls - Bathroom
            {name = "walls_interior_bathroom_01_0", direction = IsoDirections.W},
            {name = "walls_interior_bathroom_01_1", direction = IsoDirections.N},
            {name = "walls_interior_bathroom_01_2", direction = IsoDirections.W},
            {name = "walls_interior_bathroom_01_4", direction = IsoDirections.W},
            {name = "walls_interior_bathroom_01_5", direction = IsoDirections.N},
            {name = "walls_interior_bathroom_01_6", direction = IsoDirections.W},
            {name = "walls_interior_bathroom_01_16", direction = IsoDirections.W},
            {name = "walls_interior_bathroom_01_17", direction = IsoDirections.N},
            {name = "walls_interior_bathroom_01_18", direction = IsoDirections.W},

            -- Interior Walls - House 01
            {name = "walls_interior_house_01_0", direction = IsoDirections.W},
            {name = "walls_interior_house_01_1", direction = IsoDirections.N},
            {name = "walls_interior_house_01_2", direction = IsoDirections.W},
            {name = "walls_interior_house_01_4", direction = IsoDirections.W},
            {name = "walls_interior_house_01_5", direction = IsoDirections.N},
            {name = "walls_interior_house_01_6", direction = IsoDirections.W},
            {name = "walls_interior_house_01_16", direction = IsoDirections.W},
            {name = "walls_interior_house_01_17", direction = IsoDirections.N},
            {name = "walls_interior_house_01_18", direction = IsoDirections.W},
            {name = "walls_interior_house_01_20", direction = IsoDirections.W},
            {name = "walls_interior_house_01_21", direction = IsoDirections.N},
            {name = "walls_interior_house_01_22", direction = IsoDirections.W},
            {name = "walls_interior_house_01_32", direction = IsoDirections.W},
            {name = "walls_interior_house_01_33", direction = IsoDirections.N},
            {name = "walls_interior_house_01_34", direction = IsoDirections.W},
            {name = "walls_interior_house_01_36", direction = IsoDirections.W},
            {name = "walls_interior_house_01_37", direction = IsoDirections.N},
            {name = "walls_interior_house_01_38", direction = IsoDirections.W},
            {name = "walls_interior_house_01_48", direction = IsoDirections.W},
            {name = "walls_interior_house_01_49", direction = IsoDirections.N},
            {name = "walls_interior_house_01_50", direction = IsoDirections.W},
            {name = "walls_interior_house_01_52", direction = IsoDirections.W},
            {name = "walls_interior_house_01_53", direction = IsoDirections.N},
            {name = "walls_interior_house_01_54", direction = IsoDirections.W},

            -- Interior Walls - House 02
            {name = "walls_interior_house_02_0", direction = IsoDirections.W},
            {name = "walls_interior_house_02_1", direction = IsoDirections.N},
            {name = "walls_interior_house_02_2", direction = IsoDirections.W},
            {name = "walls_interior_house_02_4", direction = IsoDirections.W},
            {name = "walls_interior_house_02_5", direction = IsoDirections.N},
            {name = "walls_interior_house_02_6", direction = IsoDirections.W},
            {name = "walls_interior_house_02_16", direction = IsoDirections.W},
            {name = "walls_interior_house_02_17", direction = IsoDirections.N},
            {name = "walls_interior_house_02_18", direction = IsoDirections.W},
            {name = "walls_interior_house_02_20", direction = IsoDirections.W},
            {name = "walls_interior_house_02_21", direction = IsoDirections.N},
            {name = "walls_interior_house_02_22", direction = IsoDirections.W},
            {name = "walls_interior_house_02_32", direction = IsoDirections.W},
            {name = "walls_interior_house_02_33", direction = IsoDirections.N},
            {name = "walls_interior_house_02_34", direction = IsoDirections.W},
            {name = "walls_interior_house_02_36", direction = IsoDirections.W},
            {name = "walls_interior_house_02_37", direction = IsoDirections.N},
            {name = "walls_interior_house_02_38", direction = IsoDirections.W},
            {name = "walls_interior_house_02_48", direction = IsoDirections.W},
            {name = "walls_interior_house_02_49", direction = IsoDirections.N},
            {name = "walls_interior_house_02_50", direction = IsoDirections.W},
            {name = "walls_interior_house_02_52", direction = IsoDirections.W},
            {name = "walls_interior_house_02_53", direction = IsoDirections.N},
            {name = "walls_interior_house_02_54", direction = IsoDirections.W},

            -- Interior Walls - House 03
            {name = "walls_interior_house_03_0", direction = IsoDirections.W},
            {name = "walls_interior_house_03_1", direction = IsoDirections.N},
            {name = "walls_interior_house_03_2", direction = IsoDirections.W},
            {name = "walls_interior_house_03_4", direction = IsoDirections.W},
            {name = "walls_interior_house_03_5", direction = IsoDirections.N},
            {name = "walls_interior_house_03_6", direction = IsoDirections.W},
            {name = "walls_interior_house_03_16", direction = IsoDirections.W},
            {name = "walls_interior_house_03_17", direction = IsoDirections.N},
            {name = "walls_interior_house_03_18", direction = IsoDirections.W},
            {name = "walls_interior_house_03_20", direction = IsoDirections.W},
            {name = "walls_interior_house_03_21", direction = IsoDirections.N},
            {name = "walls_interior_house_03_22", direction = IsoDirections.W},
            {name = "walls_interior_house_03_32", direction = IsoDirections.W},
            {name = "walls_interior_house_03_33", direction = IsoDirections.N},
            {name = "walls_interior_house_03_34", direction = IsoDirections.W},
            {name = "walls_interior_house_03_36", direction = IsoDirections.W},
            {name = "walls_interior_house_03_37", direction = IsoDirections.N},
            {name = "walls_interior_house_03_38", direction = IsoDirections.W},
            {name = "walls_interior_house_03_48", direction = IsoDirections.W},
            {name = "walls_interior_house_03_49", direction = IsoDirections.N},
            {name = "walls_interior_house_03_50", direction = IsoDirections.W},
            {name = "walls_interior_house_03_52", direction = IsoDirections.W},
            {name = "walls_interior_house_03_53", direction = IsoDirections.N},
            {name = "walls_interior_house_03_54", direction = IsoDirections.W},

            -- Interior Walls - House 04
            {name = "walls_interior_house_04_0", direction = IsoDirections.W},
            {name = "walls_interior_house_04_1", direction = IsoDirections.N},
            {name = "walls_interior_house_04_2", direction = IsoDirections.W},
            {name = "walls_interior_house_04_4", direction = IsoDirections.W},
            {name = "walls_interior_house_04_5", direction = IsoDirections.N},
            {name = "walls_interior_house_04_6", direction = IsoDirections.W},
            {name = "walls_interior_house_04_16", direction = IsoDirections.W},
            {name = "walls_interior_house_04_17", direction = IsoDirections.N},
            {name = "walls_interior_house_04_18", direction = IsoDirections.W},
            {name = "walls_interior_house_04_20", direction = IsoDirections.W},
            {name = "walls_interior_house_04_21", direction = IsoDirections.N},
            {name = "walls_interior_house_04_22", direction = IsoDirections.W},
            {name = "walls_interior_house_04_32", direction = IsoDirections.W},
            {name = "walls_interior_house_04_33", direction = IsoDirections.N},
            {name = "walls_interior_house_04_34", direction = IsoDirections.W},
            {name = "walls_interior_house_04_36", direction = IsoDirections.W},
            {name = "walls_interior_house_04_37", direction = IsoDirections.N},
            {name = "walls_interior_house_04_38", direction = IsoDirections.W},
            {name = "walls_interior_house_04_48", direction = IsoDirections.W},
            {name = "walls_interior_house_04_49", direction = IsoDirections.N},
            {name = "walls_interior_house_04_50", direction = IsoDirections.W},
            {name = "walls_interior_house_04_52", direction = IsoDirections.W},
            {name = "walls_interior_house_04_53", direction = IsoDirections.N},
            {name = "walls_interior_house_04_54", direction = IsoDirections.W},
            {name = "walls_interior_house_04_64", direction = IsoDirections.W},
            {name = "walls_interior_house_04_65", direction = IsoDirections.N},
            {name = "walls_interior_house_04_66", direction = IsoDirections.W},
            {name = "walls_interior_house_04_68", direction = IsoDirections.W},
            {name = "walls_interior_house_04_69", direction = IsoDirections.N},
            {name = "walls_interior_house_04_70", direction = IsoDirections.W},
            {name = "walls_interior_house_04_80", direction = IsoDirections.W},
            {name = "walls_interior_house_04_81", direction = IsoDirections.N},
            {name = "walls_interior_house_04_82", direction = IsoDirections.W},
            {name = "walls_interior_house_04_84", direction = IsoDirections.W},
            {name = "walls_interior_house_04_85", direction = IsoDirections.N},
            {name = "walls_interior_house_04_86", direction = IsoDirections.W},

            -- Police Walls
            {name = "location_community_police_01_0", direction = IsoDirections.W},
            {name = "location_community_police_01_1", direction = IsoDirections.N},
            {name = "location_community_police_01_2", direction = IsoDirections.W},

            -- School Walls
            {name = "location_community_school_01_0", direction = IsoDirections.W},
            {name = "location_community_school_01_1", direction = IsoDirections.N},
            {name = "location_community_school_01_2", direction = IsoDirections.W},

            -- SunstarMotel Walls
            {name = "location_hospitality_sunstarmotel_02_8", direction = IsoDirections.W},
            {name = "location_hospitality_sunstarmotel_02_9", direction = IsoDirections.N},
            {name = "location_hospitality_sunstarmotel_02_10", direction = IsoDirections.W},

            -- Diner Walls
            {name = "location_restaurant_diner_01_0", direction = IsoDirections.W},
            {name = "location_restaurant_diner_01_1", direction = IsoDirections.N},
            {name = "location_restaurant_diner_01_2", direction = IsoDirections.W},
            {name = "location_restaurant_diner_01_8", direction = IsoDirections.W},
            {name = "location_restaurant_diner_01_9", direction = IsoDirections.W},
            {name = "location_restaurant_diner_01_10", direction = IsoDirections.W},
            {name = "location_restaurant_diner_01_11", direction = IsoDirections.N},
            {name = "location_restaurant_diner_01_12", direction = IsoDirections.N},
            {name = "location_restaurant_diner_01_13", direction = IsoDirections.N},

            -- PileOCrepe Walls
            {name = "location_restaurant_pileocrepe_01_0", direction = IsoDirections.W},
            {name = "location_restaurant_pileocrepe_01_1", direction = IsoDirections.N},
            {name = "location_restaurant_pileocrepe_01_2", direction = IsoDirections.W},

            -- PizzaWhirled Walls
            {name = "location_restaurant_pizzawhirled_01_0", direction = IsoDirections.W},
            {name = "location_restaurant_pizzawhirled_01_1", direction = IsoDirections.N},
            {name = "location_restaurant_pizzawhirled_01_2", direction = IsoDirections.W},

            -- BargNClothes Walls
            {name = "location_shop_bargNclothes_01_24", direction = IsoDirections.W},
            {name = "location_shop_bargNclothes_01_25", direction = IsoDirections.N},
            {name = "location_shop_bargNclothes_01_26", direction = IsoDirections.W},

            -- Carpentry Walls
            {name = "carpentry_02_80", direction = IsoDirections.W},
            {name = "carpentry_02_81", direction = IsoDirections.N},
            {name = "carpentry_02_82", direction = IsoDirections.W},

            -- Medical Walls
            {name = "location_community_medical_01_168", direction = IsoDirections.W},
            {name = "location_community_medical_01_169", direction = IsoDirections.N},
            {name = "location_community_medical_01_170", direction = IsoDirections.W},

            -- Bar Walls
            {name = "location_restaurant_bar_01_44", direction = IsoDirections.W},
            {name = "location_restaurant_bar_01_45", direction = IsoDirections.N},
            {name = "location_restaurant_bar_01_46", direction = IsoDirections.W},			

            -- Logs Walls
            {name = "walls_logs_0", direction = IsoDirections.W},
            {name = "walls_logs_1", direction = IsoDirections.N},
            {name = "walls_logs_2", direction = IsoDirections.W},
            {name = "walls_logs_4", direction = IsoDirections.W},
            {name = "walls_logs_5", direction = IsoDirections.N},
            {name = "walls_logs_96", direction = IsoDirections.W},
            {name = "walls_logs_97", direction = IsoDirections.N},
            {name = "walls_logs_98", direction = IsoDirections.W},

            -- Industry Walls
            {name = "industry_01_0", direction = IsoDirections.W},
            {name = "industry_01_1", direction = IsoDirections.N},
            {name = "industry_01_2", direction = IsoDirections.W},

            -- Railroad Walls
            {name = "industry_railroad_05_8", direction = IsoDirections.W},
            {name = "industry_railroad_05_9", direction = IsoDirections.N},
            {name = "industry_railroad_05_10", direction = IsoDirections.W},
            {name = "industry_railroad_05_24", direction = IsoDirections.W},
            {name = "industry_railroad_05_25", direction = IsoDirections.N},
            {name = "industry_railroad_05_26", direction = IsoDirections.W},

            -- Truck Walls
            {name = "industry_trucks_01_0", direction = IsoDirections.W},
            {name = "industry_trucks_01_1", direction = IsoDirections.N},
            {name = "industry_trucks_01_2", direction = IsoDirections.W},
            {name = "industry_trucks_01_4", direction = IsoDirections.W},
            {name = "industry_trucks_01_5", direction = IsoDirections.N},
            {name = "industry_trucks_01_6", direction = IsoDirections.W},
            {name = "industry_trucks_01_48", direction = IsoDirections.W},
            {name = "industry_trucks_01_49", direction = IsoDirections.N},
            {name = "industry_trucks_01_50", direction = IsoDirections.W},

            -- Bank Walls
            {name = "location_business_bank_01_0", direction = IsoDirections.W},
            {name = "location_business_bank_01_1", direction = IsoDirections.N},
            {name = "location_business_bank_01_2", direction = IsoDirections.W},

            -- Restaurant Pie Walls
            {name = "location_restaurant_pie_01_0", direction = IsoDirections.W},
            {name = "location_restaurant_pie_01_1", direction = IsoDirections.N},
            {name = "location_restaurant_pie_01_2", direction = IsoDirections.W},

            -- Fossoil Walls
            {name = "location_shop_fossoil_01_0", direction = IsoDirections.N},
            {name = "location_shop_fossoil_01_2", direction = IsoDirections.W},
            {name = "location_shop_fossoil_01_4", direction = IsoDirections.W},
            {name = "location_shop_fossoil_01_5", direction = IsoDirections.N},
            {name = "location_shop_fossoil_01_6", direction = IsoDirections.W},

            -- Gas2Go Walls
            {name = "location_shop_gas2go_01_0", direction = IsoDirections.W},
            {name = "location_shop_gas2go_01_1", direction = IsoDirections.N},
            {name = "location_shop_gas2go_01_2", direction = IsoDirections.W},
            {name = "location_shop_gas2go_01_8", direction = IsoDirections.W},
            {name = "location_shop_gas2go_01_9", direction = IsoDirections.N},

            -- Mall Walls
            {name = "location_shop_mall_01_0", direction = IsoDirections.W},
            {name = "location_shop_mall_01_1", direction = IsoDirections.N},
            {name = "location_shop_mall_01_2", direction = IsoDirections.W},
            {name = "location_shop_mall_01_18", direction = IsoDirections.W},
            {name = "location_shop_mall_01_19", direction = IsoDirections.N},

            -- Barn Walls
            {name = "location_barn_01_0", direction = IsoDirections.W},
            {name = "location_barn_01_1", direction = IsoDirections.N},
            {name = "location_barn_01_2", direction = IsoDirections.W},

            -- Church Walls
            {name = "location_community_church_small_01_0", direction = IsoDirections.W},
            {name = "location_community_church_small_01_1", direction = IsoDirections.N},
            {name = "location_community_church_small_01_2", direction = IsoDirections.W},
            {name = "location_community_church_small_01_4", direction = IsoDirections.W},
            {name = "location_community_church_small_01_5", direction = IsoDirections.N},
            {name = "location_community_church_small_01_6", direction = IsoDirections.W},

            -- SunstarMotel Walls
            {name = "location_hospitality_sunstarmotel_01_0", direction = IsoDirections.W},
            {name = "location_hospitality_sunstarmotel_01_1", direction = IsoDirections.N},
            {name = "location_hospitality_sunstarmotel_01_2", direction = IsoDirections.W},
            {name = "location_hospitality_sunstarmotel_01_4", direction = IsoDirections.W},
            {name = "location_hospitality_sunstarmotel_01_5", direction = IsoDirections.N},
            {name = "location_hospitality_sunstarmotel_01_6", direction = IsoDirections.W},
            {name = "location_hospitality_sunstarmotel_01_24", direction = IsoDirections.W},
            {name = "location_hospitality_sunstarmotel_01_25", direction = IsoDirections.N},
            {name = "location_hospitality_sunstarmotel_01_26", direction = IsoDirections.W},

            -- Military Tent Walls
            {name = "location_military_tent_01_0", direction = IsoDirections.W},
            {name = "location_military_tent_01_1", direction = IsoDirections.N},
            {name = "location_military_tent_01_2", direction = IsoDirections.W},
            {name = "location_military_tent_01_64", direction = IsoDirections.W},
            {name = "location_military_tent_01_65", direction = IsoDirections.N},
            {name = "location_military_tent_01_66", direction = IsoDirections.W},

            -- Restaurant Seahorse Walls
            {name = "location_restaurant_seahorse_01_0", direction = IsoDirections.W},
            {name = "location_restaurant_seahorse_01_1", direction = IsoDirections.N},
            {name = "location_restaurant_seahorse_01_2", direction = IsoDirections.W},
            {name = "location_restaurant_seahorse_01_4", direction = IsoDirections.W},
            {name = "location_restaurant_seahorse_01_5", direction = IsoDirections.N},
            {name = "location_restaurant_seahorse_01_6", direction = IsoDirections.W},
            {name = "location_restaurant_seahorse_01_16", direction = IsoDirections.N},
            {name = "location_restaurant_seahorse_01_17", direction = IsoDirections.N},
            {name = "location_restaurant_seahorse_01_18", direction = IsoDirections.N},
            {name = "location_restaurant_seahorse_01_19", direction = IsoDirections.W},
            {name = "location_restaurant_seahorse_01_20", direction = IsoDirections.W},
            {name = "location_restaurant_seahorse_01_21", direction = IsoDirections.W},

            -- Restaurant Spiffos Walls
            {name = "location_restaurant_spiffos_01_0", direction = IsoDirections.W},
            {name = "location_restaurant_spiffos_01_1", direction = IsoDirections.N},
            {name = "location_restaurant_spiffos_01_4", direction = IsoDirections.W},
            {name = "location_restaurant_spiffos_01_5", direction = IsoDirections.W},
            {name = "location_restaurant_spiffos_01_6", direction = IsoDirections.W},
            {name = "location_restaurant_spiffos_01_7", direction = IsoDirections.W},
            {name = "location_restaurant_spiffos_01_8", direction = IsoDirections.W},
            {name = "location_restaurant_spiffos_01_9", direction = IsoDirections.N},
            {name = "location_restaurant_spiffos_01_12", direction = IsoDirections.W},
            {name = "location_restaurant_spiffos_01_13", direction = IsoDirections.W},
            {name = "location_restaurant_spiffos_01_14", direction = IsoDirections.W},
            {name = "location_restaurant_spiffos_01_15", direction = IsoDirections.W},
            {name = "location_restaurant_spiffos_01_16", direction = IsoDirections.N},
            {name = "location_restaurant_spiffos_01_17", direction = IsoDirections.N},
            {name = "location_restaurant_spiffos_01_18", direction = IsoDirections.N},
            {name = "location_restaurant_spiffos_01_19", direction = IsoDirections.N},
            {name = "location_restaurant_spiffos_01_20", direction = IsoDirections.N},
            {name = "location_restaurant_spiffos_01_21", direction = IsoDirections.N},
            {name = "location_restaurant_spiffos_01_40", direction = IsoDirections.W},
            {name = "location_restaurant_spiffos_01_41", direction = IsoDirections.N},
            {name = "location_restaurant_spiffos_01_42", direction = IsoDirections.W},

            -- Sewer Walls
            {name = "location_sewer_01_0", direction = IsoDirections.W},
            {name = "location_sewer_01_1", direction = IsoDirections.N},
            {name = "location_sewer_01_2", direction = IsoDirections.W},
            {name = "location_sewer_01_4", direction = IsoDirections.W},
            {name = "location_sewer_01_5", direction = IsoDirections.N},
            {name = "location_sewer_01_6", direction = IsoDirections.W},
            {name = "location_sewer_01_7", direction = IsoDirections.N},
            {name = "location_sewer_01_8", direction = IsoDirections.W},
            {name = "location_sewer_01_9", direction = IsoDirections.N},
            {name = "location_sewer_01_10", direction = IsoDirections.W},
            {name = "location_sewer_01_12", direction = IsoDirections.W},
            {name = "location_sewer_01_13", direction = IsoDirections.N},
            {name = "location_sewer_01_14", direction = IsoDirections.W},
            {name = "location_sewer_01_15", direction = IsoDirections.N},
            {name = "location_sewer_01_24", direction = IsoDirections.W},
            {name = "location_sewer_01_25", direction = IsoDirections.N},

            -- Shop Greenes Walls
            {name = "location_shop_greenes_01_0", direction = IsoDirections.W},
            {name = "location_shop_greenes_01_1", direction = IsoDirections.N},
            {name = "location_shop_greenes_01_2", direction = IsoDirections.W},
            {name = "location_shop_greenes_01_8", direction = IsoDirections.N},
            {name = "location_shop_greenes_01_9", direction = IsoDirections.W},
            {name = "location_shop_greenes_01_13", direction = IsoDirections.W},
            {name = "location_shop_greenes_01_14", direction = IsoDirections.N},
            {name = "location_shop_greenes_01_16", direction = IsoDirections.W},
            {name = "location_shop_greenes_01_17", direction = IsoDirections.W},
            {name = "location_shop_greenes_01_18", direction = IsoDirections.N},
            {name = "location_shop_greenes_01_19", direction = IsoDirections.N},

            -- Trailer Walls
            {name = "location_trailer_01_0", direction = IsoDirections.W},
            {name = "location_trailer_01_1", direction = IsoDirections.N},
            {name = "location_trailer_01_2", direction = IsoDirections.W},
            {name = "location_trailer_01_24", direction = IsoDirections.W},
            {name = "location_trailer_01_25", direction = IsoDirections.N},
            {name = "location_trailer_01_26", direction = IsoDirections.W},

            -- Commercial Walls
            {name = "walls_commercial_01_0", direction = IsoDirections.W},
            {name = "walls_commercial_01_1", direction = IsoDirections.N},
            {name = "walls_commercial_01_16", direction = IsoDirections.W},
            {name = "walls_commercial_01_17", direction = IsoDirections.N},
            {name = "walls_commercial_01_18", direction = IsoDirections.W},
            {name = "walls_commercial_01_32", direction = IsoDirections.W},
            {name = "walls_commercial_01_33", direction = IsoDirections.N},
            {name = "walls_commercial_01_34", direction = IsoDirections.W},
            {name = "walls_commercial_01_40", direction = IsoDirections.W},
            {name = "walls_commercial_01_41", direction = IsoDirections.N},
            {name = "walls_commercial_01_48", direction = IsoDirections.W},
            {name = "walls_commercial_01_49", direction = IsoDirections.N},
            {name = "walls_commercial_01_50", direction = IsoDirections.W},
            {name = "walls_commercial_01_64", direction = IsoDirections.W},
            {name = "walls_commercial_01_65", direction = IsoDirections.N},
            {name = "walls_commercial_01_66", direction = IsoDirections.W},
            {name = "walls_commercial_01_80", direction = IsoDirections.W},
            {name = "walls_commercial_01_81", direction = IsoDirections.N},
            {name = "walls_commercial_01_82", direction = IsoDirections.W},
            {name = "walls_commercial_01_96", direction = IsoDirections.W},
            {name = "walls_commercial_01_97", direction = IsoDirections.N},
            {name = "walls_commercial_01_98", direction = IsoDirections.W},
            {name = "walls_commercial_01_112", direction = IsoDirections.W},
            {name = "walls_commercial_01_113", direction = IsoDirections.N},
            {name = "walls_commercial_01_114", direction = IsoDirections.W},
            {name = "walls_commercial_02_0", direction = IsoDirections.W},
            {name = "walls_commercial_02_1", direction = IsoDirections.N},
            {name = "walls_commercial_02_2", direction = IsoDirections.W},
            {name = "walls_commercial_02_8", direction = IsoDirections.W},
            {name = "walls_commercial_02_9", direction = IsoDirections.N},
            {name = "walls_commercial_02_10", direction = IsoDirections.W},
            {name = "walls_commercial_02_48", direction = IsoDirections.N},
            {name = "walls_commercial_02_49", direction = IsoDirections.N},
            {name = "walls_commercial_02_50", direction = IsoDirections.N},
            {name = "walls_commercial_02_51", direction = IsoDirections.W},
            {name = "walls_commercial_02_52", direction = IsoDirections.W},
            {name = "walls_commercial_02_53", direction = IsoDirections.W},
            {name = "walls_commercial_02_54", direction = IsoDirections.N},
            {name = "walls_commercial_02_55", direction = IsoDirections.W},
            {name = "walls_commercial_03_0", direction = IsoDirections.W},
            {name = "walls_commercial_03_1", direction = IsoDirections.N},
            {name = "walls_commercial_03_2", direction = IsoDirections.W},
            {name = "walls_commercial_03_16", direction = IsoDirections.W},
            {name = "walls_commercial_03_17", direction = IsoDirections.N},
            {name = "walls_commercial_03_18", direction = IsoDirections.W},
            {name = "walls_commercial_03_32", direction = IsoDirections.W},
            {name = "walls_commercial_03_33", direction = IsoDirections.N},
            {name = "walls_commercial_03_34", direction = IsoDirections.W},
            {name = "walls_commercial_03_48", direction = IsoDirections.W},
            {name = "walls_commercial_03_49", direction = IsoDirections.N},
            {name = "walls_commercial_03_50", direction = IsoDirections.W}
        }
    },
    -- Door
    {
        type = "Door", 
        spriteNames = {
            -- Regular doors
            {name = "fixtures_doors_01_0", direction = IsoDirections.E},
            {name = "fixtures_doors_01_1", direction = IsoDirections.S},
            {name = "fixtures_doors_01_4", direction = IsoDirections.E},
            {name = "fixtures_doors_01_5", direction = IsoDirections.S},
            {name = "fixtures_doors_01_8", direction = IsoDirections.E},
            {name = "fixtures_doors_01_9", direction = IsoDirections.S},
            {name = "fixtures_doors_01_12", direction = IsoDirections.E},
            {name = "fixtures_doors_01_13", direction = IsoDirections.S},
            {name = "fixtures_doors_01_16", direction = IsoDirections.E},
            {name = "fixtures_doors_01_17", direction = IsoDirections.S},
            {name = "fixtures_doors_01_20", direction = IsoDirections.E},
            {name = "fixtures_doors_01_21", direction = IsoDirections.S},
            {name = "fixtures_doors_01_24", direction = IsoDirections.E},
            {name = "fixtures_doors_01_25", direction = IsoDirections.S},
            {name = "fixtures_doors_01_28", direction = IsoDirections.E},
            {name = "fixtures_doors_01_29", direction = IsoDirections.S},
            {name = "fixtures_doors_01_32", direction = IsoDirections.E},
            {name = "fixtures_doors_01_33", direction = IsoDirections.S},
            {name = "fixtures_doors_01_36", direction = IsoDirections.E},
            {name = "fixtures_doors_01_37", direction = IsoDirections.S},
            {name = "fixtures_doors_01_40", direction = IsoDirections.E},
            {name = "fixtures_doors_01_41", direction = IsoDirections.S},
            {name = "fixtures_doors_01_44", direction = IsoDirections.E},
            {name = "fixtures_doors_01_45", direction = IsoDirections.S},
            {name = "fixtures_doors_01_48", direction = IsoDirections.E},
            {name = "fixtures_doors_01_49", direction = IsoDirections.S},
            {name = "fixtures_doors_01_52", direction = IsoDirections.E},
            {name = "fixtures_doors_01_53", direction = IsoDirections.S},
            {name = "fixtures_doors_01_56", direction = IsoDirections.E},
            {name = "fixtures_doors_01_57", direction = IsoDirections.S},
            {name = "fixtures_doors_01_60", direction = IsoDirections.E},
            {name = "fixtures_doors_01_61", direction = IsoDirections.S},
            {name = "fixtures_doors_01_64", direction = IsoDirections.E},
            {name = "fixtures_doors_01_65", direction = IsoDirections.S},
            {name = "fixtures_doors_01_68", direction = IsoDirections.E},
            {name = "fixtures_doors_01_69", direction = IsoDirections.S},
            {name = "location_restaurant_spiffos_01_52", direction = IsoDirections.E},
            {name = "location_restaurant_spiffos_01_53", direction = IsoDirections.S},
            {name = "location_restaurant_pileocrepe_01_48", direction = IsoDirections.E},
            {name = "location_restaurant_pileocrepe_01_49", direction = IsoDirections.S},
            {name = "location_restaurant_pileocrepe_01_52", direction = IsoDirections.E},
            {name = "location_restaurant_pileocrepe_01_53", direction = IsoDirections.S},
            {name = "location_restaurant_pizzawhirled_01_60", direction = IsoDirections.E},
            {name = "location_restaurant_pizzawhirled_01_61", direction = IsoDirections.S},
            {name = "carpentry_01_48", direction = IsoDirections.E},
            {name = "carpentry_01_49", direction = IsoDirections.S},
            {name = "carpentry_01_52", direction = IsoDirections.E},
            {name = "carpentry_01_53", direction = IsoDirections.S},
            {name = "carpentry_01_56", direction = IsoDirections.E},
            {name = "carpentry_01_57", direction = IsoDirections.S},
            {name = "fixtures_bathroom_01_48", direction = IsoDirections.E},
            {name = "fixtures_bathroom_01_49", direction = IsoDirections.S},
            {name = "fixtures_bathroom_01_64", direction = IsoDirections.E},
            {name = "fixtures_bathroom_01_65", direction = IsoDirections.S},
            {name = "fixtures_bathroom_02_16", direction = IsoDirections.E},
            {name = "fixtures_bathroom_02_17", direction = IsoDirections.S},
            {name = "fixtures_bathroom_02_32", direction = IsoDirections.E},
            {name = "fixtures_bathroom_02_33", direction = IsoDirections.S},
            {name = "location_community_church_small_01_24", direction = IsoDirections.E},
            {name = "location_community_church_small_01_25", direction = IsoDirections.S},
            {name = "location_community_church_small_01_28", direction = IsoDirections.E},
            {name = "location_community_church_small_01_29", direction = IsoDirections.S},
            {name = "location_community_church_small_01_64", direction = IsoDirections.E},
            {name = "location_community_church_small_01_65", direction = IsoDirections.S},
            {name = "location_community_church_small_01_68", direction = IsoDirections.E},
            {name = "location_community_church_small_01_69", direction = IsoDirections.S},

            -- Glass doors
            {name = "fixtures_doors_01_104", direction = IsoDirections.E},
            {name = "fixtures_doors_01_105", direction = IsoDirections.S},
            {name = "fixtures_doors_01_106", direction = IsoDirections.E},
            {name = "fixtures_doors_01_107", direction = IsoDirections.S},
            {name = "fixtures_doors_01_108", direction = IsoDirections.E},
            {name = "fixtures_doors_01_109", direction = IsoDirections.S},
            {name = "fixtures_doors_01_112", direction = IsoDirections.E},
            {name = "fixtures_doors_01_113", direction = IsoDirections.S},
            {name = "fixtures_doors_01_114", direction = IsoDirections.E},
            {name = "fixtures_doors_01_115", direction = IsoDirections.S},
            {name = "fixtures_doors_01_116", direction = IsoDirections.E},
            {name = "fixtures_doors_01_117", direction = IsoDirections.S},
            {name = "location_restaurant_spiffos_01_48", direction = IsoDirections.E},
            {name = "location_restaurant_spiffos_01_49", direction = IsoDirections.S},
            {name = "location_restaurant_pizzawhirled_01_56", direction = IsoDirections.E},
            {name = "location_restaurant_pizzawhirled_01_57", direction = IsoDirections.S},
            {name = "location_shop_fossoil_01_60", direction = IsoDirections.E},
            {name = "location_shop_fossoil_01_61", direction = IsoDirections.S},
            {name = "location_shop_gas2go_01_60", direction = IsoDirections.E},
            {name = "location_shop_gas2go_01_61", direction = IsoDirections.S},
            {name = "location_restaurant_seahorse_01_48", direction = IsoDirections.E},
            {name = "location_restaurant_seahorse_01_49", direction = IsoDirections.S},

            -- Security doors
            {name = "fixtures_doors_02_0", direction = IsoDirections.E},
            {name = "fixtures_doors_02_1", direction = IsoDirections.S},
            {name = "fixtures_doors_02_4", direction = IsoDirections.E},
            {name = "fixtures_doors_02_5", direction = IsoDirections.S},
            {name = "fixtures_doors_02_8", direction = IsoDirections.E},
            {name = "fixtures_doors_02_9", direction = IsoDirections.S},
            {name = "fixtures_doors_02_12", direction = IsoDirections.E},
            {name = "fixtures_doors_02_13", direction = IsoDirections.S},
            {name = "fixtures_doors_02_16", direction = IsoDirections.E},
            {name = "fixtures_doors_02_17", direction = IsoDirections.S},
            {name = "fixtures_doors_02_20", direction = IsoDirections.E},
            {name = "fixtures_doors_02_21", direction = IsoDirections.S},
            {name = "fixtures_doors_02_24", direction = IsoDirections.E},
            {name = "fixtures_doors_02_25", direction = IsoDirections.S},
            {name = "location_community_police_01_4", direction = IsoDirections.E},
            {name = "location_community_police_01_5", direction = IsoDirections.S},

            -- Garage doors
            {name = "fixtures_doors_garage_01_0", direction = IsoDirections.W},
            {name = "fixtures_doors_garage_01_1", direction = IsoDirections.N},
            {name = "fixtures_doors_garage_01_2", direction = IsoDirections.W},
            {name = "fixtures_doors_garage_01_3", direction = IsoDirections.N},
            {name = "walls_garage_01_0", direction = IsoDirections.W},
            {name = "walls_garage_01_1", direction = IsoDirections.W},
            {name = "walls_garage_01_2", direction = IsoDirections.W},
            {name = "walls_garage_01_3", direction = IsoDirections.N},
            {name = "walls_garage_01_4", direction = IsoDirections.N},
            {name = "walls_garage_01_5", direction = IsoDirections.N},
            {name = "walls_garage_01_16", direction = IsoDirections.W},
            {name = "walls_garage_01_17", direction = IsoDirections.W},
            {name = "walls_garage_01_18", direction = IsoDirections.W},
            {name = "walls_garage_01_19", direction = IsoDirections.N},
            {name = "walls_garage_01_20", direction = IsoDirections.N},
            {name = "walls_garage_01_21", direction = IsoDirections.N},
            {name = "walls_garage_01_32", direction = IsoDirections.W},
            {name = "walls_garage_01_33", direction = IsoDirections.N},
            {name = "walls_garage_01_34", direction = IsoDirections.W},
            {name = "walls_garage_01_36", direction = IsoDirections.W},
            {name = "walls_garage_01_37", direction = IsoDirections.N},
            {name = "walls_garage_01_38", direction = IsoDirections.W},
            {name = "walls_garage_01_48", direction = IsoDirections.W},
            {name = "walls_garage_01_49", direction = IsoDirections.W},
            {name = "walls_garage_01_50", direction = IsoDirections.W},
            {name = "walls_garage_01_51", direction = IsoDirections.N},
            {name = "walls_garage_01_52", direction = IsoDirections.N},
            {name = "walls_garage_01_53", direction = IsoDirections.N},
            {name = "walls_garage_02_0", direction = IsoDirections.W},
            {name = "walls_garage_02_1", direction = IsoDirections.W},
            {name = "walls_garage_02_2", direction = IsoDirections.W},
            {name = "walls_garage_02_3", direction = IsoDirections.N},
            {name = "walls_garage_02_4", direction = IsoDirections.N},
            {name = "walls_garage_02_5", direction = IsoDirections.N},
            {name = "walls_garage_02_16", direction = IsoDirections.W},
            {name = "walls_garage_02_17", direction = IsoDirections.N},
            {name = "walls_garage_02_32", direction = IsoDirections.W},
            {name = "walls_garage_02_33", direction = IsoDirections.N},
            {name = "walls_garage_02_35", direction = IsoDirections.N},
            {name = "walls_garage_02_36", direction = IsoDirections.W},
            {name = "walls_garage_02_37", direction = IsoDirections.N},
            {name = "walls_garage_02_48", direction = IsoDirections.W},
            {name = "walls_garage_02_49", direction = IsoDirections.W},
            {name = "walls_garage_02_50", direction = IsoDirections.W},
            {name = "walls_garage_02_51", direction = IsoDirections.N},
            {name = "walls_garage_02_52", direction = IsoDirections.N},
            {name = "walls_garage_02_53", direction = IsoDirections.N},
            {name = "industry_trucks_01_32", direction = IsoDirections.W},
            {name = "industry_trucks_01_33", direction = IsoDirections.W},
            {name = "industry_trucks_01_34", direction = IsoDirections.W},
            {name = "industry_trucks_01_35", direction = IsoDirections.N},
            {name = "industry_trucks_01_36", direction = IsoDirections.N},
            {name = "industry_trucks_01_37", direction = IsoDirections.N}
        }
    },
    -- Open Door
    -- location_community_church_small_01 30 + 31 + 70 + 31 HitBox problem ?
    {
        type = "Open Door", 
        spriteNames = {
            -- Regular open doors
            {name = "fixtures_doors_01_2", direction = IsoDirections.S},
            {name = "fixtures_doors_01_3", direction = IsoDirections.E},
            {name = "fixtures_doors_01_6", direction = IsoDirections.S},
            {name = "fixtures_doors_01_7", direction = IsoDirections.E},
            {name = "fixtures_doors_01_10", direction = IsoDirections.S},
            {name = "fixtures_doors_01_11", direction = IsoDirections.E},
            {name = "fixtures_doors_01_14", direction = IsoDirections.S},
            {name = "fixtures_doors_01_15", direction = IsoDirections.E},
            {name = "fixtures_doors_01_18", direction = IsoDirections.S},
            {name = "fixtures_doors_01_19", direction = IsoDirections.E},
            {name = "fixtures_doors_01_22", direction = IsoDirections.S},
            {name = "fixtures_doors_01_23", direction = IsoDirections.E},
            {name = "fixtures_doors_01_26", direction = IsoDirections.S},
            {name = "fixtures_doors_01_27", direction = IsoDirections.E},
            {name = "fixtures_doors_01_30", direction = IsoDirections.S},
            {name = "fixtures_doors_01_31", direction = IsoDirections.E},
            {name = "fixtures_doors_01_34", direction = IsoDirections.S},
            {name = "fixtures_doors_01_35", direction = IsoDirections.E},
            {name = "fixtures_doors_01_38", direction = IsoDirections.S},
            {name = "fixtures_doors_01_39", direction = IsoDirections.E},
            {name = "fixtures_doors_01_42", direction = IsoDirections.S},
            {name = "fixtures_doors_01_43", direction = IsoDirections.E},
            {name = "fixtures_doors_01_46", direction = IsoDirections.S},
            {name = "fixtures_doors_01_47", direction = IsoDirections.E},
            {name = "fixtures_doors_01_50", direction = IsoDirections.S},
            {name = "fixtures_doors_01_51", direction = IsoDirections.E},
            {name = "fixtures_doors_01_54", direction = IsoDirections.S},
            {name = "fixtures_doors_01_55", direction = IsoDirections.E},
            {name = "fixtures_doors_01_58", direction = IsoDirections.S},
            {name = "fixtures_doors_01_59", direction = IsoDirections.E},
            {name = "fixtures_doors_01_62", direction = IsoDirections.S},
            {name = "fixtures_doors_01_63", direction = IsoDirections.E},
            {name = "fixtures_doors_01_66", direction = IsoDirections.S},
            {name = "fixtures_doors_01_67", direction = IsoDirections.E},
            {name = "fixtures_doors_01_70", direction = IsoDirections.S},
            {name = "fixtures_doors_01_71", direction = IsoDirections.E},
            {name = "location_restaurant_spiffos_01_54", direction = IsoDirections.S},
            {name = "location_restaurant_spiffos_01_55", direction = IsoDirections.E},
            {name = "location_restaurant_pileocrepe_01_50", direction = IsoDirections.S},
            {name = "location_restaurant_pileocrepe_01_51", direction = IsoDirections.E},
            {name = "location_restaurant_pileocrepe_01_54", direction = IsoDirections.S},
            {name = "location_restaurant_pileocrepe_01_55", direction = IsoDirections.E},
            {name = "location_restaurant_pizzawhirled_01_62", direction = IsoDirections.S},
            {name = "location_restaurant_pizzawhirled_01_63", direction = IsoDirections.E},
            {name = "carpentry_01_50", direction = IsoDirections.S},
            {name = "carpentry_01_51", direction = IsoDirections.E},
            {name = "carpentry_01_54", direction = IsoDirections.S},
            {name = "carpentry_01_55", direction = IsoDirections.E},
            {name = "carpentry_01_58", direction = IsoDirections.S},
            {name = "carpentry_01_59", direction = IsoDirections.E},
            {name = "fixtures_bathroom_01_50", direction = IsoDirections.S},
            {name = "fixtures_bathroom_01_51", direction = IsoDirections.E},
            {name = "fixtures_bathroom_01_66", direction = IsoDirections.S},
            {name = "fixtures_bathroom_01_67", direction = IsoDirections.E},
            {name = "fixtures_bathroom_02_18", direction = IsoDirections.S},
            {name = "fixtures_bathroom_02_19", direction = IsoDirections.E},
            {name = "fixtures_bathroom_02_34", direction = IsoDirections.S},
            {name = "fixtures_bathroom_02_35", direction = IsoDirections.E},
            {name = "location_community_church_small_01_26", direction = IsoDirections.S},
            {name = "location_community_church_small_01_27", direction = IsoDirections.E},
            {name = "location_community_church_small_01_30", direction = IsoDirections.S},
            {name = "location_community_church_small_01_31", direction = IsoDirections.E},
            {name = "location_community_church_small_01_66", direction = IsoDirections.S},
            {name = "location_community_church_small_01_67", direction = IsoDirections.E},
            {name = "location_community_church_small_01_70", direction = IsoDirections.S},
            {name = "location_community_church_small_01_71", direction = IsoDirections.E},

            -- Glass open doors
            {name = "location_restaurant_spiffos_01_50", direction = IsoDirections.S},
            {name = "location_restaurant_spiffos_01_51", direction = IsoDirections.E},
            {name = "location_restaurant_pizzawhirled_01_58", direction = IsoDirections.S},
            {name = "location_restaurant_pizzawhirled_01_59", direction = IsoDirections.E},
            {name = "location_shop_fossoil_01_62", direction = IsoDirections.S},
            {name = "location_shop_fossoil_01_63", direction = IsoDirections.E},
            {name = "location_shop_gas2go_01_62", direction = IsoDirections.S},
            {name = "location_shop_gas2go_01_63", direction = IsoDirections.E},
            {name = "location_restaurant_seahorse_01_50", direction = IsoDirections.S},
            {name = "location_restaurant_seahorse_01_51", direction = IsoDirections.E},

            -- Security open doors
            {name = "fixtures_doors_02_2", direction = IsoDirections.S},
            {name = "fixtures_doors_02_3", direction = IsoDirections.E},
            {name = "fixtures_doors_02_6", direction = IsoDirections.S},
            {name = "fixtures_doors_02_7", direction = IsoDirections.E},
            {name = "fixtures_doors_02_10", direction = IsoDirections.S},
            {name = "fixtures_doors_02_11", direction = IsoDirections.E},
            {name = "fixtures_doors_02_14", direction = IsoDirections.S},
            {name = "fixtures_doors_02_15", direction = IsoDirections.E},
            {name = "fixtures_doors_02_18", direction = IsoDirections.S},
            {name = "fixtures_doors_02_19", direction = IsoDirections.E},
            {name = "fixtures_doors_02_22", direction = IsoDirections.S},
            {name = "fixtures_doors_02_23", direction = IsoDirections.E},
            {name = "fixtures_doors_02_26", direction = IsoDirections.S},
            {name = "fixtures_doors_02_27", direction = IsoDirections.E},
            {name = "location_community_police_01_6", direction = IsoDirections.S},
            {name = "location_community_police_01_7", direction = IsoDirections.E}
        }
    },
    -- Fence
    {
        type = "Fence", 
        spriteNames = {
            -- Standard Fences
            {name = "fencing_01_1", direction = IsoDirections.N},
            {name = "fencing_01_2", direction = IsoDirections.W},
            {name = "fencing_01_4", direction = IsoDirections.W},
            {name = "fencing_01_5", direction = IsoDirections.N},
            {name = "fencing_01_11", direction = IsoDirections.W},
            {name = "fencing_01_16", direction = IsoDirections.W},
            {name = "fencing_01_17", direction = IsoDirections.N},
            {name = "fencing_01_20", direction = IsoDirections.W},
            {name = "fencing_01_21", direction = IsoDirections.N},
            {name = "fencing_01_24", direction = IsoDirections.N},
            {name = "fencing_01_25", direction = IsoDirections.N},
            {name = "fencing_01_26", direction = IsoDirections.W},
            {name = "fencing_01_27", direction = IsoDirections.W},
            {name = "fencing_01_32", direction = IsoDirections.N},
            {name = "fencing_01_33", direction = IsoDirections.N},
            {name = "fencing_01_34", direction = IsoDirections.W},
            {name = "fencing_01_35", direction = IsoDirections.W},
            {name = "fencing_01_40", direction = IsoDirections.N},
            {name = "fencing_01_41", direction = IsoDirections.N},
            {name = "fencing_01_42", direction = IsoDirections.W},
            {name = "fencing_01_43", direction = IsoDirections.W},
            {name = "fencing_01_48", direction = IsoDirections.N},
            {name = "fencing_01_49", direction = IsoDirections.N},
            {name = "fencing_01_50", direction = IsoDirections.W},
            {name = "fencing_01_51", direction = IsoDirections.W},
            {name = "fencing_01_59", direction = IsoDirections.W},

            -- Damaged Fences 01
            {name = "fencing_damaged_01_0", direction = IsoDirections.N},
            {name = "fencing_damaged_01_2", direction = IsoDirections.N},
            {name = "fencing_damaged_01_3", direction = IsoDirections.W},
            {name = "fencing_damaged_01_5", direction = IsoDirections.W},
            {name = "fencing_damaged_01_8", direction = IsoDirections.N},
            {name = "fencing_damaged_01_10", direction = IsoDirections.N},
            {name = "fencing_damaged_01_11", direction = IsoDirections.W},
            {name = "fencing_damaged_01_13", direction = IsoDirections.W},
            {name = "fencing_damaged_01_16", direction = IsoDirections.N},
            {name = "fencing_damaged_01_18", direction = IsoDirections.N},
            {name = "fencing_damaged_01_19", direction = IsoDirections.W},
            {name = "fencing_damaged_01_21", direction = IsoDirections.W},
            {name = "fencing_damaged_01_24", direction = IsoDirections.N},
            {name = "fencing_damaged_01_26", direction = IsoDirections.N},

            -- Damaged Fences 02
            {name = "fencing_damaged_02_0", direction = IsoDirections.N},
            {name = "fencing_damaged_02_1", direction = IsoDirections.N},
            {name = "fencing_damaged_02_2", direction = IsoDirections.W},
            {name = "fencing_damaged_02_3", direction = IsoDirections.W},
            {name = "fencing_damaged_02_8", direction = IsoDirections.N},
            {name = "fencing_damaged_02_9", direction = IsoDirections.N},
            {name = "fencing_damaged_02_10", direction = IsoDirections.W},
            {name = "fencing_damaged_02_11", direction = IsoDirections.W},
            {name = "fencing_damaged_02_16", direction = IsoDirections.N},
            {name = "fencing_damaged_02_17", direction = IsoDirections.N},
            {name = "fencing_damaged_02_18", direction = IsoDirections.W},
            {name = "fencing_damaged_02_19", direction = IsoDirections.W},

            -- Damaged Fences 03
            {name = "fencing_damaged_03_0", direction = IsoDirections.N},
            {name = "fencing_damaged_03_1", direction = IsoDirections.N},
            {name = "fencing_damaged_03_2", direction = IsoDirections.W},
            {name = "fencing_damaged_03_3", direction = IsoDirections.W},
            {name = "fencing_damaged_03_8", direction = IsoDirections.N},
            {name = "fencing_damaged_03_9", direction = IsoDirections.N},
            {name = "fencing_damaged_03_10", direction = IsoDirections.W},
            {name = "fencing_damaged_03_11", direction = IsoDirections.W},
            {name = "fencing_damaged_03_16", direction = IsoDirections.N},
            {name = "fencing_damaged_03_17", direction = IsoDirections.N},
            {name = "fencing_damaged_03_18", direction = IsoDirections.W},
            {name = "fencing_damaged_03_19", direction = IsoDirections.W}
        }
    },
    -- High Fence
    {
        type = "High Fence", 
        spriteNames = {
            {name = "fencing_01_8", direction = IsoDirections.N},
            {name = "fencing_01_9", direction = IsoDirections.N},
            {name = "fencing_01_10", direction = IsoDirections.W},
            {name = "fencing_01_56", direction = IsoDirections.N},
            {name = "fencing_01_57", direction = IsoDirections.N},
            {name = "fencing_01_58", direction = IsoDirections.W},
            {name = "fencing_01_66", direction = IsoDirections.W},
            {name = "fencing_01_67", direction = IsoDirections.W},
            {name = "fencing_01_73", direction = IsoDirections.N},
            {name = "fencing_01_88", direction = IsoDirections.N},
            {name = "fencing_01_89", direction = IsoDirections.N}
        }
    },
    -- Low Fence Door
    {
        type = "Low Fence Door", 
        spriteNames = {
            {name = "fixtures_doors_fences_01_0", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_1", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_4", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_5", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_8", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_9", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_16", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_17", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_28", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_29", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_112", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_113", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_114", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_115", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_120", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_121", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_122", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_123", direction = IsoDirections.S}
        }
    },
    -- Open Low Fence Door
    {
        type = "Open Low Fence Door", 
        spriteNames = {
            {name = "fixtures_doors_fences_01_2", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_3", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_6", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_7", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_10", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_11", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_18", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_19", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_30", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_31", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_116", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_117", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_118", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_119", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_124", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_125", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_126", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_127", direction = IsoDirections.E}
        }
    },
    -- High Fence Door
    {
        type = "High Fence Door", 
        spriteNames = {
            {name = "fixtures_doors_fences_01_12", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_13", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_20", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_21", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_24", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_25", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_32", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_33", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_34", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_35", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_40", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_41", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_42", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_43", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_48", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_49", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_50", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_51", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_56", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_57", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_58", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_59", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_64", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_65", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_66", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_67", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_72", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_73", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_74", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_75", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_80", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_81", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_82", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_83", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_88", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_89", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_90", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_91", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_96", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_97", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_98", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_99", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_104", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_105", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_106", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_107", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_128", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_129", direction = IsoDirections.S}
        }
    },
    -- Open High Fence Door
    {
        type = "Open High Fence Door", 
        spriteNames = {
            {name = "fixtures_doors_fences_01_14", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_15", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_22", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_23", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_26", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_27", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_36", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_37", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_38", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_39", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_44", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_45", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_46", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_47", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_52", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_53", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_54", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_55", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_68", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_69", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_70", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_71", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_84", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_85", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_86", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_87", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_100", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_101", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_102", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_103", direction = IsoDirections.E},
            {name = "fixtures_doors_fences_01_130", direction = IsoDirections.S},
            {name = "fixtures_doors_fences_01_131", direction = IsoDirections.E}
        }
    },
    -- Stairs
    {
        type = "Stairs", 
        spriteNames = {
            -- Wooden Stairs (direction W)
            {name = "fixtures_stairs_01_0", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_1", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_2", direction = IsoDirections.W},
            -- Metal Stairs (direction W)
            {name = "fixtures_stairs_01_3", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_4", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_5", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_80", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_81", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_82", direction = IsoDirections.W},
            -- Solid Wooden Stairs (direction W)
            {name = "fixtures_stairs_01_16", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_17", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_18", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_19", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_20", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_21", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_32", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_33", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_34", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_48", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_49", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_50", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_64", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_65", direction = IsoDirections.W},
            {name = "fixtures_stairs_01_66", direction = IsoDirections.W},

            -- Wooden Stairs (direction N)
            {name = "fixtures_stairs_01_8", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_9", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_10", direction = IsoDirections.N},
            -- Metal Stairs (direction N)
            {name = "fixtures_stairs_01_11", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_12", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_13", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_88", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_89", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_90", direction = IsoDirections.N},
            -- Solid Wooden Stairs (direction N)
            {name = "fixtures_stairs_01_24", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_25", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_26", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_27", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_28", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_29", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_40", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_41", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_42", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_56", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_57", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_58", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_72", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_73", direction = IsoDirections.N},
            {name = "fixtures_stairs_01_74", direction = IsoDirections.N},
        }
    },
    -- From here on nothing is in the Wiki
    -- damaged_objects_01
    {
        type = "Damaged Public Mail Box", 
        spriteNames = {
            {name = "damaged_objects_01_8", direction = IsoDirections.S},
            {name = "damaged_objects_01_9", direction = IsoDirections.E},
            {name = "damaged_objects_01_10", direction = IsoDirections.W},
            {name = "damaged_objects_01_11", direction = IsoDirections.N}
        }
    },
    -- fixtures_railings_01
    -- location_hospitality_sunstarmotel_02
    {
        type = "Railings", 
        spriteNames = {
            {name = "fixtures_railings_01_24", direction = IsoDirections.E},
            {name = "fixtures_railings_01_25", direction = IsoDirections.S},
            {name = "fixtures_railings_01_26", direction = IsoDirections.E},
            {name = "fixtures_railings_01_28", direction = IsoDirections.E},
            {name = "fixtures_railings_01_29", direction = IsoDirections.S},
            {name = "fixtures_railings_01_30", direction = IsoDirections.E},
            {name = "fixtures_railings_01_34", direction = IsoDirections.E},
            {name = "fixtures_railings_01_36", direction = IsoDirections.E},
            {name = "fixtures_railings_01_37", direction = IsoDirections.S},
            {name = "fixtures_railings_01_38", direction = IsoDirections.E},
            {name = "fixtures_railings_01_48", direction = IsoDirections.E},
            {name = "fixtures_railings_01_49", direction = IsoDirections.S},
            {name = "fixtures_railings_01_52", direction = IsoDirections.E},
            {name = "fixtures_railings_01_53", direction = IsoDirections.S},
            {name = "fixtures_railings_01_54", direction = IsoDirections.E},
            {name = "fixtures_railings_01_64", direction = IsoDirections.E},
            {name = "fixtures_railings_01_65", direction = IsoDirections.S},
            {name = "fixtures_railings_01_66", direction = IsoDirections.E},
            {name = "fixtures_railings_01_74", direction = IsoDirections.E},
            {name = "fixtures_railings_01_88", direction = IsoDirections.E},
            {name = "fixtures_railings_01_89", direction = IsoDirections.S},
            {name = "fixtures_railings_01_90", direction = IsoDirections.E},
            {name = "fixtures_railings_01_92", direction = IsoDirections.E},
            {name = "fixtures_railings_01_93", direction = IsoDirections.S},
            {name = "fixtures_railings_01_108", direction = IsoDirections.E},
            {name = "fixtures_railings_01_109", direction = IsoDirections.S},
            {name = "fixtures_railings_01_110", direction = IsoDirections.E},
            {name = "fixtures_railings_01_112", direction = IsoDirections.E},
            {name = "fixtures_railings_01_113", direction = IsoDirections.S},
            {name = "fixtures_railings_01_114", direction = IsoDirections.E},
            {name = "fixtures_railings_01_116", direction = IsoDirections.E},
            {name = "fixtures_railings_01_117", direction = IsoDirections.S},
            {name = "fixtures_railings_01_118", direction = IsoDirections.E},
            {name = "fixtures_railings_01_128", direction = IsoDirections.E},
            {name = "fixtures_railings_01_129", direction = IsoDirections.S},
            {name = "fixtures_railings_01_130", direction = IsoDirections.E},
            {name = "fixtures_railings_01_132", direction = IsoDirections.E},
            {name = "fixtures_railings_01_133", direction = IsoDirections.S},
            {name = "location_hospitality_sunstarmotel_02_28", direction = IsoDirections.E},
            {name = "location_hospitality_sunstarmotel_02_29", direction = IsoDirections.S},
            {name = "location_hospitality_sunstarmotel_02_30", direction = IsoDirections.E},
            {name = "location_shop_mall_01_24", direction = IsoDirections.E},
            {name = "location_shop_mall_01_25", direction = IsoDirections.S},
            {name = "location_shop_mall_01_26", direction = IsoDirections.E},
            {name = "location_shop_mall_01_56", direction = IsoDirections.S},
            {name = "location_shop_mall_01_57", direction = IsoDirections.E},
            {name = "location_shop_mall_01_58", direction = IsoDirections.E},
            {name = "location_shop_mall_01_59", direction = IsoDirections.S},
            {name = "location_shop_mall_01_60", direction = IsoDirections.E},
            {name = "location_shop_mall_01_61", direction = IsoDirections.S},
            {name = "construction_01_0", direction = IsoDirections.E},
            {name = "construction_01_1", direction = IsoDirections.S},
            {name = "construction_01_2", direction = IsoDirections.E},
            {name = "walls_garage_02_20", direction = IsoDirections.E},
            {name = "walls_garage_02_21", direction = IsoDirections.S},
            {name = "walls_garage_02_22", direction = IsoDirections.E},
            {name = "location_restaurant_pileocrepe_01_56", direction = IsoDirections.E},
            {name = "location_restaurant_pileocrepe_01_57", direction = IsoDirections.S},
            {name = "location_restaurant_pileocrepe_01_58", direction = IsoDirections.E},
            {name = "location_restaurant_spiffos_02_60", direction = IsoDirections.E},
            {name = "location_restaurant_spiffos_02_61", direction = IsoDirections.S},
            {name = "location_restaurant_spiffos_02_62", direction = IsoDirections.E},
            {name = "carpentry_02_40", direction = IsoDirections.E},
            {name = "carpentry_02_41", direction = IsoDirections.S},
            {name = "carpentry_02_42", direction = IsoDirections.E},
            {name = "carpentry_02_44", direction = IsoDirections.E},
            {name = "carpentry_02_45", direction = IsoDirections.S},
            {name = "carpentry_02_46", direction = IsoDirections.E},
            {name = "carpentry_02_48", direction = IsoDirections.E},
            {name = "carpentry_02_49", direction = IsoDirections.S},
            {name = "carpentry_02_50", direction = IsoDirections.E}
        }
    },
    -- location_business_distillery_01
    {
        type = "Distillery", 
        spriteNames = {
            {name = "location_business_distillery_01_0", direction = IsoDirections.S},
            {name = "location_business_distillery_01_1", direction = IsoDirections.S},
            {name = "location_business_distillery_01_2", direction = IsoDirections.S},
            {name = "location_business_distillery_01_3", direction = IsoDirections.S},
            {name = "location_business_distillery_01_4", direction = IsoDirections.S},
            {name = "location_business_distillery_01_5", direction = IsoDirections.S}
        }
    },
    {
        type = "Distillery Barrel", 
        spriteNames = {
            {name = "location_business_distillery_01_8", direction = IsoDirections.S}
        }
    },
    -- location_business_machinery_01
    {
        type = "Tires Pile Small", 
        spriteNames = {
            {name = "location_business_machinery_01_40", direction = IsoDirections.S},
            {name = "location_business_machinery_01_41", direction = IsoDirections.S},
            {name = "location_business_machinery_01_50", direction = IsoDirections.S},
            {name = "recreational_sports_01_153", direction = IsoDirections.S},
            {name = "recreational_sports_01_154", direction = IsoDirections.S},
            {name = "recreational_sports_01_155", direction = IsoDirections.S},
            {name = "recreational_sports_01_161", direction = IsoDirections.S},
            {name = "recreational_sports_01_162", direction = IsoDirections.S},
            {name = "recreational_sports_01_163", direction = IsoDirections.S}
        }
    },
    {
        type = "Tires Pile Big", 
        spriteNames = {
            {name = "location_business_machinery_01_42", direction = IsoDirections.S},
            {name = "location_business_machinery_01_43", direction = IsoDirections.S},
            {name = "location_business_machinery_01_44", direction = IsoDirections.S},
            {name = "location_business_machinery_01_45", direction = IsoDirections.S},
            {name = "location_business_machinery_01_51", direction = IsoDirections.S},
            {name = "location_business_machinery_01_52", direction = IsoDirections.S},
            {name = "recreational_sports_01_136", direction = IsoDirections.S},
            {name = "recreational_sports_01_137", direction = IsoDirections.S},
            {name = "recreational_sports_01_138", direction = IsoDirections.S},
            {name = "recreational_sports_01_139", direction = IsoDirections.S},
            {name = "recreational_sports_01_140", direction = IsoDirections.S},
            {name = "recreational_sports_01_141", direction = IsoDirections.S},
            {name = "recreational_sports_01_144", direction = IsoDirections.S},
            {name = "recreational_sports_01_145", direction = IsoDirections.S},
            {name = "recreational_sports_01_146", direction = IsoDirections.S},
            {name = "recreational_sports_01_147", direction = IsoDirections.S},
            {name = "recreational_sports_01_148", direction = IsoDirections.S},
            {name = "recreational_sports_01_149", direction = IsoDirections.S}
        }
    },
    -- location_military_generic_01
    {
        type = "Target Panel", 
        spriteNames = {
            {name = "location_military_generic_01_64", direction = IsoDirections.W},
            {name = "location_military_generic_01_65", direction = IsoDirections.N},
            {name = "location_military_generic_01_66", direction = IsoDirections.S},
            {name = "location_military_generic_01_67", direction = IsoDirections.E}
        }
    },
    -- Nothing to stand against
    --[[
    {
        type = "Wooden Obstacle", 
        spriteNames = {
            {name = "location_military_generic_01_32", direction = IsoDirections.W},
            {name = "location_military_generic_01_33", direction = IsoDirections.W},
            {name = "location_military_generic_01_34", direction = IsoDirections.W},
            {name = "location_military_generic_01_35", direction = IsoDirections.W},
            {name = "location_military_generic_01_36", direction = IsoDirections.N},
            {name = "location_military_generic_01_37", direction = IsoDirections.N},
            {name = "location_military_generic_01_38", direction = IsoDirections.N},
            {name = "location_military_generic_01_39", direction = IsoDirections.N},
            {name = "location_military_generic_01_40", direction = IsoDirections.E},
            {name = "location_military_generic_01_41", direction = IsoDirections.E},
            {name = "location_military_generic_01_42", direction = IsoDirections.E},
            {name = "location_military_generic_01_43", direction = IsoDirections.E},
            {name = "location_military_generic_01_44", direction = IsoDirections.S},
            {name = "location_military_generic_01_45", direction = IsoDirections.S},
            {name = "location_military_generic_01_46", direction = IsoDirections.S},
            {name = "location_military_generic_01_47", direction = IsoDirections.S}
        }
    },
    ]]
    -- location_military_knox_01
    {
        type = "Small Pallet Gold", 
        spriteNames = {
            {name = "location_military_knox_01_1", direction = IsoDirections.S}
        }
    },
    {
        type = "Large Pallet Gold", 
        spriteNames = {
            {name = "location_military_knox_01_2", direction = IsoDirections.S}
        }
    },
    {
        type = "Welcome Knox", 
        spriteNames = {
            {name = "location_military_knox_01_20", direction = IsoDirections.S},
            {name = "location_military_knox_01_21", direction = IsoDirections.S},
            {name = "location_military_knox_01_22", direction = IsoDirections.S},
            {name = "location_military_knox_01_23", direction = IsoDirections.E},
            {name = "location_military_knox_01_24", direction = IsoDirections.S},
            {name = "location_military_knox_01_25", direction = IsoDirections.S},
            {name = "location_military_knox_01_26", direction = IsoDirections.S},
            {name = "location_military_knox_01_27", direction = IsoDirections.S},
            {name = "location_military_knox_01_28", direction = IsoDirections.S},
            {name = "location_military_knox_01_29", direction = IsoDirections.S},
            {name = "location_military_knox_01_31", direction = IsoDirections.E}
        }
    },
    -- street_decoration_01
    {
        type = "Concrete Road Block", 
        spriteNames = {
            {name = "street_decoration_01_28", direction = IsoDirections.S},
            {name = "street_decoration_01_29", direction = IsoDirections.E}
        }
    },
    {
        type = "Small Newspaper Vending Machine", 
        spriteNames = {
            {name = "street_decoration_01_80", direction = IsoDirections.E},
            {name = "street_decoration_01_81", direction = IsoDirections.S},
            {name = "street_decoration_01_82", direction = IsoDirections.W},
            {name = "street_decoration_01_83", direction = IsoDirections.N},
            {name = "street_decoration_01_88", direction = IsoDirections.E},
            {name = "street_decoration_01_89", direction = IsoDirections.S},
            {name = "street_decoration_01_90", direction = IsoDirections.W},
            {name = "street_decoration_01_91", direction = IsoDirections.N}
        }
    },
    {
        type = "Large Newspaper Vending Machine", 
        spriteNames = {
            {name = "street_decoration_01_84", direction = IsoDirections.E},
            {name = "street_decoration_01_85", direction = IsoDirections.S},
            {name = "street_decoration_01_86", direction = IsoDirections.N},
            {name = "street_decoration_01_87", direction = IsoDirections.W},
            {name = "street_decoration_01_92", direction = IsoDirections.E},
            {name = "street_decoration_01_93", direction = IsoDirections.S},
            {name = "street_decoration_01_94", direction = IsoDirections.N},
            {name = "street_decoration_01_95", direction = IsoDirections.W}
        }
    },
    -- camping_01
    {
        type = "Composter", 
        spriteNames = {
            {name = "camping_01_19", direction = IsoDirections.S}
        }
    },
    {
        type = "Small Stack Log", 
        spriteNames = {
            {name = "camping_01_24", direction = IsoDirections.N},
            {name = "camping_01_25", direction = IsoDirections.N},
            {name = "camping_01_26", direction = IsoDirections.N},
            {name = "camping_01_27", direction = IsoDirections.N},
            {name = "camping_01_28", direction = IsoDirections.S},
            {name = "camping_01_29", direction = IsoDirections.S},
            {name = "camping_01_30", direction = IsoDirections.S},
            {name = "camping_01_31", direction = IsoDirections.S},
            {name = "camping_01_40", direction = IsoDirections.S},
            {name = "camping_01_41", direction = IsoDirections.S},
            {name = "camping_01_32", direction = IsoDirections.E},
            {name = "camping_01_33", direction = IsoDirections.E},
            {name = "camping_01_34", direction = IsoDirections.E},
            {name = "camping_01_35", direction = IsoDirections.E},
            {name = "camping_01_36", direction = IsoDirections.W},
            {name = "camping_01_37", direction = IsoDirections.W},
            {name = "camping_01_38", direction = IsoDirections.W},
            {name = "camping_01_39", direction = IsoDirections.W},
            {name = "camping_01_42", direction = IsoDirections.E},
            {name = "camping_01_43", direction = IsoDirections.E}
        }
    },
    {
        type = "Large Stack Log", 
        spriteNames = {
            {name = "camping_01_48", direction = IsoDirections.S},
            {name = "camping_01_50", direction = IsoDirections.S},
            {name = "camping_01_53", direction = IsoDirections.E},
            {name = "camping_01_56", direction = IsoDirections.S},
            {name = "camping_01_59", direction = IsoDirections.E},
            {name = "camping_01_60", direction = IsoDirections.E}
        }
    },
    {
        type = "Mobile Medical Tool", 
        spriteNames = {
            {name = "location_community_medical_01_48", direction = IsoDirections.E},
            {name = "location_community_medical_01_49", direction = IsoDirections.S},
            {name = "location_community_medical_01_50", direction = IsoDirections.W},
            {name = "location_community_medical_01_51", direction = IsoDirections.N}
        }
    },
    {
        type = "Medical Foot Tool", 
        spriteNames = {
            {name = "location_community_medical_01_52", direction = IsoDirections.E},
            {name = "location_community_medical_01_53", direction = IsoDirections.S}
        }
    },
    {
        type = "Medical Waiting Chair", 
        spriteNames = {
            {name = "location_community_medical_01_56", direction = IsoDirections.E},
            {name = "location_community_medical_01_57", direction = IsoDirections.E},
            {name = "location_community_medical_01_58", direction = IsoDirections.S},
            {name = "location_community_medical_01_59", direction = IsoDirections.S},
            {name = "location_community_medical_01_60", direction = IsoDirections.W},
            {name = "location_community_medical_01_61", direction = IsoDirections.W},
            {name = "location_community_medical_01_62", direction = IsoDirections.N},
            {name = "location_community_medical_01_63", direction = IsoDirections.N}
        }
    },
    {
        type = "Baby Incubator", 
        spriteNames = {
            {name = "location_community_medical_01_64", direction = IsoDirections.S},
            {name = "location_community_medical_01_65", direction = IsoDirections.E}
        }
    },
    {
        type = "Mortuary Storage", 
        spriteNames = {
            {name = "location_community_medical_01_66", direction = IsoDirections.E},
            {name = "location_community_medical_01_67", direction = IsoDirections.S}
        }
    },
    {
        type = "Hospital Bed", 
        spriteNames = {
            {name = "location_community_medical_01_72", direction = IsoDirections.E},
            {name = "location_community_medical_01_73", direction = IsoDirections.E},
            {name = "location_community_medical_01_74", direction = IsoDirections.S},
            {name = "location_community_medical_01_75", direction = IsoDirections.S}
        }
    },
    {
        type = "Table Morgue", 
        spriteNames = {
            {name = "location_community_medical_01_76", direction = IsoDirections.S},
            {name = "location_community_medical_01_77", direction = IsoDirections.S},
            {name = "location_community_medical_01_78", direction = IsoDirections.E},
            {name = "location_community_medical_01_79", direction = IsoDirections.E}
        }
    },
    {
        type = "Blood Bank", 
        spriteNames = {
            {name = "location_community_medical_01_102", direction = IsoDirections.S},
            {name = "location_community_medical_01_103", direction = IsoDirections.E},
            {name = "location_community_medical_01_110", direction = IsoDirections.W},
            {name = "location_community_medical_01_111", direction = IsoDirections.N}
        }
    },
    {
        type = "Wide Medical Cabinet", 
        spriteNames = {
            {name = "location_community_medical_01_152", direction = IsoDirections.E},
            {name = "location_community_medical_01_153", direction = IsoDirections.E},
            {name = "location_community_medical_01_154", direction = IsoDirections.S},
            {name = "location_community_medical_01_155", direction = IsoDirections.S}
        }
    },
    {
        type = "Very Long Large Table", 
        spriteNames = {
            {name = "furniture_tables_high_02_0", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_1", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_2", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_6", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_7", direction = IsoDirections.N},
            {name = "furniture_tables_high_02_14", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_15", direction = IsoDirections.E},
            {name = "furniture_tables_high_02_9", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_10", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_16", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_17", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_18", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_22", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_23", direction = IsoDirections.N},
            {name = "furniture_tables_high_02_30", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_31", direction = IsoDirections.E},
            {name = "furniture_tables_high_02_24", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_25", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_26", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_32", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_33", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_34", direction = IsoDirections.S},
            {name = "furniture_tables_high_02_3", direction = IsoDirections.E},
            {name = "furniture_tables_high_02_4", direction = IsoDirections.E},
            {name = "furniture_tables_high_02_5", direction = IsoDirections.E},
            {name = "furniture_tables_high_02_11", direction = IsoDirections.E},
            {name = "furniture_tables_high_02_12", direction = IsoDirections.E},
            {name = "furniture_tables_high_02_13", direction = IsoDirections.E},
            {name = "furniture_tables_high_02_19", direction = IsoDirections.E},
            {name = "furniture_tables_high_02_20", direction = IsoDirections.E},
            {name = "furniture_tables_high_02_21", direction = IsoDirections.E},
            {name = "furniture_tables_high_02_27", direction = IsoDirections.E},
            {name = "furniture_tables_high_02_28", direction = IsoDirections.E},
            {name = "furniture_tables_high_02_29", direction = IsoDirections.E},
            {name = "furniture_tables_high_02_35", direction = IsoDirections.E},
            {name = "furniture_tables_high_02_36", direction = IsoDirections.E},
            {name = "furniture_tables_high_02_37", direction = IsoDirections.E}
        }
    },
    {
        type = "Heavy Industry Machine", 
        spriteNames = {
            {name = "industry_03_0", direction = IsoDirections.E},
            {name = "industry_03_1", direction = IsoDirections.E},
            {name = "industry_03_2", direction = IsoDirections.E},
            {name = "industry_03_3", direction = IsoDirections.S},
            {name = "industry_03_4", direction = IsoDirections.S},
            {name = "industry_03_5", direction = IsoDirections.S},
            {name = "industry_03_8", direction = IsoDirections.N},
            {name = "industry_03_9", direction = IsoDirections.N},
            {name = "industry_03_10", direction = IsoDirections.N},
            {name = "industry_03_11", direction = IsoDirections.W},
            {name = "industry_03_12", direction = IsoDirections.W},
            {name = "industry_03_13", direction = IsoDirections.W},
            {name = "industry_03_32", direction = IsoDirections.E},
            {name = "industry_03_33", direction = IsoDirections.E},
            {name = "industry_03_34", direction = IsoDirections.E},
            {name = "industry_03_35", direction = IsoDirections.S},
            {name = "industry_03_36", direction = IsoDirections.S},
            {name = "industry_03_37", direction = IsoDirections.S},
            {name = "industry_03_40", direction = IsoDirections.N},
            {name = "industry_03_41", direction = IsoDirections.N},
            {name = "industry_03_42", direction = IsoDirections.N},
            {name = "industry_03_43", direction = IsoDirections.W},
            {name = "industry_03_44", direction = IsoDirections.W},
            {name = "industry_03_45", direction = IsoDirections.W},
            {name = "industry_03_48", direction = IsoDirections.W},
            {name = "industry_03_52", direction = IsoDirections.W},
            {name = "industry_03_56", direction = IsoDirections.W},
            {name = "industry_03_60", direction = IsoDirections.W},
            {name = "industry_03_49", direction = IsoDirections.N},
            {name = "industry_03_53", direction = IsoDirections.N},
            {name = "industry_03_57", direction = IsoDirections.N},
            {name = "industry_03_61", direction = IsoDirections.N},
            {name = "industry_03_50", direction = IsoDirections.E},
            {name = "industry_03_54", direction = IsoDirections.E},
            {name = "industry_03_58", direction = IsoDirections.E},
            {name = "industry_03_62", direction = IsoDirections.E},
            {name = "industry_03_51", direction = IsoDirections.S},
            {name = "industry_03_55", direction = IsoDirections.S},
            {name = "industry_03_59", direction = IsoDirections.S},
            {name = "industry_03_63", direction = IsoDirections.S}
        }
    },
    {
        type = "Heavy Industry Table", 
        spriteNames = {
            {name = "industry_03_80", direction = IsoDirections.E},
            {name = "industry_03_81", direction = IsoDirections.E},
            {name = "industry_03_84", direction = IsoDirections.W},
            {name = "industry_03_85", direction = IsoDirections.W},
            {name = "industry_03_88", direction = IsoDirections.E},
            {name = "industry_03_89", direction = IsoDirections.E},
            {name = "industry_03_92", direction = IsoDirections.E},
            {name = "industry_03_93", direction = IsoDirections.E},
            {name = "industry_03_120", direction = IsoDirections.E},
            {name = "industry_03_121", direction = IsoDirections.E},
            {name = "industry_03_124", direction = IsoDirections.W},
            {name = "industry_03_125", direction = IsoDirections.W},
            {name = "industry_03_82", direction = IsoDirections.S},
            {name = "industry_03_83", direction = IsoDirections.S},
            {name = "industry_03_86", direction = IsoDirections.N},
            {name = "industry_03_87", direction = IsoDirections.N},
            {name = "industry_03_90", direction = IsoDirections.S},
            {name = "industry_03_91", direction = IsoDirections.S},
            {name = "industry_03_94", direction = IsoDirections.S},
            {name = "industry_03_95", direction = IsoDirections.S},
            {name = "industry_03_122", direction = IsoDirections.S},
            {name = "industry_03_123", direction = IsoDirections.S},
            {name = "industry_03_126", direction = IsoDirections.N},
            {name = "industry_03_127", direction = IsoDirections.N}
        }
    },
    {
        type = "Escalator Stairs", 
        spriteNames = {
            {name = "fixtures_escalators_01_0", direction = IsoDirections.E},
            {name = "fixtures_escalators_01_1", direction = IsoDirections.E},
            {name = "fixtures_escalators_01_2", direction = IsoDirections.E},
            {name = "fixtures_escalators_01_8", direction = IsoDirections.S},
            {name = "fixtures_escalators_01_9", direction = IsoDirections.S},
            {name = "fixtures_escalators_01_10", direction = IsoDirections.S}
        }
    },
    {
        type = "Escalator Door", 
        spriteNames = {
            {name = "fixtures_escalators_01_48", direction = IsoDirections.E},
            {name = "fixtures_escalators_01_49", direction = IsoDirections.E},
            {name = "fixtures_escalators_01_50", direction = IsoDirections.S},
            {name = "fixtures_escalators_01_51", direction = IsoDirections.S}
        }
    },
    {
        type = "Mechanical Conveyor", 
        spriteNames = {
            {name = "industry_02_40", direction = IsoDirections.S},
            {name = "industry_02_41", direction = IsoDirections.E},
            {name = "industry_02_42", direction = IsoDirections.S},
            {name = "industry_02_43", direction = IsoDirections.E},
            {name = "industry_02_44", direction = IsoDirections.E},
            {name = "industry_02_45", direction = IsoDirections.S}
        }
    },
    {
        type = "Various Machinery", 
        spriteNames = {
            {name = "industry_02_46", direction = IsoDirections.E},
            {name = "industry_02_47", direction = IsoDirections.S},
            {name = "industry_02_152", direction = IsoDirections.E},
            {name = "industry_02_153", direction = IsoDirections.S},
            {name = "industry_02_154", direction = IsoDirections.E},
            {name = "industry_02_155", direction = IsoDirections.S}
        }
    },
    {
        type = "Automatic Machinery", 
        spriteNames = {
            {name = "industry_02_48", direction = IsoDirections.S},
            {name = "industry_02_49", direction = IsoDirections.E},
            {name = "industry_02_50", direction = IsoDirections.S},
            {name = "industry_02_51", direction = IsoDirections.E},
            {name = "industry_02_54", direction = IsoDirections.E},
            {name = "industry_02_55", direction = IsoDirections.S}
        }
    },
    {
        type = "Industrial Electrical Panel", 
        spriteNames = {
            {name = "industry_02_161", direction = IsoDirections.N},
            {name = "industry_02_163", direction = IsoDirections.E},
            {name = "industry_02_165", direction = IsoDirections.S},
            {name = "industry_02_167", direction = IsoDirections.W},
            {name = "industry_02_168", direction = IsoDirections.S},
            {name = "industry_02_169", direction = IsoDirections.S},
            {name = "industry_02_170", direction = IsoDirections.S},
            {name = "industry_02_171", direction = IsoDirections.E},
            {name = "industry_02_172", direction = IsoDirections.E},
            {name = "industry_02_173", direction = IsoDirections.E}
        }
    },
    {
        type = "Industrial Jigsaw", 
        spriteNames = {
            {name = "industry_02_264", direction = IsoDirections.E},
            {name = "industry_02_265", direction = IsoDirections.S},
            {name = "industry_02_266", direction = IsoDirections.W},
            {name = "industry_02_267", direction = IsoDirections.N}
        }
    },
    {
        type = "ATM Machine", 
        spriteNames = {
            {name = "location_business_bank_01_64", direction = IsoDirections.E},
            {name = "location_business_bank_01_65", direction = IsoDirections.S}
        }
    },
    {
        type = "Bank Vault", 
        spriteNames = {
            {name = "location_business_bank_01_68", direction = IsoDirections.E},
            {name = "location_business_bank_01_69", direction = IsoDirections.S}
        }
    },
    -- Nothing to stand against on 13 and 15
    {
        type = "Gas Pump", 
        spriteNames = {
            {name = "location_shop_fossoil_01_12", direction = IsoDirections.E},
            {name = "location_shop_fossoil_01_14", direction = IsoDirections.S},
            {name = "location_shop_gas2go_01_12", direction = IsoDirections.E},
            {name = "location_shop_gas2go_01_14", direction = IsoDirections.S}
        }
    },
    {
        type = "Out of Gas", 
        spriteNames = {
            {name = "location_shop_fossoil_01_68", direction = IsoDirections.S},
            {name = "location_shop_fossoil_01_69", direction = IsoDirections.E},
            {name = "location_shop_gas2go_01_38", direction = IsoDirections.S},
            {name = "location_shop_gas2go_01_39", direction = IsoDirections.E}
        }
    },
    {
        type = "Mall Central Block", 
        spriteNames = {
            {name = "location_shop_mall_01_28", direction = IsoDirections.S},
            {name = "location_shop_mall_01_29", direction = IsoDirections.S},
            {name = "location_shop_mall_01_30", direction = IsoDirections.E}
        }
    },
    {
        type = "Gym Treadmills", 
        spriteNames = {
            {name = "recreational_sports_01_29", direction = IsoDirections.E},
            {name = "recreational_sports_01_30", direction = IsoDirections.S},
            {name = "recreational_sports_01_36", direction = IsoDirections.W},
            {name = "recreational_sports_01_39", direction = IsoDirections.N}
        }
    },
    {
        type = "Tennis Net", 
        spriteNames = {
            {name = "recreational_sports_01_49", direction = IsoDirections.S},
            {name = "recreational_sports_01_50", direction = IsoDirections.S},
            {name = "recreational_sports_01_51", direction = IsoDirections.S},
            {name = "recreational_sports_01_52", direction = IsoDirections.E},
            {name = "recreational_sports_01_53", direction = IsoDirections.E},
            {name = "recreational_sports_01_54", direction = IsoDirections.E}
        }
    },
    {
        type = "Buffet Pans", 
        spriteNames = {
            {name = "location_restaurant_generic_01_16", direction = IsoDirections.S},
            {name = "location_restaurant_generic_01_17", direction = IsoDirections.E},
            {name = "location_restaurant_generic_01_18", direction = IsoDirections.E},
            {name = "location_restaurant_generic_01_19", direction = IsoDirections.E},
            {name = "location_restaurant_generic_01_20", direction = IsoDirections.S},
            {name = "location_restaurant_generic_01_21", direction = IsoDirections.S},
            {name = "location_restaurant_generic_01_22", direction = IsoDirections.S},
            {name = "location_restaurant_generic_01_23", direction = IsoDirections.E}
        }
    },
    {
        type = "Pallet Brick", 
        spriteNames = {
            {name = "construction_01_4", direction = IsoDirections.S}
        }
    },
    -- Nothing to stand against
    --[[
    {
        type = "Greenes Sale", 
        spriteNames = {
            {name = "location_shop_greenes_01_45", direction = IsoDirections.E},
            {name = "location_shop_greenes_01_46", direction = IsoDirections.S}
        }
    },
    ]]
}

--- Function to get the direction of a sprite
--- @param spriteName string -- The name of the sprite
--- @return IsoDirections|nil -- The direction of the sprite or nil if not found
function ZomboDesire_ObjectTypes.getSpriteDirection(spriteName)
    return ZomboDesire_ObjectTypes.spriteToDirection[spriteName]
end

--- Function to check if a sprite matches an object type
--- @param spriteName string -- The name of the sprite to check
--- @param objectType table -- The object type table containing spriteNames
--- @return boolean -- True if the sprite matches the object type, false otherwise
function ZomboDesire_ObjectTypes.checkSpriteForObjectType(spriteName, objectType)
    if not objectType.spriteNames then return false end

    for _, sprite in ipairs(objectType.spriteNames) do
        if sprite.name == spriteName then
            return true
        end
    end

    return false
end

--- Function to get the object type from a sprite
--- @param spriteName string -- The name of the sprite
--- @return string|nil -- The object type or nil if not found
function ZomboDesire_ObjectTypes.getObjectTypeFromSprite(spriteName)
    for _, objType in ipairs(ZomboDesire_ObjectTypes.objectTypes) do
        if ZomboDesire_ObjectTypes.checkSpriteForObjectType(spriteName, objType) then
            return objType.type
        end
    end

    return nil
end

--- Function to initialize the sprite directions lookup table
--- Populates the spriteToDirection table by iterating through all object types
--- @return nil
function ZomboDesire_ObjectTypes.initSpriteDirections()
    -- Create a lookup table for sprite directions
    ZomboDesire_ObjectTypes.spriteToDirection = {}

    -- Iterate through all object types
    for _, objectType in ipairs(ZomboDesire_ObjectTypes.objectTypes) do
        if objectType.spriteNames and #objectType.spriteNames > 0 then
            for _, sprite in ipairs(objectType.spriteNames) do
                if sprite.name and sprite.direction then
                    ZomboDesire_ObjectTypes.spriteToDirection[sprite.name] = sprite.direction
                end
            end
        end
    end
end

-- Initialize the sprite directions lookup table
ZomboDesire_ObjectTypes.initSpriteDirections()

-- Export the module
return ZomboDesire_ObjectTypes
