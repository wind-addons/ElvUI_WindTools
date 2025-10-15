local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local KI = W:GetModule("KeystoneInfo")
local S = W.Modules.Skins ---@type Skins
local MF = W.Modules.MoveFrames ---@type MoveFrames
local LL = W:NewModule("LFGList", "AceHook-3.0", "AceEvent-3.0") ---@class LFGList : AceModule, AceHook-3.0, AceEvent-3.0
local LFGPI = W.Utilities.LFGPlayerInfo
local C = W.Utilities.Color
local LSM = E.Libs.LSM

local _G = _G
local bit = bit
local floor = floor
local format = format
local gsub = gsub
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local math = math
local min = min
local pairs = pairs
local select = select
local sort = sort
local tAppendAll = tAppendAll
local tinsert = tinsert
local tonumber = tonumber
local tostring = tostring
local tremove = tremove
local unpack = unpack
local wipe = wipe

local CopyTable = CopyTable
local CreateFrame = CreateFrame
local GetNumGroupMembers = GetNumGroupMembers
local GetTime = GetTime
local GroupFinderFrameGroupButton_OnClick = GroupFinderFrameGroupButton_OnClick
local InCombatLockdown = InCombatLockdown
local IsInGroup = IsInGroup
local IsShiftKeyDown = IsShiftKeyDown
local LFGListSearchPanel_Clear = LFGListSearchPanel_Clear
local LFGListSearchPanel_DoSearch = LFGListSearchPanel_DoSearch
local LFGListSearchPanel_SetCategory = LFGListSearchPanel_SetCategory
local PlayerIsTimerunning = PlayerIsTimerunning
local UnitClassBase = UnitClassBase
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitName = UnitName
local WeeklyRewards_ShowUI = WeeklyRewards_ShowUI

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_AddOns_LoadAddOn = C_AddOns.LoadAddOn
local C_ChallengeMode_GetAffixInfo = C_ChallengeMode.GetAffixInfo
local C_ChallengeMode_GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local C_LFGList_GetActivityInfoTable = C_LFGList.GetActivityInfoTable
local C_LFGList_GetAdvancedFilter = C_LFGList.GetAdvancedFilter
local C_LFGList_GetApplicationInfo = C_LFGList.GetApplicationInfo
local C_LFGList_GetAvailableActivityGroups = C_LFGList.GetAvailableActivityGroups
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetSearchResultPlayerInfo = C_LFGList.GetSearchResultPlayerInfo
local C_LFGList_SaveAdvancedFilter = C_LFGList.SaveAdvancedFilter
local C_MythicPlus = C_MythicPlus
local C_MythicPlus_GetCurrentAffixes = C_MythicPlus.GetCurrentAffixes
local C_MythicPlus_GetRewardLevelForDifficultyLevel = C_MythicPlus.GetRewardLevelForDifficultyLevel
local C_MythicPlus_GetRunHistory = C_MythicPlus.GetRunHistory
local C_SpecializationInfo_GetSpecialization = C_SpecializationInfo.GetSpecialization
local C_SpecializationInfo_GetSpecializationInfo = C_SpecializationInfo.GetSpecializationInfo
local Enum_LFGListFilter = Enum.LFGListFilter

local GROUP_FINDER_CATEGORY_ID_DUNGEONS = GROUP_FINDER_CATEGORY_ID_DUNGEONS
local GROUP_FINDER_CUSTOM_CATEGORY = GROUP_FINDER_CUSTOM_CATEGORY
local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE

local AFFIX_ICON_SIZE = 32
local AFFIX_ICON_SPACING = 6
local FILTER_BUTTON_WIDTH = W.AsianLocale and 85 or 100
local FILTER_BUTTON_HEIGHT = 28
local FILTER_BUTTON_SPACING = 6
local FILTER_BUTTONS_PER_COLUMN = 4
local PANEL_PADDING = 10
local QUICK_ACCESS_PANEL_WIDTH = 2 * FILTER_BUTTON_WIDTH + FILTER_BUTTON_SPACING + PANEL_PADDING * 2

local seasonGroups = C_LFGList_GetAvailableActivityGroups(
	GROUP_FINDER_CATEGORY_ID_DUNGEONS,
	bit.bor(Enum_LFGListFilter.CurrentSeason, Enum_LFGListFilter.PvE)
)
local expansionGroups = C_LFGList_GetAvailableActivityGroups(
	GROUP_FINDER_CATEGORY_ID_DUNGEONS,
	bit.bor(Enum_LFGListFilter.CurrentExpansion, Enum_LFGListFilter.NotCurrentSeason, Enum_LFGListFilter.PvE)
)
local timerunningGroups = C_LFGList_GetAvailableActivityGroups(
	GROUP_FINDER_CATEGORY_ID_DUNGEONS,
	bit.bor(Enum_LFGListFilter.Timerunning, Enum_LFGListFilter.PvE)
)

local RoleIconTextures = {
	PHILMOD = {
		TANK = W.Media.Icons.philModTank,
		HEALER = W.Media.Icons.philModHealer,
		DAMAGER = W.Media.Icons.philModDPS,
	},
	FFXIV = {
		TANK = W.Media.Icons.ffxivTank,
		HEALER = W.Media.Icons.ffxivHealer,
		DAMAGER = W.Media.Icons.ffxivDPS,
	},
	HEXAGON = {
		TANK = W.Media.Icons.hexagonTank,
		HEALER = W.Media.Icons.hexagonHealer,
		DAMAGER = W.Media.Icons.hexagonDPS,
	},
	SUNUI = {
		TANK = W.Media.Icons.sunUITank,
		HEALER = W.Media.Icons.sunUIHealer,
		DAMAGER = W.Media.Icons.sunUIDPS,
	},
	LYNUI = {
		TANK = W.Media.Icons.lynUITank,
		HEALER = W.Media.Icons.lynUIHealer,
		DAMAGER = W.Media.Icons.lynUIDPS,
	},
	ELVUI_OLD = {
		TANK = W.Media.Icons.elvUIOldTank,
		HEALER = W.Media.Icons.elvUIOldHealer,
		DAMAGER = W.Media.Icons.elvUIOldDPS,
	},
	DEFAULT = {
		TANK = E.Media.Textures.Tank,
		HEALER = E.Media.Textures.Healer,
		DAMAGER = E.Media.Textures.DPS,
	},
}

local vaultItemLevel = {}

for i = 1, 10 do
	local weeklyItemLevel = C_MythicPlus_GetRewardLevelForDifficultyLevel(i)
	tinsert(vaultItemLevel, weeklyItemLevel)
end

local affixAddedAtLevel = { 4, 7, 10, 12 }

local legionRemixAffixes = {
	{ id = 166 },
	{ id = 167 },
	{ id = 168 },
	{ id = 169 },
	{ id = 170 },
}

local availableSortMode = {
	"DEFAULT",
	"OVERALL_SCORE",
	"DUNGEON_SCORE",
}

local sortMode = {
	["DUNGEON_SCORE"] = {
		text = L["Dungeon Score"],
		tooltip = L["Leader's Dungeon Score"],
		func = function(a, b)
			local _a = (a and a.leaderScore or 0)
			local _b = (b and b.leaderScore or 0)
			return _a > _b and 1 or _a < _b and -1 or 0
		end,
	},
	["OVERALL_SCORE"] = {
		text = L["Overall Score"],
		tooltip = L["Leader's Overall Score"],
		func = function(a, b)
			local _a = (a and a.leaderOverallScore or 0)
			local _b = (b and b.leaderOverallScore or 0)
			return _a > _b and 1 or _a < _b and -1 or 0
		end,
	},
	["DEFAULT"] = {
		text = L["Default"],
		tooltip = L["Default"],
	},
}

function LL:GetPlayerDB(key)
	local globalDB = E.global.WT.misc.lfgList

	if not globalDB then
		return {}
	end

	if not globalDB[E.myrealm] then
		globalDB[E.myrealm] = {}
	end

	if not globalDB[E.myrealm][E.myname] then
		globalDB[E.myrealm][E.myname] = {}
	end

	if not globalDB[E.myrealm][E.myname][key] then
		globalDB[E.myrealm][E.myname][key] = {}
	end

	return globalDB[E.myrealm][E.myname][key] --[[@as table]]
end

function LL:UpdateAdditionalText(button, score, best)
	local db = self.db.additionalText

	if not db.enable or not button.Name or not button.ActivityName then
		return
	end

	if not db.template or not score or not best then
		return
	end

	if db.shortenDescription then
		local descriptionText = button.ActivityName:GetText()
		descriptionText = gsub(descriptionText, "%([^%)]+%)", "")
		button.ActivityName:SetText(descriptionText)
	end

	local target = button[db.target == "TITLE" and "Name" or "ActivityName"]

	local text = target:GetText()

	local result = db.template

	result = gsub(result, "{{score}}", score)
	result = gsub(result, "{{best}}", best)
	result = gsub(result, "{{text}}", text)

	target:SetText(result)
