--- File: ZomboDesire/42/media/lua/client/ZomboDesire_Intercept.lua
--- Client-side interceptor for ZomboDesire framework
--- Handles detection of ZomboLust adult mod and sub-mods on game start, and collision interception
--- @author BlaBla 2025

-- Initial loading print
print("[ZomboDesire LOADING] ZomboDesire_Intercept.lua loaded")

-- =============
-- Dependencies
-- =============
-- Main module with debug functions + Handles all flags
require "ZomboDesire_Main"
-- Handles direct transformation of zombie into ZombHuman
local ZomboDesire_TransformZombHuman = require "Transform/ZomboDesire_TransformZombHuman"
-- Handles scene preparation and launching
require "Staging/ZomboDesire_Staging"
-- Utilities for pushing nearby zombies, determination side of object, player control management
require "ZomboDesire_Utils"
-- Detection utilities
---@type ZomboDesire_Detection
local ZomboDesire_Detection = require "Detection/ZomboDesire_Detection"
-- Used to process function return from ZomboDesire_Detection.lua
require "luautils"
-- Flag management to avoid double cleanup in ZomboDesire_Cleanup.lua
---@type ZomboDesire_Cleanup
local ZomboDesire_Cleanup = require "ZomboDesire_Cleanup"
-- Object detection utilities
---@type ZomboDesire_ObjectDetection
local ZomboDesire_ObjectDetection = require "Detection/ZomboDesire_ObjectDetection"
-- Object tag determination utilities
---@type ZomboDesire_ObjectTags
local ZomboDesire_ObjectTags = require "Objects/ZomboDesire_ObjectTags"
-- Direction from ZomboDesire_ObjectTypes
---@type ZomboDesire_ObjectTypes
local ZomboDesire_ObjectTypes = require "Objects/ZomboDesire_ObjectTypes"

-- ZomboLust integration
local ZomboLust_GenderMismatchHandler = nil	-- Clothing stripping handler (loaded if ZomboLust is active)
local ZomboLust_SexualIntentSystem = nil	-- Bite-vs-sexual-animation roll handler (loaded if ZomboLust is active)

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local tonumber = tonumber
local tostring = tostring

--- Module name for logging
--- @type string
local MODULE_NAME = "Intercept"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboDesire.isDebug in ZomboDesire_Main.lua).
--- Calls with cheap/no arguments use ZomboDesire.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboDesire.isDebug(MODULE_NAME)
end

--- Constants
--- @type number
local ZOMBIE_PUSH_RADIUS = 3
--- @type number
local ZOMBHUMAN_TRANSFORM_DELAY_TICKS = 60 -- 60 ticks ≈ 1/2 second
-- ---@type number
-- local lastCollisionTime = 0 -- For collision throttling management

--- Specialized object offset mappings
--- Table that defines custom offset values for specific object types
--- Format: [object_type] = offset_value
--- These offsets are applied when the object is facing East or South (non-structural, non-counter objects)
--- @type table<string, number>
local SPECIALIZED_OBJECT_OFFSETS = {
    -- damaged_objects_01
    ["Damaged Public Mail Box"] = 1.25,
    -- fixtures_railings_01
    ["Railings"] = 0.5,
    -- location_business_distillery_01
    ["Distillery"] = 1.3,
    ["Distillery Barrel"] = 1.0,
    -- location_business_machinery_01
    ["Wood Top Workbench"] = 1.2,
    ["Tires Pile Small"] = 1.3,
    ["Tires Pile Big"] = 1.3,
    -- location_community_cemetary_01
    ["Arched Gravestone"] = 1.2,
    ["Square Gravestone"] = 1.2,
    ["Angelic Gravestone"] = 1.25,
    ["Cairn"] = 1.25,
    -- location_community_park_01
    ["Large Fountain"] = 1.3,
    ["Childrens Play Castle"] = 1.3,
    -- location_community_police_01
    ["Police Prisoners Bed"] = 1.25,
    -- location_entertainment_gallery_02
    ["Male Bust"] = 1.25,
    ["Female Bust"] = 1.25,
    ["Female Statue"] = 1.25,
    ["Male Statue"] = 1.25,
    ["Gallery Toilet"] = 1.25,
    ["Gallery Bed"] = 1.25,
    ["Famous Man Statue"] = 1.25,
    ["Giant Horseman Statue"] = 1.25,
    ["Giant Horse Statue"] = 1.25,
    -- location_farm_accesories_01
    ["DogHouse"] = 1.3,
    ["Large Animal Feeder"] = 1.2,
    ["Small Animal Feeder"] = 1.2,
    ["Large Metal Feeder With Roof"] = 1.3,
    ["Long Cattle Feeder"] = 1.25,
    ["Short Cattle Feeder"] = 1.25,
    ["Chicken Coop"] = 1.25,
    -- location_hospitality_sunstarmotel_02
    ["Sunstarmotel Sign"] = 1.3,
    -- location_military_generic_01
    ["Military Crate"] = 1.25,
    ["Military Locker"] = 1.0,
    ["Target Panel"] = 1.3,
    -- location_military_knox_01
    ["Small Pallet Gold"] = 1.3,
    ["Large Pallet Gold"] = 1.3,
    ["Welcome Knox"] = 1.3,
    -- location_restaurant_diner_01
    ["50s Diner Table"] = 1.3,
    -- location_restaurant_pileocrepe_01
    ["Large Bleached Table"] = 1.3,
    ["Light Wood Restaurant Table"] = 1.3,
    -- location_restaurant_pizzawhirled_01
    ["Garbage Bin"] = 1.3,
    ["Pizza Whirled Table"] = 1.3,
    -- location_restaurant_spiffos_02
    ["Spiffo Type B Table"] = 1.35,
    ["Spiffo Type A Table"] = 1.35,
    -- location_shop_accessories_genericsigns_01
    ["For Sale Sign"] = 1.3,
    -- security_01
    ["Security Terminal"] = 1.3,
    ["Security Wall Monitors"] = 0.7,
    -- signs_one-off_01
    ["Pony Roam Sign"] = 1.3,
--	["Riverside Suites Sign"] = 1.3,
    -- street_decoration_01
    ["Public Mail Box"] = 1.25,
    ["Pay Phones"] = 0.75,
    ["Concrete Road Block"] = 1.0,
    ["Small Newspaper Vending Machine"] = 1.25,
    ["Large Newspaper Vending Machine"] = 1.25,
    -- vegetation_farm_01
    ["Single Stacked Hay"] = 1.2,
    ["Double Stacked Hay"] = 1.2,
    -- vegetation_indoor_01
    ["Raised Plantbed"] = 1.25,
    -- fixtures_doors_01 + fixtures_doors_02 + fixtures_doors_fences_01
    ["Open Door"] = 0.7,
    ["Open High Fence Door"] = 0.7,
    ["Open Low Fence Door"] = 0.7,
    -- appliances_com_01
    ["CeroSec Terminal"] = 1.25,
    -- appliances_cooking_01
    ["Green Oven"] = 1.0,
    ["Red Oven"] = 1.0,
    ["Modern Oven"] = 1.0,
    ["Industrial Oven"] = 1.0,
    ["Fryers Club Industrial 2000 Oven"] = 1.0,
    ["Old Stove Oven"] = 1.0,
    ["Crafted Oven"] = 1.0,
    -- appliances_refrigeration_01
    ["Fridge"] = 1.2,
    ["Other Fridge"] = 1.0,
    ["Chest Freezer"] = 1.0,
    -- appliances_television_01
    ["TV"] = 1.0,
    -- camping_01
    ["Picnic Table"] = 1.4,
    ["Composter"] = 1.25,
    ["Small Stack Log"] = 1.25,
    ["Large Stack Log"] = 1.25,
    -- carpentry_01
    ["Wooden Crate"] = 1.25,
    -- construction_01
    ["Road Block"] = 1.3,
    ["Pallet Brick"] = 1.3,
    -- fixtures_bathroom_01
    ["Fancy Toilet"] = 1.25,
    ["Low Toilet"] = 1.25,
    ["Hanging Toilet"] = 0.7,
    ["Shower screen"] = 0.5,
    ["Large Deluxe Bath"] = 1.25,
    -- fixtures_sinks_01
    ["White Standing Sink"] = 1.0,
    ["White Hanging Sink"] = 1.0,
    ["Fancy Hanging Sink"] = 1.0,
    ["Large Industrial Sink"] = 1.3,
    -- furniture_bedding_01
    ["Baby Crib Bed"] = 1.2,
    -- furniture_seating_indoor_01
    ["Red Comfy Couch"] = 1.2,
    ["Green Comfy Couch"] = 1.2,
    ["Purple Rattan Couch"] = 1.2,
    -- furniture_seating_indoor_02
    ["Sturdy Bench"] = 1.2,
    ["White Lazy Couch"] = 1.2,
    ["Blue Rattan Couch"] = 1.2,
    ["Brown Lazy Couch"] = 1.2,
    -- furniture_seating_indoor_03
    ["Grey Lazy Couch"] = 1.2,
    ["Yellow Modern Couch"] = 1.2,
    ["Blue Comfy Couch"] = 1.2,
    ["Victorian C1 Couch"] = 1.05,
    ["Victorian C2 Couch"] = 1.0,
    ["Victorian C3 Couch"] = 1.0,
    ["Victorian C4 Couch"] = 1.3,
    ["Victorian C5 Couch"] = 1.3,
    ["Victorian C6 Couch"] = 1.25,
    -- furniture_shelving_01
    ["Big Wall Shelves"] = 1.0,
    ["Corner A Shelves"] = 0.9,
    ["Middle Shelves"] = 0.9,
    ["Corner B Shelves"] = 0.9,
    ["Large Low Shelves"] = 0.9,
    ["Large Metal Shelves"] = 1.15,
    ["Oakwood Shelves"] = 1.0,
    ["White Fancy Shelves"] = 1.0,
    -- furniture_storage_01
    ["Fancy Drawers"] = 1.0,
    ["Fancy Oak Drawers"] = 1.0,
    ["Dark Fancy Drawers"] = 1.0,
    ["Mirror And Drawers"] = 1.0,
    ["Light Wood Drawers"] = 1.0,
    ["Bedroom Drawers"] = 1.0,
    ["Quality Crafted Table"] = 1.0,
    -- furniture_storage_02
    ["Blue Wall Locker"] = 0.9,
    ["Small Locker"] = 0.9,
    ["Big Locker"] = 0.9,
    ["Large Cardboard Box"] = 1.25,
    -- furniture_tables_high_01
    ["Large Dark Oak Table"] = 1.25,
    ["Long Table"] = 1.0,
    ["Oak Round Table"] = 1.2,
    ["Light Round Table"] = 1.2,
    ["Large Brown Table"] = 1.25,
    ["Long Light Table"] = 1.0,
    ["Round Table"] = 1.2,
    ["Fancy Table"] = 1.25,
    ["Fancy Dark Table"] = 1.25,
    ["Large Dark Table"] = 1.25,
    ["Long Dark Table"] = 1.0,
    ["Dark Round Table"] = 1.2,
    ["Large Light Table"] = 1.25,
    ["Large Oak Table"] = 1.25,
    ["Broad White Table"] = 1.25,
    ["Large Dark Wooden Table"] = 1.25,
    ["Plastic Table"] = 1.2,
    ["Large Smooth Table"] = 1.25,
    ["Large Simple Table"] = 1.2,
    ["Large Plastic Table"] = 1.25,
    ["Large Light Oak Table"] = 1.25,
    -- location_business_office_generic_01
    ["Office Desk"] = 1.25,
    ["White File Cabinet"] = 1.25,
    ["Water Dispenser"] = 1.2,
    ["Empty Water Dispenser"] = 1.2,
    -- location_community_medical_01
    ["Dentist Patient Bed"] = 1.3,
    ["Large Medical Bed"] = 1.3,
    ["Patient Bed"] = 1.3,
    ["Medical Drawers"] = 1.0,
    ["Medical Waiting Chair"] = 1.3,
    ["Baby Incubator"] = 1.3,
    ["Mortuary Storage"] = 0.6,
    ["Hospital Bed"] = 1.3,
    ["Table Morgue"] = 1.25,
    ["Blood Bank"] = 1.25,
    ["Wide Medical Cabinet"] = 1.25,
    -- location_entertainment_theatre_01
    ["Large Rental Shelves"] = 1.0,
    ["Small Rental Shelves"] = 1.0,
    -- location_restaurant_bar_01
    ["Leather Bar Seat"] = 1.2,
    ["Large Bar Stool"] = 1.05,
    ["Bar Stool"] = 1.0,
    ["Left Bar Wall Bar"] = 1.0,
    ["Bar Wall Bar"] = 1.0,
    ["Right Bar Wall Bar"] = 1.0,
    -- location_restaurant_generic_01
    ["Corner A Glass"] = 1.25,
    ["Middle Glass"] = 1.25,
    ["Corner B Glass"] = 1.25,
    -- location_shop_generic_01
    ["Comics Shop Shelves"] = 1.35,
    ["Beige Magazine Shop Shelves"] = 1.25,
    ["Beige Rack Shop Shelves"] = 1.3,
    ["Regular Magasine Rack"] = 1.25,
    ["Rounded Glass Display Counter"] = 1.05,
    ["Large Clothes Rack"] = 1.3,
    ["Generic Cooled Shelves"] = 1.25,
    ["Large Shop Shelves"] = 1.25,
    ["Shop Display Counter"] = 1.3,
    ["Fancy Wooden Shop Shelves"] = 1.25,
    ["Trapezoid Shop Shelves"] = 1.3,
    ["Glass Corner Display Counter"] = 1.3,
    ["Glass Display Counter"] = 1.3,
    ["Generic Shop Shelves"] = 1.3,
    -- location_shop_zippee_01
    ["Zippee Low Wall Shelves"] = 1.25,
    ["Zippee Shelves Rack"] = 1.25,
    ["Red Magazine Shelf"] = 1.25,
    ["Slurp Burp Soda Machine"] = 1.0,
    ["Zippee Display Counter"] = 1.0,
    -- recreational_01
    ["Oldies Jukebox"] = 1.25,
    ["Pool Table"] = 1.3,
    ["Dr Oids Arcade"] = 1.25,
    ["Kaboom Arcade"] = 1.25,
    ["PAWS Pinball"] = 1.0,
    ["Black Grand Piano"] = 1.3,
    -- trashcontainers_01
    ["Wheelie Bin"] = 1.25,
    ["Blue Dumpster"] = 1.3,
    ["Orange Dumpster"] = 1.3,
    -- furniture_tables_high_02
    ["Very Long Large Table"] = 1.25,
    -- industry_03
    ["Heavy Industry Machine"] = 1.25,
    ["Heavy Industry Table"] = 1.25,
    -- signs_church
    ["What Missing Sign"] = 1.25,
    ["Hungry Desert Sign"] = 1.25,
    ["Burn In Hell Sign"] = 1.25,
    ["Jesus Carry Sign"] = 1.25,
    ["Jesus Save Sign"] = 1.25,
    ["Lord Shepherd Sign"] = 1.25,
    ["God Knox Sign"] = 1.25,
    ["Service Daily Sign"] = 1.25,
    ["God Watching Sign"] = 1.25,
    ["Satan Domain Sign"] = 1.25,
    ["Evening Service Sign"] = 1.25,
    ["Devious Gooses Sign"] = 1.25,
    ["Chris Died Sign"] = 1.25,
    ["Lord Forsaken Sign"] = 1.25,
    ["To 19 Sign"] = 1.25,
    ["God Will Sign"] = 1.25,
    -- advertising_02
    ["Advertising Mall"] = 1.15,
    -- signs_one-off_07
    ["Hodgetts Sign"] = 1.25,
    -- crafted_01
    ["Crafted Metal Drum"] = 1.3,
    -- fixtures_escalators_01
    ["Escalator Door"] = 0.7,
    -- industry_02
    ["Mechanical Conveyor"] = 1.2,
    ["Various Machinery"] = 1.35,
    ["Automatic Machinery"] = 1.3,
    ["Industrial Electrical Panel"] = 1.0,
    ["Industrial Jigsaw"] = 1.3,
    -- location_business_bank_01
    ["Standing Vault"] = 1.25,
    ["ATM Machine"] = 1.25,
    ["Bank Vault"] = 1.25,
    -- location_restaurant_pie_01
    ["Pie Display Stand"] = 1.25,
    -- location_shop_fossoil_01
    ["Gas Pump"] = 1.25,
    ["Out of Gas"] = 1.15,
    ["Blue Magazine Shelf"] = 1.3,
    ["Fossoil Low Shelves"] = 1.3,
    -- location_shop_gas2go_01
    ["Gas2Go Low Shelves"] = 1.3,
    -- location_shop_mall_01
    ["Mall Table"] = 1.3,
    ["Mall Map"] = 1.0,
    ["Mall Central Block"] = 1.2,
    ["Brick Planter"] = 1.2,
    ["Mall Garbage Bin"] = 1.3,
    ["Mannequin"] = 1.2,
    -- recreational_sports_01
    ["Gym Treadmills"] = 1.2,
    ["Tennis Net"] = 0.7,
    ["Bowling Rack"] = 0.7,
    -- location_shop_greenes_01
    ["Grocery Trapezoid Counter"] = 1.25,
    ["Greene Grocery Display Counter"] = 1.3,
}

