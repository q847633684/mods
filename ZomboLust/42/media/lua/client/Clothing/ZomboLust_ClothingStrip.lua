-- File: ZomboLust/42/media/lua/client/Clothing/ZomboLust_ClothingStrip.lua
-- Clothing stripping system for ZomboLust
-- Manages removal of player clothing when encountering zombies
-- @author BlaBla 2025

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_ClothingStrip.lua loaded")

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"
local VoiceUtils = require "AnimationEvents/ZomboLust_VoiceUtils"

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local pcall    = pcall
local tostring = tostring
local type     = type
local table    = table

-- Module name for logging
--- @type string
local MODULE_NAME = "ClothingStrip"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

-- Innocent trait: flat panic gain per garment grabbed by a zombie
-- CharacterStat.PANIC is a 0-100 scale (see forageSystem.lua); vanilla one-off medical
-- panic spikes (stitching, bullet removal, etc.) are +50, this is a smaller repeatable jolt
local INNOCENT_PANIC_PER_GRAB = 8

-- ================
-- Module Namespace
-- ================
--- Main namespace
--- @type table
ZomboLust_ClothingStrip = {}

-- Clothing body part priorities for removal
-- Removed from outside to inside (external layers first, underwear last)
ZomboLust_ClothingStrip.ClothingRemovalOrder = {}

-- Weak point locations for the ItFollows trait
-- Only underwear-equivalent locations - everything else is ignored
ZomboLust_ClothingStrip.WeakPointRemovalOrder = {}

--- Initialize the clothing removal order list
--- Handles optional mod dependencies safely
function ZomboLust_ClothingStrip.initRemovalOrder()
    local order = {}
    local weakPointOrder = {}
    -- Index into `order` where the Submissive trait's removal list starts (captured below,
    -- right after the last head/torso-only entry) - everything before this index is
    -- upper-body-only and ignored by Submissive, everything from here on is fair game
    local submissiveBoundaryIndex = 1

    -- Helper to safely add a location (vanilla or modded)
    local function add(location)
        if location then
            table.insert(order, location)
        end
    end

    -- Helper to safely add a location that is also a weak point (ItFollows trait)
    local function addWeakPoint(location)
        if location then
            table.insert(order, location)
            table.insert(weakPointOrder, location)
        end
    end

    -- Helper to safely get a modded location
    local function getModLoc(fullPath)
        -- pcall is safer in case ResourceLocation.of or ItemBodyLocation.get throws
        local status, res = pcall(ResourceLocation.of, fullPath)
        if not status or not res then return nil end

        local status2, loc = pcall(ItemBodyLocation.get, res)
        if not status2 or not loc then return nil end

        return loc
    end

    -- Head items
    add(ItemBodyLocation.FULL_SUIT_HEAD)
    add(ItemBodyLocation.FULL_SUIT_HEAD_SCBA)
    add(ItemBodyLocation.FULL_HAT)
    add(ItemBodyLocation.MASK_FULL)
    add(ItemBodyLocation.MASK_EYES)
    add(ItemBodyLocation.MASK)
    add(ItemBodyLocation.HAT)

    -- Frockin Splendor - Boleros, Gloves, Headbands, and Head Accessories
    add(getModLoc("FcknSpldr:KIUA"))
    add(getModLoc("FcknSpldr:KIUB"))
    add(getModLoc("FcknSpldr:KIUC"))

    -- Authentic Z Lite - Head accessories (earmuffs, top hats, hair picks)
    add(getModLoc("AZ:HeadExtra"))

    add(ItemBodyLocation.SCARF)
    add(ItemBodyLocation.FULL_SUIT)
    add(ItemBodyLocation.CUIRASS)
    add(ItemBodyLocation.TORSO_EXTRA_VEST_BULLET)
    add(ItemBodyLocation.TORSO_EXTRA_VEST)

    -- Frockin Splendor - Vests
    add(getModLoc("FcknSpldr:TorsoExtraVest"))

    -- Authentic Z Lite - Torso rig / webbing extras (e.g. inflatable tube)
    -- AZ:TorsoRigPlus2 is unused by the mod as of this writing, added preemptively for forward compatibility
    add(getModLoc("AZ:TorsoExtraPlus1"))
    add(getModLoc("AZ:TorsoRigPlus2"))

    add(ItemBodyLocation.VEST_TEXTURE) -- Waistcoats texture
    add(ItemBodyLocation.TORSO_EXTRA)
    add(ItemBodyLocation.FULL_TOP)
    add(ItemBodyLocation.BATH_ROBE)

    -- Frockin Splendor - Bathrobe
    add(getModLoc("FcknSpldr:BathRobeCoat"))

    add(ItemBodyLocation.FULL_ROBE)
    add(ItemBodyLocation.JACKET)

    -- Frockin Splendor - Jackets
    add(getModLoc("FcknSpldr:JacketOpen"))
    add(getModLoc("FcknSpldr:JacketShort"))

    add(ItemBodyLocation.JACKET_BULKY)
    add(ItemBodyLocation.JACKET_DOWN)
    add(ItemBodyLocation.JACKET_SUIT)

    -- Frockin Splendor - Suits & Corsets
    add(getModLoc("FcknSpldr:JacketSuitSlim"))

    add(ItemBodyLocation.JACKET_HAT)
    add(ItemBodyLocation.JACKET_HAT_BULKY)

    -- Frockin Splendor - More Corsets / Accessories
    add(getModLoc("FcknSpldr:KIUX"))
    add(getModLoc("FcknSpldr:KIUY"))
    add(getModLoc("FcknSpldr:ShoulderpadLeft"))
    add(getModLoc("FcknSpldr:ShoulderpadRight"))

    add(ItemBodyLocation.SWEATER_HAT)
    add(ItemBodyLocation.SWEATER)
    add(ItemBodyLocation.BOILERSUIT)
