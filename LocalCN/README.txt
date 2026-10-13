本地汉化合集 (LocalCN)
=======================

本 mod = 之前四个本地汉化 mod 合并而成(2026-10-13), 已校验 0 冲突 / 0 键丢失。

一、包含内容 (按命名空间)
  common\media\lua\shared\Translate\CN\
    ItemName.json    2919   damnlib 249 + AuthZ-Lite 2622 + VOE 48
    Recipes.json     1242   damnlib 1185 + AuthZ-Lite 57
    IG_UI.json        830   damnlib 751 + AuthZ-Lite 79
    Tooltip.json      110   damnlib 44 + AuthZ-Lite 66
    ContextMenu.json   42   AuthZ-Lite 42
    Sandbox.json       11   damnlib 11
    Fluids.json         5   damnlib 2 + AuthZ-Lite 3
    UI.json            30   自定义服装槽位名(Authentic Z / NaturesCall / tabas / radarchery /
                             alice's Weapon Sling / Spongie Open Jackets / Zombie Dismemberment 等)
  common\media\lua\shared\Translate\EN\
    UI.json            30   上面槽位名的英文版
  合计 5219 键。

二、来源(已移到 Zomboid\mods_backup_<日期>\ 备份, 不再加载)
  DamnLib_CN / AuthenticZLite_CN / VanillaOutfitsExpanded_CN / SlotNames_CN

三、启用
  1. Mods 列表勾选 "本地汉化合集 (LocalCN)";
  2. **重启游戏**(翻译只在启动时加载)。
  3. 本 mod 没有 require: 对应 mod 装了才生效, 没装则该部分键闲置(无副作用)。

四、维护
  直接改 common\media\lua\shared\Translate\CN\*.json (UTF-8 扁平 JSON)。
  注: Tomb 相关的那 10 个槽位名仍留在 GothBagTweaks 里(它同时含玩法补丁);
      若也想并进来, 把那 10 个 UI_ClothingType_twa:* 键复制到本 mod 的 UI.json 即可。