-- ==================
-- Utility functions
-- ==================

--- Utility function to determine character gender
--- @param character IsoGameCharacter -- The character whose gender needs to be determined
--- @return string -- Returns 'M' for male and 'F' for female
local function determineGender(character)
    return character:isFemale() and "F" or "M"
end

--- Utility function to check if a mod is enabled
--- @param modName string -- Name of the mod to check
--- @param debugMode? boolean -- Optional debug mode to print all activated mods
local function isModActivated(modName, debugMode)
    local activatedMods = getActivatedMods()
    local size = activatedMods:size()

    -- Debug: print all activated mods if debug mode is enabled
    if debugMode then
        print("[ZomboDesire FrameWork] Checking for mod " .. modName)
        print("[ZomboDesire FrameWork] Total activated mods " .. size)
        for i = 0, size - 1 do
            print("[ZomboDesire FrameWork] Mod [" .. i .. "] '" .. activatedMods:get(i) .. "'")
        end
    end

    -- Check if the mod is in the list
    local isFound = false
    for i = 0, size - 1 do
        if activatedMods:get(i) == modName then
            isFound = true
            break
        end
    end

    if isFound then
        if debugMode then print("[ZomboDesire FrameWork] Mod '" .. modName .. "' FOUND!") end
        return true
    end

    if debugMode then
        print("[ZomboDesire FrameWork] Mod '" .. modName .. "' NOT FOUND")
    end
    return false
end

-- Deferred action helper, centralized in ZomboDesire_Utils.lua
local createDelayedAction = ZomboDesire_Utils.createDelayedAction

--- Forward declaration for circular references
--- @type function
local ZomboDesire_HandleGenderMismatch

-- ==========================
-- Precise collision handler
-- ==========================
--- Forward declaration for collisionListener
--- @type function
local collisionListener

--- Temporarily disables the collision listener for a fixed number of ticks, then re-enables it.
--- Used by the handleXXX guards below, each of which only decides whether and for how long to suspend the listener.
--- @param ticks number -- Number of ticks to wait before re-enabling the listener
--- @param reason string -- Short description of why the listener was suspended (used in the re-enable log)
local function suspendCollisionListener(ticks, reason)
    -- Disable collision listener temporarily
    Events.OnCharacterCollide.Remove(collisionListener)
    ZomboDesire.isCollisionListenerRegistered = false

    -- Schedule re-enabling the collision listener after the given number of ticks
    local currentTick = 0
    local function reEnableCollisionListener()
        currentTick = currentTick + 1
        if currentTick < ticks then return end

        -- Remove this tick handler
        Events.OnTick.Remove(reEnableCollisionListener)

        -- Re-enable collision listener
        if not ZomboDesire.isCollisionListenerRegistered then
            Events.OnCharacterCollide.Add(collisionListener)
            ZomboDesire.isCollisionListenerRegistered = true
            ZomboDesire.debugLog(MODULE_NAME, "Re-enabled collision listener after %s", reason)
        end
    end

    Events.OnTick.Add(reEnableCollisionListener)
end

