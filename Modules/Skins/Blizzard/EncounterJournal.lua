local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs

---@param tab Frame
---@param point FramePoint
---@param relativeTo Region|string
---@param relativePoint string
---@param x? number
---@param y? number
local function createPositionHook(tab, point, relativeTo, relativePoint, x, y)
	tab:ClearAllPoints()
	tab:SetPoint(point, relativeTo, relativePoint, x, y)
	---@param frame Frame
	hooksecurefunc(tab, "Point", function(frame)
		frame:ClearAllPoints()
		frame:SetPoint(point, relativeTo, relativePoint, x, y)
	end)
end

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

	-- Encounter info tabs
	local info = _G.EncounterJournal.encounter.info
	local tabPositions = {
		overviewTab = { "TOPLEFT", _G.EncounterJournalEncounterFrameInfo, "TOPRIGHT", 13, -55 },
		lootTab = { "TOPLEFT", info.overviewTab, "BOTTOMLEFT", 0, -4 },
		bossTab = { "TOPLEFT", info.lootTab, "BOTTOMLEFT", 0, -4 },
		modelTab = { "TOPLEFT", info.bossTab, "BOTTOMLEFT", 0, -4 },
	}

	for tabName, position in pairs(tabPositions) do
		local tab = info[tabName]
		if tab then
			self:CreateBackdropShadow(tab)
			createPositionHook(tab, position[1], position[2], position[3], position[4], position[5])
		end
	end

	-- Monthly Activities
	local MAF = _G.EncounterJournalMonthlyActivitiesFrame
	if MAF and MAF.FilterList then
		MAF.FilterList:SetTemplate("Transparent")
	end
end

S:AddCallbackForAddon("Blizzard_EncounterJournal")
