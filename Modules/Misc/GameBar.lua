local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local GB = W:NewModule("GameBar", "AceEvent-3.0", "AceHook-3.0")
local DT = E:GetModule("DataTexts")

local _G = _G
local collectgarbage = collectgarbage
local date = date
local floor = floor
local format = format
local gsub = gsub
local ipairs = ipairs
local max = max
local min = min
local mod = mod
local pairs = pairs
local select = select
local strfind = strfind
local strjoin = strjoin
local tContains = tContains
local tinsert = tinsert
local tonumber = tonumber
local tostring = tostring
local type = type
local unpack = unpack

local BNGetNumFriends = BNGetNumFriends
local CloseAllWindows = CloseAllWindows
local CloseMenus = CloseMenus
local CreateFrame = CreateFrame
local CreateFromMixins = CreateFromMixins
local GenerateClosure = GenerateClosure
local GetGameTime = GetGameTime
local GetNumGuildMembers = GetNumGuildMembers
local GetTime = GetTime
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local IsControlKeyDown = IsControlKeyDown
local IsInGuild = IsInGuild
local IsModifierKeyDown = IsModifierKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local ItemMixin = ItemMixin
local PlaySound = PlaySound
local PlayerHasToy = PlayerHasToy
local RegisterStateDriver = RegisterStateDriver
local ResetCPUUsage = ResetCPUUsage
local Screenshot = Screenshot
local ShowUIPanel = ShowUIPanel
local ToggleCalendar = ToggleCalendar
local ToggleCharacter = ToggleCharacter
local ToggleFriendsFrame = ToggleFriendsFrame
local ToggleTimeManager = ToggleTimeManager
local UnregisterStateDriver = UnregisterStateDriver

local C_BattleNet_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
local C_BattleNet_GetFriendGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo
local C_BattleNet_GetFriendNumGameAccounts = C_BattleNet.GetFriendNumGameAccounts
local C_CVar_GetCVar = C_CVar.GetCVar
local C_CVar_GetCVarBool = C_CVar.GetCVarBool
local C_CVar_SetCVar = C_CVar.SetCVar
local C_CovenantSanctumUI_GetRenownLevel = C_CovenantSanctumUI.GetRenownLevel
local C_Covenants_GetActiveCovenantID = C_Covenants.GetActiveCovenantID
local C_FriendList_GetNumFriends = C_FriendList.GetNumFriends
local C_Garrison_GetCompleteMissions = C_Garrison.GetCompleteMissions
local C_Item_GetItemCooldown = C_Item.GetItemCooldown
local C_Item_GetItemCount = C_Item.GetItemCount
local C_Timer_NewTicker = C_Timer.NewTicker
local C_ToyBox_IsToyUsable = C_ToyBox.IsToyUsable
local C_UI_Reload = C_UI.Reload

local FollowerType_8_0 = Enum.GarrisonFollowerType.FollowerType_8_0_GarrisonFollower
local FollowerType_9_0 = Enum.GarrisonFollowerType.FollowerType_9_0_GarrisonFollower

local NUM_PANEL_BUTTONS = 7
local IconString = "|T%s:16:18:0:0:64:64:4:60:7:57"
local LeftButtonIcon = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t"
local RightButtonIcon = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:410|t"
local ScrollButtonIcon = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t"

local friendOnline = gsub(_G.ERR_FRIEND_ONLINE_SS, "\124Hplayer:%%s\124h%[%%s%]\124h", "")
local friendOffline = gsub(_G.ERR_FRIEND_OFFLINE_S, "%%s", "")

GB.AnimationManager = { frame = nil, groups = nil }

local hearthstones = {
	6948, -- 爐石
	54452, -- 以太傳送門
	64488, -- 旅店老闆的女兒
	93672, -- 黑暗之門
	142542, -- 城鎮傳送之書
	162973, -- 冬天爺爺的爐石
	163045, -- 無頭騎士的爐石
	165669, -- 新年長者的爐石
	165670, -- 傳播者充滿愛的爐石
	165802, -- 貴族園丁的爐石
	166746, -- 吞火者的爐石
	166747, -- 啤酒節狂歡者的爐石
	168907, -- 全像數位化爐石
	172179, -- 永恆旅人的爐石
	188952, -- 統御的爐石
	190196, -- 受啟迪的爐石
	190237, -- 仲介者傳送矩陣
	193588, -- 時光行者的爐石
	200630, -- 雍伊爾風之賢者爐石
	206195, -- 那魯之道
	208704, -- 深淵居者的大地爐石
	209035, -- 烈焰爐石
	212337, -- 爐石之石
	228940, -- 凶霸絲線爐石
	235016, -- 再部署模組
	236687, -- 爆炸爐石
	245970, -- 郵務主管的瞬移爐石
	246565, -- 宇宙爐石
}

local hearthstoneAndToyIDList = {
	-- Special Hearthstones
	6948, -- 爐石
	-- Hearthstones Toys
	-- https://www.wowhead.com/items?filter=107:216:17;0:1:-2324;%3CHearthstone+Location%3E:0:0
	54452, -- 以太傳送門
	64488, -- 旅店老闆的女兒
	93672, -- 黑暗之門
	142542, -- 城鎮傳送之書
	162973, -- 冬天爺爺的爐石
	163045, -- 無頭騎士的爐石
	165669, -- 新年長者的爐石
	165670, -- 傳播者充滿愛的爐石
	165802, -- 貴族園丁的爐石
	166746, -- 吞火者的爐石
	166747, -- 啤酒節狂歡者的爐石
	168907, -- 全像數位化爐石
	172179, -- 永恆旅人的爐石
	180290, -- 暗夜妖精的爐石
	182773, -- 死靈領主爐石
	183716, -- 汎希爾罪孽石
	184353, -- 琪瑞安爐石
	188952, -- 統御的爐石
	190196, -- 受啟迪的爐石
	190237, -- 仲介者傳送矩陣
	193588, -- 時光行者的爐石
	200630, -- 雍伊爾風之賢者爐石
	206195, -- 那魯之道
	208704, -- 深淵居者的大地爐石
	209035, -- 烈焰爐石
	210455, -- 德萊尼全像寶石
	212337, -- 爐石之石
	228940, -- 凶霸絲線爐石
	235016, -- 再部署模組
	236687, -- 爆炸爐石
	245970, -- 郵務主管的瞬移爐石
	246565, -- 宇宙爐石
	-- Patch Items
	110560, -- 要塞爐石
	140192, -- 達拉然爐石
	141605, -- 飛行管理員的哨子
	180817, -- 移轉暗語
	-- Engineering Wormholes
	-- https://www.wowhead.com/items/name:Generator?filter=86:195;5:2;0:0
	18984, -- 空間撕裂器 - 永望鎮
	18986, -- 安全傳送器:加基森
	30542, -- 空間撕裂器 - 52區
	30544, -- 安全傳送器:托斯利基地
	48933, -- 蟲洞產生器：北裂境
	87215, -- 蟲洞產生器：潘達利亞
	112059, -- 蟲洞離心裝置 (WoD)
	132517, -- 達拉然內部蟲洞產生器
	132524, -- 劫福斯蟲洞產生器模組
	151652, -- 蟲洞產生器：阿古斯
	168807, -- 蟲洞產生器：庫爾提拉斯
	168808, -- 蟲洞產生器：贊達拉
	172924, -- 蟲洞產生器：暗影之境
	198156, -- 龍洞產生器：巨龍群島
	221966, -- 蟲洞產生器：卡茲阿爾加
}

