local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local OT = W:NewModule("ObjectiveTracker", "AceHook-3.0", "AceEvent-3.0") ---@class ObjectiveTracker : AceModule, AceHook-3.0, AceEvent-3.0
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
local GetKeysArray = GetKeysArray

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

---@type table<string, string>
local replaceRules = {}
local numReplaceRules = #GetKeysArray(replaceRules)

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

---Sort quest watches after waiting for C_QuestLog to be available
function OT:SortQuestWatches()
	F.WaitFor(function()
		return _G.C_QuestLog ~= nil
	end, function()
		_G.C_QuestLog.SortQuestWatches()
	end)
end

---Create and configure cosmetic bar for objective tracker header
---@param header ObjectiveTrackerModuleHeaderTemplate The header frame to add cosmetic bar to
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
	bar.backdrop.shadow:SetShown(self.db.cosmeticBar.border == "SHADOW")
	bar.backdrop:SetShown(self.db.cosmeticBar.border ~= "NONE")

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
	bar:Point("LEFT", header.Text, "LEFT", self.db.cosmeticBar.offsetX, self.db.cosmeticBar.offsetY)

	-- Size
	local width, height = self.db.cosmeticBar.width, self.db.cosmeticBar.height
	if self.db.cosmeticBar.widthMode == "DYNAMIC" then
		width = width + header.Text:GetStringWidth()
	end
	if self.db.cosmeticBar.heightMode == "DYNAMIC" then
		height = height + header.Text:GetStringHeight()
	end

	bar:Size(max(width, 1), max(height, 1))
	bar:Show()
end

function OT:RefreshAllCosmeticBars()
	for _, tracker in pairs(trackers) do
		self:CosmeticBar(tracker.Header)
	end

	self:SortQuestWatches()
end

function OT:UpdateBackdrop()
	local frame = _G.ObjectiveTrackerFrame
	if not frame then
		return
	end

	local config = self.db.backdrop

	if not config.enable then
		if frame.backdrop then
			frame.backdrop:Hide()
		end
		return
	end

	if not frame.backdrop then
		frame:CreateBackdrop()
		S:CreateBackdropShadow(frame)
	end

	frame.backdrop:Show()
	frame.backdrop:SetTemplate(config.transparent and "Transparent")
	S:Reposition(
		frame.backdrop,
		frame,
		0,
		config.topLeftOffsetY + 10,
		-config.bottomRightOffsetY + 10,
		-config.bottomRightOffsetX + 20,
		config.topLeftOffsetX + 15
	)
end

---Add colorful progression and percentage to objective tracker text
---@param text FontString? The text object to modify
function OT:ColorfulProgression(text)
	if not text or (not self.db.colorfulProgress and not self.db.percentage) then
		return
	end

	local raw = text:GetText()
	if not raw then
		return
	end

	local current, required, details = strmatch(raw, "^(%d+)/(%d+) (.+)")
	if not current then
		details, current, required = strmatch(raw, "(.+): (%d+)/(%d+)$")
	end

	if not (current and required and details) then
		return
	end

	local currentNum, requiredNum = tonumber(current), tonumber(required)
	local progress = currentNum / requiredNum

	local progressText = current .. "/" .. required ---@type string
	if self.db.colorfulProgress then
		local progressColor = F.GetProgressColor(progress)
		progressText = F.CreateColorString(progressText, progressColor) --[[@as string]]
	end

	---@cast details string
	local result = progressText .. " " .. details

	if self.db.percentage then
		local percentage = format(" [%.f%%]", progress * 100)
		if self.db.colorfulPercentage then
			local progressColor = F.GetProgressColor(progress)
			percentage = F.CreateColorString(percentage, progressColor) --[[@as string]]
		end
		result = result .. percentage
	end

	text:SetText(result)
end

---Shorten the header text based on the rules defined in `replaceRules`
---@param headerText ObjectiveTrackerModuleHeaderTemplate_Text
function OT:ShortHeader(headerText)
	if numReplaceRules == 0 or not self.db or not self.db.header or not self.db.header.shortHeader then
		return
	end

	local key = F.Strings.Replace(headerText:GetText(), {
		["\239\188\140"] = ", ",
		["\239\188\141"] = ".",
	})

	if replaceRules[key] then
		headerText:SetText(replaceRules[key])
	end
end

---Override SetTextColor for block header text with custom colors
---@param text FontString The text object
---@param r number Red component
---@param g number Green component
---@param b number Blue component
---@param a number Alpha component
function OT:BlockHeaderText_SetTextColor(text, r, g, b, a)
	if not self.db or not self.db.enable or not self.db.titleColor then
		return self.hooks[text].SetTextColor(text, r, g, b, a)
	end

	local rgba = { r = r, g = g, b = b, a = a }
	rgba = OverrideColor(rgba, self.db.titleColor, "Header", "HeaderHighlight")
	self.hooks[text].SetTextColor(text, rgba.r, rgba.g, rgba.b, rgba.a)
end

---Override SetTextColor for line text with custom colors
---@param text FontString The text object
---@param r number Red component
---@param g number Green component
---@param b number Blue component
---@param a number Alpha component
function OT:LineText_SetTextColor(text, r, g, b, a)
	if not self.db or not self.db.enable or not self.db.infoColor then
		return self.hooks[text].SetTextColor(text, r, g, b, a)
	end

	local rgba = { r = r, g = g, b = b, a = a }
	rgba = OverrideColor(rgba, self.db.infoColor, "Normal", "NormalHighlight")
	self.hooks[text].SetTextColor(text, rgba.r, rgba.g, rgba.b, rgba.a)
