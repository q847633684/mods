--- File: ZomboDesire/42/media/lua/client/Objects/ZomboDesire_ObjectTags.lua
--- Module for determining the appropriate interaction tag based on the detected object
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_ObjectTags.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboDesire_Main" -- Main module with debug functions

--- Module name for logging
--- @type string
local MODULE_NAME = "ObjectTags"

--- Module table
--- @class ZomboDesire_ObjectTags
local ZomboDesire_ObjectTags = {}

--- Correspondence table for "Leaning over" objects
--- @type table
local leaningOverObjects = {
    -- Appliances / Communication
    ["TV"] = true,

    -- Appliances / Cooking appliances
    ["Green Oven"] = true,
    ["Red Oven"] = true,
    ["Modern Oven"] = true,
    ["Industrial Oven"] = true,
    ["Fryers Club Industrial 2000 Oven"] = true,
    ["Old Stove Oven"] = true,
    ["Crafted Oven"] = true,
    ["Metal Drum"] = true,
    ["Crafted Metal Drum"] = true,
    ["Barbecue"] = true,
    ["Mini Fridge"] = true,
    ["Popsicle Fridge"] = true,
    ["Chest Freezer"] = true,
    ["Built-in Trailer Fridge"] = true,

    -- Appliances / Washing machines
    ["Clothes Dryer"] = true,
    ["Washing Machine"] = true,
    ["Blue Combo WasherDryer"] = true,

    -- Appliances / Other
    ["CeroSec Terminal"] = true,
    ["Security Terminal"] = true,
    ["PAWS Pinball"] = true,

    -- Plumbing / Sinks
    ["White Standing Sink"] = true,
    ["White Hanging Sink"] = true,
    ["Fancy Hanging Sink"] = true,
    ["Large Industrial Sink"] = true,

    -- Plumbing / Baths and showers
    ["Large Deluxe Bath"] = true,

    -- Comfort / Beds
    ["Police Prisoners Bed"] = true,

    -- Comfort / Chairs
    ["Spiffo Dinner Chair"] = true,

    -- Comfort / Seats
    ["Hanging Seat"] = true,
    ["Leather Bar Seat"] = true,

    -- Comfort / Stools
    ["Wooden Bar Stool"] = true,
    ["Branch Stool"] = true,
    ["Large Bar Stool"] = true,
    ["Bar Stool"] = true,
    ["50s Bar Stool"] = true,
    ["Piano Stool"] = true,
    ["Drum Stool"] = true,

    -- Tables
    ["Picnic Table"] = true,
    ["Large Wooden Table"] = true,
    ["Long Branch Low Table"] = true,
    ["Quality Crafted Table"] = true,
    ["Long Table"] = true,
    ["Oak Round Table"] = true,
    ["Light Round Table"] = true,
    ["Large Brown Table"] = true,
    ["Long Light Table"] = true,
    ["Round Table"] = true,
    ["Fancy Table"] = true,
    ["Fancy Dark Table"] = true,
    ["Large Dark Table"] = true,
    ["Long Dark Table"] = true,
    ["Dark Round Table"] = true,
    ["Large Light Table"] = true,
    ["Large Oak Table"] = true,
    ["Broad White Table"] = true,
    ["Large Dark Wooden Table"] = true,
    ["Plastic Table"] = true,
    ["Large Smooth Table"] = true,
    ["Large Simple Table"] = true,
    ["Large Plastic Table"] = true,
    ["Large Light Oak Table"] = true,
    ["50s Diner Table"] = true,
    ["Brown Picnic Table"] = true,
    ["Blue Picnic Table"] = true,
    ["Large Bleached Table"] = true,
    ["Light Wood Restaurant Table"] = true,
    ["Pizza Whirled Table"] = true,
    ["Spiffo Type B Table"] = true,
    ["Spiffo Type A Table"] = true,
    ["Lightwood Trailer Table"] = true,
    ["Pool Table"] = true,
    ["Large Dark Oak Table"] = true,
    ["Mall Table"] = true,

    -- Storage / Counters
    ["Bar Corner"] = true,
    ["Bar Element"] = true,
    ["Crude Metal Corner Counter"] = true,
    ["Crude Metal Counter"] = true,
    ["Modern Corner Counter"] = true,
    ["Modern Counter"] = true,
    ["Wooden Corner Counter"] = true,
    ["Wooden Counter"] = true,
    ["Metal Counter Corner"] = true,
    ["Metal Counter"] = true,
    ["Birchwood Corner Counter"] = true,
    ["Birchwood Counter"] = true,
    ["Oak Corner Counter"] = true,
    ["Oak Counter"] = true,
    ["Dark Corner Counter"] = true,
    ["Dark Counter"] = true,
    ["Green Corner Counter"] = true,
    ["Green Counter"] = true,
    ["White Corner Counter"] = true,
    ["White Counter"] = true,
    ["Glass Theater Counter"] = true,
    ["Theater Corner Counter"] = true,
    ["Theater Counter"] = true,
    ["Square Theater Counter"] = true,
    ["Motel Counter"] = true,
    ["Bar Corner Counter"] = true,
    ["Bar Counter"] = true,
    ["Oak Corner Bar Counter"] = true,
    ["Oak Bar Counter"] = true,
    ["White Striped Corner Counter"] = true,
    ["White Striped Counter"] = true,
    ["Seahorse Coffee Corner Counter"] = true,
    ["Seahorse Coffee Counter"] = true,
    ["Spiffo Corner Counter"] = true,
    ["Spiffo Counter"] = true,
    ["Fossoil Corner Counter"] = true,
    ["Fossoil Counter"] = true,
    ["Fossoil Low Shelves"] = true,
    ["Red Corner Counter"] = true,
    ["Red Counter"] = true,
    ["Gas2Go Low Shelves"] = true,
    ["Zippee Corner Counter"] = true,
    ["Zippee Counter"] = true,
    ["Zippee Display Counter"] = true,
    ["Trailer Counter"] = true,
    ["Oak Employee Bank Counter"] = true,
    ["Employee Bank Counter"] = true,
    ["Oak Bank Counter"] = true,
    ["Bank Counter"] = true,
    ["Low Motel Counter"] = true,
    ["Diner Corner Counter"] = true,
    ["Diner Counter"] = true,
    ["Pizza Whirled Corner Counter"] = true,
    ["Pizza Whirled Counter"] = true,
    ["Generic Shop Corner Counter"] = true,
    ["Generic Shop Counter"] = true,
    ["Rounded Glass Display Counter"] = true,
    ["Shop Display Counter"] = true,
    ["Glass Corner Display Counter"] = true,
    ["Glass Display Counter"] = true,
    ["Greene Grocery Display Counter"] = true,

    -- Storage / Shelves (Low style)
    ["Branch Shelves"] = true,
    ["Low Shelves"] = true,
    ["Large Low Shelves"] = true,
    ["Corner A Shelves"] = true,
    ["Middle Shelves"] = true,
    ["Corner B Shelves"] = true,
    ["Comics Shop Shelves"] = true,
    ["Generic Shop Shelves"] = true,
    ["Small Drying Rack"] = true,
    ["Large Drying Rack"] = true,
    ["Medium Drying Rack"] = true,
    ["Bowling Rack"] = true,

    -- Storage / Cabinets
    ["Red Mobile Tool Cabinet"] = true,

    -- Storage / Desks
    ["Office Desk"] = true,
    ["Dark School Bench"] = true,
    ["Light School Bench"] = true,

    -- Storage / Dressers (Low style)
    ["Fancy Drawers"] = true,
    ["Fancy Oak Drawers"] = true,
    ["Dark Fancy Drawers"] = true,
    ["Mirror And Drawers"] = true,
    ["Light Wood Drawers"] = true,
    ["Bedroom Drawers"] = true,

    -- Storage / Crates
    ["Wooden Crate"] = true,
    ["Metal Crate"] = true,
    ["Fancy Metal Crate"] = true,
    ["Large Cardboard Box"] = true,
    ["Military Crate"] = true,
    ["Cardboard Box"] = true,
    ["Battered Cardboard Box"] = true,
    ["Small Crate"] = true,

    -- Storage / Bins
    ["Spiffo Garbage Bin"] = true,
    ["Fossoil Garbage Bin"] = true,
    ["Mall Garbage Bin"] = true,
    ["Wheelie Bin"] = true,
    ["Recycle Bin"] = true,
    ["Green Garbage Bin"] = true,
    ["Gray Garbage Bin"] = true,
    ["Public Garbage Bin"] = true,

    -- Workstations
    ["Branch Workbench"] = true,
    ["Wood Top Workbench"] = true,
    ["Complex Loom"] = true,
    ["Simple Loom"] = true,
    ["Simple Pottery Wheel"] = true,
    ["Modern Pottery Wheel"] = true,

    -- Signs
    ["For Sale Sign"] = true,

    -- Plants (Low style)
    ["Raised Plantbed"] = true,
    ["Low Hedge"] = true,
    ["Low Corner Hedge"] = true,

    -- Miscellaneous (Low style)
    ["Large Metal Trough"] = true,
    ["Small Metal Trough"] = true,
    ["Road Block"] = true,
    ["Laundry Cart"] = true,
    ["Round Gravestone"] = true,
    ["Arched Gravestone"] = true,
    ["Square Gravestone"] = true,
    ["Battered Gravestone"] = true,
    ["Decorated Altar"] = true,
    ["Brick Planter"] = true,
    ["Western Piano"] = true,
    ["Black Grand Piano"] = true,
    ["DogHouse"] = true,
    ["Large Fountain"] = true,

    -- Structural elements
    ["Fence"] = true,
    ["Fence Door"] = true,

    -- Everything else
    ["Railings"] = true,
    ["Distillery Barrel"] = true,
    ["Tires Pile Small"] = true,
    ["Cairn"] = true,
    ["Large Metal Feeder With Roof"] = true,
    ["Long Cattle Feeder"] = true,
    ["Short Cattle Feeder"] = true,
    ["Small Pallet Gold"] = true,
    ["Concrete Road Block"] = true,
    ["Composter"] = true,
    ["Dentist Patient Bed"] = true,
    ["Large Medical Bed"] = true,
    ["Patient Bed"] = true,
    ["Medical Drawers"] = true,
    ["Mobile Medical Tool"] = true,
    ["Medical Waiting Chair"] = true,
    ["Baby Incubator"] = true,
    ["Hospital Bed"] = true,
    ["Table Morgue"] = true,
    ["Very Long Large Table"] = true,
    ["Heavy Industry Table"] = true,
    ["Mechanical Conveyor"] = true,
    ["Various Machinery"] = true,
    ["Out of Gas"] = true,
    ["Mall Central Block"] = true,
    ["Tennis Net"] = true,
    ["Buffet Pans"] = true,
    ["Pallet Brick"] = true
}

