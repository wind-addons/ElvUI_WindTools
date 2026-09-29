local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_SubscriptionInterstitialUI")
data.toggle = "subscriptionInterstitial"

local _G = _G

function S:Blizzard_SubscriptionInterstitialUI()
	self:CreateShadow(_G.SubscriptionInterstitialFrame)
end

