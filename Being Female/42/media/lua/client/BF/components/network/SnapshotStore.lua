local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
--- Holds the latest validated server snapshot visible to client presentation code.
-- This store is a read-only mirror and does not persist or mutate gameplay state.
____exports.SnapshotStore = __TS__Class()
local SnapshotStore = ____exports.SnapshotStore
SnapshotStore.Type = "SnapshotStore"
__PW__BaseClassExtends(SnapshotStore)
function SnapshotStore.prototype.____constructor(self)
    self.listeners = {}
end
function SnapshotStore.prototype.apply(self, snapshot)
    if self.current and snapshot.stateVersion <= self.current.stateVersion then
        return
    end
    self.current = snapshot
    for ____, listener in ipairs(self.listeners) do
        listener(snapshot)
    end
end
function SnapshotStore.prototype.notifyCurrent(self)
    if not self.current then
        return
    end
    for ____, listener in ipairs(self.listeners) do
        listener(self.current)
    end
end
function SnapshotStore.prototype.resetSession(self)
    self.current = nil
end
function SnapshotStore.prototype.subscribe(self, listener)
    local ____self_listeners_0 = self.listeners
    ____self_listeners_0[#____self_listeners_0 + 1] = listener
end
__TS__SetDescriptor(
    SnapshotStore.prototype,
    "snapshot",
    {get = function(self)
        return self.current
    end},
    true
)
return ____exports
