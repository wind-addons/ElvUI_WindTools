local W, F, E, L = unpack((select(2, ...)))
local EB = W:GetModule("ExtraItemsBar")

local pairs = pairs
local sort = sort
local tinsert = tinsert

local potions = {
	general = {
		5512, -- 治療石
		177278, -- 寧靜之瓶
		224464, -- 惡魔治療石
	},
	legacy = {
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
	},
	sl = {
		-- https://www.wowhead.com/items/consumables/potions/min-level:40/min-req-level:51/max-req-level:60?filter=161:166;1:9;0:0
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
		181620, -- 水煮果姆蛋
		182382, -- 邪惡抵抗藥水
		183823, -- 暢行無阻藥水
		187802, -- 宇宙治療藥水
	},
	df = {
		-- https://www.wowhead.com/items/consumables/potions/min-level:40/min-req-level:61/max-req-level:70?filter=161:166;1:10;0:0
		191351, -- 凍結死亡藥水 (1)
		191352, -- 凍結死亡藥水 (2)
		191353, -- 凍結死亡藥水 (3)
		191360, -- 瓶裝腐敗 (1)
		191361, -- 瓶裝腐敗 (2)
		191362, -- 瓶裝腐敗 (3)
		191363, -- 凍結專注藥水 (1)
		191364, -- 凍結專注藥水 (2)
		191365, -- 凍結專注藥水 (3)
		191366, -- 冰冷清晰藥水 (1)
		191367, -- 冰冷清晰藥水 (2)
		191368, -- 冰冷清晰藥水 (3)
		191369, -- 凋萎活力藥水 (1)
		191370, -- 凋萎活力藥水 (2)
		191371, -- 凋萎活力藥水 (3)
		191372, -- 殘餘的神經傳導劑 (1)
		191373, -- 殘餘的神經傳導劑 (2)
		191374, -- 殘餘的神經傳導劑 (3)
		191375, -- 精緻的孢子懸浮液 (1)
		191376, -- 精緻的孢子懸浮液 (2)
		191377, -- 精緻的孢子懸浮液 (3)
		191378, -- 提神治療藥水 (1)
		191379, -- 提神治療藥水 (2)
		191380, -- 提神治療藥水 (3)
		191381, -- 至高威能元素藥水 (1)
		191382, -- 至高威能元素藥水 (2)
		191383, -- 至高威能元素藥水 (3)
		191384, -- 充氣法力藥水 (1)
		191385, -- 充氣法力藥水 (2)
		191386, -- 充氣法力藥水 (3)
		191387, -- 威能元素藥水 (1)
		191388, -- 威能元素藥水 (2)
		191389, -- 威能元素藥水 (3)
		191393, -- 寂靜之風藥水 (1)
		191394, -- 寂靜之風藥水 (2)
		191395, -- 寂靜之風藥水 (3)
		191396, -- 狂風藥水 (1)
		191397, -- 狂風藥水 (2)
		191398, -- 狂風藥水 (3)
		191399, -- 震驚揭露藥水 (1)
		191400, -- 震驚揭露藥水 (2)
		191401, -- 震驚揭露藥水 (3)
		191905, -- 短效威能元素藥水 (1)
		191906, -- 短效威能元素藥水 (2)
		191907, -- 短效威能元素藥水 (3)
		191912, -- 短效至高威能元素藥水 (1)
		191913, -- 短效至高威能元素藥水 (2)
		191914, -- 短效至高威能元素藥水 (3)
		201427, -- 飛逝之沙
		201428, -- 水銀沙漠
		201436, -- 暫時鎖住的沙
		201438, -- 疲倦的沙
		207021, -- 夢行者的治療藥水 (1)
		207022, -- 夢行者的治療藥水 (2)
		207023, -- 夢行者的治療藥水 (3)
		207039, -- 枯萎夢境藥水 (1)
		207040, -- 枯萎夢境藥水 (2)
		207041, -- 枯萎夢境藥水 (3)
	},
	tww = {
		-- https://www.wowhead.com/items/consumables/potions/min-level:40/min-req-level:71?filter=161:166;1:11;0:0
		211878, -- 阿爾加治療藥水 (1)
		211879, -- 阿爾加治療藥水 (2)
		211880, -- 阿爾加治療藥水 (3)
		212239, -- 阿爾加法力藥水 (1)
		212240, -- 阿爾加法力藥水 (2)
		212241, -- 阿爾加法力藥水 (3)
		212242, -- 穴居者之喜 (1)
		212243, -- 穴居者之喜 (2)
		212244, -- 穴居者之喜 (3)
		212245, -- 沉睡靈魂藥水 (1)
		212246, -- 沉睡靈魂藥水 (2)
		212247, -- 沉睡靈魂藥水 (3)
		212248, -- 沉默足音藥劑 (1)
		212249, -- 沉默足音藥劑 (2)
		212250, -- 沉默足音藥劑 (3)
		212251, -- 驚人啟示藥劑 (1)
		212252, -- 驚人啟示藥劑 (2)
		212253, -- 驚人啟示藥劑 (3)
		212254, -- 噁心藥水 (1)
		212255, -- 噁心藥水 (2)
		212256, -- 噁心藥水 (3)
		212257, -- 全神貫注藥水 (1)
		212258, -- 全神貫注藥水 (2)
		212259, -- 全神貫注藥水 (3)
		212260, -- 前線藥水 (1)
		212261, -- 前線藥水 (2)
		212262, -- 前線藥水 (3)
		212263, -- 淬煉藥水 (1)
		212264, -- 淬煉藥水 (2)
		212265, -- 淬煉藥水 (3)
		212266, -- 重生獵豹藥水 (1)
		212267, -- 重生獵豹藥水 (2)
		212268, -- 重生獵豹藥水 (3)
		212318, -- QA阿爾加治療藥水 (3)
		212319, -- QA阿爾加法力藥水 (3)
		212320, -- QA穴居者之喜 (3)
		212321, -- QA沉睡靈魂藥水 (3)
		212322, -- QA沉默足音藥劑 (3)
		212323, -- QA驚人啟示藥劑 (3)
		212324, -- QA噁心藥水 (3)
		212325, -- QA全神貫注藥水 (3)
		212326, -- QA前線藥水 (3)
		212327, -- QA淬煉藥水 (3)
		212328, -- QA重生獵豹藥水 (3)
		212942, -- 短效阿爾加治療藥水 (1)
		212943, -- 短效阿爾加治療藥水 (2)
		212944, -- 短效阿爾加治療藥水 (3)
		212945, -- 短效阿爾加法力藥水 (1)
		212946, -- 短效阿爾加法力藥水 (2)
		212947, -- 短效阿爾加法力藥水 (3)
		212948, -- 短效穴居者之喜 (1)
		212949, -- 短效穴居者之喜 (2)
		212950, -- 短效穴居者之喜 (3)
		212951, -- 短效沉睡靈魂藥水 (1)
		212952, -- 短效沉睡靈魂藥水 (2)
		212953, -- 短效沉睡靈魂藥水 (3)
		212954, -- 短效沉默足音藥劑 (1)
		212955, -- 短效沉默足音藥劑 (2)
		212956, -- 短效沉默足音藥劑 (3)
		212957, -- 短效驚人啟示藥劑 (1)
		212958, -- 短效驚人啟示藥劑 (2)
		212959, -- 短效驚人啟示藥劑 (3)
		212960, -- 飛逝的噁心藥水 (1)
		212961, -- 飛逝的噁心藥水 (2)
		212962, -- 飛逝的噁心藥水 (3)
		212963, -- 短效全神貫注藥水 (1)
		212964, -- 短效全神貫注藥水 (2)
		212965, -- 短效全神貫注藥水 (3)
		212966, -- 短效前線藥水 (1)
		212967, -- 短效前線藥水 (2)
		212968, -- 短效前線藥水 (3)
		212969, -- 短效淬煉藥水 (1)
		212970, -- 短效淬煉藥水 (2)
		212971, -- 短效淬煉藥水 (3)
		212972, -- 短效重生獵豹藥水 (1)
		212973, -- 短效重生獵豹藥水 (2)
		212974, -- 短效重生獵豹藥水 (3)
	},
}

