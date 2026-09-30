local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local next = next

S:AddCallbackForAddon("Blizzard_ExpansionLandingPage", nil, "expansionLanding", "expansionLandingPage")

function S:Blizzard_ExpansionLandingPage()
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
