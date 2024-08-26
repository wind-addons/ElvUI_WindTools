local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local next = next

function S:Blizzard_ExpansionLandingPage()
	if not self:CheckDB("expansionLanding", "expansionLandingPage") then
		return
	end

	local overlay = _G.ExpansionLandingPage.Overlay
	if overlay then
		local clean = E.private.skins.parchmentRemoverEnable
		for _, child in next, { overlay:GetChildren() } do
			if clean then
				self:CreateShadow(child)
			end
		end
	end
end

S:AddCallbackForAddon("Blizzard_ExpansionLandingPage")
