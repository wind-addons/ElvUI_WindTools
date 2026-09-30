local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local LO = E:GetModule("Layout")

local _G = _G

local data = S:AddCallback("ElvUI_ChatDataPanels", S:CreateElvUICheck("chatDataPanels"))

function data:ToggleShadows() -- self is the Layout module when hooked, not data
	if not E.private.WT.skins.shadow then
		return
	end

	local leftDB = E.db.datatexts.panels.LeftChatDataPanel
	local rightDB = E.db.datatexts.panels.RightChatDataPanel

	if leftDB.enable and leftDB.backdrop then
		_G.LeftChatDataPanel.shadow:Show()
	else
		_G.LeftChatDataPanel.shadow:Hide()
	end

	if rightDB.enable and rightDB.backdrop then
		_G.RightChatDataPanel.shadow:Show()
	else
		_G.RightChatDataPanel.shadow:Hide()
	end
end

function S:ElvUI_ChatDataPanels()
	self:CreateShadow(_G.LeftChatDataPanel)
	self:CreateShadow(_G.RightChatDataPanel)

	if _G.LeftChatDataPanel.shadow then
		_G.LeftChatDataPanel.shadow:Point("TOPLEFT", _G.LeftChatToggleButton, "TOPLEFT", -4, 4)
	end

	if _G.RightChatDataPanel.shadow then
		_G.RightChatDataPanel.shadow:Point("BOTTOMRIGHT", _G.RightChatToggleButton, "BOTTOMRIGHT", 4, -4)
	end

	data:ToggleShadows()
	self:SecureHook(LO, "ToggleChatPanels", data.ToggleShadows)
end