--	add(ItemBodyLocation.NECK)         -- Choker / Tie
--	add(ItemBodyLocation.NECK_TEXTURE) -- Choker / Tie

    -- Authentic Z Lite - Neck accessories (cameras, jewelry, earmuffs-neck variant, signs)
    add(getModLoc("AZ:NeckExtra"))

    add(ItemBodyLocation.SHIRT)

    -- Frockin Splendor - Shirts
    add(getModLoc("FcknSpldr:FSShirt"))

    add(ItemBodyLocation.SHORT_SLEEVE_SHIRT)
    add(ItemBodyLocation.TSHIRT)
    add(ItemBodyLocation.JERSEY)
    add(ItemBodyLocation.TORSO1)

    -- Everything from here on covers the lower body (or both, like a dress/one-piece) -
    -- the Submissive trait's removal list starts here, skipping all head/torso-only items above
    submissiveBoundaryIndex = #order + 1

    add(ItemBodyLocation.TORSO1LEGS1)
    add(ItemBodyLocation.DRESS)
    add(ItemBodyLocation.LONG_DRESS)
	add(ItemBodyLocation.LEGS1) -- Longjohns bottom / leg warmers (NOT a garter, see vanilla BodyLocations.lua)
--	add(ItemBodyLocation.LEGS5) -- Unused by vanilla, no clothing item references it

    -- Authentic Z Lite - Leg warmers / shin guards
    add(getModLoc("AZ:LegsExtra"))

    -- Frockin Splendor - Legs
    add(getModLoc("FcknSpldr:RightLeg"))
    add(getModLoc("FcknSpldr:LeftLeg"))

    add(ItemBodyLocation.SKIRT)
    add(ItemBodyLocation.LONG_SKIRT)
    add(ItemBodyLocation.PANTS)
    add(ItemBodyLocation.PANTS_SKINNY)
    add(ItemBodyLocation.PANTS_EXTRA)
    add(ItemBodyLocation.SHORTS_SHORT)
    add(ItemBodyLocation.SHORT_PANTS)
    add(ItemBodyLocation.TANK_TOP)
    add(ItemBodyLocation.BODY_COSTUME)
--	add(getModLoc("Tail")) -- Bunny Suits Enhanced
    add(ItemBodyLocation.UNDERWEAR_TOP)
    addWeakPoint(ItemBodyLocation.UNDERWEAR_BOTTOM)
    addWeakPoint(ItemBodyLocation.UNDERWEAR)

    -- Frockin Splendor - Kink It Up! Extra
    addWeakPoint(getModLoc("FcknSpldr:KIU3"))
    addWeakPoint(getModLoc("FcknSpldr:KIU2"))
    addWeakPoint(getModLoc("FcknSpldr:KIU1"))
    addWeakPoint(getModLoc("FcknSpldr:KIU0"))
