local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local FL = W:NewModule("FriendList", "AceHook-3.0", "AceEvent-3.0")
local C = W.Utilities.Color

local _G = _G
local pairs = pairs
local select = select
local strsplit = strsplit
local setmetatable = setmetatable
local strupper = strupper
local tostring = tostring

local BNConnected = BNConnected
local FriendsFrame_Update = FriendsFrame_Update
local GetClassInfo = GetClassInfo
local GetQuestDifficultyColor = GetQuestDifficultyColor
local TimerunningUtil_AddSmallIcon = TimerunningUtil and TimerunningUtil.AddSmallIcon

local C_BattleNet_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
local C_ClassColor_GetClassColor = C_ClassColor.GetClassColor
local C_FriendList_GetFriendInfoByIndex = C_FriendList.GetFriendInfoByIndex

local BNET_FRIEND_TOOLTIP_WOW_CLASSIC = BNET_FRIEND_TOOLTIP_WOW_CLASSIC
local FRIENDS_BUTTON_TYPE_BNET = FRIENDS_BUTTON_TYPE_BNET
local FRIENDS_BUTTON_TYPE_DIVIDER = FRIENDS_BUTTON_TYPE_DIVIDER
local FRIENDS_BUTTON_TYPE_WOW = FRIENDS_BUTTON_TYPE_WOW
local FRIENDS_TEXTURE_AFK = FRIENDS_TEXTURE_AFK
local FRIENDS_TEXTURE_DND = FRIENDS_TEXTURE_DND
local FRIENDS_TEXTURE_OFFLINE = FRIENDS_TEXTURE_OFFLINE
local FRIENDS_TEXTURE_ONLINE = FRIENDS_TEXTURE_ONLINE
local LOCALIZED_CLASS_NAMES_FEMALE = LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE
local WOW_PROJECT_BURNING_CRUSADE_CLASSIC = 5
local WOW_PROJECT_CLASSIC = 2
local WOW_PROJECT_MAINLINE = WOW_PROJECT_MAINLINE
local WOW_PROJECT_CAMELOT = WOW_PROJECT_CAMELOT or 18 -- WoW Forever
local WOW_PROJECT_ID = WOW_PROJECT_ID
local WOW_PROJECT_WRATH_CLASSIC = 11
local WOW_PROJECT_CATACLYSM_CLASSIC = 14
local WOW_PROJECT_MISTS_CLASSIC = 19

local MediaPath = "Interface\\Addons\\ElvUI_WindTools\\Media\\FriendList\\"

local cache = {}

-- Manually code the atlas "battlenetclienticon"
local projectCodes = {
	["ANBS"] = "Diablo Immortal",
	["Hero"] = "Heroes of the Storm",
	["OSI"] = "Diablo II",
	["S2"] = "StarCraft II",
	["VIPR"] = "Call of Duty: Black Ops 4",
	["W3"] = "WarCraft III",
	["APP"] = "Battle.net App",
	["FORE"] = "Call of Duty: Vanguard",
	["LAZR"] = "Call of Duty: MW2 Campaign Remastered",
	["RTRO"] = "Blizzard Arcade Collection",
	["WLBY"] = "Crash Bandicoot 4: It's About Time",
	["WTCG"] = "Hearthstone",
	["ZEUS"] = "Call of Duty: Blac Ops Cold War",
	["D3"] = "Diablo III",
	["GRY"] = "Warcraft Arclight Rumble",
	["ODIN"] = "Call of Duty: Mordern Warfare II",
	["S1"] = "StarCraft",
	["WOW"] = "World of Warcraft",
	["PRO"] = "Overwatch",
	["PRO-ZHCN"] = "Overwatch",
}

