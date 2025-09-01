local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local OT = W:NewModule("ObjectiveTracker", "AceHook-3.0", "AceEvent-3.0") ---@class ObjectiveTracker : AceModule, AceHook-3.0, AceEvent-3.0
local C = W.Utilities.Color
local S = W.Modules.Skins ---@type Skins
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

---@type ObjectiveTrackerModuleTemplate[]
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
	local replaceRules = {}

	function OT:ShortTitle(title)
		if title and #replaceRules > 0 then
			local key = F.Strings.Replace(title, {
				["\239\188\140"] = ", ",
				["\239\188\141"] = ".",
			})

			return replaceRules[key] or title
		end

		return title
	end
end

---@class RGB
---@field r number
---@field g number
---@field b number

---@class RGBA : RGB
---@field a number

---Override the Blizzard text color used in objective tracker
---@param rgba RGBA The RGBA color table
---@param config {classColor: boolean, customColorNormal: RGB, customColorHighlight: RGB} The configuration table
---@param normal string The key of normal color in OBJECTIVE_TRACKER_COLOR
---@param highlight string The key of highlight color in OBJECTIVE_TRACKER_COLOR
---@return RGBA newRGBA The overridden RGBA color table
local function OverrideColor(rgba, config, normal, highlight)
	local targetColor ---@type RGB?
	if C.IsRGBEqual(_G.OBJECTIVE_TRACKER_COLOR[normal], rgba) then
		targetColor = config.classColor and E.myClassColor or config.customColorNormal
	elseif C.IsRGBEqual(_G.OBJECTIVE_TRACKER_COLOR[highlight], rgba) then
		targetColor = config.classColor and E.myClassColor or config.customColorHighlight
	end

	if targetColor then
		rgba.r, rgba.g, rgba.b = targetColor.r, targetColor.g, targetColor.b
	end

	return rgba
end

function OT:TitleText_SetTextColor(text, r, g, b, a)
	if not self.db or not self.db.enable or not self.db.titleColor then
		return self.hooks[text].SetTextColor(text, r, g, b, a)
	end

	local rgba = { r = r, g = g, b = b, a = a }
	rgba = OverrideColor(rgba, self.db.titleColor, "Header", "HeaderHighlight")
	self.hooks[text].SetTextColor(text, rgba.r, rgba.g, rgba.b, rgba.a)
end

function OT:InfoText_SetTextColor(text, r, g, b, a)
	if not self.db or not self.db.enable or not self.db.infoColor then
		return self.hooks[text].SetTextColor(text, r, g, b, a)
	end

	local rgba = { r = r, g = g, b = b, a = a }
	rgba = OverrideColor(rgba, self.db.infoColor, "Normal", "NormalHighlight")
	self.hooks[text].SetTextColor(text, rgba.r, rgba.g, rgba.b, rgba.a)
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
		bar:SetVertexColor(C.ExtractColorFromTable(E.myClassColor))
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

	bar:Size(max(width, 1), max(height, 1))

	bar:Show()
end

---@param tracker ObjectiveTrackerModuleTemplate
function OT:ObjectiveTrackerModule_Update(tracker)
	if not tracker or not tracker.Header or not tracker.Header.Text then
		return
	end

	self:CosmeticBar(tracker.Header)
	local text = tracker.Header.Text
	F.SetFontWithDB(text, self.db.header)
	if not text.__SetFontObject then
		text.__SetFontObject = text.SetFontObject
		text:SetFontObject(nil)
		text.SetFontObject = E.noop
	end

	if self.db.header.shortHeader then
		text:SetText(self:ShortTitle(text:GetText()))
	end

	local color = self.db.header.classColor and E.myClassColor or self.db.header.color
	text:SetTextColor(color.r, color.g, color.b)
end

---@param text ObjectiveTrackerModuleHeaderTemplate_Text
function OT:HandleTitleText(text)
	F.SetFontWithDB(text, self.db.title)

	local height = text:GetStringHeight() + 2
	if height ~= text:GetHeight() then
		text:Height(height)
	end

	if not self:IsHooked(text, "SetTextColor") then
		self:RawHook(text, "SetTextColor", "TitleText_SetTextColor", true)
		self:TitleText_SetTextColor(text, C.ExtractColorFromTable(_G.OBJECTIVE_TRACKER_COLOR["Header"], { a = 1 }))
	end
end

---@param text ObjectiveTrackerContainerHeaderTemplate_Text
function OT:HandleMenuText(text)
	if not self.db.menuTitle.enable then
		return
	end

	F.SetFontWithDB(text, self.db.menuTitle.font)

	if not text.windHooked then
		text.windHooked = true
		if self.db.menuTitle.classColor then
			text:SetTextColor(C.ExtractColorFromTable(E.myClassColor))
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

	if not self:IsHooked(line.Text, "SetTextColor") then
		self:RawHook(line.Text, "SetTextColor", "InfoText_SetTextColor", true)
		self:InfoText_SetTextColor(line.Text, C.ExtractColorFromTable(_G.OBJECTIVE_TRACKER_COLOR["Normal"], { a = 1 }))
	end

	self:ColorfulProgression(line.Text)
	line:Height(line.Text:GetHeight())
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
