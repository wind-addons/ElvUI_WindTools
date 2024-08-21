local W, F, E, L = unpack((select(2, ...)))
local EC = E:GetModule("Chat")
local S = W.Modules.Skins

local _G = _G

function S:ElvUI_ChatVoicePanel()
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.chatVoicePanel) then
		return
	end

	if _G.ElvUIChatVoicePanel then
		self:CreateShadow(_G.ElvUIChatVoicePanel)
	end
end

S:AddCallback("ElvUI_ChatVoicePanel")
