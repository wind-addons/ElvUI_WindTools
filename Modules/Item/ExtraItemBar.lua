local W, F, E, L = unpack(select(2, ...))
local EB = W:NewModule("ExtraItemsBar", "AceEvent-3.0")
local async = W.Utilities.Async
local S = W.Modules.Skins
local AB = E.ActionBars

local _G = _G
local ceil = ceil
local format = format
local gsub = gsub
local ipairs = ipairs
local pairs = pairs
local strmatch = strmatch
local strsplit = strsplit
local tinsert = tinsert
local tonumber = tonumber
local unpack = unpack
local wipe = wipe

local CooldownFrame_Set = CooldownFrame_Set
local CreateFrame = CreateFrame
local GameTooltip = _G.GameTooltip
local GetBindingKey = GetBindingKey
local GetInventoryItemCooldown = GetInventoryItemCooldown
local GetInventoryItemID = GetInventoryItemID
local GetItemCooldown = GetItemCooldown
local GetItemCount = GetItemCount
local GetQuestLogSpecialItemCooldown = GetQuestLogSpecialItemCooldown
local GetQuestLogSpecialItemInfo = GetQuestLogSpecialItemInfo
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsItemInRange = IsItemInRange
local IsUsableItem = IsUsableItem
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries

-- https://www.wowhead.com/beta/items/consumables/potions/name:Potion/min-level:40
-- Potion (require level >= 40, Name: Potion, +Shadowlands, +Dragonflight, +Normal)
local potions = {
    -- Normal
    5512, -- 治療石
    177278, -- 寧靜之瓶
    -- Potions
    109217, -- 德拉諾敏捷藥水
    109218, -- 德拉諾智力藥水
    109219, -- 德拉諾力量藥水
    109220, -- 德拉諾臨機應變藥水
    109221, -- 德拉諾法力引導藥水
    109222, -- 德拉諾法力藥水
    109226, -- 德拉諾活力藥水
    114124, -- 幽靈藥水
    115531, -- 迴旋艾斯蘭藥水
    116925, -- 舊式的自由行動藥水
    118278, -- 蒼白幻象藥水
    118910, -- 打鬥者的德拉諾敏捷藥水
    118911, -- 打鬥者的德拉諾智力藥水
    118912, -- 打鬥者的德拉諾力量藥水
    118913, -- 打鬥者的無底德拉諾敏捷藥水
    118914, -- 打鬥者的無底德拉諾智力藥水
    118915, -- 打鬥者的無底德拉諾力量藥水
    122453, -- 指揮官的德拉諾敏捷藥水
    122454, -- 指揮官的德拉諾智力藥水
    122455, -- 指揮官的德拉諾力量藥水
    122456, -- 指揮官的德拉諾臨機應變藥水
    127834, -- 上古治療藥水
    127835, -- 上古法力藥水
    127836, -- 上古活力藥水
    127843, -- 致命恩典藥水
    127844, -- 遠古戰役藥水
    127845, -- 不屈藥水
    127846, -- 脈流藥水
    136569, -- 陳年的生命藥水
    142117, -- 持久之力藥水
    142325, -- 打鬥者上古治療藥水
    142326, -- 打鬥者持久之力藥水
    144396, -- 悍勇治療藥水
    144397, -- 悍勇護甲藥水
    144398, -- 悍勇怒氣藥水
    152494, -- 濱海治療藥水
    152495, -- 濱海法力藥水
    152497, -- 輕足藥水
    152503, -- 隱身藥水
    152550, -- 海霧藥水
    152557, -- 鋼膚藥水
    152559, -- 死亡湧升藥水
    152560, -- 澎湃鮮血藥水
    152561, -- 回復藥水
    152615, -- 暗星治療藥水
    152619, -- 暗星法力藥水
    163082, -- 濱海回春藥水
    163222, -- 智力戰鬥藥水
    163223, -- 敏捷戰鬥藥水
    163224, -- 力量戰鬥藥水
    163225, -- 耐力戰鬥藥水
    167917, -- 鬥陣濱海治療藥水
    167918, -- 鬥陣力量戰鬥藥水
    167919, -- 鬥陣敏捷戰鬥藥水
    167920, -- 鬥陣智力戰鬥藥水
    168489, -- 精良敏捷戰鬥藥水
    168498, -- 精良智力戰鬥藥水
    168499, -- 精良耐力戰鬥藥水
    168500, -- 精良力量戰鬥藥水
    168501, -- 精良鋼膚藥水
    168502, -- 重組藥水
    168506, -- 凝神決心藥水
    168529, -- 地緣強化藥水
    169299, -- 無盡狂怒藥水
    169300, -- 野性癒合藥水
    169451, -- 深淵治療藥水
    171263, -- 靈魂純淨藥水
    171264, -- 靈視藥水
    171266, -- 魂隱藥水
    171267, -- 鬼靈治療藥水
    171268, -- 鬼靈法力藥水
    171269, -- 鬼靈活力藥水
    171270, -- 鬼靈敏捷藥水
    171271, -- 堅實暗影藥水
    171272, -- 鬼靈清晰藥水
    171273, -- 鬼靈智力藥水
    171274, -- 鬼靈耐力藥水
    171275, -- 鬼靈力量藥水
    171349, -- 魅影之火藥水
    171350, -- 神性覺醒藥水
    171351, -- 死亡凝視藥水
    171352, -- 強力驅邪藥水
    171370, -- 幽魂迅捷藥水
    176811, -- 靈魄獻祭藥水
    180317, -- 靈性治療藥水
    180318, -- 靈性法力藥水
    180771, -- 不尋常力量藥水
    183823, -- 暢行無阻藥水
    184090, -- 導靈者之速藥水
    187802, -- 宇宙治療藥水
    191351, -- 凍結死亡藥水
    191352, -- 凍結死亡藥水
    191353, -- 凍結死亡藥水
    191360, -- 瓶裝腐敗
    191361, -- 瓶裝腐敗
    191362, -- 瓶裝腐敗
    191363, -- 凍結專注藥水
    191364, -- 凍結專注藥水
    191365, -- 凍結專注藥水
    191366, -- 冰冷清晰藥水
    191367, -- 冰冷清晰藥水
    191368, -- 冰冷清晰藥水
    191369, -- 凋萎活力藥水
    191370, -- 凋萎活力藥水
    191371, -- 凋萎活力藥水
    191372, -- 殘餘的神經傳導劑
    191373, -- 殘餘的神經傳導劑
    191374, -- 殘餘的神經傳導劑
    191375, -- 精緻的孢子懸浮液
    191376, -- 精緻的孢子懸浮液
    191377, -- 精緻的孢子懸浮液
    191378, -- 提神治療藥水
    191379, -- 提神治療藥水
    191380, -- 提神治療藥水
    191381, -- 至高威能元素藥水
    191382, -- 至高威能元素藥水
    191383, -- 至高威能元素藥水
    191384, -- 充氣法力藥水
    191385, -- 充氣法力藥水
    191386, -- 充氣法力藥水
    191387, -- 威能元素藥水
    191388, -- 威能元素藥水
    191389, -- 威能元素藥水
    191393, -- 寂靜之風藥水
    191394, -- 寂靜之風藥水
    191395, -- 寂靜之風藥水
    191396, -- 狂風藥水
    191397, -- 狂風藥水
    191398, -- 狂風藥水
    191399, -- 震驚揭露藥水
    191400, -- 震驚揭露藥水
    191401, -- 震驚揭露藥水
    191905, -- 短效威能元素藥水
    191906, -- 短效威能元素藥水
    191907, -- 短效威能元素藥水
    191912, -- 短效至高威能元素藥水
    191913, -- 短效至高威能元素藥水
    191914 -- 短效至高威能元素藥水
}

