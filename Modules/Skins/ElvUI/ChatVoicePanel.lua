local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local EC = E:GetModule("Chat")
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("ElvUI_ChatVoicePanel")
data.check = function()
	return (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.chatVoicePanel)
end

local _G = _G

function S:ElvUI_ChatVoicePanel()
	if _G.ElvUIChatVoicePanel then
		self:CreateShadow(_G.ElvUIChatVoicePanel)
	end
end