end

function LL:MemberDisplay_SetActivity(memberDisplay, activity)
	memberDisplay.resultID = activity and activity.GetID and activity:GetID() or nil
end

---Reskins and customizes role icons in LFG (Looking for Group) lists with various visual enhancements.
---When role is nil, the icon and its elements are hidden by setting alpha to 0.
---@param parent Frame? The parent frame that contains the icon. Required for leader indicator and class line features.
---@param icon Texture The texture object representing the role icon to be reskinned.
---@param role "TANK" | "HEALER" | "DAMAGER" | nil The player's role. If nil, the icon will be hidden.
---@param data [ClassFile, string, boolean]? Optional cached data containing [class, specialization, isLeader] information.
function LL:ReskinIcon(parent, icon, role, data)
	local class, spec, isLeader
	if data then
		class, spec, isLeader = data[1], data[2], data[3]
	end

	if role then
		if self.db.icon.reskin then
			-- if not class and spec info, use square style instead
			local pack = self.db.icon.pack
			if pack == "SPEC" and (not class or not spec) then
				pack = "SQUARE"
			end

			if pack == "SQUARE" then
				icon:SetTexture(W.Media.Textures.ROLES)
				icon:SetTexCoord(F.GetRoleTexCoord(role))
			elseif pack == "SPEC" then
				local tex = LFGPI.GetIconTextureWithClassAndSpecName(class, spec)
				icon:SetTexture(tex)
				icon:SetTexCoord(unpack(E.TexCoords))
			else
				icon:SetTexture(RoleIconTextures[pack][role])
				icon:SetTexCoord(0, 1, 0, 1)
			end
		end

		icon:Size(self.db.icon.size)

		if self.db.icon.border and not icon.backdrop then
			icon:CreateBackdrop("Transparent")
		end

		icon:SetAlpha(self.db.icon.alpha)
		if icon.backdrop then
			icon.backdrop:SetAlpha(self.db.icon.alpha)
		end
	else
		icon:SetAlpha(0)
		if icon.backdrop then
			icon.backdrop:SetAlpha(0)
		end
	end

	if parent then
		if self.db.icon.leader then
			if not icon.leader then
				local leader = parent:CreateTexture(nil, "OVERLAY")
				leader:SetTexture(W.Media.Icons.leader)
				leader:Size(10, 8)
				leader:Point("BOTTOM", icon, "TOP", 0, 1)
				icon.leader = leader
			end

			icon.leader:SetShown(isLeader)
		end

		-- Create bar in class color behind
		if class and self.db.line.enable then
			if not icon.line then
				local line = parent:CreateTexture(nil, "ARTWORK")
				line:SetTexture(LSM:Fetch("statusbar", self.db.line.tex) or E.media.normTex)
				line:Size(self.db.line.width, self.db.line.height)
				line:Point("TOP", icon, "BOTTOM", self.db.line.offsetX, self.db.line.offsetY)
				icon.line = line
			end

			local color = E:ClassColor(class, false)
			icon.line:SetVertexColor(color.r, color.g, color.b)
			icon.line:SetAlpha(self.db.line.alpha)
		elseif parent and icon.line then
			icon.line:SetAlpha(0)
		end
	end
end

function LL:UpdateEnumerate(Enumerate)
	local button = Enumerate:GetParent():GetParent()

	if not button.resultID then
		return
	end

	local result = C_LFGList_GetSearchResultInfo(button.resultID)
	local info = C_LFGList_GetActivityInfoTable(result.activityIDs[1])

	if not result then
		return
	end

	if self.db.icon.enable then
		---@type table<string, [ClassFile, string, boolean][]>
		local cache = { TANK = {}, HEALER = {}, DAMAGER = {} }

		for i = 1, result.numMembers do
			local playerInfo = C_LFGList_GetSearchResultPlayerInfo(button.resultID, i)
			if playerInfo then
				local role, class, spec, isLeader =
					playerInfo.assignedRole, playerInfo.classFilename, playerInfo.specName, playerInfo.isLeader
				tinsert(cache[role], { class, spec, isLeader })
			end
		end

		for i = 5, 1, -1 do -- The index of icon starts from right
			local icon = Enumerate["Icon" .. i]
			local roleIcon = icon.RoleIcon
			local classCircle = icon.ClassCircle

			if roleIcon and roleIcon.SetTexture then
				if #cache.TANK > 0 then
					self:ReskinIcon(Enumerate, roleIcon, "TANK", cache.TANK[1])
					tremove(cache.TANK, 1)
				elseif #cache.HEALER > 0 then
					self:ReskinIcon(Enumerate, roleIcon, "HEALER", cache.HEALER[1])
					tremove(cache.HEALER, 1)
				elseif #cache.DAMAGER > 0 then
					self:ReskinIcon(Enumerate, roleIcon, "DAMAGER", cache.DAMAGER[1])
					tremove(cache.DAMAGER, 1)
				else
					self:ReskinIcon(Enumerate, roleIcon)
				end
			end

			if classCircle and self.db.icon.hideDefaultClassCircle then
				classCircle:Hide()
			end
		end
	end

	if self.db.additionalText.enable and result and info and info.isMythicPlusActivity then
		local scoreText, bestText

		local score = result.leaderOverallDungeonScore or 0
		local color = score and C_ChallengeMode_GetDungeonScoreRarityColor(score) or { r = 1.0, g = 1.0, b = 1.0 }
		scoreText = C.StringWithRGB(score, color)

		local bestRun = result.leaderDungeonScoreInfo
			and result.leaderDungeonScoreInfo[1]
			and result.leaderDungeonScoreInfo[1].bestRunLevel
		if bestRun then
			local template = result.leaderDungeonScoreInfo[1].finishedSuccess and "green-400" or "gray-400"
			bestText = C.StringByTemplate("+" .. bestRun, template)
		end

		self:UpdateAdditionalText(button, scoreText, bestText)
	end
end

function LL:UpdateRoleCount(RoleCount)
	if not self.db.icon.enable then
		return
	end

	if RoleCount.TankIcon then
		self:ReskinIcon(nil, RoleCount.TankIcon, "TANK")
	end
	if RoleCount.HealerIcon then
		self:ReskinIcon(nil, RoleCount.HealerIcon, "HEALER")
	end
	if RoleCount.DamagerIcon then
		self:ReskinIcon(nil, RoleCount.DamagerIcon, "DAMAGER")
	end
end

-- Used for Details! command check
local FakeChatEditBox = {}
function FakeChatEditBox:GetText()
	return "/keystone"
end

function LL:InitializePartyKeystoneFrame()
	local frame = CreateFrame("Frame", "WTPartyKeystoneFrame", _G.ChallengesFrame)
	frame:Size(200, 150)
	frame:SetTemplate("Transparent")
	frame:Point("BOTTOMRIGHT", _G.ChallengesFrame, "BOTTOMRIGHT", -8, 85)

	frame.lines = {}

	frame.title = frame:CreateFontString(nil, "OVERLAY")
	F.SetFontWithDB(frame.title, self.db.partyKeystone.font)
	frame.title:Point("TOPLEFT", frame, "TOPLEFT", 8, -10)
	frame.title:SetJustifyH("LEFT")
	frame.title:SetText(F.GetWindStyleText(L["Party Keystone"]))

	frame.detailsButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.detailsButton:Size(40, self.db.partyKeystone.font.size + 4)
	F.SetFontWithDB(frame.detailsButton.Text, self.db.partyKeystone.font)
	F.SetFont(frame.detailsButton.Text, nil, "-2")
	frame.detailsButton:SetText(L["More"])
	frame.detailsButton:Point("TOPRIGHT", frame, "TOPRIGHT", -8, -8)
	S:Proxy("HandleButton", frame.detailsButton)

	frame.detailsButton:SetScript("OnClick", function()
		if _G.SlashCmdList["KEYSTONE"] then
			_G.SlashCmdList["KEYSTONE"]("", FakeChatEditBox)
		else
			F.Print(L["You need to install Details! first."])
		end
	end)

	frame.detailsButton:SetScript("OnEnter", function(s)
		_G.GameTooltip:SetOwner(s, "ANCHOR_TOP", 0, 3)
		_G.GameTooltip:ClearLines()
		_G.GameTooltip:AddLine(L["Click to open Details! keystone info window."])
		_G.GameTooltip:Show()
	end)

	frame.detailsButton:SetScript("OnLeave", function()
		_G.GameTooltip:Hide()
	end)

	frame.sendToPartyChat = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.sendToPartyChat:Size(40, self.db.partyKeystone.font.size + 4)
	F.SetFontWithDB(frame.sendToPartyChat.Text, self.db.partyKeystone.font)
	F.SetFont(frame.sendToPartyChat.Text, nil, "-2")
	frame.sendToPartyChat:SetText(L["Send"])
	frame.sendToPartyChat:Point("RIGHT", frame.detailsButton, "LEFT", -5, 0)
	S:Proxy("HandleButton", frame.sendToPartyChat)

	frame.sendToPartyChat:SetScript("OnClick", function()
		if not IsInGroup() then
			F.Print(L["You are not in a party."])
			return
		end

		if not frame.partyMessages or #frame.partyMessages == 0 then
			return
		end

		for i, msg in ipairs(frame.partyMessages) do
			E:Delay((i - 1) * 0.5, function()
				_G.SendChatMessage(msg, IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "PARTY")
			end)
		end
	end)

	frame.sendToPartyChat:SetScript("OnEnter", function(s)
		_G.GameTooltip:SetOwner(s, "ANCHOR_TOP", 0, 3)
		_G.GameTooltip:ClearLines()
		_G.GameTooltip:AddLine(L["Click to send keystone info to party chat."])
		_G.GameTooltip:Show()
	end)

	frame.sendToPartyChat:SetScript("OnLeave", function()
		_G.GameTooltip:Hide()
	end)

	for i = 1, 5 do
		local yOffset = (2 + self.db.partyKeystone.font.size) * (i - 1) + 5

		local rightText = frame:CreateFontString(nil, "OVERLAY")
		F.SetFontWithDB(rightText, self.db.partyKeystone.font)
		rightText:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, yOffset)
		rightText:SetJustifyH("RIGHT")
		rightText:Width(90)

		local leftText = frame:CreateFontString(nil, "OVERLAY")
		F.SetFontWithDB(leftText, self.db.partyKeystone.font)
		leftText:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -100, yOffset)
		leftText:SetJustifyH("LEFT")
		leftText:Width(90)

		frame.lines[i] = { left = leftText, right = rightText }
	end

	self.partyKeystoneFrame = frame
