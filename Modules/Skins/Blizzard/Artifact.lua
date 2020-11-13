local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_ArtifactUI()
    if not self:CheckDB("artifact") then
        return
    end

    self:CreateBackdropShadowAfterElvUISkins(_G.ArtifactFrame)

    for i = 1, 2 do
		S:ReskinTab(_G['ArtifactFrameTab' .. i])
	end
end

S:AddCallbackForAddon("Blizzard_ArtifactUI")