local hearthstonesAndToysData
local availableHearthstones

local function copyRGB(color, target)
	target.r = color.r
	target.g = color.g
	target.b = color.b
end

function GB.AnimationManager:Drop()
	self.frame = nil
	self.groups = nil
end

function GB.AnimationManager:DropIfMatched(frame, group)
	if frame and self.frame == frame or self.groups and tContains(self.groups, group) then
		self:Drop()
	end
end

function GB.AnimationManager:SetCurrent(frame, groups)
	if self.frame and self.frame ~= frame or self.groups and tContains(self.groups, groups[1]) then
		E:Delay(0.01, GB.AnimationOnLeave, GB, self.frame)
	end
	self.frame = frame
	self.groups = groups
end

local function animationReset(self)
	self.StartR, self.StartG, self.StartB = GB.normalRGB.r, GB.normalRGB.g, GB.normalRGB.b
	self.EndR, self.EndG, self.EndB = GB.mouseOverRGB.r, GB.mouseOverRGB.g, GB.mouseOverRGB.b
	self:SetChange(self.EndR - self.StartR, self.EndG - self.StartG, self.EndB - self.StartB)
	self:SetDuration(GB.animationDuration)
	self:SetEasing(GB.animationInEase)
	self:Reset()
end

local function animationSwitch(self, isEnterMode)
	local elapsed = min(max(0, self:GetProgressByTimer()), GB.animationDuration)
	self.Timer = isEnterMode == self.isEnterMode and elapsed or (GB.animationDuration - elapsed)
	local startRGB = isEnterMode and GB.normalRGB or GB.mouseOverRGB
	local endRGB = isEnterMode and GB.mouseOverRGB or GB.normalRGB
	self.StartR, self.StartG, self.StartB = startRGB.r, startRGB.g, startRGB.b
	self.EndR, self.EndG, self.EndB = endRGB.r, endRGB.g, endRGB.b
	self:SetChange(endRGB.r, endRGB.g, endRGB.b)
	self:SetEasing(isEnterMode and GB.animationInEase or GB.animationOutEase)
	self.isEnterMode = isEnterMode
end

local function copyAnimationData(self, target)
	target.StartR, target.StartG, target.StartB = self.StartR, self.StartG, self.StartB
	target.EndR, target.EndG, target.EndB = self.EndR, self.EndG, self.EndB
	target:SetChange(self:GetChange())
	target:SetDuration(self:GetDuration())
	target:SetEasing(self:GetEasing())
	target.Timer = self.Timer
	target.isEnterMode = self.isEnterMode
end

local function animationSetFinished(anim)
	anim:SetScript("OnFinished", function(self)
		if not self.isEnterMode then
			GB.AnimationManager:DropIfMatched(nil, self.Group)
		end
	end)
end

function GB:AnimationOnEnter(button)
	if button.mainTex then
		local group, anim = button.mainTex.group, button.mainTex.group.anim
		if group:IsPlaying() then
			group:Pause()
		end

		animationSwitch(anim, true)
		group:Play()

		self.AnimationManager:SetCurrent(button, { group })
		return
	end

	if button.hour and button.minutes then
		local group1, anim1 = button.hour.group, button.hour.group.anim
		local group2, anim2 = button.minutes.group, button.minutes.group.anim
		if group1:IsPlaying() then
			group1:Pause()
		end
		if group2:IsPlaying() then
			group2:Pause()
		end

		animationSwitch(anim1, true)
		copyAnimationData(anim1, anim2)
		group1:Play()
		group2:Play()

		self.AnimationManager:SetCurrent(button, { group1, group2 })
	end
end
function GB:AnimationOnLeave(button)
	if button.mainTex then
		local group, anim = button.mainTex.group, button.mainTex.group.anim
		if group:IsPlaying() then
			group:Pause()
		end

		animationSwitch(anim, false)
		group:Play()
	end

	if button.hour and button.minutes then
		local group1, anim1 = button.hour.group, button.hour.group.anim
		local group2, anim2 = button.minutes.group, button.minutes.group.anim
		if group1:IsPlaying() then
			group1:Pause()
		end
		if group2:IsPlaying() then
			group2:Pause()
		end

		animationSwitch(anim1, false)
		animationSwitch(anim2, false)
		group1:Play()
		group2:Play()
	end
end

local function AddDoubleLineForItem(itemID, prefix)
	local isRandomHearthstone
	if type(itemID) == "string" then
		if itemID == "RANDOM" then
			isRandomHearthstone = true
			itemID = 6948
		else
			itemID = tonumber(itemID)
		end
	end

	prefix = prefix and prefix .. " " or ""

	local data = hearthstonesAndToysData[tostring(itemID)]
	if not data then
		return
	end

	local icon = format(IconString .. ":255:255:255|t", data.icon)
	local startTime, duration = C_Item_GetItemCooldown(itemID)
	local cooldownTime = startTime + duration - GetTime()
	local canUse = cooldownTime <= 0
	local cooldownTimeString
	if not canUse then
		local m = floor(cooldownTime / 60)
		local s = floor(mod(cooldownTime, 60))
		cooldownTimeString = format("%02d:%02d", m, s)
	end

	local name = data.name
	if itemID == 180817 then
		local charge = C_Item_GetItemCount(itemID, nil, true)
		name = name .. format(" (%d)", charge)
	end

	if isRandomHearthstone then
		name = L["Random Hearthstone"]
	end

	DT.tooltip:AddDoubleLine(
		prefix .. icon .. " " .. name,
		canUse and L["Ready"] or cooldownTimeString,
		1,
		1,
		1,
		canUse and 0 or 1,
		canUse and 1 or 0,
		0
	)
end

-- Fake DataText for no errors throwed from ElvUI
local VirtualDTEvent = {
	Friends = nil,
	Guild = "GUILD_ROSTER_UPDATE",
	Time = "UPDATE_INSTANCE_INFO",
}

local VirtualDT = {
	Friends = {
		name = "Friends",
		text = {
			SetFormattedText = E.noop,
		},
	},
	System = {
		name = "System",
	},
	Time = {
		name = "Time",
		text = {
			SetFormattedText = E.noop,
		},
	},
	Guild = {
		name = "Guild",
		text = {
			SetFormattedText = E.noop,
			SetText = E.noop,
		},
		GetScript = function()
			return E.noop
		end,
		IsMouseOver = function()
			return false
		end,
	},
}

local sharedCache = {
	friends = {},
}