end

function LL:UpdatePartyKeystoneFrame()
	if not self.db.partyKeystone.enable then
		if self.partyKeystoneFrame then
			self.partyKeystoneFrame:Hide()
		end
		return
	end

	if not self.partyKeystoneFrame then
		self:InitializePartyKeystoneFrame()
	end

	local frame = self.partyKeystoneFrame

	local scale = self.db.partyKeystone.font.size / 12
	local heightIncrement = floor(8 * scale)
	local blockWidth = floor(95 * scale)
	local cache = {}

	frame.partyMessages = {}

	local mythicPlusMapData = W:GetMythicPlusMapData()
	for i = 1, 5 do
		local unit = i == 1 and "player" or "party" .. i - 1
		local data = KI:UnitData(unit)
		local mapData = data and data.challengeMapID and mythicPlusMapData[data.challengeMapID]
		if mapData then
			tinsert(cache, {
				level = data.level,
				name = mapData.abbr,
				player = C.StringWithClassColor(UnitName(unit), UnitClassBase(unit)),
				icon = mapData.tex,
			})

			tinsert(frame.partyMessages, format("%s: %s (+%d)", UnitName(unit), mapData.name, data.level))
		end
	end

	F.SetFontWithDB(frame.title, self.db.partyKeystone.font)

	frame.detailsButton:Size(floor(40 * scale), self.db.partyKeystone.font.size + 4)
	F.SetFontWithDB(frame.detailsButton.Text, self.db.partyKeystone.font)
	F.SetFont(frame.detailsButton.Text, nil, "-2")

	frame.sendToPartyChat:SetEnabled(#frame.partyMessages ~= 0)
	frame.sendToPartyChat:Size(floor(40 * scale), self.db.partyKeystone.font.size + 4)
	F.SetFontWithDB(frame.sendToPartyChat.Text, self.db.partyKeystone.font)
	F.SetFont(frame.sendToPartyChat.Text, nil, "-2")

	for i = 1, 5 do
		local yOffset = (heightIncrement + self.db.partyKeystone.font.size) * (i - 1) + 10

		F.SetFontWithDB(frame.lines[i].right, self.db.partyKeystone.font)
		frame.lines[i].right:ClearAllPoints()
		frame.lines[i].right:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, yOffset)
		frame.lines[i].right:SetJustifyH("RIGHT")
		frame.lines[i].right:Width(blockWidth)

		F.SetFontWithDB(frame.lines[i].left, self.db.partyKeystone.font)
		frame.lines[i].left:ClearAllPoints()
		frame.lines[i].left:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -blockWidth - 9, yOffset)
		frame.lines[i].left:Width(blockWidth)

		if cache[i] then
			frame.lines[i].right:SetText(cache[i].player)
			frame.lines[i].left:SetText(
				F.GetIconString(cache[i].icon, 16, 18, true)
					.. " "
					.. C.StringWithKeystoneLevel(format("%s (%s)", cache[i].name, cache[i].level), cache[i].level)
			)
		else
			frame.lines[i].right:SetText("")
			frame.lines[i].left:SetText("")
		end
	end

	frame:Size(
		blockWidth * 2 + 20,
		20 + (heightIncrement + self.db.partyKeystone.font.size) * #cache + self.db.partyKeystone.font.size
	)
	frame:Show()
end

function LL:RequestKeystoneData()
	E:Delay(0.5, self.UpdatePartyKeystoneFrame, self)
	E:Delay(2, self.UpdatePartyKeystoneFrame, self)
end

function LL:RefreshSearch()
	if not self.db.rightPanel.enable or not self.db.rightPanel.autoRefresh then
		return
	end

	_G.LFGListSearchPanel_DoSearch(_G.LFGListFrame.SearchPanel)
end

function LL:RepositionRaiderIOProfileTooltip(frame)
	local anchor = _G.RaiderIO_ProfileTooltipAnchor
	if not anchor then
		return
	end

	if not self:IsHooked(anchor, "SetPoint") then
		self:RawHook(anchor, "SetPoint", function(_, arg1, arg2, arg3, arg4, arg5)
			if arg2 and (arg2 == _G.PVEFrame or arg2 == frame) then
				arg2 = frame:IsShown() and frame or _G.PVEFrame
			end
			self.hooks[anchor]["SetPoint"](anchor, arg1, arg2, arg3, arg4, arg5)
		end, true)
	end

	local point = { anchor:GetPoint(1) }
	if #point > 0 then
		anchor:ClearAllPoints()
		anchor:Point(unpack(point))
	end
end

