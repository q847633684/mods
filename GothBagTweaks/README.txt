Tomb Wardrobe Local Patches  (local patch mod)
==============================================

目的
  把你对 Tomb's Wardrobe - Alternative [VANILLA] 的自定义改动集中到这里,
  这样 Steam 更新那个 mod 时你的改动不会被覆盖。
  来源 mod: 工坊 3616536783, id TombWardrobeALTVanilla (游戏 42.21 -> 加载它的 42.20 分支)

  ⚠ 2026-10-17 变更: 已按要求**移除对哥特风背包的全部修补**
  (Bag_Goth_Loose / Bag_Goth_Tight / Bag_L_Loose / Bag_L_Tight)。
  这四件现在完全使用 Tomb 原脚本: 不再有水袋、不再改破洞/挂载位,
  容量与减重也完全由 Tomb 自己的沙盒选项控制, 本补丁不再插手。
  原物品脚本已停用并备份到 tools\backup\GothBagTweaks.txt.disabled,
  以后想恢复水袋方案时可以从这里取回(不建议直接启用, 联机需要服务端同步)。

一、哥特风背包 —— 已移除
  2026-10-17 起本补丁不再声明、也不再运行时修改这四件背包。
  原因: 重声明已有物品 + FluidContainer 在联机下不稳定(背包被识别成水袋背包,
  容量与沙盒设置不一致)。现在它们就是 Tomb 原版物品。
  如仍想要"哥特背包带水袋", 需要另做方案(不能复用原版 HydrationBackpack 的
  容器 ID, 且客户端/服务端必须同一份文件), 不要直接用备份文件覆盖回来。

二、全包衣(自定义数值)
  TombAlternative.Catsuit_Full / Catsuit_Full_Open / Catsuit_Full_Open2
  这三件是你自己改过的版本, 与 Tomb 出厂值(以非 VANILLA 的 42.20 分支为对照)差异:

    参数                      出厂              你的
    BiteDefense               10                100
    ScratchDefense            20                100
    BulletDefense             (无)              100
    CoveredParts              (无)              Neck;Torso;Back;LowerBody;Groin;双臂;双腿;Feet;Hands
    BloodLocation             无 Neck           加 Neck
    EquipSound                EquipSatchel      EquipLeather
    Weight                    1.5               0.5
    Insulation                Full 0.6          Full 0.9 / _Open 0.4 / _Open2 0.15
    WindResistance            0.6 / 0.4 / 0.4   0.95 / 0.45 / 0.2
    WaterResistance           (无)              0.95
    RunSpeedModifier          (无)              0.98
    CombatSpeedModifier       (无)              0.98
    ConditionMax              (无)              100
    ConditionLowerChance      (无)              95   ← 你原来的写法名字无效(原版 0 次使用)
                                                     补丁副本里已改为 ConditionLowerChanceOneIn = 95
                                                     (即 1/95 概率掉 1 点耐久, 真的生效)
    Researchablerecipes       (无)              SewCatsuitFull

  同一家族另外 9 件也套用了上面的数值模板(生成器 $CatsuitFamilyFullTemplate):
    TombAlternative.Catsuit / _Open / _Open2
    TombAlternative.Catsuit_Sleeveless / _Open / _Open2
    TombAlternative.Bodysuit / _Open / _Open2
  套用内容: Bite/Scratch/Bullet = 100, Weight = 0.5, RunSpeed/CombatSpeed = 0.98,
  ConditionMax = 100, ConditionLowerChanceOneIn = 95(用正确参数名, 真的会掉耐久),
  CanHaveHoles = false, 保暖/防风按状态: 闭合 0.9/0.95、拉开 0.4/0.45、完全拉开 0.15/0.2,
  WaterResistance = 0.95。

  覆盖范围**不统一**, 按每件衣服的实际形态保留各自的 BloodLocation
  (防御只落在这些部位上; 原版规则: 覆盖范围由 BodyLocation/BloodLocation 决定,
   且原版 1395 件里"有防御却没写 BloodLocation"的 = 0 件):

    物品                  BloodLocation                          实际覆盖
    Catsuit_Full(你的)     Trousers;ShirtLongSleeves;Hands;Shoes;Neck  双腿+躯干+手臂+手+脚+颈(全身)
    Catsuit                Trousers;ShirtLongSleeves;Neck         双腿+躯干+手臂+颈(不含手/脚)
    Catsuit_Sleeveless     Trousers;ShirtNoSleeves                双腿+躯干(不含手臂/手/脚/颈)
    Bodysuit               Trousers;ShirtNoSleeves                躯干+双腿(不含手臂/手/脚/颈)

  这里刻意**不写 CoveredParts**: 原版 1395 件 0 引用(基本无效), 写了还会与上面的覆盖描述冲突。

