local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_ProfessionsBook()
	if not self:CheckDB("spellbook", "professionBook") then
		return
	end

	self:CreateShadow(_G.ProfessionsBookFrame)
end

S:AddCallbackForAddon("Blizzard_ProfessionsBook")
