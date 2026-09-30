local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_SubscriptionInterstitialUI", nil, "subscriptionInterstitial")

function S:Blizzard_SubscriptionInterstitialUI()
	self:CreateShadow(_G.SubscriptionInterstitialFrame)
end