local flasks = {
	legacy = {
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
	},
	sl = {
		-- https://www.wowhead.com/items/consumables/flasks/min-level:40/min-req-level:51/max-req-level:60?filter=161:166;1:9;0:0
		171276, -- 鬼靈威力精煉藥劑
		171278, -- 鬼靈耐力精煉藥劑
		171280, -- 永恆精煉藥劑
	},
	df = {
		-- https://www.wowhead.com/items/consumables/flasks/min-level:40/min-req-level:51/max-req-level:60?filter=161:166;1:10;0:0

		191318, -- 暴風眼之瓶 (1)
		191319, -- 暴風眼之瓶 (2)
		191320, -- 暴風眼之瓶 (3)
		191321, -- 靜氣之瓶 (1)
		191322, -- 靜氣之瓶 (2)
		191323, -- 靜氣之瓶 (3)
		191324, -- 冰凍護存之瓶 (1)
		191325, -- 冰凍護存之瓶 (2)
		191326, -- 冰凍護存之瓶 (3)
		191327, -- 腐化之怒冰瓶 (1)
		191328, -- 腐化之怒冰瓶 (2)
		191329, -- 腐化之怒冰瓶 (3)
		191330, -- 高能隔離之瓶 (1)
		191331, -- 高能隔離之瓶 (2)
		191332, -- 高能隔離之瓶 (3)
		191333, -- 冰川狂怒之瓶 (1)
		191334, -- 冰川狂怒之瓶 (2)
		191335, -- 冰川狂怒之瓶 (3)
		191336, -- 靜止強化之瓶 (1)
		191337, -- 靜止強化之瓶 (2)
		191338, -- 靜止強化之瓶 (3)
		191339, -- 不慍不火之瓶 (1)
		191340, -- 不慍不火之瓶 (2)
		191341, -- 不慍不火之瓶 (3)
		191342, -- 純熟氣泡瓶 (1)
		191343, -- 純熟氣泡瓶 (2)
		191344, -- 純熟氣泡瓶 (3)
		191345, -- 技法蒸汽瓶 (1)
		191346, -- 技法蒸汽瓶 (2)
		191347, -- 技法蒸汽瓶 (3)
		191348, -- 矯捷充能瓶 (1)
		191349, -- 矯捷充能瓶 (2)
		191350, -- 矯捷充能瓶 (3)
		191354, -- 感知水晶之瓶 (1)
		191355, -- 感知水晶之瓶 (2)
		191356, -- 感知水晶之瓶 (3)
		191357, -- 元素混沌之瓶 (1)
		191358, -- 元素混沌之瓶 (2)
		191359, -- 元素混沌之瓶 (3)
		197720, -- 快手氣泡瓶 (1)
		197721, -- 快手氣泡瓶 (2)
		197722, -- 快手氣泡瓶 (3)
		204643, -- 短效暴風眼之瓶 (1)
		204644, -- 短效暴風眼之瓶 (2)
		204645, -- 短效暴風眼之瓶 (3)
		204646, -- 短效靜氣之瓶 (1)
		204647, -- 短效靜氣之瓶 (2)
		204648, -- 短效靜氣之瓶 (3)
		204649, -- 短效冰凍護存之瓶 (1)
		204650, -- 短效冰凍護存之瓶 (2)
		204651, -- 短效冰凍護存之瓶 (3)
		204652, -- 暫存的腐化之怒冰瓶 (1)
		204653, -- 暫存的腐化之怒冰瓶 (2)
		204654, -- 暫存的腐化之怒冰瓶 (3)
		204655, -- 短效高能隔離之瓶 (1)
		204656, -- 短效高能隔離之瓶 (2)
		204657, -- 短效高能隔離之瓶 (3)
		204658, -- 短效冰川狂怒之瓶 (1)
		204659, -- 短效冰川狂怒之瓶 (2)
		204660, -- 短效冰川狂怒之瓶 (3)
		204661, -- 短效靜止強化之瓶 (1)
		204662, -- 短效靜止強化之瓶 (2)
		204663, -- 短效靜止強化之瓶 (3)
		204664, -- 短效不慍不火之瓶 (1)
		204665, -- 短效不慍不火之瓶 (2)
		204666, -- 短效不慍不火之瓶 (3)
		204667, -- 暫存的矯捷充能瓶 (1)
		204668, -- 暫存的矯捷充能瓶 (2)
		204669, -- 暫存的矯捷充能瓶 (3)
		204670, -- 短效元素混沌之瓶 (1)
		204671, -- 短效元素混沌之瓶 (2)
		204672, -- 短效元素混沌之瓶 (3)
	},
	tww = {
		-- https://www.wowhead.com/items/consumables/flasks/min-level:40/min-req-level:71?filter=161:166;1:11;0:0
		212269, -- 淬煉侵略精煉藥劑 (1)
		212270, -- 淬煉侵略精煉藥劑 (2)
		212271, -- 淬煉侵略精煉藥劑 (3)
		212272, -- 淬煉迅捷精煉藥劑 (1)
		212273, -- 淬煉迅捷精煉藥劑 (2)
		212274, -- 淬煉迅捷精煉藥劑 (3)
		212275, -- 淬煉機變精煉藥劑 (1)
		212276, -- 淬煉機變精煉藥劑 (2)
		212277, -- 淬煉機變精煉藥劑 (3)
		212278, -- 淬鍊精通精煉藥劑 (1)
		212279, -- 淬鍊精通精煉藥劑 (2)
		212280, -- 淬鍊精通精煉藥劑 (3)
		212281, -- 鍊金混沌精煉藥劑 (1)
		212282, -- 鍊金混沌精煉藥劑 (2)
		212283, -- 鍊金混沌精煉藥劑 (3)
		212289, -- 古典精神兇惡精煉藥劑
		212292, -- 榮譽兇惡精煉藥劑
		212295, -- 現形之怒兇惡精煉藥劑
		212298, -- 破壞鐵球兇惡精煉藥劑
		212299, -- 截長補短精煉藥劑 (1)
		212300, -- 截長補短精煉藥劑 (2)
		212301, -- 截長補短精煉藥劑 (3)
		212305, -- 濃縮精妙藥瓶 (1)
		212306, -- 濃縮精妙藥瓶 (2)
		212307, -- 濃縮精妙藥瓶 (3)
		212308, -- 真識藥瓶 (1)
		212309, -- 真識藥瓶 (2)
		212310, -- 真識藥瓶 (3)
		212311, -- 強化左右開弓藥瓶 (1)
		212312, -- 強化左右開弓藥瓶 (2)
		212313, -- 強化左右開弓藥瓶 (3)
		212314, -- 豐收季節藥瓶 (1)
		212315, -- 豐收季節藥瓶 (2)
		212316, -- 豐收季節藥瓶 (3)
		212725, -- 短效淬煉侵略精煉藥劑 (1)
		212727, -- 短效淬煉侵略精煉藥劑 (2)
		212728, -- 短效淬煉侵略精煉藥劑 (3)
		212729, -- 短效淬煉迅捷精煉藥劑 (1)
		212730, -- 短效淬煉迅捷精煉藥劑 (2)
		212731, -- 短效淬煉迅捷精煉藥劑 (3)
		212732, -- 短效淬煉機變精煉藥劑 (1)
		212733, -- 短效淬煉機變精煉藥劑 (2)
		212734, -- 短效淬煉機變精煉藥劑 (3)
		212735, -- 短效淬鍊精通精煉藥劑 (1)
		212736, -- 短效淬鍊精通精煉藥劑 (2)
		212738, -- 短效淬鍊精通精煉藥劑 (3)
		212739, -- 短效鍊金混沌精煉藥劑 (1)
		212740, -- 短效鍊金混沌精煉藥劑 (2)
		212741, -- 短效鍊金混沌精煉藥劑 (3)
		212745, -- 短效截長補短精煉藥劑 (1)
		212746, -- 短效截長補短精煉藥劑 (2)
		212747, -- 短效截長補短精煉藥劑 (3)
	},
}