--- Temporarily disables the collision listener until a condition clears, then re-enables it.
--- Same rationale as suspendCollisionListener, but for guards that must wait on a state (polled every tick) instead of a fixed duration.
--- @param stillActiveFn fun():boolean -- Polled every tick; listener is re-enabled once this returns false
--- @param reason string -- Short description of why the listener was suspended (used in the re-enable log)
local function suspendCollisionListenerUntil(stillActiveFn, reason)
    -- Disable collision listener
    Events.OnCharacterCollide.Remove(collisionListener)
    ZomboDesire.isCollisionListenerRegistered = false

    -- Monitor state to re-enable collision listener once it clears
    local function monitorState()
        if stillActiveFn() then return end

        -- Remove this monitor
        Events.OnTick.Remove(monitorState)

        -- Re-enable collision listener
        if not ZomboDesire.isCollisionListenerRegistered then
            Events.OnCharacterCollide.Add(collisionListener)
            ZomboDesire.isCollisionListenerRegistered = true
            ZomboDesire.debugLog(MODULE_NAME, "Re-enabled collision listener after %s", reason)
        end
    end

    Events.OnTick.Add(monitorState)
end

--- Handles the case when a player is running or sprinting during collision
--- @param player IsoPlayer -- The player to check
--- @return boolean -- Returns true if the collision should be ignored due to running
local function handleRunningPlayer(player)
    if player:isRunning() or player:isSprinting() then
        ZomboDesire.debugLog(MODULE_NAME, "Player is running or sprinting, ignoring collision and disabling listener for 180 ticks")
        suspendCollisionListener(180, "running cooldown") -- 180 ticks ≈ 1 second and a half
        return true -- Collision should be ignored
    end

    return false -- Collision should not be ignored due to running
end

--- Handles the case when a player is in PlayerFallingState during collision
--- @param player IsoPlayer -- The player to check
--- @param currentStateName string|nil -- The current state name of the player
--- @return boolean -- Returns true if the collision should be ignored due to player falling state
local function handleFallingPlayer(player, currentStateName)
    if currentStateName and currentStateName == "PlayerFallingState" then
        ZomboDesire.debugLog(MODULE_NAME, "Player is in PlayerFallingState, ignoring collision for 120 ticks")
        suspendCollisionListener(120, "falling state cooldown") -- 120 ticks ≈ 1 second
        return true -- Collision should be ignored
    end

    return false -- Collision should not be ignored due to falling state
end

--- Handles the case when a player is in BumpedState during collision
--- Prevents rapid collisions while the player is stumbling or being pushed
--- @param player IsoPlayer -- The player who collided
--- @param currentStateName string|nil -- The current state name of the player
--- @return boolean -- True if collision should be ignored
local function handleBumpedPlayer(player, currentStateName)
    -- In B42, BumpedState is a common state when being shoved or stumbling
    if currentStateName and currentStateName == "BumpedState" then
        ZomboDesire.debugLog(MODULE_NAME, "Player is in BumpedState, ignoring collision")
        return true -- Collision should be ignored
    end

    return false -- Collision should not be ignored
end

--- Handles the case when a player is sitting on ground during collision
--- With vanilla code:
--- If the player is sitting on an object, they will automatically stand up when a zombie approaches -> nothing special to do
--- If the player is sitting on the ground, they won't stand up even if a zombie approaches -> our code forces the player to stand up
--- @param player IsoPlayer -- The player to check
--- @param currentStateName string|nil -- The current state name of the player
--- @return boolean -- Returns true if the collision should be ignored due to sitting
local function handleSittingPlayer(player, currentStateName)
    if currentStateName and currentStateName == "PlayerSitOnGroundState" then
        ZomboDesire.debugLog(MODULE_NAME, "Player is sitting on ground, forcing stand up and ignoring collision for 60 ticks")

        -- Force player to stand up
        ISTimedActionQueue.clear(player)
        player:setVariable("forceGetUp", true)

        suspendCollisionListener(60, "player stands up") -- 60 ticks ≈ 1/2 second
        return true -- Collision should be ignored
    end

    return false -- Collision should not be ignored due to sitting
end

--- Handles the case when a player is climbing through a window during collision
--- @param player IsoPlayer -- The player to check
--- @param currentStateName string|nil -- The current state name of the player
--- @return boolean -- Returns true if the collision should be ignored due to window climbing
local function handleWindowClimbingPlayer(player, currentStateName)
    -- Check if player is currently climbing through a window
    if currentStateName and currentStateName == "ClimbThroughWindowState" then
        ZomboDesire.debugLog(MODULE_NAME, "Player is climbing through a window, ignoring collision for 60 ticks")
        suspendCollisionListener(60, "window climbing cooldown") -- 60 ticks ≈ 1/2 second
        return true -- Collision should be ignored
    end

    return false -- Collision should not be ignored due to window climbing
end

--- Handles the case when a player is damaged (bleeding, wounded, on fire, sickness, disease, etc.)
--- @param player IsoPlayer -- The player to check
--- @return boolean -- Returns true if the collision should be ignored due to player being damaged
local function handleDamagedPlayer(player)
    -- Check if player is on fire
    if player:isOnFire() then
        ZomboDesire.debugLog(MODULE_NAME, "Player is on fire, ignoring collision")
        return true -- Collision should be ignored
    end

    -- Check body parts for damage
    local bodyDamage = player:getBodyDamage()
    local bodyParts = bodyDamage:getBodyParts()

    -- Iterate through all body parts
    for i = 0, bodyParts:size() - 1 do
        local bodyPart = bodyParts:get(i)

        -- Check for various types of damage
        if bodyPart:bleeding() or 
           bodyPart:isDeepWounded() then

            if dbg() then
                ZomboDesire.debugLog(MODULE_NAME, "Player is injured (%s%s), ignoring collision",
                    bodyPart:bleeding() and "bleeding" or "",
                    bodyPart:isDeepWounded() and "deepWounded" or "")
            end

            ZomboDesire_Utils.sayAnimationInterrupted(player)

            suspendCollisionListener(60, "injury cooldown") -- 60 ticks ≈ 1/2 second
            return true -- Collision should be ignored
        end
    end

    return false -- Collision should not be ignored due to player being damaged
end

--- Handles the case when a player is grappling a corpse
--- @param player IsoPlayer -- The player to check
--- @return boolean -- Returns true if the collision should be ignored due to player grappling a corpse
local function handleGrapplingPlayer(player)
    -- Check if player is dragging/grappling a corpse
    if player:isDraggingCorpse() then
        ZomboDesire.debugLog(MODULE_NAME, "Player is grappling a corpse, disabling collision listener until grapple is released")
        suspendCollisionListenerUntil(function() return player:isDraggingCorpse() end, "grapple released")
        return true -- Collision should be ignored
    end

    return false -- Collision should not be ignored due to grappling
end

--- Function to check if a zombie is performing an action that should invalidate the collision
--- @param collidedChar IsoGameCharacter -- The character to check (zombie)
--- @return boolean -- Returns true if the collision should be ignored, otherwise returns false
local function isPerformingInvalidAction(collidedChar)
     -- Check the current state of the zombie
    local currentState = collidedChar:getCurrentState()

    -- NOTE: AttackState/isAttacking()/isZombieAttacking() is NOT checked here as an invalid state.
    -- Confirmed by live logging: the zombie is essentially ALWAYS in AttackState at the
    -- exact instant a valid melee collision fires (the physical contact IS the attack windup on the engine side).
    -- Treating it as invalid rejected ~100% of collisions.
    -- The actual fix is to forcibly interrupt the in-progress AttackState
    -- (see setStaggerBack(true) in ZomboDesireOnCollide) rather than to reject the collision.

    -- If the zombie is in BumpedState, ignore the collision
    if currentState and instanceof(currentState, "BumpedState") then
        ZomboDesire.debugLog(MODULE_NAME, "Zombie is bumped, ignoring collision")
        return true
    end

    -- Check if the zombie is going through a window or over an obstacle
    if currentState and (instanceof(currentState, "ClimbThroughWindowState") or 
                         instanceof(currentState, "ClimbOverFenceState") or
                         instanceof(currentState, "ClimbOverWallState")) then
        ZomboDesire.debugLog(MODULE_NAME, "Zombie goes through a window or over an obstacle, ignoring collision")
        return true
    end

    -- Check if the zombie is falling
    if currentState and instanceof(currentState, "ZombieFallDownState") then
        ZomboDesire.debugLog(MODULE_NAME, "Zombie is falling down, ignoring collision")
        return true
    end

    -- Check if the zombie is on the ground
    if currentState and instanceof(currentState, "ZombieOnGroundState") then
        ZomboDesire.debugLog(MODULE_NAME, "Zombie is on ground, ignoring collision")
        return true
    end

    -- Check other states that should invalidate the collision
    if currentState and (instanceof(currentState, "ZombieGetUpState") or
                         instanceof(currentState, "ZombieGetDownState") or
                         instanceof(currentState, "ZombieSittingState") or
                         instanceof(currentState, "LungeState") or
                         instanceof(currentState, "FakeDeadZombieState") or
                         instanceof(currentState, "CrawlingZombieTurnState") or
                         instanceof(currentState, "ZombieReanimateState") or
                         instanceof(currentState, "StaggerBackState") or
                         instanceof(currentState, "ThumpState") or
                         instanceof(currentState, "SmashWindowState")) then
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Zombie is in special state (%s), ignoring collision", tostring(currentState))
        end
        return true
    end

    -- No invalid state detected
    ZomboDesire.debugLog(MODULE_NAME, "No invalid current action detected")
    return false
end

