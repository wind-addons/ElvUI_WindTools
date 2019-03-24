-- 原创模块
-- 参考：https://wow.gamepedia.com/COMBAT_LOG_EVENT
local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local AS = E:NewModule('Wind_AnnounceSystem', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

local gsub = string.gsub
local format = string.format
local pairs = pairs

local PlayerName = UnitName("player")

local Feasts = {
	-- 大餐通報列表
	[126492] = true,  -- 燒烤盛宴
	[126494] = true,  -- 豪华燒烤盛宴
	[126495] = true,  -- 快炒盛宴
	[126496] = true,  -- 豪华快炒盛宴
	[126501] = true,  -- 烘烤盛宴
	[126502] = true,  -- 豪华烘烤盛宴
	[126497] = true,  -- 燉煮盛宴
	[126498] = true,  -- 豪华燉煮盛宴
	[126499] = true,  -- 蒸煮盛宴
	[126500] = true,  -- 豪華蒸煮盛宴
	[104958] = true,  -- 熊貓人盛宴
	[126503] = true,  -- 美酒盛宴
	[126504] = true,  -- 豪華美酒盛宴
	[145166] = true,  -- 拉麵推車
	[145169] = true,  -- 豪華拉麵推車
	[145196] = true,  -- 熊貓人國寶級拉麵推車
	[188036] = true,  -- 灵魂药锅
	[201351] = true,  -- 丰盛大餐
	[201352] = true,  -- 苏拉玛奢华大餐
	[259409] = true,  -- 海帆盛宴
	[259410] = true,  -- 船长盛宴佳肴
	[276972] = true,  -- 神秘大鍋
	[286050] = true,  -- 血潤盛宴
}

local Bots = {
	-- 機器人通報列表
	[22700] = true,		-- 修理機器人74A型
	[44389] = true,		-- 修理機器人110G型
	[54711] = true,		-- 廢料機器人
	[67826] = true,		-- 吉福斯
	[126459] = true,	-- 布靈登4000型
	[161414] = true,	-- 布靈登5000型
	[200061] = true,	-- 召唤里弗斯
	[200204] = true,	-- 自動鐵錘模式(里弗斯)
	[200205] = true,	-- 自動鐵錘模式(里弗斯)
	[200210] = true,	-- 故障检测模式(里弗斯)
	[200211] = true,	-- 故障检测模式(里弗斯)
	[200212] = true,	-- 烟花表演模式(里弗斯)
	[200214] = true,	-- 烟花表演模式(里弗斯)
	[200215] = true,	-- 零食发放模式(里弗斯)
	[200216] = true,	-- 零食发放模式(里弗斯)
	[200217] = true,	-- 华丽模式(布靈登6000型)(里弗斯)
	[200218] = true,	-- 华丽模式(布靈登6000型)(里弗斯)
	[200219] = true,	-- 驾驶战斗模式(里弗斯)
	[200220] = true,	-- 驾驶战斗模式(里弗斯)
	[200221] = true,	-- 虫洞发生器模式(里弗斯)
	[200222] = true,	-- 虫洞发生器模式(里弗斯)
	[200223] = true,	-- 热砧模式(里弗斯)
	[200225] = true,	-- 热砧模式(里弗斯)
	[199109] = true,	-- 自動鐵錘
	[226241] = true,	-- 宁神圣典
	[256230] = true,	-- 静心圣典
}

local Toys = {
	-- 玩具
	[61031] = true,		-- 玩具火車組
	[49844] = true,		-- 恐酒遙控器
}

local Portals = {
	-- 傳送門通報列表
	-- 聯盟
	[10059] = true,		-- 暴風城
	[11416] = true,		-- 鐵爐堡
	[11419] = true,		-- 達納蘇斯
	[32266] = true,		-- 艾克索達
	[49360] = true,		-- 塞拉摩
	[33691] = true,		-- 撒塔斯
	[88345] = true,		-- 托巴拉德
	[132620] = true,	-- 恆春谷
	[176246] = true,	-- 暴風之盾
	[281400] = true,	-- 波拉勒斯
	-- 部落
	[11417] = true,		-- 奧格瑪
	[11420] = true,		-- 雷霆崖
	[11418] = true,		-- 幽暗城
	[32267] = true,		-- 銀月城
	[49361] = true,		-- 斯通納德
	[35717] = true,		-- 撒塔斯
	[88346] = true,		-- 托巴拉德
	[132626] = true,	-- 恆春谷
	[176244] = true,	-- 戰爭之矛
	-- 中立
	[53142] = true,		-- 達拉然——北裂境
	[224871] = true,	-- 達拉然——破碎群島
	[120146] = true,	-- 遠古達拉然
}

function AS:SendMessage(text, channel, raid_warning)
	-- 忽视不通告讯息
	if channel == "NONE" then return end
	-- 聊天框输出
	if channel == "SELF" then print(text) return end
	-- 表情频道前置冒号以优化显示
	if channel == "EMOTE" then text = ": "..text end
	-- 如果允许团队警告
	if channel == "RAID" and raid_warning and IsInRaid(LE_PARTY_CATEGORY_HOME) then
		if UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant() then
			channel = "RAID_WARNING"
		end
	end

	SendChatMessage(text, channel)
end

function AS:GetChannel(channel_db, raid_warning)
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
		return channel_db.instance
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
		return channel_db.raid
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return channel_db.party
	elseif channel_db.solo then
		return channel_db.solo
	end
	return "NONE"
end

function AS:Interrupt(...)
	local config = self.db.interrupt
	if not config.enabled then return end
	if config.only_instance and select(2, IsInInstance()) == "none" then return end

	local _, _, _, sourceGUID, sourceName, _, _, _, destName, _, _, sourceSpellId, _, _, targetSpellID = ...
	if not (sourceSpellId and targetSpellID) then return end

	-- 格式化自定义字符串
	local function FormatMessage(custom_message)
		custom_message = gsub(custom_message, "%%player%%", sourceName)
		custom_message = gsub(custom_message, "%%target%%", destName)
		custom_message = gsub(custom_message, "%%player_spell%%", GetSpellLink(sourceSpellId))
		custom_message = gsub(custom_message, "%%target_spell%%", GetSpellLink(targetSpellID))
		return custom_message
	end

	-- 自己及宠物打断
	if sourceGUID == UnitGUID("player") or sourceGUID == UnitGUID("pet") then
		if config.player.enabled then
			self:SendMessage(FormatMessage(config.player.text), self:GetChannel(config.player.channel))
		end
		return
	end

	-- 他人打断
	if config.others.enabled then
		if IsInGroup() and (UnitInRaid(sourceName) or UnitInParty(sourceName)) then
			self:SendMessage(FormatMessage(config.others.text), self:GetChannel(config.others.channel))
		end
	end
end

function AS:Raid(...)
	local config = self.db.raid
	if not config.enabled then return end
	local _, event, _, sourceGUID, sourceName, _, _, _, destName, _, _, spellId = ...
	if InCombatLockdown() or not event or not spellId or not sourceName then return end
	if sourceName ~= PlayerName and not UnitInRaid(sourceName) and not UnitInParty(sourceName) then return end
	sourceName = sourceName:gsub("%-[^|]+", "")

	-- 格式化自定义字符串
	local function FormatMessage(custom_message)
		custom_message = gsub(custom_message, "%%player%%", sourceName)
		custom_message = gsub(custom_message, "%%spell%%", GetSpellLink(spellId))
		return custom_message
	end

	-- 通用验证函数
	local function TryAnnounce(spell_db, spell_list)
		if (spell_db.id and spellId == spell_db.id) or (spell_list and spell_list[spellId]) then
			if spell_db.enabled then
				self:SendMessage(FormatMessage(spell_db.text), self:GetChannel(config.channel), spell_db.use_raid_warning)
			end
			return true
		end
		return false
	end

	-- 绑定事件
	if event == "SPELL_CAST_SUCCESS" then
		if TryAnnounce(config.spells.conjure_refreshment) then return end     -- 召喚餐點桌
		if TryAnnounce(config.spells.feasts, Feasts) then return end          -- 大餐
	elseif event == "SPELL_SUMMON" then
		if TryAnnounce(config.spells.bots, Bots) then return end              -- 修理機器人
		if TryAnnounce(config.spells.cmoll_e) then return end                 -- 凱蒂的郵哨
	elseif event == "SPELL_CREATE" then
		if TryAnnounce(config.spells.ritual_of_summoning) then return end     -- 召喚儀式
		if TryAnnounce(config.spells.moll_e) then return end                  -- MOLL-E 郵箱
		if TryAnnounce(config.spells.create_soulwell) then return end         -- 靈魂之井
		if TryAnnounce(config.spells.toys, Toys) then return end              -- 玩具
		if TryAnnounce(config.spells.portals, Portals) then return end        -- 傳送門
	end
end

function AS:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local subEvent = select(2, CombatLogGetCurrentEventInfo())

	if subEvent == "SPELL_CAST_SUCCESS" then
		self:Raid(CombatLogGetCurrentEventInfo())
	elseif subEvent == "SPELL_SUMMON" then
		self:Raid(CombatLogGetCurrentEventInfo())
	elseif subEvent == "SPELL_CREATE" then
		self:Raid(CombatLogGetCurrentEventInfo())
	elseif subEvent == "SPELL_INTERRUPT" then
		self:Interrupt(CombatLogGetCurrentEventInfo())
    end
end

function AS:Initialize()
	self.db = E.db.WindTools["More Tools"]["Announce System"]
	if not self.db.enabled then return end

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local function InitializeCallback()
	AS:Initialize()
end

E:RegisterModule(AS:GetName(), InitializeCallback)