local runes = {
	df = {
		-- https://www.wowhead.com/items/consumables/item-enhancements-temporary/min-level:50?filter=161:166;1:10;0:0
		191933, -- 洪荒磨石 (1)
		191939, -- 洪荒打磨石 (2)
		191940, -- 洪荒打磨石 (3)
		191943, -- 洪荒平衡石 (1)
		191944, -- 洪荒配重石 (2)
		191945, -- 洪荒配重石 (3)
		191948, -- 洪荒磨刃石 (1)
		191949, -- 洪荒磨刃石 (2)
		191950, -- 洪荒磨刃石 (3)
		194817, -- 尖嘯符文 (1)
		194819, -- 尖嘯符文 (2)
		194820, -- 尖嘯符文 (3)
		194821, -- 嗡鳴符文 (1)
		194822, -- 嗡鳴符文 (2)
		194823, -- 嗡鳴符文 (3)
		194824, -- 鳴叫符文 (1)
		194825, -- 鳴叫符文 (2)
		194826, -- 鳴叫符文 (3)
		198160, -- 超安全火箭 (1)
		198161, -- 超安全火箭 (2)
		198162, -- 超安全火箭 (3)
		198163, -- 無限針堆 (1)
		198164, -- 無限針堆 (2)
		198165, -- 無限針堆 (3)
		204971, -- 嘶鳴符文 (1)
		204972, -- 嘶鳴符文 (2)
		204973, -- 嘶鳴符文 (3)
	},
	tww = {
		220156, -- 冒泡蠟
		222502, -- 鐵爪磨石 (1)
		222503, -- 鐵爪磨石 (2)
		222504, -- 鐵爪磨石 (3)
		222505, -- 鐵爪磨刃石 (1)
		222506, -- 鐵爪磨刃石 (2)
		222507, -- 鐵爪磨刃石 (3)
		222508, -- 鐵爪平衡石 (1)
		222509, -- 鐵爪平衡石 (2)
		222510, -- 鐵爪平衡石 (3)
		223979, -- 低語蠕蟲
		224105, -- 阿爾加法力之油 (1)
		224106, -- 阿爾加法力之油 (2)
		224107, -- 阿爾加法力之油 (3)
		224108, -- 巴雷達爾恩典之油 (1)
		224109, -- 巴雷達爾恩典之油 (2)
		224110, -- 巴雷達爾恩典之油 (3)
		224111, -- 深邃毒素之油 (1)
		224112, -- 深邃毒素之油 (2)
		224113, -- 深邃毒素之油 (3)
		224572, -- 結晶增強符文
	},
}

local vantus = {
	df = {
		-- https://www.wowhead.com/items/consumables/name:Vantus+Rune/min-level:50?filter=161:166;1:10;0:0
		198491, -- 梵陀符文：洪荒化身牢獄 (1)
		198492, -- 梵陀符文：洪荒化身牢獄 (2)
		198493, -- 梵陀符文：洪荒化身牢獄 (3)
		204858, -- 梵陀符文：『朧影實驗場』亞貝魯斯。 (1)
		204859, -- 梵陀符文：『朧影實驗場』亞貝魯斯。 (2)
		204860, -- 梵陀符文：『朧影實驗場』亞貝魯斯。 (3)
		210247, -- 梵陀符文：『夢境希望』埃達希爾 (1)
		210248, -- 梵陀符文：『夢境希望』埃達希爾 (2)
		210249, -- 梵陀符文：『夢境希望』埃達希爾 (3)
	},
	tww = {
		-- https://www.wowhead.com/items/consumables/name:Vantus+Rune/min-level:50?filter=161:166;1:11;0:0
		226034, -- 梵陀符文：奈幽巴宮殿 (1)
		226035, -- 梵陀符文：奈幽巴宮殿 (2)
		226036, -- 梵陀符文：奈幽巴宮殿 (3)
	},
}

