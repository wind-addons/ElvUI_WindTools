local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local next = next

function S:Blizzard_PlayerSpells()
	if not self:CheckDB("talent", "playerSpells") then
		return
	end

	self:CreateBackdropShadow(_G.ClassTalentLoadoutImportDialog)
	self:CreateBackdropShadow(_G.ClassTalentLoadoutEditDialog)

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

	local TalentsSelect = _G.HeroTalentsSelectionDialog
	if TalentsSelect then
		self:CreateShadow(TalentsSelect)
		hooksecurefunc(TalentsSelect, "ShowDialog", function(frame)
			if not frame.__windSkin then
				frame.__windSkin = true
				self:HighAlphaTransparent(TalentsSelect)
			end
		end)
	end
end

S:AddCallbackForAddon("Blizzard_PlayerSpells")