--- Correspondence table for "Standing against" objects
--- @type table
local standingAgainstObjects = {
    -- Appliances / Cooking appliances
    ["Large Modern Cooker"] = true,
    ["BakeOMatic Industrial"] = true,
    ["Jorge Foreguy Barbecue"] = true,
    ["Full Jorge Foreguy Barbecue"] = true,

    -- Appliances / Fridges
    ["Fridge"] = true,
    ["Other Fridge"] = true,
    ["Generic Cooled Shelves"] = true,
    ["White Display Counter"] = true,

    -- Appliances / Other
    ["Kaboom Arcade"] = true,
    ["Dr Oids Arcade"] = true,

    -- Plumbing / Toilets
    ["Hanging Toilet"] = true,

    -- Plumbing / Baths and showers
    ["Shower screen"] = true,

    -- Plumbing / Other
    ["Water Dispenser"] = true,
    ["Empty Water Dispenser"] = true,

    -- Storage / Counters
    ["Corner A Glass"] = true,
    ["Middle Glass"] = true,
    ["Corner B Glass"] = true,
    ["Grocery Trapezoid Counter"] = true,

    -- Storage / Shelves (High style)
    ["Big Wall Corner Shelves"] = true,
    ["Big Wall Shelves"] = true,
    ["Large Metal Shelves"] = true,
    ["Oakwood Shelves"] = true,
    ["White Fancy Shelves"] = true,
    ["Metal Locker"] = true,
    ["Large Rental Shelves"] = true,
    ["Small Rental Shelves"] = true,
    ["Left Bar Wall Bar"] = true,
    ["Bar Wall Bar"] = true,
    ["Right Bar Wall Bar"] = true,
    ["Blue Magazine Shelf"] = true,
    ["Beige Magazine Shop Shelves"] = true,
    ["Beige Rack Shop Shelves"] = true,
    ["Large Clothes Rack"] = true,
    ["Small Clothes Rack"] = true,
    ["Clothes Stand"] = true,
    ["Open Wardrobe"] = true,
    ["Wooden Shop Shelves"] = true,
    ["Large Shop Shelves"] = true,
    ["Fancy Wooden Shop Shelves"] = true,
    ["Trapezoid Shop Shelves"] = true,
    ["Greene Grocery Shelves"] = true,
    ["Zippee Low Wall Shelves"] = true,
    ["Red Magazine Shelf"] = true,
    ["Long Shelves"] = true,
    ["Zippee Shelves Rack"] = true,
    ["Regular Magasine Rack"] = true,

    -- Storage / Cabinets
    ["China Cabinet"] = true,
    ["Gray File Cabinet"] = true,
    ["White File Cabinet"] = true,

    -- Storage / Dressers (High style)
    ["Fancy White Wardrobe"] = true,
    ["Fancy Oak Wardrobe"] = true,
    ["Dark Fancy Wardrobe"] = true,
    ["Large Wardrobe"] = true,
    ["Light Wood Wardrobe"] = true,
    ["White Wardrobe"] = true,

    -- Storage / Lockers
    ["Crude Tall Locker"] = true,
    ["Crude Wall Locker"] = true,
    ["Blue Wall Locker"] = true,
    ["Small Locker"] = true,
    ["Big Locker"] = true,
    ["Military Locker"] = true,

    -- Storage / Displays
    ["Glass Display Stand"] = true,
    ["Pie Display Stand"] = true,
    ["Glass Display"] = true,
    ["Seahorse Coffee Glass Display"] = true,

    -- Storage / Mail boxes
    ["Public Mail Box"] = true,

    -- Storage / Mannequins
    ["Scarecrow"] = true,
    ["Mannequin"] = true,

    -- Storage / Bins
    ["Garbage Bin"] = true,

    -- Dumpsters
    ["Blue Dumpster"] = true,
    ["Orange Dumpster"] = true,

    -- Storage / Other
    ["Slurp Burp Soda Machine"] = true,
    ["Large Machine"] = true,

    -- Decorations / Sculptures
    ["Male Bust"] = true,
    ["Female Bust"] = true,
    ["Female Statue"] = true,
    ["Male Statue"] = true,
    ["Gallery Toilet"] = true,
    ["Gallery Bed"] = true,
    ["Famous Man Statue"] = true,
    ["Giant Horseman Statue"] = true,
    ["Giant Horse Statue"] = true,

    -- Decorations / Phones
    ["Pay Phones"] = true,

    -- Decorations / Other
    ["Bird Bath"] = true,
    ["Mall Map"] = true,

    -- Signs
    ["Ominous Sign"] = true,
--	["Spiffo Arrow Sign"] = true,
    ["Blowout Sign"] = true,
    ["Sale Sign"] = true,
--	["Inmates Road Sign"] = true,
--	["Rest Area Road Sign"] = true,
--	["Muldraugh Road Sign"] = true,
--	["West Point Road Sign"] = true,
--	["Rosewood Road Sign"] = true,
--	["March Ridge Road Sign"] = true,
--	["Rest Area South Road Sign"] = true,
    ["What Missing Sign"] = true,
    ["Hungry Desert Sign"] = true,
    ["Burn In Hell Sign"] = true,
    ["Jesus Carry Sign"] = true,
    ["Jesus Save Sign"] = true,
    ["Lord Shepherd Sign"] = true,
    ["God Knox Sign"] = true,
    ["Service Daily Sign"] = true,
    ["God Watching Sign"] = true,
    ["Satan Domain Sign"] = true,
    ["Evening Service Sign"] = true,
    ["Devious Gooses Sign"] = true,
    ["Chris Died Sign"] = true,
    ["Lord Forsaken Sign"] = true,
    ["To 19 Sign"] = true,
    ["God Will Sign"] = true,
    ["No Credit Sign"] = true,
    ["Pony Roam Sign"] = true,
--	["Riverside Suites Sign"] = true,
    ["Sunstarmotel Sign"] = true,

    -- Plants (High style)
    ["Double Stacked Hay"] = true,
    ["Tall Hedge"] = true,
    ["Tall Corner Hedge"] = true,

    -- Miscellaneous (High style)
    ["Standing Vault"] = true,
    ["Angelic Gravestone"] = true,
    ["Lectern Stand"] = true,
    ["Childrens Play Castle"] = true,
    ["Small Soda Machine"] = true,
    ["Oldies Jukebox"] = true,
    ["Pool Cue Stand"] = true,
    ["Security Wall Monitors"] = true,
    ["Upright Coffin"] = true,

    -- Structural elements
    ["Wall"] = true,
    ["Door"] = true,
    ["Open Door"] = true,
    ["High Fence"] = true,
    ["High Fence Door"] = true,
    ["Open High Fence Door"] = true,
    ["Low Fence Door"] = true,
    ["Open Low Fence Door"] = true,
    ["Escalator Door"] = true,

    -- Everything else
    ["Damaged Public Mail Box"] = true,
    ["Distillery"] = true,
    ["Tires Pile Big"] = true,
    ["Chicken Coop"] = true,
    ["Target Panel"] = true,
    ["Large Pallet Gold"] = true,
    ["Welcome Knox"] = true,
    ["Small Newspaper Vending Machine"] = true,
    ["Large Newspaper Vending Machine"] = true,
    ["Large Stack Log"] = true,
    ["Baby Crib Bed"] = true,
    ["Mortuary Storage"] = true,
    ["Blood Bank"] = true,
    ["Wide Medical Cabinet"] = true,
    ["Heavy Industry Machine"] = true,
    ["Advertising Mall"] = true,
    ["Hodgetts Sign"] = true,
    ["Automatic Machinery"] = true,
    ["Industrial Electrical Panel"] = true,
    ["Industrial Jigsaw"] = true,
    ["ATM Machine"] = true,
    ["Bank Vault"] = true,
    ["Gas Pump"] = true,
    ["Gym Treadmills"] = true
}