local ButtonTypes = {
	ACHIEVEMENTS = {
		name = L["Achievements"],
		icon = W.Media.Icons.barAchievements,
		macro = {
			LeftButton = _G.SLASH_ACHIEVEMENTUI1,
		},
		tooltips = {
			L["Achievements"],
		},
	},
	BAGS = {
		name = L["Bags"],
		icon = W.Media.Icons.barBags,
		click = {
			LeftButton = function()
				_G.ToggleAllBags()
			end,
		},
		tooltips = "Bags",
	},
	BLIZZARD_SHOP = {
		name = L["Blizzard Shop"],
		icon = W.Media.Icons.barBlizzardShop,
		click = {
			LeftButton = function()
				_G.StoreMicroButton:Click()
			end,
		},
		tooltips = {
			L["Blizzard Shop"],
		},
	},
	CHARACTER = {
		name = L["Character"],
		icon = W.Media.Icons.barCharacter,
		click = {
			LeftButton = function()
				if not InCombatLockdown() then
					ToggleCharacter("PaperDollFrame")
				else
					_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
				end
			end,
		},
		tooltips = {
			L["Character"],
		},
	},
	COLLECTIONS = {
		name = L["Collections"],
		icon = W.Media.Icons.barCollections,
		macro = {
			LeftButton = "/click CollectionsJournalCloseButton\n/click CollectionsMicroButton\n/click CollectionsJournalTab1",
			RightButton = "/run C_MountJournal.SummonByID(0)",
		},
		tooltips = {
			L["Collections"],
			"\n",
			LeftButtonIcon .. " " .. L["Show Collections"],
			RightButtonIcon .. " " .. L["Random Favorite Mount"],
		},
	},
	ENCOUNTER_JOURNAL = {
		name = L["Encounter Journal"],
		icon = W.Media.Icons.barEncounterJournal,
		macro = {
			LeftButton = "/click EJMicroButton",
			RightButton = "/run WeeklyRewards_ShowUI()",
		},
		tooltips = {
			LeftButtonIcon .. " " .. L["Encounter Journal"],
			RightButtonIcon .. " " .. L["Weekly Rewards"],
		},
	},
	FRIENDS = {
		name = L["Friend List"],
		icon = W.Media.Icons.barFriends,
		click = {
			LeftButton = function()
				if not InCombatLockdown() then
					ToggleFriendsFrame(1)
				else
					_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
				end
			end,
		},
		additionalText = function()
			local numBNOnline, numWoWOnline = 0, 0

			for i = 1, BNGetNumFriends() do
				local accountInfo = C_BattleNet_GetFriendAccountInfo(i)
				if accountInfo and accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.isOnline then
					local numGameAccounts = C_BattleNet_GetFriendNumGameAccounts(i)
					numBNOnline = numBNOnline + 1
					if numGameAccounts and numGameAccounts > 0 then
						for j = 1, numGameAccounts do
							local gameAccountInfo = C_BattleNet_GetFriendGameAccountInfo(i, j)
							if gameAccountInfo.clientProgram and gameAccountInfo.clientProgram == "WoW" then
								numWoWOnline = numWoWOnline + 1
							end
						end
					elseif accountInfo.gameAccountInfo.clientProgram == "WoW" then
						numWoWOnline = numWoWOnline + 1
					end
				end
			end

			local result
			if GB and GB.db and GB.db.friends and GB.db.friends.showAllFriends then
				local friendsOnline = C_FriendList_GetNumFriends() or 0
				result = friendsOnline + numBNOnline
			else
				result = numWoWOnline
			end

			return result > 0 and result or ""
		end,
		tooltips = "Friends",
		events = {
			"BN_FRIEND_ACCOUNT_ONLINE",
			"BN_FRIEND_ACCOUNT_OFFLINE",
			"BN_FRIEND_INFO_CHANGED",
			"FRIENDLIST_UPDATE",
			"CHAT_MSG_SYSTEM",
		},
		eventHandler = function(button, event, message)
			if event == "CHAT_MSG_SYSTEM" then
				if not (strfind(message, friendOnline) or strfind(message, friendOffline)) then
					return
				end
			end
			local now = GetTime()
			local cache = sharedCache.friends
			if now - (cache.lastEvent or 0) > 1 then
				cache.lastEvent = now
				E:Delay(1, function()
					button.additionalText:SetFormattedText(button.additionalTextFormat, button.additionalTextFunc())
				end)
			end
		end,
	},
	GAMEMENU = {
		name = L["Game Menu"],
		icon = W.Media.Icons.barGameMenu,
		click = {
			LeftButton = function()
				if not InCombatLockdown() then
					-- Open game menu | From ElvUI
					if not _G.GameMenuFrame:IsShown() then
						CloseMenus()
						CloseAllWindows()
						PlaySound(850) --IG_MAINMENU_OPEN
						ShowUIPanel(_G.GameMenuFrame)
					else
						PlaySound(854) --IG_MAINMENU_QUIT
						HideUIPanel(_G.GameMenuFrame)
					end
				else
					_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
				end
			end,
		},
		tooltips = {
			L["Game Menu"],
		},
	},
	GROUP_FINDER = {
		name = L["Group Finder"],
		icon = W.Media.Icons.barGroupFinder,
		macro = {
			LeftButton = "/click LFDMicroButton",
		},
		tooltips = {
			L["Group Finder"],
		},
	},
	GUILD = {
		name = L["Guild"],
		icon = W.Media.Icons.barGuild,
		macro = {
			LeftButton = "/click GuildMicroButton",
			RightButton = "/script if not InCombatLockdown() then if not GuildFrame or not GuildFrame:IsShown() then ToggleGuildFrame() end end",
		},
		additionalText = function()
			return IsInGuild() and select(2, GetNumGuildMembers()) or ""
		end,
		tooltips = "Guild",
		events = {
			"GUILD_ROSTER_UPDATE",
			"PLAYER_GUILD_UPDATE",
		},
		eventHandler = function(button, event, message)
			button.additionalText:SetFormattedText(button.additionalTextFormat, button.additionalTextFunc())
		end,
		notification = true,
	},
	HOME = {
		name = L["Home"],
		icon = W.Media.Icons.barHome,
		item = {},
		tooltips = function(button)
			DT.tooltip:ClearLines()
			DT.tooltip:SetText(L["Home"])
			DT.tooltip:AddLine("\n")
			AddDoubleLineForItem(GB.db.home.left, LeftButtonIcon)
			AddDoubleLineForItem(GB.db.home.right, RightButtonIcon)
			DT.tooltip:Show()

			button.tooltipsUpdateTimer = C_Timer_NewTicker(1, function()
				DT.tooltip:ClearLines()
				DT.tooltip:SetText(L["Home"])
				DT.tooltip:AddLine("\n")
				AddDoubleLineForItem(GB.db.home.left, LeftButtonIcon)
				AddDoubleLineForItem(GB.db.home.right, RightButtonIcon)
				DT.tooltip:Show()
			end)
		end,
		tooltipsLeave = function(button)
			if button.tooltipsUpdateTimer and button.tooltipsUpdateTimer.Cancel then
				button.tooltipsUpdateTimer:Cancel()
			end
		end,
	},
	MISSION_REPORTS = {
		name = L["Mission Reports"],
		icon = W.Media.Icons.barMissionReports,
		click = {
			LeftButton = function(button)
				DT.RegisteredDataTexts["Missions"].onClick(button)
			end,
		},
		additionalText = function()
			local numMissions = #C_Garrison_GetCompleteMissions(FollowerType_9_0)
				+ #C_Garrison_GetCompleteMissions(FollowerType_8_0)
			if numMissions == 0 then
				numMissions = ""
			end
			return numMissions
		end,
		tooltips = "Missions",
	},
	NONE = {
		name = L["None"],
	},
	PET_JOURNAL = {
		name = L["Pet Journal"],
		icon = W.Media.Icons.barPetJournal,
		macro = {
			LeftButton = "/click CollectionsJournalCloseButton\n/click CollectionsMicroButton\n/click CollectionsJournalTab2",
			RightButton = "/run C_PetJournal.SummonRandomPet(C_PetJournal.HasFavoritePets());",
		},
		tooltips = {
			L["Pet Journal"],
			"\n",
			LeftButtonIcon .. " " .. L["Show Pet Journal"],
			RightButtonIcon .. " " .. L["Random Favorite Pet"],
		},
	},
	PROFESSION = {
		name = L["Profession"],
		icon = W.Media.Icons.barProfession,
		click = {
			LeftButton = function()
				if not InCombatLockdown() then
					_G.ToggleProfessionsBook()
				else
					_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
				end
			end,
		},
		tooltips = {
			L["Profession"],
		},
	},
	SCREENSHOT = {
		name = L["Screenshot"],
		icon = W.Media.Icons.barScreenShot,
		click = {
			LeftButton = function()
				DT.tooltip:Hide()
				Screenshot()
			end,
			RightButton = function()
				E:Delay(2, function()
					Screenshot()
				end)
			end,
		},
		tooltips = {
			L["Screenshot"],
			"\n",
			LeftButtonIcon .. " " .. L["Screenshot immediately"],
			RightButtonIcon .. " " .. L["Screenshot after 2 secs"],
		},
	},
	SPELLBOOK = {
		name = L["Spell Book"],
		icon = W.Media.Icons.barSpellBook,
		click = {
			LeftButton = function()
				if not InCombatLockdown() then
					_G.PlayerSpellsUtil.ToggleSpellBookFrame()
				else
					_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
				end
			end,
		},
		tooltips = {
			L["Spell Book"],
		},
	},
	TALENTS = {
		name = L["Talents"],
		icon = W.Media.Icons.barTalents,
		click = {
			LeftButton = function()
				if not InCombatLockdown() then
					_G.PlayerSpellsUtil.ToggleClassTalentFrame()
				else
					_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
				end
			end,
		},
		tooltips = {
			L["Talents"],
		},
	},
	TOY_BOX = {
		name = L["Toy Box"],
		icon = W.Media.Icons.barToyBox,
		macro = {
			LeftButton = "/click CollectionsJournalCloseButton\n/click CollectionsMicroButton\n/click CollectionsJournalTab3",
		},
		tooltips = {
			L["Toy Box"],
		},
	},
	VOLUME = {
		name = L["Volume"],
		icon = W.Media.Icons.barVolume,
		click = {
			LeftButton = function()
				local vol = C_CVar_GetCVar("Sound_MasterVolume")
				vol = vol and tonumber(vol) or 0
				C_CVar_SetCVar("Sound_MasterVolume", min(vol + 0.1, 1))
			end,
			MiddleButton = function()
				local enabled = tonumber(C_CVar_GetCVar("Sound_EnableAllSound")) == 1
				C_CVar_SetCVar("Sound_EnableAllSound", enabled and 0 or 1)
			end,
			RightButton = function()
				local vol = C_CVar_GetCVar("Sound_MasterVolume")
				vol = vol and tonumber(vol) or 0
				C_CVar_SetCVar("Sound_MasterVolume", max(vol - 0.1, 0))
			end,
		},
		tooltips = function(button)
			local vol = C_CVar_GetCVar("Sound_MasterVolume")
			vol = vol and tonumber(vol) or 0
			DT.tooltip:ClearLines()
			DT.tooltip:SetText(L["Volume"] .. format(": %d%%", vol * 100))
			DT.tooltip:AddLine("\n")
			DT.tooltip:AddLine(LeftButtonIcon .. " " .. L["Increase the volume"] .. " (+10%)", 1, 1, 1)
			DT.tooltip:AddLine(RightButtonIcon .. " " .. L["Decrease the volume"] .. " (-10%)", 1, 1, 1)
			DT.tooltip:AddLine(ScrollButtonIcon .. " " .. L["Sound ON/OFF"], 1, 1, 1)
			DT.tooltip:Show()

			button.tooltipsUpdateTimer = C_Timer_NewTicker(0.3, function()
				local _vol = C_CVar_GetCVar("Sound_MasterVolume")
				_vol = _vol and tonumber(_vol) or 0
				DT.tooltip:ClearLines()
				DT.tooltip:SetText(L["Volume"] .. format(": %d%%", _vol * 100))
				DT.tooltip:AddLine("\n")
				DT.tooltip:AddLine(LeftButtonIcon .. " " .. L["Increase the volume"] .. " (+10%)", 1, 1, 1)
				DT.tooltip:AddLine(RightButtonIcon .. " " .. L["Decrease the volume"] .. " (-10%)", 1, 1, 1)
				DT.tooltip:AddLine(ScrollButtonIcon .. " " .. L["Sound ON/OFF"], 1, 1, 1)
				DT.tooltip:Show()
			end)
		end,
		tooltipsLeave = function(button)
			if button.tooltipsUpdateTimer and button.tooltipsUpdateTimer.Cancel then
				button.tooltipsUpdateTimer:Cancel()
			end
		end,
	},
}