-- https://www.wowhead.com/beta/items/consumables/potions/min-level:120/min-req-level:51/max-req-level:60
-- Potion added in Shadowlands (51 <= require level <= 60, item level >= 120, +Normal)
local potionsShadowlands = {
    -- Normal
    5512, -- 治療石
    177278, -- 寧靜之瓶
    -- Shadowlands
    171263, -- 靈魂純淨藥水
    171264, -- 靈視藥水
    171266, -- 魂隱藥水
    171267, -- 鬼靈治療藥水
    171268, -- 鬼靈法力藥水
    171269, -- 鬼靈活力藥水
    171270, -- 鬼靈敏捷藥水
    171271, -- 堅實暗影藥水
    171272, -- 鬼靈清晰藥水
    171273, -- 鬼靈智力藥水
    171274, -- 鬼靈耐力藥水
    171275, -- 鬼靈力量藥水
    171349, -- 魅影之火藥水
    171350, -- 神性覺醒藥水
    171351, -- 死亡凝視藥水
    171352, -- 強力驅邪藥水
    171370, -- 幽魂迅捷藥水
    176811, -- 靈魄獻祭藥水
    180317, -- 靈性治療藥水
    180318, -- 靈性法力藥水
    183823, -- 暢行無阻藥水
    187802 -- 宇宙治療藥水
}

-- https://www.wowhead.com/beta/items/consumables/potions/min-level:300/min-req-level:61/max-req-level:70
-- Potion added in Dragonflight (61 <= require level <= 70, item level >= 300, +Normal)
local potionsDragonflight = {
    -- Normal
    5512, -- 治療石
    --- Dragonflight
    191351, -- 凍結死亡藥水
    191352, -- 凍結死亡藥水
    191353, -- 凍結死亡藥水
    191360, -- 瓶裝腐敗
    191361, -- 瓶裝腐敗
    191362, -- 瓶裝腐敗
    191363, -- 凍結專注藥水
    191364, -- 凍結專注藥水
    191365, -- 凍結專注藥水
    191366, -- 冰冷清晰藥水
    191367, -- 冰冷清晰藥水
    191368, -- 冰冷清晰藥水
    191369, -- 凋萎活力藥水
    191370, -- 凋萎活力藥水
    191371, -- 凋萎活力藥水
    191372, -- 殘餘的神經傳導劑
    191373, -- 殘餘的神經傳導劑
    191374, -- 殘餘的神經傳導劑
    191375, -- 精緻的孢子懸浮液
    191376, -- 精緻的孢子懸浮液
    191377, -- 精緻的孢子懸浮液
    191378, -- 提神治療藥水
    191379, -- 提神治療藥水
    191380, -- 提神治療藥水
    191381, -- 至高威能元素藥水
    191382, -- 至高威能元素藥水
    191383, -- 至高威能元素藥水
    191384, -- 充氣法力藥水
    191385, -- 充氣法力藥水
    191386, -- 充氣法力藥水
    191387, -- 威能元素藥水
    191388, -- 威能元素藥水
    191389, -- 威能元素藥水
    191393, -- 寂靜之風藥水
    191394, -- 寂靜之風藥水
    191395, -- 寂靜之風藥水
    191396, -- 狂風藥水
    191397, -- 狂風藥水
    191398, -- 狂風藥水
    191399, -- 震驚揭露藥水
    191400, -- 震驚揭露藥水
    191401, -- 震驚揭露藥水
    191905, -- 短效威能元素藥水
    191906, -- 短效威能元素藥水
    191907, -- 短效威能元素藥水
    191912, -- 短效至高威能元素藥水
    191913, -- 短效至高威能元素藥水
    191914 -- 短效至高威能元素藥水
}

-- Flasks (require level >= 40, +Normal)
local flasks = {
    127847, -- 低語契約精煉藥劑
    127848, -- 七魔精煉藥劑
    127849, -- 無盡軍士精煉藥劑
    127850, -- 萬道傷痕精煉藥劑
    127858, -- 靈魂精煉藥劑
    152638, -- 洪流精煉藥劑
    152639, -- 無盡深淵精煉藥劑
    152640, -- 遼闊地平線精煉藥劑
    152641, -- 暗流精煉藥劑
    162518, -- 神秘精煉藥劑
    168651, -- 強效洪流精煉藥劑
    168652, -- 強效無盡深淵精煉藥劑
    168653, -- 強效遼闊地平線精煉藥劑
    168654, -- 強效暗流精煉藥劑
    168655, -- 強效神秘精煉藥劑
    171276, -- 鬼靈威力精煉藥劑
    171278, -- 鬼靈耐力精煉藥劑
    171280, -- 永恆精煉藥劑
    191318, -- 暴風眼之瓶
    191319, -- 暴風眼之瓶
    191320, -- 暴風眼之瓶
    191321, -- 靜氣之瓶
    191322, -- 靜氣之瓶
    191323, -- 靜氣之瓶
    191324, -- 冰凍護存之瓶
    191325, -- 冰凍護存之瓶
    191326, -- 冰凍護存之瓶
    191327, -- 腐化之怒冰瓶
    191328, -- 腐化之怒冰瓶
    191329, -- 腐化之怒冰瓶
    191330, -- 高能隔離之瓶
    191331, -- 高能隔離之瓶
    191332, -- 高能隔離之瓶
    191333, -- 冰川狂怒之瓶
    191334, -- 冰川狂怒之瓶
    191335, -- 冰川狂怒之瓶
    191336, -- 靜止強化之瓶
    191337, -- 靜止強化之瓶
    191338, -- 靜止強化之瓶
    191339, -- 不慍不火之瓶
    191340, -- 不慍不火之瓶
    191341, -- 不慍不火之瓶
    191342, -- 純熟氣泡瓶
    191343, -- 純熟氣泡瓶
    191344, -- 純熟氣泡瓶
    191345, -- 技法蒸汽瓶
    191346, -- 技法蒸汽瓶
    191347, -- 技法蒸汽瓶
    191348, -- 矯捷充能瓶
    191349, -- 矯捷充能瓶
    191350, -- 矯捷充能瓶
    191354, -- 感知水晶之瓶
    191355, -- 感知水晶之瓶
    191356, -- 感知水晶之瓶
    191357, -- 元素混沌之瓶
    191358, -- 元素混沌之瓶
    191359, -- 元素混沌之瓶
    197720, -- 快手氣泡瓶
    197721, -- 快手氣泡瓶
    197722 -- 快手氣泡瓶
}

-- Flasks added in Shadowlands (50 <= require level <= 60)
local flasksShadowlands = {
    171276, --鬼靈威力精煉藥劑
    171278, --鬼靈耐力精煉藥劑
    171280 --永恆精煉藥劑
}

