local E, _, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local L = unpack(select(2, ...))
local DT = E:GetModule('DataTexts')

--Cache global variables
--Lua functions
local _G = _G
local format = format

--WoW API / Variables
local EasyMenu = EasyMenu
local menuFrame = CreateFrame("Frame", "MicroMenuDatatextMenu", E.UIParent, "UIDropDownMenuTemplate")

local microMenu = {
    {text = MAINMENU_BUTTON, isTitle = true, notCheckable=true},
	{text = CHARACTER_BUTTON, func = function() ToggleCharacter("PaperDollFrame") end, notCheckable = true},
	{text = SPELLBOOK_ABILITIES_BUTTON, func = function() ToggleFrame(SpellBookFrame) end, notCheckable = true},
	{text = TALENTS_BUTTON,	func = function() if (not PlayerTalentFrame) then TalentFrame_LoadUI() end ShowUIPanel(PlayerTalentFrame) end, notCheckable = true},
	{text = ACHIEVEMENT_BUTTON, func = function() ToggleAchievementFrame() end, notCheckable = true},
	{text = MOUNTS, func = function() ToggleCollectionsJournal(1) end, notCheckable = true},
	{text = PETS, func = function() ToggleCollectionsJournal(2) end, notCheckable = true},
	{text = TOY_BOX, func = function() ToggleCollectionsJournal(3) end, notCheckable = true},
	{text = HEIRLOOMS, func = function() ToggleCollectionsJournal(4) end, notCheckable = true},
	{text = SOCIAL_BUTTON, func = function() ToggleFriendsFrame(1) end,	notCheckable = true},
	{text = ACHIEVEMENTS_GUILD_TAB, func = function() if IsInGuild() then if (not CommunitiesFrame) then LoadAddOn("Blizzard_Communities") end ToggleFrame(CommunitiesFrame) else if (not LookingForGuildFrame) then LookingForGuildFrame_LoadUI() end LookingForGuildFrame_Toggle() end end, notCheckable = true},
	{text = COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVE.." / "..COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVP, func = function() PVEFrame_ToggleFrame() end, notCheckable = true},
	{text = RAID, func = function() ToggleFriendsFrame(3) end, notCheckable = true},
	{text = ENCOUNTER_JOURNAL, func = function() ToggleEncounterJournal() end, notCheckable = true},
	{text = HELP_BUTTON, func = function() ToggleHelpFrame() end, notCheckable = true},
	{text = "|cfffe7b2cElvUI|r", func = function() E:ToggleConfig() end, notCheckable = true},
	{text = L["WindTools"], func = function() E:ToggleConfig("WindTools") end, notCheckable = true},
}

local function OnEvent(self, event, unit)
	self.text:SetFormattedText("%s", MAINMENU_BUTTON)
end

local function OnClick(self, button)
	if button == 'LeftButton' then
		EasyMenu(microMenu, menuFrame, "cursor", -50, 220, "MENU")
	end

	if button == 'RightButton' then
		ToggleFrame(GameMenuFrame)
	end
end

DT:RegisterDatatext(L["MicroMenu"], {"PLAYER_ENTERING_WORLD"}, OnEvent, nil, OnClick)