local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local ipairs = ipairs

S:AddCallbackForAddon("Blizzard_Collections", nil, "collections")

local function SkinCollectionCountFrame(frame)
	if not frame then
		return
	end

	frame:StripTextures()
	if frame.NineSlice then
		frame.NineSlice:StripTextures()
	end

	if not frame.backdrop then
		frame:CreateBackdrop("Transparent")
	end

	S:CreateBackdropShadow(frame)
end

function S:Blizzard_Collections()
	self:CreateShadow(_G.CollectionsJournal)
	self:CreateShadow(_G.WardrobeFrame)
	self:CreateShadow(_G.WardrobeOutfitEditFrame)

	if E.Forever then
		local journal = _G.CollectionsJournal
		local tabContainer = journal and journal.TabContainer
		local tabs = tabContainer and tabContainer.Tabs
		if tabs then
			for _, tab in ipairs(tabs) do
				self:Proxy("HandleLargeSideTab", tab)
				self:ReskinTab(tab)
			end
			self:Proxy("LayoutLargeSideTabs", journal, tabs)
		end

		local mountJournal = _G.MountJournal
		if mountJournal then
			SkinCollectionCountFrame(mountJournal.MountCount)
		end

		local petJournal = _G.PetJournal
		if petJournal then
			SkinCollectionCountFrame(petJournal.PetCount)
		end

		local toyBox = _G.ToyBox
		if toyBox then
			SkinCollectionCountFrame(toyBox.ProgressTracker)
		end

		local wardrobeCollectionFrame = _G.WardrobeCollectionFrame
		if wardrobeCollectionFrame then
			self:ReskinTab(wardrobeCollectionFrame.ItemsTab)
			self:ReskinTab(wardrobeCollectionFrame.SetsTab)
		end

		return
	end

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
