local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local ES = E.Skins

local _G = _G

function S:Blizzard_SubscriptionInterstitialUI()
	if not self:CheckDB("subscriptionInterstitial") then
		return
	end

	self:CreateShadow(_G.SubscriptionInterstitialFrame)
end

S:AddCallbackForAddon("Blizzard_SubscriptionInterstitialUI")