--- Handles collision events between player and other characters
--- @param player IsoPlayer -- The player involved in the collision
--- @param collidedChar IsoZombie -- The zombie or ZombHuman that collided with the player
collisionListener = function(player, collidedChar)
    -- Throttling system disabled: was causing unexpected cancellations even with low zombie counts.
    -- Re-enable only for extreme populations (e.g., X16) if CPU performance becomes a critical issue.
    --[[
    -- Throttling : guarantee that only one collision is handled every 100 ms (reduce CPU usage in case of too many zombies)
    -- getWorldAgeHours() returns elapsed hours since world start. We convert to seconds (* 3600).
    local now = getGameTime():getWorldAgeHours() * 3600
    local minInterval = 0.1  -- 100ms
    if lastCollisionTime and (now - lastCollisionTime < minInterval) then
        if ZomboDesire.Debug.enabled and ZomboDesire.Debug.modules[MODULE_NAME] then
            ZomboDesire.debugLog(MODULE_NAME, "Collision ignored (throttling): %s ms since last collision", tostring(math.floor((now - lastCollisionTime) * 1000)))
        end
        return
    end
    lastCollisionTime = now
    ]]

    -- We are only interested if the player is an IsoPlayer
    if player ~= getPlayer() then return end

    -- Cache player state name once for all sub-handlers (Performance optimization)
    local currentStateName = player:getCurrentStateName()

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "IsoPlayer vs IsoZombie detected (State: %s) -> proceed", tostring(currentStateName))
    end

    -- Check if the player is running or sprinting
    if handleRunningPlayer(player) then return end

    -- Check if player is falling, on ground, or bumped
    if handleFallingPlayer(player, currentStateName) or handleBumpedPlayer(player, currentStateName) then return end

    -- Check if player is sitting on ground
    if handleSittingPlayer(player, currentStateName) then return end

    -- Check if player is climbing through a window
    if handleWindowClimbingPlayer(player, currentStateName) then return end

    --  Check if player is damaged (on fire, recently took damage, etc.)
    if handleDamagedPlayer(player) then return end

    -- Check if player is grappling a corpse
    if handleGrapplingPlayer(player) then return end

    -- Ensure collidedChar is not nil before proceeding
    if not collidedChar then
        ZomboDesire.warningLog(MODULE_NAME, "Collided Character is nil, ignoring")
        return
    end

    -- A valid attacker (collidedChar) must be a zombie
    -- A Bandit (collidedChar) is not a valid attacker
    -- A ZombHuman (collidedChar) is not a valid attacker
    local modData = collidedChar:getModData()
    local isZombie = collidedChar:isZombie()
    local isBandit = modData.isBandit
    local isZombHuman = modData.zombHumanBrain ~= nil

    -- 1. Must be a zombie (excludes animals/players)
    if not isZombie then
        ZomboDesire.debugLog(MODULE_NAME, "Collided Character is not a zombie (maybe an animal?), ignoring")
        return
    end

    -- 2. Exclude special types with distinct logs
    if isBandit then
        -- Test to ensure that ZomboDesire remains compatible with the Bandits mod, since bandits are IsoZombie
        -- This compatibility simply prevents a crash caused by a bandit (a zombie with a brain) also receiving a ZombHumanBrain
        ZomboDesire.debugLog(MODULE_NAME, "Collided Character is a Bandit, ignoring to avoid conflict")
        return
    end

    if isZombHuman then
        ZomboDesire.debugLog(MODULE_NAME, "Collided Character is already a ZombHuman (highly unlikely!), ignoring")
        return
    end

    ZomboDesire.debugLog(MODULE_NAME, "Valid standard zombie detected colliding with player")

    -- Check if zombie is performing an invalid action
    if isPerformingInvalidAction(collidedChar) then
        return -- Collision is ignored if zombie is performing an invalid action
    end

    ZomboDesire.debugLog(MODULE_NAME, "Current actions verified and none invalidating, we continue")

    -- For zombies, false positives are filtered by a true adjacency test
    if isZombie and not ZomboDesire_Detection.isAdjacent(player, collidedChar) then
        ZomboDesire.warningLog(MODULE_NAME, "Not adjacent, ignoring")
        return
    end

    if isZombie then
        ZomboDesire.debugLog(MODULE_NAME, "True contact detected")
    end

    -- True valid contact: we trigger the main handler logic
    ZomboDesireOnCollide(player, collidedChar)
end

--- Exposing the reference for later reuse in ZomboDesire_EscapeHandler.lua
ZomboDesire.collisionListener = collisionListener

--- Exposing suspendCollisionListener as public API:
--- external mods (like ZomboLust) that need to temporarily disable collision detection for a fixed duration should call this
--- instead of reimplementing the Remove/Add + isCollisionListenerRegistered bookkeeping themselves - doing it by hand elsewhere
--- risks desyncing from a concurrent suspend/resume triggered from within ZomboDesire itself
--- (see suspendCollisionListener/suspendCollisionListenerUntil above).
ZomboDesire.suspendCollisionListener = suspendCollisionListener

-- ============================================================
-- Function to transform zombie into a ZombHuman after a delay
-- ============================================================