function GB:OnEnter()
	if self.db and self.db.mouseOver then
		E:UIFrameFadeIn(self.bar, self.db.fadeTime, self.bar:GetAlpha(), 1)
	end
end

function GB:OnLeave()
	if self.db and self.db.mouseOver then
		E:UIFrameFadeOut(self.bar, self.db.fadeTime, self.bar:GetAlpha(), 0)
	end
end

function GB:ConstructBar()
	if self.bar then
		return
	end

	local bar = CreateFrame("Frame", "WTGameBar", E.UIParent)
	bar:SetSize(800, 60)
	bar:SetPoint("TOP", 0, -20)
	bar:SetFrameStrata("MEDIUM")

	bar:SetScript("OnEnter", GenerateClosure(self.OnEnter, self))
	bar:SetScript("OnLeave", GenerateClosure(self.OnLeave, self))

	local middlePanel = CreateFrame("Button", "WTGameBarMiddlePanel", bar, "SecureActionButtonTemplate")
	middlePanel:SetSize(81, 50)
	middlePanel:SetPoint("CENTER")
	middlePanel:CreateBackdrop("Transparent")
	middlePanel:RegisterForClicks(W.UseKeyDown and "AnyDown" or "AnyUp")
	bar.middlePanel = middlePanel

	local leftPanel = CreateFrame("Frame", "WTGameBarLeftPanel", bar)
	leftPanel:SetSize(300, 40)
	leftPanel:SetPoint("RIGHT", middlePanel, "LEFT", -10, 0)
	leftPanel:CreateBackdrop("Transparent")
	bar.leftPanel = leftPanel

	local rightPanel = CreateFrame("Frame", "WTGameBarRightPanel", bar)
	rightPanel:SetSize(300, 40)
	rightPanel:SetPoint("LEFT", middlePanel, "RIGHT", 10, 0)
	rightPanel:CreateBackdrop("Transparent")
	bar.rightPanel = rightPanel

	S:CreateShadowModule(leftPanel.backdrop)
	S:CreateShadowModule(middlePanel.backdrop)
	S:CreateShadowModule(rightPanel.backdrop)
	S:MerathilisUISkin(leftPanel.backdrop)
	S:MerathilisUISkin(middlePanel.backdrop)
	S:MerathilisUISkin(rightPanel.backdrop)

	self.bar = bar

	E:CreateMover(self.bar, "WTGameBarAnchor", L["Game Bar"], nil, nil, nil, "ALL,WINDTOOLS", function()
		return GB.db and GB.db.enable
	end, "WindTools,misc,gameBar")