-- Flasks added in Dragonflight (60 <= require level <= 70)
local flasksDragonflight = {
    191318, -- 暴風眼之瓶
    191319, -- 暴風眼之瓶
    191320, -- 暴風眼之瓶
    191321, -- 靜氣之瓶
    191322, -- 靜氣之瓶
    191323, -- 靜氣之瓶
    191324, -- 冰凍護存之瓶
    191325, -- 冰凍護存之瓶
    191326, -- 冰凍護存之瓶
    191327, -- 腐化之怒冰瓶
    191328, -- 腐化之怒冰瓶
    191329, -- 腐化之怒冰瓶
    191330, -- 高能隔離之瓶
    191331, -- 高能隔離之瓶
    191332, -- 高能隔離之瓶
    191333, -- 冰川狂怒之瓶
    191334, -- 冰川狂怒之瓶
    191335, -- 冰川狂怒之瓶
    191336, -- 靜止強化之瓶
    191337, -- 靜止強化之瓶
    191338, -- 靜止強化之瓶
    191339, -- 不慍不火之瓶
    191340, -- 不慍不火之瓶
    191341, -- 不慍不火之瓶
    191342, -- 純熟氣泡瓶
    191343, -- 純熟氣泡瓶
    191344, -- 純熟氣泡瓶
    191345, -- 技法蒸汽瓶
    191346, -- 技法蒸汽瓶
    191347, -- 技法蒸汽瓶
    191348, -- 矯捷充能瓶
    191349, -- 矯捷充能瓶
    191350, -- 矯捷充能瓶
    191354, -- 感知水晶之瓶
    191355, -- 感知水晶之瓶
    191356, -- 感知水晶之瓶
    191357, -- 元素混沌之瓶
    191358, -- 元素混沌之瓶
    191359, -- 元素混沌之瓶
    197720, -- 快手氣泡瓶
    197721, -- 快手氣泡瓶
    197722 -- 快手氣泡瓶
}

-- Runes
local runes = {
    160053, -- 戰鬥傷痕增強符文
    181468, -- 朦朧增強符文
    198491, -- 梵陀符文：洪荒化身牢獄
    198492, -- 梵陀符文：洪荒化身牢獄
    198493, -- 梵陀符文：洪荒化身牢獄
    201325 -- 龍族增強符文
}

-- Runes added in Dragonflight
local runesDragonflight = {
    198491, -- 梵陀符文：洪荒化身牢獄
    198492, -- 梵陀符文：洪荒化身牢獄
    198493, -- 梵陀符文：洪荒化身牢獄
    201325 -- 龍族增強符文
}

-- The items in torghast
local torghastItems = {
    168035, -- 淵喉污鼠韁繩
    168207, -- 掠奪的靈魄能量球
    170499, -- 淵喉巡者韁繩
    170540, -- 飢餓的靈魄能量球
    174464, -- 鬼靈鞍具
    176331, -- 精華掩蔽藥水
    176409, -- 活力虹吸精華
    176443, -- 消逝狂亂藥水
    184662, -- 被徵用的靈魄能量球
    185946, -- 長尾爆炸鼠
    185947, -- 汲取打擊藥劑
    185950, -- 時光飛梭藥劑
    186043, -- 托迦司傳送門操作卷軸
    186614, -- 靈魂罐
    186615, -- 召喚雙子之鏡
    186636, -- 一籠淵喉污鼠
    186678, -- 淵鑄武器箱
    186679 -- 統御卷軸
}

-- https://www.wowhead.com/beta/items/consumables/food-and-drinks/min-req-level:40?filter=86;11;0
-- Food (Crafted by cooking)
local food = {
    133557, -- 椒鹽火腿
    133561, -- 酥炸蘚鰓鱸魚
    133562, -- 醃漬風暴魟魚
    133563, -- 法隆納氣泡飲
    133564, -- 香料烤肋排
    133565, -- 脈燒肋排
    133566, -- 蘇拉瑪爾海陸大餐
    133567, -- 梭子魚莫古嘎古
    133568, -- 鯉香風暴魟魚
    133569, -- 卓格巴風味鮭魚
    133570, -- 飢腸盛宴
    133571, -- 艾薩拉沙拉
    133572, -- 夜裔精緻拼盤
    133573, -- 種籽風味炸魚盤
    133574, -- 魚卜魯特餐
    133575, -- 風乾鯖魚肉
    133576, -- 韃靼熊排
    133577, -- 戰士雜煮
    133578, -- 澎湃盛宴
    133579, -- 蘇拉瑪爾豪宴
    133681, -- 香脆培根
    142334, -- 香料龍隼煎蛋捲
    154881, -- 庫爾提拉米蘇
    154882, -- 蜜汁烤後腿
    154883, -- 鴉莓塔
    154884, -- 沼澤炸魚薯條
    154885, -- 蒙達吉
    154886, -- 香料笛鯛
    154887, -- 羅亞肉餅
    154889, -- 燒烤鯰魚
    154891, -- 調味腰內肉
    156525, -- 艦上盛宴
    156526, -- 豐盛的船長饗宴
    163781, -- 禍心巫術香腸
    165755, -- 蜂蜜餡餅
    166240, -- 血潤盛宴
    166343, -- 野莓麵包
    166344, -- 精心調味的肉排和馬鈴薯
    166804, -- 波拉勒斯血腸
    168310, -- 機當勞的「大機克」
    168312, -- 噴香燉魚
    168313, -- 烘焙港口薯
    168314, -- 比爾通肉乾
    168315, -- 超澎湃饗宴
    169280, -- 串烤鰻魚肉
    172040, -- 奶油糖醃製肋排
    172041, -- 刺鰭舒芙蕾佐炸物
    172042, -- 意外可口盛宴
    172043, -- 暴食享樂盛宴
    172044, -- 肉桂燉骨魚
    172045, -- 陰暗皇冠肉排凍
    172046, -- 魚子醬餅乾
    172047, -- 蜜糖鰤魚蛋糕
    172048, -- 肉餡蘋果餃子
    172049, -- 蘋果醬彩色餡餃
    172050, -- 蜜汁銀鰓香腸
    172051, -- 濃醬牛排
    172061, -- 天使雞翅
    172062, -- 燉煮腿肉
    172063, -- 炸骨魚
    172068, -- 醃肉奶昔
    172069, -- 香蕉牛肉布丁
    184682, -- 特大號香檸魚排
    186704, -- 暮光茶
    186725, -- 骨粉麵包
    186726, -- 多孔石頭糖
    197758, -- 兩面烘烤馬鈴薯
    197759, -- 吉利呱啦餅
    197760, -- 鯖魚點心
    197761, -- 大概是蛋白質
    197762, -- 酸甜蛤蜊濃湯
    197763, -- 龍族勇士早餐
    197766, -- 雪淇淋甜筒
    197767, -- 胖胖馬芬
    197768, -- 慶祝蛋糕
    197769, -- 美味的幼雛點心
    197770, -- 帶勁的水
    197771, -- 美味的龍涎
    197772, -- 反胃茶
    197774, -- 燒烤角蛙排
    197775, -- 嫩炒蜥蜴蛋
    197776, -- 三味猛瑪象肉串
    197777, -- 希望對健康有益
    197778, -- 現宰海味
    197779, -- 尖牙切片
    197780, -- 驚奇海蛾魚
    197781, -- 鹽烤魚餅
    197782, -- 火辣鮮魚棒
    197783, -- 馨香海鮮拼盤
    197784, -- 冒泡的海鮮總匯
    197785, -- 冷酷復仇
    197786, -- 千骨切舌器
    197787, -- 大天藍之海
    197788, -- 燉煮麋牛胸肉
    197789, -- 河畔野餐組
    197790, -- 燒烤鴨肉點心
    197791, -- 鹽漬肉餅
    197792, -- 命定幸運籤餅
    197793, -- 雨莎的澎湃燉肉
    197794, -- 卡魯耶克的豪華盛宴
    197795 -- 龍族佳餚大餐
}