--- Correspondence table for "Sitting on" objects
--- @type table
local sittingOnObjects = {
    -- Plumbing / Toilets
    ["Fancy Toilet"] = true,
    ["Low Toilet"] = true,
    ["Chemical Toilet"] = true,
    ["Wooden Toilet"] = true,

    -- Comfort / Couches
    ["Red Comfy Couch"] = true,
    ["Green Comfy Couch"] = true,
    ["Purple Rattan Couch"] = true,
    ["White Lazy Couch"] = true,
    ["Blue Rattan Couch"] = true,
    ["Brown Lazy Couch"] = true,
    ["Grey Lazy Couch"] = true,
    ["Yellow Modern Couch"] = true,
    ["Blue Comfy Couch"] = true,
    ["Victorian C1 Couch"] = true,
    ["Victorian C2 Couch"] = true,
    ["Victorian C3 Couch"] = true,
    ["Victorian C4 Couch"] = true,
    ["Victorian C5 Couch"] = true,
    ["Victorian C6 Couch"] = true,

    -- Comfort / Chairs
    ["Crafted Chair"] = true,
    ["Green Comfy Chair"] = true,
    ["Orange Modern Chair"] = true,
    ["Purple Rattan Chair"] = true,
    ["White Fancy Chair"] = true,
    ["Red Chair"] = true,
    ["White Chair"] = true,
    ["Black Office Chair"] = true,
    ["Green Wooden Chair"] = true,
    ["Folding Chair"] = true,
    ["Dark Wooden Chair"] = true,
    ["Wooden Chair"] = true,
    ["Red Wooden Chair"] = true,
    ["Blue Plastic Chair"] = true,
    ["White Lazy Chair"] = true,
    ["Blue Rattan Chair"] = true,
    ["Brown Lazy Chair"] = true,
    ["White Wooden Chair"] = true,
    ["Grey Lazy Chair"] = true,
    ["Blue Comfy Chair"] = true,
    ["Yellow Modern Chair"] = true,
    ["Black Fancy Chair"] = true,
    ["Purple Wooden Chair"] = true,
    ["Dark Blue Chair"] = true,
    ["White Simple Chair"] = true,
    ["Grey Plastic Chair"] = true,
    ["Victorian 1 Chair"] = true,
    ["Victorian 2 Chair"] = true,
    ["Victorian 3 Chair"] = true,
    ["Victorian 4 Chair"] = true,
    ["Victorian 5 Chair"] = true,
    ["Victorian 6 Chair"] = true,
    ["Rocking Chair"] = true,
    ["Plastic Chair"] = true,
    ["Beach Chair"] = true,
    ["Blue Theater Chair"] = true,
    ["Red Theatre Chair"] = true,
    ["Pile o Crepe Chair"] = true,
    ["Salon Chair"] = true,
    ["Mall Chair"] = true,
    ["Grey Chair"] = true,

    -- Comfort / Benches
    ["Wooden Bench"] = true,
    ["Park Bench"] = true,
    ["Log Bench"] = true,
    ["Sturdy Bench"] = true,
    ["Long Wooden Bench"] = true,
    ["Sports Bench"] = true,
    ["Fancy Outdoors Bench"] = true,
    ["Oakwood Bench"] = true,
    ["Birchwood Bench"] = true,
    ["Brick Mall Bench"] = true,
    ["Low Bench Trailer"] = true,

    -- Comfort / Seats
    ["50s Seat"] = true,
    ["Blue Seat"] = true,
    ["Pizza Whirled Seat"] = true,
    ["Spiffo Lounge Seat"] = true,
    ["Trailer Fixed Seat"] = true,

    -- Comfort / Other
    ["Church Pew"] = true,
    ["Orange Futon"] = true,

    -- Tables
    ["Long Low Table"] = true,
    ["Fancy Low Table"] = true,
    ["Long Fancy Low Table"] = true,
    ["Fancy Low Glass Table"] = true,
    ["Brown Low Table"] = true,
    ["Light Low Table"] = true,
    ["Black Low Modern Table"] = true,
    ["Low Plastic Table"] = true,

    -- Plants (Low style)
    ["Single Stacked Hay"] = true,

    -- Miscellaneous
    ["Fitness Contraption"] = true,
    ["Flat Coffin"] = true,

    -- Everything else
    ["Large Animal Feeder"] = true,
    ["Small Animal Feeder"] = true,
    ["Small Stack Log"] = true,
    ["Medical Foot Tool"] = true
}

