local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local CM = W:NewModule("ContextMenu", "AceHook-3.0")

local _G = _G
local format = format
local gsub = gsub
local ipairs = ipairs
local max = max
local pairs = pairs
local select = select
local sort = sort
local strlower = strlower
local strsub = strsub
local tinsert = tinsert
local tonumber = tonumber

local AbbreviateNumbers = AbbreviateNumbers
local BNGetNumFriends = BNGetNumFriends
local BNSendWhisper = BNSendWhisper
local CanGuildInvite = CanGuildInvite
local GenerateClosure = GenerateClosure
local GetAverageItemLevel = GetAverageItemLevel
local GetCombatRatingBonus = GetCombatRatingBonus
local GetCritChance = GetCritChance
local GetHaste = GetHaste
local GetLifesteal = GetLifesteal
local GetMasteryEffect = GetMasteryEffect
local GetRangedCritChance = GetRangedCritChance
local C_SpecializationInfo_GetSpecialization = C_SpecializationInfo.GetSpecialization
local C_SpecializationInfo_GetSpecializationInfo = C_SpecializationInfo.GetSpecializationInfo
local GetSpellCritChance = GetSpellCritChance
local GetVersatilityBonus = GetVersatilityBonus
local C_ChatInfo_SendChatMessage = C_ChatInfo.SendChatMessage
local UnitClass = UnitClass
local UnitHealthMax = UnitHealthMax
local UnitPlayerControlled = UnitPlayerControlled

local C_BattleNet_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
local C_BattleNet_GetFriendGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo
local C_BattleNet_GetFriendNumGameAccounts = C_BattleNet.GetFriendNumGameAccounts
local C_Club_GetGuildClubId = C_Club.GetGuildClubId
local C_FriendList_SendWho = C_FriendList.SendWho
local C_GuildInfo_Invite = C_GuildInfo.Invite
local Menu_ModifyMenu = Menu.ModifyMenu

local CR_VERSATILITY_DAMAGE_DONE = CR_VERSATILITY_DAMAGE_DONE
local HP = HP
local ITEM_LEVEL_ABBR = ITEM_LEVEL_ABBR
local STAT_CRITICAL_STRIKE = STAT_CRITICAL_STRIKE
local STAT_HASTE = STAT_HASTE
local STAT_LIFESTEAL = STAT_LIFESTEAL
local STAT_MASTERY = STAT_MASTERY
local STAT_VERSATILITY = STAT_VERSATILITY
local TEXT_MODE_A_STRING_RESULT_CRITICAL = TEXT_MODE_A_STRING_RESULT_CRITICAL

local function getRetailCharacterNamesFromGameAccountInfo(gameAccountInfo)
	if gameAccountInfo.clientProgram == "WoW" and gameAccountInfo.wowProjectID == 1 then
		return gameAccountInfo.characterName .. "-" .. gameAccountInfo.realmName
	end
end

local function getRetailCharacterNamesByBNetID(id)
	local numBNOnlineFriend = select(2, BNGetNumFriends())
	for i = 1, numBNOnlineFriend do
		local accountInfo = C_BattleNet_GetFriendAccountInfo(i)
		if
			accountInfo
			and accountInfo.bnetAccountID == id
			and accountInfo.gameAccountInfo
			and accountInfo.gameAccountInfo.isOnline
		then
			local numGameAccounts = C_BattleNet_GetFriendNumGameAccounts(i)
			local name
			if numGameAccounts and numGameAccounts > 0 then
				for j = 1, numGameAccounts do
					if name then
						break
					end
					local gameAccountInfo = C_BattleNet_GetFriendGameAccountInfo(i, j)
					name = gameAccountInfo and getRetailCharacterNamesFromGameAccountInfo(gameAccountInfo)
				end
			else
				name = getRetailCharacterNamesFromGameAccountInfo(accountInfo.gameAccountInfo)
			end
			return name
		end
	end
end

