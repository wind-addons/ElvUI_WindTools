local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_AzeriteUI", nil, "azerite")

function S:Blizzard_AzeriteUI()
	self:CreateBackdropShadow(_G.AzeriteEmpoweredItemUI)
	if _G.AzeriteEmpoweredItemUITitleText then
		F.SetFont(_G.AzeriteEmpoweredItemUITitleText)
	end
end
