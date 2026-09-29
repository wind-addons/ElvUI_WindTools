local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_ExpansionLandingPage")
data.toggle = "expansionLanding"
data.private = "expansionLandingPage"

local _G = _G
local next = next

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

