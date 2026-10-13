local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__NumberToFixed = ____lualib.__TS__NumberToFixed
local __TS__Number = ____lualib.__TS__Number
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Unpack = ____lualib.__TS__Unpack
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local getActivatedMods = ____pipewrench.getActivatedMods
local getTexture = ____pipewrench.getTexture
local getText = ____pipewrench.getText
local HaloTextHelper = ____pipewrench.HaloTextHelper
local pipeWrenchRequire = ____pipewrench.require
local _____40constants = require('constants')
local MODS = _____40constants.MODS
--- Represents a custom moodle for a player, supporting both Moodle Framework (MF) and fallback HaloText.
-- 
-- If Moodle Framework is active, moodles are registered and updated via MF APIs, and can be called more frequently for real-time updates.
-- If not, falls back to HaloText for one-off moodle notifications.
____exports.Moodle = __TS__Class()
local Moodle = ____exports.Moodle
Moodle.Type = "Moodle"
__PW__BaseClassExtends(Moodle)
function Moodle.prototype.____constructor(self, props)
    local ____props_0 = props
    local player = ____props_0.player
    local name = ____props_0.name
    local ____type = ____props_0.type
    local texture = ____props_0.texture
    local tresholds = ____props_0.tresholds
    self.player = player
    self.name = name
    self.type = ____type
    self.tresholds = tresholds
    if getActivatedMods():contains(MODS.MOODLE_FRAMEWORK) then
        do
            local function ____catch()
                print(("[BF][Warn] Moodle Framework mod detected but failed to load MF_ISMoodle. Falling back to HaloText for moodle \"" .. name) .. "\".")
                return true
            end
            local ____try, ____hasReturned, ____returnValue = pcall(function()
                pipeWrenchRequire("MF_ISMoodle")
            end)
            if not ____try then
                ____hasReturned, ____returnValue = ____catch()
            end
            if ____hasReturned then
                return ____returnValue
            end
        end
        if not self.moodleFramework then
            print(("[BF][Warn] Moodle Framework mod detected but required APIs are missing. Falling back to HaloText for moodle \"" .. name) .. "\".")
            return
        end
        self.texture = getTexture(texture)
        self.moodleFramework.createMoodle(self.name)
        self.moodleFramework.ISMoodle.new(self.moodleFramework.ISMoodle, self.name, self.player)
    end
end
function Moodle.prototype.fallbackMoodle(self, level)
    level = math.min(
        math.max(level, 0),
        1
    )
    local mapped = __TS__New(Map, {{self.tresholds[1], 1}, {self.tresholds[2], 2}, {self.tresholds[3], 3}, {self.tresholds[4], 4}}):get(__TS__Number(__TS__NumberToFixed(level, 1)))
    if mapped then
        local text = getText((((("Moodles_" .. self.name) .. "_") .. self.type) .. "_desc_lvl") .. tostring(mapped))
        if self.type == "Good" then
            HaloTextHelper.addGoodText(self.player, text)
            return
        end
        HaloTextHelper.addBadText(self.player, text)
    end
end
function Moodle.prototype.buildTresholds(self)
    local level1, level2, level3, level4 = __TS__Unpack(self.tresholds)
    if self.type == "Good" then
        return {
            bad4 = nil,
            bad3 = nil,
            bad2 = nil,
            bad1 = nil,
            good1 = level1,
            good2 = level2,
            good3 = level3,
            good4 = level4
        }
    end
    return {
        bad4 = 1 - level4,
        bad3 = 1 - level3,
        bad2 = 1 - level2,
        bad1 = 1 - level1,
        good1 = nil,
        good2 = nil,
        good3 = nil,
        good4 = nil
    }
end
function Moodle.prototype.normalizeLevel(self, level)
    if level > 1 then
        return level / 100
    end
    return level
end
function Moodle.prototype.moodle(self, level, onlyMoodleFramework)
    if onlyMoodleFramework == nil then
        onlyMoodleFramework = false
    end
    local normalized = self:normalizeLevel(level)
    local mfLevel = self.type == "Bad" and 1 - normalized or normalized
    if not self.moodleFramework then
        if not onlyMoodleFramework then
            self:fallbackMoodle(normalized)
        end
        return
    end
    local ____opt_3 = self.moodleFramework
    local ____opt_1 = ____opt_3 and ____opt_3.getMoodle
    local moodle = ____opt_1 and ____opt_1(self.name)
    if not moodle then
        if not onlyMoodleFramework then
            self:fallbackMoodle(normalized)
        end
        return
    end
    local ____temp_5 = self:buildTresholds()
    local bad4 = ____temp_5.bad4
    local bad3 = ____temp_5.bad3
    local bad2 = ____temp_5.bad2
    local bad1 = ____temp_5.bad1
    local good1 = ____temp_5.good1
    local good2 = ____temp_5.good2
    local good3 = ____temp_5.good3
    local good4 = ____temp_5.good4
    moodle:setThresholds(
        bad4,
        bad3,
        bad2,
        bad1,
        good1,
        good2,
        good3,
        good4
    )
    if self.texture then
        moodle:setPicture(
            moodle:getGoodBadNeutral(),
            moodle:getLevel(),
            self.texture
        )
    end
    moodle:setValue(mfLevel)
end
__TS__SetDescriptor(
    Moodle.prototype,
    "moodleFramework",
    {get = function(self)
        local ____temp_8 = not MF or not MF.createMoodle or not MF.getMoodle
        if not ____temp_8 then
            local ____opt_6 = MF.ISMoodle
            ____temp_8 = not (____opt_6 and ____opt_6.new)
        end
        if ____temp_8 then
            return nil
        end
        return MF
    end},
    true
)
return ____exports
