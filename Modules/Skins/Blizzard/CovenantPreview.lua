local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_CovenantPreviewUI", nil, "covenantPreview")

function S:Blizzard_CovenantPreviewUI()
	self:CreateShadow(_G.CovenantPreviewFrame)
end