end

function GB:UpdateBar()
	if self.db and self.db.mouseOver then
		self.bar:SetAlpha(0)
	else
		self.bar:SetAlpha(1)
	end

	RegisterStateDriver(self.bar, "visibility", self.db.visibility)
end

function GB:ConstructTimeArea()
	local colon = self.bar.middlePanel:CreateFontString(nil, "OVERLAY")
	colon:SetPoint("CENTER")
	F.SetFontWithDB(colon, self.db.time.font)
	self.bar.middlePanel.colon = colon

	local hour = self.bar.middlePanel:CreateFontString(nil, "OVERLAY")
	hour:SetPoint("RIGHT", colon, "LEFT", 1, 0)
	F.SetFontWithDB(hour, self.db.time.font)
	self.bar.middlePanel.hour = hour

	hour.group = _G.CreateAnimationGroup(hour)
	hour.group.anim = hour.group:CreateAnimation("color")
	hour.group.anim:SetColorType("text")
	animationSetFinished(hour.group.anim)

	local minutes = self.bar.middlePanel:CreateFontString(nil, "OVERLAY")
	minutes:SetPoint("LEFT", colon, "RIGHT", 0, 0)
	F.SetFontWithDB(minutes, self.db.time.font)
	self.bar.middlePanel.minutes = minutes

	minutes.group = _G.CreateAnimationGroup(minutes)
	minutes.group.anim = minutes.group:CreateAnimation("color")
	minutes.group.anim:SetColorType("text")

	local text = self.bar.middlePanel:CreateFontString(nil, "OVERLAY")
	text:SetPoint("TOP", self.bar, "BOTTOM", 0, -5)
	F.SetFontWithDB(text, self.db.additionalText.font)
	text:SetAlpha(self.db.time.alwaysSystemInfo and 1 or 0)
	self.bar.middlePanel.text = text

	self.bar.middlePanel:SetSize(self.db.timeAreaWidth, self.db.timeAreaHeight)

	self:UpdateTime()
	self.timeAreaUpdateTimer = C_Timer_NewTicker(self.db.time.interval, function()
		GB:UpdateTime()
	end)

	DT.RegisteredDataTexts["Time"].eventFunc(VirtualDT["Time"], "ELVUI_FORCE_UPDATE")
	DT.RegisteredDataTexts["System"].onUpdate(self.bar.middlePanel, 10)

	if self.db.time.alwaysSystemInfo then
		self.alwaysSystemInfoTimer = C_Timer_NewTicker(1, function()
			DT.RegisteredDataTexts["System"].onUpdate(self.bar.middlePanel, 10)
		end)
	end

	self:HookScript(self.bar.middlePanel, "OnEnter", function(panel)
		self:OnEnter()
		self:AnimationOnEnter(panel)

		DT.RegisteredDataTexts["System"].onUpdate(panel, 10)
		if not self.db.time.alwaysSystemInfo then
			E:UIFrameFadeIn(panel.text, self.db.fadeTime, panel.text:GetAlpha(), 1)
		end

		if self.db.tooltipsAnchor == "ANCHOR_TOP" then
			DT.tooltip:SetOwner(panel, "ANCHOR_TOP", 0, 10)
		else
			DT.tooltip:SetOwner(panel.text, "ANCHOR_BOTTOM", 0, -10)
		end

		if IsModifierKeyDown() then
			DT.RegisteredDataTexts["System"].eventFunc()
			DT.RegisteredDataTexts["System"].onEnter()

			self.tooltipTimer = C_Timer_NewTicker(1, function()
				DT.RegisteredDataTexts["System"].onUpdate(panel, 10)
				DT.RegisteredDataTexts["System"].eventFunc()
				DT.RegisteredDataTexts["System"].onEnter()
			end)
		else
			DT.RegisteredDataTexts["Time"].eventFunc(VirtualDT["Time"], VirtualDTEvent["Time"])
			DT.RegisteredDataTexts["Time"].onEnter()
			DT.RegisteredDataTexts["Time"].onLeave()

			self.tooltipTimer = C_Timer_NewTicker(1, function()
				DT.RegisteredDataTexts["System"].onUpdate(panel, 10)
			end)

			DT.tooltip:AddLine("\n")
			DT.tooltip:AddDoubleLine(format("%s %s", LeftButtonIcon, L["Left Button"]), L["Calendar"], 1, 1, 1)
			DT.tooltip:AddDoubleLine(format("%s %s", RightButtonIcon, L["Right Button"]), L["Time Manager"], 1, 1, 1)
			DT.tooltip:AddDoubleLine(format("%s %s", ScrollButtonIcon, L["Middle Button"]), L["Reload UI"], 1, 1, 1)
			DT.tooltip:AddDoubleLine(format("Shift + %s", L["Any"]), L["Collect Garbage"], 1, 1, 1)
			DT.tooltip:AddDoubleLine(format("Ctrl + Shift + %s", L["Any"]), L["Toggle CPU Profiling"], 1, 1, 1)

			DT.tooltip:Show()
		end
	end)

	self:HookScript(self.bar.middlePanel, "OnLeave", function(panel)
		self:OnLeave()
		self:AnimationOnLeave(panel)

		if not self.db.time.alwaysSystemInfo then
			E:UIFrameFadeOut(panel.text, self.db.fadeTime, panel.text:GetAlpha(), 0)
		end

		DT.RegisteredDataTexts["System"].onLeave()
		DT.tooltip:Hide()
		self.tooltipTimer:Cancel()
	end)

	self.bar.middlePanel:SetScript("OnClick", function(_, mouseButton)
		if IsShiftKeyDown() then
			if IsControlKeyDown() then
				C_CVar_SetCVar("scriptProfile", C_CVar_GetCVarBool("scriptProfile") and 0 or 1)
				C_UI_Reload()
			else
				collectgarbage("collect")
				ResetCPUUsage()
				DT.RegisteredDataTexts["System"].eventFunc()
				DT.RegisteredDataTexts["System"].onEnter()
			end
		elseif mouseButton == "LeftButton" then
			if not InCombatLockdown() then
				ToggleCalendar()
			else
				_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
			end
		elseif mouseButton == "RightButton" then
			ToggleTimeManager()
		elseif mouseButton == "MiddleButton" then
			C_UI_Reload()
		end
	end)
end

function GB:UpdateTimeTicker()
	self.timeAreaUpdateTimer:Cancel()
	self.timeAreaUpdateTimer = C_Timer_NewTicker(self.db.time.interval, function()
		GB:UpdateTime()
	end)
