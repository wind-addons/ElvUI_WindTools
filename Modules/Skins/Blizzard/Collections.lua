local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_Collections()
	if not self:CheckDB("collections") then
		return
	end

	self:CreateShadow(_G.CollectionsJournal)
	self:CreateShadow(_G.WardrobeFrame)
	self:CreateShadow(_G.WardrobeOutfitEditFrame)

	for i = 1, 6 do
		local tab = _G["CollectionsJournalTab" .. i]
		if tab then
			if tab.SetPushedTextOffset then
				tab:SetPushedTextOffset(0, 0)
			end
			self:ReskinTab(tab)
		end
	end
end

S:AddCallbackForAddon("Blizzard_Collections")
