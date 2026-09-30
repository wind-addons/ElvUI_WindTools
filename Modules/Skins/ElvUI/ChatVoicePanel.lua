local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local EC = E:GetModule("Chat")
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallback("ElvUI_ChatVoicePanel", S:CreateElvUICheck("chatVoicePanel"))

function S:ElvUI_ChatVoicePanel()
	if _G.ElvUIChatVoicePanel then
		self:CreateShadow(_G.ElvUIChatVoicePanel)
	end
end