function LL:InitializeRightPanel()
	if self.rightPanel then
		return
	end

	local mythicPlusMapData = W:GetMythicPlusMapData()

	local frame = CreateFrame("Frame", nil, _G.PVEFrame)
	frame:Point("TOPLEFT", _G.PVEFrame, "TOPRIGHT", 4, 0)
	frame:Point("BOTTOMLEFT", _G.PVEFrame, "BOTTOMRIGHT", 4, 0)
	frame:SetTemplate("Transparent")
	S:CreateShadowModule(frame)
	MF:InternalHandle(frame, "PVEFrame")

	self:SecureHook(frame, "Show", "RepositionRaiderIOProfileTooltip")
	self:SecureHook(frame, "Hide", "RepositionRaiderIOProfileTooltip")

	local function HandleAutoJoin(module, resultID, button)
		if not module.db.rightPanel.autoJoin then
			return
		end

		if button == "RightButton" then
			return
		end

		local panel = _G.LFGListFrame.SearchPanel
		if _G.LFGListSearchPanelUtil_CanSelectResult(resultID) and panel.SignUpButton:IsEnabled() then
			if panel.selectedResult ~= resultID then
				_G.LFGListSearchPanel_SelectResult(panel, resultID)
			end
			_G.LFGListSearchPanel_SignUp(panel)
		end
	end

	hooksecurefunc("LFGListSearchEntry_Update", function(entry)
		if entry.autoJoinHandled then
			return
		end

		entry:HookScript("OnClick", function(f, button)
			HandleAutoJoin(LL, f.resultID, button)
		end)

		entry.autoJoinHandled = true
	end)

	_G.LFGListApplicationDialog:HookScript("OnShow", function(s)
		if not self.db.rightPanel.skipConfirmation then
			return
		end

		if s.SignUpButton:IsEnabled() and not IsShiftKeyDown() then
			s.SignUpButton:Click()
		end
	end)

	local affixes = not PlayerIsTimerunning() and C_MythicPlus_GetCurrentAffixes() or legionRemixAffixes
	frame.affixes = CreateFrame("Frame", nil, frame)
	frame.affixes:Height(AFFIX_ICON_SIZE)
	frame.affixes:Point("TOPLEFT", frame, "TOPLEFT", PANEL_PADDING, -PANEL_PADDING)
	frame.affixes:Point("TOPRIGHT", frame, "TOPRIGHT", -PANEL_PADDING, -PANEL_PADDING)
	frame.affixes.alignFrame = CreateFrame("Frame", nil, frame.affixes)
	frame.affixes.alignFrame:Point("CENTER")
	frame.affixes.alignFrame:Height(AFFIX_ICON_SIZE)
	frame.affixes.alignFrame:Width(#affixes * AFFIX_ICON_SIZE + (#affixes - 1) * AFFIX_ICON_SPACING + 4)

	for i = 1, #affixes do
		local affix = frame.affixes:CreateTexture(nil, "ARTWORK")
		affix:CreateBackdrop()
		affix:Size(AFFIX_ICON_SIZE)
		affix:Point("LEFT", frame.affixes.alignFrame, "LEFT", 2 + (i - 1) * (AFFIX_ICON_SIZE + AFFIX_ICON_SPACING), 0)
		affix:SetTexture(select(3, C_ChallengeMode_GetAffixInfo(affixes[i].id)))
		affix:SetTexCoord(unpack(E.TexCoords))
	end

	frame.affixes:SetScript("OnEnter", function()
		_G.GameTooltip:SetOwner(frame, "ANCHOR_BOTTOMRIGHT", 3, frame:GetHeight())
		_G.GameTooltip:ClearLines()
		_G.GameTooltip:AddLine(F.GetWindStyleText(L["Affixes"]))

		for i = 1, #affixes do
			local name, description, fileDataID = C_ChallengeMode_GetAffixInfo(affixes[i].id)
			_G.GameTooltip:AddLine(" ")
			if not PlayerIsTimerunning() then
				local level = affixAddedAtLevel[i] or 0
				_G.GameTooltip:AddLine(format("%s (%d) %s", F.GetIconString(fileDataID, 16, 18, true), level, name))
			else
				_G.GameTooltip:AddLine(format("%s %s", F.GetIconString(fileDataID, 16, 18, true), name))
			end
			_G.GameTooltip:AddLine(description, 1, 1, 1, true)
		end
		_G.GameTooltip:Show()
	end)

	frame.affixes:SetScript("OnLeave", function()
		_G.GameTooltip:Hide()
	end)

	-- Filters container
	local filters = CreateFrame("Frame", nil, frame)
	filters:Point("TOPLEFT", frame.affixes, "BOTTOMLEFT", 0, -10)
	filters:Point("TOPRIGHT", frame.affixes, "BOTTOMRIGHT", 0, -10)
	filters.buttons = {}

	local function addSetActive(obj)
		obj.SetActive = function(f, active)
			local r, g, b = unpack(E.media.rgbvaluecolor)
			if active then
				f:SetBackdropBorderColor(r, g, b)
				f:SetBackdropColor(r, g, b, 0.5)
			else
				f:SetBackdropBorderColor(0, 0, 0)
				f:SetBackdropColor(0.3, 0.3, 0.3, 0.5)
			end
			f.active = active
		end
	end

	local mapIDs = {}
	for key in pairs(mythicPlusMapData) do
		tinsert(mapIDs, key)
	end

	sort(mapIDs, function(a, b)
		return a < b
	end)

	local numDungeons = #mapIDs
	local numColumns = math.ceil(numDungeons / FILTER_BUTTONS_PER_COLUMN)
	local filtersWidth = numColumns * FILTER_BUTTON_WIDTH + (numColumns - 1) * FILTER_BUTTON_SPACING
	local frameWidth = filtersWidth + PANEL_PADDING * 2
	frame.FilterPanelWidth = frameWidth
	frame:Width(frame.FilterPanelWidth)

	-- Set filters container height based on actual number of rows needed
	local numRows = math.min(numDungeons, FILTER_BUTTONS_PER_COLUMN)
	filters:Height(FILTER_BUTTON_HEIGHT * numRows + FILTER_BUTTON_SPACING * (numRows - 1))

	for i, mapID in ipairs(mapIDs) do
		local filterButton = CreateFrame("Frame", nil, filters)
		filterButton:SetTemplate()
		filterButton:Size(FILTER_BUTTON_WIDTH, FILTER_BUTTON_HEIGHT)
		local col = floor((i - 1) / FILTER_BUTTONS_PER_COLUMN)
		local row = (i - 1) % FILTER_BUTTONS_PER_COLUMN
		local xOffset = col * (FILTER_BUTTON_WIDTH + FILTER_BUTTON_SPACING)
		local yOffset = -row * (FILTER_BUTTON_HEIGHT + FILTER_BUTTON_SPACING)
		filterButton:Point("TOPLEFT", filters, "TOPLEFT", xOffset, yOffset)

		filterButton.tex = filterButton:CreateTexture(nil, "ARTWORK")
		filterButton.tex:Size(20, 20)
		filterButton.tex:Point("LEFT", filterButton, "LEFT", 4, 0)
		filterButton.tex:SetTexture(mythicPlusMapData[mapID].tex)

		filterButton.name = filterButton:CreateFontString(nil, "OVERLAY")
		filterButton.name:SetFont(E.media.normFont, 12 + self.db.rightPanel.adjustFontSize, "OUTLINE")
		filterButton.name:Point("LEFT", filterButton.tex, "RIGHT", 8, 0)
		filterButton.name:SetText(mythicPlusMapData[mapID].abbr)

		addSetActive(filterButton)

		filterButton:SetScript("OnMouseDown", function(btn, button)
			if button == "LeftButton" then
				local dfDB = self:GetPlayerDB("dungeonFilter")
				btn:SetActive(not btn.active)
				dfDB[mapID] = btn.active
				self:UpdateAdvancedFilters()
				LL:RefreshSearch()
			end
		end)

		filters.buttons[mapID] = filterButton
	end

	-- Leader Overall Score
	local leaderScore = CreateFrame("Frame", nil, filters)
	leaderScore:Height(32)
	leaderScore:Point("TOPLEFT", filters, "BOTTOMLEFT", 0, -FILTER_BUTTON_SPACING)
	leaderScore:Point("TOPRIGHT", filters, "BOTTOMRIGHT", 0, -FILTER_BUTTON_SPACING)
	leaderScore:SetTemplate()

	leaderScore.text = leaderScore:CreateFontString(nil, "OVERLAY")
	leaderScore.text:SetFont(E.media.normFont, 11 + self.db.rightPanel.adjustFontSize, "OUTLINE")
	leaderScore.text:Point("LEFT", leaderScore, "LEFT", 8, 0)
	leaderScore.text:SetText(L["Leader Score Over"])

	leaderScore.editBox = CreateFrame("EditBox", nil, leaderScore)
	leaderScore.editBox:SetFont(E.media.normFont, 12 + self.db.rightPanel.adjustFontSize, "OUTLINE")
	leaderScore.editBox:Size(40, 20)
	leaderScore.editBox:SetJustifyH("CENTER")
	leaderScore.editBox:Point("RIGHT", leaderScore, "RIGHT", -10, 0)
	leaderScore.editBox:SetAutoFocus(false)
	leaderScore.editBox:SetScript("OnEscapePressed", function(editBox)
		editBox:ClearFocus()
	end)

	leaderScore.editBox:SetScript("OnEnterPressed", function(editBox)
		local dfDB = self:GetPlayerDB("dungeonFilter")

		local text = editBox:GetText()
		if text == "" then
			text = 0
			editBox:SetText(0)
		end

		dfDB.leaderScore = tonumber(text) or 0
		editBox:SetText(tostring(dfDB.leaderScore))
		editBox:ClearFocus()
		LL:RefreshSearch()
	end)

	S:Proxy("HandleEditBox", leaderScore.editBox)

	addSetActive(leaderScore)

	leaderScore:SetScript("OnEnter", function(btn)
		_G.GameTooltip:SetOwner(btn, "ANCHOR_TOP", 0, 4)
		_G.GameTooltip:AddLine(F.GetWindStyleText(L["Leader Score"]), 1, 1, 1)
		_G.GameTooltip:AddLine(L["The overall mythic+ score of the leader."], 1, 1, 1, true)
		_G.GameTooltip:Show()
	end)

	leaderScore:SetScript("OnLeave", function(btn)
		_G.GameTooltip:Hide()
	end)

	leaderScore:SetScript("OnMouseDown", function(btn, button)
		if button == "LeftButton" then
			local dfDB = self:GetPlayerDB("dungeonFilter")
			btn:SetActive(not btn.active)
			dfDB.leaderScoreEnable = btn.active
			self:UpdateAdvancedFilters()
			LL:RefreshSearch()
		end
	end)

	filters.leaderScore = leaderScore

	-- Leader Dungeon Score
	local leaderDungeonScore = CreateFrame("Frame", nil, filters)
	leaderDungeonScore:Height(32)
	leaderDungeonScore:Point("TOPLEFT", leaderScore, "BOTTOMLEFT", 0, -FILTER_BUTTON_SPACING)
	leaderDungeonScore:Point("TOPRIGHT", leaderScore, "BOTTOMRIGHT", 0, -FILTER_BUTTON_SPACING)
	leaderDungeonScore:SetTemplate()

	leaderDungeonScore.text = leaderDungeonScore:CreateFontString(nil, "OVERLAY")
	leaderDungeonScore.text:SetFont(E.media.normFont, 11 + self.db.rightPanel.adjustFontSize, "OUTLINE")
	leaderDungeonScore.text:Point("LEFT", leaderDungeonScore, "LEFT", 8, 0)
	leaderDungeonScore.text:SetText(L["Dungeon Score Over"])

	leaderDungeonScore.editBox = CreateFrame("EditBox", nil, leaderDungeonScore)
	leaderDungeonScore.editBox:SetFont(E.media.normFont, 12 + self.db.rightPanel.adjustFontSize, "OUTLINE")
	leaderDungeonScore.editBox:Size(40, 20)
	leaderDungeonScore.editBox:SetJustifyH("CENTER")
	leaderDungeonScore.editBox:Point("RIGHT", leaderDungeonScore, "RIGHT", -10, 0)
	leaderDungeonScore.editBox:SetAutoFocus(false)
	leaderDungeonScore.editBox:SetScript("OnEscapePressed", function(editBox)
		editBox:ClearFocus()
	end)

	leaderDungeonScore.editBox:SetScript("OnEnterPressed", function(editBox)
		local dfDB = self:GetPlayerDB("dungeonFilter")

		local text = editBox:GetText()
		if text == "" then
			text = 0
			editBox:SetText(0)
		end

		dfDB.leaderDungeonScore = tonumber(text) or 0
		editBox:SetText(tostring(dfDB.leaderDungeonScore))
		editBox:ClearFocus()
		LL:RefreshSearch()
	end)

	S:Proxy("HandleEditBox", leaderDungeonScore.editBox)

	addSetActive(leaderDungeonScore)

	leaderDungeonScore:SetScript("OnEnter", function(btn)
		_G.GameTooltip:SetOwner(btn, "ANCHOR_TOP", 0, 4)
		_G.GameTooltip:AddLine(F.GetWindStyleText(L["Leader's Dungeon Score"]), 1, 1, 1)
		_G.GameTooltip:AddLine(L["The recruited dungeon mythic+ score of the leader."], 1, 1, 1, true)
		_G.GameTooltip:Show()
	end)

	leaderDungeonScore:SetScript("OnLeave", function(btn)
		_G.GameTooltip:Hide()
	end)

	leaderDungeonScore:SetScript("OnMouseDown", function(btn, button)
		if button == "LeftButton" then
			local dfDB = self:GetPlayerDB("dungeonFilter")
			btn:SetActive(not btn.active)
			dfDB.leaderDungeonScoreEnable = btn.active
			LL:RefreshSearch()
		end
	end)

	filters.leaderDungeonScore = leaderDungeonScore

	-- Role Available
	local roleAvailable = CreateFrame("Frame", nil, filters)
	roleAvailable:Height(32)
	roleAvailable:Point("TOPLEFT", leaderDungeonScore, "BOTTOMLEFT", 0, -FILTER_BUTTON_SPACING)
	roleAvailable:Point("TOPRIGHT", leaderDungeonScore, "BOTTOMRIGHT", 0, -FILTER_BUTTON_SPACING)
	roleAvailable:SetTemplate()

	roleAvailable.text = roleAvailable:CreateFontString(nil, "OVERLAY")
	roleAvailable.text:SetFont(E.media.normFont, 11 + self.db.rightPanel.adjustFontSize, "OUTLINE")
	roleAvailable.text:Point("CENTER", roleAvailable, "CENTER", 0, 0)
	roleAvailable.text:SetText(L["Role Available"])
	roleAvailable.text:SetJustifyH("CENTER")

	-- Need Tank
	local needTank = CreateFrame("Frame", nil, filters)
	needTank:Height(28)
	needTank:Point("TOPLEFT", roleAvailable, "BOTTOMLEFT", 0, -FILTER_BUTTON_SPACING)
	needTank:Point("RIGHT", roleAvailable, "BOTTOM", -FILTER_BUTTON_SPACING / 2, -FILTER_BUTTON_SPACING - 14)
	needTank:SetTemplate()

	needTank.text = needTank:CreateFontString(nil, "OVERLAY")
	needTank.text:SetFont(E.media.normFont, 11 + self.db.rightPanel.adjustFontSize, "OUTLINE")
	needTank.text:Point("CENTER", needTank, "CENTER", 0, 0)
	needTank.text:SetText(L["Has Tank"])
	needTank.text:SetJustifyH("CENTER")

	-- Need Healer
	local needHealer = CreateFrame("Frame", nil, filters)
	needHealer:Height(28)
	needHealer:Point("LEFT", roleAvailable, "BOTTOM", FILTER_BUTTON_SPACING / 2, -FILTER_BUTTON_SPACING - 14)
	needHealer:Point("TOPRIGHT", roleAvailable, "BOTTOMRIGHT", 0, -FILTER_BUTTON_SPACING)
	needHealer:SetTemplate()

	needHealer.text = needHealer:CreateFontString(nil, "OVERLAY")
	needHealer.text:SetFont(E.media.normFont, 11 + self.db.rightPanel.adjustFontSize, "OUTLINE")
	needHealer.text:Point("CENTER", needHealer, "CENTER", 0, 0)
	needHealer.text:SetText(L["Has Healer"])
	needHealer.text:SetJustifyH("CENTER")

	roleAvailable:SetScript("OnEnter", function(btn)
		_G.GameTooltip:SetOwner(btn, "ANCHOR_TOP", 0, 4)
		_G.GameTooltip:AddLine(F.GetWindStyleText(L["Role Available"]), 1, 1, 1)
		_G.GameTooltip:AddLine(
			format(
				"%s %s %s",
				L["Enable this filter will only show the group that fits you or your group members to join."],
				L["It will check the role of current party members if you are in a group."],
				L["Otherwise, it will filter with your current specialization."]
			),
			1,
			1,
			1,
			true
		)
		_G.GameTooltip:Show()
	end)

	roleAvailable:SetScript("OnLeave", function(btn)
		_G.GameTooltip:Hide()
	end)

	addSetActive(roleAvailable)

	roleAvailable:SetScript("OnMouseDown", function(btn, button)
		if button ~= "LeftButton" then
			return
		end
		local dfDB = self:GetPlayerDB("dungeonFilter")
		btn:SetActive(not btn.active)
		if not self.db.rightPanel.disableSafeFilters and btn.active then
			needTank:SetActive(false)
			needHealer:SetActive(false)
			dfDB.needTankEnable = false
			dfDB.needHealerEnable = false
		end

		dfDB.roleAvailableEnable = btn.active
		self:UpdateAdvancedFilters()
		self:RefreshSearch()
	end)

	filters.roleAvailable = roleAvailable

	needTank:SetScript("OnEnter", function(btn)
		_G.GameTooltip:SetOwner(btn, "ANCHOR_TOP", 0, 4)
		_G.GameTooltip:AddLine(F.GetWindStyleText(L["Has Tank"]), 1, 1, 1)
		_G.GameTooltip:AddLine(
			format(
				"%s %s",
				L["Enable this filter will only show the group that have the tank already in party."],
				L["If you already have a tank in your group and you use the 'Role Available' filter, it won't find any match."]
			),
			1,
			1,
			1,
			true
		)
		_G.GameTooltip:Show()
	end)

	needTank:SetScript("OnLeave", function(btn)
		_G.GameTooltip:Hide()
	end)

	addSetActive(needTank)

	needTank:SetScript("OnMouseDown", function(btn, button)
		if button == "LeftButton" then
			local dfDB = self:GetPlayerDB("dungeonFilter")
			btn:SetActive(not btn.active)
			if not self.db.rightPanel.disableSafeFilters and btn.active then
				roleAvailable:SetActive(false)
				dfDB.roleAvailableEnable = false
			end
			dfDB.needTankEnable = btn.active
			self:UpdateAdvancedFilters()
			LL:RefreshSearch()
		end
	end)

	filters.needTank = needTank

	needHealer:SetScript("OnEnter", function(btn)
		_G.GameTooltip:SetOwner(btn, "ANCHOR_TOP", 0, 4)
		_G.GameTooltip:AddLine(F.GetWindStyleText(L["Has Healer"]), 1, 1, 1)
		_G.GameTooltip:AddLine(
			format(
				"%s %s",
				L["Enable this filter will only show the group that have the healer already in party."],
				L["If you already have a healer in your group and you use the 'Role Available' filter, it won't find any match."]
			),
			1,
			1,
			1,
			true
		)
		_G.GameTooltip:Show()
	end)

	needHealer:SetScript("OnLeave", function(btn)
		_G.GameTooltip:Hide()
	end)

	addSetActive(needHealer)

	needHealer:SetScript("OnMouseDown", function(btn, button)
		if button == "LeftButton" then
			local dfDB = self:GetPlayerDB("dungeonFilter")
			btn:SetActive(not btn.active)
			if not self.db.rightPanel.disableSafeFilters and btn.active then
				roleAvailable:SetActive(false)
				dfDB.roleAvailableEnable = false
			end
			dfDB.needHealerEnable = btn.active
			self:UpdateAdvancedFilters()
			LL:RefreshSearch()
		end
	end)

	filters.needHealer = needHealer

	frame.filters = filters

	local vaultStatus = CreateFrame("Frame", nil, frame)
	vaultStatus:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)
	vaultStatus:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 10)
	vaultStatus:Height(32)
	vaultStatus:SetTemplate()

	-- Hide vault status in Timerunning mode
	if PlayerIsTimerunning() then
		vaultStatus:Hide()
	end

	addSetActive(vaultStatus)

	vaultStatus.text = vaultStatus:CreateFontString(nil, "OVERLAY")
	vaultStatus.text:SetFont(E.media.normFont, 13 + self.db.rightPanel.adjustFontSize, "OUTLINE")
	vaultStatus.text:Point("CENTER", vaultStatus, "CENTER", 0, 0)
	vaultStatus.text:SetJustifyH("CENTER")

	vaultStatus:SetScript("OnEnter", function(btn)
		vaultStatus:SetActive(true)

		btn.update()
		if not btn.cache then
			return
		end

		_G.GameTooltip:SetOwner(btn, "ANCHOR_TOP", 0, 4)
		_G.GameTooltip:AddLine(F.GetWindStyleText(L["The Great Vault"]), 1, 1, 1)
		_G.GameTooltip:AddLine(" ")

		for i = 1, 8 do
			if btn.cache[i] then
				local mapID = btn.cache[i].mapID
				local mapData = mythicPlusMapData[mapID]
				if mapData then
					local level = btn.cache[i].level
					local iconString = F.GetIconString(mapData.tex, 14, 16, true)
					_G.GameTooltip:AddDoubleLine(
						format("%s %s %s", C.StringWithKeystoneLevel(tostring(level), level), iconString, mapData.name),
						vaultItemLevel[min(level, #vaultItemLevel)],
						1,
						1,
						1,
						(i == 1 or i == 4 or i == 8) and 0 or 1,
						1,
						(i == 1 or i == 4 or i == 8) and 0 or 1
					)
				end
			else
				break
			end
		end

		if #btn.cache == 0 then
			_G.GameTooltip:AddLine(L["No weekly runs found."], 1, 1, 1)
		end

		_G.GameTooltip:AddLine(" ")
		_G.GameTooltip:AddLine(L["Click to open the weekly rewards frame."], 1, 1, 1)

		_G.GameTooltip:Show()
	end)

	vaultStatus:SetScript("OnLeave", function()
		vaultStatus:SetActive(false)
		_G.GameTooltip:Hide()
	end)

	vaultStatus:SetScript("OnMouseDown", function(btn, button)
		if button == "LeftButton" and not InCombatLockdown() then
			WeeklyRewards_ShowUI()
		end
	end)

	vaultStatus.update = function()
		local vaultStatusCache = {}
		local runHistory = C_MythicPlus_GetRunHistory(false, true)
		local comparison = function(entry1, entry2)
			if entry1.level == entry2.level then
				return entry1.mapChallengeModeID < entry2.mapChallengeModeID
			else
				return entry1.level > entry2.level
			end
		end

		sort(runHistory, comparison)

		for i = 1, #runHistory do
			tinsert(vaultStatusCache, {
				mapID = runHistory[i].mapChallengeModeID,
				level = runHistory[i].level,
				score = runHistory[i].score,
			})
		end

		local vaultItemString = C.StringByTemplate(L["No Mythic+ Runs"], "gray-400")

		if #vaultStatusCache > 0 then
			vaultItemString = C.StringWithKeystoneLevel(tostring(vaultStatusCache[1].level), vaultStatusCache[1].level)
		end

		if #vaultStatusCache > 3 then
			vaultItemString = vaultItemString
				.. " / "
				.. C.StringWithKeystoneLevel(tostring(vaultStatusCache[4].level), vaultStatusCache[4].level)
		end

		if #vaultStatusCache > 7 then
			vaultItemString = vaultItemString
				.. " / "
				.. C.StringWithKeystoneLevel(tostring(vaultStatusCache[8].level), vaultStatusCache[8].level)
		end

		vaultStatus.cache = vaultStatusCache
		vaultStatus.text:SetText(vaultItemString)
	end

	frame.vaultStatus = vaultStatus

	local sortPanel = CreateFrame("Frame", nil, frame)
	-- In Timerunning mode, anchor to frame bottom instead of vaultStatus
	if PlayerIsTimerunning() then
		sortPanel:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)
		sortPanel:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 10)
	else
		sortPanel:Point("BOTTOMLEFT", vaultStatus, "TOPLEFT", 0, 8)
		sortPanel:Point("BOTTOMRIGHT", vaultStatus, "TOPRIGHT", 0, 8)
	end
	sortPanel:Height(32)

	local sortModeButton = CreateFrame("Frame", nil, sortPanel)
	sortModeButton:Point("RIGHT", sortPanel, "RIGHT", 0, 0)
	sortModeButton:Size(32, 32)
	sortModeButton:SetTemplate()
	sortModeButton.tex = sortModeButton:CreateTexture(nil, "OVERLAY")
	sortModeButton.tex:Size(24, 24)
	sortModeButton.tex:Point("CENTER", sortModeButton, "CENTER", 0, 0)
	sortModeButton.tex:SetTexture(W.Media.Textures.arrowDown)
	sortModeButton.tex:SetTexCoord(0, 1, 0, 1)
	sortModeButton.tex:SetVertexColor(1, 1, 1)

	addSetActive(sortModeButton)

	sortModeButton:SetScript("OnEnter", function(btn)
		sortModeButton:SetActive(true)

		_G.GameTooltip:SetOwner(btn, "ANCHOR_RIGHT", 4, -34)
		_G.GameTooltip:AddLine(btn.descending and L["Descending"] or L["Ascending"], 1, 1, 1)
		_G.GameTooltip:Show()
	end)

	sortModeButton:SetScript("OnLeave", function()
		sortModeButton:SetActive(false)
		_G.GameTooltip:Hide()
	end)

	sortModeButton:SetScript("OnMouseDown", function(btn, button)
		if button == "LeftButton" then
			local dfDB = self:GetPlayerDB("dungeonFilter")

			btn.descending = not btn.descending
			btn.tex:SetRotation(btn.descending and 0 or 3.14)
			LL:RefreshSearch()
			dfDB.sortDescending = btn.descending

			_G.GameTooltip:ClearLines()
			_G.GameTooltip:SetOwner(btn, "ANCHOR_RIGHT", 4, -34)
			_G.GameTooltip:AddLine(btn.descending and L["Descending"] or L["Ascending"], 1, 1, 1)
			_G.GameTooltip:Show()
		end
	end)

	sortPanel.sortModeButton = sortModeButton

	local sortByButton = CreateFrame("Frame", nil, sortPanel)
	sortByButton:Point("LEFT", sortPanel, "LEFT", 0, 0)
	sortByButton:Point("RIGHT", sortModeButton, "LEFT", -6, 0)
	sortByButton:Height(32)
	sortByButton:SetTemplate()

	addSetActive(sortByButton)

	sortByButton.text = sortByButton:CreateFontString(nil, "OVERLAY")
	sortByButton.text:SetFont(E.media.normFont, 12 + self.db.rightPanel.adjustFontSize, "OUTLINE")
	sortByButton.text:Point("CENTER", sortByButton, "CENTER", 0, 0)

	sortByButton.title = sortByButton:CreateFontString(nil, "OVERLAY")
	sortByButton.title:SetFont(E.media.normFont, 12 + self.db.rightPanel.adjustFontSize, "OUTLINE")
	sortByButton.title:Point("CENTER", sortByButton, "TOP", 0, 0)
	sortByButton.title:SetText(F.GetWindStyleText(L["Sort by"]))
	sortByButton.title:Hide()

	sortByButton:SetScript("OnEnter", function(btn)
		sortByButton:SetActive(true)
		sortByButton.title:Show()

		local tooltip = btn.sortBy and sortMode[btn.sortBy] and sortMode[btn.sortBy].tooltip
		_G.GameTooltip:SetOwner(btn, "ANCHOR_LEFT", -4, -34)
		_G.GameTooltip:AddLine(tooltip or "", 1, 1, 1)
		_G.GameTooltip:Show()
	end)

	sortByButton:SetScript("OnLeave", function()
		sortByButton:SetActive(false)
		sortByButton.title:Hide()
		_G.GameTooltip:Hide()
	end)

	sortByButton:SetScript("OnMouseDown", function(btn, button)
		if button == "LeftButton" then
			local dfDB = self:GetPlayerDB("dungeonFilter")

			if btn.sortBy then
				local currentModeID
				for i, mode in ipairs(availableSortMode) do
					if mode == btn.sortBy then
						currentModeID = i
						break
					end
				end

				btn.sortBy = currentModeID and availableSortMode[currentModeID + 1] or availableSortMode[1]
			end

			sortByButton.text:SetText(sortMode[btn.sortBy].text)
			LL:RefreshSearch()
			dfDB.sortBy = btn.sortBy

			local tooltip = btn.sortBy and sortMode[btn.sortBy] and sortMode[btn.sortBy].tooltip
			_G.GameTooltip:ClearLines()
			_G.GameTooltip:SetOwner(btn, "ANCHOR_LEFT", -4, -34)
			_G.GameTooltip:AddLine(tooltip or "", 1, 1, 1)
			_G.GameTooltip:Show()

			sortByButton.UpdatePosition()
		end
	end)

	sortByButton.UpdatePosition = function()
		if sortByButton.sortBy == "DEFAULT" then
			sortModeButton:Hide()
			sortByButton:ClearAllPoints()
			sortByButton:Point("LEFT", sortPanel, "LEFT", 0, 0)
			sortByButton:Point("RIGHT", sortPanel, "RIGHT", 0, 0)
		else
			sortModeButton:Show()
			sortByButton:ClearAllPoints()
			sortByButton:Point("LEFT", sortPanel, "LEFT", 0, 0)
			sortByButton:Point("RIGHT", sortModeButton, "LEFT", -6, 0)
		end
	end

	sortPanel.sortByButton = sortByButton
	frame.sortPanel = sortPanel

	-- Quick Access Panel
	local quickAccessPanel = CreateFrame("Frame", nil, frame)
	quickAccessPanel:Point("TOPLEFT", frame.affixes, "BOTTOMLEFT", 0, -10)
	-- In Timerunning mode, anchor to frame bottom instead of vaultStatus
	if PlayerIsTimerunning() then
		quickAccessPanel:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -PANEL_PADDING, PANEL_PADDING)
	else
		quickAccessPanel:Point("BOTTOMRIGHT", frame.vaultStatus, "TOPRIGHT", 0, 10)
	end

	-- Quick Access Title
	local quickAccessTitle = quickAccessPanel:CreateFontString(nil, "OVERLAY")
	F.SetFont(quickAccessTitle, nil, 16 + self.db.rightPanel.adjustFontSize)
	quickAccessTitle:SetJustifyH("CENTER")
	quickAccessTitle:SetJustifyV("MIDDLE")
	quickAccessTitle:Point("TOPLEFT", quickAccessPanel, "TOPLEFT", 0, 0)
	quickAccessTitle:Point("BOTTOMRIGHT", quickAccessPanel, "TOPRIGHT", 0, -60)
	quickAccessTitle:SetText(F.GetWindStyleText(L["Quick Access"]))

	local quickAccessButtons = {}

	-- Find the categoryID and filters when click the category button
	-- hooksecurefunc("LFGListSearchPanel_SetCategory", function(searchPanel, categoryID, filters, baseFilters)
	-- 	print(categoryID, filters, baseFilters)
	-- end)
	local buttonData = {
		{ text = L["Mythic+"], categoryID = GROUP_FINDER_CATEGORY_ID_DUNGEONS, filters = 0 },
		{ text = L["Raids"], categoryID = 3, filters = 1 },
		{ text = L["Delves"], categoryID = 121, filters = 0, disableIfTimerunning = true },
		{ text = L["Quest"], categoryID = 1, filters = 0 },
		{ text = L["Custom"], categoryID = GROUP_FINDER_CUSTOM_CATEGORY, filters = 0, disableIfTimerunning = true },
	}

	local playerIsTimerunning = PlayerIsTimerunning()
	local prevButton
	for _, data in ipairs(buttonData) do
		if not playerIsTimerunning or not data.disableIfTimerunning then
			local button = CreateFrame("Frame", nil, quickAccessPanel)
			if not prevButton then
				button:Point("TOPLEFT", quickAccessTitle, "BOTTOMLEFT")
				button:Point("BOTTOMRIGHT", quickAccessTitle, "BOTTOMRIGHT", 0, -64)
			else
				button:Point("TOPLEFT", prevButton, "BOTTOMLEFT", 0, -FILTER_BUTTON_SPACING)
				button:Point("BOTTOMRIGHT", prevButton, "BOTTOMRIGHT", 0, -32 - FILTER_BUTTON_SPACING)
			end
			prevButton = button
			button:SetTemplate()
			addSetActive(button)

			button.text = button:CreateFontString(nil, "OVERLAY")
			button.text:SetFont(E.media.normFont, 12 + self.db.rightPanel.adjustFontSize, "OUTLINE")
			button.text:Point("CENTER", button, "CENTER", 0, 0)
			button.text:SetText(data.text)

			button.categoryID = data.categoryID

			button:SetScript("OnEnter", function(btn)
				btn:SetActive(true)
			end)

			button:SetScript("OnLeave", function(btn)
				btn:SetActive(false)
			end)

			button:SetScript("OnMouseDown", function(_, mouseButton)
				if mouseButton ~= "LeftButton" then
					return
				end

				if _G.PVEFrame.activeTabIndex ~= 1 then
					_G.PVEFrame_ShowFrame("GroupFinderFrame")
				end

				if not _G.LFGListFrame.SearchPanel:IsShown() or _G.GroupFinderFrame.selection ~= _G.LFGListPVEStub then
					local PremadeGroupButton = _G.PVEFrame:ScenariosEnabled() and _G.GroupFinderFrame.groupButton4
						or _G.GroupFinderFrame.groupButton3
					GroupFinderFrameGroupButton_OnClick(PremadeGroupButton)
				end

				local searchPanel, selection = _G.LFGListFrame.SearchPanel, _G.LFGListFrame.CategorySelection
				if not selection or not searchPanel then
					return
				end

				for _, categoryButton in ipairs(selection.CategoryButtons) do
					if categoryButton.categoryID == data.categoryID and categoryButton.filters == data.filters then
						local baseFilters = _G.LFGListFrame.baseFilters

						-- Set the selectedCategory and selectedFilters to a not nil value will cause taint, needs cleanup later
						self.needTaintCleanup = true
						selection.selectedCategory = data.categoryID
						selection.selectedFilters = data.filters

						LFGListSearchPanel_Clear(searchPanel)
						LFGListSearchPanel_SetCategory(searchPanel, data.categoryID, data.filters, baseFilters)
						LFGListSearchPanel_DoSearch(searchPanel)
						_G.LFGListFrame_SetActivePanel(_G.LFGListFrame, searchPanel)
						return
					end
				end
			end)

			-- Prehook the back button to clear the selectedCategory and selectedFilters to avoid taint
			local backButtonOnClick = _G.LFGListFrame.SearchPanel.BackButton:GetScript("OnClick")
			_G.LFGListFrame.SearchPanel.BackButton:SetScript("OnClick", function(...)
				if self.needTaintCleanup then
					_G.LFGListFrame.CategorySelection.selectedCategory = nil
					_G.LFGListFrame.CategorySelection.selectedFilters = nil
				end
				backButtonOnClick(...)
			end)

			button:SetActive(false)
			tinsert(quickAccessButtons, button)
		end
	end

	quickAccessPanel.title = quickAccessTitle
	quickAccessPanel.buttons = quickAccessButtons
	frame.quickAccessPanel = quickAccessPanel

	self.rightPanel = frame