CM.Features = {
	GUILD_INVITE = {
		order = 1,
		configKey = "guildInvite",
		name = L["Guild Invite"],
		supportTypes = {
			PARTY = true,
			PLAYER = true,
			RAID_PLAYER = true,
			RAID = true,
			FRIEND = true,
			ENEMY_PLAYER = true,
			BN_FRIEND = true,
			CHAT_ROSTER = true,
			TARGET = true,
			FOCUS = true,
			COMMUNITIES_WOW_MEMBER = true,
			RAF_RECRUIT = true,
		},
		func = function(contextData)
			if contextData.bnetIDAccount then
				local numBNOnlineFriend = select(2, BNGetNumFriends())
				for i = 1, numBNOnlineFriend do
					local accountInfo = C_BattleNet_GetFriendAccountInfo(i)
					if
						accountInfo
						and accountInfo.bnetAccountID == contextData.bnetIDAccount
						and accountInfo.gameAccountInfo
						and accountInfo.gameAccountInfo.isOnline
					then
						local numGameAccounts = C_BattleNet_GetFriendNumGameAccounts(i)
						if numGameAccounts and numGameAccounts > 0 then
							for j = 1, numGameAccounts do
								local gameAccountInfo = C_BattleNet_GetFriendGameAccountInfo(i, j)
								if
									gameAccountInfo.clientProgram
									and gameAccountInfo.clientProgram == "WoW"
									and gameAccountInfo.wowProjectID == 1
								then
									C_GuildInfo_Invite(
										gameAccountInfo.characterName .. "-" .. gameAccountInfo.realmName
									)
								end
							end
						elseif
							accountInfo.gameAccountInfo.clientProgram == "WoW"
							and accountInfo.gameAccountInfo.wowProjectID == 1
						then
							C_GuildInfo_Invite(
								accountInfo.gameAccountInfo.characterName
									.. "-"
									.. accountInfo.gameAccountInfo.realmName
							)
						end
						return
					end
				end
			elseif contextData.chatTarget then
				C_GuildInfo_Invite(contextData.chatTarget)
			elseif contextData.name then
				local playerName = contextData.name
				if contextData.server and contextData.server ~= E.myrealm then
					playerName = playerName .. "-" .. contextData.server
				end
				C_GuildInfo_Invite(playerName)
			else
				CM:Log("debug", "Cannot get the name.")
			end
		end,
		hidden = function(contextData)
			if not CanGuildInvite() then
				return true
			end

			if contextData.communityClubID then
				if tonumber(contextData.communityClubID) == tonumber(C_Club_GetGuildClubId()) then
					return true
				end
			end

			if contextData.which == "BN_FRIEND" then
				local name = contextData.bnetIDAccount and getRetailCharacterNamesByBNetID(contextData.bnetIDAccount)
				if not name then
					return true
				end
			end

			if contextData.unit and contextData.unit == "target" then
				if not UnitPlayerControlled("target") then
					return true
				end
			end

			if contextData.unit and contextData.unit == "focus" then
				if not UnitPlayerControlled("focus") then
					return true
				end
			end

			if contextData.name == E.myname then
				if not contextData.server or contextData.server == E.myrealm then
					return true
				end
			end

			return false
		end,
	},
	WHO = {
		order = 2,
		configKey = "who",
		name = _G.WHO,
		supportTypes = {
			PARTY = true,
			PLAYER = true,
			RAID_PLAYER = true,
			RAID = true,
			FRIEND = true,
			GUILD = true,
			GUILD_OFFLINE = true,
			CHAT_ROSTER = true,
			TARGET = true,
			ARENAENEMY = true,
			FOCUS = true,
			WORLD_STATE_SCORE = true,
			COMMUNITIES_WOW_MEMBER = true,
			COMMUNITIES_GUILD_MEMBER = true,
			RAF_RECRUIT = true,
		},
		func = function(contextData)
			if contextData.chatTarget then
				C_FriendList_SendWho(contextData.chatTarget)
			elseif contextData.name then
				local playerName = contextData.name
				if contextData.server and contextData.server ~= E.myrealm then
					playerName = playerName .. "-" .. contextData.server
				end
				C_FriendList_SendWho(playerName)
			else
				CM:Log("debug", "Cannot get the name.")
			end
		end,
		hidden = function(contextData)
			if contextData.unit and contextData.unit == "target" then
				if not UnitPlayerControlled("target") then
					return true
				end
			end

			if contextData.unit and contextData.unit == "focus" then
				if not UnitPlayerControlled("focus") then
					return true
				end
			end

			if contextData.name == E.myname then
				if not contextData.server or contextData.server == E.myrealm then
					return true
				end
			end

			return false
		end,
	},
	ARMORY = {
		order = 3,
		configKey = "armory",
		name = L["Armory"],
		supportTypes = {
			SELF = true,
			PARTY = true,
			PLAYER = true,
			RAID_PLAYER = true,
			RAID = true,
			FRIEND = true,
			GUILD = true,
			GUILD_OFFLINE = true,
			CHAT_ROSTER = true,
			TARGET = true,
			ARENAENEMY = true,
			FOCUS = true,
			WORLD_STATE_SCORE = true,
			COMMUNITIES_WOW_MEMBER = true,
			COMMUNITIES_GUILD_MEMBER = true,
			RAF_RECRUIT = true,
		},
		func = function(frame)
			local name = frame.name
			local server = frame.server or E.myrealm

			if name and server then
				-- Remove the single quote in the server name
				-- e.g. Mal'Ganis -> MalGanis
				local s = gsub(server, "'", "")
				local link = CM:GetArmoryBaseURL() .. s .. "/" .. name
				E:StaticPopup_Show("ELVUI_EDITBOX", nil, nil, link)
			else
				CM:Log("debug", "Cannot get the armory link.")
			end
		end,
		hidden = function(contextData)
			if contextData.unit and contextData.unit == "target" then
				if not UnitPlayerControlled("target") then
					return true
				end
			end

			if contextData.unit and contextData.unit == "focus" then
				if not UnitPlayerControlled("focus") then
					return true
				end
			end

			return false
		end,
	},
	REPORT_STATS = {
		order = 4,
		configKey = "reportStats",
		name = L["Report Stats"],
		supportTypes = {
			PARTY = true,
			PLAYER = true,
			RAID_PLAYER = true,
			FRIEND = true,
			BN_FRIEND = true,
			GUILD = true,
			CHAT_ROSTER = true,
			TARGET = true,
			FOCUS = true,
			COMMUNITIES_WOW_MEMBER = true,
			COMMUNITIES_GUILD_MEMBER = true,
			RAF_RECRUIT = true,
		},
		func = function(contextData)
			local name
			local _SendChatMessage = C_ChatInfo_SendChatMessage

			if contextData.bnetIDAccount then
				_SendChatMessage = function(message, chatType, languageID, target)
					BNSendWhisper(contextData.bnetIDAccount, message)
				end
				name = "BN"
			elseif contextData.chatTarget then
				name = contextData.chatTarget
			elseif contextData.name then
				name = contextData.name
				if contextData.server and contextData.server ~= E.myrealm then
					name = name .. "-" .. contextData.server
				end
			end

			if not name then
				CM:Log("debug", "Cannot get the name.")
				return
			end

			local CRITICAL = gsub(TEXT_MODE_A_STRING_RESULT_CRITICAL or STAT_CRITICAL_STRIKE, "[()]", "")

			for i, message in ipairs({
				format(
					"(%s) %s: %.1f %s: %s",
					select(2, C_SpecializationInfo_GetSpecializationInfo(C_SpecializationInfo_GetSpecialization()))
						.. select(1, UnitClass("player")),
					ITEM_LEVEL_ABBR,
					select(2, GetAverageItemLevel()),
					HP,
					AbbreviateNumbers(UnitHealthMax("player"))
				),
				format(" * %s: %.2f%%", CRITICAL, max(GetRangedCritChance(), GetCritChance(), GetSpellCritChance())),
				format(" * %s: %.2f%%", STAT_HASTE, GetHaste()),
				format(" * %s: %.2f%%", STAT_MASTERY, GetMasteryEffect()),
				format(
					" * %s: %.2f%%",
					STAT_VERSATILITY,
					GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)
				),
				format(" * %s:%.2f%%", STAT_LIFESTEAL, GetLifesteal()),
			}) do
				E:Delay(0.1 + i * 0.2, function()
					_SendChatMessage(message, "WHISPER", nil, name)
				end)
			end
		end,
		hidden = function(contextData)
			if contextData.unit and contextData.unit == "target" then
				if not UnitPlayerControlled("target") then
					return true
				end
			end

			if contextData.unit and contextData.unit == "focus" then
				if not UnitPlayerControlled("focus") then
					return true
				end
			end

			if contextData.name == E.myname then
				if not contextData.server or contextData.server == E.myrealm then
					return true
				end
			end

			return false
		end,
	},
}