local foods = {
	crafted_sl = {
		-- https://www.wowhead.com/items/consumables/food-and-drinks/min-req-level:40?filter=86:166;11:9;0:0
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
		187648, -- 石頭湯空壺
	},
	crafted_df = {
		-- https://www.wowhead.com/items/consumables/food-and-drinks/min-req-level:40?filter=86:166;11:10;0:0
		197758, -- 兩面烘烤馬鈴薯
		197759, -- 吉利呱啦餅
		197760, -- 鯖魚點心
		197761, -- 大概是蛋白質
		197762, -- 酸甜蛤蜊濃湯
		197763, -- 龍族勇士早餐
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
		197795, -- 龍族佳餚大餐
		202290, -- 火水雪糕
		204072, -- 整人魔鬼蛋
		207054, -- 沉眠寧神花茶
	},
	crafted_tww = {
		-- https://www.wowhead.com/items/consumables/food-and-drinks/min-level:80?filter=166:86;11:11;0:0
		-- https://www.wowhead.com/items/consumables/food-and-drinks/name:Hearty?filter=166;11;0#50
		222307, -- 澎湃未調味的野味肉排
		222308, -- 澎湃炙烤真菌花
		222309, -- 澎湃鍋烙真菌花
		222310, -- 澎湃聖落之地辣醬
		222311, -- 澎湃地心通途肉串
		222312, -- 澎湃閃焰之火肉片
		222313, -- 澎湃肉塊和馬鈴薯
		222314, -- 澎湃黏黏肋排
		222315, -- 澎湃酸甜肉丸
		222317, -- 澎湃香辣魚肉串
		222318, -- 澎湃火熱鮮魚棒
		222319, -- 澎湃薑汁魚排
		222324, -- 澎湃炸魚薯條
		222325, -- 澎湃鹽焗海鮮
		222326, -- 澎湃釣手的點心
		222332, -- 澎湃日光佳饌
		222333, -- 澎湃夜暮補品
		222334, -- 澎湃深夜點心
		222335, -- 澎湃暗影灌注燴肉
		222338, -- 澎湃炸魚餐
		222343, -- 澎湃提神咖啡
		222345, -- 澎湃崩岩奶昔
		222702, -- 串烤肉片
		222703, -- 簡單的燉肉
		222704, -- 未調味的野味肉排
		222705, -- 炙烤真菌花
		222706, -- 鍋烙真菌花
		222707, -- 聖落之地辣醬
		222708, -- 地心通途肉串
		222709, -- 閃焰之火肉片
		222710, -- 肉塊和馬鈴薯
		222711, -- 黏黏肋排
		222712, -- 酸甜肉丸
		222713, -- 軟嫩暮光肉乾
		222714, -- 香辣魚肉串
		222715, -- 火熱鮮魚棒
		222716, -- 薑汁魚排
		222717, -- 鹹狗鯊派
		222718, -- 深鰭肉餅
		222719, -- 甜辣湯
		222720, -- 特級壽司
		222721, -- 炸魚薯條
		222722, -- 鹽焗海鮮
		222723, -- 醃製嫩腰肉
		222724, -- 滋滋作響的蜜汁烤肉
		222725, -- 真菌花燉飯
		222726, -- 包餡洞穴青椒
		222727, -- 釣手的點心
		222728, -- 巴雷達爾的恩惠
		222729, -- 女皇的告別
		222730, -- 小丑膳食
		222731, -- 外來者糧食
		222732, -- 神聖日盛宴
		222733, -- 午夜化妝舞會盛宴
		222735, -- 大雜燴
		222736, -- 炸魚餐
		222740, -- 澎湃大餐
		222744, -- 燼火花蜜
		222745, -- 提神咖啡
		222747, -- 崩岩奶昔
		222748, -- 黏稠甜點
		222749, -- 熔化的蠟燭條
		222750, -- 澎湃串烤肉片
		222751, -- 澎湃簡單的燉肉
		222752, -- 澎湃未調味的野味肉排
		222753, -- 澎湃炙烤真菌花
		222754, -- 澎湃鍋烙真菌花
		222755, -- 澎湃聖落之地辣醬
		222756, -- 澎湃地心通途肉串
		222757, -- 澎湃閃焰之火肉片
		222758, -- 澎湃肉塊和馬鈴薯
		222759, -- 澎湃黏黏肋排
		222760, -- 澎湃酸甜肉丸
		222761, -- 澎湃軟嫩暮光肉乾
		222762, -- 澎湃香辣魚肉串
		222763, -- 澎湃火熱鮮魚棒
		222764, -- 澎湃薑汁魚排
		222765, -- 澎湃鹹狗鯊派
		222766, -- 澎湃深鰭肉餅
		222767, -- 澎湃甜辣湯
		222768, -- 澎湃特級壽司
		222769, -- 澎湃炸魚薯條
		222770, -- 澎湃鹽焗海鮮
		222771, -- 澎湃醃製嫩腰肉
		222772, -- 澎湃滋滋作響的蜜汁烤肉
		222773, -- 澎湃真菌花燉飯
		222774, -- 澎湃包餡洞穴青椒
		222775, -- 澎湃釣手的點心
		222776, -- 澎湃巴雷達爾的恩惠
		222777, -- 澎湃女皇的告別
		222778, -- 澎湃小丑膳食
		222779, -- 澎湃外來者糧食
		222780, -- 澎湃神聖日盛宴
		222781, -- 澎湃午夜化妝舞會盛宴
		222782, -- 澎湃鄉村便餐
		222783, -- 澎湃大雜燴
		222784, -- 澎湃炸魚餐
		223968, -- 綿密炒蛋
		225592, -- 精心剔骨的肉排
		225855, -- 美味食屍魚
		233062, -- 袋装披萨
		233118, -- 洋际外卖
	},
	vendor = {
		-- https://www.wowhead.com/items/consumables/food-and-drinks/min-level:80/min-req-level:75?filter=92:166;1:11;0:0
		224762, -- 探究者水囊
		226811, -- 醃製蛆蟲
		227301, -- 水晶小點
		227302, -- 花崗岩沙拉
		227303, -- 蠟味起司點心
		227304, -- 蘑菇蛋糕
		227305, -- 飛船熱狗堡
		227306, -- 神聖鯖魚
		227307, -- 綜合蟲碗
		227308, -- 片開的深淵行者
		227317, -- 熔岩可樂
		227318, -- 水銀清飲
		227319, -- 狗布奇諾
		227320, -- 巫木幻飲
		227321, -- 祝福之酒
		227322, -- 沐聖沙士
		227323, -- 蘑菇茶
		227324, -- 奈幽巴蜜露
		227325, -- 石頭湯
		227326, -- 輝銅熔岩蛋糕
		227327, -- 石板街麵包
		227328, -- 融蠟火鍋
		227329, -- 生猛秋葵濃湯
		227330, -- 石穴燉煮
		227331, -- 聖者之歡
		227332, -- 以太啜飲
		227333, -- 微光佳餚
		227334, -- 鼴鼠料理
		227335, -- 鑽孔蟲血腸布丁
		227336, -- 蜜糖漿液
		236633, -- 贫穷泡沫饮料
		236646, -- 加乐宫特选
		236647, -- 硬币配卡亚
		236650, -- 镇痛水
		236680, -- 蟹肉棒
		236681, -- 液态黄金
	},
	mage = {
		-- https://www.wowhead.com/beta/items/consumables/food-and-drinks/name:Conjured+Mana
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
		113509, -- 魔法法力餐包
	},
}

local fishings = {
	general = {
		6529, -- 闪光的小珠
		6530, -- 夜色虫
		6532, -- 明亮的小珠
		6533, -- 水下诱鱼器
		136377, -- 巨型鱼漂
		202207, -- 可重复使用的巨型鱼漂
	},
	tww = {
		-- fish lure https://www.wowhead.com/cn/items/consumables/other/name:%E9%B1%BC%E9%A5%B5?filter=166;11;0
		219002, -- 高光虹鱼鱼饵
		219003, -- 静谧河鲈鱼饵
		219004, -- 多恩梭鱼鱼饵
		219005, -- 阿拉索锤头鲨鱼饵
		219006, -- 咆哮的渔夫寻猎者鱼饵
		-- fish that can be used to get buff https://www.wowhead.com/items/trade-goods/meat?filter=166:69;11:1;0:0
		220134, -- 拖沓鲦
		220135, -- 血红鲈
		220136, -- 晶脉鲟
		220137, -- 铋鳑鲏
		220138, -- 轻吻鲦鱼
		220139, -- 低语观星鲑
		220146, -- 皇家拟雀鲷
		220152, -- 受诅食尸鱼
	},
}

local banners = {
	18606, -- 聯盟戰旗
	18607, -- 部落戰旗
	63359, -- 合作旌旗
	64398, -- 團結軍旗
	64399, -- 協調戰旗
	64400, -- 合作旌旗
	64401, -- 團結軍旗
	64402, -- 協調戰旗
}

local utilities = {
	49040, -- 吉福斯
	109076, -- 哥布林滑翔工具組
	132514, -- 自動鐵錘
	132516, -- 槍靴
	193470, -- 兇野皮鼓
	221945, -- 誘人的紅色按鈕
	221949, -- 暫停裝置
	221953, -- 極為實用的起搏器 (1)
	221954, -- 極為實用的起搏器 (2)
	221955, -- 極為實用的起搏器 (3)
}

