local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local LO = E:GetModule("Layout")

local _G = _G

function S:ElvUI_ChatPanels_ToggleShadows()
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

function S:ElvUI_ChatPanels()
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.chatDataPanels) then
		return
	end

	self:CreateShadow(_G.LeftChatDataPanel)
	self:CreateShadow(_G.RightChatDataPanel)

	if _G.LeftChatDataPanel.shadow then
		_G.LeftChatDataPanel.shadow:Point("TOPLEFT", _G.LeftChatToggleButton, "TOPLEFT", -4, 4)
	end

	if _G.RightChatDataPanel.shadow then
		_G.RightChatDataPanel.shadow:Point("BOTTOMRIGHT", _G.RightChatToggleButton, "BOTTOMRIGHT", 4, -4)
	end

	self:ElvUI_ChatPanels_ToggleShadows()
	self:SecureHook(LO, "ToggleChatPanels", "ElvUI_ChatPanels_ToggleShadows")
end

S:AddCallback("ElvUI_ChatPanels")
