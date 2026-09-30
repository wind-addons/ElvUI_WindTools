local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

local next = next

S:AddCallbackForAddon("Blizzard_ProfessionsCustomerOrders", nil, "tradeskill", "professionsCustomerOrders")

function S:Blizzard_ProfessionsCustomerOrders()
	self:CreateShadow(_G.ProfessionsCustomerOrdersFrame)

	for _, tab in next, _G.ProfessionsCustomerOrdersFrame.Tabs do
		self:ReskinTab(tab)
	end
end
