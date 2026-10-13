--- File: ZomboLust Lewd Models/42/media/lua/shared/ZLLewdModels_ModDataMigration.lua
--- One-shot migration of the legacy SPNCharCustom mod data key into the unified ZLLewdModels key
--- @author BlaBla 2026

-- Initial loading print
print("[ZomboLust Lewd Models LOADING] ZLLewdModels_ModDataMigration.lua loaded")

local ZLLewdModelsModDataMigration = {}

--- Merges legacy player mod data (ZLLewdModels + SPNCharCustom) into a single ZLLewdModels table.
--- Idempotent: the presence of SPNCharCustom (not ZLLewdModels) is the migration marker,
--- since ZLLewdModels already exists for every pre-existing player as the hair-only key.
--- @param moddata table -- The result of player:getModData()
--- @return table -- The unified ZLLewdModels table
function ZLLewdModelsModDataMigration.migrateLegacyModData(moddata)
    if not moddata.SPNCharCustom then
        moddata.ZLLewdModels = moddata.ZLLewdModels or {}
        return moddata.ZLLewdModels
    end

    local merged = moddata.ZLLewdModels or {}
    for k, v in pairs(moddata.SPNCharCustom) do merged[k] = v end

    moddata.SPNCharCustom = nil
    moddata.ZLLewdModels = merged
    return merged
end

return ZLLewdModelsModDataMigration