CM.TypeToFeatureMap = {}
for feature, featureConfig in pairs(CM.Features) do
	for supportType in pairs(featureConfig.supportTypes) do
		if not CM.TypeToFeatureMap[supportType] then
			CM.TypeToFeatureMap[supportType] = {}
		end
		tinsert(CM.TypeToFeatureMap[supportType], feature)
	end
end

function CM:GetArmoryBaseURL()
	local language = strlower(W.Locale)
	if language == "zhcn" then
		language = "zhtw" -- There is no simplified Chinese armory
	end

	local region = self.db and self.db.armoryOverride[E.myrealm] or W.RealRegion
	if region == "CN" then
		region = "TW" -- Fix taiwan server region issue
	end
	region = strlower(region or "US")

	return format(
		"https://worldofwarcraft.com/%s-%s/character/%s/",
		strsub(language, 1, 2),
		strsub(language, 3, 4),
		region
	)
end

function CM:GetAvailableButtonTypes(contextData)
	if not contextData.which or not self.TypeToFeatureMap[contextData.which] then
		return
	end

	local features = {}
	for _, feature in pairs(self.TypeToFeatureMap[contextData.which]) do
		features[feature] = true
	end

	local availableButtonTypes = {}
	for feature in pairs(features) do
		if self.db[self.Features[feature].configKey] and self.Features[feature].hidden(contextData) ~= true then
			tinsert(availableButtonTypes, feature)
		end
	end

	sort(availableButtonTypes, function(a, b)
		return self.Features[a].order < self.Features[b].order
	end)

	return availableButtonTypes
end

function CM:ModifyMenu(_, rootDescription, contextData)
	if not self.db.enable then
		return
	end

	local availableButtonTypes = self:GetAvailableButtonTypes(contextData)

	if not availableButtonTypes or #availableButtonTypes == 0 then
		return
	end

	rootDescription:CreateDivider()
	if self.db.sectionTitle then
		rootDescription:CreateTitle(self.sectionName)
	end

	for _, feature in ipairs(availableButtonTypes) do
		local featureConfig = self.Features[feature]
		rootDescription:CreateButton(featureConfig.name, featureConfig.func, contextData)
	end
end

function CM:Initialize()
	self.db = E.db.WT.social.contextMenu
	if not self.db.enable or self.initialized then
		return
	end

	local sectionText = W.PlainTitle
	if not W.ChineseLocale then
		sectionText = sectionText .. " "
	end
	self.sectionName = F.GetWindStyleText(sectionText .. L["Menu"])

	for supportType in pairs(self.TypeToFeatureMap) do
		Menu_ModifyMenu("MENU_UNIT_" .. supportType, GenerateClosure(self.ModifyMenu, self))
	end

	self.initialized = true
end

CM.ProfileUpdate = CM.Initialize

W:RegisterModule(CM:GetName())