-- https://www.wowhead.com/beta/items/consumables/food-and-drinks/min-req-level:40?filter=86:166;11:9;0:0
-- Food added in Shadowlands (Crafted by cooking)
local foodShadowlands = {
    172040, -- 奶油糖醃製肋排
    172041, -- 刺鰭舒芙蕾佐炸物
    172042, -- 意外可口盛宴
    172043, -- 暴食享樂盛宴
    172044, -- 肉桂燉骨魚
    172045, -- 陰暗皇冠肉排凍
    172046, -- 魚子醬餅乾
    172047, -- 蜜糖鰤魚蛋糕
    172048, -- 肉餡蘋果餃子
    172049, -- 蘋果醬彩色餡餃
    172050, -- 蜜汁銀鰓香腸
    172051, -- 濃醬牛排
    172061, -- 天使雞翅
    172062, -- 燉煮腿肉
    172063, -- 炸骨魚
    172068, -- 醃肉奶昔
    172069, -- 香蕉牛肉布丁
    184682, -- 特大號香檸魚排
    186704, -- 暮光茶
    186725, -- 骨粉麵包
    186726, -- 多孔石頭糖
    187648 -- 石頭湯空壺
}

-- https://www.wowhead.com/beta/items/consumables/food-and-drinks/min-req-level:40?filter=86:166;11:10;0:0
-- Food added in Dragonflight (Crafted by cooking)
local foodDragonflight = {
    197758, -- 兩面烘烤馬鈴薯
    197759, -- 吉利呱啦餅
    197760, -- 鯖魚點心
    197761, -- 大概是蛋白質
    197762, -- 酸甜蛤蜊濃湯
    197763, -- 龍族勇士早餐
    197766, -- 雪淇淋甜筒
    197767, -- 胖胖馬芬
    197768, -- 慶祝蛋糕
    197769, -- 美味的幼雛點心
    197770, -- 帶勁的水
    197771, -- 美味的龍涎
    197772, -- 反胃茶
    197774, -- 燒烤角蛙排
    197775, -- 嫩炒蜥蜴蛋
    197776, -- 三味猛瑪象肉串
    197777, -- 希望對健康有益
    197778, -- 現宰海味
    197779, -- 尖牙切片
    197780, -- 驚奇海蛾魚
    197781, -- 鹽烤魚餅
    197782, -- 火辣鮮魚棒
    197783, -- 馨香海鮮拼盤
    197784, -- 冒泡的海鮮總匯
    197785, -- 冷酷復仇
    197786, -- 千骨切舌器
    197787, -- 大天藍之海
    197788, -- 燉煮麋牛胸肉
    197789, -- 河畔野餐組
    197790, -- 燒烤鴨肉點心
    197791, -- 鹽漬肉餅
    197792, -- 命定幸運籤餅
    197793, -- 雨莎的澎湃燉肉
    197794, -- 卡魯耶克的豪華盛宴
    197795 -- 龍族佳餚大餐
}

-- https://www.wowhead.com/beta/items/consumables/food-and-drinks/min-req-level:65?filter=92:166;1:10;0:0
-- Food sold by a vendor (Dragonflight)
local foodDragonflightVendor = {
    194680, -- 肉乾驚喜
    194681, -- 糖翼杯子蛋糕
    194683, -- 白脫牛奶
    194684, -- 蒼藍脈酒
    194685, -- 龍泉之水
    194688, -- 沃昆裡脊
    194689, -- 香脆鯷魚
    194690, -- 號角蜜酒
    194691, -- 手榨莓汁
    194692, -- 蒸餾魚湯
    194693, -- 創意壽司
    194694, -- 調味角蛙排
    194695, -- 公羊肉餅
    195455, -- 阿戈利起司
    195456, -- 平原薄餅
    195457, -- 猛瑪象肉乾
    195459, -- 阿戈利羊奶
    195462, -- 酥炸角行鳥翅
    195463, -- 調味過的踏泥獸腹肉
    195466, -- 狂魚薯條
    196440, -- 翔龍腳
    196540, -- 寬蹄尾肉醬薯條
    196582, -- 蘸糖漿的吐司
    196583, -- 綠莓土司
    196584, -- 橡實鮮奶
    196585, -- 平原扭結麵包
    197771, -- 美味的龍涎
    197847, -- 戈洛克魚翅湯
    197848, -- 營養的燉南瓜
    197849, -- 上古火酒
    197850, -- 猛瑪象肉水餃
    197851, -- 超香脆羊肉
    197852, -- 山羊胸肉
    197853, -- 小動物烤肉串
    197854, -- 魔法阿戈利羊腰肉
    197855, -- 探險者的大雜燴
    197856, -- 清醒之水
    197857, -- 史瓦格思樂飲
    197858, -- 鹽烤鱗肚
    198440, -- 特價肉品
    198441, -- 雷脊里肌肉
    200099, -- 即食肉
    200304, -- 儲藏的半龍人口糧
    200305, -- 半龍人水口糧
    200619, -- 斯卡勒許的特調
    200680, -- 莫魯凱馱騾
    200681, -- 雍啤酒
    200855, -- 巨牙海民波特酒
    200856, -- 側船
    200871, -- 清蒸甲蟲肉排
    201045, -- 寒冰皇冠藍乳酪
    201089, -- 製作育所克羅勒
    201327, -- 翡翠夢境時光
    201398, -- 魔古起司
    201413, -- 永恆灌注的布拉塔乳酪
    201415, -- 時光帕馬森乳酪
    201416, -- 黑暗帝國褐乳酪
    201417, -- 斯坦索姆的凝乳酪
    201419, -- 頂尖艾斯阿格乳酪
    201820 -- 希利蘇斯冷酪
}

-- https://www.wowhead.com/beta/items/consumables/food-and-drinks/name:Conjured+Mana
-- Food crafted by mage
local conjuredManaFood = {
    34062, -- 魔法法力軟餅
    43518, -- 魔法法力派
    43523, -- 魔法法力餡餅
    65499, -- 魔法法力蛋糕
    65500, -- 魔法法力餅乾
    65515, -- 魔法法力布朗尼
    65516, -- 魔法法力杯子蛋糕
    65517, -- 魔法法力棒棒糖
    80610, -- 魔法法力布丁
    80618, -- 魔法法力甜餅
    113509 -- 魔法法力餐包
}

-- Banners
local banners = {
    18606, -- 聯盟戰旗
    18607, -- 部落戰旗
    63359, -- 合作旌旗
    64398, -- 團結軍旗
    64399, -- 協調戰旗
    64400, -- 合作旌旗
    64401, -- 團結軍旗
    64402 -- 協調戰旗
}

-- Utilities
local utilities = {
    49040, -- 吉福斯
    109076, -- 哥布林滑翔工具組
    132514, -- 自動鐵錘
    132516, -- 槍靴
    153023, -- 光鑄增強符文
    171285, -- 影核之油
    171286, -- 防腐之油
    171436, -- 孔岩磨刀石
    171437, -- 幽影磨刀石
    171438, -- 孔岩平衡石
    171439, -- 幽影平衡石
    172233, -- 致命兇殘之鼓
    172346, -- 荒寂護甲片
    172347, -- 厚重荒寂護甲片
    182749, -- 回收的琪瑞安之翼
    191933, -- 洪荒磨石
    191939, -- 洪荒打磨石
    191940, -- 洪荒打磨石
    191943, -- 洪荒平衡石
    191944, -- 洪荒配重石
    191945, -- 洪荒配重石
    191948, -- 洪荒磨刃石
    191949, -- 洪荒磨刃石
    191950, -- 洪荒磨刃石
    194817, -- 尖嘯符文
    194819, -- 尖嘯符文
    194820, -- 尖嘯符文
    194821, -- 嗡鳴符文
    194822, -- 嗡鳴符文
    194823, -- 嗡鳴符文
    194824, -- 鳴叫符文
    194825, -- 鳴叫符文
    194826, -- 鳴叫符文
    198160, -- 超安全火箭
    198161, -- 超安全火箭
    198162, -- 超安全火箭
    198163, -- 無限針堆
    198164, -- 無限針堆
    198165 -- 無限針堆
}