--	add(ItemBodyLocation.UNDERWEAR_EXTRA1) -- Garter
--	add(ItemBodyLocation.UNDERWEAR_EXTRA2) -- Garter

    -- Submissive trait: slice out everything from the captured boundary onward,
    -- skipping the purely upper-body entries authored above it
    -- NOTE: ClothingRemovalOrder is sorted by removal LAYER (outside to inside), not by
    -- body region - a few torso locations are base layers worn under other tops, so they
    -- appear after the boundary despite covering the torso. They must be filtered out here:
    --   TANK_TOP     -- "goes under tshirt or shirt" (BodyLocations.lua), a torso base layer
    --   UNDERWEAR_TOP -- bra, torso
    --   BODY_COSTUME -- full-body one-piece (mutually exclusive with FULL_SUIT_HEAD/DRESS/
    --                   PANTS/etc in BodyLocations.lua), covers the torso along with everything else
    local submissiveExcluded = {
        [ItemBodyLocation.TANK_TOP] = true,
        [ItemBodyLocation.UNDERWEAR_TOP] = true,
        [ItemBodyLocation.BODY_COSTUME] = true,
    }

    local submissiveOrder = {}
    for i = submissiveBoundaryIndex, #order do
        local location = order[i]
        if not submissiveExcluded[location] then
            table.insert(submissiveOrder, location)
        end
    end

    ZomboLust_ClothingStrip.ClothingRemovalOrder = order
    ZomboLust_ClothingStrip.WeakPointRemovalOrder = weakPointOrder
    ZomboLust_ClothingStrip.SubmissiveRemovalOrder = submissiveOrder
    ZomboLust.debugLog(MODULE_NAME, "initRemovalOrder -> Initialized with %d locations (%d weak points, %d submissive)", #order, #weakPointOrder, #submissiveOrder)
end

-- Initialize the order immediately
ZomboLust_ClothingStrip.initRemovalOrder()

--- Get the appropriate clothing removal list for the target
--- ItFollows trait: zombies can only target underwear-equivalent locations,
--- regardless of what else the player is wearing
--- Submissive trait: zombies skip head/torso-only locations entirely, so the player
--- can be defeated without those items ever being removed (mutually exclusive with
--- ItFollows in the trait definition, so both cases never need to be combined here)
--- @param target IsoPlayer -- The target player
--- @return table -- The clothing removal order list
local function getClothingRemovalList(target)
    if target and target:hasTrait(ZomboLustRegistries.Traits.ItFollows) then
        return ZomboLust_ClothingStrip.WeakPointRemovalOrder
    end
    if target and target:hasTrait(ZomboLustRegistries.Traits.Submissive) then
        return ZomboLust_ClothingStrip.SubmissiveRemovalOrder
    end
    return ZomboLust_ClothingStrip.ClothingRemovalOrder
end

--- Remove an item from the character and drop it on the ground
--- @param item InventoryItem -- The item to remove
--- @param character IsoPlayer -- The character wearing the item
local function removeItemFromCharacter(item, character)
    if not item or not character then
        ZomboLust.errorLog(MODULE_NAME, "removeItemFromCharacter -> Invalid parameters (item or character is nil)")
        return
    end

    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "removeItemFromCharacter -> Starting removal of item %s", item:getName())
    end

    character:removeAttachedItem(item)
    ZomboLust.debugLog(MODULE_NAME, "removeItemFromCharacter -> removeAttachedItem completed")

    if character:isEquipped(item) then
        ZomboLust.debugLog(MODULE_NAME, "removeItemFromCharacter -> Item is equipped, calling removeFromHands")
        character:removeFromHands(item)
    else
        ZomboLust.debugLog(MODULE_NAME, "removeItemFromCharacter -> Item is not equipped, skipping removeFromHands")
    end

    character:removeWornItem(item, false)
    ZomboLust.debugLog(MODULE_NAME, "removeItemFromCharacter -> removeWornItem completed")

    triggerEvent("OnClothingUpdated", character)
    ZomboLust.debugLog(MODULE_NAME, "removeItemFromCharacter -> OnClothingUpdated event triggered")

    local container = item:getContainer()
    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "removeItemFromCharacter -> Item container %s", tostring(container))
    end

    if character:hasTrait(ZomboLustRegistries.Traits.BetterAlive) then
        -- BetterAlive: don't risk grabbing torn clothes back - drop them on the ground
        if container and ISInventoryTransferAction then
            local floorContainer = ISInventoryPage.floorContainer and ISInventoryPage.floorContainer[1]
            if floorContainer then
                ZomboLust.debugLog(MODULE_NAME, "removeItemFromCharacter -> BetterAlive trait - creating transfer action to floor")
                local transferAction = ISInventoryTransferAction:new(character, item, container, floorContainer)
                if transferAction then
                    ZomboLust.debugLog(MODULE_NAME, "removeItemFromCharacter -> Transferring item to floor")
                    transferAction:transferItem(item)
                    ZomboLust.debugLog(MODULE_NAME, "removeItemFromCharacter -> Item successfully transferred to floor")
                else
                    ZomboLust.errorLog(MODULE_NAME, "removeItemFromCharacter -> Failed to create transfer action")
                end
            else
                ZomboLust.warningLog(MODULE_NAME, "removeItemFromCharacter -> No floor container available")
            end
        else
            ZomboLust.warningLog(MODULE_NAME, "removeItemFromCharacter -> Container or ISInventoryTransferAction unavailable")
        end
    else
        -- Default: item stays in the player's inventory (already there after removeWornItem)
        ZomboLust.debugLog(MODULE_NAME, "removeItemFromCharacter -> No BetterAlive trait, item kept in inventory")
    end