local clientData = {
	["Diablo Immortal"] = {
		color = { r = 0.768, g = 0.121, b = 0.231 },
	},
	["Heroes of the Storm"] = {
		color = { r = 0, g = 0.8, b = 1 },
	},
	["Diablo II"] = {
		color = { r = 0.768, g = 0.121, b = 0.231 },
	},
	["StarCraft II"] = {
		color = { r = 0.749, g = 0.501, b = 0.878 },
	},
	["Call of Duty: Black Ops 4"] = {
		color = { r = 0, g = 0.8, b = 0 },
	},
	["WarCraft III"] = {
		color = { r = 0.796, g = 0.247, b = 0.145 },
	},
	["Battle.net App"] = {
		color = { r = 0.509, g = 0.772, b = 1 },
	},
	["Call of Duty: Vanguard"] = {
		color = { r = 0, g = 0.8, b = 0 },
	},
	["Call of Duty: MW2 Campaign Remastered"] = {
		color = { r = 0, g = 0.8, b = 0 },
	},
	["Blizzard Arcade Collection"] = {
		color = { r = 0.509, g = 0.772, b = 1 },
	},
	["Crash Bandicoot 4: It's About Time"] = {
		color = { r = 0.509, g = 0.772, b = 1 },
	},
	["Hearthstone"] = {
		color = { r = 1, g = 0.694, b = 0 },
	},
	["Call of Duty: Blac Ops Cold War"] = {
		color = { r = 0, g = 0.8, b = 0 },
	},
	["Diablo III"] = {
		color = { r = 0.768, g = 0.121, b = 0.231 },
	},
	["Warcraft Arclight Rumble"] = {
		color = { r = 0.945, g = 0.757, b = 0.149 },
	},
	["Call of Duty: Mordern Warfare II"] = {
		color = { r = 0, g = 0.8, b = 0 },
	},
	["StarCraft"] = {
		color = { r = 0.749, g = 0.501, b = 0.878 },
	},
	["World of Warcraft"] = {
		color = { r = 0.866, g = 0.690, b = 0.180 },
	},
	["Overwatch"] = {
		color = { r = 1, g = 1, b = 1 },
	},
}

local timerunningSeasonIcon = {
	[2] = MediaPath .. "GameIcons\\WOW_LEG",
}

local expansionData = {
	[WOW_PROJECT_MAINLINE] = {
		name = "Retail",
		suffix = "Retail",
		maxLevel = E.Forever and 90 or W.MaxLevelForPlayerExpansion,
		icon = MediaPath .. "GameIcons\\WOW_Retail",
	},
	[WOW_PROJECT_CAMELOT] = {
		name = "Forever",
		suffix = "Forever",
		maxLevel = E.Forever and W.MaxLevelForPlayerExpansion or nil,
		icon = MediaPath .. "GameIcons\\WOW_Forever",
	},
	[WOW_PROJECT_CLASSIC] = {
		name = "Classic",
		suffix = "Classic",
		maxLevel = 60,
		icon = MediaPath .. "GameIcons\\WOW_Classic",
	},
	[WOW_PROJECT_BURNING_CRUSADE_CLASSIC] = {
		name = "TBC",
		suffix = "TBC",
		maxLevel = 70,
		icon = MediaPath .. "GameIcons\\WOW_TBC",
	},
	[WOW_PROJECT_WRATH_CLASSIC] = {
		name = "WotLK",
		suffix = "WotLK",
		maxLevel = 80,
		icon = MediaPath .. "GameIcons\\WOW_WotLK",
	},
	[WOW_PROJECT_CATACLYSM_CLASSIC] = {
		name = "Cata",
		suffix = "Cata",
		maxLevel = 85,
		icon = MediaPath .. "GameIcons\\WOW_Cata",
	},
	[WOW_PROJECT_MISTS_CLASSIC] = {
		name = "MoP",
		suffix = "MoP",
		maxLevel = 90,
		icon = MediaPath .. "GameIcons\\WOW_MoP",
	},
}

local factionIcons = {
	["Alliance"] = MediaPath .. "GameIcons\\Alliance",
	["Horde"] = MediaPath .. "GameIcons\\Horde",
}

