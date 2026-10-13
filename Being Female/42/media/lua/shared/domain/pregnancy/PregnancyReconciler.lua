local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local ____PregnancyState = require('domain/pregnancy/PregnancyState')
local PregnancyStatus = ____PregnancyState.PregnancyStatus
--- Pure reconciliation for reversible debug Pregnancy state changes.
____exports.PregnancyReconciler = __TS__Class()
local PregnancyReconciler = ____exports.PregnancyReconciler
PregnancyReconciler.Type = "PregnancyReconciler"
__PW__BaseClassExtends(PregnancyReconciler)
function PregnancyReconciler.prototype.____constructor(self)
end
function PregnancyReconciler.prototype.reconcile(self, current, desired)
    if not self:isConsistent(desired) then
        return {valid = false, changed = false, state = current}
    end
    local changed = current.status ~= desired.status or current.current ~= desired.current or current.progress ~= desired.progress or current.isInLabor ~= desired.isInLabor
    if not changed then
        return {valid = true, changed = false, state = current}
    end
    return {valid = true, changed = true, state = {status = desired.status, current = desired.current, progress = desired.progress, isInLabor = desired.isInLabor}}
end
function PregnancyReconciler.prototype.isConsistent(self, state)
    if state.status == PregnancyStatus.NOT_PREGNANT then
        return state.current == 0 and state.progress == 0 and not state.isInLabor
    end
    if state.progress == 0 and state.current ~= 0 then
        return false
    end
    if state.progress > 0 and state.current == 0 then
        return false
    end
    if state.isInLabor and state.progress ~= 1 then
        return false
    end
    return true
end
return ____exports