三、缝制配方 SewCatsuitFull
  module Base 的 craftRecipe, 由 42\media\scripts\recipes\recipes_tomb_catsuit.txt 提供
  (该文件在本文件夹里原本就有, 2026/9/23, 内容与 Tomb 的 42.20 分支逐字节一致:
   8 皮革条 + 3 线/麻绳 + 针 + 剪刀/利刃, 200 时间, 裁缝 3 级, 3 级自动学会)。
  注意: B42 的 craftRecipe 按名字索引(getScriptManager():getCraftRecipe(name)), 同名后加载的覆盖先加载的。
  同一个 mod 里只能有一份定义, 所以补丁里没有再放第二份(否则会被合并成双倍材料)。
  游戏内请确认一次: 制作菜单里"缝制全身皮质紧身衣"的材料是 8 皮革条 + 3 线/麻绳(不是翻倍)。
  console.txt 里会打印 [TombPatches] recipe SewCatsuitFull: inputs=4 outputs=1 —— 正常值;
  若显示 inputs=8 说明两个来源被合并了, 把 recipes_tomb_catsuit.txt 删掉即可(改用 Tomb 自带配方)。

四、服装参数补齐（B 档, 172 件）
  只补"机制完整性", 不加任何 Bite/Scratch/Bullet 防御, 也不动 RunSpeed/CombatSpeed。
  逐件规则(仅在该参数缺失时才写, 已有的一律保留):
    Tags                 按材质追加撕裂标签 base:ripclothingcotton/denim/leather
                         (原有标签保留, 如 base:isfirefuel;base:isfiretinder → 追加在后面)
    FabricType           皮质兜帽/束具/手套/部分内衣补 Leather 或对应材质
    CanHaveHoles = true  87 件主体衣物(上衣/裤/短裤/裙/连衣裙/外套/连体衣/手套/束腰);
                         帽子与鞋保持原样(原版帽子 182/183 是 false)
    ConditionMax + ConditionLowerChanceOneIn
                         外套 30/20、连体衣 30/20、裤装 24/12、束腰与手套 20/10
    WaterResistance      连体衣 0.40; 皮裤/束腰/束具/皮手套/皮兜帽 0.35
    DiscomfortModifier   外套与连体衣 0.05(平衡保暖)
  未包含: 3 件全包衣(你自己改过, 故意排除)、BiteDefense/ScratchDefense/BulletDefense、
          CombatSpeedModifier、眼镜(原版本来就只写 Cosmetic/ChanceToFall/VisualAid)。
  B 档影响: 会破洞(可针线+补丁修)、会磨损、皮衣略闷、能撕成材料 —— 属于真实感/平衡, 不是加强。

五、束具 / 内衣配饰 100% 防御（27 件, 按覆盖部位生效）
  做法照抄原版 100% 护具(Bite=100/Scratch=100) + 原版护档 AthleticCup 的写法:
  给每件补 BloodLocation(部位映射) 再写 BiteDefense/ScratchDefense = 100。
  原版证据: 1395 件里"有防御值但没写 BloodLocation"的 = 0 件; 原版护臂/护颈/防暴盔/牛仔靴
  一律 100 + 明确 BloodLocation, 且从不用 CoveredParts。所以防御只落在这些部位上:

    部位(BloodLocation)      物品
    UpperBody                 GothHarness, GothHarness_Over, Pasties, GstringBra, GstringBraBlack,
                              LeatherBra, StdBra, Suspenders
    UpperLeg_L;UpperLeg_R     GothLegHarness, GothLegHarness_Over
    UpperLeg_L / _R           SpikedGarterL / SpikedGarterR
    Trousers(双腿)            Tights_10D / 30D / 60D / Ripped / Zombie
    LowerLeg_L;LowerLeg_R     Stockings_10D / 30D / 60D, SpikedGarterBoth
    Groin                     Gstring, GstringBlack, LeatherUnderwear, StdUnderwear
    Neck                      SpikedCollar, SpikedCollarDouble

  按玩家要求**移出防御表**的 10 件(不再有 100 防御/BloodLocation):
    SwordEarrings(原 Head → 会让头部免疫)
    SpikedWristL / R / Both / DoubleL / DoubleR / DoubleBoth(6 件, 图层是手指槽, 判定不可靠)
    SwordNecklace / DravenNecklace(首饰层, 护颈偏强)
    BigBelt(腰带层, 护整躯干偏强)
  SpikedGarterBoth(铆钉吊袜带-双腿): 按玩家要求**完整与长筒袜一致** ——
    图层 base:underwearextra1(丝袜层) + 覆盖 LowerLeg_L;LowerLeg_R。
    ⚠ 副作用: 它与丝袜/连裤袜同槽位, 不能再和丝袜同时穿。

  另外: BulletDefense = 100 也一起写了(生成器开关 $IncludeBulletDefense);
  这些件里原本没写 CanHaveHoles 的补成 false(避免破洞削弱防护, 开关 $LockHolesOnDefenseItems)。

  ⚠ 仍需实测的点:
    1) 束具四件用的是 mod 自定义槽 twa:twharnessunder/over、twa:twlegharnessunder/over。
       若实测不生效, 可把 BodyLocation 换成原版躯干/腿部图层(如 base:torso_extra)。
  逐件明细见 TombClothing-Applied.txt(改了什么) 与 TombClothing-Audit.md(审计与依据)。