local statusIcons = {
	default = {
		Online = FRIENDS_TEXTURE_ONLINE,
		Offline = FRIENDS_TEXTURE_OFFLINE,
		DND = FRIENDS_TEXTURE_DND,
		AFK = FRIENDS_TEXTURE_AFK,
	},
	square = {
		Online = MediaPath .. "StatusIcons\\Square\\Online",
		Offline = MediaPath .. "StatusIcons\\Square\\Offline",
		DND = MediaPath .. "StatusIcons\\Square\\DND",
		AFK = MediaPath .. "StatusIcons\\Square\\AFK",
	},
	d3 = {
		Online = MediaPath .. "StatusIcons\\D3\\Online",
		Offline = MediaPath .. "StatusIcons\\D3\\Offline",
		DND = MediaPath .. "StatusIcons\\D3\\DND",
		AFK = MediaPath .. "StatusIcons\\D3\\AFK",
	},
}

local function GetClassColor(className)
	for class, localizedName in pairs(LOCALIZED_CLASS_NAMES_MALE) do
		if className == localizedName then
			return C_ClassColor_GetClassColor(class)
		end
	end

	-- Very special rules for deDE and frFR
	if W.Locale == "deDE" or W.Locale == "frFR" then
		for class, localizedName in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
			if className == localizedName then
				return C_ClassColor_GetClassColor(class)
			end
		end
	end
end

local function GetBNetStatus(accountInfo)
	local gameAccountInfo = accountInfo and accountInfo.gameAccountInfo
	if not gameAccountInfo or not gameAccountInfo.isOnline then
		return "Offline"
	elseif accountInfo.isAFK or gameAccountInfo.isGameAFK then
		return "AFK"
	elseif accountInfo.isDND or gameAccountInfo.isGameBusy then
		return "DND"
	end

	return "Online"
end