end

function LL:UpdateRightPanel()
	if not self.db.rightPanel.enable then
		if self.rightPanel then
			self.rightPanel:Hide()
		end
		return
	end

	if not _G.PVEFrame:IsVisible() then
		if self.rightPanel then
			self.rightPanel:Hide()
		end
		return
	end

	if not self.rightPanel then
		self:InitializeRightPanel()
	end

	local isDungeonMode = _G.PVEFrame.activeTabIndex == 1
		and _G.GroupFinderFrame.selection == _G.LFGListPVEStub
		and _G.LFGListFrame.SearchPanel:IsShown()
		and _G.LFGListFrame.SearchPanel.categoryID == 2

	self.rightPanel.filters:SetShown(isDungeonMode)
	self.rightPanel.sortPanel:SetShown(isDungeonMode)
	self.rightPanel.quickAccessPanel:SetShown(not isDungeonMode)
	self.rightPanel:Width(isDungeonMode and self.rightPanel.FilterPanelWidth or QUICK_ACCESS_PANEL_WIDTH)

	local dfDB = self:GetPlayerDB("dungeonFilter")
	for mapID, btn in pairs(self.rightPanel.filters.buttons) do
		btn:SetActive(dfDB[mapID])
	end

	self.rightPanel.filters.leaderScore:SetActive(dfDB.leaderScoreEnable)
	self.rightPanel.filters.leaderScore.editBox:SetText(tostring(dfDB.leaderScore or 0))
	self.rightPanel.filters.leaderDungeonScore:SetActive(dfDB.leaderDungeonScoreEnable)
	self.rightPanel.filters.leaderDungeonScore.editBox:SetText(tostring(dfDB.leaderDungeonScore or 0))
	self.rightPanel.filters.roleAvailable:SetActive(dfDB.roleAvailableEnable)
	self.rightPanel.filters.needTank:SetActive(dfDB.needTankEnable)
	self.rightPanel.filters.needHealer:SetActive(dfDB.needHealerEnable)

	self.rightPanel.vaultStatus.update()
	self.rightPanel.vaultStatus:SetActive(false)

	if dfDB.sortDescending == nil then
		dfDB.sortDescending = true
	end

	self.rightPanel.sortPanel.sortModeButton.descending = not not dfDB.sortDescending
	self.rightPanel.sortPanel.sortModeButton.tex:SetRotation(dfDB.sortDescending and 0 or 3.14)
	self.rightPanel.sortPanel.sortModeButton:SetActive(false)

	if dfDB.sortBy then
		self.rightPanel.sortPanel.sortByButton.sortBy = dfDB.sortBy
		self.rightPanel.sortPanel.sortByButton.text:SetText(sortMode[dfDB.sortBy].text)
	else
		self.rightPanel.sortPanel.sortByButton.sortBy = availableSortMode[1]
		self.rightPanel.sortPanel.sortByButton.text:SetText(sortMode[availableSortMode[1]].text)
	end

	self.rightPanel.sortPanel.sortByButton:SetActive(false)
	self.rightPanel.sortPanel.sortByButton.UpdatePosition()

	self.rightPanel:Show()
	self:UpdateAdvancedFilters()
