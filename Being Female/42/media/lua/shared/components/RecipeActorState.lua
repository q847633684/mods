local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____pipewrench = require('lua_modules/@asledgehammer/pipewrench/PipeWrench')
local isServer = ____pipewrench.isServer
local ____LactationSchema = require('domain/lactation/LactationSchema')
local lactationStateSchema = ____LactationSchema.lactationStateSchema
local _____40constants = require('constants')
local BF_STATE_MOD_DATA_KEY = _____40constants.BF_STATE_MOD_DATA_KEY
local ____LactationState = require('domain/lactation/LactationState')
local createDefaultLactationState = ____LactationState.createDefaultLactationState
--- Reads recipe state exclusively from the callback-supplied character.
-- 
-- @param character Callback actor whose ModData should be inspected without mutation.
-- The namespaced root is server-owned and is deliberately ignored in client and
-- single-player callback contexts, where it may be an unsynchronized stale copy.
-- @returns Legacy recipe fields plus the authoritative domain root on the server.
____exports.readRecipeActorState = function(character)
    local ____temp_0 = character:getModData()
    if ____temp_0 == nil then
        ____temp_0 = {}
    end
    local data = ____temp_0
    local root = data[BF_STATE_MOD_DATA_KEY]
    local ____temp_3
    if type(isServer) == "function" and isServer() then
        ____temp_3 = root and root.domains
    else
        ____temp_3 = nil
    end
    local authoritative = ____temp_3
    return {
        womb = data.BFWomb,
        lactation = lactationStateSchema(data.BFLactation) and data.BFLactation or nil,
        pregnancy = data.BFPregnancy,
        authoritative = authoritative
    }
end
--- Resolves complete Lactation state with explicit authoritative-over-legacy precedence.
-- A validated authoritative zero state remains authoritative and never falls back merely
-- because every numeric value is zero.
-- 
-- @param actor Previously read callback-actor state.
-- @returns Valid authoritative Lactation, valid legacy Lactation, or a neutral default.
____exports.resolveRecipeLactation = function(actor)
    local ____opt_4 = actor.authoritative
    local authoritative = ____opt_4 and ____opt_4.lactation
    if lactationStateSchema(authoritative) then
        return authoritative
    end
    if actor.lactation then
        return actor.lactation
    end
    return createDefaultLactationState()
end
return ____exports
