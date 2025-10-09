local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

function S:Blizzard_AzeriteRespecUI()
	if not self:CheckDB("azeriteRespec") then
		return
	end

	_G.AzeriteRespecFrame:SetClipsChildren(false)
	for _, region in pairs({ _G.AzeriteRespecFrame:GetRegions() }) do
		if region and region.GetTexture then
			if region:GetTexture() == "Interface\\Transmogrify\\EtherealLines" then
				region:ClearAllPoints()
				region:Point("TOPLEFT")
				region:Point("BOTTOMRIGHT")
			end
		end
	end

	self:CreateBackdropShadow(_G.AzeriteRespecFrame)
	F.SetFont(_G.AzeriteRespecFrame.TitleText)
end

S:AddCallbackForAddon("Blizzard_AzeriteRespecUI")
