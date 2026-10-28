-- ============================================================================
-- GothBagTweaks_TABAS_Exclude.lua  (shared)
-- 兼容补丁（纯官方接口，无 monkey patch）：
-- 让 Take A Bath And Shower 在脱衣 / 自动换衣 / 洗澡收益计算时忽略
-- ZomboLust Lewd Models 的体毛 / 胡茬物品（ZLLewdModels.*）。
--
-- 通过原模组官方扩展点 TABAS_BodyLocations.Exclude 实现：
--   1) Exclude.BodyLocations <- 6 个身体部位
--        影响：shouldExcludedClothing（脱衣队列）+ canAutoUnequipClothing
--   2) Exclude.FullType       <- 30 个 fullType
--        影响：canAutoUnequipClothing / countWornClothesAfterExclusions
--             （洗澡收益、是否算"穿着衣服"、是否去清洗穿着衣物）
--
-- 背景：这些体毛是永久穿戴、脱不掉的（ItemType=base:clothing，Weight=0），
-- 若被当成可脱的"衣服"，会导致：
--   - 自动脱衣队列尝试脱下它们而卡住（无法自动化）
--   - 洗澡收益被永久打折（服务端 TABAS_BathingBenefitDriver）
--   - isClothed 判定恒为 true（客户端 TABAS_BathingSystems）
-- 本文件放在 shared/，客户端与服务端各自加载一次，两边都生效。
-- ============================================================================

-- 6 个身体部位（字符串，与 ZLLewdModels registries.lua 中一致）
local BODY_LOCATIONS = {
    "zllewdmodels:armpithair",
    "zllewdmodels:chesthair",
    "zllewdmodels:leghair",
    "zllewdmodels:pubichair",
    "zllewdmodels:beardstubble",
    "zllewdmodels:headstubble",
}

-- 30 个 fullType（与 ZLLewdModels_Scripts.txt 的 item 一致）
local EXCLUDE_FULLTYPES = {
    "ZLLewdModels.FemaleArmpit",
    "ZLLewdModels.FemaleArmpit_Int",
    "ZLLewdModels.FemaleArmpit_Black2",
    "ZLLewdModels.MaleArmpit",
    "ZLLewdModels.MaleArmpit_Int",
    "ZLLewdModels.MaleChest",
    "ZLLewdModels.MaleChest_Int",
    "ZLLewdModels.FemaleLeg",
    "ZLLewdModels.FemaleLeg_Int",
    "ZLLewdModels.FemaleLeg_Black2",
    "ZLLewdModels.MaleLeg",
    "ZLLewdModels.MaleLeg_Int",
    "ZLLewdModels.FemalePubicNatural",
    "ZLLewdModels.FemalePubicNatural_Int",
    "ZLLewdModels.FemalePubicNatural_Int_Black2",
    "ZLLewdModels.FemalePubicNatural_Black2",
    "ZLLewdModels.FemalePubicStrip",
    "ZLLewdModels.FemalePubicStrip_Black2",
    "ZLLewdModels.FemalePubicTrimmed",
    "ZLLewdModels.FemalePubicTrimmed_Black2",
    "ZLLewdModels.MalePubicNatural",
    "ZLLewdModels.MalePubicNatural_Int",
    "ZLLewdModels.MalePubicStrip",
    "ZLLewdModels.MalePubicStrip_Int",
    "ZLLewdModels.StubbleBeard_Dark",
    "ZLLewdModels.StubbleBeard_Light",
    "ZLLewdModels.StubbleHead_Dark_F",
    "ZLLewdModels.StubbleHead_Dark_M",
    "ZLLewdModels.StubbleHead_Light_F",
    "ZLLewdModels.StubbleHead_Light_M",
}

-- 安全 require：目标模组未安装/未加载时返回 nil，不抛错
local function safeRequire(name)
    local ok, mod = pcall(require, name)
    if ok then return mod end
    return nil
end

local applied = false

local function applyExcludes()
    if applied then return end

    local bodyLocations = safeRequire("NPCs/TABAS_BodyLocations")
    if not bodyLocations then return end
    if type(bodyLocations.Exclude) ~= "table" then return end

    -- 1) 身体部位 -> shouldExcludedClothing 与 canAutoUnequipClothing 都认
    local bodyList = bodyLocations.Exclude.BodyLocations
    if type(bodyList) == "table" then
        for _, loc in ipairs(BODY_LOCATIONS) do
            table.insert(bodyList, loc)
        end
    end

    -- 2) fullType -> canAutoUnequipClothing / countWornClothesAfterExclusions 认
    local fullTypeMap = bodyLocations.Exclude.FullType
    if type(fullTypeMap) == "table" then
        for _, fullType in ipairs(EXCLUDE_FULLTYPES) do
            fullTypeMap[fullType] = true
        end
    end

    applied = true
end

-- 文件加载时立即尝试一次（mod.info 的 require=TakeABathAndShowerNew 已保证加载顺序，
-- 客户端与服务端都会在各自的 Lua 环境里执行一遍，因此两边都能生效）
applyExcludes()

-- 兜底：客户端完全启动后再尝试一次
Events.OnGameBoot.Add(applyExcludes)
