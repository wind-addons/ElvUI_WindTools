local W, F, E, L, V = unpack((select(2, ...)))
local ID = W:NewModule("InstanceDifficulty", "AceEvent-3.0", "AceHook-3.0")
local M = E:GetModule("Minimap")

local _G = _G
local format = format
local gsub = gsub
local pairs = pairs
local select = select

local CreateFrame = CreateFrame
local GetInstanceInfo = GetInstanceInfo
local IsInInstance = IsInInstance

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_ChallengeMode_GetActiveKeystoneInfo = C_ChallengeMode.GetActiveKeystoneInfo

function ID:UpdateFrame()
	local inInstance, instanceType = IsInInstance()
	local difficulty = select(3, GetInstanceInfo())
	local numplayers = select(9, GetInstanceInfo())
	local mplusdiff = select(1, C_ChallengeMode_GetActiveKeystoneInfo()) or ""

	if difficulty == 0 then
		self.frame.text:SetText("")
	elseif instanceType == "party" or instanceType == "raid" or instanceType == "scenario" then
		local text = ID:GetTextForDifficulty(difficulty, false)

		if not text then
			self:Log("debug", format("difficutly %s not found", difficulty))
			text = ""
		end

		text = gsub(text, "%%mplus%%", mplusdiff)
		text = gsub(text, "%%numPlayers%%", numplayers)
		self.frame.text:SetText(text)
	elseif instanceType == "pvp" or instanceType == "arena" then
		self.frame.text:SetText(ID:GetTextForDifficulty(-1, false))
	else
		self.frame.text:SetText("")
	end

	self.frame:SetShown(inInstance)
end

function ID:GetTextForDifficulty(difficulty, useDefault)
	local db = useDefault and V.maps.instanceDifficulty.difficulty.customStrings or self.db.difficulty.customStrings
	local text = {
		-- https://wago.tools/db2/Difficulty?page=2&sort%5BID%5D=asc
		[-1] = db["PvP"],
		[1] = db["5-player Normal"],
		[2] = db["5-player Heroic"],
		[3] = db["10-player Normal"],
		[4] = db["25-player Normal"],
		[5] = db["10-player Heroic"],
		[6] = db["25-player Heroic"],
		[7] = db["LFR"],
		[8] = db["Mythic Keystone"],
		[9] = db["40-player"],
		[11] = db["Heroic Scenario"],
		[12] = db["Normal Scenario"],
		[14] = db["Normal Raid"],
		[15] = db["Heroic Raid"],
		[16] = db["Mythic Raid"],
		[17] = db["LFR Raid"],
		[18] = db["Event Scenario"],
		[19] = db["Event Scenario"],
		[20] = db["Event Scenario"],
		[23] = db["Mythic Party"],
		[24] = db["Timewalking"],
		[25] = db["World PvP Scenario"],
		[29] = db["PvEvP Scenario"],
		[30] = db["Event Scenario"],
		[32] = db["World PvP Scenario"],
		[33] = db["Timewalking Raid"],
		[34] = db["PvP Heroic"],
		[38] = db["Normal Scenario"],
		[39] = db["Heroic Scenario"],
		[40] = db["Mythic Scenario"],
		[45] = db["PvP"],
		[147] = db["Warfronts Normal"],
		[149] = db["Warfronts Heroic"],
		[150] = db["Normal Scaling Party"],
		[151] = db["LFR"],
		[152] = db["Visions of N'Zoth"],
		[153] = db["Teeming Island"],
		[167] = db["Torghast"],
		[168] = db["Path of Ascension: Courage"],
		[169] = db["Path of Ascension: Loyalty"],
		[170] = db["Path of Ascension: Wisdom"],
		[171] = db["Path of Ascension: Humility"],
		[172] = db["World Boss"],
		[192] = db["Challenge Level 1"],
		[205] = db["Follower"],
		[208] = db["Delves"],
		[216] = db["Quest"],
		[220] = db["Story"],
		[232] = db["Event Scenario"],
		[236] = db["Lorewalking"],
	}

	return text[difficulty]
end

function ID:ConstructFrame()
	if not self.db then
		return
	end

	local frame = CreateFrame("Frame", "WTInstanceDifficultyFrame", _G.Minimap)
	frame:Size(30, 20)
	frame:Point("TOPLEFT", M.MapHolder, "TOPLEFT", 10, -10)

	local text = frame:CreateFontString(nil, "OVERLAY")
	F.SetFontWithDB(text, self.db.font)
	text:Point(self.db.align or "LEFT")
	frame.text = text

	E:CreateMover(
		frame,
		"WTInstanceDifficultyFrameMover",
		L["Instance Difficulty"],
		nil,
		nil,
		nil,
		"ALL,WINDTOOLS",
		function()
			return E.private.WT.maps.difficulty.enable
		end,
		"WindTools,maps"
	)

	self.frame = frame
end

function ID:HideBlizzardDifficulty(difficultyFrame, isShown)
	if not self.db or not self.db.hideBlizzard or not isShown then
		return
	end

	difficultyFrame:Hide()
end

function ID:ADDON_LOADED(_, addon)
	if addon == "Blizzard_Minimap" then
		self:UnregisterEvent("ADDON_LOADED")

		local difficulty = _G.MinimapCluster.InstanceDifficulty
		for _, frame in pairs({ difficulty.Default, difficulty.Guild, difficulty.ChallengeMode }) do
			frame:SetAlpha(0)
		end
	end
end

ID.GROUP_ROSTER_UPDATE = F.DelvesEventFix(ID.UpdateFrame)

function ID:Initialize()
	self.db = E.private.WT.maps.instanceDifficulty

	if not self.db or not self.db.enable then
		return
	end

	self:ConstructFrame()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateFrame")
	self:RegisterEvent("CHALLENGE_MODE_START", "UpdateFrame")
	self:RegisterEvent("CHALLENGE_MODE_COMPLETED", "UpdateFrame")
	self:RegisterEvent("CHALLENGE_MODE_RESET", "UpdateFrame")
	self:RegisterEvent("PLAYER_DIFFICULTY_CHANGED", "UpdateFrame")
	self:RegisterEvent("GUILD_PARTY_STATE_UPDATED", "UpdateFrame")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "UpdateFrame")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")

	if C_AddOns_IsAddOnLoaded("Blizzard_Minimap") then
		self:ADDON_LOADED("ADDON_LOADED", "Blizzard_Minimap")
	else
		self:RegisterEvent("ADDON_LOADED")
	end
end

W:RegisterModule(ID:GetName())
