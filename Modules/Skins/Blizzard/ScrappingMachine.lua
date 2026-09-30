local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_ScrappingMachineUI", nil, "scrapping", "scrappingMachine")

function S:Blizzard_ScrappingMachineUI()
	self:CreateShadow(_G.ScrappingMachineFrame)
end