--- Correspondence table for “Lying on” objects
--- @type table
local lyingOnObjects = {
    -- Comfort / Beds
    ["Twin Beds"] = true,
    ["Bunk Beds"] = true,
    ["Fancy Bed"] = true,
    ["Large Fancy Bed"] = true,
    ["Blue Bed"] = true,
    ["Large Modern Bed"] = true,
    ["Simple Bed"] = true,
    ["Large Oak Bed"] = true,
    ["Stretcher Bed"] = true,
    ["Gurney Bed"] = true

    -- Everything else
}

--- Correspondence table for "On stairs" objects
--- @type table
local onStairsObjects = {
    -- Structural elements
    ["Stairs"] = true,

    -- Everything else
    ["Escalator Stairs"] = true
}

--- Determines the appropriate interaction tag based on the detected object
--- @param detectedObject table -- The detected object with its type and other properties
--- @return "Leaning over"|"Standing against"|"Sitting on"|"Lying on"|"On stairs"|nil -- The interaction tag to use for the animation, or nil if none was determined
function ZomboDesire_ObjectTags.determineObjectInteractionTag(detectedObject)
    if not detectedObject or not detectedObject.type then
        ZomboDesire.debugLog(MODULE_NAME, "No valid object detected")
        return nil
    end

    ZomboDesire.debugLog(MODULE_NAME, "Determining tag for object %s", detectedObject.type)

    -- Check for exact matches
    if leaningOverObjects[detectedObject.type] then
        ZomboDesire.debugLog(MODULE_NAME, "Tag -> Leaning over %s", detectedObject.type)
        return "Leaning over"
    end

    if standingAgainstObjects[detectedObject.type] then
        ZomboDesire.debugLog(MODULE_NAME, "Tag -> Standing against %s", detectedObject.type)
        return "Standing against"
    end

    if sittingOnObjects[detectedObject.type] then
        ZomboDesire.debugLog(MODULE_NAME, "Tag -> Sitting on %s", detectedObject.type)
        return "Sitting on"
    end

    if lyingOnObjects[detectedObject.type] then
        ZomboDesire.debugLog(MODULE_NAME, "Tag -> Lying on %s", detectedObject.type)
        return "Lying on"
    end

    if onStairsObjects[detectedObject.type] then
        ZomboDesire.debugLog(MODULE_NAME, "Tag -> On stairs %s", detectedObject.type)
        return "On stairs"
    end

    -- Default case if no match is found
    ZomboDesire.debugLog(MODULE_NAME, "No tag found for object %s", detectedObject.type)
    return nil
end

-- Return the module
return ZomboDesire_ObjectTags
