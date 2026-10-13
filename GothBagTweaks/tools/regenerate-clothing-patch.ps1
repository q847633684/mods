param(
    [ValidateSet('VANILLA','ALT')]
    [string]$Variant = 'VANILLA'
)
$ErrorActionPreference = 'Stop'
# ============================================================================
#  Tomb Wardrobe Local Patches - clothing patch generator
#  用法: pwsh -File regenerate-clothing-patch.ps1 [-Variant VANILLA|ALT]
#    VANILLA (默认) = 工坊 3616536783 里的 "Tomb's Wardrobe - Alternative [VANILLA]"
#                     id TombWardrobeALTVanilla, 不需要前置
#    ALT            = 同工坊条目里的 "Tomb's Wardrobe - Alternative"
#                     id TombWardrobeALT, 需要 TombBody 前置
#  生成: 42\media\scripts\clothing\TombClothingTweaks.txt
#        42\media\lua\server\GothBagTweaks.lua  (CLOTHING 表)
#        TombClothing-Applied.txt               (改动清单)
#  开关:
#    $IncludeBulletDefense      = 防御件是否也给 BulletDefense = 100
#    $LockHolesOnDefenseItems   = 防御件是否锁 CanHaveHoles = false
#    $CatsuitFamilyFullTemplate = 全身连体衣(除玩家自改的 3 件)是否整份套用 Catsuit_Full 模板
# ============================================================================

$IncludeBulletDefense      = $true
$LockHolesOnDefenseItems   = $true
$CatsuitFamilyFullTemplate = $true

$variants = @{
    'VANILLA' = @{ Id = 'TombWardrobeALTVanilla'; Name = "Tomb's Wardrobe - Alternative [VANILLA]"; Dir = "Tomb's Wardrobe - Alternative - Vanilla" }
    'ALT'     = @{ Id = 'TombWardrobeALT';        Name = "Tomb's Wardrobe - Alternative";           Dir = "Tomb's Wardrobe - Alternative" }
}
$v = $variants[$Variant]
$base = "C:\Program Files (x86)\Steam\steamapps\workshop\content\108600\3616536783\mods\$($v.Dir)\42.20"
$src = Join-Path $base "media\scripts\clothing\tomb_clothingitems.txt"
$modDir = "$env:USERPROFILE\Zomboid\mods\GothBagTweaks"
$outTxt = Join-Path $modDir "42\media\scripts\clothing\TombClothingTweaks.txt"
$outLua = Join-Path $modDir "42\media\lua\server\GothBagTweaks.lua"
$outList = Join-Path $modDir "TombClothing-Applied.txt"
Write-Host "变体: $Variant  ->  $($v.Name) (id=$($v.Id))"
if (-not (Test-Path $src)) { throw "找不到源文件: $src" }

# ---------- 束具 / 内衣配饰 100% 防御表: 物品 -> 覆盖部位(BloodLocation) ----------
# 玩家决定移除的: SpikedWrist*(6, 槽位是手指槽) / SwordNecklace / DravenNecklace / BigBelt
$defenseMap = [ordered]@{
    'GothHarness'             = 'UpperBody'
    'GothHarness_Over'        = 'UpperBody'
    'GothLegHarness'          = 'UpperLeg_L;UpperLeg_R'
    'GothLegHarness_Over'     = 'UpperLeg_L;UpperLeg_R'
    'Pasties'                 = 'UpperBody'
    'GstringBra'              = 'UpperBody'
    'GstringBraBlack'         = 'UpperBody'
    'LeatherBra'              = 'UpperBody'
    'StdBra'                  = 'UpperBody'
    'Suspenders'              = 'UpperBody'
    'Gstring'                 = 'Groin'
    'GstringBlack'            = 'Groin'
    'LeatherUnderwear'        = 'Groin'
    'StdUnderwear'            = 'Groin'
    'Tights_10D'              = 'Trousers'
    'Tights_30D'              = 'Trousers'
    'Tights_60D'              = 'Trousers'
    'Tights_Ripped'           = 'Trousers'
    'Tights_Zombie'           = 'Trousers'
    'Stockings_10D'           = 'LowerLeg_L;LowerLeg_R'
    'Stockings_30D'           = 'LowerLeg_L;LowerLeg_R'
    'Stockings_60D'           = 'LowerLeg_L;LowerLeg_R'
    'SpikedCollar'            = 'Neck'
    'SpikedCollarDouble'      = 'Neck'
    'SpikedGarterL'           = 'UpperLeg_L'
    'SpikedGarterR'           = 'UpperLeg_R'
    'SpikedGarterBoth'        = 'LowerLeg_L;LowerLeg_R'   # 按玩家要求: 完整和长筒袜一致
}

