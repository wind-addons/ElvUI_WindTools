-- 原作：TinyUntitled 的 Menu lua中的一段
-- 参考：XanChat
-- loudsoul (http://bbs.ngacn.cc/read.php?tid=10240957)
-- 修改：houshuu, SomeBlu
-------------------
-- 主要修改条目：
-- 模块化
-- 增加自定义功能设定项

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local EnhancedRCMenu = E:NewModule('Wind_EnhancedRCMenu')
local locale = GetLocale()

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

local function getfullname()
	local unit = UIDROPDOWNMENU_INIT_MENU.unit
	local name = UIDROPDOWNMENU_INIT_MENU.name
	local server = UIDROPDOWNMENU_INIT_MENU.server

	if (server and (not unit or UnitRealmRelationship(unit) ~= LE_REALM_RELATION_SAME)) then
		return name .. "-" .. server
	else
		return name
	end
end

EnhancedRCMenu.friend_features = {
	"ARMORY",
	"MYSTATS",
	"NAME_COPY",
	"SEND_WHO",
	"FRIEND_ADD",
	"GUILD_ADD",
}
EnhancedRCMenu.cr_features = {
	"NAME_COPY",
	"SEND_WHO",
	"FRIEND_ADD",
}
EnhancedRCMenu.guild_features = {
	"ARMORY",
	"NAME_COPY",
	"FRIEND_ADD",
}
EnhancedRCMenu.player_features = {
	"ARMORY",
	"NAME_COPY",
}

EnhancedRCMenu.UnitPopupButtonsExtra = {
	["ARMORY"] = true,
	["SEND_WHO"] = true,
	["NAME_COPY"] = true,
	["GUILD_ADD"] = true,
	["FRIEND_ADD"] = true,
	["MYSTATS"] = true,
}

EnhancedRCMenu.dropdownmenu_show = {
	["SELF"] = true,
	["PLAYER"] = true,
	["PARTY"] = true,
	["RAID_PLAYER"] = true,
	["TARGET"] = true,
}

StaticPopupDialogs["ARMORY"] = {
	text = L["Armory"],
	button2 = CANCEL,
	hasEditBox = true,
    hasWideEditBox = true,
	timeout = 0,
	exclusive = 1,
	hideOnEscape = 1,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	whileDead = 1,
	maxLetters = 255,
}

StaticPopupDialogs["NAME_COPY"] = {
	text = L["Get Name"],
	button2 = CANCEL,
	hasEditBox = true,
    hasWideEditBox = true,
	timeout = 0,
	exclusive = 1,
	hideOnEscape = 1,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	whileDead = 1,
	maxLetters = 255,
}

UnitPopupButtons["WINDTOOLS"] = {
	text = WT.Title,
	isTitle = true,
	isUninteractable = true,
	isSubsection = true,
	isSubsectionTitle = true,
	isSubsectionSeparator = true,
}

UnitPopupButtons["ARMORY"] = {
	text = L["Armory"],
	func = function()
		local name = UIDROPDOWNMENU_INIT_MENU.name
		local server = UIDROPDOWNMENU_INIT_MENU.server

		if name then
			local armory = gethost() .. urlencode(server or GetRealmName()) .. "/" .. urlencode(name) .. "/advanced"
			local dialog = StaticPopup_Show("ARMORY")
			local editbox = _G[dialog:GetName().."EditBox"]  
			editbox:SetText(armory)
			editbox:SetFocus()
			editbox:HighlightText()
			local button = _G[dialog:GetName().."Button2"]
			button:ClearAllPoints()
			button:SetPoint("CENTER", editbox, "CENTER", 0, -30)
		end
	end
}

UnitPopupButtons["SEND_WHO"] = {
	text = L["Query Detail"],
	func = function()
		local fullname = getfullname()

		if fullname then
			SendWho(fullname)
		end
	end
}

UnitPopupButtons["GUILD_ADD"] = {
	text = L["Guild Invite"],
	func = function()
		local fullname = getfullname()

		if fullname then
			GuildInvite(fullname)
		end
	end
}

UnitPopupButtons["FRIEND_ADD"] = {
	text = L["Add Friend"],
	func = function()
		local fullname = getfullname()

		if fullname then
			AddFriend(fullname)
		end
	end
}

UnitPopupButtons["MYSTATS"] = {
	text = L["Report MyStats"],
	func = function()
		local fullname = getfullname()

		if fullname then
			local CRITICAL = TEXT_MODE_A_STRING_RESULT_CRITICAL or STAT_CRITICAL_STRIKE
			CRITICAL = gsub(CRITICAL, "[()]","")
			SendChatMessage(format("%s:%.1f %s:%s", ITEM_LEVEL_ABBR, select(2,GetAverageItemLevel()), HP, AbbreviateNumbers(UnitHealthMax("player"))), "WHISPER", nil, fullname)
			SendChatMessage(format(" - %s:%.2f%%", STAT_HASTE, GetHaste()), "WHISPER", nil, fullname)
			SendChatMessage(format(" - %s:%.2f%%", STAT_MASTERY, GetMasteryEffect()), "WHISPER", nil, fullname)
			--SendChatMessage(format(" - %s:%.2f%%", STAT_LIFESTEAL, GetLifesteal()), "WHISPER", nil, fullname)
			SendChatMessage(format(" - %s:%.2f%%", CRITICAL, max(GetRangedCritChance(), GetCritChance(), GetSpellCritChance(2))), "WHISPER", nil, fullname)
			SendChatMessage(format(" - %s:%.2f%%", STAT_VERSATILITY, GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)), "WHISPER", nil, fullname)
		end
	end
}

