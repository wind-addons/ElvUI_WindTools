local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local DT = E:GetModule("DataTexts")

local _G = _G

local format = format

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local IsInGuild = IsInGuild
local ToggleFrame = ToggleFrame
local UIErrorsFrame = UIErrorsFrame

local MenuUtil_CreateContextMenu = MenuUtil.CreateContextMenu

local dropdown =
	CreateFrame("DropdownButton", "WTMicroMenuDatatextMenuDropDown", E.UIParent, "WowStyle1DropdownTemplate")

local function GenerateDayContextMenu(owner, rootDescription)
	rootDescription:SetTag("WT_MICRO_MENU")

	rootDescription:CreateTitle(_G.MAINMENU_BUTTON)
	rootDescription:CreateButton(_G.CHARACTER_BUTTON, function()
		_G.ToggleCharacter("PaperDollFrame")
	end)
	rootDescription:CreateButton(_G.SPELLBOOK, function()
		_G.PlayerSpellsUtil.ToggleSpellBookFrame()
	end)
	rootDescription:CreateButton(_G.TALENTS_BUTTON, function()
		_G.PlayerSpellsUtil.ToggleClassTalentFrame()
	end)
	rootDescription:CreateButton(_G.ACHIEVEMENT_BUTTON, function()
		_G.ToggleAchievementFrame()
	end)
	rootDescription:CreateButton(_G.MOUNTS, function()
		_G.ToggleCollectionsJournal(1)
	end)
	rootDescription:CreateButton(_G.PETS, function()
		_G.ToggleCollectionsJournal(2)
	end)
	rootDescription:CreateButton(_G.TOY_BOX, function()
		_G.ToggleCollectionsJournal(3)
	end)
	rootDescription:CreateButton(_G.HEIRLOOMS, function()
		_G.ToggleCollectionsJournal(4)
	end)
	rootDescription:CreateButton(_G.SOCIAL_BUTTON, function()
		_G.ToggleFriendsFrame(1)
	end)
	rootDescription:CreateButton(_G.ACHIEVEMENTS_GUILD_TAB, function()
		if IsInGuild() then
			_G.ToggleGuildFrame()
		else
			_G.ToggleGuildFinder()
		end
	end)
	rootDescription:CreateButton(
		_G.COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVE .. " / " .. _G.COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVP,
		function()
			_G.PVEFrame_ToggleFrame()
		end
	)
	rootDescription:CreateButton(_G.RAID, function()
		_G.ToggleFriendsFrame(3)
	end)
	rootDescription:CreateButton(_G.ENCOUNTER_JOURNAL, function()
		_G.ToggleEncounterJournal()
	end)
	rootDescription:CreateButton(_G.HELP_BUTTON, function()
		_G.ToggleHelpFrame()
	end)
	rootDescription:CreateButton("|cfffe7b2cElvUI|r", function()
		E:ToggleOptions()
	end)
	rootDescription:CreateButton(W.Title, function()
		E:ToggleOptions("WindTools")
	end)
end

local function OnEvent(self, event, unit)
	self.text:SetFormattedText("%s", _G.MAINMENU_BUTTON)
end

local function OnClick(self, button)
	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
		return
	end

	if button == "LeftButton" then
		MenuUtil_CreateContextMenu(self, GenerateDayContextMenu)
	elseif button == "RightButton" then
		ToggleFrame(_G.GameMenuFrame)
	end
end

DT:RegisterDatatext("Micro Menu", nil, { "PLAYER_ENTERING_WORLD" }, OnEvent, nil, OnClick, nil, nil, L["Micro Menu"])
