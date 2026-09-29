local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_ProfessionsBook")
data.toggle = "spellbook"
data.private = "professionBook"

local _G = _G

function S:Blizzard_ProfessionsBook()
	self:CreateShadow(_G.ProfessionsBookFrame)
end

