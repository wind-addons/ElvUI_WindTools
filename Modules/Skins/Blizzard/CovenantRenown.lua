local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_CovenantRenown")
data.toggle = "covenantRenown"

local _G = _G

function S:Blizzard_CovenantRenown()
	self:CreateShadow(_G.CovenantRenownFrame)
end