UnitPopupButtons["NAME_COPY"] = {
	text = L["Get Name"],
	func = function()
		local fullname = getfullname()

		if fullname then
			local dialog = StaticPopup_Show("NAME_COPY")
			local editbox = _G[dialog:GetName().."EditBox"]  
			editbox:SetText(fullname or "")
			editbox:SetFocus()
			editbox:HighlightText()
			local button = _G[dialog:GetName().."Button2"]
			button:ClearAllPoints()
			button:SetPoint("CENTER", editbox, "CENTER", 0, -30)
		end
	end
}

function EnhancedRCMenu:Initialize()
	if not E.db.WindTools["Chat"]["Right-click Menu"]["enabled"] then return end

	-- 好友功能 载入
	tinsert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"] - 1, "WINDTOOLS")
	for _, v in pairs(EnhancedRCMenu.friend_features) do
		if E.db.WindTools["Chat"]["Right-click Menu"]["friend"][v] then
			tinsert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"] - 1, v)
		end
	end

	-- -- 聊天名单功能 载入
	-- tinsert(UnitPopupMenus["CHAT_ROSTER"], #UnitPopupMenus["CHAT_ROSTER"] - 1, "WINDTOOLS")
	-- for _, v in pairs(EnhancedRCMenu.cr_features) do
	-- 	if E.db.WindTools["Chat"]["Right-click Menu"]["chat_roster"][v] then
	-- 		tinsert(UnitPopupMenus["CHAT_ROSTER"], #UnitPopupMenus["CHAT_ROSTER"] - 1, v)
	-- 	end
	-- end

	-- -- 公会功能 载入
	-- tinsert(UnitPopupMenus["GUILD"], #UnitPopupMenus["GUILD"] - 1, "WINDTOOLS")
	-- tinsert(UnitPopupMenus["COMMUNITIES_GUILD_MEMBER"], #UnitPopupMenus["COMMUNITIES_GUILD_MEMBER"] - 1, "WINDTOOLS")
	-- for _, v in pairs(EnhancedRCMenu.guild_features) do
	-- 	if E.db.WindTools["Chat"]["Right-click Menu"]["guild"][v] then
	-- 		tinsert(UnitPopupMenus["GUILD"], #UnitPopupMenus["GUILD"] - 1, v)
	-- 		tinsert(UnitPopupMenus["COMMUNITIES_GUILD_MEMBER"], #UnitPopupMenus["COMMUNITIES_GUILD_MEMBER"] - 1, v)
	-- 	end
	-- end

	-- 修复回报功能错误
	-- if E.db.WindTools["Chat"]["Right-click Menu"]["friend"]["Fix_Report"] then
	-- 	local old_C_ChatInfo_CanReportPlayer = C_ChatInfo.CanReportPlayer
	-- 	C_ChatInfo.CanReportPlayer = function(...)
	-- 		return true
	-- 	end
	-- end

	-- 人物右键菜单
	-- for _, unit in pairs{"SELF","PLAYER","PARTY","RAID_PLAYER"} do
	-- 	tinsert(UnitPopupMenus[unit], #UnitPopupMenus[unit] - 1, "WINDTOOLS")
	-- 	for _, v in pairs(EnhancedRCMenu.player_features) do
	-- 		tinsert(UnitPopupMenus[unit], #UnitPopupMenus[unit] - 1, v)
	-- 	end
	-- end
	-- need to fix position problems
	-- hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData)
	-- 	if (UIDROPDOWNMENU_MENU_LEVEL == 1 and EnhancedRCMenu.dropdownmenu_show[which]) then
	-- 		local info = UIDropDownMenu_CreateInfo()
	-- 		UIDropDownMenu_AddSeparator(UIDROPDOWNMENU_MENU_LEVEL)
	-- 		UnitPopup_AddDropDownButton(info, dropdownMenu, UnitPopupButtons["WINDTOOLS"], "WINDTOOLS")
	-- 		if (UnitIsPlayer(unit)) then
	-- 			UnitPopup_AddDropDownButton(info, dropdownMenu, UnitPopupButtons["ARMORY"], "ARMORY")
	-- 		end
	-- 		UnitPopup_AddDropDownButton(info, dropdownMenu, UnitPopupButtons["NAME_COPY"], "NAME_COPY")
	-- 	end
	-- end)

	hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData, ...)
		for i=1, UIDROPDOWNMENU_MAXBUTTONS do
			local button = _G["DropDownList" .. UIDROPDOWNMENU_MENU_LEVEL .. "Button" .. i]
			if EnhancedRCMenu.UnitPopupButtonsExtra[button.value] then
				button.func = UnitPopupButtons[button.value].func
			end
		end
	end)
end

local function InitializeCallback()
	EnhancedRCMenu:Initialize()
end
E:RegisterModule(EnhancedRCMenu:GetName(), InitializeCallback)