end

--- Check if the target has clothing that can be removed
--- @param target IsoPlayer -- The target player
--- @return boolean -- True if there's clothing to remove
function ZomboLust_ClothingStrip.hasClothingToRemove(target)
    if not target then return false end

    local wornItems = target:getWornItems()
    if not wornItems then return false end

    local clothingList = getClothingRemovalList(target)

    for i = wornItems:size(), 1, -1 do
        local wornItem = wornItems:get(i - 1)

        if wornItem then
            local item = wornItem:getItem()
            local location = wornItem:getLocation()

            if item and item:IsClothing() then
                -- if dbg() then
                    -- ZomboLust.debugLog(MODULE_NAME, "Clothing check -> Scanning item %s at location %s (type: %s)", item:getName(), tostring(location), type(location))
                -- end
                for j = 1, #clothingList do
                    if location == clothingList[j] then
                        if dbg() then
                            ZomboLust.debugLog(MODULE_NAME, "Clothing check -> Found removable clothing at location '%s'", tostring(location))
                        end
                        return true
                    end
                end
            end
        end
    end

    -- ZomboLust.debugLog(MODULE_NAME, "Clothing check -> No removable clothing found on target")
    return false
end

--- Apply ViciousZombies trait damage to a grabbed clothing item
--- 75% chance to add a hole to the item, independent of where it ends up
--- (kept in inventory or dropped to the ground via BetterAlive)
--- @param item Clothing -- The clothing item being removed
--- @param target IsoPlayer -- The target player
local function applyViciousZombiesDamage(item, target)
    if not item or not target then return end
    if not target:hasTrait(ZomboLustRegistries.Traits.ViciousZombies) then return end

    if ZombRand(100) < 75 and item:getCanHaveHoles() then
        local ok = pcall(function() item:addRandomHole() end)
        if dbg() then
            if ok then
                ZomboLust.debugLog(MODULE_NAME, "applyViciousZombiesDamage -> Added random hole to %s", item:getName())
            else
                ZomboLust.debugLog(MODULE_NAME, "applyViciousZombiesDamage -> addRandomHole failed for %s (incompatible item, likely a third-party clothing mod)", item:getName())
            end
        end
    else
        HaloTextHelper.addTextWithArrow(target, getText("IGUI_ZomboLust_ViciousZombies_Failed"), true, HaloTextHelper.getColorGreen())
        if dbg() then
            ZomboLust.debugLog(MODULE_NAME, "applyViciousZombiesDamage -> Roll failed, clothing spared (%s)", item:getName())
        end
    end
end

--- Apply Innocent trait panic spike when a garment is grabbed by a zombie
--- @param target IsoPlayer -- The target player
local function applyInnocentPanic(target)
    if not target then return end
    if not target:hasTrait(ZomboLustRegistries.Traits.Innocent) then return end

    target:getStats():add(CharacterStat.PANIC, INNOCENT_PANIC_PER_GRAB)

    ZomboLust.debugLog(MODULE_NAME, "applyInnocentPanic -> +%d panic (Innocent, garment grabbed)", INNOCENT_PANIC_PER_GRAB)
