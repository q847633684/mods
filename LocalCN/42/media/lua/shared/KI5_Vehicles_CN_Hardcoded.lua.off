KI5_CN_Hardcoded = KI5_CN_Hardcoded or {}

-- ============================================================================
-- 翻译键（玩家可见文案一律走 Translate/CN|CH/IG_UI.json，lua 代码区不再有中文字面量）
--   IGUI_KI5VCN_PlasterMold / NegativeMold / FilledMold / FailedMess
--   IGUI_KI5VCN_SayExpect
--   IGUI_KI5VCN_UninstallHintNoSpare / UninstallHintWithSpare
-- 7 个键值与改动前的中文字面量逐字相同（含前导空格与 <ORANGE> 标签），因为它们
-- 会被直接当作 string.gsub 的替换串使用，动一个字符就改变产出文案。
-- ============================================================================

-- 键取不到时每个键只报一次，方便定位「装了汉化包但语言不是简体中文」这类配置问题。
-- 这条诊断串刻意用英文：它只进 console.txt，不是玩家 UI 文案；用英文可以让本文件
-- 代码区一个中文字面量都不剩（brief 里 test_lua_i18n 的 test_lua_has_no_hardcoded_cjk
-- 就是按这个口径断言的，而它只盯 Hardcoded.lua 这一个文件）。
local missingLogged = {}

local function trMissing(key, why)
    if missingLogged[key] then return end
    missingLogged[key] = true
    print("[KI5_Vehicles_CN] translation key unavailable, kept English as-is: " .. tostring(key) .. " (" .. tostring(why) .. ")")
end

-- tr(key)：惰性取翻译。**必须**在函数体里取，绝不能在文件加载期缓存成 local ——
-- 加载期翻译表可能还没装载，缓存到的会是键名本身，那就会把 IGUI_KI5VCN_* 写进物品名。
-- getText 不存在 / 抛错 / 返回空串 / 原样返回键名，一律给出 nil；调用方收到 nil 就保持
-- 英文原样：既不抛错（不影响读档与联机同步），也绝不写半中半英的坏名字。
local function tr(key)
    if type(getText) ~= "function" then
        trMissing(key, "getText is not available")
        return nil
    end
    local ok, val = pcall(getText, key)
    if not ok then
        trMissing(key, "pcall failed: " .. tostring(val))
        return nil
    end
    if type(val) ~= "string" or val == "" then
        trMissing(key, "getText returned a non-string or an empty string")
        return nil
    end
    if val == key then
        trMissing(key, "key missing; getText echoed the key name")
        return nil
    end
    return val
end

-- esc(s)：翻译值会被直接当作 string.gsub 的替换串。Lua 替换串里 % 是转义符
-- （%1..%9 引用捕获、%% 才是字面百分号），所以来自 JSON 的值必须先做 % -> %%。
-- 当前 7 个键值都不含 %，此调用是恒等的（已实测）；保留它是为了日后改译文不踩坑。
local function esc(s)
    return (s:gsub("%%", "%%%%"))
end

local function fixMoldItemName(result)
    if not result or not result.getName or not result.setName then return end

    local name = result:getName()
    if not name or name == "" then return end

    -- 4 条模式串与替换语义与改动前逐字一致，只是替换串改从翻译键取；某条取不到键
    -- 就只跳过那一条，其余各条互不影响，最后的去前导空格与无条件 setName 照旧执行。
    -- gsub 一律加括号：它返回 (结果, 次数) 两个值，括号保证在任何表达式位置都只取第一个。
    local rep

    rep = tr("IGUI_KI5VCN_PlasterMold")
    if rep then name = (name:gsub(" Plaster Mold$", esc(rep))) end

    rep = tr("IGUI_KI5VCN_NegativeMold")
    if rep then name = (name:gsub(" Negative Mold$", esc(rep))) end

    rep = tr("IGUI_KI5VCN_FilledMold")
    if rep then name = (name:gsub(" in Negative Filled Mold$", esc(rep))) end

    rep = tr("IGUI_KI5VCN_FailedMess")
    if rep then name = (name:gsub("^Failed mess", esc(rep))) end

    name = (name:gsub("^%s+", ""))

    result:setName(name)
end

local function fixCreatedItem(craftRecipeData)
    if not craftRecipeData or not craftRecipeData.getAllCreatedItems then return end

    local items = craftRecipeData:getAllCreatedItems()
    if not items then return end
    if items:size() < 1 then return end

    fixMoldItemName(items:get(0))
