local W, F, E, L = unpack((select(2, ...)))
local DT = E:GetModule("DataTexts")

local _G = _G

local format = format

local CreateFrame = CreateFrame
local EasyMenu = EasyMenu
local GameMenuFrame = _G.GameMenuFrame
local IsInGuild = IsInGuild

local dropdown =
	CreateFrame("DropdownButton", "WTMicroMenuDatatextMenuDropDown", E.UIParent, "WowStyle1DropdownTemplate")

local function GenerateDayContextMenu(owner, rootDescription)
	rootDescription:SetTag("WT_MICRO_MENU")

	rootDescription:CreateTitle(MAINMENU_BUTTON)
	rootDescription:CreateButton(
		CHARACTER_BUTTON,
		function()
			_G.ToggleCharacter("PaperDollFrame")
		end
	)
	rootDescription:CreateButton(
		SPELLBOOK,
		function()
			_G.PlayerSpellsUtil.ToggleSpellBookFrame()
		end
	)
	rootDescription:CreateButton(
		TALENTS_BUTTON,
		function()
			_G.PlayerSpellsUtil.ToggleClassTalentFrame()
		end
	)
	rootDescription:CreateButton(
		ACHIEVEMENT_BUTTON,
		function()
			_G.ToggleAchievementFrame()
		end
	)
	rootDescription:CreateButton(
		MOUNTS,
		function()
			_G.ToggleCollectionsJournal(1)
		end
	)
	rootDescription:CreateButton(
		PETS,
		function()
			_G.ToggleCollectionsJournal(2)
		end
	)
	rootDescription:CreateButton(
		TOY_BOX,
		function()
			_G.ToggleCollectionsJournal(3)
		end
	)
	rootDescription:CreateButton(
		HEIRLOOMS,
		function()
			_G.ToggleCollectionsJournal(4)
		end
	)
	rootDescription:CreateButton(
		SOCIAL_BUTTON,
		function()
			_G.ToggleFriendsFrame(1)
		end
	)
	rootDescription:CreateButton(
		ACHIEVEMENTS_GUILD_TAB,
		function()
			if IsInGuild() then
				_G.ToggleGuildFrame()
			else
				_G.ToggleGuildFinder()
			end
		end
	)
	rootDescription:CreateButton(
		COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVE .. " / " .. COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVP,
		function()
			_G.PVEFrame_ToggleFrame()
		end
	)
	rootDescription:CreateButton(
		RAID,
		function()
			_G.ToggleFriendsFrame(3)
		end
	)
	rootDescription:CreateButton(
		ENCOUNTER_JOURNAL,
		function()
			_G.ToggleEncounterJournal()
		end
	)
	rootDescription:CreateButton(
		HELP_BUTTON,
		function()
			_G.ToggleHelpFrame()
		end
	)
	rootDescription:CreateButton(
		"|cfffe7b2cElvUI|r",
		function()
			E:ToggleOptions()
		end
	)
	rootDescription:CreateButton(
		W.Title,
		function()
			E:ToggleOptions("WindTools")
		end
	)
end

local function OnEvent(self, event, unit)
	self.text:SetFormattedText("%s", MAINMENU_BUTTON)
end

local function OnClick(self, button)
	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
		return
	end

	if button == "LeftButton" then
		MenuUtil.CreateContextMenu(self, GenerateDayContextMenu)
	elseif button == "RightButton" then
		ToggleFrame(GameMenuFrame)
	end
end

DT:RegisterDatatext("Micro Menu", nil, {"PLAYER_ENTERING_WORLD"}, OnEvent, nil, OnClick, nil, nil, L["Micro Menu"])