local openableItems = {
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
	200094, -- 商隊保險箱
	200095, -- 充滿補給品的湯鍋
	200468, -- 大狩獵戰利品
	200513, -- 大狩獵戰利品
	200515, -- 大狩獵戰利品
	200516, -- 大狩獵戰利品
	201462, -- 形狀奇特的胃袋
	201754, -- 黑曜熔爐大師的寶箱
	201755, -- 黑曜熔爐大師的保險箱
	201756, -- 鼓鼓的零錢包
	201817, -- 暮光儲藏箱
	201818, -- 暮光保險箱
	202079, -- 密庫藏寶箱
	202080, -- 密庫藏寶箱
	202142, -- 龍禍要塞保險箱
	202171, -- 龍族錢包
	202172, -- 裝了滿滿金幣的袋子
	202371, -- 發光的洪荒使者寶箱
	203217, -- 龍鱗多餘物資木箱
	203220, -- 伊斯凱拉多餘物資包
	203222, -- 莫魯克多餘物資包裹
	203224, -- 沃卓肯多餘物資箱
	203476, -- 洪荒使者寶箱
	203700, -- 破舊的禮物包
	204339, -- 一袋聚合混沌
	204359, -- 競速騎師的錢包
	204378, -- 裝滿的龍鱗遠征隊補給背包
	204379, -- 裝滿的伊斯凱拉補給背包
	204380, -- 裝滿的莫魯克半人馬補給包
	204381, -- 裝滿的沃卓肯協調者補給背包
	204383, -- 一袋奇玩
	204712, -- 裝滿的洛姆鼴鼠人補給包
	204721, -- 幼龍的小寶箱
	204722, -- 幼龍的豐碩寶箱
	204723, -- 幼龍的沉重寶箱
	204724, -- 飛龍的小寶箱
	204725, -- 飛龍的沉重寶箱
	204726, -- 飛龍的豐碩寶箱
	205226, -- 洞穴競賽者的錢包
	205247, -- 鏗鏘作響的覆泥小包
	205248, -- 叮噹作響的覆泥小包
	205288, -- 被埋起來的鼴鼠人收藏
	205346, -- 隱藏的鼴鼠人寶藏
	205347, -- 收集來的鼴鼠人資源
	205367, -- 負疚研究員的禮物
	205368, -- 感恩研究員的禮物
	205369, -- 感激研究員的禮物
	205370, -- 研究員的禮物
	205371, -- 感激研究員收集來的貨物
	205372, -- 負疚研究員收集來的貨物
	205373, -- 研究員收集來的貨物
	205374, -- 感恩研究員收集來的貨物
	205423, -- 暗焰殘渣袋
	205964, -- 小型洛姆補給包
	205965, -- 大型洛姆補給包
	205966, -- 亞貝魯斯寶箱
	205967, -- 亞貝魯斯寶箱
	205968, -- 滿溢洛姆補給包
	205983, -- 很有味道的鼴鼠人寶藏
	206135, -- 英雄難度地城鑽研家的戰利品箱子
	207002, -- 囊封命運
	207582, -- 一箱竄改的現實
	207583, -- 一箱塌縮的現實
	207584, -- 一箱易變的現實
	208090, -- 超因果容器
	208091, -- 時光扭曲寶箱
	208094, -- 時光扭曲寶箱
	208095, -- 時光扭曲寶箱
	208951, -- 超因果集簇
	208952, -- 索芮朵蜜的表揚信
	209837, -- 夢境微弱呢喃
	209839, -- 夢境明確呢喃
	209037, -- 埃達希爾寶藏箱
	210180, -- 翡翠龍石
	210549, -- 夢境競速騎師的錢包
	210872, -- 夢境背袋
	210217, -- 小型夢境賞金袋
	210218, -- 鼓起的夢境賞金袋
	210219, -- 大型夢境賞金袋
	210756, -- 一袋發光飛龍夢境紋章
	210762, -- 一把閃耀巨龍夢境紋章
	210768, -- 一扎淡綠守護巨龍夢境紋章
	210770, -- 一袋飛龍夢境紋章
	210780, -- 菲拉雷斯的小片餘燼
	210871, -- 菲拉雷斯的大片餘燼
	210917, -- 一袋幼龍夢境紋章
	210923, -- 一把巨龍夢境紋章
	210992, -- 溢滿的夢境守望者寶藏
	211303, -- 林精補給袋
	211389, -- 放過剩寶藏箱
	211394, -- 收穫的夢境種子貯藏箱
	211410, -- 盛開野花箱子
	211411, -- 萌芽夢珍寶
	211413, -- 花蕾夢珍寶
	211414, -- 繁花夢珍寶
	215362, -- 風暴寶箱
	215363, -- 餘燼貯藏箱
	215364, -- 夢境貯藏箱
	217109, -- 覺醒風暴貯藏箱
	217110, -- 覺醒餘燼貯藏箱
	217111, -- 覺醒夢境貯藏箱
	217241, -- 覺醒晶紅之翼
	217242, -- 覺醒岩石之翼
	217243, -- 覺醒晶紅之翼
	217728, -- 覺醒寶藏貯藏箱
	-- TWW https://www.wowhead.com/items/miscellaneous?filter=11:166;1:11;0:0
	217011, -- 業餘演員箱子
	217012, -- 新手演員箱子
	217013, -- 專家演員箱子
	218738, -- 形狀奇怪的胃袋
	220767, -- 一袋凱旋的雕刻先驅者紋章
	220773, -- 一包慶祝用的符文先驅者紋章
	220776, -- 一組光榮的鍍金先驅者紋章
	221268, -- 一袋陳舊先驅者紋章
	221269, -- 赤紅勇氣石
	221373, -- 一袋雕刻先驅者紋章
	221375, -- 一包符文先驅者紋章
	221502, -- 冒險者的戰隊綁定戰裝掉落
	221503, -- 探險者的戰隊綁定戰裝掉落
	224556, -- 榮耀爭奪者的保險箱
	224573, -- 水晶合作背包
	224721, -- 蠟封箱子
	224722, -- 一包蠟質共鳴水晶
	224723, -- 一捆蠟質皮革
	224724, -- 一包蠟質附魔塵
	224725, -- 一捆蠟質草藥
	224726, -- 一盒蠟質石頭
	224784, -- 尖端儲物箱
	225239, -- 滿溢多恩諾加議會寶藏
	225245, -- 滿溢深淵寶藏
	225246, -- 滿溢聖落之地寶藏
	225247, -- 滿溢斷裂絲線寶藏
	225249, -- 嘎嘎響的黃金袋
	225571, -- 織絲者的賞賜
	225572, -- 將軍的戰爭寶箱
	225573, -- 輔臣的資金
	225896, -- 虛無之觸勇氣石
	226045, -- 將軍的珍寶
	226100, -- 輔臣的珍寶
	226103, -- 織絲者的珍寶
	226146, -- 一把亮晶晶又嗡嗡叫的東西
	226147, -- 一堆勇敢石頭
	226148, -- 蠟封陳舊紋章
	226149, -- 一堆亮晶晶又嗡嗡叫的東西
	226152, -- 蠟封紋章
	226154, -- 蠟封工藝紋章
	226193, -- 奈幽寶藏箱
	226194, -- 奈幽寶藏箱
	226195, -- 共鳴水晶簇
	226196, -- 絲質卡吉錢袋
	226198, -- 共鳴水晶叢
	226199, -- 絲質卡吉錢包
	226256, -- 追憶者紀念品
	226258, -- 探究者材料袋
	226259, -- 探究者共鳴水晶袋
	226263, -- 劇團寶箱
	226264, -- 聖輝寶箱
	226273, -- 覺醒機械寶箱
	226392, -- 粗心猛冲者的宝藏
	226813, -- 黃金勇氣石
	226814, -- 一箱金幣
	227450, -- 天空競速騎師的錢包
	227713, -- 工匠聯盟報酬
	227792, -- 日常儲物箱
	228361, -- 老練冒險者的貯藏箱
	228741, -- 燈火者補給包
	228916, -- 阿爾加裁縫師背袋
	228917, -- 一袋礦石
	228919, -- 一袋阿爾加草藥
	228931, -- 阿爾加附魔師背袋
	228932, -- 阿爾加工程師背袋
	228933, -- 阿爾加製皮師背袋
	228959, -- 一堆不明的肉
	229005, -- 土靈寶藏箱
	229006, -- 土靈寶藏箱
	229129, -- 探究者戰利品寶箱
	229130, -- 探究者戰利品寶箱
	231153, -- 一袋凱旋的雕刻幽坑城紋章
	231154, -- 一包慶祝用的符文幽坑城紋章
	231264, -- 一組光榮的鍍金幽坑城紋章
	231267, -- 一袋陳舊幽坑城紋章
	231269, -- 一袋雕刻幽坑城紋章
	231270, -- 一包符文幽坑城紋章
	232076, -- 冒險者的戰隊綁定戰裝掉落
	232372, -- 一箱昔日的財寶
	232382, -- 黃金勇氣石
	232463, -- 滿溢幽坑城寶藏
	232465, -- 暗融寶箱
	232471, -- 黑鐵矮人寶箱
	232472, -- 黑鐵矮人寶箱
	232473, -- 黑鐵矮人寶箱
	233276, -- 探究者新手組合
	233281, -- 探究者的驚奇造型包
	233557, -- 過篩的廢料堆
	233558, -- S.C.R.A.P.豪華清潔箱
	234425, -- 被遺忘的對開本
	234816, -- 滿溢的一袋鐵
	234729, -- 幽坑城寶箱
	234731, -- 幽坑城寶箱
	234743, -- 熱砂寶箱
	234744, -- 黑水寶箱
	234745, -- 污水寶箱
	234746, -- 風險投資公司寶箱
	235052, -- 陳舊的神秘背袋
	235054, -- 完好的神秘背袋
	235151, -- 傑出演員箱子
	235258, -- 污水寶箱
	235259, -- 污水寶箱
	235260, -- 黑水寶箱
	235261, -- 黑水寶箱
	235262, -- 熱砂寶箱
	235263, -- 熱砂寶箱
	235264, -- 風險投資公司寶箱
	235265, -- 風險投資公司寶箱
	235548, -- 土靈旱鴨子儲物箱
	235558, -- 一箱暗融雜物
	235610, -- 老練冒險者的貯藏箱
	235639, -- 老練冒險者的貯藏箱
	235911, -- 陳舊的神秘背袋
	236756, -- 社會期待的小費箱
	236757, -- 豐厚小費箱
	236758, -- 慷慨小費箱
	236944, -- 陳舊的神秘背袋
	236953, -- 赤紅勇氣石
	236954, -- 虛無之觸勇氣石
	237132, -- 污水寶箱
	237133, -- 風險投資公司寶箱
	237134, -- 熱砂寶箱
	237135, -- 黑水寶箱
	237743, -- 阿拉希士兵保險箱
	237759, -- 阿拉希教士寶箱
	237760, -- 阿拉希勇士戰利品
	238207, -- 奶奶的超極紅利
	238208, -- 奶奶的超極紅利
	239004, -- 聖輝貢獻背袋
	239118, -- 尖端儲物箱
	239120, -- 老練冒險者的貯藏箱
	239121, -- 覺醒機械寶箱
	239122, -- 將軍的戰爭寶箱
	239124, -- 輔臣的資金
	239125, -- 織絲者的賞賜
	239126, -- 聖輝寶箱
	239128, -- 劇團寶箱
	239489, -- 聖輝軍官儲藏箱
	239546, -- 被沒收的教徒背包
	242386, -- 博學行者的紀念品箱
	244466, -- 達格蘭的裂片小包
	244696, -- 超載箱
	245589, -- 喚魔者之箱
}

