local W, F, E, L = unpack((select(2, ...)))
local OT = W:NewModule("ObjectiveTracker", "AceHook-3.0", "AceEvent-3.0")
local C = W.Utilities.Color
local S = W.Modules.Skins
local LSM = E.Libs.LSM

local _G = _G
local format = format
local gsub = gsub
local max = max
local pairs = pairs
local strfind = strfind
local strmatch = strmatch
local tonumber = tonumber

local CreateFrame = CreateFrame
local C_QuestLog_SortQuestWatches = C_QuestLog.SortQuestWatches

local trackers = {
	_G.ScenarioObjectiveTracker,
	_G.UIWidgetObjectiveTracker,
	_G.CampaignQuestObjectiveTracker,
	_G.QuestObjectiveTracker,
	_G.AdventureObjectiveTracker,
	_G.AchievementObjectiveTracker,
	_G.MonthlyActivitiesObjectiveTracker,
	_G.ProfessionsRecipeTracker,
	_G.BonusObjectiveTracker,
	_G.WorldQuestObjectiveTracker,
}

do
	local replaceRule = {}

	function OT:ShortTitle(title)
		if not title then
			return
		end

		title = F.Strings.Replace(title, {
			["\239\188\140"] = ", ",
			["\239\188\141"] = ".",
		})

		for longName, shortName in pairs(replaceRule) do
			if longName == title then
				return shortName
			end
		end
		return title
	end
end