六、开局赠送哥特胸挂（沙盒选项）
  新角色开局直接把三件胸挂放进背包。选项挂在 Tomb 自己的沙盒页里, 创建世界时在
  "Tomb's Wardrobe - Alternative" 那一页的最下面:

    选项名(沙盒里显示的名字)                              默认   发放的物品
    TWALT.GothStartKit            开局赠送哥特胸挂(总开关)  开     —— 总开关, 关掉一件都不发
    TWALT.GothStartKitFull        全套胸挂 - 宽松           开     TombAlternative.Goth_ChestRigFull_Loose
    TWALT.GothStartKitFullTight   全套胸挂 - 紧身           开     TombAlternative.Goth_ChestRigFull_Tight
    TWALT.GothStartKitSmall       小号胸挂 - 宽松           开     TombAlternative.Goth_ChestRig_Loose

  发放时机与判定:
    * 新角色: 与原版 SpawnItems 同一个时机(Events.OnNewGame); 多人时只在服务端发放。
    * 老存档: 读档时补发一次(Events.OnCreatePlayer), 所以本选项出现之前建的角色也能拿到。
    * 每个角色只发一次: 标记写在角色 modData 的 GothStartKitGiven 上, 反复读档不会重复给。
      某件物品 ID 发不出去时不会打标记, 修好加载顺序后下次读档还会再试。
    * 关闭方式: 三件都取消勾选, 或关掉总开关(新建世界时生效); 也可以直接把
      42\media\sandbox-options.txt 里的 default = true 改成 false。
    * Full_Tight 与 Full_Loose 数值完全相同(8 容量 / 80% 减重), 只是穿着外观不同,
      右键菜单可互相切换 —— 两件都发等于两套等价胸挂, 不想要就取消勾选 Tight 那一条。
  console.txt 日志:
    [GothStartKit] start kit given: TombAlternative.Goth_ChestRigFull_Loose, ...   (发放成功)
    [GothStartKit] item not found: ...   (Tomb 的 mod 没启用, 或加载顺序反了)

七、自定义角色界面的槽位名称（UI_ClothingType_* 显示成原始键）
  Tomb 在 registries.lua 里注册了 10 个自定义服装槽位(twa:*), 但没有提供对应的
  UI_ClothingType_<槽位> 翻译键, 于是"自定义角色"界面里它们显示成
  UI_ClothingType_twa:twduffel 这种原始键名。修法就是补翻译键(放本补丁里, 不会被 Tomb 更新覆盖):
    42\media\lua\shared\Translate\CN\UI.json / EN / CH
  已补的 10 个: twduffel 行李袋(背挂) / twduffellow 行李袋(低位) / twharnessover 束带(外穿) /
  twharnessunder 束带(内穿) / twlegharnessover 腿部束带(外穿) / twlegharnessunder 腿部束带(内穿) /
  twjacket 皮夹克(Tomb层) / twtrenchcoat 风衣(Tomb层) / twsleeves 袖套 / twxlcoffin XL棺材背包
  注意: 翻译在游戏启动时加载, 改完要**重启游戏**才生效(回主菜单重载 Lua 不够)。
  另外: 全工坊共 40 个自定义槽位缺翻译(含其他 mod: Authentic Z 7 个、NaturesCall 5 个、
  tabas 2 个、radarchery 1 个、casualtiesundead 2 个 等), 需要的话可以一起补。