local openableItems = {
    54537, -- 心型盒
    92794, -- 騎乘套票
    171209, -- 沾血的袋子
    171210, -- 一袋自然的恩賜
    171211, -- 汎希爾的錢包
    174652, -- 一袋被遺忘的傳家寶
    178040, -- 濃縮的冥魄
    178078, -- 重生之靈寶箱
    178128, -- 裝滿亮晶晶寶物的袋子
    178513, -- 週年慶禮物
    178965, -- 小型的園丁袋子
    178966, -- 園丁的袋子
    178967, -- 大型的園丁袋子
    178968, -- 每週的園丁袋子
    180085, -- 琪瑞安紀念品
    180355, -- 華麗聖盒
    180378, -- 鍛造大師的箱子
    180379, -- 精緻紡織地毯
    180380, -- 精細網織品
    180386, -- 草藥師小袋
    180442, -- 一袋罪孽石
    180646, -- 不死軍團補給品
    180647, -- 晉升者補給品
    180648, -- 收割者廷衛補給品
    180649, -- 曠野獵者補給品
    180875, -- 馬車貨物
    180974, -- 學徒的袋子
    180975, -- 熟工的袋子
    180976, -- 專家的袋子
    180977, -- 靈魂看管者的袋子
    180979, -- 專家的大型袋子
    180980, -- 熟工的大型袋子
    180981, -- 學徒的大型袋子
    180983, -- 專家滿載的袋子
    180984, -- 熟工滿載的袋子
    180985, -- 學徒滿載的袋子
    180988, -- 熟工滿溢的袋子
    180989, -- 學徒滿溢的袋子
    181372, -- 晉升者的獻禮
    181475, -- 林地看守者的獎賞
    181476, -- 曠野獵者的獻禮
    181556, -- 廷衛的獻禮
    181557, -- 廷衛的大禮
    181732, -- 野心家獻禮
    181733, -- 盡責者獻禮
    181741, -- 楷模的獻禮
    181767, -- 小錢包
    182590, -- 爬藤蠕動的零錢包
    182591, -- 覆藤灌能紅寶石
    183699, -- 特選材料
    183701, -- 淨化儀式材料
    183702, -- 自然光采
    183703, -- 骸骨工匠背袋
    184045, -- 收割者廷衛的軍稅
    184046, -- 不死軍團武器箱
    184047, -- 晉升者武器箱
    184048, -- 曠野獵者武器袋
    184158, -- 黏黏的死靈魟魚卵
    184395, -- 死亡冒險者的貯藏箱
    184444, -- 晉升之路補給
    184522, -- 協力朦朧布包
    184589, -- 藥水袋
    184630, -- 冒險者布料箱
    184631, -- 冒險者附魔箱
    184632, -- 勇士魚類箱
    184633, -- 勇士肉類箱
    184634, -- 冒險者草藥箱
    184635, -- 冒險者礦石箱
    184636, -- 冒險者皮革箱
    184637, -- 英雄肉類箱
    184638, -- 英雄魚類箱
    184639, -- 勇士布料箱
    184640, -- 勇士皮革箱
    184641, -- 勇士礦石箱
    184642, -- 勇士草藥箱
    184643, -- 勇士附魔箱
    184644, -- 英雄布料箱
    184645, -- 英雄皮革箱
    184646, -- 英雄礦石箱
    184647, -- 英雄草藥箱
    184648, -- 英雄附魔箱
    184810, -- 盜掠來的物資
    184811, -- 阿特米德的恩賜
    184812, -- 阿波隆的恩賜
    184843, -- 回收的補給物資
    184868, -- 納撒亞寶物箱
    184869, -- 納撒亞寶物箱
    185765, -- 一批厚重硬結獸皮
    185832, -- 一批艾雷希礦石
    185833, -- 一批無光絲布
    185972, -- 折磨者的寶箱
    185990, -- 收割者戰爭寶箱
    185991, -- 曠野獵者戰爭寶箱
    185992, -- 不死軍團戰爭寶箱
    185993, -- 晉升者戰爭寶箱
    186196, -- 死亡先鋒軍戰爭寶箱
    186533, -- 聖所寶箱
    186650, -- 死亡先鋒軍補給品
    186680, -- 裝滿黃金的靴子
    186691, -- 裝滿黃金的袋子
    186694, -- 一袋暗影礦石
    186705, -- 裝滿黃金的聖杯
    186706, -- 裝滿黃金的帽子
    186707, -- 裝滿黃金的木箱
    186708, -- 裝滿黃金的油漆刷杯
    187028, -- 博文者寶典補給品
    187029, -- 維娜里的神秘禮物
    187221, -- 靈魂灰燼箱
    187222, -- 冥魄奇異點
    187254, -- 靈魄排列
    187278, -- 利爪穿過的淵誓寶箱
    187351, -- 冥魄晶簇
    187354, -- 被遺棄的仲介者背袋
    187440, -- 塞滿羽毛的頭盔
    187503, -- 一堆研究檔案
    187543, -- 死亡先鋒軍戰爭寶箱
    187551, -- 小型科西亞補給箱
    187569, -- 仲介者布料潛能微粒
    187570, -- 仲介者皮革潛能微粒
    187571, -- 仲介者礦石潛能微粒
    187572, -- 仲介者草藥潛能微粒
    187573, -- 仲介者附魔潛能微粒
    187574, -- 仲介者的滿溢食材桶
    187575, -- 科西亞釣魚箱
    187576, -- 科西亞皮革箱
    187577, -- 科西亞肉類箱
    187780, -- 受啟迪的仲介者物資
    187781, -- 歐利亞寶箱
    187817, -- 科西亞水晶簇
    189765, -- 莫魯克半人馬補給包
    190178, -- 原生補給品包
    190610, -- 受啟迪者長老貢品
    191040, -- 聖塚寶藏箱
    191041, -- 聖塚寶藏箱
    191139, -- 受啟迪者長老貢品
    192438, -- 命定寶箱
    198863, -- 小型巨龍遠征隊補給包
    198864, -- 大型莫魯克半人馬補給包
    198865, -- 大型巨龍遠征隊補給包
    198866, -- 小型伊斯凱拉補給包
    198867, -- 大型伊斯凱拉補給包
    198868, -- 小型沃卓肯協調者補給包
    198869, -- 大型沃卓肯協調者補給包
    199192, -- 飛龍競速者的獎金袋
    199472, -- 滿溢巨龍遠征隊補給包
    199473, -- 滿溢伊斯凱拉補給包
    199474, -- 滿溢莫魯克半人馬補給包
    199475, -- 滿溢沃卓肯協調者補給包
    200069, -- 黑曜貯藏箱
    200070, -- 黑曜保險箱
    200072, -- 龍禍要塞保險箱
    200073, -- 沃卓肯寶藏
    200095, -- 充滿補給品的湯鍋
    200468, -- 大狩獵戰利品
    200513, -- 大狩獵戰利品
    200516, -- 大狩獵戰利品
    201754, -- 黑曜熔爐大師的寶箱
    201755, -- 黑曜熔爐大師的保險箱
    201756, -- 鼓鼓的零錢包
    201817, -- 暮光儲藏箱
    201818, -- 暮光保險箱
    202142, -- 龍禍要塞保險箱
    202171 -- 龍族錢包
}

