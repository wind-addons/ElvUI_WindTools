local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local A = W:GetModule("Announcement")

local gsub = gsub
local tostring = tostring

local InCombatLockdown = InCombatLockdown

local C_Spell_GetSpellLink = C_Spell.GetSpellLink

local BotList = {
	[22700] = true, -- 修理機器人74A型
	[44389] = true, -- 修理機器人110G型
	[54711] = true, -- 廢料機器人
	[67826] = true, -- 吉福斯
	[126459] = true, -- 布靈登4000型
	[157066] = true, -- 沃特
	[161414] = true, -- 布靈登5000型
	[199109] = true, -- 自動鐵錘
	[200061] = true, -- 召喚劫福斯
	[200204] = true, -- 自動鐵錘模式
	[200205] = true, -- 自動鐵錘模式
	[200210] = true, -- 滅團偵測水晶塔
	[200211] = true, -- 滅團偵測水晶塔
	[200212] = true, -- 煙火展示模式
	[200214] = true, -- 煙火展示模式
	[200215] = true, -- 點心發送模式
	[200216] = true, -- 點心發送模式
	[200217] = true, -- 閃亮模式
	[200218] = true, -- 閃亮模式
	[200219] = true, -- 機甲戰鬥模式
	[200220] = true, -- 機甲戰鬥模式
	[200221] = true, -- 蟲洞生成模式
	[200222] = true, -- 蟲洞生成模式
	[200223] = true, -- 熱能鐵砧模式
	[200225] = true, -- 熱能鐵砧模式
	[226241] = true, -- 靜心寶典
	[256230] = true, -- 寧神寶典
	[298926] = true, -- 布靈登7000型
	[324029] = true, -- 寧心寶典
	[453942] = true, -- 阿爾加修理機器人11O
}

local FeastList = {
	[104958] = true, -- 熊貓人盛宴
	[126492] = true, -- 燒烤盛宴
	[126494] = true, -- 豪華燒烤盛宴
	[126495] = true, -- 快炒盛宴
	[126496] = true, -- 豪華快炒盛宴
	[126497] = true, -- 燉煮盛宴
	[126498] = true, -- 豪華燉煮盛宴
	[126499] = true, -- 蒸煮盛宴
	[126500] = true, -- 豪華蒸煮盛宴
	[126501] = true, -- 烘烤盛宴
	[126502] = true, -- 豪華烘烤盛宴
	[126503] = true, -- 美酒盛宴
	[126504] = true, -- 豪華美酒盛宴
	[145166] = true, -- 拉麵推車
	[145169] = true, -- 豪華拉麵推車
	[145196] = true, -- 熊貓人國寶級拉麵推車
	[188036] = true, -- 靈魂大鍋
	[201351] = true, -- 澎湃盛宴
	[201352] = true, -- 蘇拉瑪爾豪宴
	[259409] = true, -- 艦上盛宴
	[259410] = true, -- 豐盛的船長饗宴
	[276972] = true, -- 神秘大鍋
	[286050] = true, -- 血潤盛宴
	[297048] = true, -- 超澎湃饗宴
	[298861] = true, -- 強效神秘大鍋
	[307157] = true, -- 永恆大鍋
	[308458] = true, -- 意外可口盛宴
	[308462] = true, -- 暴食享樂盛宴
	[382423] = true, -- 雨莎的澎湃燉肉
	[382427] = true, -- 卡魯耶克的豪華盛宴
	[383063] = true, -- 製作加料龍族佳餚大餐
	[455960] = true, -- 大雜燴
	[457283] = true, -- 神聖日盛宴
	[457285] = true, -- 午夜化妝舞會盛宴
	[457302] = true, -- 特級壽司
	[457487] = true, -- 澎湃大雜燴
	[462211] = true, -- 澎湃特級壽司
	[462212] = true, -- 澎湃神聖日盛宴
	[462213] = true, -- 澎湃午夜化妝舞會盛宴
}

local FeastList_SPELLCAST_SUCCEEDED = {
	[359336] = true, -- 準備石頭湯之壺
	[432877] = true, -- 準備阿爾加精煉藥劑大鍋
	[432878] = true, -- 準備阿爾加精煉藥劑大鍋
	[432879] = true, -- 準備阿爾加精煉藥劑大鍋
	[433292] = true, -- 準備阿爾加藥水大鍋
	[433293] = true, -- 準備阿爾加藥水大鍋
	[433294] = true, -- 準備阿爾加藥水大鍋
}