end

--- Remove a single piece of clothing from the target
--- @param zombie IsoZombie -- The attacking zombie
--- @param target IsoPlayer -- The target player
--- @return boolean -- True if clothing was removed
function ZomboLust_ClothingStrip.removeOneClothing(zombie, target)
    if not target or not zombie then return false end

    local wornItems = target:getWornItems()
    if not wornItems then return false end

    local clothingList = getClothingRemovalList(target)

    for i = wornItems:size(), 1, -1 do
        local wornItem = wornItems:get(i - 1)

        if wornItem then
            local item = wornItem:getItem()
            local location = wornItem:getLocation()

            if item and item:IsClothing() then
                if dbg() then
                    ZomboLust.debugLog(MODULE_NAME, "Item removal -> Scanning item %s at location %s", item:getName(), tostring(location))
                end

                for j = 1, #clothingList do
                    if location == clothingList[j] then
                        if dbg() then
                            ZomboLust.debugLog(MODULE_NAME, "Item removal -> Removing clothing from location '%s' (item %s)", tostring(location), item:getName())
                        end

                        -- Remove favorite status if needed
                        if item:isFavorite() then
                            item:setFavorite(false)
                        end

                        -- Show removal text
                        HaloTextHelper.addTextWithArrow(target, getText("IGUI_ZomboLust_Clothing"), false, HaloTextHelper.getColorRed())

                        -- ViciousZombies trait: chance to tear a hole in the grabbed item
                        applyViciousZombiesDamage(item, target)

                        -- Innocent trait: panic spike per garment grabbed
                        applyInnocentPanic(target)

                        -- Remove the item
                        removeItemFromCharacter(item, target)

                        ISInventoryPage.renderDirty = true
                        ZomboLust.debugLog(MODULE_NAME, "Item removal -> Successfully removed clothing from target")
                        return true
                    end
                end
            end
        end
    end

    return false
end

--- Strip multiple clothing items from target (up to numToRemove times)
--- @param zombie IsoZombie -- The attacking zombie
--- @param target IsoPlayer -- The target player
--- @param numToRemove number -- How many items to attempt removing
--- @return boolean -- True if at least one item was removed
function ZomboLust_ClothingStrip.stripTarget(zombie, target, numToRemove)
    if not target or not zombie then return false end

    if numToRemove <= 0 then return false end

    local removedAny = false
    local numRemoved = 0

    while numRemoved < numToRemove do
        if not ZomboLust_ClothingStrip.removeOneClothing(zombie, target) then
            break
        end

        numRemoved = numRemoved + 1
        removedAny = true
    end

    return removedAny
end

--- Play clothing rip sounds
--- @param target IsoPlayer -- The target player
local function playClothingRipSounds(target)
    if not target then return end
    ZomboLust.debugLog(MODULE_NAME, "Sound effect -> Playing clothing rip sound at target location")
    getSoundManager():PlayWorldSound('SFXClothingRip', true, target:getCurrentSquare(), 0, 4, 1, false)

    -- Play player voice reaction with a small delay (approx 1/2 second = 30 ticks)
    -- to ensure it doesn't overlap with the rip sound and is clearly audible
    local soundType = target:isFemale() and "StrugglesAbigailNormal" or "Grunt"
    local soundName = VoiceUtils.GetSoundName(target, soundType)

    local ticks = 0
    local function playDelayedVoice()
        ticks = ticks + 1
        if ticks >= 30 then
            Events.OnTick.Remove(playDelayedVoice)
            if target and not target:isDead() then
                ZomboLust.debugLog(MODULE_NAME, "Sound effect -> Playing delayed player voice: %s", soundName)
                -- Using the character's emitter directly for better sound positioning and reliability
                target:getEmitter():playSound(soundName)
            end
        end
    end
    Events.OnTick.Add(playDelayedVoice)
end