# ---------- 单件覆盖/图层改写(放在防御块之后生效) ----------
# SpikedGarterBoth: 图层从原版吊袜带层 extra2 挪到丝袜层 extra1 (玩家要求完整和丝袜一致)
$bodyLocationOverrides = [ordered]@{
    'SpikedGarterBoth' = 'base:underwearextra1'
}
$bloodLocationOverrides = [ordered]@{
    'SpikedGarterBoth' = 'LowerLeg_L;LowerLeg_R'
}

# ---------- 全身连体衣家族的"状态"(闭合 / 拉开 / 完全拉开) ----------
# 除玩家自改的 Catsuit_Full 三件之外, 其余 9 件套用 Catsuit_Full 的模板。
$catsuitFamily = [ordered]@{
    'Catsuit'                  = 'closed'
    'Catsuit_Open'             = 'open'
    'Catsuit_Open2'            = 'open2'
    'Catsuit_Sleeveless'       = 'closed'
    'Catsuit_Sleeveless_Open'  = 'open'
    'Catsuit_Sleeveless_Open2' = 'open2'
    'Bodysuit'                 = 'closed'
    'Bodysuit_Open'            = 'open'
    'Bodysuit_Open2'           = 'open2'
}
$catsuitStateInsul = @{ 'closed' = '0.9'; 'open' = '0.4'; 'open2' = '0.15' }
$catsuitStateWind  = @{ 'closed' = '0.95'; 'open' = '0.45'; 'open2' = '0.2' }
$catsuitBlood      = 'Trousers;ShirtLongSleeves;Hands;Shoes;Neck'
$catsuitCovered    = 'Neck;Torso;Back;LowerBody;Groin;LeftArm;RightArm;LeftLeg;RightLeg;Feet;Hands'

# ---------- 解析源文件 ----------
$lines = Get-Content $src
$blocks = New-Object System.Collections.Generic.List[object]
$cur = $null
foreach ($ln in $lines) {
    if ($ln -match '^\s*item\s+([A-Za-z0-9_]+)\s*$') {
        if ($cur) { $blocks.Add($cur) }
        $cur = [pscustomobject]@{ Id = $Matches[1]; Lines = (New-Object System.Collections.Generic.List[string]) }
    }
    elseif ($cur) {
        if ($ln -match '^\s*\}\s*$') { $blocks.Add($cur); $cur = $null }
        elseif ($ln -match '^\s*\{\s*$' -and $cur.Lines.Count -eq 0) { }
        else { $cur.Lines.Add($ln) }
    }
}
Write-Host "源文件服装件数: $($blocks.Count)"

function Get-Cat($id) {
    if ($id -match '^(Catsuit|Bodysuit)') { return '全身连体衣' }
    if ($id -match '^(Dress|Turtleneck)') { return '连衣裙' }
    if ($id -match '^(Jeans|GothJeans|LeatherPants|LeatherHotPants|TacPants)') { return '裤装' }
    if ($id -match '(Microshorts|Minishorts|Highshorts)') { return '短裤' }
    if ($id -match 'Skirt') { return '裙子' }
    if ($id -match 'Corset') { return '束腰' }
    if ($id -match 'Harness') { return '束具' }
    if ($id -match '^(LeatherJacket|Trenchcoat|Jacket)') { return '外套/大衣' }
    if ($id -match '^(WornT|Tattered|Tank|LeatherTank|LeatherBandeau|Haltertop)') { return '上衣' }
    if ($id -match '(Gloves|Armbands)') { return '手套/臂套' }
    if ($id -match '^Shoes') { return '鞋靴' }
    if ($id -match '(Hood|Mask|Bandana|Cap)') { return '头饰/面罩' }
    if ($id -match 'Shades') { return '眼镜' }
    return '内衣/配饰'
}
function Get-Mat($id, $p) {
    if ($p.Contains('FabricType')) { return $p['FabricType'] }
    if ($id -match '(Leather|Goth|Corset|Harness|Catsuit|Bodysuit|Stiletto|Squaretoe|Biker|Stomper|Hood|Gloves|Trenchcoat_L)') { return 'Leather' }
    if ($id -match 'Jeans') { return 'Denim' }
    return 'Cotton'
}
$ripTag = @{ Leather = 'base:ripclothingleather'; Denim = 'base:ripclothingdenim'; Cotton = 'base:ripclothingcotton' }
$skip = @('Catsuit_Full', 'Catsuit_Full_Open', 'Catsuit_Full_Open2')   # 玩家自己改过的, 不动

