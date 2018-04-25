-- 原作：ShestakUI 的一个通告组件
-- 原作者：Shestak (http://www.wowinterface.com/downloads/info19033-ShestakUI.html)
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 修改函数判定参数
-- 修正宠物打断不通告问题
-- 增减了部分光环通告
-- 汉化使其更加适合中文语法（明明是早期技能名翻译不规则的锅）
-- 频道检测更加多样化
-- 添加了一些可设置项

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local AnnounceSystem = E:NewModule('AnnounceSystem', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

local format = string.format
local pairs = pairs

P["WindTools"]["Announce System"] = {
	["enabled"] = true,
	["Interrupt"] = {
		["enabled"] = true,
		["SoloYell"] = false,
		["IncludePet"] = true,
	},
	["ResAndThreat"] = {
		["enabled"] = true,
	},
	["ResThanks"] = {
		["enabled"] = true,
	},
	["RaidUsefulSpells"] = {
		["enabled"] = true,
	},
}

local myName = UnitName("player")

local ASL = {
	["UseSpellNoTarget"] = "%s 使用了 %s",
	["UseSpellTarget"] = "%s 使用了 %s -> %s",
	["PutNormal"] = "%s 放置了 %s",
	["PutFeast"] = "天啊，土豪 %s 竟然擺出了 %s！",
	["PutPortal"] = "%s 開啟了 %s",
	["PutRefreshmentTable"] = "%s 使用了 %s，各位快來領餐包哦！",
	["RitualOfSummoning"] = "%s 正在進行 %s，請配合點門哦！",
	["SoulWell"] = "%s 發糖了，快點拿喲！",
	["Interrupt"] = "我打斷了 %s 的 >%s<！",
	["Thanks"] = "%s，謝謝你復活我:)",
}
if GetLocale() == "zhCN" then
	local ASL = {
		["UseSpellNoTarget"] = "%s 使用了 %s",
		["UseSpellTarget"] = "%s 使用了 %s -> %s",
		["PutNormal"] = "%s 放置了 %s",
		["PutFeast"] = "天啊，土豪 %s 竟然摆出了 %s！",
		["PutPortal"] = "%s 开启了 %s",
		["PutRefreshmentTable"] = "%s 使用了 %s，各位快來领面包哦！",
		["RitualOfSummoning"] = "%s 正在进行 %s，请配合点门哦！",
		["SoulWell"] = "%s 发糖了，快点拿哟！",
		["Interrupt"] = "我打断了 %s 的 >%s<！",
		["Thanks"] = "%s，谢谢你复活我:)",
	}
end

----------------------------------------------------------------------------------------
--	智能頻道檢測
----------------------------------------------------------------------------------------
local function CheckChat(warning)
	-- 随机团队频道 > 副本警告频道 > 副本频道 > 队伍频道 > 说频道
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		return "INSTANCE_CHAT"
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
		if warning and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant()) then
			return "RAID_WARNING"
		else
			return "RAID"
		end
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return "PARTY"
	end

	return "SAY"
end

----------------------------------------------------------------------------------------
--	打断频道检测
----------------------------------------------------------------------------------------
local function CheckChatInterrupt ()
	-- 随机团队频道 > 副本频道 > 队伍频道 > 大喊频道（设定的话） > 聊天框显示
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		return "INSTANCE_CHAT"
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
		return "RAID"
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return "PARTY"
	elseif E.db.WindTools["Announce System"]["Interrupt"]["SoloYell"] then
		return "YELL"
	end

	return "ChatFrame"
end

local ThanksSpells = {
	-- 复活技能
	[20484] = true,		-- 復生
	[61999] = true,		-- 盟友復生
	[20707] = true,		-- 靈魂石
	[50769] = true,		-- 復活
	[2006]  = true,		-- 復活術
	[7328]  = true,		-- 救贖
	[2008]  = true,		-- 先祖之魂
	[115178] = true,	-- 回命訣
}
local CombatResSpells = {
	-- 战复技能
	[61999] = true,	-- 盟友復生
	[20484] = true,	-- 復生
	[20707] = true,	-- 靈魂石
}
local TransferThreatSpells = {
	-- 仇恨转移技能
	[34477] = true,	-- 誤導
	[57934] = true,	-- 偷天換日
}

local FeastSpells = {
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
	[188036] = true,  -- 靈魂大鍋
	[201352] = true,  -- 蘇拉瑪爾豪宴
}

local Bots = {
	-- 機器人通報列表
	[22700] = true,		-- 修理機器人74A型
	[44389] = true,		-- 修理機器人110G型
	[54711] = true,		-- 廢料機器人
	[67826] = true,		-- 吉福斯
	[126459] = true,	-- 布靈登4000型
	[161414] = true,	-- 布靈登5000型
	[199109] = true,	-- 自動鐵錘
	[226241] = true,	-- 靜心寶典
}


local Toys = {
	-- 玩具
	[61031] = true,		-- 玩具火車組
	[49844] = true,		-- 恐酒遙控器
}

local PortalSpells = {
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
	[53142] = true,		-- 達拉然
	[120146] = true,	-- 遠古達拉然
}



----------------------------------------------------------------------------------------
--	团队战斗有用技能提示
----------------------------------------------------------------------------------------
function AnnounceSystem:RaidUsefulSpells()
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:SetScript("OnEvent", function(self, event, _, subEvent, _, _, srcName, _, _, _, destName, _, _, spellID, ...)
		if not IsInGroup() or InCombatLockdown() or not subEvent or not spellID or not srcName then return end
		if not UnitInRaid(srcName) and not UnitInParty(srcName) then return end

		local srcName = srcName:gsub("%-[^|]+", "")
		if subEvent == "SPELL_CAST_SUCCESS" then
			-- 大餐
			if FeastSpells[spellID] then 
				SendChatMessage(format(ASL["PutFeast"], srcName, GetSpellLink(spellID)), CheckChat(true))
			end
			-- 召喚餐點桌
			if spellID == 43987 then
				SendChatMessage(format(ASL["PutRefreshmentTable"], srcName, GetSpellLink(spellID)), CheckChat(true))
			-- 召喚儀式
			elseif spellID == 698 then
				SendChatMessage(format(ASL["RitualOfSummoning"], srcName, GetSpellLink(spellID)), CheckChat(true))
			end
		elseif subEvent == "SPELL_SUMMON" then
			-- 修理機器人
			if Bots[spellID] then
				SendChatMessage(format(ASL["PutNormal"], srcName, GetSpellLink(spellID)), CheckChat(true))
			end
		elseif subEvent == "SPELL_CREATE" then
			-- MOLL-E 郵箱
			if spellID == 54710 then
				SendChatMessage(format(ASL["PutNormal"], srcName, GetSpellLink(spellID)), CheckChat(true))
			-- 靈魂之井
			elseif spellID == 29893 then
				SendChatMessage(format(ASL["SoulWell"], srcName), CheckChat(true))
			-- 玩具
			elseif Toys[spellID] then
				SendChatMessage(format(ASL["PutNormal"], srcName, GetSpellLink(spellID)), CheckChat())
			-- 傳送門
			elseif PortalSpells[spellID] then
				SendChatMessage(format(ASL["PutPortal"], srcName, GetSpellLink(spellID)), CheckChat(true))
			end
		-- elseif subEvent == "SPELL_AURA_APPLIED" then
		-- 	-- 火鷄羽毛 及 派對手榴彈
		-- 	if spellID == 61781 or ((spellID == 51508 or spellID == 51510)) then
		-- 		SendChatMessage(format(ASL["UseSpellNoTarget"], srcName, GetSpellLink(spellID)), CheckChat())
		-- 	end
		end
	end)
end

----------------------------------------------------------------------------------------
--	战复 / 误导
----------------------------------------------------------------------------------------
function AnnounceSystem:ResAndThreat()
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:SetScript("OnEvent", function(self, _, ...)	
		local _, event, _, sourceGUID, sourceName, _, _, _, destName, _, _, spellID = ...
		local _, _, difficultyID = GetInstanceInfo()
		if event ~= "SPELL_CAST_SUCCESS" then return end
		if sourceName then sourceName = sourceName:gsub("%-[^|]+", "") end
		if destName then destName = destName:gsub("%-[^|]+", "") end
		if not sourceName then return end
		-- 在副本里启用战复技能提示
		if difficultyID ~= 0 then
			if CombatResSpells[spellID] then
				if destName == nil then
					SendChatMessage(format(ASL["UseSpellNoTarget"], sourceName, GetSpellLink(spellID)), CheckChat())
				else
					SendChatMessage(format(ASL["UseSpellTarget"], sourceName, GetSpellLink(spellID), destName), CheckChat())
				end
			end
		end

		-- 仇恨转移技能提示
		if TransferThreatSpells[spellID] then
			if destName == myName or sourceName == myName then
				-- 如果自己被误导或者自己误导别人，用表情进行通告
				-- 其他时候则显示在聊天框
				SendChatMessage(format(": "..ASL["UseSpellTarget"], sourceName, GetSpellLink(spellID), destName), "EMOTE")
			else
				ChatFrame1:AddMessage(format(ASL["UseSpellTarget"], sourceName, GetSpellLink(spellID), destName))
			end
		end

	end)
end

----------------------------------------------------------------------------------------
--	打断
----------------------------------------------------------------------------------------
function AnnounceSystem:Interrupt()
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:SetScript("OnEvent", function(self, _, ...)
		local _, event, _, subEvent, sourceGUID, _, _, _, _, destName, _, _, _, _, _, spellID = ...
		
		if E.db.WindTools["Announce System"]["Interrupt"]["enabled"] then
			-- 打断
			if event == "SPELL_INTERRUPT" and (sourceGUID == UnitGUID("player") or (sourceGUID == UnitGUID("pet") and E.db.WindTools["Announce System"]["Interrupt"]["IncludePet"])) then
				local destChannel = CheckChatInterrupt()
				if destChannel == "ChatFrame" then
					-- 如果没有设定个人情况发送到大喊频道，就在聊天框显示一下（就自己能看到）
					ChatFrame1:AddMessage(format(ASL["Interrupt"], destName, GetSpellLink(spellID)))
				else
					-- 智能检测频道并发送信息
					SendChatMessage(format(ASL["Interrupt"], destName, GetSpellLink(spellID)), destChannel)
				end
			end
		end
	end)
end

----------------------------------------------------------------------------------------
--	复活感谢
----------------------------------------------------------------------------------------
function AnnounceSystem:ResThanks()
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:SetScript("OnEvent", function(_, event, _, subEvent, _, _, buffer, _, _, _, player, _, _, spell, ...)
		for key, value in pairs(ThanksSpells) do
			if spell == key and value == true and player == myName and buffer ~= myName and subEvent == "SPELL_CAST_SUCCESS" then
				local thanksTargetName = buffer:gsub("%-[^|]+", "") -- 去除服务器名
				SendChatMessage(format(ASL["Thanks"], thanksTargetName), "WHISPER", nil, buffer)
			end
		end
	end)
end

function AnnounceSystem:Initialize()
	if not (GetLocale() == "zhCN" or GetLocale() == "zhTW") then return end
	if not E.db.WindTools["Announce System"]["enabled"] then return end
	
	if E.db.WindTools["Announce System"]["Interrupt"]["enabled"] then
		AnnounceSystem:Interrupt()
	end
	if E.db.WindTools["Announce System"]["ResAndThreat"]["enabled"] then
		AnnounceSystem:ResAndThreat()
	end
	if E.db.WindTools["Announce System"]["ResThanks"]["enabled"] then
		AnnounceSystem:ResThanks()
	end
	if E.db.WindTools["Announce System"]["RaidUsefulSpells"]["enabled"] then
		AnnounceSystem:RaidUsefulSpells()
	end
end

local function InsertOptions()
	E.Options.args.WindTools.args["More Tools"].args["Announce System"].args["Interrupt"] = {
		order = 10,
		type = "group",
		name = L["Interrupt"],
		args = {
			Enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				get = function(info) return E.db.WindTools["Announce System"]["Interrupt"]["enabled"] end,
				set = function(info, value) E.db.WindTools["Announce System"]["Interrupt"]["enabled"] = value;E:StaticPopup_Show("PRIVATE_RL")end
			},
			SoloYell = {
				order = 2,
				type = "toggle",
				name = L["Solo Yell"],
				get = function(info) return E.db.WindTools["Announce System"]["Interrupt"]["SoloYell"] end,
				set = function(info, value) E.db.WindTools["Announce System"]["Interrupt"]["SoloYell"] = value;E:StaticPopup_Show("PRIVATE_RL")end
			},
			IncludePet = {
				order = 3,
				type = "toggle",
				name = L["Include Pet"],
				get = function(info) return E.db.WindTools["Announce System"]["Interrupt"]["IncludePet"] end,
				set = function(info, value) E.db.WindTools["Announce System"]["Interrupt"]["IncludePet"] = value;E:StaticPopup_Show("PRIVATE_RL")end
			},
		}
	}
	E.Options.args.WindTools.args["More Tools"].args["Announce System"].args["ResAndThreat"] = {
		order = 11,
		type = "group",
		name = L["Res And Threat"],
		args = {
			Enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				get = function(info) return E.db.WindTools["Announce System"]["ResAndThreat"]["enabled"] end,
				set = function(info, value) E.db.WindTools["Announce System"]["ResAndThreat"]["enabled"] = value;E:StaticPopup_Show("PRIVATE_RL")end
			},
		}
	}
	E.Options.args.WindTools.args["More Tools"].args["Announce System"].args["ResThanks"] = {
		order = 12,
		type = "group",
		name = L["Res Thanks"],
		args = {
			Enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				get = function(info) return E.db.WindTools["Announce System"]["ResThanks"]["enabled"] end,
				set = function(info, value) E.db.WindTools["Announce System"]["ResThanks"]["enabled"] = value;E:StaticPopup_Show("PRIVATE_RL")end
			},
		}
	}
	E.Options.args.WindTools.args["More Tools"].args["Announce System"].args["RaidUsefulSpells"] = {
		order = 13,
		type = "group",
		name = L["Raid Useful Spells"],
		args = {
			Enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				get = function(info) return E.db.WindTools["Announce System"]["RaidUsefulSpells"]["enabled"] end,
				set = function(info, value) E.db.WindTools["Announce System"]["RaidUsefulSpells"]["enabled"] = value;E:StaticPopup_Show("PRIVATE_RL")end
			},
		}
	}
end

WT.ToolConfigs["Announce System"] = InsertOptions
E:RegisterModule(AnnounceSystem:GetName())