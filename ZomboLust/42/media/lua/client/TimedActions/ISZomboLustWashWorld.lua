-- File: ZomboLust/42/media/lua/client/TimedActions/ISZomboLustWashWorld.lua
-- This TimedAction handles cleaning world cum textures (floor/walls)
-- @author BlaBla 2026

-- =============
-- Dependencies
-- =============
require "ZomboLust_Main"
require "TimedActions/ISBaseTimedAction"

-- ==========================
-- Optimization Cache (Local)
-- ==========================
-- IMPORTANT: Only cache Lua standard libraries (table, string, math) or built-in functions
-- (pairs, ipairs, next, tostring, tonumber, type, unpack, select, setmetatable, getmetatable, pcall, xpcall, assert, error).
-- DO NOT cache custom mod globals (ZomboDesire, ZombHumanBrain, etc.) or game-specific API objects at the top level.
-- Project Zomboid's load order is unpredictable; caching them at the file top level may freeze them as 'nil' 
-- if they aren't fully initialized yet, breaking dynamic features like multi-stage animations or, worse, game features.
local tostring = tostring
local table    = table

--- @class ZL_CumEntry
--- @field s string -- spriteName
--- @field t string -- type ("f" or "w")
--- @field d string|nil -- wallDir ("N" or "W")

--- @class ISZomboLustWashWorld : ISBaseTimedAction
--- @field square IsoGridSquare
--- @field trace IsoObject
--- @field absorbent InventoryItem
--- @field water InventoryItem
--- @field cleaningAgent InventoryItem|nil
--- @field sound integer|nil
--- @field targetX number
--- @field targetY number
ISZomboLustWashWorld = ISBaseTimedAction:derive("ISZomboLustWashWorld")

-- Module name for logging
local MODULE_NAME = "BukkakeWashWorld"

--- Debug guard for this module.
--- Only needed at call sites whose log arguments are costly to build (native engine calls, tostring, concatenation)
--- (see ZomboLust.isDebug in ZomboLust_Main.lua).
--- Calls with cheap/no arguments use ZomboLust.debugLog directly, which is already self-guarded.
--- @return boolean
local function dbg()
    return ZomboLust.isDebug(MODULE_NAME)
end

--- Check if the action is still valid
--- @return boolean -- True if the action is still valid
function ISZomboLustWashWorld:isValid()
    -- Check if square and trace still exist
    if not self.square or not self.trace or self.trace:getSquare() ~= self.square then
        return false
    end
    -- Check if player still has basic tools
    local inv = self.character:getInventory()
    return inv:contains(self.absorbent) and inv:contains(self.water)
end

--- Prepare character for action
function ISZomboLustWashWorld:waitToStart()
    self.character:faceLocation(self.targetX, self.targetY)
    return self.character:shouldBeTurning()
end

--- Continuous update during the action
function ISZomboLustWashWorld:update()
    self.character:faceLocation(self.targetX, self.targetY)
    self.character:setMetabolicTarget(Metabolics.LightWork)

    -- Optional: Check for water exhaustion during cleaning
    local fluid = self.water:getFluidContainer()
    if fluid and fluid:getAmount() <= 0 then
        local text = getText("IGUI_ZomboLust_HaloText_NoMoreWater") or "No more water!"
        HaloTextHelper.addText(self.character, text, "", HaloTextHelper.getColorWhite())
        self:forceStop()
    end
end

--- Start of the action (Animations & Sound)
function ISZomboLustWashWorld:start()
    local name = self.trace:getName()
    local isWall = (name == "CumWall")
    local isTwoHanded = self.absorbent:isTwoHandWeapon()

    if dbg() then
        ZomboLust.debugLog(MODULE_NAME, "Starting cleaning action: wall=%s, tool=%s, soap=%s, duration=%d", tostring(isWall), self.absorbent:getType(), tostring(self.cleaningAgent ~= nil), self.maxTime)
    end

    -- Choose animations based on B42 standards (from ISCleanBlood.lua)
    if isWall then
        if isTwoHanded then -- Mop/Broom
            self:setActionAnim("ScrubWall_Mop")
            self:setOverrideHandModels(self.absorbent, nil)
        else -- Sponge/Towel
            self:setActionAnim("Scrubwall")
            self:setOverrideHandModels(self.absorbent, self.cleaningAgent)
        end
    else -- Floor
        if isTwoHanded then -- Mop/Broom
            self:setActionAnim("ScrubFloor_Mop")
            self:setOverrideHandModels(self.absorbent, nil)
        else -- Sponge/Towel
            self:setActionAnim("ScrubFloor")
            self:setOverrideHandModels(self.absorbent, self.cleaningAgent)
        end
    end

    -- Play cleaning sound
    self.sound = self.character:playSound("CleanBloodScrub")
    self.character:reportEvent("EventCleanBlood")
end

--- End of the action
function ISZomboLustWashWorld:stop()
    if self.sound then
        self.character:stopOrTriggerSound(self.sound)
    end
    ISBaseTimedAction.stop(self)
end

