local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_ArtifactUI", nil, "artifact")

function S:Blizzard_ArtifactUI()
	self:CreateBackdropShadow(_G.ArtifactFrame)

	for i = 1, 2 do
		S:ReskinTab(_G["ArtifactFrameTab" .. i])
	end
end