end
function GB:UpdateTime()
	local panel = self.bar.middlePanel
	if not panel or not self.db or not self.db.time or not self.db.additionalText then
		return
	end

	F.SetFontWithDB(panel.hour, self.db.time.font)
	F.SetFontWithDB(panel.minutes, self.db.time.font)
	F.SetFontWithDB(panel.colon, self.db.time.font)
	F.SetFontWithDB(panel.text, self.db.additionalText.font)

	panel.hour.group:Stop()
	animationReset(panel.hour.group.anim)
	panel.hour.group.anim.isEnterMode = true

	panel.minutes.group:Stop()
	animationReset(panel.minutes.group.anim)
	panel.minutes.group.anim.isEnterMode = true

	local hour, minute

	if self.db.time.localTime then
		hour = self.db.time.twentyFour and date("%H") or date("%I")
		minute = date("%M")
	else
		hour, minute = GetGameTime()
		hour = self.db.time.twentyFour and hour or mod(hour, 12)
		hour = format("%02d", hour)
		minute = format("%02d", minute)
	end

	panel.colon:SetText(F.CreateColorString(":", self.mouseOverRGB))
	panel.hour:SetText(hour)
	panel.minutes:SetText(minute)
	panel.colon:ClearAllPoints()

	local offset = (panel.hour:GetStringWidth() - panel.minutes:GetStringWidth()) / 2
	panel.colon:SetPoint("CENTER", offset, -1)
end

function GB:UpdateTimeArea()
	local panel = self.bar.middlePanel

	if self.db.time.flash then
		E:Flash(panel.colon, 1, true)
	else
		E:StopFlash(panel.colon)
	end

	panel.text:ClearAllPoints()
	if self.db.tooltipsAnchor == "ANCHOR_TOP" then
		panel.text:SetPoint("BOTTOM", self.bar, "TOP", 0, 5)
	else
		panel.text:SetPoint("TOP", self.bar, "BOTTOM", 0, -5)
	end

	if self.db.time.alwaysSystemInfo then
		DT.RegisteredDataTexts["System"].onUpdate(panel, 10)
		panel.text:SetAlpha(1)
		if not self.alwaysSystemInfoTimer or self.alwaysSystemInfoTimer:IsCancelled() then
			self.alwaysSystemInfoTimer = C_Timer_NewTicker(1, function()
				DT.RegisteredDataTexts["System"].onUpdate(panel, 10)
			end)
		end
	else
		panel.text:SetAlpha(0)
		if self.alwaysSystemInfoTimer and not self.alwaysSystemInfoTimer:IsCancelled() then
			self.alwaysSystemInfoTimer:Cancel()
		end
	end

	self:UpdateTime()
end

function GB:ButtonOnEnter(button)
	self:AnimationOnEnter(button)
	self:OnEnter()
	if button.tooltips then
		if self.db.tooltipsAnchor == "ANCHOR_TOP" then
			DT.tooltip:SetOwner(button, "ANCHOR_TOP", 0, 20)
		else
			DT.tooltip:SetOwner(button, "ANCHOR_BOTTOM", 0, -10)
		end

		if type(button.tooltips) == "table" then
			DT.tooltip:ClearLines()
			for index, line in ipairs(button.tooltips) do
				if index == 1 then
					DT.tooltip:SetText(line)
				else
					DT.tooltip:AddLine(line, 1, 1, 1)
				end
			end
			DT.tooltip:Show()
		elseif type(button.tooltips) == "string" then
			local DTModule = DT.RegisteredDataTexts[button.tooltips]

			if VirtualDT[button.tooltips] and DTModule.eventFunc then
				DTModule.eventFunc(VirtualDT[button.tooltips], VirtualDTEvent[button.tooltips])
			end

			if DTModule and DTModule.onEnter then
				DTModule.onEnter()
			end

			-- If ElvUI Datatext tooltip not shown, display a simple information (e.g. button name) to player
			if not DT.tooltip:IsShown() then
				DT.tooltip:ClearLines()
				DT.tooltip:SetText(button.name)
				DT.tooltip:Show()
			end
		elseif type(button.tooltips) == "function" then
			button.tooltips(button)
		end
	end
end

function GB:ButtonOnLeave(button)
	self:AnimationOnLeave(button)
	self:OnLeave()
	DT.tooltip:Hide()
	if button.tooltipsLeave then
		button.tooltipsLeave(button)
	end
end

function GB:ConstructButton()
	if not self.bar then
		return
	end

	local button = CreateFrame("Button", nil, self.bar, "SecureActionButtonTemplate")
	button:SetSize(self.db.buttonSize, self.db.buttonSize)
	button:RegisterForClicks(W.UseKeyDown and "AnyDown" or "AnyUp")

	local mainTex = button:CreateTexture(nil, "ARTWORK")
	mainTex:SetPoint("CENTER")
	mainTex:SetSize(self.db.buttonSize, self.db.buttonSize)
	mainTex.group = _G.CreateAnimationGroup(mainTex)
	mainTex.group.anim = mainTex.group:CreateAnimation("color")
	mainTex.group.anim:SetColorType("vertex")
	animationSetFinished(mainTex.group.anim)
	button.mainTex = mainTex

	local notificationTex = button:CreateTexture(nil, "OVERLAY")
	notificationTex:SetTexture(W.Media.Icons.barNotification)
	notificationTex:SetPoint("TOPRIGHT")
	notificationTex:SetSize(0.38 * self.db.buttonSize, 0.38 * self.db.buttonSize)
	button.notificationTex = notificationTex

	local additionalText = button:CreateFontString(nil, "OVERLAY")
	additionalText:SetPoint(self.db.additionalText.anchor, self.db.additionalText.x, self.db.additionalText.y)
	F.SetFontWithDB(additionalText, self.db.additionalText.font)
	additionalText:SetJustifyH("CENTER")
	additionalText:SetJustifyV("MIDDLE")
	button.additionalText = additionalText

	self:HookScript(button, "OnEnter", "ButtonOnEnter")
	self:HookScript(button, "OnLeave", "ButtonOnLeave")

	tinsert(self.buttons, button)
end

