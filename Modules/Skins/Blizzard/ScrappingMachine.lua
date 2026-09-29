local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_ScrappingMachineUI")
data.toggle = "scrapping"
data.private = "scrappingMachine"

local _G = _G

function S:Blizzard_ScrappingMachineUI()
	self:CreateShadow(_G.ScrappingMachineFrame)
end