end

---@param frame ObjectiveTrackerBlockTemplate|{Text: FontString}
function OT:HandleBlockHeader(frame)
	local text = frame.HeaderText or frame.Text
	if not text then
		return
	end

	F.SetFontWithDB(text, self.db.title)
	text:Height(text:GetStringHeight() + 2)

	if not self:IsHooked(text, "SetTextColor") then
		self:RawHook(text, "SetTextColor", "BlockHeaderText_SetTextColor", true)
		self:BlockHeaderText_SetTextColor(
			text,
			C.ExtractColorFromTable(_G.OBJECTIVE_TRACKER_COLOR["Header"], { a = 1 })
		)
	end
end

---Handle container header text styling for the objective tracker header
---@param frame ObjectiveTrackerContainerHeaderTemplate The header element to style
function OT:HandleContainerHeader(frame)
	if not self.db.menuTitle.enable then
		return
	end

	F.SetFontWithDB(frame.Text, self.db.menuTitle.font)

	if not F.IsMethodInternalized(frame.Text, "SetTextColor") then
		F.InternalizeMethod(frame.Text, "SetTextColor", true)

		local color = self.db.menuTitle.classColor and E.myClassColor or self.db.menuTitle.color
		F.CallMethod(frame.Text, "SetTextColor", C.ExtractColorFromTable(color))
	end
end

---Handle line styling and progression display for objective tracker lines
---@param line Frame The line frame to handle
---@param _ any The objective key identifier
function OT:HandleLine(line, _)
	if self.db.noDash then
		if line.Dash then
			line.Dash:Hide()
			line.Dash:SetText(nil)
		end

		local raw = line.Text:GetText()
		if raw and raw ~= "" and strfind(raw, "^%- ") then
			line.Text:SetText(gsub(raw, "^%- ", ""))
		end
	end

	F.SetFontWithDB(line.Text, self.db.info)

	if not self:IsHooked(line.Text, "SetTextColor") then
		self:RawHook(line.Text, "SetTextColor", "LineText_SetTextColor", true)
		self:LineText_SetTextColor(line.Text, C.ExtractColorFromTable(_G.OBJECTIVE_TRACKER_COLOR["Normal"], { a = 1 }))
	end

	self:ColorfulProgression(line.Text)
	line:Height(line.Text:GetHeight())
end

---Handle objective block addition
---@param block ObjectiveTrackerBlockTemplate The block that had an objective added
function OT:ObjectiveTrackerBlock_AddObjective(block)
	self:HandleLine(block.lastRegion)
end

---Update scenario objective tracker criteria and hide dash icons when needed
---@param tracker ScenarioObjectiveTracker
---@param numCriteria number
function OT:ScenarioObjectiveTracker_UpdateCriteria(tracker, numCriteria)
	if not self.db.noDash then
		return
	end

	local objectivesBlock = tracker.ObjectivesBlock
	for criteriaIndex = 1, numCriteria do
		local existingLine = objectivesBlock:GetExistingLine(criteriaIndex)
		existingLine.Icon:Hide()
	end
end

---Handle tracker module updates, applying cosmetic bar, font styling, and header modifications
---@param tracker ObjectiveTrackerModuleTemplate The tracker module being updated
function OT:ObjectiveTrackerModule_Update(tracker)
	self:CosmeticBar(tracker.Header)

	local headerText = tracker.Header.Text
	F.SetFontWithDB(headerText, self.db.header)

	if not F.IsMethodInternalized(headerText, "SetFontObject") then
		F.InternalizeMethod(headerText, "SetFontObject", true)
		F.CallMethod(headerText, "SetFontObject", nil)
	end

	self:ShortHeader(headerText)

	local color = self.db.header.classColor and E.myClassColor or self.db.header.color
	headerText:SetTextColor(color.r, color.g, color.b)
end

---Handles the addition of a new objective tracker block by setting up hooks and processing its elements
---@param _ ObjectiveTrackerModuleTemplate? The objective tracker module (unused)
---@param block any The objective tracker block that was added
function OT:ObjectiveTrackerModule_AddBlock(_, block)
	if not block or not block.AddObjective then
		-- ScenarioObjectiveTrackerStageMixin has some custom behavior
		return
	end

	if not self:IsHooked(block, "AddObjective") then
		self:SecureHook(block, "AddObjective", "ObjectiveTrackerBlock_AddObjective")
	end

	self:HandleBlockHeader(block)
	block:ForEachUsedLine(function(line, objectiveKey)
		self:HandleLine(line, objectiveKey)
	end)
end

---Initialize the ObjectiveTracker module with hooks and settings
function OT:Initialize()
	self.db = E.private.WT.quest.objectiveTracker
	if not self.db.enable then
		return
	end

	for _, tracker in pairs(trackers) do
		self:SecureHook(tracker, "Update", "ObjectiveTrackerModule_Update")
		self:SecureHook(tracker, "AddBlock", "ObjectiveTrackerModule_AddBlock")
		tracker:EnumerateActiveBlocks(function(block)
			self:ObjectiveTrackerModule_AddBlock(nil, block)
		end)
	end
	self:SecureHook(_G.ScenarioObjectiveTracker, "UpdateCriteria", "ScenarioObjectiveTracker_UpdateCriteria")

	self:HandleContainerHeader(_G.ObjectiveTrackerFrame.Header)
	self:UpdateBackdrop()
	self:SortQuestWatches()
end

W:RegisterModule(OT:GetName())
