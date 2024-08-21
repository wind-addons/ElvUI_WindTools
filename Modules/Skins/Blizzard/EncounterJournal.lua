local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local next = next
local pairs = pairs
local select = select
local tinsert = tinsert
local unpack = unpack

function S:Blizzard_EncounterJournal()
	if not self:CheckDB("encounterjournal", "encounterJournal") then
		return
	end

	self:CreateShadow(_G.EncounterJournal)

	-- Bottom tabs
	local tabs = {
		_G.EncounterJournalMonthlyActivitiesTab,
		_G.EncounterJournalSuggestTab,
		_G.EncounterJournalDungeonTab,
		_G.EncounterJournalRaidTab,
		_G.EncounterJournalLootJournalTab,
	}

	for _, tab in pairs(tabs) do
		self:ReskinTab(tab)
	end

	for _, name in next, { "overviewTab", "modelTab", "bossTab", "lootTab" } do
		local info = _G.EncounterJournal.encounter.info
		local tab = info[name]
		self:CreateBackdropShadow(tab)

		tab:ClearAllPoints()
		if name == "overviewTab" then
			tab:SetPoint("TOPLEFT", _G.EncounterJournalEncounterFrameInfo, "TOPRIGHT", 13, -55)
			hooksecurefunc(tab, "Point", function(self)
				self:ClearAllPoints()
				self:SetPoint("TOPLEFT", _G.EncounterJournalEncounterFrameInfo, "TOPRIGHT", 13, -55)
			end)
		elseif name == "lootTab" then
			tab:SetPoint("TOPLEFT", _G.EncounterJournal.encounter.info.overviewTab, "BOTTOMLEFT", 0, -4)
			hooksecurefunc(tab, "Point", function(self)
				self:ClearAllPoints()
				tab:SetPoint("TOPLEFT", _G.EncounterJournal.encounter.info.overviewTab, "BOTTOMLEFT", 0, -4)
			end)
		elseif name == "bossTab" then
			tab:SetPoint("TOPLEFT", _G.EncounterJournal.encounter.info.lootTab, "BOTTOMLEFT", 0, -4)
			hooksecurefunc(tab, "Point", function(self)
				self:ClearAllPoints()
				tab:SetPoint("TOPLEFT", _G.EncounterJournal.encounter.info.lootTab, "BOTTOMLEFT", 0, -4)
			end)
		elseif name == "modelTab" then
			tab:SetPoint("TOPLEFT", _G.EncounterJournal.encounter.info.bossTab, "BOTTOMLEFT", 0, -4)
			hooksecurefunc(tab, "Point", function(self)
				self:ClearAllPoints()
				tab:SetPoint("TOPLEFT", _G.EncounterJournal.encounter.info.bossTab, "BOTTOMLEFT", 0, -4)
			end)
		end
	end

	-- Monthly Activities
	local MAF = _G.EncounterJournalMonthlyActivitiesFrame
	if MAF and MAF.FilterList then
		MAF.FilterList:SetTemplate("Transparent")
	end
end

S:AddCallbackForAddon("Blizzard_EncounterJournal")
