local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

S:AddCallbackForAddon("Blizzard_AzeriteRespecUI", nil, "azeriteRespec")

function S:Blizzard_AzeriteRespecUI()
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
