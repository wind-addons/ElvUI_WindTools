-- 原创模块
-- 参考：https://wow.gamepedia.com/COMBAT_LOG_EVENT
local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local AS = E:NewModule('Wind_AnnounceSystem', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

local _G = _G
local UnitName, GetRealmName, UnitGUID, UnitInParty, UnitInRaid, IsInInstance, GetSpellLink = UnitName, GetRealmName, UnitGUID, UnitInParty, UnitInRaid, IsInInstance, GetSpellLink
local strsplit, gsub, format, pairs= strsplit, string.gsub, string.format, pairs

local PlayerName, PlayerRelam = UnitName("player"), GetRealmName("player")
local PlayerNameWithServer = format("%s-%s", PlayerName, PlayerRelam)

-- 一个对 CJK 支持更好的分割字符串函数
-- 参考自 https://blog.csdn.net/sftxlin/article/details/48275197
local function BetterSplit(str, split_char)
    if str == "" or str == nil then 
        return {};
    end
	local split_len = string.len(split_char)
    local sub_str_tab = {};
    local i = 0;
    local j = 0;
    while true do
        j = string.find(str, split_char,i+split_len);
        if string.len(str) == i then 
            break;
        end
 
 
        if j == nil then
            table.insert(sub_str_tab,string.sub(str,i));
            break;
        end;
 
 
        table.insert(sub_str_tab,string.sub(str,i,j-1));
        i = j+split_len;
    end
    return sub_str_tab;
end

-- 找到宠物的主人
-- 参考自 https://www.wowinterface.com/forums/showthread.php?t=43082
local tempTooltip = CreateFrame("GameTooltip", "FindPetOwnerToolTip", nil, "GameTooltipTemplate")
tempTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
local tempPetDetails = _G["FindPetOwnerToolTipTextLeft2"]

local function GetPetInfo(pet_name)
	tempTooltip:ClearLines()
	tempTooltip:SetUnit(pet_name)
	local details = tempPetDetails:GetText()
	if not details then return nil end
	local split_word = "'"
	if GetLocale() == "zhCN" or GetLocale() == "zhTW" then split_word = "的" end
	local pet_owner = BetterSplit(details, split_word)[1]
	local pet_role = BetterSplit(details, split_word)[2]
	return pet_owner, pet_role
end

local Feasts = {
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
	[61031] = true,		-- 玩具火車組
	[49844] = true,		-- 恐酒遙控器
}

local Portals = {
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

local Resurrection = {
	[20484] = true,		-- 復生
	[61999] = true,		-- 盟友復生
	[20707] = true,		-- 靈魂石
	[50769] = true,		-- 復活
	[2006]  = true,		-- 復活術
	[7328]  = true,		-- 救贖
	[2008]  = true,		-- 先祖之魂
	[115178] = true,	-- 回命訣
	[265116] = true,	-- 不穩定的時間轉移器（工程學）
}

local Taunt = {
	[355] = true,    -- 嘲諷（戰士）
	[56222] = true,  -- 黑暗赦令（死亡騎士）
	[6795] = true,   -- 低吼（德魯伊 熊形態）
	[62124] = true,  -- 清算之手（聖騎士）
	[116189] = true, -- 嘲心嘯（武僧）
	[118635] = true, -- 嘲心嘯（武僧圖騰 玄牛雕像 算作玩家群嘲）
	[196727] = true, -- 嘲心嘯（武僧守護者 玄牛怒兆）
	[281854] = true, -- 折磨（惡魔獵人）
	[2649] = true,   -- 低吼（獵人寵物）
	[17735] = true,  -- 受難 （術士寵物虛無行者）
}

local CombatResurrection = {
	[61999] = true,	    -- 盟友復生
	[20484] = true,	    -- 復生
	[20707] = true,	    -- 靈魂石
	[265116] = true,    -- 不穩定的時間轉移器（工程學）
}

local ThreatTransfer = {
	[34477] = true,	-- 誤導
	[57934] = true,	-- 偷天換日
}

function AS:SendMessage(text, channel, raid_warning, whisper_target)
	-- 忽视不通告讯息
	if channel == "NONE" then return end
	-- 聊天框输出
	if channel == "SELF" then ChatFrame1:AddMessage(text) return end
	-- 密语
	if channel == "WHISPER" then
		if whisper_target then 
			SendChatMessage(text, channel, nil, whisper_target)
		end
		return
	end
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

function AS:GetChannel(channel_db)
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

function AS:SendAddonMessage(message)
	if not IsInGroup() then return end
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
		C_ChatInfo.SendAddonMessage(self.Prefix, message, "INSTANCE")
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
		C_ChatInfo.SendAddonMessage(self.Prefix, message, "RAID")
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		C_ChatInfo.SendAddonMessage(self.Prefix, message, "PARTY")
	end
end

function AS:CanIAnnounce()
	if not self then return end
	self.AllUsers = {}
	self.ActiveUser = nil
	self.ActiveUserAuthority = nil
	if IsInGroup() then self:SendAddonMessage("HELLO") else self.ActiveUser = PlayerNameWithServer end
end

function AS:Interrupt(...)
	local config = self.db.interrupt
	if not config.enabled then return end
	if config.only_instance and select(2, IsInInstance()) == "none" then return end

	local _, _, _, sourceGUID, sourceName, _, _, _, destName, _, _, sourceSpellId, _, _, targetSpellId = ...
	if not (sourceSpellId and targetSpellId) then return end

	-- 格式化自定义字符串
	local function FormatMessage(custom_message)
		custom_message = gsub(custom_message, "%%player%%", sourceName)
		custom_message = gsub(custom_message, "%%target%%", destName)
		custom_message = gsub(custom_message, "%%player_spell%%", GetSpellLink(sourceSpellId))
		custom_message = gsub(custom_message, "%%target_spell%%", GetSpellLink(targetSpellId))
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
		local sourceType = strsplit("-", sourceGUID)
		if sourceType == "Pet" then sourceName = select(1, GetPetInfo(sourceName)) end
		if not UnitInRaid(sourceName) or not UnitInParty(sourceName) then return end
		self:SendMessage(FormatMessage(config.others.text), self:GetChannel(config.others.channel))
	end
end

function AS:Utility(...)
	local config = self.db.utility_spells
	if not config or not config.enabled then return end
	local _, event, _, sourceGUID, sourceName, _, _, _, destName, _, _, spellId = ...
	if InCombatLockdown() or not event or not spellId or not sourceName then return end
	if sourceName ~= PlayerName and not UnitInRaid(sourceName) and not UnitInParty(sourceName) then return end
	sourceName = sourceName:gsub("%-[^|]+", "")

	if self.ActiveUser ~= PlayerNameWithServer then return end

	-- 格式化自定义字符串
	local function FormatMessage(custom_message)
		custom_message = gsub(custom_message, "%%player%%", sourceName)
		custom_message = gsub(custom_message, "%%spell%%", GetSpellLink(spellId))
		return custom_message
	end

	-- 通用验证函数
	local function TryAnnounce(spell_db, spell_list)
		if (spell_db.id and spellId == spell_db.id) or (spell_list and spell_list[spellId]) then
			if spell_db.enabled and (not spell_db.player_cast or spell_db.player_cast and sourceGUID == UnitGUID("player")) then
				self:SendMessage(FormatMessage(spell_db.text), self:GetChannel(config.channel), spell_db.use_raid_warning)
			end
			return true
		end
		return false
	end

	-- 绑定事件
	if event == "SPELL_CAST_SUCCESS" then
		if TryAnnounce(config.spells.conjure_refreshment) then return end     -- 召喚餐點桌
		if TryAnnounce(config.spells.feasts, Feasts) then return end          -- 大餐大鍋
	elseif event == "SPELL_SUMMON" then
		if TryAnnounce(config.spells.bots, Bots) then return end              -- 修理機器人
		if TryAnnounce(config.spells.katy_stampwhistle) then return end       -- 凱蒂的郵哨
	elseif event == "SPELL_CREATE" then
		if TryAnnounce(config.spells.ritual_of_summoning) then return end     -- 召喚儀式
		if TryAnnounce(config.spells.moll_e) then return end                  -- MOLL-E 郵箱
		if TryAnnounce(config.spells.create_soulwell) then return end         -- 靈魂之井
		if TryAnnounce(config.spells.toys, Toys) then return end              -- 玩具
		if TryAnnounce(config.spells.portals, Portals) then return end        -- 傳送門
	end
end

function AS:Combat(...)
	local config = self.db.combat_spells
	if not config or not config.enabled then return end
	local _, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId = ...
	local difficultyId = select(3, GetInstanceInfo())
	if not destName or not sourceName then return end
	if sourceName ~= PlayerName and not UnitInRaid(sourceName) and not UnitInParty(sourceName) then return end

	if self.ActiveUser ~= PlayerNameWithServer then return end

	-- 格式化自定义字符串
	local function FormatMessage(custom_message)
		destName = destName:gsub("%-[^|]+", "")
		sourceName = sourceName:gsub("%-[^|]+", "")
		custom_message = gsub(custom_message, "%%player%%", sourceName)
		custom_message = gsub(custom_message, "%%target%%", destName)
		custom_message = gsub(custom_message, "%%spell%%", GetSpellLink(spellId))
		return custom_message
	end

	-- 战斗复活
	if CombatResurrection[spellId] then
		if config.combat_resurrection.enabled then
			if config.combat_resurrection.player_cast then
				if sourceGUID == UnitGUID("player") then
					self:SendMessage(FormatMessage(config.combat_resurrection.text), self:GetChannel(config.combat_resurrection.channel), config.combat_resurrection.use_raid_warning)
				end
			else
				self:SendMessage(FormatMessage(config.combat_resurrection.text), self:GetChannel(config.combat_resurrection.channel), config.combat_resurrection.use_raid_warning)
			end
		end
		return true
	end
	
	-- 仇恨转移
	if ThreatTransfer[spellId] then
		if config.threat_transfer.enabled then
			local needAnnounce = false

			if config.threat_transfer.player_cast and sourceGUID == UnitGUID("player") then needAnnounce = true end
			if config.threat_transfer.target_is_me and destGUID == UnitGUID("player") then needAnnounce = true end
			if not config.threat_transfer.target_is_me and not config.threat_transfer.player_cast then needAnnounce = true end

			if config.threat_transfer.only_target_is_not_tank then
				local role = UnitGroupRolesAssigned(destName)
				if role == "TANK" or role == "NONE" then needAnnounce = false end
			end

			if needAnnounce then
				self:SendMessage(FormatMessage(config.threat_transfer.text), self:GetChannel(config.threat_transfer.channel), config.threat_transfer.use_raid_warning)
			end
		end
		return true
	end

	return false
end

function AS:Taunt(...)
	local config = self.db.taunt_spells
	if not config.enabled then return end

	local timestamp, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId = ...
	if not spellId or not sourceGUID or not destGUID or not Taunt[spellId] then return false end

	local sourceType = strsplit("-", sourceGUID)
	local petOwner, petRole
	
	-- 格式化自定义字符串
	local function FormatMessageWithPet(custom_message)
		petOwner = petOwner:gsub("%-[^|]+", "")
		destName = destName:gsub("%-[^|]+", "")
		sourceName = sourceName:gsub("%-[^|]+", "")
		custom_message = gsub(custom_message, "%%player%%", petOwner)
		custom_message = gsub(custom_message, "%%target%%", destName)
		custom_message = gsub(custom_message, "%%spell%%", GetSpellLink(spellId))
		custom_message = gsub(custom_message, "%%pet%%", sourceName)
		custom_message = gsub(custom_message, "%%pet_role%%", petRole)
		return custom_message
	end

	local function FormatMessageWithoutPet(custom_message)
		destName = destName:gsub("%-[^|]+", "")
		sourceName = sourceName:gsub("%-[^|]+", "")
		custom_message = gsub(custom_message, "%%player%%", sourceName)
		custom_message = gsub(custom_message, "%%target%%", destName)
		custom_message = gsub(custom_message, "%%spell%%", GetSpellLink(spellId))
		return custom_message
	end
	
	if event == "SPELL_AURA_APPLIED" then
		-- 嘲讽成功
		if sourceType == "Player" then
			if sourceName == PlayerName then
				if config.player.player.enabled then
					if spellId == 118635 then
						-- 武僧群嘲防刷屏
						if not self.MonkProvokeAllTimeCache[sourceGUID] or timestamp - self.MonkProvokeAllTimeCache[sourceGUID] > 1 then
							self.MonkProvokeAllTimeCache[sourceGUID] = timestamp
							self:SendMessage(FormatMessageWithoutPet(config.player.player.provoke_all_text), self:GetChannel(config.player.player.success_channel))
						end
					else
						self:SendMessage(FormatMessageWithoutPet(config.player.player.success_text), self:GetChannel(config.player.player.success_channel))
					end
				end
			elseif config.others.player.enabled then
				if spellId == 118635 then
					-- 武僧群嘲防刷屏
					if not self.MonkProvokeAllTimeCache[sourceGUID] or timestamp - self.MonkProvokeAllTimeCache[sourceGUID] > 1 then
						self.MonkProvokeAllTimeCache[sourceGUID] = timestamp
						self:SendMessage(FormatMessageWithoutPet(config.others.player.provoke_all_text), self:GetChannel(config.others.player.success_channel))
					end
				else
					self:SendMessage(FormatMessageWithoutPet(config.others.player.success_text), self:GetChannel(config.others.player.success_channel))
				end
			end
		elseif sourceType == "Pet" or sourceType == "Creature" then
			petOwner, petRole = GetPetInfo(sourceName)
			if petOwner == PlayerName then
				if config.player.pet.enabled then
					self:SendMessage(FormatMessageWithPet(config.player.pet.success_text), self:GetChannel(config.player.pet.success_channel))
				end
			elseif config.others.pet.enabled then
				self:SendMessage(FormatMessageWithPet(config.others.pet.success_text), self:GetChannel(config.others.pet.success_channel))
			end
		end
	elseif event == "SPELL_MISSED" then
		-- 嘲讽失败
		if sourceType == "Player" then
			if sourceName == PlayerName then
				if config.player.player.enabled then
					self:SendMessage(FormatMessageWithoutPet(config.player.player.failed_text), self:GetChannel(config.player.player.failed_channel))
				end
			elseif config.others.player.enabled then
				self:SendMessage(FormatMessageWithoutPet(config.others.player.failed_text), self:GetChannel(config.others.player.failed_channel))
			end
		elseif sourceType == "Pet" or sourceType == "Creature" then
			petOwner, petRole = GetPetInfo(sourceName)
			if petOwner == PlayerName then
				if config.player.pet.enabled then
					self:SendMessage(FormatMessageWithPet(config.player.pet.failed_text), self:GetChannel(config.player.pet.failed_channel))
				end
			elseif config.others.pet.enabled then
				self:SendMessage(FormatMessageWithPet(config.others.pet.failed_text), self:GetChannel(config.others.pet.failed_channel))
			end
		end
	end

	return true
end

function AS:SayThanks(...)
	local config = self.db.thanks
	if not config.enabled then return end
	local _, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId = ...
	if not destGUID or not sourceGUID then return end

	-- 格式化自定义字符串
	local function FormatMessage(custom_message)
		destName = destName:gsub("%-[^|]+", "")
		sourceNameWithoutServer = sourceName:gsub("%-[^|]+", "")
		custom_message = gsub(custom_message, "%%player%%", destName)
		custom_message = gsub(custom_message, "%%target%%", sourceNameWithoutServer)
		custom_message = gsub(custom_message, "%%spell%%", GetSpellLink(spellId))
		return custom_message
	end
	
	if Resurrection[spellId] then
		-- 排除预先绑定灵魂石的情况
		if not InCombatLockdown() and spellId == 20707 then return end
		if config.resurrection.enabled and sourceGUID ~= UnitGUID("player") and destGUID == UnitGUID("player") then
			self:SendMessage(FormatMessage(config.resurrection.text), self:GetChannel(config.resurrection.channel), nil, sourceName)
		end
	end
end

function AS:SayThanks_Goodbye()
	local config = self.db.thanks
	if not config.enabled or not config.goodbye.enabled then return end
	self:SendMessage(config.goodbye.text, self:GetChannel(config.goodbye.channel))
end

function AS:LFG_COMPLETION_REWARD(event, ...)
	C_Timer.After(1, function() self:SayThanks_Goodbye() end)
end

function AS:CHALLENGE_MODE_COMPLETED(event, ...)
	C_Timer.After(1, function() self:SayThanks_Goodbye() end)
end

function AS:GROUP_ROSTER_UPDATE(event, ...)
	self:CanIAnnounce()
end

function AS:ZONE_CHANGED_NEW_AREA(event, ...)
	self:CanIAnnounce()
end

function AS:CHAT_MSG_ADDON(event, ...)
	local prefix, message, channel, sender = select(1, ...)
	if prefix ~= self.Prefix then return end
	-- 默认用户进入队伍时自动打个招呼
	if message == "HELLO" then
		local authority = 0
		if not IsInGroup() then return end
		if UnitIsGroupLeader("player") then authority = 2 end
		if UnitIsGroupAssistant("player") then authority = 1 end
		self:SendAddonMessage("FB_"..authority)
	elseif message:match("^FB_") then
		local authority = tonumber(select(2, strsplit("_", message)))
		self.AllUsers[sender] = authority
		for user_name, user_authority in pairs(self.AllUsers) do
			if self.ActiveUser == nil then
				self.ActiveUser = user_name
				self.ActiveUserAuthority = user_authority
			elseif user_authority > self.ActiveUserAuthority then
				self.ActiveUser = user_name
				self.ActiveUserAuthority = user_authority
			elseif user_authority == self.ActiveUserAuthority and user_name < self.ActiveUser then
				self.ActiveUser = user_name
				self.ActiveUserAuthority = user_authority
			end
		end
		--print("[WindTools DEBUG] ActiveUser is: ", self.ActiveUser)
	end
end

function AS:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local subEvent = select(2, CombatLogGetCurrentEventInfo())

	if subEvent == "SPELL_CAST_SUCCESS" then
		self:SayThanks(CombatLogGetCurrentEventInfo())
		if self:Combat(CombatLogGetCurrentEventInfo()) then return end
		self:Utility(CombatLogGetCurrentEventInfo())
	elseif subEvent == "SPELL_SUMMON" then
		self:Utility(CombatLogGetCurrentEventInfo())
	elseif subEvent == "SPELL_CREATE" then
		self:Utility(CombatLogGetCurrentEventInfo())
	elseif subEvent == "SPELL_INTERRUPT" then
		self:Interrupt(CombatLogGetCurrentEventInfo())
	elseif subEvent == "SPELL_AURA_APPLIED" then
		self:Taunt(CombatLogGetCurrentEventInfo())
	elseif subEvent == "SPELL_MISSED" then
		self:Taunt(CombatLogGetCurrentEventInfo())
	end
end

function AS:Initialize()
	self.db = E.db.WindTools["More Tools"]["Announce System"]
	if not self.db.enabled then return end

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("LFG_COMPLETION_REWARD")
	self:RegisterEvent("CHALLENGE_MODE_COMPLETED")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("CHAT_MSG_ADDON")

	self.Prefix = "WIND_AS"
	self.AllUsers = {}
	local regStatus = C_ChatInfo.RegisterAddonMessagePrefix(self.Prefix)
	if not regStatus then print("[WindTools Announce System] Prefix error") end

	self.MonkProvokeAllTimeCache = {}

	self.CanIAnnounce()
end

local function InitializeCallback()
	AS:Initialize()
end

E:RegisterModule(AS:GetName(), InitializeCallback)