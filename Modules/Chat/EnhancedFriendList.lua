-- 原作：EnhancedFriendList
-- 原作者：Awbee (http://www.wowinterface.com/downloads/info8679-EnhancedFriendList.html)
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 染色逻辑
-- 添加新的 rgb 函数

local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local LSM = LibStub("LibSharedMedia-3.0")
local WT = E:GetModule("WindTools")
local EFL = E:NewModule('Wind_EnhancedFriendsList', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')

-- Friend Color
local function Hex(r, g, b)
    if(type(r) == 'table') then
        if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
    end
    if(not r or not g or not b) then
        r, g, b = 1, 1, 1
    end
    return format('|cff%02x%02x%02x', r*255, g*255, b*255)
end
local function FriendColorInit()
	local friendOffset = HybridScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame);
	if not friendOffset then
		return;
	end
	if friendOffset < 0 then
		friendOffset = 0;
	end

	local numBNetTotal, numBNetOnline = BNGetNumFriends();
	if numBNetOnline > 0 then
		for i=1, numBNetOnline, 1 do
			local _, realName, _, _, toonName, toonID, client, _, _, _, _, _, _, _, _, _ = BNGetFriendInfo(i);
			if client == BNET_CLIENT_WOW then
				local _, _, _, realmName, _, _, _, class, _, zoneName, level, _, _, _, _, _ = BNGetGameAccountInfo(toonID);
				for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
				if GetLocale() ~= "enUS" then
					for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
				end
				local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
				if not classc then
					return;
				end
				local nameString = _G["FriendsFrameFriendsScrollFrameButton"..(i-friendOffset).."Name"];
				if nameString then
					nameString:SetText(realName.." ("..Hex(classc.r, classc.g, classc.b)..toonName.."|r, "..Hex(.945, .769, .059)..level.."|r)")
				end
				if CanCooperateWithGameAccount(toonID) ~= true then
					local nameString = _G["FriendsFrameFriendsScrollFrameButton"..(i-friendOffset).."Info"];
					if nameString then
						nameString:SetText(zoneName.." ("..realmName..")");
					end
				end
			end
		end
	end

	local numberOfFriends, onlineFriends = GetNumFriends();
	if onlineFriends > 0 then
		for i=1, onlineFriends, 1 do
			j = i + numBNetOnline;
			local name, level, class, area, connected, status, note, RAF = GetFriendInfo(i);
			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
			if GetLocale() ~= "enUS" then
				for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
			end
			local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
			if not classc then
				return;
			end
			if connected then
				local nameString = _G["FriendsFrameFriendsScrollFrameButton"..(j-friendOffset).."Name"];
				if nameString and name then
					nameString:SetText(name..", L"..level);
					nameString:SetTextColor(classc.r, classc.g, classc.b);
				end
			end
		end
	end
end
-- Enhanced
local MediaPath = 'Interface\\Addons\\ElvUI_WindTools\\Texture\\FriendList\\'
EFL.GameIcons = {
	Alliance = {
		Default = BNet_GetClientTexture(BNET_CLIENT_WOW),
		BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-WoW',
		Flat = MediaPath..'GameIcons\\Flat\\Alliance',
		Gloss = MediaPath..'GameIcons\\Gloss\\Alliance',
		Launcher = MediaPath..'GameIcons\\Launcher\\Alliance',
	},
	Horde = {
		Default = BNet_GetClientTexture(BNET_CLIENT_WOW),
		BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-WoW',
		Flat = MediaPath..'GameIcons\\Flat\\Horde',
		Gloss = MediaPath..'GameIcons\\Gloss\\Horde',
		Launcher = MediaPath..'GameIcons\\Launcher\\Horde',
	},
	Neutral = {
		Default = BNet_GetClientTexture(BNET_CLIENT_WOW),
		BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-WoW',
		Flat = MediaPath..'GameIcons\\Flat\\WoW',
		Gloss = MediaPath..'GameIcons\\Gloss\\WoW',
		Launcher = MediaPath..'GameIcons\\Launcher\\WoW',
	},
	D3 = {
		Default = BNet_GetClientTexture(BNET_CLIENT_D3),
		BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-D3',
		Flat = MediaPath..'GameIcons\\Flat\\D3',
		Gloss = MediaPath..'GameIcons\\Gloss\\D3',
		Launcher = MediaPath..'GameIcons\\Launcher\\D3',
	},
	WTCG = {
		Default = BNet_GetClientTexture(BNET_CLIENT_WTCG),
		BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-WTCG',
		Flat = MediaPath..'GameIcons\\Flat\\Hearthstone',
		Gloss = MediaPath..'GameIcons\\Gloss\\Hearthstone',
		Launcher = MediaPath..'GameIcons\\Launcher\\Hearthstone',
	},
	S1 = {
		Default = BNet_GetClientTexture(BNET_CLIENT_SC),
		BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-SC',
		Flat = MediaPath..'GameIcons\\Flat\\SC',
		Gloss = MediaPath..'GameIcons\\Gloss\\SC',
		Launcher = MediaPath..'GameIcons\\Launcher\\SC',
	},
	S2 = {
		Default = BNet_GetClientTexture(BNET_CLIENT_SC2),
		BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-SC2',
		Flat = MediaPath..'GameIcons\\Flat\\SC2',
		Gloss = MediaPath..'GameIcons\\Gloss\\SC2',
		Launcher = MediaPath..'GameIcons\\Launcher\\SC2',
	},
	App = {
		Default = BNet_GetClientTexture(BNET_CLIENT_APP),
		BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-Battlenet',
		Flat = MediaPath..'GameIcons\\Flat\\BattleNet',
		Gloss = MediaPath..'GameIcons\\Gloss\\BattleNet',
		Launcher = MediaPath..'GameIcons\\Launcher\\BattleNet',
	},
	BSAp = {
		Default = BNet_GetClientTexture(BNET_CLIENT_APP),
		BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-Battlenet',
		Flat = MediaPath..'GameIcons\\Flat\\BattleNet',
		Gloss = MediaPath..'GameIcons\\Gloss\\BattleNet',
		Launcher = MediaPath..'GameIcons\\Launcher\\BattleNet',
	},
	Hero = {
		Default = BNet_GetClientTexture(BNET_CLIENT_HEROES),
		BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-HotS',
		Flat = MediaPath..'GameIcons\\Flat\\Heroes',
		Gloss = MediaPath..'GameIcons\\Gloss\\Heroes',
		Launcher = MediaPath..'GameIcons\\Launcher\\Heroes',
	},
	Pro = {
		Default = BNet_GetClientTexture(BNET_CLIENT_OVERWATCH),
		BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-Overwatch',
		Flat = MediaPath..'GameIcons\\Flat\\Overwatch',
		Gloss = MediaPath..'GameIcons\\Gloss\\Overwatch',
		Launcher = MediaPath..'GameIcons\\Launcher\\Overwatch',
	},
	DST2 = {
		Default = BNet_GetClientTexture(BNET_CLIENT_DESTINY2),
		BlizzardChat = 'Interface\\ChatFrame\\UI-ChatIcon-Destiny2',
		Flat = MediaPath..'GameIcons\\Launcher\\Destiny2',
		Gloss = MediaPath..'GameIcons\\Launcher\\Destiny2',
		Launcher = MediaPath..'GameIcons\\Launcher\\Destiny2',
	},
}
EFL.StatusIcons = {
	Default = {
		Online = FRIENDS_TEXTURE_ONLINE,
		Offline = FRIENDS_TEXTURE_OFFLINE,
		DND = FRIENDS_TEXTURE_DND,
		AFK = FRIENDS_TEXTURE_AFK,
	},
	Square = {
		Online = MediaPath..'StatusIcons\\Square\\Online',
		Offline = MediaPath..'StatusIcons\\Square\\Offline',
		DND = MediaPath..'StatusIcons\\Square\\DND',
		AFK = MediaPath..'StatusIcons\\Square\\AFK',
	},
	D3 = {
		Online = MediaPath..'StatusIcons\\D3\\Online',
		Offline = MediaPath..'StatusIcons\\D3\\Offline',
		DND = MediaPath..'StatusIcons\\D3\\DND',
		AFK = MediaPath..'StatusIcons\\D3\\AFK',
	},
}
EFL.ClientColor = {
	S1 = 'C495DD',
	S2 = 'C495DD',
	D3 = 'C41F3B',
	Pro = 'FFFFFF',
	WTCG = 'FFB100',
	Hero = '00CCFF',
	App = '82C5FF',
	BSAp = '82C5FF',
}
function EFL:ClassColorCode(class)
	local color = class and (CUSTOM_CLASS_COLORS) or { r = 1, g = 1, b = 1 }
	if not color.r or not color.g or not color.b then color = { r = 1, g = 1, b = 1 } end
	return format('|cFF%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
end
function EFL:UpdateFriends(button)
	local nameText, nameColor, infoText, broadcastText, _, Cooperate
	if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
		local name, level, class, area, connected, status = GetFriendInfo(button.id)
		broadcastText = nil
		if connected then
			button.status:SetTexture(EFL.StatusIcons[self.db.StatusIconPack][(status == CHAT_FLAG_DND and 'DND' or status == CHAT_FLAG_AFK and 'AFK' or 'Online')])
			nameText = format('%s%s - (%s - %s %s)', EFL:ClassColorCode(class), name, class, LEVEL, level)
			nameColor = FRIENDS_WOW_NAME_COLOR
			Cooperate = true
		else
			button.status:SetTexture(EFL.StatusIcons[self.db.StatusIconPack].Offline)
			nameText = name
			nameColor = FRIENDS_GRAY_COLOR
		end
		infoText = area
	elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET and BNConnected() then
		local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(button.id)
		local realmName, realmID, faction, race, class, zoneName, level, gameText
		broadcastText = messageText
		local characterName = toonName
		if presenceName then
			nameText = presenceName
			if isOnline then
				characterName = BNet_GetValidatedCharacterName(characterName, battleTag, client)
			end
		else
			nameText = UNKNOWN
		end

		if characterName then
			_, _, _, realmName, realmID, faction, race, class, _, zoneName, level, gameText = BNGetGameAccountInfo(toonID)
			if client == BNET_CLIENT_WOW then
				if (level == nil or tonumber(level) == nil) then level = 0 end
				local classcolor = EFL:ClassColorCode(class)
				local diff = level ~= 0 and format('|cFF%02x%02x%02x', GetQuestDifficultyColor(level).r * 255, GetQuestDifficultyColor(level).g * 255, GetQuestDifficultyColor(level).b * 255) or '|cFFFFFFFF'
				nameText = format('%s |cFFFFFFFF(|r%s%s|r - %s %s%s|r|cFFFFFFFF)|r', nameText, classcolor, characterName, LEVEL, diff, level)
				Cooperate = CanCooperateWithGameAccount(toonID)
			else
				nameText = format('|cFF%s%s|r', EFL.ClientColor[client] or 'FFFFFF', nameText)
			end
		end

		if isOnline then
			button.status:SetTexture(EFL.StatusIcons[self.db.StatusIconPack][(isDND and 'DND' or isAFK and 'AFK' or 'Online')])
			if client == BNET_CLIENT_WOW then
				if not zoneName or zoneName == '' then
					infoText = UNKNOWN
				else
					if realmName == EFL.MyRealm then
						infoText = zoneName
					else
						infoText = format('%s - %s', zoneName, realmName)
					end
				end
				button.gameIcon:SetTexture(EFL.GameIcons[faction][self.db.GameIcon[faction]])
			else
				infoText = gameText
				button.gameIcon:SetTexture(EFL.GameIcons[client][self.db.GameIcon[client]])
			end
			nameColor = FRIENDS_BNET_NAME_COLOR
		else
			button.status:SetTexture(EFL.StatusIcons[self.db.StatusIconPack].Offline)
			nameColor = FRIENDS_GRAY_COLOR
			infoText = lastOnline == 0 and FRIENDS_LIST_OFFLINE or format(BNET_LAST_ONLINE_TIME, FriendsFrame_GetLastOnline(lastOnline))
		end
	end

	if button.summonButton:IsShown() then
		button.gameIcon:SetPoint('TOPRIGHT', -50, -2)
	else
		button.gameIcon:SetPoint('TOPRIGHT', -21, -2)
	end

	if nameText then
		button.name:SetText(nameText)
		button.name:SetTextColor(nameColor.r, nameColor.g, nameColor.b)
		button.info:SetText(infoText)
		button.info:SetTextColor(unpack(Cooperate and {1, .96, .45} or {.49, .52, .54}))
		button.name:SetFont(LSM:Fetch('font', self.db.NameFont), self.db.NameFontSize, self.db.NameFontFlag)
		button.info:SetFont(LSM:Fetch('font', self.db.InfoFont), self.db.InfoFontSize, self.db.InfoFontFlag)
	end
end

function EFL:Initialize()
	-- 总开关
	if not E.db.WindTools["Chat"]["Enhanced Friend List"]["enabled"] then return end
	
	if E.db.WindTools["Chat"]["Enhanced Friend List"]["color_name"] then
		-- 检查是否要染色
		hooksecurefunc("FriendsList_Update", FriendColorInit)
		hooksecurefunc("HybridScrollFrame_Update", FriendColorInit)
	end

	self.db = E.db.WindTools["Chat"]["Enhanced Friend List"]["enhanced"]
	tinsert(WT.UpdateAll, function()
		EFL.db = E.db.WindTools["Chat"]["Enhanced Friend List"]["enhanced"]
	end)
	
	if self.db["enabled"] then
		-- 检查是否要进行增强
		EFL:SecureHook("FriendsFrame_UpdateFriendButton", 'UpdateFriends')
	end
end

local function InitializeCallback()
	EFL:Initialize()
end
E:RegisterModule(EFL:GetName(), InitializeCallback)