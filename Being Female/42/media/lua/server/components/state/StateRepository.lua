local ____lualib = require('lualib_bundle')
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____pipewrench_fixes = require('pipewrench_fixes')
local __PW__BaseClassExtends = ____pipewrench_fixes.__PW__BaseClassExtends
local __PW__ClassExtendsPatch = ____pipewrench_fixes.__PW__ClassExtendsPatch
local ____exports = {}
local _____40constants = require('constants')
local BF_STATE_MOD_DATA_KEY = _____40constants.BF_STATE_MOD_DATA_KEY
local ____StateMigrator = require('components/state/StateMigrator')
local StateMigrator = ____StateMigrator.StateMigrator
--- Loads and normalizes the server-owned BF root stored on an authenticated player.
____exports.StateRepository = __TS__Class()
local StateRepository = ____exports.StateRepository
StateRepository.Type = "StateRepository"
__PW__BaseClassExtends(StateRepository)
function StateRepository.prototype.____constructor(self, migrator)
    if migrator == nil then
        migrator = __TS__New(StateMigrator)
    end
    self.migrator = migrator
end
function StateRepository.prototype.load(self, player)
    local store = player:getModData()
    local persisted = self:getValue(store)
    local result = self.migrator:migrate(persisted)
    if result.supported then
        self:setValue(store, result.state)
    end
    local source = persisted == nil and "initialized" or "loaded"
    print((((("[BF][MP][Server] authoritative state " .. source) .. " schema=") .. tostring(result.schemaVersion)) .. " state=") .. tostring(result.stateVersion))
    return result
end
function StateRepository.prototype.save(self, player, state)
    local store = player:getModData()
    self:setValue(store, state)
end
function StateRepository.prototype.getValue(self, store)
    return self:getStoreValue(store, BF_STATE_MOD_DATA_KEY)
end
function StateRepository.prototype.getStoreValue(self, store, key)
    if type(store.get) == "function" then
        return store:get(key)
    end
    return store[key]
end
function StateRepository.prototype.setValue(self, store, value)
    if type(store.set) == "function" then
        store:set(BF_STATE_MOD_DATA_KEY, value)
        return
    end
    store[BF_STATE_MOD_DATA_KEY] = value
end
return ____exports