function GB:UpdateButton(button, buttonType)
	if InCombatLockdown() then
		return
	end

	local config = ButtonTypes[buttonType]
	button:SetSize(self.db.buttonSize, self.db.buttonSize)
	button.type = buttonType
	button.name = config.name
	button.tooltips = config.tooltips
	button.tooltipsLeave = config.tooltipsLeave

	-- Click
	if
		buttonType == "HOME"
		and (config.item.item1 == L["Random Hearthstone"] or config.item.item2 == L["Random Hearthstone"])
	then
		button:SetAttribute("type*", "macro")
		self:HandleRandomHomeButton(button, "left", config.item.item1)
		self:HandleRandomHomeButton(button, "right", config.item.item2)
	elseif config.macro then
		button:SetAttribute("type*", "macro")
		button:SetAttribute("macrotext1", config.macro.LeftButton or "")
		button:SetAttribute("macrotext2", config.macro.RightButton or config.macro.LeftButton or "")
	elseif config.click then
		button.Click = function(_, mouseButton)
			local func = mouseButton and config.click[mouseButton] or config.click.LeftButton
			func(GB.bar.middlePanel)
		end
		button:SetAttribute("type*", "click")
		button:SetAttribute("clickbutton", button)
	elseif config.item then
		button:SetAttribute("type*", "item")
		button:SetAttribute("item1", config.item.item1 or "")
		button:SetAttribute("item2", config.item.item2 or "")
	end

	-- Normal
	button.mainTex.group:Stop()
	button.mainTex:SetTexture(config.icon)
	button.mainTex:SetSize(self.db.buttonSize, self.db.buttonSize)
	animationReset(button.mainTex.group.anim)
	button.mainTex.group.anim.isEnterMode = true

	-- Additional text
	if button.registeredEvents then
		for _, event in pairs(button.registeredEvents) do
			button:UnregisterEvent(event)
		end
	end

	button:SetScript("OnEvent", nil)
	button.registeredEvents = nil
	button.additionalTextFunc = nil

	if button.additionalTextTimer and not button.additionalTextTimer:IsCancelled() then
		button.additionalTextTimer:Cancel()
	end

	button.additionalTextFormat = F.CreateColorString("%s", self.mouseOverRGB)

	if config.additionalText and self.db.additionalText.enable then
		button.additionalText:SetFormattedText(
			button.additionalTextFormat,
			config.additionalText and config.additionalText() or ""
		)

		if config.events and config.eventHandler then
			button:SetScript("OnEvent", config.eventHandler)
			button.additionalTextFunc = config.additionalText
			button.registeredEvents = {}
			for _, event in pairs(config.events) do
				button:RegisterEvent(event)
				tinsert(button.registeredEvents, event)
			end
		else
			button.additionalTextTimer = C_Timer_NewTicker(self.db.additionalText.slowMode and 10 or 1, function()
				button.additionalText:SetFormattedText(
					button.additionalTextFormat,
					config.additionalText and config.additionalText() or ""
				)
			end)
		end

		button.additionalText:ClearAllPoints()
		button.additionalText:SetPoint(
			self.db.additionalText.anchor,
			self.db.additionalText.x,
			self.db.additionalText.y
		)
		F.SetFontWithDB(button.additionalText, self.db.additionalText.font)
		button.additionalText:Show()
	else
		button.additionalText:Hide()
	end

	button.notificationTex:Hide()
	if config.notification then
		button.notificationTex:SetVertexColor(self.mouseOverRGB.r, self.mouseOverRGB.g, self.mouseOverRGB.b, 1)
	end

	button:Show()
end

function GB:ConstructButtons()
	if self.buttons then
		return
	end

	self.buttons = {}
	for _ = 1, NUM_PANEL_BUTTONS * 2 do
		self:ConstructButton()
	end
end

function GB:UpdateButtons()
	for i = 1, NUM_PANEL_BUTTONS do
		self:UpdateButton(self.buttons[i], self.db.left[i])
		self:UpdateButton(self.buttons[i + NUM_PANEL_BUTTONS], self.db.right[i])
	end

	self:UpdateGuildButton()
end

function GB:UpdateLayout()
	if self.db.backdrop then
		self.bar.leftPanel.backdrop:Show()
		self.bar.middlePanel.backdrop:Show()
		self.bar.rightPanel.backdrop:Show()
	else
		self.bar.leftPanel.backdrop:Hide()
		self.bar.middlePanel.backdrop:Hide()
		self.bar.rightPanel.backdrop:Hide()
	end

	local numLeftButtons, numRightButtons = 0, 0

	-- Left Panel
	local lastButton = nil
	for i = 1, NUM_PANEL_BUTTONS do
		local button = self.buttons[i]
		if button.name ~= L["None"] then
			button:Show()
			button:ClearAllPoints()
			if not lastButton then
				button:SetPoint("LEFT", self.bar.leftPanel, "LEFT", self.db.backdropSpacing, 0)
			else
				button:SetPoint("LEFT", lastButton, "RIGHT", self.db.spacing, 0)
			end
			lastButton = button
			numLeftButtons = numLeftButtons + 1
		else
			button:Hide()
		end
	end

	if numLeftButtons == 0 then
		self.bar.leftPanel:Hide()
	else
		self.bar.leftPanel:Show()
		local panelWidth = self.db.backdropSpacing * 2
			+ (numLeftButtons - 1) * self.db.spacing
			+ numLeftButtons * self.db.buttonSize
		local panelHeight = self.db.backdropSpacing * 2 + self.db.buttonSize
		self.bar.leftPanel:SetSize(panelWidth, panelHeight)
	end

	-- Right Panel
	lastButton = nil
	for i = 1, NUM_PANEL_BUTTONS do
		local button = self.buttons[i + NUM_PANEL_BUTTONS]
		if button.name ~= L["None"] then
			button:Show()
			button:ClearAllPoints()
			if not lastButton then
				button:SetPoint("LEFT", self.bar.rightPanel, "LEFT", self.db.backdropSpacing, 0)
			else
				button:SetPoint("LEFT", lastButton, "RIGHT", self.db.spacing, 0)
			end
			lastButton = button
			numRightButtons = numRightButtons + 1
		else
			button:Hide()
		end
	end

	if numRightButtons == 0 then
		self.bar.rightPanel:Hide()
	else
		self.bar.rightPanel:Show()
		local panelWidth = self.db.backdropSpacing * 2
			+ (numRightButtons - 1) * self.db.spacing
			+ numRightButtons * self.db.buttonSize
		local panelHeight = self.db.backdropSpacing * 2 + self.db.buttonSize
		self.bar.rightPanel:SetSize(panelWidth, panelHeight)
	end

	-- Time Panel
	self.bar.middlePanel:SetSize(self.db.timeAreaWidth, self.db.timeAreaHeight)

	-- Update the size of moveable zones
	local areaWidth = 20 + self.bar.middlePanel:GetWidth()
	local leftWidth = self.bar.leftPanel:IsShown() and self.bar.leftPanel:GetWidth() or 0
	local rightWidth = self.bar.rightPanel:IsShown() and self.bar.rightPanel:GetWidth() or 0
	areaWidth = areaWidth + 2 * max(leftWidth, rightWidth)

	local areaHeight = self.bar.middlePanel:GetHeight()
	local leftHeight = self.bar.leftPanel:IsShown() and self.bar.leftPanel:GetHeight() or 0
	local rightHeight = self.bar.rightPanel:IsShown() and self.bar.rightPanel:GetHeight() or 0
	areaHeight = max(max(leftHeight, rightHeight), areaHeight)

	self.bar:SetSize(areaWidth, areaHeight)
end

function GB:PLAYER_REGEN_ENABLED()
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	self:ProfileUpdate()
end

function GB:PLAYER_ENTERING_WORLD()
	E:Delay(1, function()
		if InCombatLockdown() then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		else
			self:ProfileUpdate()
		end
	end)
end

function GB:UpdateReknown()
	local covenantID = C_Covenants_GetActiveCovenantID()
	if not covenantID or covenantID == 0 then
		return
	end

	if not self.covenantCache[E.myrealm] then
		self.covenantCache[E.myrealm] = {}
	end

	if not self.covenantCache[E.myrealm][E.myname] then
		self.covenantCache[E.myrealm][E.myname] = {}
	end

	local renownLevel = C_CovenantSanctumUI_GetRenownLevel()
	if renownLevel then
		self.covenantCache[E.myrealm][E.myname][tostring(covenantID)] = renownLevel
	end
