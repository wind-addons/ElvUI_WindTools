local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local M = W.Modules.Misc ---@class Misc

local pairs = pairs
local MuteSoundFile = MuteSoundFile
local UnmuteSoundFile = UnmuteSoundFile

local MountSE = {
	[63796] = {
		-- 彌米倫之首
		568252, -- spells/summongyrocopter.ogg
		595100, -- creature/mimironheadmount/mimironheadmount_walk.ogg
		555364, -- creature/mimironheadmount/mimironheadmount_run.ogg
		595103, -- creature/mimironheadmount/mimironheadmount_jumpstart.ogg
		595097, -- creature/mimironheadmount/mimironheadmount_jumpend.ogg
	},
	[229385] = {
		-- 班盧，宗師良伴
		1593212, -- creature/ban-lu/vo_72_ban-lu_01_m.ogg
		1593213, -- creature/ban-lu/vo_72_ban-lu_02_m.ogg
		1593214, -- creature/ban-lu/vo_72_ban-lu_03_m.ogg
		1593215, -- creature/ban-lu/vo_72_ban-lu_04_m.ogg
		1593216, -- creature/ban-lu/vo_72_ban-lu_05_m.ogg
		1593217, -- creature/ban-lu/vo_72_ban-lu_06_m.ogg
		1593218, -- creature/ban-lu/vo_72_ban-lu_07_m.ogg
		1593219, -- creature/ban-lu/vo_72_ban-lu_08_m.ogg
		1593220, -- creature/ban-lu/vo_72_ban-lu_09_m.ogg
		1593221, -- creature/ban-lu/vo_72_ban-lu_10_m.ogg
		1593222, -- creature/ban-lu/vo_72_ban-lu_11_m.ogg
		1593223, -- creature/ban-lu/vo_72_ban-lu_12_m.ogg
		1593224, -- creature/ban-lu/vo_72_ban-lu_13_m.ogg
		1593225, -- creature/ban-lu/vo_72_ban-lu_14_m.ogg
		1593226, -- creature/ban-lu/vo_72_ban-lu_15_m.ogg
		1593227, -- creature/ban-lu/vo_72_ban-lu_16_m.ogg
		1593228, -- creature/ban-lu/vo_72_ban-lu_17_m.ogg
		1593229, -- creature/ban-lu/vo_72_ban-lu_18_m.ogg
		1593230, -- creature/ban-lu/vo_72_ban-lu_19_m.ogg
		1593231, -- creature/ban-lu/vo_72_ban-lu_20_m.ogg
		1593232, -- creature/ban-lu/vo_72_ban-lu_21_m.ogg
		1593233, -- creature/ban-lu/vo_72_ban-lu_22_m.ogg
		1593234, -- creature/ban-lu/vo_72_ban-lu_23_m.ogg
		1593235, -- creature/ban-lu/vo_72_ban-lu_24_m.ogg
		1593236, -- creature/ban-lu/vo_72_ban-lu_25_m.ogg
	},
	[339588] = {
		-- 罪奔者布蘭契
		3587276, -- Part of SoundKit(s): 157142, 160875, 166787, 167500, 167947, 172866
	},
	[312762] = {
		-- 淵誓獵魂犬
		3745490, -- sound/creature/talethi's_target/mon_talethi's_target_fidget01_01_168902.ogg
		3745492, -- sound/creature/talethi's_target/mon_talethi's_target_fidget01_02_168902.ogg
		3745494, -- sound/creature/talethi's_target/mon_talethi's_target_fidget01_03_168902.ogg
		3745496, -- sound/creature/talethi's_target/mon_talethi's_target_fidget01_04_168902.ogg
		3745498, -- sound/creature/talethi's_target/mon_talethi's_target_fidget01_05_168902.ogg
		3745500, -- sound/creature/talethi's_target/mon_talethi's_target_fidget01_06_168902.ogg
		3745502, -- sound/creature/talethi's_target/mon_talethi's_target_fidget01_07_168902.ogg
		3745504, -- sound/creature/talethi's_target/mon_talethi's_target_fidget01_08_168902.ogg
		3745506, -- sound/creature/talethi's_target/mon_talethi's_target_fidget01_09_168902.ogg
		3745508, -- sound/creature/talethi's_target/mon_talethi's_target_fidget01_10_168902.ogg
		3745510, -- sound/creature/talethi's_target/mon_talethi's_target_fidget01_11_168902.ogg
		3745512, -- sound/creature/talethi's_target/mon_talethi's_target_fidget01_12_168902.ogg
		3745514, -- sound/creature/talethi's_target/mon_talethi's_target_fidget01_13_168902.ogg
		3745516, -- sound/creature/talethi's_target/mon_talethi's_target_fidget01_14_168902.ogg
		3745518, -- sound/creature/talethi's_target/mon_talethi's_target_fidget01_15_168902.ogg
		3745520, -- sound/creature/talethi's_target/mon_talethi's_target_fidget01_16_168902.ogg
		3745566, -- sound/creature/talethi's_target/mon_talethi's_target_fidget02_01_168903.ogg
	},
}