-- 更新任务物品列表
local questItemList = {}
local function UpdateQuestItemList()
    wipe(questItemList)
    for questLogIndex = 1, C_QuestLog_GetNumQuestLogEntries() do
        local link = GetQuestLogSpecialItemInfo(questLogIndex)
        if link then
            local itemID = tonumber(strmatch(link, "|Hitem:(%d+):"))
            local data = {
                questLogIndex = questLogIndex,
                itemID = itemID
            }
            tinsert(questItemList, data)
        end
    end
end

-- 更新装备物品列表
local equipmentList = {}
local function UpdateEquipmentList()
    wipe(equipmentList)
    for slotID = 1, 18 do
        local itemID = GetInventoryItemID("player", slotID)
        if itemID and IsUsableItem(itemID) then
            tinsert(equipmentList, slotID)
        end
    end
end

local UpdateAfterCombat = {
    [1] = false,
    [2] = false,
    [3] = false
}

local moduleList = {
    ["POTION"] = potions,
    ["POTIONSL"] = potionsShadowlands,
    ["POTIONDF"] = potionsDragonflight,
    ["FLASK"] = flasks,
    ["FLASKSL"] = flasksShadowlands,
    ["FLASKDF"] = flasksDragonflight,
    ["RUNE"] = runes,
    ["RUNEDF"] = runesDragonflight,
    ["FOOD"] = food,
    ["FOODSL"] = foodShadowlands,
    ["FOODDF"] = foodDragonflight,
    ["FOODVENDOR"] = foodDragonflightVendor,
    ["MAGEFOOD"] = conjuredManaFood,
    ["TORGHAST"] = torghastItems,
    ["BANNER"] = banners,
    ["UTILITY"] = utilities,
    ["OPENABLE"] = openableItems
}

function EB:CreateButton(name, barDB)
    local button = CreateFrame("Button", name, E.UIParent, "SecureActionButtonTemplate, BackdropTemplate")
    button:SetSize(barDB.buttonWidth, barDB.buttonHeight)
    button:SetTemplate("Default")
    button:SetClampedToScreen(true)
    button:SetAttribute("type", "item")
    button:EnableMouse(false)
    button:RegisterForClicks(W.UseKeyDown and "AnyDown" or "AnyUp")

    local tex = button:CreateTexture(nil, "OVERLAY", nil)
    tex:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
    tex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
    tex:SetTexCoord(unpack(E.TexCoords))

    local count = button:CreateFontString(nil, "OVERLAY")
    count:SetTextColor(1, 1, 1, 1)
    count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
    count:SetJustifyH("CENTER")
    F.SetFontWithDB(count, barDB.countFont)

    local bind = button:CreateFontString(nil, "OVERLAY")
    bind:SetTextColor(0.6, 0.6, 0.6)
    bind:SetPoint("TOPRIGHT", button, "TOPRIGHT")
    bind:SetJustifyH("CENTER")
    F.SetFontWithDB(bind, barDB.bindFont)

    local cooldown = CreateFrame("Cooldown", name .. "Cooldown", button, "CooldownFrameTemplate")
    E:RegisterCooldown(cooldown)

    button.tex = tex
    button.count = count
    button.bind = bind
    button.cooldown = cooldown

    button:StyleButton()

    S:CreateShadowModule(button)
    S:BindShadowColorWithBorder(button.shadow, button)

    return button
end

function EB:SetUpButton(button, questItemData, slotID)
    button.itemName = nil
    button.itemID = nil
    button.spellName = nil
    button.slotID = nil
    button.countText = nil

    if questItemData then
        button.itemID = questItemData.itemID
        button.countText = GetItemCount(questItemData.itemID, nil, true)
        button.questLogIndex = questItemData.questLogIndex
        button:SetBackdropBorderColor(0, 0, 0)

        async.WithItemID(
            questItemData.itemID,
            function(item)
                button.itemName = item:GetItemName()
                button.tex:SetTexture(item:GetItemIcon())
            end
        )
    elseif slotID then
        button.slotID = slotID
        async.WithItemSlotID(
            slotID,
            function(item)
                if button.slotID == slotID then
                    button.itemName = item:GetItemName()
                    button.tex:SetTexture(item:GetItemIcon())

                    local color = item:GetItemQualityColor()

                    if color then
                        button:SetBackdropBorderColor(color.r, color.g, color.b)
                    end
                end
            end
        )
    end

    -- 更新堆叠数
    if button.countText and button.countText > 1 then
        button.count:SetText(button.countText)
    else
        button.count:SetText()
    end

    -- 更新 OnUpdate 函数
    local OnUpdateFunction

    if button.itemID then
        OnUpdateFunction = function(self)
            local start, duration, enable
            if self.questLogIndex and self.questLogIndex > 0 then
                start, duration, enable = GetQuestLogSpecialItemCooldown(self.questLogIndex)
            else
                start, duration, enable = GetItemCooldown(self.itemID)
            end
            CooldownFrame_Set(self.cooldown, start, duration, enable)
            if (duration and duration > 0 and enable and enable == 0) then
                self.tex:SetVertexColor(0.4, 0.4, 0.4)
            elseif IsItemInRange(self.itemID, "target") == false then
                self.tex:SetVertexColor(1, 0, 0)
            else
                self.tex:SetVertexColor(1, 1, 1)
            end
        end
    elseif button.slotID then
        OnUpdateFunction = function(self)
            local start, duration, enable = GetInventoryItemCooldown("player", self.slotID)
            CooldownFrame_Set(self.cooldown, start, duration, enable)
        end
    end

    button:SetScript("OnUpdate", OnUpdateFunction)

    -- 浮动提示
    button:SetScript(
        "OnEnter",
        function(self)
            local bar = self:GetParent()
            local barDB = EB.db["bar" .. bar.id]
            if not bar or not barDB then
                return
            end

            if barDB.globalFade then
                if AB.fadeParent and not AB.fadeParent.mouseLock then
                    E:UIFrameFadeIn(AB.fadeParent, 0.2, AB.fadeParent:GetAlpha(), 1)
                end
            elseif barDB.mouseOver then
                local alphaCurrent = bar:GetAlpha()
                E:UIFrameFadeIn(
                    bar,
                    barDB.fadeTime * (barDB.alphaMax - alphaCurrent) / (barDB.alphaMax - barDB.alphaMin),
                    alphaCurrent,
                    barDB.alphaMax
                )
            end

            if barDB.tooltip then
                GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, -2)
                GameTooltip:ClearLines()

                if self.slotID then
                    GameTooltip:SetInventoryItem("player", self.slotID)
                else
                    GameTooltip:SetItemByID(self.itemID)
                end

                GameTooltip:Show()
            end
        end
    )

    button:SetScript(
        "OnLeave",
        function(self)
            local bar = self:GetParent()
            local barDB = EB.db["bar" .. bar.id]
            if not bar or not barDB then
                return
            end

            if barDB.globalFade then
                if AB.fadeParent and not AB.fadeParent.mouseLock then
                    E:UIFrameFadeOut(AB.fadeParent, 0.2, AB.fadeParent:GetAlpha(), 1 - AB.db.globalFadeAlpha)
                end
            elseif barDB.mouseOver then
                local alphaCurrent = bar:GetAlpha()
                E:UIFrameFadeOut(
                    bar,
                    barDB.fadeTime * (alphaCurrent - barDB.alphaMin) / (barDB.alphaMax - barDB.alphaMin),
                    alphaCurrent,
                    barDB.alphaMin
                )
            end

            GameTooltip:Hide()
        end
    )

    -- 更新按钮功能
    if not InCombatLockdown() then
        button:EnableMouse(true)
        button:Show()
        if button.slotID then
            button:SetAttribute("type", "macro")
            button:SetAttribute("macrotext", "/use " .. button.slotID)
        elseif button.itemName then
            if button.itemID == 172347 then
                -- Heavy Desolate Armor Kit
                button:SetAttribute("type", "macro")
                button:SetAttribute("macrotext", "/use " .. button.itemName .. "\n/use 5")
            else
                button:SetAttribute("type", "item")
                button:SetAttribute("item", button.itemName)
            end
        end
    end