local function SetHeaderTextColorHook(text)
	if not text.windHooked then
		text.__WindSetTextColor = text.SetTextColor
		text.SetTextColor = function(self, r, g, b, a)
			local rgbTable = { r = r, g = g, b = b, a = a }

			if C.IsRGBEqual(_G.OBJECTIVE_TRACKER_COLOR["Header"], rgbTable) then
				if OT.db and OT.db.enable and OT.db.titleColor and OT.db.titleColor.enable then
					r = OT.db.titleColor.classColor and W.ClassColor.r or OT.db.titleColor.customColorNormal.r
					g = OT.db.titleColor.classColor and W.ClassColor.g or OT.db.titleColor.customColorNormal.g
					b = OT.db.titleColor.classColor and W.ClassColor.b or OT.db.titleColor.customColorNormal.b
				end
			elseif C.IsRGBEqual(_G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"], rgbTable) then
				if OT.db and OT.db.enable and OT.db.titleColor and OT.db.titleColor.enable then
					r = OT.db.titleColor.classColor and W.ClassColor.r or OT.db.titleColor.customColorHighlight.r
					g = OT.db.titleColor.classColor and W.ClassColor.g or OT.db.titleColor.customColorHighlight.g
					b = OT.db.titleColor.classColor and W.ClassColor.b or OT.db.titleColor.customColorHighlight.b
				end
			end
			self:__WindSetTextColor(r, g, b, a)
		end
		text:SetTextColor(C.ExtractColorFromTable(_G.OBJECTIVE_TRACKER_COLOR["Header"], { a = 1 }))
		text.windHooked = true
	end
end

local function SetInfoTextColorHook(text)
	if not text.windHooked then
		text.__WindSetTextColor = text.SetTextColor
		text.SetTextColor = function(self, r, g, b, a)
			local rgbTable = { r = r, g = g, b = b, a = a }

			if C.IsRGBEqual(_G.OBJECTIVE_TRACKER_COLOR["Normal"], rgbTable) then
				if OT.db and OT.db.enable and OT.db.infoColor and OT.db.infoColor.enable then
					r = OT.db.infoColor.classColor and W.ClassColor.r or OT.db.infoColor.customColorNormal.r
					g = OT.db.infoColor.classColor and W.ClassColor.g or OT.db.infoColor.customColorNormal.g
					b = OT.db.infoColor.classColor and W.ClassColor.b or OT.db.infoColor.customColorNormal.b
				end
			elseif C.IsRGBEqual(_G.OBJECTIVE_TRACKER_COLOR["NormalHighlight"], rgbTable) then
				if OT.db and OT.db.enable and OT.db.infoColor and OT.db.infoColor.enable then
					r = OT.db.infoColor.classColor and W.ClassColor.r or OT.db.infoColor.customColorHighlight.r
					g = OT.db.infoColor.classColor and W.ClassColor.g or OT.db.infoColor.customColorHighlight.g
					b = OT.db.infoColor.classColor and W.ClassColor.b or OT.db.infoColor.customColorHighlight.b
				end
			end
			self:__WindSetTextColor(r, g, b, a)
		end
		text:SetTextColor(C.ExtractColorFromTable(_G.OBJECTIVE_TRACKER_COLOR["Normal"], { a = 1 }))
		text.windHooked = true
	end
end

function OT:CosmeticBar(header)
	local bar = header.windCosmeticBar

	if not self.db.cosmeticBar.enable then
		if bar then
			bar:Hide()
			bar.backdrop:Hide()
		end
		return
	end

	if not bar then
		bar = header:CreateTexture()
		local backdrop = CreateFrame("Frame", nil, header)
		backdrop:SetFrameStrata("BACKGROUND")
		backdrop:SetTemplate()
		backdrop:SetOutside(bar, 1, 1)
		backdrop.Center:SetAlpha(0)
		S:CreateShadow(backdrop, 2, nil, nil, nil, true)
		bar.backdrop = backdrop
		header.windCosmeticBar = bar
	end

	-- Border
	if self.db.cosmeticBar.border == "NONE" then
		bar.backdrop:Hide()
	else
		if self.db.cosmeticBar.border == "SHADOW" then
			bar.backdrop.shadow:Show()
		else
			bar.backdrop.shadow:Hide()
		end
		bar.backdrop:Show()
	end

	-- Texture
	bar:SetTexture(LSM:Fetch("statusbar", self.db.cosmeticBar.texture) or E.media.normTex)

	-- Color
	if self.db.cosmeticBar.color.mode == "CLASS" then
		bar:SetVertexColor(C.ExtractColorFromTable(W.ClassColor))
	elseif self.db.cosmeticBar.color.mode == "NORMAL" then
		bar:SetVertexColor(C.ExtractColorFromTable(self.db.cosmeticBar.color.normalColor))
	elseif self.db.cosmeticBar.color.mode == "GRADIENT" then
		bar:SetVertexColor(1, 1, 1)
		bar:SetGradient(
			"HORIZONTAL",
			C.CreateColorFromTable(self.db.cosmeticBar.color.gradientColor1),
			C.CreateColorFromTable(self.db.cosmeticBar.color.gradientColor2)
		)
	end

	bar.backdrop:SetAlpha(self.db.cosmeticBar.borderAlpha)

	-- Position
	bar:ClearAllPoints()
	bar:SetPoint("LEFT", header.Text, "LEFT", self.db.cosmeticBar.offsetX, self.db.cosmeticBar.offsetY)

	-- Size
	local width = self.db.cosmeticBar.width
	local height = self.db.cosmeticBar.height
	if self.db.cosmeticBar.widthMode == "DYNAMIC" then
		width = width + header.Text:GetStringWidth()
	end
	if self.db.cosmeticBar.heightMode == "DYNAMIC" then
		height = height + header.Text:GetStringHeight()
	end

	bar:SetSize(max(width, 1), max(height, 1))

	bar:Show()
end

function OT:ObjectiveTrackerModule_Update(tracker)
	if tracker and tracker.Header and tracker.Header.Text then
		self:CosmeticBar(tracker.Header)
		F.SetFontWithDB(tracker.Header.Text, self.db.header)
		if not tracker.Header.Text.__windUnbind then
			tracker.Header.Text.__windUnbind = true
			tracker.Header.Text:SetFontObject(nil)
			tracker.Header.Text.SetFontObject = E.noop
		end

		local r = self.db.header.classColor and W.ClassColor.r or self.db.header.color.r
		local g = self.db.header.classColor and W.ClassColor.g or self.db.header.color.g
		local b = self.db.header.classColor and W.ClassColor.b or self.db.header.color.b

		tracker.Header.Text:SetTextColor(r, g, b)
		if self.db.header.shortHeader then
			tracker.Header.Text:SetText(self:ShortTitle(tracker.Header.Text:GetText()))
		end
	end
end

function OT:HandleTitleText(text)
	F.SetFontWithDB(text, self.db.title)
	local height = text:GetStringHeight() + 2
	if height ~= text:GetHeight() then
		text:SetHeight(height)
	end
	SetHeaderTextColorHook(text)
end

function OT:HandleMenuText(text)
	if not self.db.menuTitle.enable then
		return
	end

	F.SetFontWithDB(text, self.db.menuTitle.font)

	if not text.windHooked then
		text.windHooked = true
		if self.db.menuTitle.classColor then
			text:SetTextColor(C.ExtractColorFromTable(W.ClassColor))
		else
			text:SetTextColor(C.ExtractColorFromTable(self.db.menuTitle.color))
		end
		text.SetTextColor = E.noop
	end
end

function OT:HandleObjectiveLine(line)
	if not line or not line.Text or not self.db then
		return
	end

	if line.objectiveKey == 0 then -- World Quest Title
		self:HandleTitleText(line.Text)
		return
	end

	F.SetFontWithDB(line.Text, self.db.info)

	if self.db.noDash then
		if line.Dash then
			line.Dash:Hide()
			line.Dash:SetText(nil)
		end
	end

	if line.Text.GetText then
		local rawText = line.Text:GetText()
		if self.db.noDash then
			-- Sometimes Blizzard not use dash icon, just put a dash in front of text
			-- We need to force update the text first
			if rawText and rawText ~= "" and strfind(rawText, "^%- ") then
				rawText = gsub(rawText, "^%- ", "")
			end
		end

		line.Text:SetText(rawText)
	end

	SetInfoTextColorHook(line.Text)

	self:ColorfulProgression(line.Text)
	line:SetHeight(line.Text:GetHeight())
end

function OT:ObjectiveTrackerBlock_AddObjective(block)
	self:HandleObjectiveLine(block.lastRegion)
end

function OT:ScenarioObjectiveTracker_UpdateCriteria(tracker, numCriteria)
	if not self.db or not self.db.noDash then
		return
	end
	local objectivesBlock = tracker.ObjectivesBlock
	for criteriaIndex = 1, numCriteria do
		local existingLine = objectivesBlock:GetExistingLine(criteriaIndex)
		existingLine.Icon:Hide()
	end
end

function OT:ColorfulProgression(text)
	if not self.db or not text then
		return
	end

	local info = text:GetText()
	if not info then
		return
	end

	local current, required, details = strmatch(info, "^(%d-)/(%d-) (.+)")

	if not (current and required and details) then
		details, current, required = strmatch(info, "(.+): (%d-)/(%d-)$")
	end

	if not (current and required and details) then
		return
	end

	local progress = tonumber(current) / tonumber(required)

	if self.db.colorfulProgress then
		info = F.CreateColorString(current .. "/" .. required, F.GetProgressColor(progress))
		info = info .. " " .. details
	end

	if self.db.percentage then
		local percentage = format("[%.f%%]", progress * 100)
		if self.db.colorfulPercentage then
			percentage = F.CreateColorString(percentage, F.GetProgressColor(progress))
		end
		info = info .. " " .. percentage
	end

	text:SetText(info)
end

function OT:UpdateBackdrop()
	if not _G.ObjectiveTrackerFrame then
		return
	end

	local db = self.db.backdrop
	local backdrop = _G.ObjectiveTrackerFrame.backdrop

	if not db.enable then
		if backdrop then
			backdrop:Hide()
		end
		return
	end

	if not backdrop then
		if self.db.backdrop.enable then
			_G.ObjectiveTrackerFrame:CreateBackdrop()
			backdrop = _G.ObjectiveTrackerFrame.backdrop
			S:CreateShadow(backdrop)
		end
	end

	backdrop:Show()
	backdrop:SetTemplate(db.transparent and "Transparent")
	backdrop:ClearAllPoints()
	backdrop:SetPoint("TOPLEFT", _G.ObjectiveTrackerFrame, "TOPLEFT", db.topLeftOffsetX - 20, db.topLeftOffsetY + 10)
	backdrop:SetPoint(
		"BOTTOMRIGHT",
		_G.ObjectiveTrackerFrame,
		"BOTTOMRIGHT",
		db.bottomRightOffsetX + 10,
		db.bottomRightOffsetY - 10
	)
end

function OT:ReskinTextInsideBlock(_, block)
	if not self.db then
		return
	end

	if block.HeaderText then
		self:HandleTitleText(block.HeaderText)
	end

	for _, line in pairs(block.usedLines or {}) do
		self:HandleObjectiveLine(line)
	end
end

function OT:RefreshAllCosmeticBars()
	for _, tracker in pairs(trackers) do
		if tracker.Header then
			self:CosmeticBar(tracker.Header)
		end
	end
	C_QuestLog_SortQuestWatches()
end

function OT:ObjectiveTrackerModule_AddBlock(_, block)
	if block.__windHooked then
		return
	end
	self:ReskinTextInsideBlock(nil, block)
	if block.AddObjective then
		self:SecureHook(block, "AddObjective", "ObjectiveTrackerBlock_AddObjective")
	end
	block.__windHooked = true
end

function OT:Initialize()
	self.db = E.private.WT.quest.objectiveTracker
	if not self.db.enable then
		return
	end

	self:UpdateBackdrop()

	if not self.initialized then
		for _, tracker in pairs(trackers) do
			for _, block in pairs(tracker.usedBlocks or {}) do
				self:ObjectiveTrackerModule_AddBlock(nil, block)
			end
			self:SecureHook(tracker, "Update", "ObjectiveTrackerModule_Update")
			self:SecureHook(tracker, "AddBlock", "ObjectiveTrackerModule_AddBlock")
		end

		self:SecureHook(_G.ScenarioObjectiveTracker, "UpdateCriteria", "ScenarioObjectiveTracker_UpdateCriteria")
		self:HandleMenuText(_G.ObjectiveTrackerFrame.Header.Text)
		self.initialized = true
	end

	-- Force update all modules once we get into the game
	E:Delay(0.5, function()
		C_QuestLog_SortQuestWatches()
	end)
end

W:RegisterModule(OT:GetName())
