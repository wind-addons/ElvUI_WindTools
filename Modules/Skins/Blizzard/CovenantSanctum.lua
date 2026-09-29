local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_CovenantSanctum")
data.toggle = "covenantSanctum"

local _G = _G

function S:Blizzard_CovenantSanctum()
	self:CreateShadow(_G.CovenantSanctumFrame)
end

