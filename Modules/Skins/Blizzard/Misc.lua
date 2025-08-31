local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local ES = E.Skins

local _G = _G
local pairs = pairs

local CreateFrame = CreateFrame

local function createShadow(frame)
	S:CreateBackdropShadow(frame)
end

function S:Blizzard_DeathRecap()
	self:CreateBackdropShadow(_G.DeathRecapFrame)
end

function S:SkinSkipButton(frame)
	if not frame then
		return
	end

	local dialog = frame.closeDialog or frame.CloseDialog

	if dialog then
		self:CreateShadow(dialog)
	end
end

function S:BlizzardMiscFrames()
	if not self:CheckDB("misc") then
		return
	end

	self:CreateBackdropShadow(_G.GameMenuFrame)
	self:CreateShadow(_G.AutoCompleteBox)

	-- Skip Frame
	self:SecureHook("CinematicFrame_UpdateLettboxForAspectRatio", "SkinSkipButton")
	self:SecureHook("MovieFrame_PlayMovie", "SkinSkipButton")

	-- Chat Menus
	local chatMenus = { "ChatMenu", "EmoteMenu", "LanguageMenu", "VoiceMacroMenu" }

	for _, menu in pairs(chatMenus) do
		local target = _G[menu] and _G[menu].NineSlice
		if target then
			self:SecureHookScript(target, "OnShow", "CreateShadow")
		end
	end

	-- Dropdown Menu
	self:SecureHook(ES, "DropDownMenu_SkinMenu", function(_, prefix, name)
		local backdrop = prefix and _G[name]
		if not backdrop then
			return
		end

		if backdrop.NineSlice then
			backdrop = backdrop.NineSlice
		end

		if backdrop.template then
			self:CreateShadow(backdrop)
		end
	end)

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
	self:SecureHook(ES, "HandleIconSelectionFrame", function(_, frame)
		self:CreateShadow(frame)
	end)

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

function S:SkinMenu(_, manager, _, menuDescription)
	local menu = manager:GetOpenMenu()
	if not menu then
		return
	end

	self:CreateBackdropShadow(menu)
	menuDescription:AddMenuAcquiredCallback(createShadow)
end

S:SecureHook(ES, "SkinMenu")
S:AddCallback("BlizzardMiscFrames")
S:AddCallbackForAddon("Blizzard_DeathRecap")