local OtherSE = {
	["Tortollan"] = {
		-- 托爾托人
		1979406, -- sound/creature/tortollan_female/vo_801_tortollan_female_01_f.ogg
		1979407, -- sound/creature/tortollan_female/vo_801_tortollan_female_02_f.ogg
		1979408, -- sound/creature/tortollan_female/vo_801_tortollan_female_03_f.ogg
		1979409, -- sound/creature/tortollan_female/vo_801_tortollan_female_04_f.ogg
		1979410, -- sound/creature/tortollan_female/vo_801_tortollan_female_05_f.ogg
		1979411, -- sound/creature/tortollan_female/vo_801_tortollan_female_06_f.ogg
		1979412, -- sound/creature/tortollan_female/vo_801_tortollan_female_07_f.ogg
		1979413, -- sound/creature/tortollan_female/vo_801_tortollan_female_08_f.ogg
		1979414, -- sound/creature/tortollan_female/vo_801_tortollan_female_09_f.ogg
		1979415, -- sound/creature/tortollan_female/vo_801_tortollan_female_10_f.ogg
		1979416, -- sound/creature/tortollan_female/vo_801_tortollan_female_11_f.ogg
		1979439, -- sound/creature/tortollan_male_child/vo_801_tortollan_male_child_01_m.ogg
		1979440, -- sound/creature/tortollan_male_child/vo_801_tortollan_male_child_02_m.ogg
		1979441, -- sound/creature/tortollan_male_child/vo_801_tortollan_male_child_03_m.ogg
		1979442, -- sound/creature/tortollan_male_child/vo_801_tortollan_male_child_04_m.ogg
		1979443, -- sound/creature/tortollan_male_child/vo_801_tortollan_male_child_05_m.ogg
		1979444, -- sound/creature/tortollan_male_child/vo_801_tortollan_male_child_06_m.ogg
		1979445, -- sound/creature/tortollan_male_child/vo_801_tortollan_male_child_07_m.ogg
		1979446, -- sound/creature/tortollan_male_child/vo_801_tortollan_male_child_08_m.ogg
		1979447, -- sound/creature/tortollan_male_child/vo_801_tortollan_male_child_09_m.ogg
		1998109, -- sound/creature/tortollan_male/vo_801_tortollan_male_01_m.ogg
		1998110, -- sound/creature/tortollan_male/vo_801_tortollan_male_02_m.ogg
		1998111, -- sound/creature/tortollan_male/vo_801_tortollan_male_03_m.ogg
		1998112, -- sound/creature/tortollan_male/vo_801_tortollan_male_04_m.ogg
		1998113, -- sound/creature/tortollan_male/vo_801_tortollan_male_05_m.ogg
		1998114, -- sound/creature/tortollan_male/vo_801_tortollan_male_06_m.ogg
		1998115, -- sound/creature/tortollan_male/vo_801_tortollan_male_07_m.ogg
		1998116, -- sound/creature/tortollan_male/vo_801_tortollan_male_08_m.ogg
		1998117, -- sound/creature/tortollan_male/vo_801_tortollan_male_09_m.ogg
		1998118, -- sound/creature/tortollan_male/vo_801_tortollan_male_10_m.ogg
		1998119, -- sound/creature/tortollan_male/vo_801_tortollan_male_11_m.ogg
		1998120, -- sound/creature/tortollan_male/vo_801_tortollan_male_12_m.ogg
		1998121, -- sound/creature/tortollan_male/vo_801_tortollan_male_13_m.ogg
		1998122, -- sound/creature/tortollan_male/vo_801_tortollan_male_14_m.ogg
	},
	["Smolderheart"] = {
		-- Smolderheart
		-- https://www.wowhead.com/item=180873/smolderheart
		-- Extra sound IDs from the below NGA thread
		-- https://nga.178.com/read.php?tid=12142815&_ff=274&page=187#pid662027861Anchor
		2066602, -- sound/spells/fx_fire_magic_loop_smoldering_a_01.ogg
		2066603, -- sound/spells/fx_fire_magic_loop_smoldering_a_02.ogg
		2066604, -- sound/spells/fx_fire_magic_loop_smoldering_b_01.ogg
		2066605, -- sound/spells/fx_fire_magic_loop_smoldering_b_02.ogg
		568250,
		568631,
		568803,
		567970,
		568904,
	},
	["Elegy of the Eternals"] = {
		-- Elegy of the Eternals
		-- https://www.wowhead.com/item=188270/elegy-of-the-eternals
		539295, -- sound/character/bloodelf/bloodelffemalecry01.ogg
	},
	["Crying"] = {
		539295, -- sound/character/bloodelf/bloodelffemalecry01.ogg
		539355, -- sound/character/bloodelf/bloodelfmalecry01.ogg
		539609, -- sound/character/draenei/draeneimalecry01.ogg
		539674, -- sound/character/draenei/draeneifemalecry01.ogg
		539792, -- sound/character/dwarf/dwarffemale/dwarffemalecry01.ogg
		539875, -- sound/character/dwarf/dwarfmale/dwarfmalecry01.ogg
		540264, -- sound/character/gnome/gnomemalecry01.ogg
		540273, -- sound/character/gnome/gnomefemalecry01.ogg
		540533, -- sound/character/human/female/humanfemalecry01.ogg
		540736, -- sound/character/human/male/humanmalecry01.ogg
		540873, -- sound/character/nightelf/nightelffemale/nightelffemalecry01.ogg
		540957, -- sound/character/nightelf/nightelfmale/nightelfmalecry01.ogg
		541149, -- sound/character/orc/female/orcfemalecry01.ogg
		541240, -- sound/character/orc/orcmale/orcmalecry01.ogg
		541450, -- sound/character/pcgilneanfemale/vo_pcgilneanfemale_cry03.ogg
		541473, -- sound/character/pcgilneanfemale/vo_pcgilneanfemale_cry01.ogg
		541525, -- sound/character/pcgilneanfemale/vo_pcgilneanfemale_cry02.ogg
		541706, -- sound/character/pcgilneanmale/vo_pcgilneanmale_cry01.ogg
		541796, -- sound/character/pcgoblinfemale/vo_pcgoblinfemale_cry02.ogg
		541817, -- sound/character/pcgoblinfemale/vo_pcgoblinfemale_cry01.ogg
		541915, -- sound/character/pcgoblinmale/vo_pcgoblinmale_cry01.ogg
		541954, -- sound/character/pcgoblinmale/vo_pcgoblinmale_cry02.ogg
		542003, -- sound/character/pcgoblinmale/vo_pcgoblinmale_cry03.ogg
		542078, -- sound/character/pcworgenfemale/vo_pcworgenfemale_cry01.ogg
		542258, -- sound/character/pcworgenmale/vo_pcworgenmale_cry01.ogg
		542519, -- sound/character/scourge/scourgefemale/undeadfemalecry01.ogg
		542601, -- sound/character/scourge/scourgemale/undeadmalecry01.ogg
		542815, -- sound/character/tauren/female/taurenfemalecry01.ogg
		542887, -- sound/character/tauren/taurenmale/taurenmalecry01.ogg
		543084, -- sound/character/troll/trollfemalecry01.ogg
		630076, -- sound/character/pcpandarenmale/vo_pcpandarenmale_cry02.ogg
		630078, -- sound/character/pcpandarenmale/vo_pcpandarenmale_cry03.ogg
		636425, -- sound/character/pcpandarenfemale/vo_pcpandarenfemale_cry02.ogg
		636427, -- sound/character/pcpandarenfemale/vo_pcpandarenfemale_cry03.ogg
	},
	["Dragon"] = {
		-- from https://wago.io/SDhHuZh3f
		540108,
		540119,
		540182,
		540188,
		540197,
		540211,
		540213,
		540218,
		540221,
		540243,
		547436,
		547714,
		547715,
		547716,
		597932,
		597968,
		597986,
		597989,
		597998,
		598004,
		598010,
		598016,
		598028,
		803545,
		803547,
		803549,
		803551,
		1489052,
		1489053,
		1563054,
		1563055,
		1563058,
		3014246,
		3014247,
		4337227,
		4543973,
		4543977,
		4543979,
		4550997,
		4550999,
		4551001,
		4551003,
		4551005,
		4551007,
		4551009,
		4551011,
		4551013,
		4551015,
		4551017,
		4627086,
		4627088,
		4627090,
		4627092,
		4633292,
		4633294,
		4633296,
		4633298,
		4633300,
		4633302,
		4633304,
		4633306,
		4633308,
		4633310,
		4633312,
		4633314,
		4633338,
		4633340,
		4633342,
		4633344,
		4633346,
		4633348,
		4633350,
		4633354,
		4633356,
		4633370,
		4633372,
		4633374,
		4633376,
		4633378,
		4633382,
		4633392,
		4634009,
		4634011,
		4634013,
		4634015,
		4634017,
		4634019,
		4634021,
		4634908,
		4634910,
		4634912,
		4634914,
		4634916,
		4634924,
		4634926,
		4634928,
		4634930,
		4634932,
		4634942,
		4634944,
		4634946,
		4663454,
		4663456,
		4663458,
		4663460,
		4663462,
		4663464,
		4663466,
		4674593,
		4674595,
		4674599,
		12694571,
		12694572,
		12694573,
		1321216,
		1321217,
		1321218,
		1321219,
		1321220,
		1467222,
	},
	["Jewelcrafting"] = {
		569325,
	},
}

function M:Mute()
	for mountID, soundIDs in pairs(MountSE) do
		if E.private.WT.misc.mute.enable and E.private.WT.misc.mute.mount[mountID] then
			for _, soundID in pairs(soundIDs) do
				MuteSoundFile(soundID)
			end
		else
			for _, soundID in pairs(soundIDs) do
				UnmuteSoundFile(soundID)
			end
		end
	end

	for cat, soundIDs in pairs(OtherSE) do
		if E.private.WT.misc.mute.enable and E.private.WT.misc.mute.other[cat] then
			for _, soundID in pairs(soundIDs) do
				MuteSoundFile(soundID)
			end
		else
			for _, soundID in pairs(soundIDs) do
				UnmuteSoundFile(soundID)
			end
		end
	end
end

M:AddCallback("Mute")
