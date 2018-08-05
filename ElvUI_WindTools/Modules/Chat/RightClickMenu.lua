-- 原作：TinyUntitled 的 Menu lua中的一段
-- loudsoul (http://bbs.ngacn.cc/read.php?tid=10240957)
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 增加自定义功能设定项

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local EnhancedRCMenu = E:NewModule('EnhancedRCMenu');

P["WindTools"]["Right-click Menu"] = {
	["enabled"] = true,
}

local function urlencode(s)
	s = string.gsub(s, "([^%w%.%- ])", function(c)
			return format("%%%02X", string.byte(c))
		end)
	return string.gsub(s, " ", "+")
end

local function gethost()
	local host = "http://us.battle.net/wow/en/character/"
	if (locale == "zhTW") then
		host = "http://tw.battle.net/wow/zh/character/"
	elseif (locale == "zhCN") then
		host = "http://www.battlenet.com.cn/wow/zh/character/"
	end
	return host
end

local function popupClick(self, info)
	local editBox
	local name, server = UnitName(info.unit)
	if (info.value == "ARMORY") then
		local armory = gethost() .. urlencode(server or GetRealmName()) .. "/" .. urlencode(name) .. "/advanced"
		editBox = ChatEdit_ChooseBoxForSend()
		ChatEdit_ActivateChat(editBox)
		editBox:SetText(armory)
		editBox:HighlightText()
	elseif (info.value == "NAME_COPY") then
		editBox = ChatEdit_ChooseBoxForSend()
		local hasText = (editBox:GetText() ~= "")
		ChatEdit_ActivateChat(editBox)
		editBox:Insert(name)
		if (not hasText) then editBox:HighlightText() end
	end
end

function EnhancedRCMenu:Initialize()
	if not E.db.WindTools["Right-click Menu"]["enabled"] then return end

	local locale = GetLocale()

	local UnitPopupButtonsExtra = {
		["ARMORY"] = { enUS ="Armory",          zhCN = "英雄榜",   zhTW = "英雄榜" },
		["SEND_WHO"] = { enUS ="Query Detail",  zhCN = "查询玩家", zhTW = "查詢玩家" },
		["NAME_COPY"] = { enUS ="Get Name",     zhCN = "获取名字", zhTW = "獲取名字" },
		["GUILD_ADD"] = { enUS ="Guild Invite", zhCN = "公会邀请", zhTW = "公會邀請" },
		["FRIEND_ADD"] = { enUS ="Add Friend",  zhCN = "添加好友", zhTW = "添加好友" },
		["MYSTATS"] = { enUS ="Report MyStats",  zhCN = "报告装等", zhTW = "報告裝等" },
	}

	for k, v in pairs(UnitPopupButtonsExtra) do
		v.text = v[locale] or k
		UnitPopupButtons[k] = v
	end

	tinsert(UnitPopupMenus["FRIEND"], 1, "ARMORY")
	tinsert(UnitPopupMenus["FRIEND"], 1, "MYSTATS")
	tinsert(UnitPopupMenus["FRIEND"], 1, "NAME_COPY")
	tinsert(UnitPopupMenus["FRIEND"], 1, "SEND_WHO")
	tinsert(UnitPopupMenus["FRIEND"], 1, "FRIEND_ADD")
	tinsert(UnitPopupMenus["FRIEND"], 1, "GUILD_ADD")

	tinsert(UnitPopupMenus["CHAT_ROSTER"], 1, "NAME_COPY")
	tinsert(UnitPopupMenus["CHAT_ROSTER"], 1, "SEND_WHO")
	tinsert(UnitPopupMenus["CHAT_ROSTER"], 1, "FRIEND_ADD")
	tinsert(UnitPopupMenus["CHAT_ROSTER"], 1, "INVITE")

	tinsert(UnitPopupMenus["GUILD"], 1, "ARMORY")
	tinsert(UnitPopupMenus["GUILD"], 1, "NAME_COPY")
	tinsert(UnitPopupMenus["GUILD"], 1, "FRIEND_ADD")

	hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData)
		if (UIDROPDOWNMENU_MENU_LEVEL > 1) then return end
		if (unit and (unit == "target" or string.find(unit, "party"))) then
			local info
			if (UnitIsPlayer(unit)) then
				info = UIDropDownMenu_CreateInfo()
				info.text = UnitPopupButtonsExtra["ARMORY"].text
				info.arg1 = {value="ARMORY",unit=unit}
				info.func = popupClick
				info.notCheckable = true
				UIDropDownMenu_AddButton(info)
			end
			info = UIDropDownMenu_CreateInfo()
			info.text = UnitPopupButtonsExtra["NAME_COPY"].text
			info.arg1 = {value="NAME_COPY",unit=unit}
			info.func = popupClick
			info.notCheckable = true
			UIDropDownMenu_AddButton(info)
		end
	end)

	hooksecurefunc("UnitPopup_OnClick", function(self)
		local unit = UIDROPDOWNMENU_INIT_MENU.unit
		local name = UIDROPDOWNMENU_INIT_MENU.name
		local server = UIDROPDOWNMENU_INIT_MENU.server
		local fullname = name
		local editBox
		if (server and (not unit or UnitRealmRelationship(unit) ~= LE_REALM_RELATION_SAME)) then
			fullname = name .. "-" .. server
		end
		if (self.value == "ARMORY") then
			local armory = gethost() .. urlencode(server or GetRealmName()) .. "/" .. urlencode(name) .. "/advanced"
			editBox = ChatEdit_ChooseBoxForSend()
			ChatEdit_ActivateChat(editBox)
			editBox:SetText(armory)
			editBox:HighlightText()
		elseif (self.value == "MYSTATS") then
			local CRITICAL = TEXT_MODE_A_STRING_RESULT_CRITICAL or STAT_CRITICAL_STRIKE
			CRITICAL = gsub(CRITICAL, "[()]","")
			SendChatMessage(format("%s:%.1f %s:%s", ITEM_LEVEL_ABBR, select(2,GetAverageItemLevel()), HP, AbbreviateNumbers(UnitHealthMax("player"))), "WHISPER", nil, fullname)
			SendChatMessage(format(" - %s:%.2f%%", STAT_HASTE, GetHaste()), "WHISPER", nil, fullname)
			SendChatMessage(format(" - %s:%.2f%%", STAT_MASTERY, GetMasteryEffect()), "WHISPER", nil, fullname)
			--SendChatMessage(format(" - %s:%.2f%%", STAT_LIFESTEAL, GetLifesteal()), "WHISPER", nil, fullname)
			SendChatMessage(format(" - %s:%.2f%%", CRITICAL, max(GetRangedCritChance(), GetCritChance(), GetSpellCritChance(2))), "WHISPER", nil, fullname)
			SendChatMessage(format(" - %s:%.2f%%", STAT_VERSATILITY, GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)), "WHISPER", nil, fullname)
		elseif (self.value == "NAME_COPY") then
			editBox = ChatEdit_ChooseBoxForSend()
			local hasText = (editBox:GetText() ~= "")
			ChatEdit_ActivateChat(editBox)
			editBox:Insert(fullname)
			if (not hasText) then editBox:HighlightText() end
		elseif (self.value == "FRIEND_ADD") then
			AddFriend(fullname)
		elseif (self.value == "SEND_WHO") then
			SendWho("n-"..name)
		elseif (self.value == "GUILD_ADD") then
			GuildInvite(fullname)
		end
	end)
end

local function InsertOptions()
	E.Options.args.WindTools.args["Chat"].args["Right-click Menu"].args["additionalconfig"] = {
		order = 10,
		type = "group",
		name = L["Features"],
		disabled = function() return not E.db.WindTools["Right-click Menu"]["enabled"] end,
		args = {
			custom_text = {
				order = 1,
				type = "toggle",
				name = L["Use feature 1"],
				
				get = function(info) return E.db.WindTools["Right-click Menu"]["feature1"] end,
				set = function(info, value) E.db.WindTools["Right-click Menu"]["feature1"] = value; E:StaticPopup_Show("PRIVATE_RL")  end,
			},
		}
	}
end
WT.ToolConfigs["Right-click Menu"] = InsertOptions
E:RegisterModule(EnhancedRCMenu:GetName())