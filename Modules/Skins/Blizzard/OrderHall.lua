local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_OrderHallUI")
data.toggle = "orderhall"
data.private = "orderHall"

local _G = _G

function S:Blizzard_OrderHallUI()
	self:CreateShadow(_G.OrderHallTalentFrame)
end

