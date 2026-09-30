local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_ProfessionsBook", nil, "spellbook", "professionBook")

function S:Blizzard_ProfessionsBook()
	self:CreateShadow(_G.ProfessionsBookFrame)
end