--- Function to position a zombie relative to the player with dynamic offset
--- The zombie's offset is calculated proportionally based on the player's offset from the object
--- @param zombie IsoGameCharacter -- The zombie or ZombHuman
--- @param player IsoPlayer -- The player
--- @param relativePosition "FaceToFace"|"FaceToBack"|nil -- The relative position ("FaceToFace" or "FaceToBack")
--- @param playerOffsetAmount number -- The offset used for player positioning (determines zombie's offset via proportional ratio)
--- @return table -- Coords of the target position where the zombie should be placed
local function positionZombieRelativeToPlayer(zombie, player, relativePosition, playerOffsetAmount)
    player:setNoClip(true, false)
    ZomboDesire.debugLog(MODULE_NAME, "NoClip enabled on player to allow precise zombie positioning")

    -- Calculate the target position for the zombie
    local targetX = player:getX()
    local targetY = player:getY()

    -- Calculate zombie offset based on player offset using proportional ratio
    -- Base ratio: 0.5 works well with default player offset of 1.1
    local basePlayerOffset = 1.1
    local baseZombieOffset = 0.5
    local zombieOffset = playerOffsetAmount * (baseZombieOffset / basePlayerOffset)

    -- Adjust position based on player orientation
    local playerDir = player:getDir()

    -- Log the appropriate offset strategy based on player direction
    -- For N/W directions: fixed 0.5 offset is used (objects with 0.1 player offset)
    -- For E/S directions: dynamic offset is used (proportional to playerOffsetAmount)
    if playerDir == IsoDirections.N or playerDir == IsoDirections.W then
        ZomboDesire.debugLog(MODULE_NAME, "Positioning zombie with fixed offset 0.5 (object direction N/W, player offset %.2f)",
            playerOffsetAmount)
    else -- E or S
        ZomboDesire.debugLog(MODULE_NAME, "Positioning zombie with dynamic offset %.2f (object direction E/S, player offset %.2f)",
            zombieOffset, playerOffsetAmount)
    end

    if relativePosition == "FaceToFace" then
        -- The zombie must face the player
        ---@diagnostic disable: param-type-mismatch, assign-type-mismatch
        if playerDir == IsoDirections.N then
            targetY = targetY - 0.5  -- Zombie south of the player
            zombie:setDir(IsoDirections.S)
        elseif playerDir == IsoDirections.E then
            targetX = targetX + zombieOffset  -- Zombie west of the player
            zombie:setDir(IsoDirections.W)
        elseif playerDir == IsoDirections.S then
            targetY = targetY + zombieOffset  -- Zombie north of the player
            zombie:setDir(IsoDirections.N)
        elseif playerDir == IsoDirections.W then
            targetX = targetX - 0.5  -- Zombie east of the player
            zombie:setDir(IsoDirections.E)
        end
        ---@diagnostic enable: param-type-mismatch, assign-type-mismatch
    elseif relativePosition == "FaceToBack" then
        -- The zombie must be behind the player
        ---@diagnostic disable: assign-type-mismatch
        if playerDir == IsoDirections.N then
            targetY = targetY + 0.5  -- Zombie north of the player
        elseif playerDir == IsoDirections.E then
            targetX = targetX - zombieOffset  -- Zombie east of the player
        elseif playerDir == IsoDirections.S then
            targetY = targetY - zombieOffset  -- Zombie south of the player
        elseif playerDir == IsoDirections.W then
            targetX = targetX + 0.5  -- Zombie west of the player
        end
        ---@diagnostic enable: assign-type-mismatch

        -- Zombie faces the same direction as player
        ---@diagnostic disable-next-line: param-type-mismatch
        zombie:setDir(playerDir)
    end

    -- Move the zombie to the new position
    zombie:setX(targetX)
    zombie:setY(targetY)

    -- Sync zombie height to the player's height. Without this, the zombie keeps whatever stale Z
    -- it had before the teleport (e.g. mid-stairs), which desyncs it from the tile it now stands on.
    zombie:setZ(player:getZ())

    -- Save starting positions for validation in ZomboDesire_Staging.lua (validates protagonists haven't moved)
    ZomboDesire.animationStartPositions.playerX = player:getX()
    ZomboDesire.animationStartPositions.playerY = player:getY()
    ZomboDesire.animationStartPositions.zombieX = zombie:getX()
    ZomboDesire.animationStartPositions.zombieY = zombie:getY()
    ZomboDesire.debugLog(MODULE_NAME, "Saved starting positions - Player (%.2f, %.2f), Zombie (%.2f, %.2f)",
        ZomboDesire.animationStartPositions.playerX, ZomboDesire.animationStartPositions.playerY,
        ZomboDesire.animationStartPositions.zombieX, ZomboDesire.animationStartPositions.zombieY)

    return {x = targetX, y = targetY}
end

--- Enables NoClip on player and saves initial positions for validation
--- The actual zombie positioning happens in ZomboDesire_Staging.startScene after ZombHuman transformation
--- This allows the animation FBX to manage positioning and orientation
--- @param zombie IsoGameCharacter -- The zombie to monitor
--- @param player IsoPlayer -- The player reference
local function enableAnimationNoClip(zombie, player)
    -- STEP 1: Enable NoClip on player to allow zombie positioning without collision detection
    player:setNoClip(true, false)
    ZomboDesire.debugLog(MODULE_NAME, "NoClip enabled on player to allow precise zombie positioning")

    -- STEP 2: Save starting positions for validation in ZomboDesire_Staging.lua (validates protagonists haven't moved)
    ZomboDesire.animationStartPositions.playerX = player:getX()
    ZomboDesire.animationStartPositions.playerY = player:getY()
    ZomboDesire.animationStartPositions.zombieX = zombie:getX()
    ZomboDesire.animationStartPositions.zombieY = zombie:getY()
    ZomboDesire.debugLog(MODULE_NAME, "Saved starting positions - Player (%.2f, %.2f), Zombie (%.2f, %.2f)",
        ZomboDesire.animationStartPositions.playerX, ZomboDesire.animationStartPositions.playerY,
        ZomboDesire.animationStartPositions.zombieX, ZomboDesire.animationStartPositions.zombieY)

    -- Note: Actual zombie positioning at exact player coordinates occurs in ZomboDesire_AnimationHandler.lua
    -- within the queueAnimationActions function, overriding any previous positioning.
end

--- Determines the player's direction based on relative position and player side
--- @param relPos "FaceToFace"|"FaceToBack" -- Relative position to the object
--- @param side "Back"|"Front" -- Which side of the object the player is on
--- @param objDir IsoDirections -- The direction the object is facing
--- @return IsoDirections|nil -- The direction the player should face
local function getPlayerDirForPosition(relPos, side, objDir)
    -- Table mapping each direction to its opposite
    local oppositeDir = {
        [IsoDirections.N] = IsoDirections.S,
        [IsoDirections.S] = IsoDirections.N,
        [IsoDirections.E] = IsoDirections.W,
        [IsoDirections.W] = IsoDirections.E,
    }

    -- Determine if we need to use the opposite direction:
    -- - FaceToFace + Back side: player's back to object, so reverse direction
    -- - FaceToFace + Front side: player faces object, so use object's direction
    -- - FaceToBack + Back side: player faces object, so use object's direction
    -- - FaceToBack + Front side: player's back to object, so reverse direction
    local useOpposite = (relPos == "FaceToFace" and side == "Back") or
                        (relPos == "FaceToBack" and side == "Front")

    -- Return the appropriate direction
    if useOpposite then
        return oppositeDir[objDir]
    else
        return objDir
    end
end

--- Mappings for structural objects to simplify detection logic (Wall, Door, Fence, High Fence, Fence Door)
local STRUCTURAL_OBJECTS = {
    ["Wall"] = true,
    ["Door"] = true,
    ["Fence"] = true,
    ["High Fence"] = true,
    ["High Fence Door"] = true,
    ["Low Fence Door"] = true
}

--- Internal helper to handle FaceToFace positioning
--- @param player IsoPlayer -- The player
--- @param collidedChar IsoZombie -- The zombie
--- @param playerSide "Back"|"Front" -- Side of the object
--- @param objectDir IsoDirections -- Direction of the object
--- @param offsetAmount number -- Offset amount used for player
local function handleFaceToFacePositioning(player, collidedChar, playerSide, objectDir, offsetAmount)
    -- Player should have back to object (Opposite direction to object)
    -- Determine player direction based on side
    local playerDir = getPlayerDirForPosition("FaceToFace", playerSide, objectDir)

    -- Handle unknown player side
    if playerDir == nil then
        playerDir = player:getDir() -- Use current direction as fallback
        ZomboDesire.warningLog(MODULE_NAME, "Unknown player side '%s' for FaceToFace, using current direction", playerSide)
    end

    -- Set player direction
    --- @type IsoDirections
    playerDir = playerDir or player:getDir() -- Ensures that playerDir is not nil
    ---@diagnostic disable-next-line: param-type-mismatch
    player:setDir(playerDir)
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Player positioned with back to object, facing direction %s", tostring(playerDir))
    end

    -- Position zombie relative to player, passing the offsetAmount used for player positioning
    local zombiePos = positionZombieRelativeToPlayer(collidedChar, player, "FaceToFace", offsetAmount)
    ZomboDesire.debugLog(MODULE_NAME, "Zombie positioned to face player at %.2f, %.2f", zombiePos.x, zombiePos.y)
end

--- Internal helper to handle FaceToBack positioning
--- @param player IsoPlayer -- The player
--- @param collidedChar IsoZombie -- The zombie
--- @param playerSide "Back"|"Front" -- Side of the object
--- @param objectDir IsoDirections -- Direction of the object
--- @param offsetAmount number -- Offset amount used for player
local function handleFaceToBackPositioning(player, collidedChar, playerSide, objectDir, offsetAmount)
    -- The player must face the object or in the opposite direction depending on the side
    -- Determine player direction based on side
    local playerDir = getPlayerDirForPosition("FaceToBack", playerSide, objectDir)

    -- Handle unknown player side
    if playerDir == nil then
        playerDir = player:getDir() -- Use current direction as fallback
        ZomboDesire.warningLog(MODULE_NAME, "Unknown player side '%s' for FaceToBack, using current direction", playerSide)
    end

    --- @type IsoDirections
    playerDir = playerDir or player:getDir() -- Ensures that playerDir is not nil
    ---@diagnostic disable-next-line: param-type-mismatch
    player:setDir(playerDir)
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Player positioned facing %s, direction %s",
            playerSide == "Back" and "away from object" or "object", tostring(playerDir))
    end

    -- Position zombie relative to player, facing player's back, passing the offsetAmount used for player positioning
    local zombiePos = positionZombieRelativeToPlayer(collidedChar, player, "FaceToBack", offsetAmount)
    ZomboDesire.debugLog(MODULE_NAME, "Zombie positioned behind player, facing player's back at %.2f, %.2f", zombiePos.x, zombiePos.y)
end

--- Manages the positioning of the player and zombie relative to a detected object
--- @param player IsoPlayer -- The player involved in the collision
--- @param collidedChar IsoGameCharacter -- The zombie that collided with the player
--- @param detectedObject {object:IsoObject, type:string, spriteName:string, square:IsoGridSquare, relativeX:number, relativeY:number} -- The object detected near the player
--- @param relativePosition "FaceToFace"|"FaceToBack"|nil -- Relative position ("FaceToFace" or "FaceToBack")
local function handleObjectPositioning(player, collidedChar, detectedObject, relativePosition)
    ZomboDesire.debugLog(MODULE_NAME, "Using previously detected object for positioning -> %s at relative position %d,%d",
        detectedObject.type, detectedObject.relativeX, detectedObject.relativeY)

    -- Initialize offsetAmount with default value (will be adjusted based on object type)
    local offsetAmount = 1.1 -- Default offset for most objects

    -- Determine object direction using the sprite direction from ZomboDesire_ObjectTypes
    local objectDir = nil
    if detectedObject and detectedObject.object then
        -- Get the sprite name from the object
        local sprite = detectedObject.object:getSprite()
        if sprite then
            local spriteName = sprite:getName()

            -- Try to get the direction from ZomboDesire_ObjectTypes
            objectDir = ZomboDesire_ObjectTypes.getSpriteDirection(spriteName)

            if objectDir then
                if dbg() then
                    ZomboDesire.debugLog(MODULE_NAME, "Determined object direction from sprite %s -> %s", spriteName, tostring(objectDir))
                end
            else
                ZomboDesire.debugLog(MODULE_NAME, "No direction found for sprite %s, falling back to position-based direction", spriteName)
                -- Fallback to position-based direction
                if detectedObject.relativeX > 0 then
                    objectDir = IsoDirections.E -- East
                elseif detectedObject.relativeX < 0 then
                    objectDir = IsoDirections.W -- West
                elseif detectedObject.relativeY > 0 then
                    objectDir = IsoDirections.S -- South
                elseif detectedObject.relativeY < 0 then
                    objectDir = IsoDirections.N -- North
                else
                    -- Object is on same tile as player, use player's current direction
                    objectDir = player:getDir()
                end
                if dbg() then
                    ZomboDesire.debugLog(MODULE_NAME, "Determined object direction from position %s", tostring(objectDir))
                end
            end
        else
            ZomboDesire.warningLog(MODULE_NAME, "Object has no sprite, falling back to position-based direction")
            -- Fallback to position-based direction (same code as above)
            if detectedObject.relativeX > 0 then
                objectDir = IsoDirections.E -- East
            elseif detectedObject.relativeX < 0 then
                objectDir = IsoDirections.W -- West
            elseif detectedObject.relativeY > 0 then
                objectDir = IsoDirections.S -- South
            elseif detectedObject.relativeY < 0 then
                objectDir = IsoDirections.N -- North
            else
                -- Object is on same tile as player, use player's current direction
                objectDir = player:getDir()
            end
            if dbg() then
                ZomboDesire.debugLog(MODULE_NAME, "Determined object direction from position %s", tostring(objectDir))
            end
        end
    else
        ZomboDesire.warningLog(MODULE_NAME, "No valid object detected, using player's direction")
        objectDir = player:getDir()
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Using player's direction %s", tostring(objectDir))
        end
    end

    -- Determine which side of the object the player is on
    if not detectedObject.square then return end
    ---@type "Back"|"Front"
    local playerSide = ZomboDesire_Utils.determinePlayerSideOfObject(player, detectedObject.square, objectDir)
    ZomboDesire.debugLog(MODULE_NAME, "Player is on the %s side of the object", playerSide)

    -- Move player to the edge of the object (always)
    -- Place player on the object's square
    local targetX = detectedObject.square:getX()
    local targetY = detectedObject.square:getY()

    -- Determine if the object is a structural element
    local isStructural = detectedObject.type and STRUCTURAL_OBJECTS[detectedObject.type] or false

    -- Set offset amount based on object type
    -- Offset in the direction of the object. This places the player at the edge of the sprite
    offsetAmount = isStructural and 0.5 or 1.0 -- Half a tile for structural elements, full tile for others

    -- Check if the object is a Counter type and player is on the Back side
    local isCounter = false
    if detectedObject.type and playerSide == "Back" then
        -- Check if the type contains "Counter" (handles all types of counters)
        if string.find(detectedObject.type, "Counter") then
            isCounter = true
            offsetAmount = 1.3 -- Special offset for counters when player is on the Back side
            ZomboDesire.debugLog(MODULE_NAME, "Counter detected with player on Back side, using special offset amount %.1f",
                offsetAmount)
        end
    end

    -- For non-structural objects that are not counters on the back side, adjust offset based on object direction
    local shouldAdjust = not isStructural and not (isCounter and playerSide == "Back")

    if shouldAdjust and (objectDir == IsoDirections.W or objectDir == IsoDirections.N) then
        offsetAmount = 0.1 -- No offset for objects facing West or North
    elseif shouldAdjust and (objectDir == IsoDirections.E or objectDir == IsoDirections.S) then
        -- Check if this object type has a specialized offset defined
        local specializedOffset = SPECIALIZED_OBJECT_OFFSETS[detectedObject.type]
        offsetAmount = specializedOffset or 1.1 -- Default full tile offset for objects facing East or South

        if specializedOffset then
            ZomboDesire.debugLog(MODULE_NAME, "%s detected, using specialized offset amount %.1f",
                detectedObject.type, offsetAmount)
        end
    end

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Using offset amount %.1f for %s object facing %s",
            offsetAmount, isStructural and "structural" or "non-structural", tostring(objectDir))
    end

    -- IMPORTANT: Do not teleport the player to the other side of the object
    -- Determine effective movement direction based on player side
    -- We start with the object's direction (behavior for the "Back" side)
    local moveDir = objectDir
    if playerSide ~= "Back" then
        -- For "Front" side, we reverse the logic to stay on the correct side of the object
        if objectDir == IsoDirections.N then moveDir = IsoDirections.S
        elseif objectDir == IsoDirections.S then moveDir = IsoDirections.N
        elseif objectDir == IsoDirections.E then moveDir = IsoDirections.W
        elseif objectDir == IsoDirections.W then moveDir = IsoDirections.E
        end
    end

    -- Apply the translation based on the effective movement direction
    ---@diagnostic disable: assign-type-mismatch
    if moveDir == IsoDirections.N then
        -- Object facing North (Back side) or South (Front side): shift player North
        targetY = targetY + offsetAmount
        -- Center horizontally on the tile
        targetX = targetX + 0.5
    elseif moveDir == IsoDirections.E then
        -- Object facing East (Back side) or West (Front side): shift player West
        targetX = targetX - offsetAmount
        -- Center vertically on the tile
        targetY = targetY + 0.5
    elseif moveDir == IsoDirections.S then
        -- Object facing South (Back side) or North (Front side): shift player South
        targetY = targetY - offsetAmount
        -- Center horizontally on the tile
        targetX = targetX + 0.5
    elseif moveDir == IsoDirections.W then
        -- Object facing West (Back side) or East (Front side): shift player East
        targetX = targetX + offsetAmount
        -- Center vertically on the tile
        targetY = targetY + 0.5
    end
    ---@diagnostic enable: assign-type-mismatch

    -- Move player to new position
    player:setX(targetX)
    player:setY(targetY)

    ZomboDesire.debugLog(MODULE_NAME, "Player moved and centered to edge of object at %.2f, %.2f", targetX, targetY)

    -- Delay zombie positioning by 1 tick to give time for player position to be properly set
    createDelayedAction(1, function()
        if relativePosition == "FaceToFace" then
            handleFaceToFacePositioning(player, collidedChar, playerSide, objectDir, offsetAmount)
        elseif relativePosition == "FaceToBack" then
            handleFaceToBackPositioning(player, collidedChar, playerSide, objectDir, offsetAmount)
        end
    end)
end

--- Function to set orientation based on relative position
--- @param player IsoPlayer -- The player involved in the collision
--- @param collidedChar IsoGameCharacter -- The character that collided with the player
--- @param relativePosition "FaceToFace"|"FaceToBack"|nil -- Relative position ("FaceToFace" or "FaceToBack")
--- @param playerX number -- The player's X coordinate at collision
--- @param playerY number -- The player's Y coordinate at collision
local function setOrientationBasedOnPosition(player, collidedChar, relativePosition, playerX, playerY)
    -- 0) Log the initial state
    local initialAngle = player:getDirectionAngle()
    ZomboDesire.debugLog(MODULE_NAME, "Orientation: Initial player visual angle: %.2f degrees", initialAngle)

    -- 1) Get the player's current cardinal or diagonal direction
    local direction = player:getDir()

    -- 2) Snap the player to this direction
    player:setDir(direction --[[@as any]])
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Orientation: Player snapped to cardinal direction: %s (New angle: %.2f degrees)",
            tostring(direction), player:getDirectionAngle())
    end

    -- 3) Calculate X and Y coordinates to teleport the attacking zombie (with a margin of 2)
    -- X positive = East, X negative = West, Y positive = South, Y negative = North
    local dx = 0
    local dy = 0

    if direction == IsoDirections.N then
        dy = -1
    elseif direction == IsoDirections.NE then
        dx = 1
        dy = -1
    elseif direction == IsoDirections.E then
        dx = 1
    elseif direction == IsoDirections.SE then
        dx = 1
        dy = 1
    elseif direction == IsoDirections.S then
        dy = 1
    elseif direction == IsoDirections.SW then
        dx = -1
        dy = 1
    elseif direction == IsoDirections.W then
        dx = -1
    elseif direction == IsoDirections.NW then
        dx = -1
        dy = -1
    end

    local distance = 0.1
    local targetX, targetY

    if relativePosition == "FaceToFace" then
        -- Zombie is in front of the player
        targetX = playerX + (dx * distance)
        targetY = playerY + (dy * distance)
    else
        -- FaceToBack: Zombie is behind the player
        targetX = playerX - (dx * distance)
        targetY = playerY - (dy * distance)
    end

    ZomboDesire.debugLog(MODULE_NAME, "Orientation: Calculated target for zombie: (%.2f, %.2f) using dx=%d, dy=%d, distance=%.1f [%s]",
        targetX, targetY, dx, dy, distance, relativePosition)

    -- 4) Teleport the zombie to these new coordinates
    collidedChar:setX(targetX)
    collidedChar:setY(targetY)
    collidedChar:setLastX(targetX)
    collidedChar:setLastY(targetY)

    -- 5) Orient the zombie toward the player
    collidedChar:faceThisObject(player)

    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Orientation set - FINAL: Player at (%.2f, %.2f), Zombie at (%.2f, %.2f)",
            player:getX(), player:getY(), collidedChar:getX(), collidedChar:getY())
    end
