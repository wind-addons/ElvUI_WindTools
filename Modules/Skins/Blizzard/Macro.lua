local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_MacroUI", nil, "macro")

function S:Blizzard_MacroUI()
	self:CreateShadow(_G.MacroFrame)
	self:CreateShadow(_G.MacroPopupFrame)
end
