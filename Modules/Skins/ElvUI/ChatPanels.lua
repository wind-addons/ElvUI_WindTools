local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local LO = E:GetModule("Layout")

local _G = _G

function S:ElvUI_ChatPanels()
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.chatPanels) then
		return
	end

	self:CreateBackdropShadow(_G.LeftChatPanel, true)
	self:CreateBackdropShadow(_G.RightChatPanel, true)
end

S:AddCallback("ElvUI_ChatPanels")