end

function EB:UpdateButtonSize(button, barDB)
    button:SetSize(barDB.buttonWidth, barDB.buttonHeight)
    local left, right, top, bottom = unpack(E.TexCoords)

    if barDB.buttonWidth > barDB.buttonHeight then
        local offset = (bottom - top) * (1 - barDB.buttonHeight / barDB.buttonWidth) / 2
        top = top + offset
        bottom = bottom - offset
    elseif barDB.buttonWidth < barDB.buttonHeight then
        local offset = (right - left) * (1 - barDB.buttonWidth / barDB.buttonHeight) / 2
        left = left + offset
        right = right - offset
    end

    button.tex:SetTexCoord(left, right, top, bottom)
end

function EB:PLAYER_REGEN_ENABLED()
    for i = 1, 5 do
        if UpdateAfterCombat[i] then
            self:UpdateBar(i)
            UpdateAfterCombat[i] = false
        end
    end
end

function EB:UpdateBarTextOnCombat(i)
    for k = 1, 12 do
        local button = self.bars[i].buttons[k]
        if button.itemID and button:IsShown() then
            button.countText = GetItemCount(button.itemID, nil, true)
            if button.countText and button.countText > 1 then
                button.count:SetText(button.countText)
            else
                button.count:SetText()
            end
        end
    end
end

function EB:CreateBar(id)
    if not self.db or not self.db["bar" .. id] then
        return
    end

    local barDB = self.db["bar" .. id]

    -- 建立条移动锚点
    local anchor = CreateFrame("Frame", "WTExtraItemsBar" .. id .. "Anchor", E.UIParent)
    anchor:SetClampedToScreen(true)
    anchor:SetPoint("BOTTOMLEFT", _G.RightChatPanel or _G.LeftChatPanel, "TOPLEFT", 0, (id - 1) * 45)
    anchor:SetSize(200, 40)
    E:CreateMover(
        anchor,
        "WTExtraItemsBar" .. id .. "Mover",
        L["Extra Items Bar"] .. " " .. id,
        nil,
        nil,
        nil,
        "ALL,WINDTOOLS",
        function()
            return EB.db.enable and barDB.enable
        end,
        "WindTools,item,extraItemBar"
    )

    -- 建立条
    local bar = CreateFrame("Frame", "WTExtraItemsBar" .. id, E.UIParent, "SecureHandlerStateTemplate")
    bar.id = id
    bar:ClearAllPoints()
    bar:SetParent(anchor)
    bar:SetPoint("CENTER", anchor, "CENTER", 0, 0)
    bar:SetSize(200, 40)
    bar:CreateBackdrop("Transparent")
    bar:SetFrameStrata("LOW")

    -- 建立按钮
    bar.buttons = {}
    for i = 1, 12 do
        bar.buttons[i] = self:CreateButton(bar:GetName() .. "Button" .. i, barDB)
        bar.buttons[i]:SetParent(bar)
        if i == 1 then
            bar.buttons[i]:SetPoint("LEFT", bar, "LEFT", 5, 0)
        else
            bar.buttons[i]:SetPoint("LEFT", bar.buttons[i - 1], "RIGHT", 5, 0)
        end
    end

    bar:SetScript(
        "OnEnter",
        function(self)
            if not barDB then
                return
            end

            if barDB.mouseOver and barDB.alphaMax and barDB.alphaMin then
                local alphaCurrent = bar:GetAlpha()
                E:UIFrameFadeIn(
                    bar,
                    barDB.fadeTime * (barDB.alphaMax - alphaCurrent) / (barDB.alphaMax - barDB.alphaMin),
                    alphaCurrent,
                    barDB.alphaMax
                )
            end
        end
    )

    bar:SetScript(
        "OnLeave",
        function(self)
            if not barDB then
                return
            end

            if barDB.mouseOver and barDB.alphaMax and barDB.alphaMin then
                local alphaCurrent = bar:GetAlpha()
                E:UIFrameFadeOut(
                    bar,
                    barDB.fadeTime * (alphaCurrent - barDB.alphaMin) / (barDB.alphaMax - barDB.alphaMin),
                    alphaCurrent,
                    barDB.alphaMin
                )
            end
        end
    )

    self.bars[id] = bar
end