end

function LL:LFGListEventHandler(event)
	if event == "ACTIVE_PLAYER_SPECIALIZATION_CHANGED" or event == "GROUP_ROSTER_UPDATE" then
		self:UpdateAdvancedFilters()
	end
end

function LL:GetPartyRoles()
	local partyMember = { TANK = 0, HEALER = 0, DAMAGER = 0 }

	if IsInGroup() then
		local playerRole = UnitGroupRolesAssigned("player")
		if partyMember[playerRole] then
			partyMember[playerRole] = partyMember[playerRole] + 1
		end

		local numMembers = GetNumGroupMembers()
		if numMembers >= 2 then
			for i = 1, numMembers - 1 do
				local role = UnitGroupRolesAssigned("party" .. i)
				if partyMember[role] then
					partyMember[role] = partyMember[role] + 1
				end
			end
		end
	else
		local specIndex = C_SpecializationInfo_GetSpecialization()
		local role = specIndex and select(5, C_SpecializationInfo_GetSpecializationInfo(specIndex))
		if partyMember[role] then
			partyMember[role] = partyMember[role] + 1
		end
	end

	return partyMember
end

function LL:UpdateAdvancedFilters()
	local advFilters = C_LFGList_GetAdvancedFilter()
	local partyMember = self:GetPartyRoles()
	local dfDB = self:GetPlayerDB("dungeonFilter")

	-- Role available (Partyfit) -> Try to set correct filters based on group roles, juggling "needs/has" in the advFilters
	if dfDB.roleAvailableEnable then
		advFilters.needsTank = partyMember.TANK > 0
		advFilters.needsHealer = partyMember.HEALER > 0
		advFilters.needsDamage = partyMember.DAMAGER > 0
	else
		advFilters.needsTank = false
		advFilters.needsHealer = false
		advFilters.needsDamage = false
	end

	advFilters.hasTank = dfDB.needTankEnable
	advFilters.hasHealer = dfDB.needHealerEnable
	advFilters.minimumRating = dfDB.leaderScoreEnable and dfDB.leaderScore or 0

	local activities = {}
	local numActiveMaps = 0
	for mapID, data in pairs(W:GetMythicPlusMapData()) do
		if dfDB[mapID] then
			tinsert(activities, data.activityID)
			numActiveMaps = numActiveMaps + 1
		end
	end

	if numActiveMaps == 0 then
		if PlayerIsTimerunning() then
			tAppendAll(activities, timerunningGroups)
		else
			tAppendAll(activities, seasonGroups)
			tAppendAll(activities, expansionGroups)
		end
	end

	advFilters.activities = activities

	C_LFGList_SaveAdvancedFilter(advFilters)