# ---------- 生成 ----------
$out = New-Object System.Collections.Generic.List[string]
$out.Add('module TombAlternative')
$out.Add('{')
$out.Add('    /* ============================================================================')
$out.Add('       Tomb Wardrobe Local Patches - generated by tools/regenerate-clothing-patch.ps1')
$out.Add('       Do not edit by hand unless you also update that script and the Lua table.')
$out.Add('')
$out.Add('       A) B tier: mechanism completeness (no defence buffs)')
$out.Add('            Tags (base:ripclothing*)  FabricType  CanHaveHoles = true')
$out.Add('            ConditionMax + ConditionLowerChanceOneIn  WaterResistance  DiscomfortModifier')
$out.Add('       B) 100% defence on harnesses / underwear-accessories, only for the parts they cover')
$out.Add('            (vanilla pattern: BloodLocation + Bite/ScratchDefense, like AthleticCup / vambraces)')
$out.Add('       C) Full catsuit family, except the player''s own 3 Catsuit_Full items:')
$out.Add('            100/100/100 defence, Weight 0.5, RunSpeed/CombatSpeed 0.98, ConditionMax 100,')
$out.Add('            ConditionLowerChanceOneIn 95, CanHaveHoles false, BloodLocation + CoveredParts,')
$out.Add('            Insulation/WindResistance by state (closed 0.9/0.95, open 0.4/0.45, open2 0.15/0.2),')
$out.Add('            WaterResistance 0.95 - i.e. the Catsuit_Full template.')
$out.Add('')
$out.Add('       Excluded: Catsuit_Full / _Open / _Open2 (player''s own edits, see TombCatsuitTweaks.txt).')
$out.Add('       ============================================================================ */')
$out.Add('')

$luaEntries = New-Object System.Collections.Generic.List[string]
$stat = @{}
$report = New-Object System.Collections.Generic.List[string]
$changed = 0; $defenseCount = 0; $catsuitCount = 0; $overrideCount = 0

