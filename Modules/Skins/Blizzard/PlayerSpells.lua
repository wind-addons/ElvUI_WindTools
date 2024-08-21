local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local next = next

function S:Blizzard_PlayerSpells()
	if not self:CheckDB("talent", "playerSpells") then
		return
	end

	self:CreateShadow(_G.PlayerSpellsFrame)

	for _, tab in next, { _G.PlayerSpellsFrame.TabSystem:GetChildren() } do
		self:ReskinTab(tab)
	end

	local SpellBookFrame = _G.PlayerSpellsFrame.SpellBookFrame
	if SpellBookFrame then
		for _, tab in next, { SpellBookFrame.CategoryTabSystem:GetChildren() } do
			self:ReskinTab(tab)
		end
	end
end

S:AddCallbackForAddon("Blizzard_PlayerSpells")