end

--- Main function to schedule the transformation of a zombie into a ZombHuman after a delay
--- This delay is necessary for:
--- ensure that other zombies around were pushed away,
--- ensure that the player's walking animation is fully completed.
--- @param player IsoPlayer -- The player involved in the collision
--- @param collidedChar IsoZombie -- The zombie that will be transformed into a ZombHuman
--- @param forceModTag string|nil -- Optional tag to force ("Desire" or "Lust")
local function delayedZombHumanTransform(player, collidedChar, forceModTag)
    -- Get the relative position that was determined earlier
    local relativePosition = ZomboDesire.relativePosition
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Using relative position -> %s with forceModTag -> %s", relativePosition, tostring(forceModTag or "Desire"))
    end
    ZomboDesire.debugLog(MODULE_NAME, "Starting delayed ZombHuman transformation with %d ticks waiting period", ZOMBHUMAN_TRANSFORM_DELAY_TICKS)

    -- Check if we have an object interaction tag
    local objectInteractionTag = ZomboDesire.objectInteractionTag
    local detectedObject = ZomboDesire.detectedObject

    -- If we have an object interaction tag and a detected object, handle object positioning
    if objectInteractionTag and detectedObject then
        handleObjectPositioning(player, collidedChar, detectedObject, relativePosition)
    else
        -- No object detected: enable NoClip on player and save initial positions
        enableAnimationNoClip(collidedChar, player)
    end

    if objectInteractionTag and detectedObject then
        collidedChar:faceThisObject(player)
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Zombie ID %d oriented to face player (object interaction detected)", collidedChar:getID())
        end
    else
        local playerX = tonumber(ZomboDesire.animationStartPositions.playerX) --[[@as number]]
        local playerY = tonumber(ZomboDesire.animationStartPositions.playerY) --[[@as number]]
        setOrientationBasedOnPosition(player, collidedChar, relativePosition, playerX, playerY)
    end

    -- Diagnostic monitor: watches the zombie every tick during the transform delay window for a
    -- native attack-state transition, to correlate "phantom bite" reports with exact timing.
    -- Edge-triggered (logs only on state change) to avoid log spam.
    if dbg() then
        local monitorTicks = 0
        local wasAttacking = false
        local function attackWatchTick()
            monitorTicks = monitorTicks + 1
            if not collidedChar or not collidedChar:isAlive() or monitorTicks > ZOMBHUMAN_TRANSFORM_DELAY_TICKS then
                Events.OnTick.Remove(attackWatchTick)
                return
            end

            local isAtk = (collidedChar.isAttacking and collidedChar:isAttacking())
                or (collidedChar.isZombieAttacking and collidedChar:isZombieAttacking(player))

            if isAtk and not wasAttacking then
                ZomboDesire.debugLog(MODULE_NAME, "!!! ATTACK WATCH -> Zombie ID %d entered attack state at tick %d/%d during transform delay (isUseless=%s, target=%s)",
                    collidedChar:getID(), monitorTicks, ZOMBHUMAN_TRANSFORM_DELAY_TICKS,
                    tostring(collidedChar:isUseless()), tostring(collidedChar.getTarget and collidedChar:getTarget()))
            elseif not isAtk and wasAttacking then
                ZomboDesire.debugLog(MODULE_NAME, "ATTACK WATCH -> Zombie ID %d exited attack state at tick %d/%d",
                    collidedChar:getID(), monitorTicks, ZOMBHUMAN_TRANSFORM_DELAY_TICKS)
            end
            wasAttacking = isAtk
        end
        Events.OnTick.Add(attackWatchTick)
    end

    -- Create the deferred action for transformation
    createDelayedAction(ZOMBHUMAN_TRANSFORM_DELAY_TICKS, function()
        ZomboDesire.debugLog(MODULE_NAME, "Transformation delay complete after %d ticks, proceeding with ZombHuman transformation",
            ZOMBHUMAN_TRANSFORM_DELAY_TICKS)

        -- Sexual-intent roll resolved: this zombie is now actually committed to becoming a
        -- ZombHuman (transformation is about to run, whether it succeeds or not below) -
        -- remove its pink "elected" outline (if any) and its proximity-roll cache entry.
        -- Done here (transform time) rather than at the top of delayedZombHumanTransform
        -- (collision time) so the outline stays visible for the full ~60-tick approach
        -- window instead of vanishing the instant contact happens.
        if ZomboLust_SexualIntentSystem then
            ZomboLust_SexualIntentSystem.clearZombieIntent(collidedChar)
        end

        -- Check if everyone is still alive
        if not player or not collidedChar or not player:isAlive() or not collidedChar:isAlive() then
            ZomboDesire.errorLog(MODULE_NAME, "Player or zombie no longer valid, aborting transformation")
            return
        end

        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Zombie ID %d -> post-delay snapshot before transform: isAttacking=%s isZombieAttacking=%s target=%s",
                collidedChar:getID(),
                tostring(collidedChar.isAttacking and collidedChar:isAttacking()),
                tostring(collidedChar.isZombieAttacking and collidedChar:isZombieAttacking(player)),
                tostring(collidedChar.getTarget and collidedChar:getTarget()))
        end

        -- Maintain useless state to prevent native AttackState from triggering faceThisObject(player) while at distance 0 (teleported position)
        -- This avoids the 'IllegalStateException: Forward Direction cannot be zero length vector' error during positioning
        -- Track it in the global table only if it wasn't already useless
        if not collidedChar:isUseless() then
            collidedChar:setUseless(true)
            if ZomboDesire.neutralizedZombies then
                ZomboDesire.neutralizedZombies[collidedChar] = true
            end
        end

        -- Re-clear target/targetSeenTime in case the zombie's native AI re-acquired the player
        -- as a target at some point during the transform delay window
        ---@diagnostic disable-next-line: param-type-mismatch
        collidedChar:setTarget(nil)
        collidedChar:setTargetSeenTime(0)

        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Zombie ID %d -> useless state maintained and target re-cleared to prevent zero-length vector error during positioning", collidedChar:getID())
        end

        -- Transform zombie into ZombHuman with forceModTag
        local successTransform = ZomboDesire_TransformZombHuman.transformZombieIntoZombHuman(collidedChar, forceModTag)

        if not successTransform then
            ZomboDesire.errorLog(MODULE_NAME, "Failed to transform zombie ID -> %d into ZombHuman", collidedChar:getID())
            -- Re-enable collision listener if transformation failed
            Events.OnCharacterCollide.Add(collisionListener)
            ZomboDesire.isCollisionListenerRegistered = true
        else
            if dbg() then
                ZomboDesire.debugLog(MODULE_NAME, "Successfully transformed zombie ID -> %d into ZombHuman", collidedChar:getID())
            end
            -- Launch the scene
            ZomboDesire_Staging.startScene(player, collidedChar, forceModTag)
        end
    end)

    ZomboDesire.debugLog(MODULE_NAME, "Scheduled ZombHuman transformation after %d ticks cooling period", ZOMBHUMAN_TRANSFORM_DELAY_TICKS)
