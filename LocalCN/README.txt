本地汉化合集 (LocalCN)
=======================

一个 mod 收齐所有本地简体中文汉化, 无依赖: 对应 mod 装了才生效, 没装则该部分键闲置(无副作用)。
共 23205 键。2026-10-17 更新。

一、包含内容 (common\media\lua\shared\Translate\CN\)
  ItemName.json         11155  物品名
  Recipes.json           8644  配方名
  IG_UI.json             2329  界面/状态文字
  ContextMenu.json        393  右键菜单
  EvolvedRecipeName.json  219  料理/进化配方名
  Tooltip.json            156  物品与制作提示
  Sandbox.json            169  沙盒选项(伤口/管道/车辆液体)
  Fluids.json              98  液体名
  UI.json                  37  界面标签 + 30 个自定义服装槽位名
  Moveables.json            5  水暖家具名
  (EN\UI.json 为上述槽位名的英文版, 保留原样)

二、收录的 mod / 本次更新内容
  1. that DAMN Library (3171167894)     原有汉化 + 42.20 新增 11 条配方
  2. Authentic Z - Lite                 原有汉化(2622 物品 + 配方/界面等)
  3. Vanilla Outfits Expanded (3783094058)
       48 个物品, 三种键名同时提供(见"四")
  4. Vanilla Gear Expanded (3401134276) 51 个物品, 新增
  5. Vanilla Foods Expanded (3577903007)
       3778852357(33Jhl 汉化, v1.0.2)的全部简体中文已迁入:
         物品名 1970、配方 340、右键 179、提示 32、液体 70、料理名 219
       并按 42.18 版补齐新版缺失 543 条:
         物品名 428(蛋糕/糖霜/蜡烛、鸡翅、馅饼等)、配方 50、右键 29、
         界面 20、液体 13、提示 2、UI 1
       合计: 物品名 2398、配方 390、右键 208、界面 20、液体 83、提示 34、料理名 219
       * 3778852357 现在可以停用(不要两个同时开, 键相同会互相覆盖, 本合集已含全部内容)
  6. Wounds Overhaul (3775026731)       293 条(界面 209、沙盒 60、物品 14、液体 10), 新增
  7. Waterpipes (3546314080)            49 条(右键 11、界面 16、家具 5、沙盒 7、提示 10), 新增
  8. Water Trailer B42 + Semi (3776875714)
       135 条(右键 25、界面 89+1、物品 19、提示 2) + VFluidLib 沙盒 30 条, 新增
  9. Plysken Battery Charger (3793465866)
       原 mod 自带的 CN 只有 "ItemName_PBC.CrankCharger" 这种键, 而它的物品脚本用的是字面
       DisplayName("Crank Battery Charger" / "Rechargeable Battery"), 所以原汉化在游戏里
       根本不生效(这也是它看起来没汉化的原因)。本合集改为字面名键并收录其界面/配方/沙盒
       共 32 条(原 CN 14 条 + 补齐新版 13 条 + 字面物品名 5 条), 现在物品名和新增选项都会正常显示中文。
 10. 其它 mod 的字面物品名 230 条
       Authentic Z / Backpacks+ / Tomb's Wardrobe / 音乐、气象站、太阳能、车辆部件等；
       脚本里写死 DisplayName 的物品，已按字面名建键，解决「有汉化仍显示英文」。
 11. KI5 车辆系列汉化 (3797951649)
       迁入其简中全部内容：物品 2,861 / 配方 8,132 / 界面 1,853 / 右键 107 / 沙盒 53 / UI 6；
       并按脚本字面 DisplayName 补了 731 条物品名键——这正是此前车辆零件和物品仍显示英文的原因；
       修正 6 条不准确译文（M911 车门装甲被译成车窗装甲、Hillbilly 未译、no 等），
       并收录其 KI5_Vehicles_CN_Hardcoded.lua（翻模名称、一句台词、机械师提示）。
       * 3797951649 现在可以停用。
 12. 其余 mod 的字面物品名 1,533 条（Authentic Z、NewMusicJayChou、Boots Expanded、
       Backpacks+、Tomb's Wardrobe、SpongieOpenJackets、RadArchery 等）
       按物品 ID 复用现有译文，逐条校验颜色 / 人物名 / 部位，修正错配 50 余条。

三、启用
  1. Mods 列表勾选 "本地汉化合集 (LocalCN)";
  2. 重启游戏(翻译只在启动时加载);
  3. 语言需为简体中文(CN)。

四、关于 VOE / VGE / PBC 的键
  这几个 mod 的物品脚本用的是字面 DisplayName(如 "Jacket - Tracksuit"), 不是翻译键。
  为兼容游戏可能的三种取值方式, 本合集对每个物品同时提供:
    VOE.Jacket_TracksuitJacket              (模块名键, B42 标准)
    ItemName_VOE.Jacket_TracksuitJacket     (ItemName_ 前缀键)
    "Jacket - Tracksuit"                    (脚本字面名键, 实际生效的就是它)
  三套值一致, 不会冲突。

五、维护
  - 全部为 UTF-8 无 BOM 的扁平 JSON, 键按字母排序, 可直接改;
  - 新增 mod 汉化时, 把键并入同名文件即可(命名空间不冲突);
  - 占位符(%s、%1、<br>、<LINE>、\n)必须原样保留, 否则界面会显示异常;
  - 另含 common\media\lua\shared\LocalCN_DisplayNameFix.lua：把字面 DisplayName 直接写回脚本物品，
    保证调试物品列表这类直接读脚本名的界面也显示中文（约 4,691 个物品）。
  - 繁体(CH)未迁移: 3778852357 里的 CH 目录与 CN 内容基本重复, 如需繁体可另建 CH 目录。
