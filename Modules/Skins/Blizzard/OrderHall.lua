local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_OrderHallUI", nil, "orderhall", "orderHall")

function S:Blizzard_OrderHallUI()
	self:CreateShadow(_G.OrderHallTalentFrame)
end