end

function LL:OnUpdateResultList(searchPanel)
	local results = CopyTable(searchPanel.results, true)
	if _G.LFGListFrame.SearchPanel.categoryID ~= 2 then
		return
	end

	if not self.db.enable or not self.db.rightPanel.enable or not results or #results == 0 then
		return
	end

	local dfDB = self:GetPlayerDB("dungeonFilter")

	local pendingResults = {}
	local waitForSortingResults = {}

	local partyMember = self:GetPartyRoles()
	for _, resultID in ipairs(results) do
		local pendingStatus = select(3, C_LFGList_GetApplicationInfo(resultID))
		if pendingStatus then
			tinsert(pendingResults, resultID)
		else
			local verified = true
			local searchResultInfo = C_LFGList_GetSearchResultInfo(resultID)

			local sortCache = { id = resultID, leaderOverallScore = 0, leaderScore = 0 }

			if searchResultInfo.leaderOverallDungeonScore then
				sortCache.leaderOverallScore = searchResultInfo.leaderOverallDungeonScore
			end

			if
				searchResultInfo.leaderDungeonScoreInfo
				and searchResultInfo.leaderDungeonScoreInfo[1]
				and searchResultInfo.leaderDungeonScoreInfo[1].mapScore
			then
				sortCache.leaderScore = searchResultInfo.leaderDungeonScoreInfo[1].mapScore
			end

			-- Role available (Party fit) => missing checks on damagers from the 10.2.7 advanced filters
			if dfDB.roleAvailableEnable then
				local resultRoles = { TANK = 0, HEALER = 0, DAMAGER = 0 }

				for i = 1, searchResultInfo.numMembers do
					local info = C_LFGList_GetSearchResultPlayerInfo(resultID, i)
					if info then
						local role = info.assignedRole
						if resultRoles[role] then
							resultRoles[role] = resultRoles[role] + 1
						end
					end
				end

				if partyMember.DAMAGER + resultRoles.DAMAGER > 3 then
					verified = false
				end
			end

			if verified then
				tinsert(waitForSortingResults, sortCache)
			end
		end
	end

	local sortBy = dfDB.sortBy or availableSortMode[1]
	if sortMode[sortBy].func then
		sort(waitForSortingResults, function(a, b)
			if not a or not b then
				return false
			end

			local result = sortMode[sortBy].func(a, b)
			result = dfDB.sortDescending and result or result * -1
			return result == 1
		end)
	end

	wipe(results)

	for _, result in ipairs(pendingResults) do
		tinsert(results, result)
	end

	for _, result in ipairs(waitForSortingResults) do
		tinsert(results, result.id)
	end

	searchPanel.results = results
	searchPanel.totalResults = #results
	_G.LFGListSearchPanel_UpdateResults(searchPanel)
