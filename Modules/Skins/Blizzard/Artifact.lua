local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_ArtifactUI()
	if not self:CheckDB("artifact") then
		return
	end

	self:CreateBackdropShadow(_G.ArtifactFrame)

	for i = 1, 2 do
		S:ReskinTab(_G["ArtifactFrameTab" .. i])
	end
end

S:AddCallbackForAddon("Blizzard_ArtifactUI")