end

-- =========================================================
-- Function to handle the case playerGender ~= zombieGender
-- =========================================================
-- ------------------------------------------------------
-- Helper functions for ZomboDesire_HandleGenderMismatch
-- ------------------------------------------------------

--- Determines if the player is facing the zombie or if the zombie is behind the player
--- @param player IsoPlayer -- The player
--- @param zombie IsoGameCharacter -- The zombie
--- @return "FaceToFace"|"FaceToBack" FaceToFace if player is facing zombie, FaceToBack if zombie is behind player
local function determineRelativePosition(player, zombie)
    -- Use the built-in isFacingObject method to determine if player is facing the zombie
    local playerFacingZombie = player:isFacingObject(zombie, 0.5)

    -- Determine the relative position based on whether the player is facing the zombie
    local position
    if playerFacingZombie then
        position = "FaceToFace"
        ZomboDesire.debugLog(MODULE_NAME, "Collision -> Player is FACING the zombie -> Tag FaceToFace")
    else
        position = "FaceToBack"
        ZomboDesire.debugLog(MODULE_NAME, "Collision -> Zombie is BEHIND the player -> Tag FaceToBack")
    end

    return position
end

--- Handles gender conversion to animation tags
--- @param zombieGender string -- The gender of the zombie
local function handleGenderConversion(zombieGender)
    -- Convert gender to animation tag
    if zombieGender == "F" then
        ZomboDesire.zombieGenderTag = "ZF0"
    else
        ZomboDesire.zombieGenderTag = "ZM0"
    end
    ZomboDesire.debugLog(MODULE_NAME, "Converted zombie gender to animation tag -> %s", ZomboDesire.zombieGenderTag)
end

--- Handles object detection and tag setting
--- @param player IsoPlayer -- The player involved in the collision
local function handleObjectDetection(player)
    -- Detect objects on the player's tile
    local detectedObject = ZomboDesire_ObjectDetection.detectObjectOnPlayerTile(player)
    if detectedObject then
        ZomboDesire.debugLog(MODULE_NAME, "Object detected for specific animation -> %s", detectedObject.type)

        -- Store the detected object in the global ZomboDesire object
        ZomboDesire.detectedObject = detectedObject
        ZomboDesire.debugLog(MODULE_NAME, "Stored detected object in ZomboDesire.detectedObject")

        -- Determine the appropriate interaction tag based on the detected object
        local objectInteractionTag = ZomboDesire_ObjectTags.determineObjectInteractionTag(detectedObject)

        -- Store the object interaction tag in the global ZomboDesire object
        if objectInteractionTag then
            ZomboDesire.objectInteractionTag = objectInteractionTag
            ZomboDesire.debugLog(MODULE_NAME, "Set object interaction tag -> %s", objectInteractionTag)
        end
    else
        -- Clear any previously stored object and tag
        ZomboDesire.detectedObject = nil
        ZomboDesire.objectInteractionTag = nil
    end
end

--- Manages interaction between a player and a zombie of a different gender
--- @param player IsoPlayer -- The player who collided with the zombie
--- @param collidedChar IsoZombie -- The zombie that collided with the player
--- @param zombieGender string -- The gender of the zombie
--- @param forceModTag string|nil -- Optional tag to force ("Desire" or "Lust")
ZomboDesire_HandleGenderMismatch = function(player, collidedChar, zombieGender, forceModTag)
    -- Disable collision listener to avoid multi-spawn
    Events.OnCharacterCollide.Remove(collisionListener)
    ZomboDesire.isCollisionListenerRegistered = false
    ZomboDesire.debugLog(MODULE_NAME, "Collision detected -> handler removed")

    -- Push nearby zombies away before the zombie is transformed into a ZombHuman
    ZomboDesire.debugLog(MODULE_NAME, "Pushing nearby zombies away before transformation into ZombHuman.")
    ZomboDesire_Utils.pushNearbyZombies(collidedChar:getX(), collidedChar:getY(), collidedChar:getZ(), ZOMBIE_PUSH_RADIUS)

    -- Reset the cleanup flag before any new scene
    ZomboDesire.debugLog(MODULE_NAME, "Reseting cleanup flag before any new scene")
    ZomboDesire_Cleanup.resetCleanupFlag()

    -- Determine relative position and store it in global variable
    ZomboDesire.relativePosition = determineRelativePosition(player, collidedChar)
    ZomboDesire.debugLog(MODULE_NAME, "Relative position determined -> %s", ZomboDesire.relativePosition)

    -- Handle gender conversion to animation tags
    handleGenderConversion(zombieGender)

    -- Handle object detection and tag setting
    handleObjectDetection(player)

    -- Transform the zombie into a ZombHuman using delayed transformation
    delayedZombHumanTransform(player, collidedChar, forceModTag)
end

-- =====================
-- Main contact handler
-- =====================

--- Determines the forced animation tag based on player survival time and ZomboLust difficulty
--- @param player IsoPlayer -- The player character
--- @return string -- The forced mod tag (e.g., "Lust" or "Lust,EndGameShy")
local function getSurvivalForceModTag(player)
    -- Default thresholds (1 month ≈ 730 hours)
    local MONTH_1_HOURS = 730
    local MONTH_2_HOURS = 1460

    -- Difficulty adjustment
    local difficultyLevel = 1 -- Default to Casual
    if PZAPI and PZAPI.ModOptions then
        local options = PZAPI.ModOptions:getOptions("ZomboLust")
        if options then
            local difficultyOption = options:getOption("difficulty")
            if difficultyOption then
                ---@cast difficultyOption umbrella.ModOptions.ComboBox
                difficultyLevel = difficultyOption:getValue()
            end
        end
    end

    -- Handle Casual Mode (Level 1)
    if difficultyLevel == 1 then
        ZomboDesire.debugLog(MODULE_NAME, "ZomboLust Difficulty: Casual -> Everything unlocked")
        return "Lust"
    end

    -- Apply multiplier for Vicious Mode (Level 3)
    if difficultyLevel == 3 then
        MONTH_1_HOURS = MONTH_1_HOURS * 2 -- 1460h (2 months)
        MONTH_2_HOURS = MONTH_2_HOURS * 2 -- 2920h (4 months)
        ZomboDesire.debugLog(MODULE_NAME, "ZomboLust Difficulty: Vicious -> Double survival time required")
    else
        ZomboDesire.debugLog(MODULE_NAME, "ZomboLust Difficulty: Normal -> Standard survival time")
    end

    local hoursSurvived = player:getHoursSurvived()

    if hoursSurvived < MONTH_1_HOURS then
        -- Phase 1: Only Shy animations
        return "Lust,EndGameShy"
    elseif hoursSurvived < MONTH_2_HOURS then
        -- Phase 2: Shy and Regular animations
        return "Lust,EndGameShy,EndGameRegular"
    else
        -- Phase 3: All animations (including Hardcore)
        return "Lust"
    end
end

--- Handles non-sexual animations when ZomboLust is inactive
--- Only ever called for a gender mismatch: ZomboDesireOnCollide filters out same-gender
--- collisions (a normal bite) before neutralizing the zombie or calling this function at all
--- @param player IsoPlayer -- The player involved in the collision
--- @param collidedChar IsoZombie -- The zombie or ZombHuman that collided with the player
--- @param zombieGender string -- The gender of the zombie
--- @return boolean -- True if the collision has been handled
local function handleNonSexualAnimations(player, collidedChar, zombieGender)
    ZomboDesire.debugLog(MODULE_NAME, "Scenario -> non-sexual animations (forcing 'Desire' tag)")

    -- "Desire" is the forced tag argument here - always non-sexual, unlike handleSexualAnimations' survival-dependent "Lust" tag,
    -- so it's passed inline rather than through a named variable
    ZomboDesire_HandleGenderMismatch(player, collidedChar, zombieGender, "Desire")

    return true -- Indicate that we've handled the collision
end

--- Handles sexual animations when ZomboLust is active
--- Only ever called for a gender mismatch where the zombie won its sexual-intent roll (or the player still has clothing to strip):
--- ZomboDesireOnCollide filters out same-gender collisions
--- and lost-roll bite outcomes before neutralizing the zombie or calling this function at all
--- @param player IsoPlayer -- The player involved in the collision
--- @param collidedChar IsoZombie -- The zombie that collided with the player
--- @param zombieGender string -- The gender of the zombie
--- @return boolean -- True if the collision has been handled
local function handleSexualAnimations(player, collidedChar, zombieGender)
    ZomboDesire.debugLog(MODULE_NAME, "Scenario -> sexual animations (forcing 'Lust' tag)")

    -- Force appropriate Lust tag based on survival time
    local forceModTag = getSurvivalForceModTag(player)
    if dbg() then
        ZomboDesire.debugLog(MODULE_NAME, "Survival tag selected -> %s (hours survived: %.2f)", forceModTag, player:getHoursSurvived())
    end

    if ZomboLust_GenderMismatchHandler then
        ZomboLust_GenderMismatchHandler.handleCollisionWithStripping(player, collidedChar, zombieGender, forceModTag, ZomboDesire_HandleGenderMismatch)
    else
        ZomboDesire.errorLog(MODULE_NAME, "ZomboLust_GenderMismatchHandler failed to load - clothing stripping handler unavailable")
    end

    return true -- Indicate that we've handled the collision