foreach ($b in $blocks) {
    $p = [ordered]@{}
    foreach ($ln in $b.Lines) {
        if ($ln -match '^\s*([A-Za-z_]+)\s*=\s*(.+?),?\s*$') { $p[$Matches[1]] = $Matches[2].TrimEnd(',') }
    }
    $id = $b.Id
    if ($skip -contains $id) { continue }

    $cat = Get-Cat $id
    $mat = Get-Mat $id $p
    $has = { param($k) $p.Contains($k) }
    $isCatsuitFamily = ($CatsuitFamilyFullTemplate -and $catsuitFamily.Contains($id))
    $set = [ordered]@{}          # 参数 -> 新值 (覆盖或新增)

    # ---- Tags (合并, 不覆盖其它标签) ----
    $wantRip = $ripTag[$mat]
    if (-not (& $has 'Tags')) { $set['Tags'] = $wantRip }
    elseif ($p['Tags'] -notmatch 'ripclothing') { $set['Tags'] = $p['Tags'] + ';' + $wantRip }

    # ---- FabricType ----
    if (-not (& $has 'FabricType')) {
        if ($cat -in '头饰/面罩', '手套/臂套' -and $mat -eq 'Leather') { $set['FabricType'] = 'Leather' }
        elseif ($cat -eq '束具') { $set['FabricType'] = 'Leather' }
        elseif ($cat -eq '内衣/配饰' -and $mat -ne 'Cotton') { $set['FabricType'] = $mat }
    }

    # ---- A) B 档: 按分类补齐(只补缺失) ----
    if (-not $isCatsuitFamily) {
        switch ($cat) {
            '外套/大衣' {
                if (-not (& $has 'CanHaveHoles')) { $set['CanHaveHoles'] = 'true' }
                if (-not (& $has 'ConditionMax')) { $set['ConditionMax'] = '30' }
                if (-not (& $has 'ConditionLowerChanceOneIn')) { $set['ConditionLowerChanceOneIn'] = '20' }
                if (-not (& $has 'DiscomfortModifier')) { $set['DiscomfortModifier'] = '0.05' }
            }
            '裤装' {
                if (-not (& $has 'CanHaveHoles')) { $set['CanHaveHoles'] = 'true' }
                if (-not (& $has 'ConditionMax')) { $set['ConditionMax'] = '24' }
                if (-not (& $has 'ConditionLowerChanceOneIn')) { $set['ConditionLowerChanceOneIn'] = '12' }
                if (-not (& $has 'WaterResistance') -and $mat -eq 'Leather') { $set['WaterResistance'] = '0.35' }
            }
            '全身连体衣' {
                if (-not (& $has 'CanHaveHoles')) { $set['CanHaveHoles'] = 'true' }
                if (-not (& $has 'ConditionMax')) { $set['ConditionMax'] = '30' }
                if (-not (& $has 'ConditionLowerChanceOneIn')) { $set['ConditionLowerChanceOneIn'] = '20' }
                if (-not (& $has 'WaterResistance')) { $set['WaterResistance'] = '0.40' }
                if (-not (& $has 'DiscomfortModifier')) { $set['DiscomfortModifier'] = '0.05' }
            }
            '束腰' {
                if (-not (& $has 'CanHaveHoles')) { $set['CanHaveHoles'] = 'true' }
                if (-not (& $has 'ConditionMax')) { $set['ConditionMax'] = '20' }
                if (-not (& $has 'ConditionLowerChanceOneIn')) { $set['ConditionLowerChanceOneIn'] = '10' }
                if (-not (& $has 'WaterResistance')) { $set['WaterResistance'] = '0.35' }
            }
            '束具' { if (-not (& $has 'WaterResistance')) { $set['WaterResistance'] = '0.35' } }
            '手套/臂套' {
                if (-not (& $has 'CanHaveHoles')) { $set['CanHaveHoles'] = 'true' }
                if (-not (& $has 'ConditionMax')) { $set['ConditionMax'] = '20' }
                if (-not (& $has 'ConditionLowerChanceOneIn')) { $set['ConditionLowerChanceOneIn'] = '10' }
                if (-not (& $has 'WaterResistance') -and $mat -eq 'Leather') { $set['WaterResistance'] = '0.35' }
            }
            '头饰/面罩' { if (-not (& $has 'WaterResistance') -and $mat -eq 'Leather') { $set['WaterResistance'] = '0.35' } }
            '上衣' { if (-not (& $has 'CanHaveHoles')) { $set['CanHaveHoles'] = 'true' } }
            '短裤' { if (-not (& $has 'CanHaveHoles')) { $set['CanHaveHoles'] = 'true' } }
            '裙子' { if (-not (& $has 'CanHaveHoles')) { $set['CanHaveHoles'] = 'true' } }
            '连衣裙' { if (-not (& $has 'CanHaveHoles')) { $set['CanHaveHoles'] = 'true' } }
        }
    }

    # ---- B) 100% 防御(束具 / 内衣配饰) ----
    if ($defenseMap.Contains($id)) {
        if (-not (& $has 'BloodLocation')) { $set['BloodLocation'] = $defenseMap[$id] }
        $set['BiteDefense'] = '100'
        $set['ScratchDefense'] = '100'
        if ($IncludeBulletDefense) { $set['BulletDefense'] = '100' }
        if ($LockHolesOnDefenseItems -and -not (& $has 'CanHaveHoles')) { $set['CanHaveHoles'] = 'false' }
        $defenseCount++
    }

    # ---- 单件改写(图层/覆盖), 在防御块之后生效 ----
    if ($bodyLocationOverrides.Contains($id)) { $set['BodyLocation'] = $bodyLocationOverrides[$id] }
    if ($bloodLocationOverrides.Contains($id)) { $set['BloodLocation'] = $bloodLocationOverrides[$id] }

    # ---- C) 全身连体衣家族: 套用 Catsuit_Full 模板 ----
    if ($isCatsuitFamily) {
        $state = $catsuitFamily[$id]
        $set['BiteDefense'] = '100'
        $set['ScratchDefense'] = '100'
        if ($IncludeBulletDefense) { $set['BulletDefense'] = '100' }
        $set['Weight'] = '0.5'
        $set['RunSpeedModifier'] = '0.98'
        $set['CombatSpeedModifier'] = '0.98'
        $set['ConditionMax'] = '100'
        $set['ConditionLowerChanceOneIn'] = '95'
        if (-not (& $has 'CanHaveHoles')) { $set['CanHaveHoles'] = 'false' }
        # 覆盖范围不统一: 每件保留自己的 BloodLocation, 才能按衣服实际形态区分 ——
        #   Catsuit_Full   Trousers;ShirtLongSleeves;Hands;Shoes;Neck  (全身, 含手/脚/颈)
        #   Catsuit        Trousers;ShirtLongSleeves                   (双腿+躯干+手臂, 不含手/脚)
        #   无袖 Sleeveless Trousers;ShirtNoSleeves                    (双腿+躯干, 不含手臂/手/脚)
        #   Bodysuit       ShirtNoSleeves                              (仅躯干, 不含腿/手/脚)
        # 只在缺失时才补一个默认值。
        if (-not (& $has 'BloodLocation')) { $set['BloodLocation'] = $catsuitBlood }
        # Catsuit(有袖紧身衣) 按玩家要求补脖子: Trousers;ShirtLongSleeves;Neck
        #   = 双腿+躯干+手臂+颈, 仍然不含手/脚
        if ($id -match '^Catsuit(_Open2?)?$') { $set['BloodLocation'] = 'Trousers;ShirtLongSleeves;Neck' }
        # Bodysuit(皮质连体衣) 按玩家要求补上双腿覆盖: Trousers;ShirtNoSleeves
        #   = 躯干 + 双腿, 仍然不含手臂/手/脚
        if ($id -match '^Bodysuit') { $set['BloodLocation'] = 'Trousers;ShirtNoSleeves' }
        # 不写 CoveredParts: 原版 1395 件 0 引用(基本无效), 且会与上面的覆盖范围描述冲突
        $set['Insulation'] = $catsuitStateInsul[$state]
        $set['WindResistance'] = $catsuitStateWind[$state]
        $set['WaterResistance'] = '0.95'
        $catsuitCount++
    }

    if ($set.Count -eq 0) { continue }
    $changed++

    # 统计 + 清单
    $desc = New-Object System.Collections.Generic.List[string]
    foreach ($k in $set.Keys) {
        $stat["$k = $($set[$k])"] = 1 + ($stat["$k = $($set[$k])"] -as [int])
        if ($p.Contains($k)) {
            if ($p[$k] -ne $set[$k]) { $desc.Add("$k = $($set[$k])  (原 $($p[$k]))"); $overrideCount++ }
        }
        else { $desc.Add("$k = $($set[$k])") }
    }
    $report.Add(("{0}`t{1}`t{2}" -f $id, $cat, ($desc -join ' ; ')))
    $luaEntries.Add("        { `"TombAlternative.$id`", { $(($set.Keys | ForEach-Object { '"' + $_ + ' = ' + $set[$_] + '"' }) -join ', ') } },")

    # 写块: 原有行按 $set 就地改值(只改第一次出现), 其余原样; 末尾补上没出现过的
    $out.Add("    item $id")
    $out.Add('    {')
    $applied = @{}
    foreach ($ln in $b.Lines) {
        $m = [regex]::Match($ln, '^\s*([A-Za-z_]+)\s*=\s*.+?,?\s*$')
        if ($m.Success -and $set.Contains($m.Groups[1].Value) -and -not $applied.ContainsKey($m.Groups[1].Value)) {
            $k = $m.Groups[1].Value
            $out.Add("        $k = $($set[$k]),")
            $applied[$k] = $true
        }
        else { $out.Add($ln.TrimEnd()) }
    }
    foreach ($k in $set.Keys) { if (-not $applied.ContainsKey($k)) { $out.Add("        $k = $($set[$k]),") } }
    $out.Add('    }')
    $out.Add('')
}
$out.Add('}')
$out -join "`r`n" | Set-Content $outTxt -Encoding UTF8

# ---------- 重新生成 Lua ----------
$clothingLua = $luaEntries -join "`r`n"
$luaTemplate = @'
-- Tomb Wardrobe Local Patches - runtime safety net.
-- CLOTHING section is generated by tools/regenerate-clothing-patch.ps1
--
-- The 1.5 L hydration bladder on the goth backpack can ONLY come from the item
-- script (Lua cannot add a component). Everything else is plain script parameters,
-- re-applied at runtime so a wrong load order cannot revert them.

local BAGS = {
    "TombAlternative.Bag_Goth_Loose",
    "TombAlternative.Bag_Goth_Tight",
    "TombAlternative.Bag_L_Loose",
    "TombAlternative.Bag_L_Tight",
}

local SLOTS = "SmallBeltLeft;SmallBeltRight;WebbingRight;WebbingLeft;BedrollBottom"

local BAG_PARAMS = {
    "CanHaveHoles = true",
    "AttachmentsProvided = " .. SLOTS,
}

local CATSUIT_COMMON = {
    "DisplayCategory = Clothing",
    "ItemType = base:clothing",
    "BloodLocation = Trousers;ShirtLongSleeves;Hands;Shoes;Neck",
    "BodyLocation = base:torso1legs1",
    "EquipSound = EquipLeather",
    "FabricType = Leather",
    "CoveredParts = Neck;Torso;Back;LowerBody;Groin;LeftArm;RightArm;LeftLeg;RightLeg;Feet;Hands",
    "BiteDefense = 100",
    "ScratchDefense = 100",
    "BulletDefense = 100",
    "Weight = 0.5",
    "WaterResistance = 0.95",
    "RunSpeedModifier = 0.98",
    "CombatSpeedModifier = 0.98",
    "ConditionMax = 100",
    "ConditionLowerChanceOneIn = 95",
    "WorldStaticModel = Bodysuit_Ground",
    "Tags = base:ripclothingleather",
    "Researchablerecipes = SewCatsuitFull",
}

local CATSUITS = {
    { id = "TombAlternative.Catsuit_Full", params = { "Icon = Catsuit_1", "ClothingItem = Catsuit_Full", "ClothingItemExtra = Catsuit_Full_Open", "ClothingItemExtraOption = TWUnzip", "Insulation = 0.9", "WindResistance = 0.95" } },
    { id = "TombAlternative.Catsuit_Full_Open", params = { "Icon = Catsuit_1_O", "ClothingItem = Catsuit_Full_Open", "ClothingItemExtra = Catsuit_Full_Open2", "ClothingItemExtraOption = TWUnzip2", "Insulation = 0.4", "WindResistance = 0.45" } },
    { id = "TombAlternative.Catsuit_Full_Open2", params = { "Icon = Catsuit_1_O2", "ClothingItem = Catsuit_Full_Open2", "ClothingItemExtra = Catsuit_Full", "ClothingItemExtraOption = TWZip", "Insulation = 0.15", "WindResistance = 0.2" } },
}

local CLOTHING = {
__CLOTHING__
}

local function patchItem(sm, id, params, label)
    local item = sm:getItem(id)
    if not item then
        print("[TombPatches] item not found: " .. id .. " (is TombWardrobeALTVanilla enabled?)")
        return false
    end
    local ok, err = pcall(function()
        for _, p in ipairs(params) do
            item:DoParam(p)
        end
    end)
    if not ok then
        print("[TombPatches] ERROR while patching " .. id .. ": " .. tostring(err))
        return false
    end
    return true
end

local RECIPE_ID = "SewCatsuitFull"

local function logCatsuitRecipe()
    local ok, line = pcall(function()
        local r = ScriptManager.instance:getCraftRecipe(RECIPE_ID)
        if not r then return "NOT FOUND" end
        local ni, no = -1, -1
        pcall(function() ni = r:getInputs():size() end)
        pcall(function() no = r:getOutputs():size() end)
        return string.format("inputs=%d outputs=%d", ni, no)
    end)
    print("[TombPatches] recipe " .. RECIPE_ID .. ": " .. (ok and line or ("check failed: " .. tostring(line))))
end

local function applyPatches()
    local sm = ScriptManager.instance
    if not sm then
        print("[TombPatches] ScriptManager not available, skipped")
        return
    end

    local bagCount = 0
    for _, id in ipairs(BAGS) do
        if patchItem(sm, id, BAG_PARAMS, "goth backpack") then bagCount = bagCount + 1 end
    end
    print("[TombPatches] patched goth backpack: " .. bagCount .. " / " .. #BAGS)

    local suitCount = 0
    for _, entry in ipairs(CATSUITS) do
        local params = {}
        for _, p in ipairs(CATSUIT_COMMON) do table.insert(params, p) end
        for _, p in ipairs(entry.params) do table.insert(params, p) end
        if patchItem(sm, entry.id, params, "catsuit") then suitCount = suitCount + 1 end
    end
    print("[TombPatches] patched catsuit: " .. suitCount .. " / " .. #CATSUITS)

    local clothingCount = 0
    for _, entry in ipairs(CLOTHING) do
        if patchItem(sm, entry[1], entry[2], "clothing") then clothingCount = clothingCount + 1 end
    end
    print("[TombPatches] patched clothing items: " .. clothingCount .. " / " .. #CLOTHING)

    logCatsuitRecipe()
end

Events.OnInitGlobalModData.Add(applyPatches)
'@
$luaTemplate.Replace('__CLOTHING__', $clothingLua) | Set-Content $outLua -Encoding UTF8

# ---------- mod.info: 只改 require 行 ----------
function Update-ModInfoRequire([string]$path, [string]$requireId) {
    $lines = @()
    if (Test-Path $path) { $lines = @(Get-Content $path) }
    if ($lines.Count -eq 0) {
        $lines = @(
            'name=Tomb Wardrobe Local Patches (Goth Bag + Catsuit)',
            'id=GothBagTweaks',
            'author=local patch',
            'description=Goth backpack: 1.5 L hydration bladder, CanHaveHoles, Legendary attachment slots. Full catsuit: custom values. 172 clothing items: B-tier completeness + 100% defence on harnesses/underwear and on the catsuit family by covered part.',
            "require=$requireId"
        )
    }
    else {
        $found = $false
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^\s*require\s*=') { $lines[$i] = "require=$requireId"; $found = $true }
        }
        if (-not $found) { $lines += "require=$requireId" }
    }
    $lines -join "`r`n" | Set-Content $path -Encoding UTF8
}
Update-ModInfoRequire (Join-Path $modDir 'mod.info') $v.Id
Update-ModInfoRequire (Join-Path $modDir '42\mod.info') $v.Id

# ---------- 清单 ----------
$hdr = @(
    "Tomb Wardrobe Local Patches - clothing changes ($changed items)",
    "generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')   variant=$Variant   IncludeBulletDefense=$IncludeBulletDefense  LockHolesOnDefenseItems=$LockHolesOnDefenseItems  CatsuitFamilyFullTemplate=$CatsuitFamilyFullTemplate",
    "100% defence items (harness/underwear): $defenseCount    catsuit family (template): $catsuitCount    overridden values: $overrideCount",
    "",
    "ID`t分类`t参数(覆盖的标注原值)",
    "-----"
)
($hdr + $report) -join "`r`n" | Set-Content $outList -Encoding UTF8

Write-Host "改动物品数: $changed / $($blocks.Count)   防御件=$defenseCount   连体衣模板=$catsuitCount   覆盖改值=$overrideCount"
Write-Host "=== 追加/覆盖参数统计 ==="
$stat.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 30 | ForEach-Object { Write-Host ("  {0,-56} x{1}" -f $_.Key, $_.Value) }
Write-Host "written: $outTxt"
Write-Host "written: $outLua"
Write-Host "written: $outList"