local professionItems = {
	-- https://www.wowhead.com/items/miscellaneous/other?filter=166:98:111;11:1:2;0:0:1
	-- https://www.wowhead.com/items/miscellaneous/other?filter=107;0;increase+your+Khaz+Algar
	213779, -- 阿爾加琥珀稜石 (1)
	213780, -- 阿爾加琥珀稜石 (2)
	213781, -- 阿爾加琥珀稜石 (3)
	222546, -- 阿爾加鍊金術概論
	222547, -- 阿爾加裁縫概論
	222548, -- 阿爾加銘文學概論
	222549, -- 阿爾加製皮概論
	222550, -- 阿爾加附魔概論
	222551, -- 阿爾加珠寶設計概論
	222552, -- 阿爾加草藥學概論
	222553, -- 阿爾加採礦概論
	222554, -- 阿爾加鍛造概論
	222621, -- 阿爾加工程學概論
	222649, -- 阿爾加剝皮概論
	224007, -- 剩餘軀殼的用途(如何將它們拆開)
	224023, -- 草藥防腐技藝
	224024, -- 肉體轉化理論，第8章
	224036, -- 層層蛛網的幕後秘辛！
	224038, -- 捨棄薩鋼的鍛造術
	224050, -- 蛛網火花：華麗而強大
	224052, -- 時鐘、齒輪、鏈輪和腳
	224053, -- 防禦敵對符文的八種觀點
	224054, -- 地表居民的新興水晶
	224055, -- 萬石起頭難
	224056, -- 剩餘軀殼的用途(將它們拆開之後)
	224264, -- 暗叢花瓣
	224265, -- 暗叢玫瑰
	224583, -- 石板片
	224584, -- 侵蝕拋光的石板
	224645, -- 珠寶蝕刻的鍊金術筆記
	224647, -- 珠寶蝕刻的鍛造筆記
	224648, -- 珠寶蝕刻的裁縫筆記
	224651, -- 機器學習工程學筆記
	224652, -- 珠寶蝕刻的附魔筆記
	224653, -- 機器學習工程學筆記
	224654, -- 機器學習銘文學筆記
	224655, -- 虛無點亮的珠寶設計筆記
	224656, -- 虛無點亮的草藥學筆記
	224657, -- 虛無點亮的剝皮筆記
	224658, -- 虛無點亮的製皮筆記
	224780, -- 韌化的風暴毛皮
	224781, -- 深淵毛皮
	224782, -- 銳利的爪子
	224807, -- 阿爾加剝皮師筆記
	224817, -- 阿爾加草藥師筆記
	224818, -- 阿爾加礦工筆記
	224835, -- 暗叢樹根
	224838, -- 空無裂片
	225220, -- 甲殼針
	225221, -- 網織線捲
	225222, -- 石製皮革樣本
	225223, -- 結實奈幽甲殼
	225224, -- 透明寶石裂片
	225225, -- 深岩碎片
	225226, -- 條紋墨石
	225227, -- 蠟封紀錄
	225228, -- 鏽蝕上鎖機關
	225229, -- 土靈感應線圈
	225230, -- 結晶存放庫
	225231, -- 粉狀火花
	225232, -- 地心通途木條
	225233, -- 緻密刃石
	225234, -- 鍊金原質
	225235, -- 深岩爐缸
	226265, -- 土靈鐵粉
	226266, -- 金屬多恩諾加框
	226267, -- 強化燒杯
	226268, -- 雕刻攪拌棒
	226269, -- 化學家淨化水
	226270, -- 沐聖研缽和搗杵
	226271, -- 奈幽混合鹽
	226272, -- 黑暗藥劑師藥瓶
	226276, -- 遠古土靈鐵砧
	226277, -- 多恩諾加錘子
	226278, -- 鳴響錘虎鉗
	226279, -- 土靈鑿子
	226280, -- 聖焰熔爐
	226281, -- 聖輝鉗
	226282, -- 奈幽工匠組
	226283, -- 小蜘蛛的鋼刷
	226284, -- 打磨過的土靈寶石
	226285, -- 銀色多恩諾加節杖
	226286, -- 裹滿灰的寶珠
	226287, -- 活化附魔塵
	226288, -- 聖火精華
	226289, -- 附魔阿拉希卷軸
	226290, -- 黑暗魔法書
	226291, -- 虛無裂片
	226292, -- 岩石技師扳手
	226293, -- 多恩諾加眼鏡
	226294, -- 惰性採礦炸彈
	226295, -- 土靈傀儡藍圖
	226296, -- 神聖煙火啞彈
	226297, -- 阿拉希安全手套
	226298, -- 人偶機械蜘蛛
	226299, -- 空毒液容器
	226300, -- 遠古之花
	226301, -- 多恩諾加園藝鐮刀
	226302, -- 土靈掘地耙
	226303, -- 蘑菇人切片刀
	226304, -- 阿拉希園藝泥鏟
	226305, -- 阿拉希草藥修剪刀
	226306, -- 蛛網纏繞的蓮花
	226307, -- 掘地工的鏟子
	226308, -- 多恩諾加書記的羽毛筆
	226309, -- 歷史學家蘸水筆
	226310, -- 符能卷軸
	226311, -- 藍色土靈染料
	226312, -- 線人的鋼筆
	226313, -- 書法師的鑿刻筆
	226314, -- 奈幽文字
	226315, -- 怨毒法師墨水瓶
	226316, -- 精細珠寶錘
	226317, -- 土靈寶石鉗
	226318, -- 石雕刀
	226319, -- 珠寶匠精密鑽頭
	226320, -- 阿拉希測量儀
	226321, -- 圖書館員放大鏡
	226322, -- 儀式施法者水晶
	226323, -- 奈幽金工板
	226324, -- 土靈穿繩工具
	226325, -- 多恩諾加工匠扁刀
	226326, -- 地底磨刀石
	226327, -- 土靈鑽孔
	226328, -- 阿拉希削薄刀組
	226329, -- 阿拉希皮革打亮器
	226330, -- 奈幽鞣製木槌
	226331, -- 奈幽剝皮弧形小刀
	226332, -- 土靈礦工錘
	226333, -- 多恩諾加鑿子
	226334, -- 土靈挖掘者鏟子
	226335, -- 再生礦石
	226336, -- 阿拉希精密電鑽
	226337, -- 敬業考古學家挖掘鏟
	226338, -- 重型蜘蛛粉碎者
	226339, -- 奈幽蟲族採礦補給品
	226340, -- 多恩諾加雕刻刀
	226341, -- 土靈工人撐杆
	226342, -- 工匠刨木刀
	226343, -- 蘑菇人濃郁單寧
	226344, -- 阿拉希鞣製劑
	226345, -- 阿拉希工匠輻刨刀
	226346, -- 奈幽鐵製打磨器
	226347, -- 甲殼拋光器
	226348, -- 多恩諾加拆線器
	226349, -- 土靈捲尺
	226350, -- 符化土靈別針
	226351, -- 土靈縫補師剪刀
	226352, -- 阿拉希旋轉切刀
	226353, -- 皇家服飾商的量角器
	226354, -- 奈幽棉被
	226355, -- 奈幽針墊
	227407, -- 模糊鐵匠圖表
	227408, -- 模糊雕銘師符文圖畫
	227409, -- 模糊鍊金師研究
	227410, -- 模糊裁縫師圖表
	227411, -- 模糊附魔師研究
	227412, -- 模糊工程師草稿
	227413, -- 模糊珠寶匠插畫
	227414, -- 模糊製皮師圖表
	227415, -- 模糊草藥師筆記
	227416, -- 模糊礦工筆記
	227417, -- 模糊剝皮師筆記
	227418, -- 卓越鐵匠圖表
	227419, -- 卓越雕銘師符文圖畫
	227420, -- 卓越鍊金師研究
	227421, -- 卓越裁縫師圖表
	227422, -- 卓越附魔師研究
	227423, -- 卓越工程師草稿
	227424, -- 卓越珠寶匠插畫
	227425, -- 卓越製皮師圖表
	227426, -- 卓越草藥師筆記
	227427, -- 卓越礦工筆記
	227428, -- 卓越剝皮師筆記
	227429, -- 原始鐵匠圖表
	227430, -- 原始雕銘師符文圖畫
	227431, -- 原始鍊金師研究
	227432, -- 原始裁縫師圖表
	227433, -- 原始附魔師研究
	227434, -- 原始工程師草稿
	227435, -- 原始珠寶匠插畫
	227436, -- 原始製皮師圖表
	227437, -- 原始草藥師筆記
	227438, -- 原始礦工筆記
	227439, -- 原始剝皮師筆記
	227659, -- 迅捷秘法化身
	227661, -- 發光的大地水晶
	227662, -- 閃亮粉塵
	227667, -- 阿爾加附魔師對開本
	228724, -- 鍊金術知識的閃爍
	228725, -- 鍊金術知識的微光
	228726, -- 鍛造知識的閃爍
	228727, -- 鍛造知識的微光
	228728, -- 附魔知識的閃爍
	228729, -- 附魔知識的微光
	228730, -- 工程學知識的閃爍
	228731, -- 工程學知識的微光
	228732, -- 銘文學知識的閃爍
	228733, -- 銘文學知識的微光
	228734, -- 珠寶設計知識的閃爍
	228735, -- 珠寶設計知識的微光
	228736, -- 製皮知識的閃爍
	228737, -- 製皮知識的微光
	228738, -- 裁縫知識的閃爍
	228739, -- 裁縫知識的微光
	228773, -- 阿爾加鍊金師筆記本
	228774, -- 阿爾加鐵匠日誌
	228775, -- 阿爾加工程師記事本
	228776, -- 阿爾加雕銘師日誌
	228777, -- 阿爾加珠寶設計師筆記本
	228778, -- 阿爾加製皮師日誌
	228779, -- 阿爾加裁縫師筆記本
}