文件
  mod.info                                        根声明
  42\mod.info                                     B42 分支声明 (require=TombWardrobeALTVanilla)
  42\media\scripts\clothing\GothBagTweaks.txt     已停用(哥特背包重声明), 备份在 tools\backup\*.disabled
  42\media\scripts\clothing\TombCatsuitTweaks.txt 全包衣三件重声明(你的数值)
  42\media\scripts\clothing\TombClothingTweaks.txt 172 件: B 档补齐 + 27 件 100% 防御件 + 9 件连体衣套用 Catsuit_Full 模板
  42\media\scripts\recipes\recipes_tomb_catsuit.txt 缝制全身皮质紧身衣配方(文件夹里原有)
  42\media\sandbox-options.txt                    开局赠送的沙盒选项(挂在 TWALT 页)
  42\media\lua\shared\GothStartKit.lua            开局发放逻辑 + [GothStartKit] 日志
  42\media\lua\shared\Translate\EN\Sandbox.json   新选项的英文本
  42\media\lua\shared\Translate\CN\Sandbox.json   新选项的简体文本
  42\media\lua\shared\Translate\CH\Sandbox.json   新选项的繁体文本
  42\media\lua\shared\Translate\{EN,CN,CH}\UI.json 自定义角色界面 10 个 twa:* 槽位名称(第七节)
  42\media\lua\server\GothBagTweaks.lua           运行时保险 + [TombPatches] 日志
  TombWardrobe-Item-List.md                       Tomb 模组全部 201 件物品清单(中文名/ID/贴图数)
  TombClothing-Audit.md                           175 件服装逐件审计 + 建议(含原版基准)
  TombClothing-Applied.txt                        实际改动清单(172 件 → 补了哪些参数)
  tools\regenerate-clothing-patch.ps1             生成器(Tomb 更新后重跑即可重算+重校验)

使用
  1. 主菜单 -> Mods, 勾选 "Tomb Wardrobe Local Patches (Catsuit + Clothing)"。
     mod.info 写了 require=TombWardrobeALTVanilla, 正常会自动排到 Tomb 的 mod 后面;
     若 Mod Manager 里排到前面, 手动拖到 Tomb's Wardrobe - Alternative [VANILLA] 之后。
  2. 进游戏后 console.txt 应出现 3 行 [TombPatches]:
       [TombPatches] patched catsuit: 3 / 3
       [TombPatches] patched clothing items: 172 / 172
       [TombPatches] recipe SewCatsuitFull: inputs=4 outputs=1
     出现 "item not found" 说明 Tomb 没启用或加载顺序反了。
     开局赠送那部分另有一行 [GothStartKit] start kit given: ... (见第六节)。
  3. 100% 防御件生效验证: 装上束具/内衣后看健康面板该部位的 Bite/Scratch 防御; 或实战测试。
     注意换装后防御需要重新计算, 建议脱掉再穿上一次。
  4. 想改开局赠送内容: 按第六节改沙盒勾选, 或直接改 42\media\sandbox-options.txt 的 default。

注意
  * 哥特背包补丁已整体移除(见开头说明)。现在这四件包不使用本补丁的任何脚本/运行时代码,
    水袋、破洞、挂载位、容量全部回到 Tomb 原版行为; 改容量请直接用 Tomb 自己的沙盒选项
    (TWALT.CapacityGothbag / ReductionGothbag / CapacityLbag / ReductionLbag)。
    联机时这些选项要在**服务端**改, 且客户端/服务端必须是同一份 mod 文件。
  * 沙盒选项只在创建世界时能改(单人)。老存档里这个新选项按默认值(开)生效, 所以第一次读档就会补发;
    之后想彻底关掉, 只能改 42\media\sandbox-options.txt 的 default 后再新建世界。
  * 以后改数值请同时改 .txt 和 .lua 两处(或只改 .txt 后不要再依赖 Lua 保险)。
  * Tomb 的 mod 更新后如果改了这些物品块的结构(贴图、ClothingItemExtra、BodyLocation 等),
    需要用新版块重新同步一次。
  * 变体: 工坊条目 3616536783 下有两个 mod ——
      "Tomb's Wardrobe - Alternative"          id=TombWardrobeALT        需要 TombBody 前置
      "Tomb's Wardrobe - Alternative [VANILLA]" id=TombWardrobeALTVanilla 不需要前置
    存档 mods.txt / console.txt 显示你启用的是后者, 本补丁的 require 也指向它, 直接可用。
    若要改用前者(必须先装 TombBody 前置, 否则游戏加载不起来), 运行:
      pwsh -File tools\regenerate-clothing-patch.ps1 -Variant ALT
    它会按那个分支(181 件, 多 6 件指甲油)重新生成, 并把两个 mod.info 的 require 行改成
    TombWardrobeALT(只动这一行, 其余字段保留)。切回: -Variant VANILLA。
  * 卸载: 直接删掉 GothBagTweaks 文件夹, 并在 Mods 列表取消勾选(改动随之回到 Tomb 出厂值)。
