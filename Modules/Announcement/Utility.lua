local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local A = W:GetModule("Announcement") ---@class Announcement
local async = W.Utilities.Async

local format = format
local gsub = gsub
local tostring = tostring

local C_Spell_GetSpellLink = C_Spell.GetSpellLink

local function FormatMessage(message, spellID)
	message = gsub(message, "%%player%%", E.name)
	message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(spellID))
	return message
end

local UtilityType = {
	Spell = "spell",
	Feast = "feast",
	Portal = "portal",
	Toy = "toy",
	Bot = "bot",
}

local UtilitySpells = {
	[116670] = UtilityType.Spell, -- 活血术

	[698] = UtilityType.Spell, -- 召唤仪式
	[29893] = UtilityType.Spell, -- 制造灵魂之井
	[190336] = UtilityType.Spell, -- 造餐术

	[49844] = UtilityType.Toy, -- 使用烈酒的遥控器
	[61031] = UtilityType.Toy, -- 玩具火车
	[195782] = UtilityType.Toy, -- 召唤月羽雕像
	[261602] = UtilityType.Toy, -- 印哨
	[290154] = UtilityType.Toy, -- 虚灵幻变者
	[376664] = UtilityType.Toy, -- 欧胡纳栖枝
	[384911] = UtilityType.Toy, -- 原子重校器

	[104958] = UtilityType.Feast, -- 熊猫人大餐
	[126492] = UtilityType.Feast, -- 烧烤大餐
	[126494] = UtilityType.Feast, -- 烧烤盛宴
	[126495] = UtilityType.Feast, -- 烹炒大餐
	[126496] = UtilityType.Feast, -- 烹炒盛宴
	[126497] = UtilityType.Feast, -- 炖煮大餐
	[126498] = UtilityType.Feast, -- 炖煮盛宴
	[126499] = UtilityType.Feast, -- 蒸烧大餐
	[126500] = UtilityType.Feast, -- 蒸烧盛宴
	[126501] = UtilityType.Feast, -- 烘焙大餐
	[126502] = UtilityType.Feast, -- 烘焙盛宴
	[126503] = UtilityType.Feast, -- 酿造大餐
	[126504] = UtilityType.Feast, -- 酿造盛宴
	[145166] = UtilityType.Feast, -- 汤面餐车
	[145169] = UtilityType.Feast, -- 什锦汤面餐车
	[145196] = UtilityType.Feast, -- 熊猫人八宝汤面餐车
	[188036] = UtilityType.Feast, -- 灵魂药锅
	[201351] = UtilityType.Feast, -- 丰盛大餐
	[201352] = UtilityType.Feast, -- 苏拉玛奢华大餐
	[259409] = UtilityType.Feast, -- 海帆盛宴
	[259410] = UtilityType.Feast, -- 船长盛宴佳肴
	[276972] = UtilityType.Feast, -- 秘法药锅
	[286050] = UtilityType.Feast, -- 鲜血大餐
	[297048] = UtilityType.Feast, -- “饿了没”点心桌
	[298861] = UtilityType.Feast, -- 强效秘法药锅
	[307157] = UtilityType.Feast, -- 永恒药锅
	[308458] = UtilityType.Feast, -- 惊异怡人大餐
	[308462] = UtilityType.Feast, -- 纵情饕餮盛宴
	[359335] = UtilityType.Feast, -- 建造窗口：石头汤大锅
	[382423] = UtilityType.Feast, -- 育莎的丰盛炖煮
	[382427] = UtilityType.Feast, -- 卡鲁亚克盛宴
	[383063] = UtilityType.Feast, -- 准备不断壮大的飞龙美味珍肴
	[432876] = UtilityType.Feast, -- 黑血之球
	[432877] = UtilityType.Feast, -- 准备阿加合剂大锅
	[432878] = UtilityType.Feast, -- 准备阿加合剂大锅
	[432879] = UtilityType.Feast, -- 准备阿加合剂大锅
	[433292] = UtilityType.Feast, -- 准备阿加药水大锅
	[433293] = UtilityType.Feast, -- 准备阿加药水大锅
	[433294] = UtilityType.Feast, -- 准备阿加药水大锅
	[455960] = UtilityType.Feast, -- 全味炖煮
	[457283] = UtilityType.Feast, -- 降圣白昼盛宴
	[457285] = UtilityType.Feast, -- 午夜舞会盛宴
	[457302] = UtilityType.Feast, -- 特色寿司
	[457487] = UtilityType.Feast, -- 丰盛的全味炖煮
	[462211] = UtilityType.Feast, -- 丰盛的特色寿司
	[462212] = UtilityType.Feast, -- 丰盛的降圣白昼盛宴
	[462213] = UtilityType.Feast, -- 丰盛的午夜舞会盛宴

	-- * Alliance
	[10059] = UtilityType.Portal, -- 传送门：暴风城
	[11416] = UtilityType.Portal, -- 传送门：铁炉堡
	[11419] = UtilityType.Portal, -- 传送门：达纳苏斯
	[32266] = UtilityType.Portal, -- 传送门：埃索达
	[33691] = UtilityType.Portal, -- 传送门：沙塔斯
	[49360] = UtilityType.Portal, -- 传送门：塞拉摩
	[88345] = UtilityType.Portal, -- 传送门：托尔巴拉德
	[132620] = UtilityType.Portal, -- 传送门：锦绣谷
	[176246] = UtilityType.Portal, -- 传送门：暴风之盾
	[281400] = UtilityType.Portal, -- 传送门：伯拉勒斯

	-- * Horde
	[11417] = UtilityType.Portal, -- 传送门：奥格瑞玛
	[11418] = UtilityType.Portal, -- 传送门：幽暗城
	[11420] = UtilityType.Portal, -- 传送门：雷霆崖
	[32267] = UtilityType.Portal, -- 传送门：银月城（燃烧的远征）
	[35717] = UtilityType.Portal, -- 传送门：沙塔斯
	[49361] = UtilityType.Portal, -- 传送门：斯通纳德
	[88346] = UtilityType.Portal, -- 传送门：托尔巴拉德
	[132626] = UtilityType.Portal, -- 传送门：锦绣谷
	[176244] = UtilityType.Portal, -- 传送门：战争之矛
	[281402] = UtilityType.Portal, -- 传送门：达萨罗

	-- Neutral
	[53142] = UtilityType.Portal, -- 传送门：达拉然 - 诺森德
	[120146] = UtilityType.Portal, -- 远古传送门：达拉然
	[224871] = UtilityType.Portal, -- 传送门：达拉然 - 破碎群岛
	[344597] = UtilityType.Portal, -- 传送门：奥利波斯
	[395289] = UtilityType.Portal, -- 传送门：瓦德拉肯
	[446534] = UtilityType.Portal, -- 传送门：多恩诺嘉尔

	[22700] = UtilityType.Bot, -- 修理机器人74A型
	[44389] = UtilityType.Bot, -- 战地修理机器人110G
	[54711] = UtilityType.Bot, -- 废物贩卖机器人
	[67826] = UtilityType.Bot, -- 基维斯
	[126459] = UtilityType.Bot, -- 布林顿4000
	[157066] = UtilityType.Bot, -- 沃尔特
	[161414] = UtilityType.Bot, -- 布林顿5000
	[199109] = UtilityType.Bot, -- 自动铁锤
	[200061] = UtilityType.Bot, -- 召唤里弗斯
	[200204] = UtilityType.Bot, -- 自动铁锤模式
	[200205] = UtilityType.Bot, -- 自动铁锤模式
	[200210] = UtilityType.Bot, -- 故障检测模式
	[200211] = UtilityType.Bot, -- 故障检测模式
	[200212] = UtilityType.Bot, -- 烟火表演模式
	[200214] = UtilityType.Bot, -- 烟火表演模式
	[200215] = UtilityType.Bot, -- 零食发放模式
	[200216] = UtilityType.Bot, -- 零食发放模式
	[200217] = UtilityType.Bot, -- 华丽模式
	[200218] = UtilityType.Bot, -- 华丽模式
	[200219] = UtilityType.Bot, -- 驾驶战斗模式
	[200220] = UtilityType.Bot, -- 驾驶战斗模式
	[200221] = UtilityType.Bot, -- 虫洞发生器模式
	[200222] = UtilityType.Bot, -- 虫洞发生器模式
	[200223] = UtilityType.Bot, -- 热砧模式
	[200225] = UtilityType.Bot, -- 热砧模式
	[226241] = UtilityType.Bot, -- 宁神圣典
	[256230] = UtilityType.Bot, -- 静心圣典
	[298926] = UtilityType.Bot, -- 布林顿7000
	[324029] = UtilityType.Bot, -- 宁心圣典
	[453942] = UtilityType.Bot, -- 阿加修理机器人11O
}

A.ConfigurableUtilitySpells = {}

function A:GetAvailableUtilitySpells()
	async.WithSpellIDTable(UtilitySpells, "key", function(spell)
		local id, tex, name = spell:GetSpellID(), spell:GetSpellTexture(), spell:GetSpellName()
		local desc = format("%s %s (%s)", F.GetTextureString(tostring(tex), 16, 13, true), name, id)
		self.ConfigurableUtilitySpells[tostring(id)] = desc
	end)

	F.Developer.DevTool(A.ConfigurableUtilitySpells, "Announcement Utility Spells")
end

function A:Utility(spellID)
	if not self.db or not self.db.utility or not UtilitySpells[spellID] then
		return
	end

	local db = self.db.utility
	local config = db.custom[tostring(spellID)] or db.general[UtilitySpells[spellID]]

	if not config or not config.enable then
		return
	end

	self:SendMessage(FormatMessage(config.text, spellID), self:GetChannel(db.channel), config.raidWarning)
end
