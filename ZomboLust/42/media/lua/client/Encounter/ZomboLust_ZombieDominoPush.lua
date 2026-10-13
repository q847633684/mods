-- File: ZomboLust/42/media/lua/client/Encounter/ZomboLust_ZombieDominoPush.lua
-- Zombie shove "domino" bonus: above a minimum Excitation level, a bare-hands shove has a
-- chance to knock down a chain of zombies behind the one actually hit, with each fall delayed a few ticks after the previous one.
-- This is a combat/physics feature merely gated by the player's Excitation level (via ZomboLust_ExcitationSystem.getExcitation).
-- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust LOADING] ZomboLust_ZombieDominoPush.lua loaded")

---@diagnostic disable: inject-field
-- =============
-- Dependencies
-- =============
require "Excitation/ZomboLust_ExcitationSystem"

-- Module name for logging
--- @type string
local MODULE_NAME = "DominoPush"

-- ======================
-- Variables & Constants
-- ======================

ZomboLust_DominoPush = ZomboLust_DominoPush or {}
ZomboLust_DominoPush.DominoQueue = {}
ZomboLust_DominoPush.DOMINO_DELAY_TICKS = 20
ZomboLust_DominoPush.TickCount = 0
ZomboLust_DominoPush.MinExcitationThreshold = 26.0 -- Start bonus at 26%
ZomboLust_DominoPush.MinPushChance = 5
ZomboLust_DominoPush.MaxPushChance = 30
ZomboLust_DominoPush.MinPushZombies = 1
ZomboLust_DominoPush.MaxPushZombies = 4
ZomboLust_DominoPush.PushLineDistance = 0.8

-- ==================
-- Utility Functions
-- ==================

--- Calculate push chance based on excitation (linear from 26% to 100%)
--- @param excitation number
--- @return number
local function getPushChanceForExcitation(excitation)
    if excitation < ZomboLust_DominoPush.MinExcitationThreshold then return 0 end

    local minExc = ZomboLust_DominoPush.MinExcitationThreshold
    local maxExc = 100.0
    local minChance = ZomboLust_DominoPush.MinPushChance
    local maxChance = ZomboLust_DominoPush.MaxPushChance

    local t = (excitation - minExc) / (maxExc - minExc)
    return math.floor(minChance + t * (maxChance - minChance) + 0.5)
end

--- Calculate max zombies based on excitation (linear from 26% to 100%)
--- @param excitation number
--- @return number
local function getMaxZombiesForExcitation(excitation)
    if excitation < ZomboLust_DominoPush.MinExcitationThreshold then return 0 end

    local minExc = ZomboLust_DominoPush.MinExcitationThreshold
    local maxExc = 100.0
    local minZ = ZomboLust_DominoPush.MinPushZombies
    local maxZ = ZomboLust_DominoPush.MaxPushZombies

    local t = (excitation - minExc) / (maxExc - minExc)
    return math.floor(minZ + t * (maxZ - minZ) + 0.5)
end

--- Find zombies in a domino chain behind the shoved zombie
--- @param player IsoPlayer
--- @param shovedZombie IsoZombie
--- @param maxCount number
--- @return table
local function getDominoChain(player, shovedZombie, maxCount)
    local results = {}
    local cell = player:getCell()
    if not cell or maxCount <= 0 then return results end

    -- Push direction: from player toward the shoved zombie
    local dx = shovedZombie:getX() - player:getX()
    local dy = shovedZombie:getY() - player:getY()
    local dist = math.sqrt(dx * dx + dy * dy)
    if dist < 0.1 then return results end

    local allZombies = cell:getZombieList()
    if not allZombies then return results end

    local stepDist = ZomboLust_DominoPush.PushLineDistance
    local used = {}
    used[shovedZombie] = true

    -- Start the chain from the shoved zombie
    local currentX = shovedZombie:getX()
    local currentY = shovedZombie:getY()
    local currentZ = shovedZombie:getZ()

    for _ = 1, maxCount do
        local bestZombie = nil
        local bestDist = stepDist

        for i = 0, allZombies:size() - 1 do
            local z = allZombies:get(i)
            if z and not used[z] and not z:isDead() and z:getZ() == currentZ then
                local zdx = z:getX() - currentX
                local zdy = z:getY() - currentY
                local zdist = math.sqrt(zdx * zdx + zdy * zdy)

                if zdist < bestDist then
                    bestZombie = z
                    bestDist = zdist
                end
            end
        end

        if bestZombie then
            table.insert(results, bestZombie)
            used[bestZombie] = true
            currentX = bestZombie:getX()
            currentY = bestZombie:getY()
        else
            break
        end
    end

    return results
end

--- Knock down a zombie using game methods
--- @param zombie IsoZombie
local function knockDownZombie(zombie)
    if not zombie or zombie:isDead() then return end

    if zombie.setHitReaction then
        zombie:setHitReaction("Shove")
    end

    if zombie.knockDown then
        zombie:knockDown(true)
    end
end

-- ================
-- Logic Functions
-- ================

--- Tick handler for domino queue processing
local function onTick()
    ZomboLust_DominoPush.TickCount = ZomboLust_DominoPush.TickCount + 1

    local i = 1
    while i <= #ZomboLust_DominoPush.DominoQueue do
        local entry = ZomboLust_DominoPush.DominoQueue[i]
        if entry and ZomboLust_DominoPush.TickCount >= entry.knockAtTick then
            if entry.zombie and not entry.zombie:isDead() then
                ZomboLust.debugLog(MODULE_NAME, "Domino Fall: Knocking down zombie at tick %d", ZomboLust_DominoPush.TickCount)
                knockDownZombie(entry.zombie)
            end
            table.remove(ZomboLust_DominoPush.DominoQueue, i)
        else
            i = i + 1
        end
    end
end

--- Handler for player hitting a character (detects shoves)
local function onWeaponHitCharacter(attacker, target, weapon, _)
    if not attacker or not target then return end
    if not instanceof(attacker, "IsoPlayer") or not instanceof(target, "IsoZombie") then return end

    -- Only trigger on spacebar shoves (BareHands)
    if weapon then
        if not weapon.getType or weapon:getType() ~= "BareHands" then
            return
        end
    end

    local excitation = ZomboLust_ExcitationSystem.getExcitation(attacker)
    if excitation < ZomboLust_DominoPush.MinExcitationThreshold then return end

    local chance = getPushChanceForExcitation(excitation)
    if ZombRand(100) >= chance then return end

    local maxCount = getMaxZombiesForExcitation(excitation)
    local chainZombies = getDominoChain(attacker, target, maxCount)

    if #chainZombies > 0 then
        ZomboLust.debugLog(MODULE_NAME, "Bonus Push Triggered! Excitation=%.2f%% Chance=%d%% Chain=%d",
            excitation, chance, #chainZombies)

        for idx, sz in ipairs(chainZombies) do
            local knockAtTick = ZomboLust_DominoPush.TickCount + (idx * ZomboLust_DominoPush.DOMINO_DELAY_TICKS)
            ZomboLust.debugLog(MODULE_NAME, "Domino Queue: Adding zombie %d to fall at tick %d", idx, knockAtTick)
            table.insert(ZomboLust_DominoPush.DominoQueue, {
                zombie = sz,
                knockAtTick = knockAtTick,
            })
        end
    end
end

Events.OnTick.Add(onTick)
Events.OnWeaponHitCharacter.Add(onWeaponHitCharacter)

print("[ZomboLust] Zombie Domino Push Initialized")