function EB:UpdateBar(id)
    if not self.db or not self.db["bar" .. id] then
        return
    end

    local bar = self.bars[id]
    local barDB = self.db["bar" .. id]

    if InCombatLockdown() then
        self:UpdateBarTextOnCombat(id)
        UpdateAfterCombat[id] = true
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end

    if not self.db.enable or not barDB.enable then
        if bar.register then
            UnregisterStateDriver(bar, "visibility")
            bar.register = false
        end
        bar:Hide()
        return
    end

    local buttonID = 1

    local function AddButtons(list)
        for _, itemID in pairs(list) do
            local count = GetItemCount(itemID)
            if count and count > 0 and not self.db.blackList[itemID] and buttonID <= barDB.numButtons then
                self:SetUpButton(bar.buttons[buttonID], {itemID = itemID})
                self:UpdateButtonSize(bar.buttons[buttonID], barDB)
                buttonID = buttonID + 1
            end
        end
    end

    for _, module in ipairs {strsplit("[, ]", barDB.include)} do
        if buttonID <= barDB.numButtons then
            if moduleList[module] then
                AddButtons(moduleList[module])
            elseif module == "QUEST" then -- 更新任务物品
                for _, data in pairs(questItemList) do
                    if not self.db.blackList[data.itemID] then
                        self:SetUpButton(bar.buttons[buttonID], data)
                        self:UpdateButtonSize(bar.buttons[buttonID], barDB)
                        buttonID = buttonID + 1
                    end
                end
            elseif module == "EQUIP" then -- 更新装备物品
                for _, slotID in pairs(equipmentList) do
                    local itemID = GetInventoryItemID("player", slotID)
                    if itemID and not self.db.blackList[itemID] and buttonID <= barDB.numButtons then
                        self:SetUpButton(bar.buttons[buttonID], nil, slotID)
                        self:UpdateButtonSize(bar.buttons[buttonID], barDB)
                        buttonID = buttonID + 1
                    end
                end
            elseif module == "CUSTOM" then -- 更新自定义列表
                AddButtons(self.db.customList)
            end
        end
    end

    -- Resize bar
    local numRows = ceil((buttonID - 1) / barDB.buttonsPerRow)
    local numCols = buttonID > barDB.buttonsPerRow and barDB.buttonsPerRow or (buttonID - 1)
    local newBarWidth = 2 * barDB.backdropSpacing + numCols * barDB.buttonWidth + (numCols - 1) * barDB.spacing
    local newBarHeight = 2 * barDB.backdropSpacing + numRows * barDB.buttonHeight + (numRows - 1) * barDB.spacing
    bar:SetSize(newBarWidth, newBarHeight)

    -- Update anchor size
    local numMoverRows = ceil(barDB.numButtons / barDB.buttonsPerRow)
    local numMoverCols = barDB.buttonsPerRow
    local newMoverWidth =
        2 * barDB.backdropSpacing + numMoverCols * barDB.buttonWidth + (numMoverCols - 1) * barDB.spacing
    local newMoverHeight =
        2 * barDB.backdropSpacing + numMoverRows * barDB.buttonHeight + (numMoverRows - 1) * barDB.spacing
    bar:GetParent():SetSize(newMoverWidth, newMoverHeight)

    bar:ClearAllPoints()
    bar:SetPoint(barDB.anchor)

    -- Hide buttons not in use
    if buttonID == 1 then
        if bar.register then
            UnregisterStateDriver(bar, "visibility")
            bar.register = false
        end
        bar:Hide()
        return
    end

    if buttonID <= 12 then
        for hideButtonID = buttonID, 12 do
            bar.buttons[hideButtonID]:Hide()
        end
    end

    for i = 1, buttonID - 1 do
        -- 重新定位图标
        local anchor = barDB.anchor
        local button = bar.buttons[i]

        button:ClearAllPoints()

        if i == 1 then
            if anchor == "TOPLEFT" then
                button:SetPoint(anchor, bar, anchor, barDB.backdropSpacing, -barDB.backdropSpacing)
            elseif anchor == "TOPRIGHT" then
                button:SetPoint(anchor, bar, anchor, -barDB.backdropSpacing, -barDB.backdropSpacing)
            elseif anchor == "BOTTOMLEFT" then
                button:SetPoint(anchor, bar, anchor, barDB.backdropSpacing, barDB.backdropSpacing)
            elseif anchor == "BOTTOMRIGHT" then
                button:SetPoint(anchor, bar, anchor, -barDB.backdropSpacing, barDB.backdropSpacing)
            end
        elseif i <= barDB.buttonsPerRow then
            local nearest = bar.buttons[i - 1]
            if anchor == "TOPLEFT" or anchor == "BOTTOMLEFT" then
                button:SetPoint("LEFT", nearest, "RIGHT", barDB.spacing, 0)
            else
                button:SetPoint("RIGHT", nearest, "LEFT", -barDB.spacing, 0)
            end
        else
            local nearest = bar.buttons[i - barDB.buttonsPerRow]
            if anchor == "TOPLEFT" or anchor == "TOPRIGHT" then
                button:SetPoint("TOP", nearest, "BOTTOM", 0, -barDB.spacing)
            else
                button:SetPoint("BOTTOM", nearest, "TOP", 0, barDB.spacing)
            end
        end

        -- 调整文字风格
        F.SetFontWithDB(button.count, barDB.countFont)
        F.SetFontWithDB(button.bind, barDB.bindFont)

        F.SetFontColorWithDB(button.count, barDB.countFont.color)
        F.SetFontColorWithDB(button.bind, barDB.bindFont.color)

        button.count:ClearAllPoints()
        button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", barDB.countFont.xOffset, barDB.countFont.yOffset)

        button.bind:ClearAllPoints()
        button.bind:SetPoint("TOPRIGHT", button, "TOPRIGHT", barDB.bindFont.xOffset, barDB.bindFont.yOffset)
    end

    if not bar.register then
        RegisterStateDriver(bar, "visibility", "[petbattle]hide;show")
        bar.register = true
    end
    bar:Show()

    -- Toggle shadow
    if barDB.backdrop then
        bar.backdrop:Show()
        if E.private.WT.skins.enable and E.private.WT.skins.windtools and E.private.WT.skins.shadow then
            for i = 1, 12 do
                if bar.buttons[i].shadow then
                    bar.buttons[i].shadow:Hide()
                end
            end
        end
    else
        bar.backdrop:Hide()
        if E.private.WT.skins.enable and E.private.WT.skins.windtools and E.private.WT.skins.shadow then
            for i = 1, 12 do
                if bar.buttons[i].shadow then
                    bar.buttons[i].shadow:Show()
                end
            end
        end
    end

    bar.alphaMin = barDB.alphaMin
    bar.alphaMax = barDB.alphaMax

    if barDB.globalFade then
        bar:SetAlpha(1)
        bar:GetParent():SetParent(AB.fadeParent)
    else
        if barDB.mouseOver then
            bar:SetAlpha(barDB.alphaMin)
        else
            bar:SetAlpha(barDB.alphaMax)
        end
        bar:GetParent():SetParent(E.UIParent)
    end
end

function EB:UpdateBars()
    for i = 1, 5 do
        self:UpdateBar(i)
    end
end

do
    local lastUpdateTime = 0
    function EB:UNIT_INVENTORY_CHANGED()
        local now = GetTime()
        if now - lastUpdateTime < 0.25 then
            return
        end
        lastUpdateTime = now
        UpdateQuestItemList()
        UpdateEquipmentList()

        self:UpdateBars()
    end
end

function EB:UpdateQuestItem()
    UpdateQuestItemList()
    self:UpdateBars()
end

do
    local InUpdating = false
    function EB:ITEM_LOCKED()
        if InUpdating then
            return
        end

        InUpdating = true
        E:Delay(
            1,
            function()
                UpdateEquipmentList()
                self:UpdateBars()
                InUpdating = false
            end
        )
    end
end

function EB:CreateAll()
    self.bars = {}

    for i = 1, 5 do
        self:CreateBar(i)
        S:CreateShadowModule(self.bars[i].backdrop)
        S:MerathilisUISkin(self.bars[i].backdrop)
    end
end

function EB:UpdateBinding()
    if not self.db then
        return
    end

    for i = 1, 5 do
        for j = 1, 12 do
            local button = self.bars[i].buttons[j]
            if button then
                local bindingName = format("CLICK WTExtraItemsBar%dButton%d:LeftButton", i, j)
                local bindingText = GetBindingKey(bindingName) or ""
                bindingText = gsub(bindingText, "BUTTON", "B")
                bindingText = gsub(bindingText, "ALT--", "A")
                bindingText = gsub(bindingText, "CTRL--", "C")
                bindingText = gsub(bindingText, "SHIFT--", "S")

                button.bind:SetText(bindingText)
            end
        end
    end
end

function EB:Initialize()
    self.db = E.db.WT.item.extraItemsBar
    if not self.db or not self.db.enable or self.initialized then
        return
    end

    self:CreateAll()
    UpdateQuestItemList()
    UpdateEquipmentList()
    self:UpdateBars()
    self:UpdateBinding()

    self:RegisterEvent("UNIT_INVENTORY_CHANGED")
    self:RegisterEvent("ITEM_LOCKED")
    self:RegisterEvent("BAG_UPDATE_DELAYED", "UpdateBars")
    self:RegisterEvent("ZONE_CHANGED", "UpdateBars")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "UpdateBars")
    self:RegisterEvent("QUEST_WATCH_LIST_CHANGED", "UpdateQuestItem")
    self:RegisterEvent("QUEST_LOG_UPDATE", "UpdateQuestItem")
    self:RegisterEvent("QUEST_ACCEPTED", "UpdateQuestItem")
    self:RegisterEvent("QUEST_TURNED_IN", "UpdateQuestItem")
    self:RegisterEvent("UPDATE_BINDINGS", "UpdateBinding")

    self.initialized = true
end

function EB:ProfileUpdate()
    self:Initialize()

    if self.db.enable then
        UpdateQuestItemList()
        UpdateEquipmentList()
    elseif self.initialized then
        self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
        self:UnregisterEvent("BAG_UPDATE_DELAYED")
        self:UnregisterEvent("ZONE_CHANGED")
        self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
        self:UnregisterEvent("QUEST_WATCH_LIST_CHANGED")
        self:UnregisterEvent("QUEST_LOG_UPDATE")
        self:UnregisterEvent("QUEST_ACCEPTED")
        self:UnregisterEvent("QUEST_TURNED_IN")
        self:UnregisterEvent("UPDATE_BINDINGS")
    end

    self:UpdateBars()
end

W:RegisterModule(EB:GetName())