end

local function wrapOnCreate(name)
    local flag = "onCreate_" .. name
    if KI5_CN_Hardcoded[flag] then return end   -- 已包过就先短路，省掉 DAMN 的 3 次查表

    if not DAMN or not DAMN.OnCreate or type(DAMN.OnCreate[name]) ~= "function" then return end

    local original = DAMN.OnCreate[name]
    DAMN.OnCreate[name] = function(craftRecipeData, character)
        local result = original(craftRecipeData, character)
        fixCreatedItem(craftRecipeData)
        return result
    end
    KI5_CN_Hardcoded[flag] = true
end

local function patchSay()
    if KI5_CN_Hardcoded.say or not IsoGameCharacter or type(IsoGameCharacter.Say) ~= "function" then return end

    local original = IsoGameCharacter.Say
    IsoGameCharacter.Say = function(self, text, ...)
        -- 热路径（联机里每次说话/喊叫都走）：第一行就短路，只有命中上游那一句才去取翻译。
        if text ~= "What did i expect?" then return original(self, text, ...) end
        local t = tr("IGUI_KI5VCN_SayExpect")
        return original(self, t or text, ...)
    end
    KI5_CN_Hardcoded.say = true
end

local function patchMechanicsTooltip()
    if KI5_CN_Hardcoded.mechanics or not ISVehicleMechanics or type(ISVehicleMechanics.doMenuTooltip) ~= "function" then return end

    local original = ISVehicleMechanics.doMenuTooltip
    ISVehicleMechanics.doMenuTooltip = function(self, part, option, lua, name)
        local result = original(self, part, option, lua, name)

        if option and option.toolTip and option.toolTip.description then
            local description = option.toolTip.description
            -- 守卫：两条模式串都必须含下面这段纯文本；plain=true 不进模式引擎。
            -- 命中不了就整段跳过（改动前是每次 tooltip 都白跑 2 次约 90 字符的模式匹配
            -- 外加 2 次 getText 的 Java 互操作）。这段守卫文本是两条模式串的最长公共字面量，
            -- 由脚本从模式串本身推导并断言，不可能与模式串漂移。
            if description:find(" Gas Can, Tent and Generator to be able to uninstall this part.", 1, true) then
                -- 两条英文模式互不包含（" <ORANGE> Remove " 之后紧跟的词不同），先后顺序不影响
                -- 结果；这里保持改动前的原顺序。模式串逐字未动（结尾 %. = 字面句点）。
                local hint = tr("IGUI_KI5VCN_UninstallHintNoSpare")
                if hint then
                    description = (description:gsub(" <ORANGE> Remove Gas Can, Tent and Generator to be able to uninstall this part%.", esc(hint)))
                end

                hint = tr("IGUI_KI5VCN_UninstallHintWithSpare")
                if hint then
                    description = (description:gsub(" <ORANGE> Remove Spare Tires, Gas Can, Tent and Generator to be able to uninstall this part%.", esc(hint)))
                end

                option.toolTip.description = description
            end
        end

        return result
    end
    KI5_CN_Hardcoded.mechanics = true
end

local function apply()
    patchSay()
    patchMechanicsTooltip()
    wrapOnCreate("MakePlasterMold")
    wrapOnCreate("RemoveOldPartFromMold")
    wrapOnCreate("PourPasteInMold")
end

-- 两段式装载，两段都必须留，不是冗余：
--   · 文件加载期先试一次：此时 DAMN.OnCreate 与 ISVehicleMechanics 可能已就绪，能装就尽早装。
--   · Events.OnGameBoot 再试一次：DAMN.OnCreate 只在 damnlib 的
--     media/lua/server/Crafting/DAMN_damnCraft.lua 里定义，ISVehicleMechanics 只在原版
--     media/lua/client/Vehicles/ISUI/ISVehicleMechanics.lua 里定义，而本文件在 shared/ 下，
--     无法假定这两个全局在加载期已存在；boot 时全部 lua 已装载完，是可靠兜底。
-- 重复调用由 KI5_CN_Hardcoded.say / .mechanics / .onCreate_* 标志挡住，幂等。
apply()
if Events and Events.OnGameBoot then
    Events.OnGameBoot.Add(apply)
end
