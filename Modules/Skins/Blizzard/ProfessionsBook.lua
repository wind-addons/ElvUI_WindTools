local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local next = next
local MAX_SKILLLINE_TABS = MAX_SKILLLINE_TABS

function S:Blizzard_ProfessionsBook()
	if not self:CheckDB("spellbook", "professionBook") then
		return
	end

	self:CreateShadow(_G.ProfessionsBookFrame)
end

S:AddCallbackForAddon("Blizzard_ProfessionsBook")