local mopRemix = {
	211279, -- 恆龍寶箱
	217722, -- 經驗之絲
	219264, -- 經驗時光絲線
	219273, -- 永恆經驗之絲
	219282, -- 無限經驗之絲
	223904, -- 非同步的榫輪寶石
	223905, -- 非同步的變換寶石
	223906, -- 非同步的技工寶石
	223907, -- 非同步稜彩寶石
	223908, -- 小型青銅寶箱
	223909, -- 次級青銅寶箱
	223910, -- 青銅寶箱
	223911, -- 大型青銅寶箱
	226142, -- 大型永恆絲線捲
	226143, -- 永恆絲線捲
	226144, -- 次級永恆絲線捲
	226145, -- 小型永恆絲線捲
}

local bigDig = {
	205223, -- 裝飾半人馬斧頭
	211414, -- 繁花夢珍寶
	212650, -- 刺青墨水罐
	212687, -- 簡陋的玩具小鴨
	212762, -- 黯淡的犄角璽戒
	212769, -- 殘破的懸賞告示
	212773, -- 生鏽墜盒
	212976, -- 龍獸鴨子雕刻
	212977, -- 龍獸標示牌
	212978, -- 飛龍畫家的調色盤
	213020, -- 古老的龍獸鏟子
	213021, -- 附軟木塞的龍獸瓶子
	213022, -- 龍獸鐵匠之錘
	213023, -- 有油漬的加拉登火炬
	213024, -- 染血的加拉登杯子
	213025, -- 古老的加拉登布卷
	213175, -- 布滿灰塵的加拉登典籍
	213176, -- 保存良好的群島典籍
	213177, -- 完好無缺的典籍
	213183, -- 粗製串珠手鐲
	213185, -- 布滿灰塵的半人馬典籍
	213186, -- 布滿灰塵的鼴鼠人典籍
	213187, -- 布滿灰塵的龍獸典籍
	213188, -- 布滿灰塵的半龍人典籍
	213189, -- 保存良好的龍族典籍
	213190, -- 保存良好的群島典籍
	213192, -- 劃掉的名單
	213200, -- 占星書
	213204, -- 紅寶石墜盒
	213208, -- 一鍋醃漬鯷魚
	213215, -- 雕刻的許願石
	213357, -- 水晶占卜碗
	213359, -- 斷裂的龍獸法杖
	213365, -- 雕刻洞穴水晶
	213375, -- 埋起來的寶物袋
	213382, -- 部分的半人馬狩獵地圖
	213389, -- 遠古半人馬日記
	213429, -- 周密的文物管理員附錄
}

