local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, table, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

function S:Blizzard_ScrappingMachineUI()
	if not self:CheckDB("scrapping", "scrappingMachine") then
		return
	end

	self:CreateShadow(_G.ScrappingMachineFrame)
end

S:AddCallbackForAddon("Blizzard_ScrappingMachineUI")
