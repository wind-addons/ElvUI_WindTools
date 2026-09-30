local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallback("ElvUI_Panels", S:CreateElvUICheck("panels"))

function S:ElvUI_Panels()
	self:CreateShadow(_G.ElvUI_TopPanel)
	self:CreateShadow(_G.ElvUI_BottomPanel)
end
