local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

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
	F.SetFontOutline(_G.AzeriteRespecFrame.TitleText)
end

S:AddCallbackForAddon("Blizzard_AzeriteRespecUI")
