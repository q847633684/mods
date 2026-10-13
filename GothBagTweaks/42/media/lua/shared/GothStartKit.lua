-- Tomb Wardrobe Local Patches - start kit (goth chest rigs).
--
-- Sandbox options live on Tomb's own page (see 42/media/sandbox-options.txt):
--   TWALT.GothStartKit          master switch
--   TWALT.GothStartKitFull      Goth_ChestRigFull_Loose
--   TWALT.GothStartKitFullTight Goth_ChestRigFull_Tight
--   TWALT.GothStartKitSmall     Goth_ChestRig_Loose
--
-- Timing:
--   * new character  - Events.OnNewGame, the same hook vanilla SpawnItems.lua
--                      uses for the starter kit. On a server only the server
--                      side hands items out (isClient() guard below).
--   * existing save  - Events.OnCreatePlayer fires when the character object is
--                      created, so a character that predates this file gets the
--                      kit once on load. A flag in the player's modData
--                      (GothStartKitGiven) makes sure it is given exactly once
--                      per character and never duplicated on later loads.

local MASTER = "GothStartKit"
local FLAG = "GothStartKitGiven"

local KIT = {
    { item = "TombAlternative.Goth_ChestRigFull_Loose", option = "GothStartKitFull" },
    { item = "TombAlternative.Goth_ChestRigFull_Tight", option = "GothStartKitFullTight" },
    { item = "TombAlternative.Goth_ChestRig_Loose",     option = "GothStartKitSmall" },
}

-- A missing option (save created before the option existed) counts as enabled,
-- which is the same as its default value.
local function isEnabled(name)
    local page = SandboxVars and SandboxVars.TWALT
    if not page then return true end
    local value = page[name]
    if value == nil then return true end
    return value and true or false
end

local function giveStartKit(playerObj)
    if isClient() then return end -- multiplayer: the server hands it out
    if not playerObj then return end

    local inventory = playerObj:getInventory()
    if not inventory then return end

    local modData = playerObj:getModData()
    if modData[FLAG] then return end -- already given to this character
    if not isEnabled(MASTER) then return end

    local given, missing = {}, {}
    for _, entry in ipairs(KIT) do
        if isEnabled(entry.option) then
            local item = inventory:AddItem(entry.item)
            if item then
                table.insert(given, entry.item)
            else
                table.insert(missing, entry.item)
            end
        end
    end

    if #missing > 0 then
        print("[GothStartKit] item not found: " .. table.concat(missing, ", ") ..
            " (is Tomb's Wardrobe - Alternative [VANILLA] enabled, and loaded before this patch?)")
    end
    if #given == 0 then return end -- nothing was given, leave the flag clear

    modData[FLAG] = true
    pcall(function() playerObj:transmitModData() end)
    print("[GothStartKit] start kit given: " .. table.concat(given, ", "))
end

-- New character (vanilla signature: playerObj, square). Fires in singleplayer
-- and on the server side in multiplayer.
Events.OnNewGame.Add(function(playerObj, square) giveStartKit(playerObj) end)

-- Catch-up pass for characters created before this file existed. The argument
-- is a player index, not the player object.
Events.OnCreatePlayer.Add(function(playerIndex)
    local ok, playerObj = pcall(getSpecificPlayer, playerIndex)
    if ok then giveStartKit(playerObj) end
end)
