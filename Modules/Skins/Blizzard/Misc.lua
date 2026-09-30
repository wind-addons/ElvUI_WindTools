local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local ES = E.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs

local CreateFrame = CreateFrame

local miscFrames = S:AddCallback("BlizzardMiscFrames", "misc")
local menu = S:AddCallbackForAddon("Blizzard_Menu", nil, "misc")
S:AddCallbackForAddon("Blizzard_DeathRecap")

local function CreateBackdropShadow(frame)
	S:CreateBackdropShadow(frame)
end

function S:Blizzard_DeathRecap()
	self:CreateShadow(_G.DeathRecapFrame)
end

function miscFrames:SkinSkipButton() -- self is CinematicFrame / MovieFrame, not data
	if not self then
		return
	end

	local dialog = self.closeDialog or self.CloseDialog

	if dialog then
		S:CreateShadow(dialog)
	end
end

function miscFrames:DropDownMenu_SkinMenu(prefix, name) -- self is ElvUI Skins
	local backdrop = prefix and _G[name]
	if not backdrop then
		return
	end

	if backdrop.NineSlice then
		backdrop = backdrop.NineSlice
	end

	if backdrop.template then
		S:CreateShadow(backdrop)
	end
end

function miscFrames:HandleIconSelectionFrame(frame) -- self is ElvUI Skins
	S:CreateShadow(frame)
end

function S:BlizzardMiscFrames()
	self:CreateShadow(_G.AutoCompleteBox)

	-- Skip Frame
	self:SecureHook("CinematicFrame_UpdateLettboxForAspectRatio", miscFrames.SkinSkipButton)
	self:SecureHook("MovieFrame_PlayMovie", miscFrames.SkinSkipButton)

	-- Chat Menus
	local chatMenus = { "ChatMenu", "EmoteMenu", "LanguageMenu", "VoiceMacroMenu" }

	for _, menuName in pairs(chatMenus) do
		local target = _G[menuName] and _G[menuName].NineSlice
		if target then
			self:SecureHookScript(target, "OnShow", "CreateShadow")
		end
	end

	-- Dropdown Menu
	self:SecureHook(ES, "DropDownMenu_SkinMenu", miscFrames.DropDownMenu_SkinMenu)

	-- Action Status
	if _G.ActionStatus.Text then
		F.SetFontWithDB(_G.ActionStatus.Text, E.private.WT.skins.actionStatus)
	end

	-- Spirit Healer
	self:CreateShadow(_G.GhostFrameContentsFrame)

	-- Cinematic Frame
	self:CreateShadow(_G.CinematicFrameCloseDialog)

	-- Report Frame
	local reportFrameShadowContainer = CreateFrame("Frame", nil, _G.ReportFrame)
	reportFrameShadowContainer:SetAllPoints(_G.ReportFrame)
	self:CreateShadow(reportFrameShadowContainer)

	-- Stack Split Frame
	self:CreateShadow(_G.StackSplitFrame)

	-- Chat Config Frame
	self:CreateShadow(_G.ChatConfigFrame)

	-- Color Picker Frame
	self:CreateShadow(_G.ColorPickerFrame)

	-- Icon Selection Frames (After ElvUI Skin)
	self:SecureHook(ES, "HandleIconSelectionFrame", miscFrames.HandleIconSelectionFrame)

	-- Battle.net
	self:CreateShadow(_G.BattleTagInviteFrame)

	-- BasicMessageDialog
	local MessageDialog = _G.BasicMessageDialog
	if MessageDialog then
		self:CreateShadow(MessageDialog)
	end

	-- Opacity Frame
	self:CreateShadow(_G.OpacityFrame)
end

function menu:SkinMenu(manager, _, menuDescription) -- self is ElvUI skin data or the menu manager
	local openMenu = manager:GetOpenMenu()
	if not openMenu then
		return
	end

	S:CreateBackdropShadow(openMenu)
	menuDescription:AddMenuAcquiredCallback(CreateBackdropShadow)
end

function menu:OpenMenu(_, menuDescription) -- self is the menu manager
	menu:SkinMenu(self, nil, menuDescription)
end

function menu:OpenContextMenu(_, menuDescription) -- self is the menu manager
	menu:SkinMenu(self, nil, menuDescription)
end

function S:Blizzard_Menu()
	local elvuiMenu = self:GetElvUISkinData("Blizzard_Menu")
	if elvuiMenu and elvuiMenu.SkinMenu then
		-- ElvUI `data:OpenMenu` / `data:OpenContextMenu` call `data:SkinMenu` through the table
		hooksecurefunc(elvuiMenu, "SkinMenu", menu.SkinMenu)
		return
	end

	local manager = _G.Menu.GetManager()
	hooksecurefunc(manager, "OpenMenu", menu.OpenMenu)
	hooksecurefunc(manager, "OpenContextMenu", menu.OpenContextMenu)
end
