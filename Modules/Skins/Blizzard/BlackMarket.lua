local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_BlackMarketUI()
	if not self:CheckDB("bmah", "blackMarket") then
		return
	end

	self:CreateShadow(_G.BlackMarketFrame)
end

S:AddCallbackForAddon("Blizzard_BlackMarketUI")