--- Apply stagger effect to zombie after stripping
--- @param zombie IsoZombie -- The attacking zombie
--- @param target IsoPlayer -- The target player (unused, kept for consistency)
--- @param clothesWereRemoved boolean -- Whether any clothes were removed
local function applyZombieStaggerAfterStrip(zombie, target, clothesWereRemoved)
    if not zombie or not clothesWereRemoved then return end
    ZomboLust.debugLog(MODULE_NAME, "Stagger effect -> Applying stagger effect to attacking zombie")
    zombie:setStaggerBack(true)
end

--- Apply temporary invisibility to the player (makes zombies useless)
--- @param player IsoPlayer -- The player to protect
--- @param durationSeconds number -- Duration in seconds
local function applyTemporaryInvisibility(player, durationSeconds)
    if not player then return end

    -- Cache zombie list once at start of effect to avoid repeating getCell():getZombieList() 60 times/sec
    local cell = getCell()
    local zombieList = cell and cell:getZombieList()
    if not zombieList then return end

    local durationTicks = durationSeconds * 60
    local currentTicks = 0

    ZomboLust.debugLog(MODULE_NAME, "applyTemporaryInvisibility -> Starting protection for %d ticks (%d seconds)", durationTicks, durationSeconds)

    -- Function to make zombies useless (invisible player)
    local function clearZombieAwareness()
        -- Use cached zombieList
        for i = 0, zombieList:size() - 1 do
            local zombie = zombieList:get(i)
            if zombie then
                zombie:setUseless(true)
            end
        end
    end

    -- Function to end protection
    local function endInvisibility()
        currentTicks = currentTicks + 1
        if currentTicks >= durationTicks then
            Events.OnTick.Remove(clearZombieAwareness)
            Events.OnTick.Remove(endInvisibility)

            -- Restore zombie awareness using cached zombieList
            for i = 0, zombieList:size() - 1 do
                local zombie = zombieList:get(i)
                if zombie then
                    zombie:setUseless(false)
                end
            end

            ZomboLust.debugLog(MODULE_NAME, "applyTemporaryInvisibility -> Protection ended after %d ticks", currentTicks)
        end
    end

    Events.OnTick.Add(clearZombieAwareness)
    Events.OnTick.Add(endInvisibility)
end

--- Apply a trip animation to the player (lunge attack successful animation)
--- @param player IsoPlayer -- The player to trip
local function applyPlayerTripAnimation(player)
    if not player then return end
    ZomboLust.debugLog(MODULE_NAME, "applyPlayerTripAnimation -> Forcing player trip animation")

    -- 1. Apply short invisibility (3 seconds) to allow player to get up/recover
    applyTemporaryInvisibility(player, 3)

    -- 2. Randomize the reaction (50% chance to fall, 50% chance to just stumble)
    local shouldFall = ZombRand(2) == 0
    local isFront = ZombRand(2) == 0
    local fallType = isFront and "pushedFront" or "pushedBehind"

    ZomboLust.debugLog(MODULE_NAME, "applyPlayerTripAnimation -> Reaction: %s, Direction: %s",
        shouldFall and "Fall" or "Stumble", fallType)

    -- Official B42 animation variables for tripping/stumbling
    player:setBumpType("stagger")
    player:setBumpFall(shouldFall)
    player:setBumpFallType(fallType)
    player:setBumpDone(true) -- Triggers bumpFall.xml (Bob_RunStumble)

    -- 3. Force the transition to BumpedState if not already there
    player:reportEvent("Bumped")
end

--- Apply a cooldown and stagger effects after a successful stripping
--- @param player IsoPlayer -- The player who was stripped
local function applyStripCooldown(player)
    if not player then return end

    ZomboLust.debugLog(MODULE_NAME, "applyStripCooldown -> Starting cooldown sequence")

    -- 1. Push nearby zombies with a small radius (1.5 squares)
    local x, y, z = player:getX(), player:getY(), player:getZ()
    if ZomboDesire_Utils and ZomboDesire_Utils.pushNearbyZombies then
        ZomboLust.debugLog(MODULE_NAME, "applyStripCooldown -> Pushing nearby zombies")
        ZomboDesire_Utils.pushNearbyZombies(x, y, z, 1.5)
    end

    -- 2. Temporarily disable ZomboDesire's collision listener for ~3 seconds (180 ticks)
    -- so the player isn't immediately re-grabbed right after a successful strip.
    -- Goes through ZomboDesire.suspendCollisionListener (public API) instead of removing/re-adding ZomboDesire.collisionListener by hand:
    -- that public function also maintains ZomboDesire.isCollisionListenerRegistered, which ZomboDesire's own internal suspend/resume logic
    -- (ZomboDesire_Intercept.lua, ZomboDesire_EscapeHandler.lua) relies on - reimplementing the Remove/Add + timer here
    -- without touching that flag could desync from a concurrent suspend/resume triggered from within ZomboDesire itself.
    if ZomboDesire and ZomboDesire.suspendCollisionListener then
        ZomboLust.debugLog(MODULE_NAME, "applyStripCooldown -> Suspending collision listener via ZomboDesire.suspendCollisionListener")
        ZomboDesire.suspendCollisionListener(180, "ZomboLust strip cooldown")
    else
        ZomboLust.errorLog(MODULE_NAME, "applyStripCooldown -> ZomboDesire.suspendCollisionListener not found (ZomboDesire missing or outdated); skipping collision listener suspension")
    end