local PortalList = {
	-- 聯盟
	[10059] = true, -- 傳送門：暴風城
	[11416] = true, -- 傳送門：鐵爐堡
	[11419] = true, -- 傳送門：達納蘇斯
	[32266] = true, -- 傳送門：艾克索達
	[33691] = true, -- 傳送門：撒塔斯
	[49360] = true, -- 傳送門：塞拉摩
	[88345] = true, -- 傳送門：托巴拉德
	[132620] = true, -- 傳送門：恆春谷
	[176246] = true, -- 傳送門：暴風之盾
	[281400] = true, -- 傳送門：波拉勒斯
	-- 部落
	[11417] = true, -- 傳送門：奧格瑪
	[11418] = true, -- 傳送門：幽暗城
	[11420] = true, -- 傳送門：雷霆崖
	[32267] = true, -- 傳送門：銀月城
	[35717] = true, -- 傳送門：撒塔斯
	[49361] = true, -- 傳送門：斯通納德
	[88346] = true, -- 傳送門：托巴拉德
	[132626] = true, -- 傳送門：恆春谷
	[176244] = true, -- 傳送門：戰爭之矛
	[281402] = true, -- 傳送門：達薩亞洛
	-- 中立
	[53142] = true, -- 傳送門：達拉然－北裂境
	[120146] = true, -- 遠古傳送門：達拉然
	[224871] = true, -- 傳送門：達拉然－破碎群島
	[344597] = true, -- 傳送門：奧睿博司
	[395289] = true, -- 傳送門：沃卓肯
	[446534] = true, -- 傳送門：多恩諾加
}

local ToyList = {
	[61031] = true, -- 玩具火車組
	[49844] = true, -- 恐酒遙控器
}

-- 格式化自定义字符串
local function FormatMessage(message, name, id)
	message = gsub(message, "%%player%%", name)
	message = gsub(message, "%%spell%%", C_Spell_GetSpellLink(id))
	return message
end

local function TryAnnounce(spellId, sourceName, id, list, type)
	if not A.db or not A.db.utility then
		return
	end

	local channelConfig = A.db.utility.channel
	local spellConfig = (type and A.db.utility.spells[type]) or (id and A.db.utility.spells[tostring(id)])

	if not spellConfig or not channelConfig then
		return
	end

	if (id and spellId == id) or (type and list[spellId]) then
		if spellConfig.enable and (sourceName ~= E.myname or spellConfig.includePlayer) then
			A:SendMessage(
				FormatMessage(spellConfig.text, sourceName, spellId),
				A:GetChannel(channelConfig),
				spellConfig.raidWarning
			)
		end
		return true
	end

	return false
end

function A:Utility(event, sourceName, spellId)
	local config = self.db.utility

	if not config or not config.enable then
		return
	end

	if InCombatLockdown() or not event or not spellId or not sourceName then
		return
	end

	local groupStatus = self:IsGroupMember(sourceName)
	if not groupStatus or groupStatus == 3 then
		return
	end

	if not self:CheckAuthority("UTILITY") then
		return
	end

	sourceName = sourceName:gsub("%-[^|]+", "")

	if event == "SPELL_CAST_SUCCESS" then
		if TryAnnounce(spellId, sourceName, 190336) then
			return
		end -- 召喚餐點桌
		if TryAnnounce(spellId, sourceName, nil, FeastList, "feasts") then
			return
		end -- 大餐大鍋
	elseif event == "SPELL_SUMMON" then
		if TryAnnounce(spellId, sourceName, nil, BotList, "bots") then
			return
		end -- 修理機器人
		if TryAnnounce(spellId, sourceName, 261602) then
			return
		end -- 凱蒂的郵哨
		if TryAnnounce(spellId, sourceName, 376664) then
			return
		end -- 歐胡納鷹棲所
		if TryAnnounce(spellId, sourceName, 195782) then
			return
		end -- 召喚月羽雕像
	elseif event == "SPELL_CREATE" then
		if TryAnnounce(spellId, sourceName, 698) then
			return
		end -- 召喚儀式
		if TryAnnounce(spellId, sourceName, 54710) then
			return
		end -- MOLL-E 郵箱
		if TryAnnounce(spellId, sourceName, 29893) then
			return
		end -- 靈魂之井
		if TryAnnounce(spellId, sourceName, nil, ToyList, "toys") then
			return
		end -- 玩具
		if TryAnnounce(spellId, sourceName, nil, PortalList, "portals") then
			return
		end --傳送門
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		if TryAnnounce(spellId, sourceName, 384911) then
			return
		end -- 原子校準器
		if TryAnnounce(spellId, sourceName, 290154) then
			return
		end -- 塑形師道標
		if TryAnnounce(spellId, sourceName, nil, FeastList_SPELLCAST_SUCCEEDED, "feasts") then
			return
		end -- Since TWW, some feasts event has been changed
	end
end
