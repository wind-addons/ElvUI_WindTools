local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_OrderHallUI()
	if not self:CheckDB("orderhall", "orderHall") then
		return
	end

	self:CreateShadow(_G.OrderHallTalentFrame)
end

S:AddCallbackForAddon("Blizzard_OrderHallUI")