end

function GB:Initialize()
	self.db = E.db.WT.misc.gameBar
	self.covenantCache = E.global.WT.misc.gameBar.covenantCache

	if not self.db or not self.db.enable then
		return
	end

	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	for name, vDT in pairs(VirtualDT) do
		if DT.RegisteredDataTexts[name] and DT.RegisteredDataTexts[name].applySettings then
			DT.RegisteredDataTexts[name].applySettings(vDT, E.media.hexvaluecolor)
		end
	end

	self:UpdateMetadata()
	self:UpdateReknown()
	self:UpdateHearthStoneTable()
	self:ConstructBar()
	self:ConstructTimeArea()
	self:ConstructButtons()
	self:UpdateTimeArea()
	self:UpdateButtons()
	self:UpdateLayout()
	self:UpdateBar()
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("COVENANT_CHOSEN", function()
		E:Delay(3, function()
			self:UpdateReknown()
			self:UpdateHearthStoneTable()
			self:UpdateBar()
		end)
	end)

	self:SecureHook(_G.GuildMicroButton, "UpdateNotificationIcon", "UpdateGuildButton")
	self.initialized = true
end

function GB:UpdateMetadata()
	self.normalRGB = self.normalRGB or { r = 1, g = 1, b = 1 }
	if self.db.normalColor == "CUSTOM" then
		copyRGB(self.db.customNormalColor, self.normalRGB)
	elseif self.db.normalColor == "CLASS" then
		copyRGB(E:ClassColor(E.myclass, true), self.normalRGB)
	elseif self.db.normalColor == "VALUE" then
		copyRGB(E.media.rgbvaluecolor, self.normalRGB)
	else
		copyRGB({ r = 1, g = 1, b = 1 }, self.normalRGB)
	end

	self.mouseOverRGB = self.mouseOverRGB or { r = 1, g = 1, b = 1 }
	if self.db.hoverColor == "CUSTOM" then
		copyRGB(self.db.customHoverColor, self.mouseOverRGB)
	elseif self.db.hoverColor == "CLASS" then
		copyRGB(E:ClassColor(E.myclass, true), self.mouseOverRGB)
	elseif self.db.hoverColor == "VALUE" then
		copyRGB(E.media.rgbvaluecolor, self.mouseOverRGB)
	else
		copyRGB({ r = 1, g = 1, b = 1 }, self.mouseOverRGB)
	end

	self.animationDuration = self.db.animation.duration
	self.animationInEase = "in-" .. self.db.animation.ease
	self.animationOutEase = "out-" .. self.db.animation.ease
	if self.db.animation.easeInvert then
		self.animationInEase, self.animationOutEase = self.animationOutEase, self.animationInEase
	end
end

function GB:ProfileUpdate()
	self.db = E.db.WT.misc.gameBar
	if not self.db then
		return
	end

	if self.db.enable then
		self:UpdateMetadata()
		if self.initialized then
			self.bar:Show()
			self:UpdateHomeButton()
			self:UpdateTimeArea()
			self:UpdateTime()
			self:UpdateButtons()
			self:UpdateLayout()
			self:UpdateBar()
		else
			if InCombatLockdown() then
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
				return
			else
				self:Initialize()
			end
		end
	else
		if self.initialized then
			UnregisterStateDriver(self.bar, "visibility")
			self.bar:Hide()
		end
	end
end

function GB:UpdateGuildButton()
	if not self.db or not self.db.notification then
		return
	end

	if not _G.GuildMicroButton or not _G.GuildMicroButton.NotificationOverlay then
		return
	end

	local isShown = _G.GuildMicroButton.NotificationOverlay:IsShown()

	for i = 1, 2 * NUM_PANEL_BUTTONS do
		if self.buttons[i].type == "GUILD" then
			self.buttons[i].notificationTex:SetShown(isShown)
		end
	end
end

function GB:HandleRandomHomeButton(button, mouseButton, item)
	if not button or not mouseButton or not item or not availableHearthstones then
		return
	end

	local attribute = mouseButton == "right" and "macrotext2" or "macrotext1"
	local macro = "/use " .. item

	if item == L["Random Hearthstone"] then
		if #availableHearthstones > 0 then
			macro = "/castrandom " .. strjoin(",", unpack(availableHearthstones))
		else
			macro = '/run UIErrorsFrame:AddMessage("' .. L["No Hearthstone Found!"] .. '", 1, 0, 0)'
		end
	end

	button:SetAttribute(attribute, macro)
end

function GB:UpdateHomeButton()
	local left = hearthstonesAndToysData[self.db.home.left]
	local right = hearthstonesAndToysData[self.db.home.right]

	ButtonTypes.HOME.item = {
		item1 = left and left.name,
		item2 = right and right.name,
	}
end

function GB:UpdateHearthStoneTable()
	hearthstonesAndToysData = { ["RANDOM"] = {
		name = L["Random Hearthstone"],
		icon = 134400,
	} }

	local hearthstonesTable = {}
	for i = 1, #hearthstones do
		local itemID = hearthstones[i]
		hearthstonesTable[itemID] = true
	end

	local covenantHearthstones = {
		[1] = 184353, -- 琪瑞安爐石
		[2] = 183716, -- 汎希爾罪孽石
		[3] = 180290, -- 暗夜妖精的爐石
		[4] = 182773, -- 死靈領主爐石
	}

	for i = 1, 4 do
		local toyID = covenantHearthstones[i]
		hearthstonesTable[toyID] = false
	end

	local raceHeartstones = {
		[210455] = {
			-- 德萊尼全像寶石
			["Draenei"] = true,
			["LightforgedDraenei"] = true,
		},
	}

	for itemID, acceptableRaces in pairs(raceHeartstones) do
		hearthstonesTable[itemID] = acceptableRaces[E.myrace] and true or false
	end

	availableHearthstones = {}

	local index = 0
	local itemEngine = CreateFromMixins(ItemMixin)

	local function GetNextHearthStoneInfo()
		index = index + 1
		if hearthstoneAndToyIDList[index] then
			itemEngine:SetItemID(hearthstoneAndToyIDList[index])
			itemEngine:ContinueOnItemLoad(function()
				local id = itemEngine:GetItemID()
				if hearthstonesTable[id] then
					if C_Item_GetItemCount(id) >= 1 or PlayerHasToy(id) and C_ToyBox_IsToyUsable(id) then
						tinsert(availableHearthstones, id)
					end
				end

				hearthstonesAndToysData[tostring(hearthstoneAndToyIDList[index])] = {
					name = itemEngine:GetItemName(),
					icon = itemEngine:GetItemIcon(),
				}
				GetNextHearthStoneInfo()
			end)
		else
			self:UpdateHomeButton()
			if self.initialized then
				self:UpdateButtons()
			end
		end
	end

	GetNextHearthStoneInfo()
end

function GB:GetHearthStoneTable()
	return hearthstonesAndToysData
end

function GB:GetAvailableButtons()
	local buttons = {}

	for key, data in pairs(ButtonTypes) do
		buttons[key] = data.name
	end

	return buttons
end

W:RegisterModule(GB:GetName())
