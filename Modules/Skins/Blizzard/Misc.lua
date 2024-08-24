local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local ES = E.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs

local CreateFrame = CreateFrame

local UIDROPDOWNMENU_MAXLEVELS = UIDROPDOWNMENU_MAXLEVELS

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

	self:CreateShadow(_G.GameMenuFrame)
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
	for i = 1, UIDROPDOWNMENU_MAXLEVELS, 1 do
		local f = _G["DropDownList" .. i .. "Backdrop"]
		self:CreateShadow(f)

		f = _G["DropDownList" .. i .. "MenuBackdrop"]
		self:CreateShadow(f)
	end

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
end

S:AddCallback("BlizzardMiscFrames")
S:AddCallbackForAddon("Blizzard_DeathRecap")