end

function LL:GROUP_ROSTER_UPDATE(...)
	self:RequestKeystoneData()
	self:LFGListEventHandler(...)
end

function LL:Initialize()
	if C_AddOns_IsAddOnLoaded("PremadeGroupsFilter") then
		self.StopRunning = "Premade Groups Filter"
		return
	end

	self.db = E.private.WT.misc.lfgList
	if not self.db.enable then
		return
	end

	if not C_AddOns_IsAddOnLoaded("Blizzard_ChallengesUI") then
		C_AddOns_LoadAddOn("Blizzard_ChallengesUI")
	end

	C_MythicPlus.RequestCurrentAffixes()
	C_MythicPlus.RequestMapInfo()

	self:SecureHook("LFGListGroupDataDisplayEnumerate_Update", "UpdateEnumerate")
	self:SecureHook("LFGListGroupDataDisplayRoleCount_Update", "UpdateRoleCount")

	self:SecureHook(_G.PVEFrame, "Show", function()
		self:RequestKeystoneData()
		self:UpdateRightPanel()
	end)
	self:SecureHook("LFGListFrame_SetActivePanel", "UpdateRightPanel")
	self:SecureHook("GroupFinderFrame_ShowGroupFrame", "UpdateRightPanel")
	self:SecureHook("PVEFrame_ShowFrame", "UpdateRightPanel")
	self:SecureHook("LFGListSearchPanel_UpdateResultList", "OnUpdateResultList")
	self:SecureHook("LFGListSearchPanel_DoSearch", function()
		LL.lastRefreshTimestamp = GetTime()
	end)

	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "RequestKeystoneData")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "RequestKeystoneData")
	self:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED", "LFGListEventHandler")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")

	E:Delay(2, self.RequestKeystoneData, self)
	E:Delay(2, self.UpdatePartyKeystoneFrame, self)
end

W:RegisterModule(LL:GetName())
