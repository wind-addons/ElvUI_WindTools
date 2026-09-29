local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_ProfessionsCustomerOrders")
data.toggle = "tradeskill"
data.private = "professionsCustomerOrders"

local _G = _G

local next = next

function S:Blizzard_ProfessionsCustomerOrders()
	self:CreateShadow(_G.ProfessionsCustomerOrdersFrame)

	for _, tab in next, _G.ProfessionsCustomerOrdersFrame.Tabs do
		self:ReskinTab(tab)
	end
end

