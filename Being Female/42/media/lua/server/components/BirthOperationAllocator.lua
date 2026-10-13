local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
--- Allocates deterministic, retry-safe birth identities for one server-owned character identity.
____exports.BirthOperationAllocator = __TS__Class()
local BirthOperationAllocator = ____exports.BirthOperationAllocator
BirthOperationAllocator.Type = "BirthOperationAllocator"
__PW__BaseClassExtends(BirthOperationAllocator)
function BirthOperationAllocator.prototype.____constructor(self)
end
function BirthOperationAllocator.prototype.allocate(self, current, characterId)
    if current.pendingBirthId then
        return {changed = false, birthId = current.pendingBirthId, state = current}
    end
    local birthSequence = current.birthSequence + 1
    local birthId = (characterId .. ":birth:") .. tostring(birthSequence)
    return {
        changed = true,
        birthId = birthId,
        state = __TS__ObjectAssign({}, current, {birthSequence = birthSequence, pendingBirthId = birthId})
    }
end
return ____exports