local function GetWoWServerText(gameAccountInfo, characterName)
	local wowID = gameAccountInfo.wowProjectID

	if wowID == WOW_PROJECT_MAINLINE and (characterName or "") == "" then
		return gameAccountInfo.richPresence -- Plunderstorm
	elseif wowID == WOW_PROJECT_ID then
		return gameAccountInfo.realmDisplayName or ""
	elseif wowID and expansionData[wowID] and gameAccountInfo.richPresence then
		-- friend is playing another version of WoW (Classic, Retail, Forever...)
		local suffix = expansionData[wowID].suffix and " (" .. expansionData[wowID].suffix .. ")" or ""
		local serverStrings = { strsplit(" - ", gameAccountInfo.richPresence) }
		return (serverStrings[#serverStrings] or BNET_FRIEND_TOOLTIP_WOW_CLASSIC .. suffix) .. "*"
	end

	return gameAccountInfo.realmDisplayName or ""
end

local function BuildLocationText(area, server, areaColor, hideRealm)
	if hideRealm then
		server = ""
	end

	if area and area ~= "" and server and server ~= "" and server ~= E.myrealm then
		return C.StringWithRGB(area .. " - " .. server, areaColor)
	elseif area and area ~= "" then
		return C.StringWithRGB(area, areaColor)
	end

	return server or ""
end

local function GetGameIconTexture(db, wowID, timerunningSeasonID, faction)
	if db.textures.gameIcon == "PATCH" and wowID and expansionData[wowID] then
		if wowID == WOW_PROJECT_MAINLINE and timerunningSeasonID and timerunningSeasonIcon[timerunningSeasonID] then
			return timerunningSeasonIcon[timerunningSeasonID]
		end
		return expansionData[wowID].icon
	elseif db.textures.gameIcon == "FACTION" and faction and factionIcons[faction] then
		return factionIcons[faction]
	end
end

local function FormatLevelText(level, format)
	local text = format and format:format(level) or tostring(level)
	return C.StringWithRGB(text, GetQuestDifficultyColor(level))
end

function FL:UpdateFriendButton(button)
	if not self.db.enable then
		if cache.name and cache.info then
			F.SetFontWithDB(button.name, cache.name)
			F.SetFontWithDB(button.info, cache.info)
		end
		return
	end

	if button.buttonType == FRIENDS_BUTTON_TYPE_DIVIDER then
		return
	end

	local gameName, realID, name, server, class, area, level, note, faction, status, wowID, timerunningSeasonID

	if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
		-- WoW friends
		wowID = WOW_PROJECT_ID
		gameName = projectCodes["WOW"]
		local friendInfo = C_FriendList_GetFriendInfoByIndex(button.id)
		name, server = strsplit("-", friendInfo.name) -- server is nil if it's not a cross-realm friend
		level = friendInfo.level
		class = friendInfo.className
		area = friendInfo.area
		note = friendInfo.notes
		faction = E.myfaction -- friend should in the same faction

		if friendInfo.connected then
			if friendInfo.afk then
				status = "AFK"
			elseif friendInfo.dnd then
				status = "DND"
			else
				status = "Online"
			end
		else
			status = "Offline"
		end
	elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET and BNConnected() then
		-- Battle.net friends
		local friendAccountInfo = C_BattleNet_GetFriendAccountInfo(button.id)
		if friendAccountInfo then
			realID = friendAccountInfo.accountName
			note = friendAccountInfo.note

			local gameAccountInfo = friendAccountInfo.gameAccountInfo
			gameName = projectCodes[strupper(gameAccountInfo.clientProgram)]

			status = GetBNetStatus(friendAccountInfo)

			-- Fetch version if friend playing WoW
			if gameName == "World of Warcraft" then
				wowID = gameAccountInfo.wowProjectID
				name = gameAccountInfo.characterName or ""
				level = gameAccountInfo.characterLevel or 0
				faction = gameAccountInfo.factionName or nil
				class = gameAccountInfo.className or ""
				area = gameAccountInfo.areaName or ""
				timerunningSeasonID = gameAccountInfo.timerunningSeasonID or ""
				server = GetWoWServerText(gameAccountInfo, name)
			end
		end
	end

	-- Status icon
	if status then
		local pack = self.db.textures.status
		if statusIcons[pack] then
			button.status:SetTexture(statusIcons[pack][status])
		end
	end

	-- reset game icon with elvui style
	button.gameIcon:SetTexCoord(0, 1, 0, 1)

	if gameName then
		local buttonTitle, buttonText

		-- override Real ID or name with note
		if self.db.useNoteAsName and note and note ~= "" then
			if realID then
				realID = note
			else
				name = note
			end
		end

		-- real ID
		local clientColor = self.db.useClientColor and clientData[gameName] and clientData[gameName].color
		local realIDString = realID and clientColor and C.StringWithRGB(realID, clientColor) or realID

		-- name
		local classColor = self.db.useClassColor and GetClassColor(class)
		local nameString = name and classColor and C.StringWithRGB(name, classColor) or name
		if TimerunningUtil_AddSmallIcon and timerunningSeasonID and timerunningSeasonID ~= "" and nameString ~= nil then
			nameString = TimerunningUtil_AddSmallIcon(nameString) or nameString -- add timerunning tag
		end

		if self.db.level and wowID and expansionData[wowID] and level and level ~= 0 then
			if level ~= expansionData[wowID].maxLevel or not self.db.hideMaxLevel then
				nameString = nameString .. C.StringWithRGB(": " .. level, GetQuestDifficultyColor(level))
			end
		end

		-- combine Real ID and Name
		if nameString and nameString ~= "" and realIDString and realIDString ~= "" then
			buttonTitle = realIDString .. " \124\124 " .. nameString
		elseif nameString and nameString ~= "" then
			buttonTitle = nameString
		else
			buttonTitle = realIDString or ""
		end

		button.name:SetText(buttonTitle)

		-- area
		if area then
			buttonText = BuildLocationText(area, server, self.db.areaColor, self.db.hideRealm)
			button.info:SetText(buttonText)
		end

		-- temporary fix for upgrading db from old version
		if self.db.textures.client ~= "blizzard" then
			self.db.textures.client = "modern"
		end

		-- game icon
		if self.db.textures.gameIcon ~= "BLIZZARD" then
			local texOrAtlas = GetGameIconTexture(self.db, wowID, timerunningSeasonID, faction)
			if texOrAtlas then
				button.gameIcon:SetAlpha(1)
				button.gameIcon:SetTexture(texOrAtlas)
				button.gameIcon:SetTexCoord(0.15, 0.85, 0.15, 0.85)
			end
		end
	else
		if self.db.useNoteAsName and note and note ~= "" then
			button.name:SetText(note)
		end
	end

	-- font style hack
	if not cache.name then
		local fontName, size, style = button.name:GetFont()
		cache.name = {
			name = fontName,
			size = size,
			style = style,
		}
	end

	if not cache.info then
		local fontName, size, style = button.info:GetFont()
		cache.info = {
			name = fontName,
			size = size,
			style = style,
		}
	end

	F.SetFont(button.name)
	F.SetFontWithDB(button.name, self.db.nameFont)

	F.SetFont(button.info)
	F.SetFontWithDB(button.info, self.db.infoFont)

	-- favorite icon
	if button.Favorite:IsShown() then
		button.Favorite:ClearAllPoints()
		button.Favorite:Point("LEFT", button.name, "LEFT", button.name:GetStringWidth(), 0)
	end
end

function FL:UpdateRecentAllyButton(button)
	local data = button.elementData
	if not self.db.enable or not data then
		return
	end

	-- Status Icon
	local status
	local stateData = data.stateData
	if stateData.isOnline then
		if stateData.isAFK then
			status = "AFK"
		elseif stateData.isDND then
			status = "DND"
		else
			status = "Online"
		end
	else
		status = "Offline"
	end

	if status then
		local pack = self.db.textures.status
		if statusIcons[pack] then
			button.OnlineStatusIcon:SetTexture(statusIcons[pack][status])
		end
	end

	local CharacterData = button.CharacterData
	if not CharacterData then
		return
	end

	local characterData = data.characterData

	-- Title
	if CharacterData.Name then
		for _, key in pairs({ "NameDivider", "Level", "LevelDivider", "Class" }) do
			if CharacterData[key] then
				CharacterData[key]:Hide()
			end
		end

		local classFile = characterData and characterData.classID and select(2, GetClassInfo(characterData.classID))
		local nameString = stateData.isOnline
				and (characterData.name and self.db.useClassColor and C.StringWithClassColor(
					characterData.name,
					classFile
				) or characterData.name)
			or C.StringByTemplate(characterData.name, "gray-400")

		local level = characterData.level
		if level then
			local maxLevel = expansionData[WOW_PROJECT_ID] and expansionData[WOW_PROJECT_ID].maxLevel
			if level ~= maxLevel or not self.db.hideMaxLevel then
				nameString = nameString .. C.StringWithRGB(": " .. level, GetQuestDifficultyColor(level))
			end
		end

		if nameString then
			CharacterData.Name:SetText(nameString)
		end

		F.SetFont(CharacterData.Name)
		F.SetFontWithDB(CharacterData.Name, self.db.nameFont)
		CharacterData.Name.maxWidth = button:GetWidth() - 60
		CharacterData.Name:Width(CharacterData.Name.maxWidth)
	end

	-- Most Recent Interaction
	if CharacterData.MostRecentInteraction then
		-- Most Recent Interaction
		F.SetFont(CharacterData.MostRecentInteraction)
		F.SetFontWithDB(CharacterData.MostRecentInteraction, self.db.infoFont)
	end

	-- Info
	if CharacterData.Location then
		if stateData.currentLocation then
			local realmName = characterData.realmName or ""
			if self.db.hideRealm then
				realmName = ""
			end

			local locationText, color
			if
				stateData.currentLocation
				and stateData.currentLocation ~= ""
				and realmName
				and realmName ~= ""
				and realmName ~= E.myrealm
			then
				locationText = stateData.currentLocation .. " - " .. realmName
				color = self.db.areaColor
			elseif stateData.currentLocation and stateData.currentLocation ~= "" then
				locationText = stateData.currentLocation
				color = self.db.areaColor
			else
				locationText = realmName or ""
			end

			if not stateData.isOnline then
				locationText = C.StringByTemplate(locationText, "gray-400")
			elseif color then
				locationText = C.StringWithRGB(locationText, color)
			end

			CharacterData.Location:SetText(locationText)
		end

		F.SetFont(CharacterData.Location)
		F.SetFontWithDB(CharacterData.Location, self.db.infoFont)
	end
end

--[[
	Social UI cards (SocialUIFrame, used by WoW Forever)
	The Refresh* functions run before Blizzard lays out the card,
	so the layout already uses our texts and fonts.
]]

local function GetCardAccountInfo(card)
	local accountInfo = card.elementData and card.elementData.accountInfo
	if accountInfo and accountInfo.gameAccountInfo then
		return accountInfo, accountInfo.gameAccountInfo
	end
end

local function SetStatusTexture(texture, pack, status)
	if texture and status and pack ~= "default" and statusIcons[pack] then
		texture:SetTexture(statusIcons[pack][status])
	end
end

function FL:SocialCard_Track(card)
	self.socialCards = self.socialCards or setmetatable({}, { __mode = "k" })
	self.socialCards[card] = true
end

function FL:SocialCard_UpdatePresence(card)
	if not self.db or not self.db.enable then
		return
	end

	local accountInfo = GetCardAccountInfo(card)
	if accountInfo and card.PresenceHolder then
		SetStatusTexture(card.PresenceHolder.PresenceIcon, self.db.textures.status, GetBNetStatus(accountInfo))
	end
end

function FL:SocialCard_UpdateGameIcon(card)
	local holder = card.GameIconHolder
	if not holder or not holder.Icon then
		return
	end

	holder.Icon:SetTexCoord(0, 1, 0, 1)

	if not self.db or not self.db.enable or self.db.textures.gameIcon == "BLIZZARD" or not holder:IsShown() then
		return
	end

	local _, gameAccountInfo = GetCardAccountInfo(card)
	if not gameAccountInfo or projectCodes[strupper(gameAccountInfo.clientProgram or "")] ~= "World of Warcraft" then
		return
	end

	local texture = GetGameIconTexture(
		self.db,
		gameAccountInfo.wowProjectID,
		gameAccountInfo.timerunningSeasonID,
		gameAccountInfo.factionName
	)

	if texture then
		holder.Icon:SetAlpha(1)
		holder.Icon:SetTexture(texture)
		holder.Icon:SetTexCoord(0.15, 0.85, 0.15, 0.85)
	end
end

function FL:SocialCard_UpdateFriendName(card)
	self:SocialCard_Track(card)

	if not self.db or not self.db.enable then
		return
	end

	local accountInfo, gameAccountInfo = GetCardAccountInfo(card)
	if not accountInfo then
		return
	end

	local note = accountInfo.note
	if self.db.useNoteAsName and note and note ~= "" then
		local text = note
		if not gameAccountInfo.isOnline then
			text = C.StringByTemplate(text, "gray-400")
		end
		card.FriendName:SetText(text)
	elseif gameAccountInfo.isOnline and self.db.useClientColor then
		local gameName = projectCodes[strupper(gameAccountInfo.clientProgram or "")]
		local clientColor = gameName and clientData[gameName] and clientData[gameName].color
		local accountName = _G.BNet_GetBNetAccountName and _G.BNet_GetBNetAccountName(accountInfo)
			or accountInfo.accountName
		if clientColor and accountName and accountName ~= "" then
			card.FriendName:SetText(C.StringWithRGB(accountName, clientColor))
		end
	end

	F.SetFont(card.FriendName)
	F.SetFontWithDB(card.FriendName, self.db.nameFont)
end

function FL:SocialCard_UpdateCharacterData(card)
	if not self.db or not self.db.enable then
		return
	end

	local accountInfo, gameAccountInfo = GetCardAccountInfo(card)
	if not accountInfo or not gameAccountInfo.characterName then
		return
	end

	-- name with class color
	if gameAccountInfo.isOnline and self.db.useClassColor then
		local name = _G.FriendsListUtil and _G.FriendsListUtil.GetFormattedCharacterName(accountInfo)
			or gameAccountInfo.characterName
		local classFile = gameAccountInfo.classFilename
		local classColor = (classFile and classFile ~= "" and C_ClassColor_GetClassColor(classFile))
			or GetClassColor(gameAccountInfo.className)
		if classColor and name and name ~= "" then
			card.Name:SetText(C.StringWithRGB(name, classColor))
		end
	end

	-- level
	local level = gameAccountInfo.characterLevel
	if self.db.level and level and level > 0 then
		local wowID = gameAccountInfo.wowProjectID
		local maxLevel = wowID and expansionData[wowID] and expansionData[wowID].maxLevel
		if self.db.hideMaxLevel and level == maxLevel then
			card.Level:SetText("")
		elseif gameAccountInfo.isOnline then
			card.Level:SetText(FormatLevelText(level, _G.SOCIAL_UI_RECENT_ALLIES_CARD_LEVEL_DISPLAY_FORMAT))
		end
	end

	for _, key in pairs({ "Name", "Level", "Class" }) do
		F.SetFont(card[key])
		F.SetFontWithDB(card[key], self.db.infoFont)
	end
end

function FL:SocialCard_UpdateLocation(card)
	if not self.db or not self.db.enable then
		return
	end

	local accountInfo, gameAccountInfo = GetCardAccountInfo(card)
	if not accountInfo then
		return
	end

	local isWoW = projectCodes[strupper(gameAccountInfo.clientProgram or "")] == "World of Warcraft"
	if gameAccountInfo.isOnline and isWoW then
		local area = gameAccountInfo.areaName
		local server = GetWoWServerText(gameAccountInfo, gameAccountInfo.characterName)
		local text = BuildLocationText(area, server, self.db.areaColor, self.db.hideRealm)

		if text ~= "" then
			local rafLinkType = accountInfo.rafLinkType
			if rafLinkType and _G.Enum.RafLinkType and rafLinkType ~= _G.Enum.RafLinkType.None then
				local rafFormat = rafLinkType == _G.Enum.RafLinkType.Recruit and _G.RAF_RECRUIT_FRIEND
					or _G.RAF_RECRUITER_FRIEND
				if rafFormat then
					text = rafFormat:format(text)
				end
			end
			card.Location:SetText(text)
		end
	end

	F.SetFont(card.Location)
	F.SetFontWithDB(card.Location, self.db.infoFont)
end

function FL:RecentAllyCard_UpdatePresence(card)
	if not self.db or not self.db.enable then
		return
	end

	local stateData = card.elementData and card.elementData.stateData
	if not stateData or not card.PresenceHolder then
		return
	end

	local status = "Offline"
	if stateData.isOnline then
		status = (stateData.isAFK and "AFK") or (stateData.isDND and "DND") or "Online"
	end

	SetStatusTexture(card.PresenceHolder.PresenceIcon, self.db.textures.status, status)
end

function FL:RecentAllyCard_UpdateCharacterData(card)
	self:SocialCard_Track(card)

	if not self.db or not self.db.enable then
		return
	end

	local characterData = card.elementData and card.elementData.characterData
	local stateData = card.elementData and card.elementData.stateData
	if not characterData or not stateData then
		return
	end

	if stateData.isOnline and self.db.useClassColor and characterData.classID then
		local classFile = select(2, GetClassInfo(characterData.classID))
		if classFile and characterData.name then
			local displayName = _G.RecentAlliesUtil
					and _G.RecentAlliesUtil.GetBestDisplayNameForCharacter
					and _G.RecentAlliesUtil.GetBestDisplayNameForCharacter(characterData)
				or characterData.name
			local coloredName = C.StringWithClassColor(displayName, classFile)
			if coloredName then
				card.Name:SetText(coloredName)
			end
		end
	end

	local level = characterData.level
	if level and level > 0 then
		local maxLevel = expansionData[WOW_PROJECT_ID] and expansionData[WOW_PROJECT_ID].maxLevel
		if self.db.hideMaxLevel and level == maxLevel then
			card.Level:SetText("")
		elseif stateData.isOnline then
			card.Level:SetText(FormatLevelText(level, _G.SOCIAL_UI_RECENT_ALLIES_CARD_LEVEL_DISPLAY_FORMAT))
		end
	end

	for _, key in pairs({ "Name", "Level", "Class" }) do
		F.SetFont(card[key])
		F.SetFontWithDB(card[key], self.db.nameFont)
	end
end

function FL:RecentAllyCard_UpdateLocation(card)
	if not self.db or not self.db.enable then
		return
	end

	local characterData = card.elementData and card.elementData.characterData
	local stateData = card.elementData and card.elementData.stateData
	if not characterData or not stateData then
		return
	end

	if stateData.isOnline and stateData.currentLocation then
		local text = BuildLocationText(
			stateData.currentLocation,
			characterData.realmName,
			self.db.areaColor,
			self.db.hideRealm
		)
		if text ~= "" then
			card.Location:SetText(text)
		end
	end

	for _, key in pairs({ "Location", "MostRecentInteraction" }) do
		F.SetFont(card[key])
		F.SetFontWithDB(card[key], self.db.infoFont)
	end
end

function FL:HookSocialUICards()
	local friendCard = _G.FriendsListSocialCardMixin
	if friendCard and not self:IsHooked(friendCard, "RefreshFriendNameDisplayText") then
		self:SecureHook(friendCard, "InitializePresenceDisplay", "SocialCard_UpdatePresence")
		self:SecureHook(friendCard, "InitializeGameIcon", "SocialCard_UpdateGameIcon")
		self:SecureHook(friendCard, "RefreshFriendNameDisplayText", "SocialCard_UpdateFriendName")
		self:SecureHook(friendCard, "RefreshFriendCharacterDataDisplayText", "SocialCard_UpdateCharacterData")
		self:SecureHook(friendCard, "RefreshLocationDisplayText", "SocialCard_UpdateLocation")
	end

	local allyCard = _G.RecentAlliesSocialCardMixin
	if allyCard and not self:IsHooked(allyCard, "RefreshCharacterDataDisplayText") then
		self:SecureHook(allyCard, "InitializePresenceDisplay", "RecentAllyCard_UpdatePresence")
		self:SecureHook(allyCard, "RefreshCharacterDataDisplayText", "RecentAllyCard_UpdateCharacterData")
		self:SecureHook(allyCard, "RefreshLocationDisplayText", "RecentAllyCard_UpdateLocation")
	end
end

function FL:RefreshSocialUICards()
	if not self.socialCards then
		return
	end

	for card in pairs(self.socialCards) do
		if card:IsShown() and card.elementData and card.InitializeDisplay then
			card:InitializeDisplay()
		end
	end
end

function FL:Initialize()
	if not E.db.WT.social.friendList.enable then
		return
	end

	self.db = E.db.WT.social.friendList

	self:HookSocialUICards()
	self:RegisterEvent("ADDON_LOADED", function(_, addonName)
		if addonName == "Blizzard_FriendsFrame" or addonName == "Blizzard_RecentAllies" then
			self:HookSocialUICards()
		end
	end)

	self:SecureHook("FriendsFrame_UpdateFriendButton", "UpdateFriendButton")
	if _G.RecentAlliesFrame and _G.RecentAlliesFrame.List and _G.RecentAlliesFrame.List.ScrollBox then
		self:SecureHook(_G.RecentAlliesFrame.List.ScrollBox, "Update", function(scrollBox)
			scrollBox:ForEachFrame(function(button)
				self:UpdateRecentAllyButton(button)
			end)
		end)
	end

	self.initialized = true
end

function FL:ProfileUpdate()
	self.db = E.db.WT.social.friendList

	if self.db and self.db.enable and not self.initialized then
		self:Initialize()
	end

	FriendsFrame_Update()

	local recentAllies = _G.RecentAlliesFrame
	if recentAllies and recentAllies.List and recentAllies.List.ScrollBox then
		recentAllies.List.ScrollBox:ForEachFrame(function(button)
			self:UpdateRecentAllyButton(button)
		end)
	end

	self:RefreshSocialUICards()
end

W:RegisterModule(FL:GetName())