end

--- Play feedback (stagger, trip, sound, floating text) when a zombie fails to grab
--- the target's clothing entirely (e.g. ButtonedUp or Dominate traits) so the failure
--- is visible to the player instead of silently doing nothing
--- @param zombie IsoZombie -- The attacking zombie
--- @param target IsoPlayer -- The target player
--- @param haloTextKey? string -- Translation key for the floating text (defaults to the ButtonedUp text)
function ZomboLust_ClothingStrip.playFailedGrabFeedback(zombie, target, haloTextKey)
    if not zombie or not target then return end

    ZomboLust.debugLog(MODULE_NAME, "playFailedGrabFeedback -> Zombie failed to grab clothing, playing feedback")

    -- Stagger the zombie and trip the player, same visual language as a successful strip
    zombie:setStaggerBack(true)
    applyPlayerTripAnimation(target)

    -- Audio feedback: the player grunts from the effort of shoving the zombie off, then stumbles
    local shoveSound = target:isFemale() and "VoiceFemaleMeleeShove" or "VoiceMaleMeleeShove"
    target:playSound(shoveSound)
    target:playSound("SFXBodyFalling")

    -- Text feedback so the player understands why nothing happened
    HaloTextHelper.addTextWithArrow(target, getText(haloTextKey or "IGUI_ZomboLust_ButtonedUp_Failed"), true, HaloTextHelper.getColorGreen())
end

--- Attempt to strip the player during combat
--- This is the main entry point for the stripping system
--- @param zombie IsoZombie -- The attacking zombie
--- @param target IsoPlayer -- The target player
--- @param numToRemove? number -- How many items to remove (default 1)
--- @return boolean -- True if stripping was successful
function ZomboLust_ClothingStrip.attemptStripping(zombie, target, numToRemove)
    if not target or not zombie then
        return false
    end

    numToRemove = numToRemove or 1

    ZomboLust.debugLog(MODULE_NAME, "Entry point -> attemptStripping called - attempting to remove %d clothing item(s)", numToRemove)

    local clothesWereRemoved = ZomboLust_ClothingStrip.stripTarget(zombie, target, numToRemove)

    if clothesWereRemoved then
        playClothingRipSounds(target)
        applyZombieStaggerAfterStrip(zombie, target, true)

        -- Always apply the trip animation to the player when clothes are removed
        applyPlayerTripAnimation(target)

        -- Check for nearby zombies (more than 1 including the attacker)
        -- and apply additional cooldown effects if the player is being overwhelmed
        local cell = getCell()
        local zombiesInRadius = 0
        if cell and cell:getZombieList() then
            local zlist = cell:getZombieList()
            for i = 0, zlist:size() - 1 do
                local z = zlist:get(i)
                if z and z:isAlive() and z:DistTo(target) < 2.0 then
                    zombiesInRadius = zombiesInRadius + 1
                end
            end
        end

        if zombiesInRadius > 1 then
            ZomboLust.debugLog(MODULE_NAME, "Entry point -> Multiple zombies detected (%d), applying strip cooldown", zombiesInRadius)
            applyStripCooldown(target)
        end

        ZomboLust.debugLog(MODULE_NAME, "Entry point -> Stripping attempt completed successfully")
        return true
    end

    ZomboLust.debugLog(MODULE_NAME, "Entry point -> Stripping attempt completed - no clothes removed")
    return false
end

return ZomboLust_ClothingStrip
