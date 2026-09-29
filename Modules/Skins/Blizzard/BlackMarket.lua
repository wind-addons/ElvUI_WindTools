local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_BlackMarketUI")
data.toggle = "bmah"
data.private = "blackMarket"

local _G = _G

function S:Blizzard_BlackMarketUI()
	self:CreateShadow(_G.BlackMarketFrame)
end