local delveItem = {
	-- 11.0
	218129, -- 陶瓷箭頭塑像
	225897, -- 蠻橫之力塑像
	225898, -- 大地之母塑像
	225899, -- 不滅的鋼鐵塑像
	225900, -- 聖光之觸塑像
	225901, -- 流線降阻聖物
	225902, -- 最終意志塑像
	225903, -- 無定形聖物
	225904, -- 時光佚失聖物
	225905, -- 往昔追尋者聖物
	225906, -- 寂滅死靈聖物
	225907, -- 感知聖物
	225908, -- 澤克維爾的遺血
	227784, -- 探究者的獎賞
	228582, -- 流線降阻聖物
	228984, -- 不滅的鋼鐵塑像
	229353, -- 盛怒塑像
	-- 11.1
	230225, -- 卡迦可樂搬運器
	230226, -- 三度生物列印機
	230227, -- 哥布林磁力彈跳榴彈
	230228, -- 口袋工廠
	230229, -- 衝擊轉化矩陣
	230230, -- 戰利品RAID-R
	230231, -- 逆向工程的哥布林死亡炸彈
	230232, -- 大到誇張的磁鐵
	230233, -- 生物燃料火箭裝備
	230234, -- 作響的增強碎片
	230950, -- 超載水晶塔
	233071, -- 探究者的獎賞
	233205, -- 活力果汁
	233792, -- 探究者偽裝
	234013, -- 反戰機
	234014, -- 足球炸彈自動發射器
	234015, -- 機甲龍簡便維護套組
}

local seeds = {
	-- from MerathilisUI
	208047, -- 大型夢境種子
	208066, -- 小型夢境種子
	208067, -- 沉重的夢境種子
	211947, -- 豐收之種補給
	214561, -- 翠綠種子
	214605, -- 結晶翠綠種子
}

local holidayRewards = {
	116762, -- 失竊的禮物
	117392, -- 塞滿戰利品的南瓜
	117393, -- 桶型寶箱
	117394, -- 冰寒寶物袋
	147907, -- 心型紙箱
	149503, -- 失竊的禮物
	149574, -- 塞滿戰利品的南瓜
	17726, -- 燻木牧場特殊禮物
	209024, --  塞滿戰利品的南瓜
	216874, -- 塞滿戰利品的籃子
	21746, -- 幸運紅包袋
	223619, -- 青銅龍慶典好物包
	223620, -- 20週年慶儲物箱
	223621, -- 20週年慶儲物箱
	226101, -- 克羅米的旅行好物包
	226102, -- 克羅米的旅行好物包
	229355, -- 克羅米的優質好物包
	229359, -- 克羅米的好物包
	232598, -- 一袋時光扭曲徽章
	232877, -- 時光好物包
	233014, -- 青銅龍慶典藏寶箱
	235505, -- 一袋時光扭曲徽章
	54536, -- 冰寒寶物袋
	54537, -- 心型盒
}

local function createList(base, ...)
	local list = {}
	for _, key in pairs({ ... }) do
		local items = base[key]
		for _, item in pairs(items) do
			list[item] = true
		end
	end
	local sorted = {}
	for item in pairs(list) do
		tinsert(sorted, item)
	end
	sort(sorted)
	return sorted
end

EB.moduleList = {
	["POTION"] = createList(potions, "general", "legacy", "sl", "df", "tww"),
	["POTIONSL"] = createList(potions, "general", "sl"),
	["POTIONDF"] = createList(potions, "general", "df"),
	["POTIONTWW"] = createList(potions, "general", "tww"),
	["FLASK"] = createList(flasks, "legacy", "sl", "df", "tww"),
	["FLASKSL"] = createList(flasks, "sl"),
	["FLASKDF"] = createList(flasks, "df"),
	["FLASKTWW"] = createList(flasks, "tww"),
	["RUNE"] = createList(runes, "df", "tww"),
	["RUNEDF"] = createList(runes, "df"),
	["RUNETWW"] = createList(runes, "tww"),
	["VANTUS"] = createList(vantus, "df", "tww"),
	["VANTUSTWW"] = createList(vantus, "tww"),
	["FOOD"] = createList(foods, "crafted_sl", "crafted_df", "crafted_tww"),
	["FOODSL"] = createList(foods, "crafted_sl"),
	["FOODDF"] = createList(foods, "crafted_df"),
	["FOODTWW"] = createList(foods, "crafted_tww"),
	["FOODVENDOR"] = createList(foods, "vendor"),
	["MAGEFOOD"] = createList(foods, "mage"),
	["FISHING"] = createList(fishings, "general", "tww"),
	["FISHINGTWW"] = createList(fishings, "tww"),
	["BANNER"] = banners,
	["UTILITY"] = utilities,
	["OPENABLE"] = openableItems,
	["PROF"] = professionItems,
	["SEEDS"] = seeds,
	["BIGDIG"] = bigDig,
	["MOPREMIX"] = mopRemix,
	["DELVE"] = delveItem,
	["HOLIDAY"] = holidayRewards,
}
