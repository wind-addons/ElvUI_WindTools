local W, F, E, L = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")

local _G = _G

local format = format

local CreateFrame = CreateFrame
local EasyMenu = EasyMenu
local GameMenuFrame = _G.GameMenuFrame
local IsInGuild = IsInGuild
local LoadAddOn = LoadAddOn
local PVEFrame_ToggleFrame = PVEFrame_ToggleFrame
local ShowUIPanel = ShowUIPanel
local TalentFrame_LoadUI = TalentFrame_LoadUI
local ToggleAchievementFrame = ToggleAchievementFrame
local ToggleCharacter = ToggleCharacter
local ToggleCollectionsJournal = ToggleCollectionsJournal
local ToggleEncounterJournal = ToggleEncounterJournal
local ToggleFrame = ToggleFrame
local ToggleFriendsFrame = ToggleFriendsFrame
local ToggleGuildFinder = ToggleGuildFinder
local ToggleGuildFrame = ToggleGuildFrame
local ToggleHelpFrame = ToggleHelpFrame

local MAINMENU_BUTTON = MAINMENU_BUTTON

local menuFrame = CreateFrame("Frame", "WTMicroMenuDatatextMenu", E.UIParent, "UIDropDownMenuTemplate")

local microMenu = {
	{text = MAINMENU_BUTTON, isTitle = true, notCheckable = true},
	{
		text = CHARACTER_BUTTON,
		func = function()
			ToggleCharacter("PaperDollFrame")
		end,
		notCheckable = true
	},
	{
		text = SPELLBOOK_ABILITIES_BUTTON,
		func = function()
			ToggleFrame(_G.SpellBookFrame)
		end,
		notCheckable = true
	},
	{
		text = TALENTS_BUTTON,
		func = function()
			if (not _G.PlayerTalentFrame) then
				TalentFrame_LoadUI()
			end
			ShowUIPanel(_G.PlayerTalentFrame)
		end,
		notCheckable = true
	},
	{
		text = ACHIEVEMENT_BUTTON,
		func = function()
			ToggleAchievementFrame()
		end,
		notCheckable = true
	},
	{
		text = MOUNTS,
		func = function()
			ToggleCollectionsJournal(1)
		end,
		notCheckable = true
	},
	{
		text = PETS,
		func = function()
			ToggleCollectionsJournal(2)
		end,
		notCheckable = true
	},
	{
		text = TOY_BOX,
		func = function()
			ToggleCollectionsJournal(3)
		end,
		notCheckable = true
	},
	{
		text = HEIRLOOMS,
		func = function()
			ToggleCollectionsJournal(4)
		end,
		notCheckable = true
	},
	{
		text = SOCIAL_BUTTON,
		func = function()
			ToggleFriendsFrame(1)
		end,
		notCheckable = true
	},
	{
		text = ACHIEVEMENTS_GUILD_TAB,
		func = function()
			if IsInGuild() then
				ToggleGuildFrame()
			else
				ToggleGuildFinder()
			end
		end,
		notCheckable = true
	},
	{
		text = COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVE .. " / " .. COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVP,
		func = function()
			PVEFrame_ToggleFrame()
		end,
		notCheckable = true
	},
	{
		text = RAID,
		func = function()
			ToggleFriendsFrame(3)
		end,
		notCheckable = true
	},
	{
		text = ENCOUNTER_JOURNAL,
		func = function()
			ToggleEncounterJournal()
		end,
		notCheckable = true
	},
	{
		text = HELP_BUTTON,
		func = function()
			ToggleHelpFrame()
		end,
		notCheckable = true
	},
	{
		text = "|cfffe7b2cElvUI|r",
		func = function()
			E:ToggleOptionsUI()
		end,
		notCheckable = true
	},
	{
		text = W.Title,
		func = function()
			E:ToggleOptionsUI("WindTools")
		end,
		notCheckable = true
	}
}

local function OnEvent(self, event, unit)
	self.text:SetFormattedText("%s", MAINMENU_BUTTON)
end

local function OnClick(self, button)
	if button == "LeftButton" then
		EasyMenu(microMenu, menuFrame, "cursor", -50, 220, "MENU")
	end

	if button == "RightButton" then
		ToggleFrame(GameMenuFrame)
	end
end

DT:RegisterDatatext("Micro Menu", nil, {"PLAYER_ENTERING_WORLD"}, OnEvent, nil, OnClick, nil, nil, L["Micro Menu"])