--- Successful completion of the action
function ISZomboLustWashWorld:perform()
    if self.sound then
        self.character:stopOrTriggerSound(self.sound)
    end

    -- 1. Consume Water (Fluid Container)
    local fluid = self.water:getFluidContainer()
    local cost = 0.2 -- Base cost
    if self.cleaningAgent then cost = 0.1 end -- Half cost with cleaning agent

    if fluid then
        if dbg() then
            ZomboLust.debugLog(MODULE_NAME, "Consuming %.2f units of water from %s", cost, self.water:getType())
        end
        fluid:adjustAmount(fluid:getAmount() - cost)
        self.water:syncItemFields()
    else
        ZomboLust.errorLog(MODULE_NAME, "Water item %s has no fluid container during perform!", self.water:getType())
    end

    -- 2. Consume Soap if it's a solid item (Soap2)
    if self.cleaningAgent and self.cleaningAgent:getType() == "Soap2" then
        ZomboLust.debugLog(MODULE_NAME, "Consuming solid soap")
        ---@cast self.cleaningAgent DrainableComboItem
        if self.cleaningAgent:getCurrentUses() > 0 then
            self.cleaningAgent:UseAndSync()
        end
    elseif self.cleaningAgent and self.cleaningAgent:getFluidContainer() then
        -- Consume fluid cleaning agent (Bleach/CleaningLiquid)
        ZomboLust.debugLog(MODULE_NAME, "Consuming fluid cleaning agent")
        local agentFluid = self.cleaningAgent:getFluidContainer()
        agentFluid:adjustAmount(agentFluid:getAmount() - 0.05)
        self.cleaningAgent:syncItemFields()
    end

    -- 3. Remove physical object from the square
    ZomboLust.debugLog(MODULE_NAME, "Removing physical trace object from square")
    self.square:RemoveTileObject(self.trace)

    -- 4. Clean ModData to prevent respawn
    local modData = self.square:getModData()
    if modData then
        if modData.ZL_Cum then
            -- Get sprite name from the object's ModData (saved during creation)
            local spriteName = self.trace:getModData().spriteName

            -- Fallback if not in ModData (try standard methods)
            if not spriteName then
                spriteName = self.trace:getSpriteName()
            end
            if not spriteName and self.trace:getSprite() then
                spriteName = self.trace:getSprite():getName()
            end

            if dbg() then
                ZomboLust.debugLog(MODULE_NAME, "Searching ModData for sprite: %s (Total entries: %d)", tostring(spriteName), #modData.ZL_Cum)
            end

            local found = false
            for i = #modData.ZL_Cum, 1, -1 do
                --- @type ZL_CumEntry
                local entry = modData.ZL_Cum[i]
                if dbg() then
                    ZomboLust.debugLog(MODULE_NAME, "  Checking entry [%d]: s='%s', t='%s'", i, tostring(entry.s), tostring(entry.t))
                end

                if entry.s == spriteName then
                    table.remove(modData.ZL_Cum, i)
                    if dbg() then
                        ZomboLust.debugLog(MODULE_NAME, "SUCCESS: Removed ModData entry for texture: %s at [%d, %d]", spriteName, self.square:getX(), self.square:getY())
                    end
                    found = true
                end
            end

            if not found then
                ZomboLust.warningLog(MODULE_NAME, "No matching sprite found in ZL_Cum for: %s", tostring(spriteName))
            end

            -- Remove table if empty to save memory
            if #modData.ZL_Cum == 0 then
                modData.ZL_Cum = nil
                ZomboLust.debugLog(MODULE_NAME, "ModData ZL_Cum is now empty and has been cleared")
            end
        else
            ZomboLust.debugLog(MODULE_NAME, "No ZL_Cum table found in ModData for this square")
        end
    else
        ZomboLust.errorLog(MODULE_NAME, "Critical: No ModData found for square [%d, %d]", self.square:getX(), self.square:getY())
    end

    -- 5. Force visual refresh
    ---@diagnostic disable-next-line: undefined-field
    if self.square.recalcBitMaps then
        ---@diagnostic disable-next-line: undefined-field
        self.square:recalcBitMaps()
    end

    -- HaloText feedback
    local text = getText("IGUI_ZomboLust_HaloText_Cleaned") or "Cleaned!"
    HaloTextHelper.addText(self.character, text, "", HaloTextHelper.getColorWhite())

    -- Completion
    ISBaseTimedAction.perform(self)
end

--- Constructor
--- @param character IsoPlayer -- The player performing the cleaning
--- @param square IsoGridSquare -- The square where the trace is located
--- @param trace IsoObject -- The cum trace object to clean
--- @param absorbent InventoryItem -- The item used to wipe the trace
--- @param water InventoryItem -- The item containing water for cleaning
--- @param cleaningAgent InventoryItem|nil -- Optional cleaning agent (soap, bleach, etc.)
--- @return ISZomboLustWashWorld -- The newly created action
function ISZomboLustWashWorld:new(character, square, trace, absorbent, water, cleaningAgent)
    local o = ISBaseTimedAction.new(self, character)
    ---@cast o ISZomboLustWashWorld
    o.square = square
    o.trace = trace
    o.absorbent = absorbent
    o.water = water
    o.cleaningAgent = cleaningAgent
    o.targetX = square:getX()
    o.targetY = square:getY()
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = 450 -- Standard cleaning time
    if o.cleaningAgent then
        o.maxTime = 337 -- Reduced cleaning time with soap/bleach (75%)
    end
    if character:isTimedActionInstant() then o.maxTime = 1 end
    o.caloriesModifier = 5
    return o
end