end

--- Main handler for valid collisions between player and zombies
--- @param player IsoPlayer -- The player involved in the collision
--- @param collidedChar IsoZombie -- The zombie that collided with the player
function ZomboDesireOnCollide(player, collidedChar)
    ZomboDesire.debugLog(MODULE_NAME, "ZomboDesireOnCollide called")

    -- Determine genders and decide upfront whether this collision should just be a normal vanilla bite - same gender,
    -- or (ZomboLust active + opposite gender) this specific zombie lost its sexual-intent roll - BEFORE touching the zombie's state at all.
    -- The zombie is essentially always mid-AttackState at the exact instant a valid collision fires
    -- (the physical contact IS the attack windup on the engine side, see isPerformingInvalidAction),
    -- so if it's just going to bite, the only reliable way to let that happen is to not interfere with it whatsoever.
    -- Forcing any changeState (IdleState, ZombieIdleState) or
    -- setStaggerBack to "neutralize then later un-neutralize" it was tried and confirmed broken in each case:
    -- IdleState defines no execute(owner) at all so the zombie never re-evaluates anything and freezes solid;
    -- StaggerBackState does re-evaluate but its own execute() also shoves the zombie back,
    -- so it just bounces off the player forever without ever landing a hit;
    -- ZombieIdleState froze it just like plain IdleState.
    -- Not touching it at all is the only approach that reproduces reliable vanilla bite behaviour.
    local playerGender = determineGender(player)
    local zombieGender = determineGender(collidedChar)
    ZomboDesire.debugLog(MODULE_NAME, "Player gender %s, Zombie gender %s", playerGender, zombieGender)

    local isBiteOutcome = (playerGender == zombieGender)
    if not isBiteOutcome and ZomboDesire.IsZomboLustActive and ZomboLust_SexualIntentSystem then
        isBiteOutcome = not ZomboLust_SexualIntentSystem.isZombieElectedForAnimation(player, collidedChar)
    end

    if isBiteOutcome then
        ZomboDesire.debugLog(MODULE_NAME, "Bite outcome decided upfront (%s) -> leaving player/zombie untouched for vanilla combat",
            playerGender == zombieGender and "same gender" or "lost sexual-intent roll")
        return
    end

    -- Immediately disable player controls to prevent any movement
    ZomboDesire_Utils.disablePlayerControls(player)

    -- Make zombie harmless immediately and during the delay
    if collidedChar then
        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Zombie ID %d -> pre-neutralize snapshot: isAttacking=%s isZombieAttacking=%s target=%s",
                collidedChar:getID(),
                tostring(collidedChar.isAttacking and collidedChar:isAttacking()),
                tostring(collidedChar.isZombieAttacking and collidedChar:isZombieAttacking(player)),
                tostring(collidedChar.getTarget and collidedChar:getTarget()))
        end

        -- Track it in the global table only if it wasn't already useless
        if not collidedChar:isUseless() then
            collidedChar:setUseless(true)
            if ZomboDesire.neutralizedZombies then
                ZomboDesire.neutralizedZombies[collidedChar] = true
            end
        end

        -- setUseless(true) alone does not retroactively cancel an attack the zombie's native AI already committed to this tick.
        -- Clearing the target mirrors the neutralization pattern already used
        -- for pushed nearby zombies in ZomboDesire_Utils.triggerZombieFallAnimation.
        ---@diagnostic disable-next-line: param-type-mismatch
        collidedChar:setTarget(nil)
        collidedChar:setTargetSeenTime(0)

        -- Live logging confirmed the zombie is essentially always in AttackState at the exact
        -- instant of a valid collision (the physical contact IS the attack windup on the engine side).
        -- setUseless/setTarget only stop the AI from deciding to act again - they don't interrupt an AttackState already in progress.
        -- A hard state transition to IdleState interrupts it silently - unlike setStaggerBack(true),
        -- which is functionally reliable but visually jarring. Falls back to setStaggerBack(true) if unavailable.
        local silentlyInterrupted = false
        if IdleState and IdleState.instance and collidedChar.changeState then
            silentlyInterrupted = pcall(function()
                collidedChar:changeState(IdleState.instance())
            end)
        end

        if not silentlyInterrupted then
            -- Fallback: visually jarring but proven reliable if the silent state change is unavailable/fails
            collidedChar:setStaggerBack(true)
        end

        if dbg() then
            ZomboDesire.debugLog(MODULE_NAME, "Zombie ID %d -> set to useless state, target cleared, and attack interrupted (%s) during %d ticks transition period",
                collidedChar:getID(), silentlyInterrupted and "silent changeState(IdleState)" or "fallback setStaggerBack", ZOMBHUMAN_TRANSFORM_DELAY_TICKS)
        end
    end

    -- Choose animation logic based on mod flags
    -- (playerGender/zombieGender/isBiteOutcome already computed above - reaching here
    -- guarantees a gender mismatch that must proceed to an animation, never a bite)
    if not ZomboDesire.IsZomboLustActive then
        -- Scenario Adult mod inactive: handle non-sexual animations
        handleNonSexualAnimations(player, collidedChar, zombieGender)
        return -- Collision has been handled
    else
        -- Scenario Adult mod active: handle sexual animations
        handleSexualAnimations(player, collidedChar, zombieGender)
        return -- Collision has been handled
    end
end

-- =================================
-- OnGameStart: detect mod presence
-- =================================

--- Detects the presence of ZomboLust and its sub-mods at game startup.
--- Sets corresponding flags in the `ZomboDesire` table.
local function ZomboDesireonGameStart()
    print("[ZomboDesire FrameWork]-----------------------------------------------")
    print("[ZomboDesire FrameWork] OnGameStart - checking ZomboLust and sub-mods")
    print("[ZomboDesire FrameWork]-----------------------------------------------")

    -- Check if ZomboLust Core mod is activated (with debug mode enabled)
    -- Note: Build 42.15+ no longer requires backslash prefix in mod names
    if isModActivated("ZomboLust", false) or isModActivated("\\ZomboLust", false) then
        ZomboDesire.IsZomboLustActive = true
        print("[ZomboDesire FrameWork] ZomboLust core mod detected -> adult content enabled")

        -- Load ZomboLust clothing stripping handler
        ZomboLust_GenderMismatchHandler = require "ZomboLust_GenderMismatchHandler"
        -- print("[ZomboDesire FrameWork] ZomboLust clothing stripping handler loaded")

        -- Load ZomboLust sexual intent handler (bite-vs-animation roll for fully undressed players)
        ZomboLust_SexualIntentSystem = require "Encounter/ZomboLust_SexualIntentSystem"

        -- Load ZomboLust penis manager for animations
        local ZomboLust_PenisManager = require "ZomboLust_PenisManager"
        -- print("[ZomboDesire FrameWork] ZomboLust penis manager loaded")
    else
        print("[ZomboDesire FrameWork] ZomboLust core mod not activated -> adult content disabled")
        return
    end

    -- Table mapping mod names to their display names
    -- Note: Build 42.15+ no longer requires backslash prefix in mod names
    local subMods = {
        { name = "ZomboLustLesbian", display = "Lesbian" },
        { name = "ZomboLustGay", display = "Gay" },
        { name = "ZomboLustBestiality", display = "Bestiality" },
        { name = "ZomboLustDreams", display = "Dreams" },
        { name = "ZomboLustEndGame", display = "End Game" },
        { name = "ZomboLustFurry", display = "Furry" },
        { name = "ZomboLustMasturbation", display = "Masturbation" },
        { name = "ZomboLustOccult", display = "Occult" },
        { name = "ZomboLustBeingFemale", display = "Being Female" },
        { name = "ZomboLustReactiveSound", display = "Reactive Sound" }
    }

    -- Check each sub-mod in a loop (Optimized numeric loop)
    for i = 1, #subMods do
        local mod = subMods[i]
        -- Try both with and without backslash for backward compatibility
        local isEnabled = isModActivated(mod.name, false) or isModActivated("\\" .. mod.name, false)

        -- Set the appropriate flag based on the mod name
        if mod.name == "ZomboLustLesbian" then
            ZomboDesire.IsZomboLustLesbianActive = isEnabled
        elseif mod.name == "ZomboLustGay" then
            ZomboDesire.IsZomboLustGayActive = isEnabled
        elseif mod.name == "ZomboLustBestiality" then
            ZomboDesire.IsZomboLustBestialityActive = isEnabled
        elseif mod.name == "ZomboLustDreams" then
            ZomboDesire.IsZomboLustDreamsActive = isEnabled
        elseif mod.name == "ZomboLustEndGame" then
            ZomboDesire.IsZomboLustEndGameActive = isEnabled
        elseif mod.name == "ZomboLustFurry" then
            ZomboDesire.IsZomboLustFurryActive = isEnabled
        elseif mod.name == "ZomboLustMasturbation" then
            ZomboDesire.IsZomboLustMasturbationActive = isEnabled
        elseif mod.name == "ZomboLustOccult" then
            ZomboDesire.IsZomboLustOccultActive = isEnabled
        elseif mod.name == "ZomboLustBeingFemale" then
            ZomboDesire.IsZomboLustBeingFemaleActive = isEnabled
        elseif mod.name == "ZomboLustReactiveSound" then
            ZomboDesire.IsZomboLustReactiveSoundActive = isEnabled
        end

        -- Print the appropriate message
        if isEnabled then
            print(string.format("[ZomboDesire FrameWork] ZomboLust %s sub-mod enabled", mod.display))
        else
            print(string.format("[ZomboDesire FrameWork] ZomboLust %s sub-mod not enabled", mod.display))
        end
    end
end

--- Register OnGameStart
Events.OnGameStart.Add(ZomboDesireonGameStart)
ZomboDesire.debugLog(MODULE_NAME, "Registered OnGameStart listener")

--- Register OnCharacterCollide
Events.OnCharacterCollide.Add(collisionListener)
ZomboDesire.debugLog(MODULE_NAME, "Collision handler registered")
