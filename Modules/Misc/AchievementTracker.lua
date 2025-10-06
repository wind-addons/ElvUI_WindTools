local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local AT = W:NewModule("AchievementTracker", "AceEvent-3.0", "AceHook-3.0") ---@class AchievementTracker : AceModule, AceEvent-3.0, AceHook-3.0
local C = W.Utilities.Color
local async = W.Utilities.Async
local MF = W.Modules.MoveFrames
local S = W.Modules.Skins

local _G = _G

local floor = floor
local format = format
local ipairs = ipairs
local math_pi = math.pi
local max = max
local pairs = pairs
local select = select
local sort = sort
local tinsert = tinsert
local tremove = tremove
local unpack = unpack

local CreateFrame = CreateFrame
local GameTooltip = _G.GameTooltip
local GetAchievementCriteriaInfo = GetAchievementCriteriaInfo
local GetAchievementInfo = GetAchievementInfo
local GetAchievementNumCriteria = GetAchievementNumCriteria
local GetCategoryInfo = GetCategoryInfo
local GetCategoryList = GetCategoryList
local GetCategoryNumAchievements = GetCategoryNumAchievements
local InCombatLockdown = InCombatLockdown
local PlaySound = PlaySound

local C_AchievementInfo_GetRewardItemID = C_AchievementInfo.GetRewardItemID
local C_AchievementInfo_IsGuildAchievement = C_AchievementInfo.IsGuildAchievement
local C_AchievementInfo_IsValidAchievement = C_AchievementInfo.IsValidAchievement
local C_ContentTracking_GetTrackedIDs = C_ContentTracking.GetTrackedIDs
local C_ContentTracking_IsTracking = C_ContentTracking.IsTracking
local C_ContentTracking_StartTracking = C_ContentTracking.StartTracking
local C_ContentTracking_StopTracking = C_ContentTracking.StopTracking

local Constants_ContentTrackingConsts = Constants.ContentTrackingConsts
local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT
local Enum_ContentTrackingStopType = Enum.ContentTrackingStopType
local Enum_ContentTrackingType = Enum.ContentTrackingType
local RED_FONT_COLOR = RED_FONT_COLOR
local SOUNDKIT = SOUNDKIT

local ELEMENT_ICON_SIZE = 36
local ELEMENT_PADDING = 8
local ELEMENT_CRITERIA_LINE_HEIGHT = 12
local ELEMENT_CRITERIA_LINE_SPACING = 2
local ELEMENT_PERCENTAGE_HEIGHT = 35

---@class AchievementData
---@field id number
---@field name string
---@field description string
---@field icon number
---@field percent number
---@field completedCriteria number
---@field totalCriteria number
---@field criteria AchievementCriteria[]
---@field categoryID number
---@field categoryName string
---@field flags number
---@field rewardText string
---@field rewardItemID number|nil
---@field wasEarnedByMe boolean
---@field earnedBy string
---@field month number
---@field day number
---@field year number
---@field isStatistic boolean

---@class AchievementCriteria
---@field text string
---@field type number
---@field done boolean
---@field quantity number
---@field required number
---@field assetID number
---@field quantityString string
---@field criteriaID number
---@field eligible boolean

---@class AchievementDetails
---@field percent number
---@field completedCriteria number
---@field totalCriteria number
---@field criteria AchievementCriteria[]

AT.states = {
	isScanning = false, ---@type boolean
	isScanInitialized = false, ---@type boolean
	currentThreshold = 80, ---@type number
	results = {}, ---@type AchievementData[]
	filteredResults = {}, ---@type AchievementData[]
	filters = {
		categoryID = nil, ---@type string|nil
		hasRewards = false, ---@type boolean
		minPercent = 0, ---@type number
		searchTerm = "", ---@type string
	},
	sort = {
		by = "percent", ---@type "percent"|"name"|"category"
		order = "desc", ---@type "asc"|"desc"
	},
}

---Calculate completion percentage and get detailed info for an achievement
---@param achievementID number
---@return AchievementDetails
local function GetAchievementDetails(achievementID)
	local numCriteria = GetAchievementNumCriteria(achievementID)
	if not numCriteria or numCriteria == 0 then
		return {
			percent = 0,
			completedCriteria = 0,
			totalCriteria = 0,
			criteria = {},
		}
	end

	local completed = 0
	local criteria = {}

	for i = 1, numCriteria do
		local criteriaString, criteriaType, done, quantity, requiredQuantity, _, _, assetID, quantityString, criteriaID, eligible =
			GetAchievementCriteriaInfo(achievementID, i)
		tinsert(criteria, {
			text = criteriaString,
			type = criteriaType,
			done = done,
			quantity = quantity,
			required = requiredQuantity,
			assetID = assetID,
			quantityString = quantityString,
			criteriaID = criteriaID,
			eligible = eligible,
		})

		if done then
			completed = completed + 1
		end
	end

	return {
		percent = (completed / numCriteria) * 100,
		completedCriteria = completed,
		totalCriteria = numCriteria,
		criteria = criteria,
	}
end

---Scan all achievements and gather data based on current settings
---@param callback fun(results: AchievementData[])
---@param updateProgress fun(categoryIndex: number, achievementIndex: number, progress: number, scanned: number, total: number)
function AT:ScanAllAchievements(callback, updateProgress)
	if self.states.isScanning then
		return
	end

	self.states.isScanning = true
	self.states.results = {}

	local categories = GetCategoryList()
	local currentCategory = 1
	local currentAchievement = 1
	local totalAchievements = 0
	local scannedAchievements = 0

	for _, categoryID in ipairs(categories) do
		totalAchievements = totalAchievements + GetCategoryNumAchievements(categoryID)
	end

	local function scanStep()
		local scanned = 0

		while currentCategory <= #categories and scanned < self.db.scan.batchSize do
			local categoryID = categories[currentCategory]
			local numAchievements = GetCategoryNumAchievements(categoryID)

			if currentAchievement <= numAchievements then
				local achievementID = select(1, GetAchievementInfo(categoryID, currentAchievement))
				if
					achievementID
					and C_AchievementInfo_IsValidAchievement(achievementID)
					and not C_AchievementInfo_IsGuildAchievement(achievementID)
				then
					async.WithAchievementID(achievementID, function(achievementData)
						local _, name, _, completed, month, day, year, description, flags, icon, rewardText, _, wasEarnedByMe, earnedBy, isStatistic =
							unpack(achievementData)

						if not completed then
							local details = GetAchievementDetails(achievementID)
							if details.percent >= self.states.currentThreshold then
								local categoryName = GetCategoryInfo(categoryID)
								local rewardItemID = C_AchievementInfo_GetRewardItemID(achievementID)

								tinsert(self.states.results, {
									id = achievementID,
									name = name,
									description = description,
									icon = icon,
									percent = details.percent,
									completedCriteria = details.completedCriteria,
									totalCriteria = details.totalCriteria,
									criteria = details.criteria,
									categoryID = categoryID,
									categoryName = categoryName,
									flags = flags,
									rewardText = rewardText,
									rewardItemID = rewardItemID,
									wasEarnedByMe = wasEarnedByMe,
									earnedBy = earnedBy,
									month = month,
									day = day,
									year = year,
									isStatistic = isStatistic,
								})
							end
						end
					end)
				end
				currentAchievement = currentAchievement + 1
				scanned = scanned + 1
				scannedAchievements = scannedAchievements + 1

				if updateProgress then
					local progress = (scannedAchievements / totalAchievements) * 100
					updateProgress(
						currentCategory,
						currentAchievement,
						progress,
						scannedAchievements,
						totalAchievements
					)
				end
			else
				currentCategory = currentCategory + 1
				currentAchievement = 1
			end
		end

		if currentCategory > #categories then
			self.states.isScanning = false
			callback(self.states.filteredResults)
		else
			E:Delay(self.db.scan.delay, scanStep)
		end
	end

	scanStep()
end

function AT:StartAchievementScan()
	if not self.MainFrame or not self.MainFrame:IsShown() then
		return
	end

	local ProgressFrame = self.MainFrame.ProgressFrame
	ProgressFrame.Bar:SetValue(0)
	ProgressFrame.Bar.ProgressText:SetText("")

	self:ScanAllAchievements(function()
		ProgressFrame:Hide()
		self:UpdateView()
	end, function(_, _, progress, scanned, total)
		ProgressFrame.Bar:SetValue(progress)
		ProgressFrame.Bar.ProgressText:SetText(format("%d / %d  -  %.0f %%", scanned, total, progress))
	end)

	ProgressFrame:Show()
end

--- Set the element data for the achievement tracker
function AT:UpdateView()
	local results = tFilter(self.states.results, function(data)
		---@cast data AchievementData
		local filters = self.states.filters
		if filters.categoryID and data.categoryID ~= filters.categoryID then
			return false
		end

		if filters.hasRewards and not data.rewardItemID then
			return false
		end

		if data.percent < filters.minPercent then
			return false
		end

		if filters.searchTerm and filters.searchTerm ~= "" then
			local searchLower = strlower(filters.searchTerm)
			local nameLower = strlower(data.name)
			local descLower = strlower(data.description or "")
			if not (nameLower:find(searchLower, 1, true) or descLower:find(searchLower, 1, true)) then
				return false
			end
		end

		return true
	end)

	sort(results, function(a, b)
		local aVal, bVal

		if self.states.sort.by == "percent" then
			aVal, bVal = a.percent, b.percent
		elseif self.states.sort.by == "name" then
			aVal, bVal = a.name:lower(), b.name:lower()
		elseif self.states.sort.by == "category" then
			aVal, bVal = a.categoryName:lower(), b.categoryName:lower()
		end

		if self.states.sort.order == "desc" then
			return aVal > bVal
		else
			return aVal < bVal
		end
	end)

	results[#results].isLastElement = true

	local dataProvider = CreateDataProvider()
	dataProvider:InsertTable(results)
	self.MainFrame.ScrollFrame.ScrollView:SetDataProvider(dataProvider)
end

---Apply achievement data to a UI element
---@param frame Frame
---@param data AchievementData
function AT:ScrollElementInitializer(frame, data, scrollBox)
	frame.data = data

	if not frame.Initialized then
		frame:SetTemplate()
		frame:SetBackdropColor(C.ExtractRGBAFromTemplate("neutral-800"))
		frame:SetScript("OnEnter", function()
			frame:SetBackdropColor(C.ExtractRGBAFromTemplate("neutral-700"))
		end)
		frame:SetScript("OnLeave", function()
			frame:SetBackdropColor(C.ExtractRGBAFromTemplate("neutral-900"))
		end)

		local ProgressBackdrop = CreateFrame("StatusBar", nil, frame)
		ProgressBackdrop:Point("TOPLEFT", frame, "TOPLEFT", 1, -1)
		ProgressBackdrop:Point("BOTTOMRIGHT", frame, "TOPRIGHT", -1, 1 - (ELEMENT_ICON_SIZE + 2 * ELEMENT_PADDING))
		ProgressBackdrop:SetStatusBarTexture(E.media.normTex)
		ProgressBackdrop:SetMinMaxValues(0, 100)
		ProgressBackdrop:SetAlpha(0.2)
		ProgressBackdrop:SetFrameLevel(frame:GetFrameLevel() + 1)
		frame.ProgressBackdrop = ProgressBackdrop

		local Background = ProgressBackdrop:CreateTexture(nil, "BACKGROUND")
		Background:SetAllPoints()
		Background:SetColorTexture(C.ExtractRGBFromTemplate("neutral-950"))
		frame.ProgressBackdrop.Background = Background

		local IconFrame = CreateFrame("Frame", nil, frame, "BackdropTemplate")
		IconFrame:Size(ELEMENT_ICON_SIZE)
		IconFrame:Point("TOPLEFT", frame, "TOPLEFT", 8, -8)
		IconFrame:SetTemplate()
		IconFrame:SetFrameLevel(frame:GetFrameLevel() + 2)
		frame.IconFrame = IconFrame

		local Icon = IconFrame:CreateTexture(nil, "ARTWORK")
		Icon:SetInside(IconFrame)
		Icon:SetTexCoord(unpack(E.TexCoords))
		frame.IconFrame.Icon = Icon

		local PercentageFrame = CreateFrame("Frame", nil, frame)
		PercentageFrame:Size(64, ELEMENT_PERCENTAGE_HEIGHT)
		PercentageFrame:Point("TOPRIGHT", frame, "TOPRIGHT", -8, -8)
		frame.PercentageFrame = PercentageFrame

		local PercentageText = PercentageFrame:CreateFontString(nil, "OVERLAY")
		F.SetFontOutline(PercentageText, F.GetCompatibleFont("Accidental Presidency"), 20)
		PercentageText:SetJustifyH("RIGHT")
		PercentageText:SetJustifyV("BOTTOM")
		PercentageText:Width(
			F.GetAdaptiveTextWidth(F.GetCompatibleFont("Accidental Presidency"), 20, "OUTLINE", "%") + 2
		)
		PercentageText:Height(PercentageFrame:GetHeight())
		PercentageText:SetText("%")
		PercentageText:Point("RIGHT", PercentageFrame, "RIGHT", 0, 0)
		frame.PercentageFrame.PercentageText = PercentageText

		local ValueText = PercentageFrame:CreateFontString(nil, "OVERLAY")
		F.SetFontOutline(ValueText, F.GetCompatibleFont("Accidental Presidency"), 40)
		ValueText:SetJustifyH("RIGHT")
		ValueText:SetJustifyV("BOTTOM")
		ValueText:Height(PercentageFrame:GetHeight())
		ValueText:Point("RIGHT", PercentageText, "LEFT", 0, -4)
		frame.PercentageFrame.ValueText = ValueText

		local TextFrame = CreateFrame("Frame", nil, frame)
		TextFrame:Point("TOPLEFT", frame.IconFrame, "TOPRIGHT", 8, -4)
		TextFrame:Point("BOTTOMRIGHT", frame.PercentageFrame, "BOTTOMLEFT", -8, 0)
		frame.TextFrame = TextFrame

		local Name = TextFrame:CreateFontString(nil, "OVERLAY")
		F.SetFontOutline(Name, E.db.general.font, 15)
		Name:SetTextColor(C.ExtractRGBAFromTemplate("amber-400"))
		Name:SetJustifyH("LEFT")
		Name:Point("TOPLEFT", TextFrame, "TOPLEFT", 0, 0)
		frame.TextFrame.Name = Name

		local Category = TextFrame:CreateFontString(nil, "OVERLAY")
		F.SetFontOutline(Category, E.db.general.font, 12)
		Category:SetJustifyH("LEFT")
		Category:SetTextColor(C.ExtractRGBAFromTemplate("neutral-300"))
		Category:Point("TOPLEFT", Name, "BOTTOMLEFT", 0, -3)
		frame.TextFrame.Category = Category

		local CriteriaFrame = CreateFrame("Frame", nil, frame)
		CriteriaFrame:Point("TOPLEFT", ProgressBackdrop, "BOTTOMLEFT", 0, 0)
		CriteriaFrame:Point("TOPRIGHT", ProgressBackdrop, "BOTTOMRIGHT", 0, 0)
		CriteriaFrame:SetFrameLevel(frame:GetFrameLevel() + 2)
		CriteriaFrame:Hide()
		frame.CriteriaFrame = CriteriaFrame
		frame.CriteriaFrame.Lines = {}

		local NoCriteriaAlert = CriteriaFrame:CreateFontString(nil, "OVERLAY")
		F.SetFontOutline(NoCriteriaAlert, E.db.general.font, 12)
		NoCriteriaAlert:Point("CENTER", CriteriaFrame, "CENTER", 0, 0)
		NoCriteriaAlert:SetText(L["No Criteria"])
		NoCriteriaAlert:SetJustifyH("CENTER")
		NoCriteriaAlert:SetJustifyV("MIDDLE")
		NoCriteriaAlert:SetTextColor(C.ExtractRGBAFromTemplate("neutral-500"))
		frame.CriteriaFrame.NoCriteriaAlert = NoCriteriaAlert
		frame:EnableMouse(true)

		frame.UpdateHeight = function(self)
			if self.data.isExpanded then
				self.data.height = self.CriteriaFrame:GetHeight() + self.ProgressBackdrop:GetHeight() + 2
			else
				self.data.height = self.ProgressBackdrop:GetHeight() + 2
			end

			self:Height(self.data.height)
		end

		frame:SetScript("OnMouseDown", function(self, button)
			if button == "LeftButton" then
				self.data.isExpanded = not self.data.isExpanded
				self.CriteriaFrame:SetShown(self.data.isExpanded)
				self:UpdateHeight()

				scrollBox:FullUpdate(ScrollBoxConstants.UpdateImmediately)

				if self.data.isLastElement then
					scrollBox:ScrollToEnd()
				end
			elseif button == "MiddleButton" then
				if not C_ContentTracking_IsTracking(Enum_ContentTrackingType.Achievement, self.data.id) then
					local trackedCount = #C_ContentTracking_GetTrackedIDs(Enum_ContentTrackingType.Achievement)
					if trackedCount >= Constants_ContentTrackingConsts.MaxTrackedAchievements then
						_G.UIErrorsFrame:AddMessage(
							format(
								L["Cannot track more than %d achievements"],
								Constants_ContentTrackingConsts.MaxTrackedAchievements
							),
							RED_FONT_COLOR:GetRGBA()
						)
						return
					end

					if not C_ContentTracking_StartTracking(Enum_ContentTrackingType.Achievement, self.data.id) then
						PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
					end
				else
					C_ContentTracking_StopTracking(
						Enum_ContentTrackingType.Achievement,
						self.data.id,
						Enum_ContentTrackingStopType.Manual
					)
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
				end
			elseif button == "RightButton" then
				_G.AchievementFrame_SelectAchievement(self.data.id)
			end
		end)

		frame.Initialized = true
	end

	self:ScrollElementResetter(frame)

	local color
	if data.percent >= 90 then
		color = C.GetRGBFromTemplate("emerald-500")
	elseif data.percent >= 75 then
		color = C.GetRGBFromTemplate("green-500")
	elseif data.percent >= 60 then
		color = C.GetRGBFromTemplate("yellow-500")
	else
		color = C.GetRGBFromTemplate("orange-500")
	end
	frame.ProgressBackdrop:SetStatusBarColor(color.r, color.g, color.b)
	frame.ProgressBackdrop:SetValue(data.percent)
	frame.IconFrame.Icon:SetTexture(data.icon)
	frame.PercentageFrame.ValueText:SetText(tostring(floor(data.percent)))
	frame.TextFrame.Name:SetText(data.name)
	frame.TextFrame.Category:SetText(data.categoryName)

	frame.CriteriaFrame:SetShown(data.isExpanded)
	frame.CriteriaFrame.NoCriteriaAlert:SetShown(data.totalCriteria == 0)
	if data.totalCriteria == 0 then
		frame.CriteriaFrame:Height(ELEMENT_CRITERIA_LINE_HEIGHT + 2 * ELEMENT_PADDING)
	else
		frame.CriteriaFrame:Height(
			data.totalCriteria * (ELEMENT_CRITERIA_LINE_HEIGHT + ELEMENT_CRITERIA_LINE_SPACING)
				- ELEMENT_CRITERIA_LINE_SPACING
				+ 2 * ELEMENT_PADDING
		)
	end

	frame:UpdateHeight()

	for i, criteria in ipairs(data.criteria) do
		local line = self.MainFrame.CriteriaLinePool:Acquire() ---@type Frame
		line:SetParent(frame.CriteriaFrame)
		line:Size(frame.CriteriaFrame:GetWidth(), ELEMENT_CRITERIA_LINE_HEIGHT)

		if not line.StatusIcon then
			line.StatusIcon = line:CreateTexture(nil, "OVERLAY")
			line.StatusIcon:Size(14, 14)
			line.StatusIcon:Point("LEFT", line, "LEFT", 5, 0)
			line.StatusIcon:SetTexture(W.Media.Icons.buttonCheck)
			line.StatusIcon:SetVertexColor(C.ExtractRGBFromTemplate("emerald-500"))
		end

		if not line.Criteria then
			line.Criteria = line:CreateFontString(nil, "OVERLAY")
			F.SetFontOutline(line.Criteria, E.db.general.font, 11)
			line.Criteria:Point("LEFT", line.StatusIcon, "RIGHT", 4, 0)
			line.Criteria:Point("RIGHT", line, "RIGHT", 0, 0)
			line.Criteria:SetJustifyH("LEFT")
			line.Criteria:SetJustifyV("MIDDLE")
		end

		line.StatusIcon:SetShown(criteria.done)
		local text = criteria.text or L["Unknown"]
		if criteria.required and criteria.required > 1 then
			text = text .. format(" (%d/%d)", criteria.quantity or 0, criteria.required)
		end
		line.Criteria:SetText(text)
		if criteria.done then
			line.Criteria:SetTextColor(C.ExtractRGBAFromTemplate("emerald-500"))
		else
			line.Criteria:SetTextColor(C.ExtractRGBAFromTemplate("neutral-300"))
		end

		line:ClearAllPoints()
		line:Point(
			"TOPLEFT",
			frame.CriteriaFrame,
			"TOPLEFT",
			0,
			-ELEMENT_PADDING - (i - 1) * (ELEMENT_CRITERIA_LINE_HEIGHT + ELEMENT_CRITERIA_LINE_SPACING)
		)
		line:Show()
		frame.CriteriaFrame.Lines[i] = line
	end
end

function AT:ScrollElementResetter(frame)
	for i = #frame.CriteriaFrame.Lines, 1, -1 do
		local line = tremove(frame.CriteriaFrame.Lines, i)
		line:Hide()
		line:SetParent(self.MainFrame)
		self.MainFrame.CriteriaLinePool:Release(line)
	end
end

function AT:Construct()
	if self.MainFrame then
		return
	end

	---@class WTAchievementTracker : Frame, BackdropTemplate
	local MainFrame = CreateFrame("Frame", "WTAchievementTracker", _G.AchievementFrame, "BackdropTemplate")
	MainFrame:Size(self.db.panel.width, self.db.panel.height)
	MainFrame:Point("TOPLEFT", _G.AchievementFrame, "TOPRIGHT", 4, 0)
	MainFrame:SetTemplate("Transparent")
	S:CreateShadow(MainFrame)
	MF:InternalHandle(MainFrame, _G.AchievementFrame)
	self.MainFrame = MainFrame
	MainFrame.States = self.states

	local SearchBox = CreateFrame("EditBox", "WTAchievementTrackerSearchBox", MainFrame, "SearchBoxTemplate")
	SearchBox:Height(24)
	SearchBox:Point("TOPLEFT", MainFrame, "TOPLEFT", 12, -8)
	SearchBox:Point("TOPRIGHT", MainFrame, "TOPRIGHT", -12, -8)
	SearchBox:SetFont(E.db.general.font, E.db.general.fontSize, "OUTLINE")
	SearchBox:SetAutoFocus(false)
	SearchBox:SetMaxLetters(50)
	SearchBox:HookScript("OnTextChanged", function(editBox)
		F.Throttle(1, "AchievementTrackerSearch", function()
			self.states.filters.searchTerm = editBox:GetText()
			self:UpdateView()
		end)
	end)
	SearchBox:HookScript("OnEscapePressed", function(editBox)
		editBox:ClearFocus()
	end)
	S:Proxy("HandleEditBox", SearchBox)
	MainFrame.SearchBox = SearchBox

	local ControlFrame1 = CreateFrame("Frame", nil, MainFrame, "BackdropTemplate")
	ControlFrame1:Height(40)
	ControlFrame1:Point("TOPLEFT", SearchBox, "BOTTOMLEFT", -4, -5)
	ControlFrame1:Point("TOPRIGHT", SearchBox, "BOTTOMRIGHT", 4, -5)
	ControlFrame1:SetTemplate("Transparent")
	MainFrame.ControlFrame1 = ControlFrame1

	local ThresholdSlider = CreateFrame("Slider", nil, ControlFrame1, "BackdropTemplate")
	ThresholdSlider:Size(140, 16)
	ThresholdSlider:Point("LEFT", ControlFrame1, "LEFT", 11, -8)
	ThresholdSlider:SetOrientation("HORIZONTAL")
	ThresholdSlider:SetObeyStepOnDrag(true)
	ThresholdSlider:SetMinMaxValues(self.db.threshold.min, self.db.threshold.max)
	ThresholdSlider:SetValueStep(1)
	ThresholdSlider:SetValue(self.states.currentThreshold)
	S:Proxy("HandleSliderFrame", ThresholdSlider)
	ThresholdSlider.Text = ThresholdSlider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	ThresholdSlider.Text:Point("BOTTOM", ThresholdSlider, "TOP", 0, 2)
	ThresholdSlider.Text:SetText(L["Threshold"] .. ": " .. self.states.currentThreshold .. "%")
	ThresholdSlider.Text:SetTextColor(C.ExtractRGBAFromTemplate("neutral-50"))
	F.SetFontOutline(ThresholdSlider.Text)
	ThresholdSlider:SetScript("OnValueChanged", function(slider, value)
		self.states.currentThreshold = floor(value)
		slider.Text:SetText(L["Threshold"] .. ": " .. self.states.currentThreshold .. "%")
	end)
	ControlFrame1.ThresholdSlider = ThresholdSlider

	local ShowAllButton = CreateFrame("Button", nil, ControlFrame1, "UIPanelButtonTemplate")
	ShowAllButton:Size(80, 25)
	ShowAllButton:Point("LEFT", ThresholdSlider, "RIGHT", 15, 8)
	ShowAllButton:SetText(L["All"])
	F.SetFontOutline(ShowAllButton.Text, E.db.general.font)
	S:Proxy("HandleButton", ShowAllButton)
	ShowAllButton:SetScript("OnClick", function()
		self.states.searchTerm = ""
		self.states.filterCategoryID = nil
		self.states.showOnlyRewards = false
		self.states.currentThreshold = self.db.threshold.min
		ThresholdSlider:SetValue(self.db.threshold.min)
		SearchBox:SetText("")
		self:StartAchievementScan()
	end)
	ControlFrame1.ShowAllButton = ShowAllButton

	local NearlyCompleteButton = CreateFrame("Button", nil, ControlFrame1, "UIPanelButtonTemplate")
	NearlyCompleteButton:Size(80, 25)
	NearlyCompleteButton:Point("LEFT", ShowAllButton, "RIGHT", 8, 0)
	NearlyCompleteButton:SetText("95%+")
	F.SetFontOutline(NearlyCompleteButton.Text)
	S:Proxy("HandleButton", NearlyCompleteButton)
	NearlyCompleteButton:SetScript("OnClick", function()
		self.states.currentThreshold = 95
		ThresholdSlider:SetValue(95)
		self:StartAchievementScan()
	end)
	ControlFrame1.NearlyCompleteButton = NearlyCompleteButton

	local RefreshButton = CreateFrame("Button", nil, ControlFrame1, "UIPanelButtonTemplate")
	RefreshButton:Size(25, 25)
	RefreshButton:Point("RIGHT", ControlFrame1, "RIGHT", -8, 0)
	RefreshButton.Icon = RefreshButton:CreateTexture(nil, "OVERLAY")
	RefreshButton.Icon:Size(16, 16)
	RefreshButton.Icon:Point("CENTER")
	RefreshButton.Icon:SetTexture(W.Media.Icons.buttonUndo)
	S:Proxy("HandleButton", RefreshButton)
	RefreshButton:SetScript("OnClick", function()
		self:StartAchievementScan()
	end)
	ControlFrame1.RefreshButton = RefreshButton

	local ControlFrame2 = CreateFrame("Frame", nil, MainFrame, "BackdropTemplate")
	ControlFrame2:Size(self.db.panel.width - 20, 32)
	ControlFrame2:Point("TOP", ControlFrame1, "BOTTOM", 0, -5)
	ControlFrame2:SetTemplate("Transparent")
	MainFrame.ControlFrame2 = ControlFrame2

	local CategoryDropdown = CreateFrame("DropdownButton", nil, ControlFrame2, "WowStyle1DropdownTemplate")
	CategoryDropdown:Point("LEFT", ControlFrame2, "LEFT", 8, 0)
	S:Proxy("HandleDropDownBox", CategoryDropdown, 150)
	CategoryDropdown:SetupMenu(function(_, rootDescription)
		rootDescription:CreateRadio(L["All Categories"] or "All Categories", function()
			return self.states.filters.categoryID == nil
		end, function()
			self.states.filters.categoryID = nil
			self:UpdateView()
		end)

		rootDescription:CreateDivider()

		local categories = {}
		local categoryMap = {}

		for _, achievement in ipairs(self.states.results) do
			if achievement.categoryID and not categoryMap[achievement.categoryID] then
				categoryMap[achievement.categoryID] = true
				tinsert(categories, { id = achievement.categoryID, name = achievement.categoryName })
			end
		end

		sort(categories, function(a, b)
			return a.id < b.id
		end)

		for _, category in ipairs(categories) do
			rootDescription:CreateRadio(category.name, function()
				return self.states.filters.categoryID == category.id
			end, function()
				self.states.filters.categoryID = category.id
				self:UpdateView()
			end)
		end
	end)
	ControlFrame2.CategoryDropdown = CategoryDropdown

	local RewardsCheckButton = CreateFrame("CheckButton", nil, ControlFrame2, "UICheckButtonTemplate")
	RewardsCheckButton:Size(22, 22)
	RewardsCheckButton:Point("LEFT", CategoryDropdown, "RIGHT", 15, 0)
	RewardsCheckButton.Text:SetText(L["Rewards"])
	RewardsCheckButton.Text:SetTextColor(1, 1, 1)
	F.SetFontOutline(RewardsCheckButton.Text)
	S:Proxy("HandleCheckBox", RewardsCheckButton)
	RewardsCheckButton:SetChecked(self.states.filters.hasRewards)
	RewardsCheckButton:SetScript("OnClick", function()
		self.states.filters.hasRewards = RewardsCheckButton:GetChecked()
		self:UpdateView()
	end)
	ControlFrame2.RewardsCheckButton = RewardsCheckButton

	local SortOrderButton = CreateFrame("Button", nil, ControlFrame2, "UIPanelButtonTemplate")
	SortOrderButton:Size(30, 22)
	SortOrderButton:Point("RIGHT", ControlFrame2, "RIGHT", -8, 0)
	S:Proxy("HandleButton", SortOrderButton)
	SortOrderButton.Arrow = SortOrderButton:CreateTexture(nil, "OVERLAY")
	SortOrderButton.Arrow:Size(16, 16)
	SortOrderButton.Arrow:Point("CENTER")
	SortOrderButton.Arrow:SetTexture(W.Media.Textures.arrowDown)
	SortOrderButton.Arrow:SetVertexColor(1, 1, 1)
	SortOrderButton.UpdateArrow = function(button)
		button.Arrow:SetRotation(self.states.sort.order == "desc" and 0 or math_pi)
	end
	SortOrderButton:SetScript("OnClick", function(button)
		self.states.sort.order = self.states.sort.order == "desc" and "asc" or "desc"
		self:UpdateView()
		button:UpdateArrow()
	end)
	SortOrderButton:UpdateArrow()
	ControlFrame2.SortOrderButton = SortOrderButton

	local SortDropdown = CreateFrame("DropdownButton", nil, ControlFrame2, "WowStyle1DropdownTemplate")
	SortDropdown:Point("RIGHT", SortOrderButton, "LEFT", -8, 0)
	local sortOptions = {
		{ text = L["Percentage"], value = "percent" },
		{ text = L["Name"], value = "name" },
		{ text = L["Category"], value = "category" },
	}
	local sortTexts = {}
	for _, option in ipairs(sortOptions) do
		sortTexts[#sortTexts + 1] = option.text
	end
	local dropdownWidth = 40 + max(40, F.GetAdaptiveTextWidth(E.media.normFont, 12, "OUTLINE", sortTexts))
	S:Proxy("HandleDropDownBox", SortDropdown, dropdownWidth)
	SortDropdown:SetupMenu(function(_, rootDescription)
		for _, option in ipairs(sortOptions) do
			rootDescription:CreateRadio(option.text, function()
				return self.states.sort.by == option.value
			end, function()
				self.states.sort.by = option.value
				self:UpdateView()
			end, option.value)
		end
	end)

	local ScrollFrame = CreateFrame("Frame", nil, MainFrame)
	ScrollFrame:Point("TOPLEFT", ControlFrame2, "BOTTOMLEFT", 0, -8)
	ScrollFrame:Point("TOPRIGHT", ControlFrame2, "BOTTOMRIGHT", 0, -8)
	ScrollFrame:Point("BOTTOM", MainFrame, "BOTTOM", 0, 8)
	MainFrame.ScrollFrame = ScrollFrame

	local ScrollBar = CreateFrame("EventFrame", nil, ScrollFrame, "MinimalScrollBar")
	ScrollBar:SetPoint("TOPRIGHT", ScrollFrame, "TOPRIGHT", -5, 0)
	ScrollBar:SetPoint("BOTTOMRIGHT", ScrollFrame, "BOTTOMRIGHT", -5, 0)
	S:Proxy("HandleTrimScrollBar", ScrollBar)
	ScrollFrame.ScrollBar = ScrollBar

	local ScrollBox = CreateFrame("Frame", nil, ScrollFrame, "WowScrollBoxList")
	ScrollBox:Point("TOPLEFT", ScrollFrame, "TOPLEFT", 0, 0)
	ScrollBox:Point("BOTTOMRIGHT", ScrollBar, "BOTTOMLEFT", -8, 0)
	ScrollBox:SetTemplate("Transparent")
	ScrollBox:SetClipsChildren(true)
	ScrollFrame.ScrollBox = ScrollBox

	local ScrollView = CreateScrollBoxListLinearView()

	local DataProvider = CreateDataProvider()
	DataProvider:InsertTable({})

	ScrollView--[[@as ScrollBoxLinearBaseViewMixin]]:SetPadding(8, 8, 8, 8, 8)
	ScrollView:SetDataProvider(DataProvider)
	ScrollView:SetElementInitializer("BackdropTemplate", function(frame, data)
		self:ScrollElementInitializer(frame, data, ScrollBox)
	end)
	ScrollView:SetElementExtentCalculator(function(dataIndex, elementData)
		return elementData.height or (ELEMENT_ICON_SIZE + 2 * ELEMENT_PADDING)
	end)
	ScrollView:SetElementResetter(GenerateClosure(self.ScrollElementResetter, self))
	ScrollUtil.InitScrollBoxListWithScrollBar(ScrollBox, ScrollBar, ScrollView)
	ScrollFrame.ScrollView = ScrollView

	local ProgressFrame = CreateFrame("Frame", nil, MainFrame)
	ProgressFrame:SetFrameStrata("DIALOG")
	ProgressFrame:SetAllPoints(MainFrame)
	MainFrame.ProgressFrame = ProgressFrame

	local ProgressBar = CreateFrame("StatusBar", nil, ProgressFrame)
	ProgressBar:Size(self.db.panel.width - 50, 26)
	ProgressBar:Point("CENTER", ProgressFrame, "CENTER")
	ProgressBar:SetStatusBarTexture(E.media.normTex)
	ProgressBar:SetMinMaxValues(0, 100)
	ProgressBar:SetValue(0)
	ProgressBar:GetStatusBarTexture():SetVertexColor(1, 1, 1)
	ProgressBar:GetStatusBarTexture():SetGradient(
		"HORIZONTAL",
		C.CreateColorFromTable({ r = 0.32941, g = 0.52157, b = 0.93333, a = 1 }),
		C.CreateColorFromTable({ r = 0.25882, g = 0.84314, b = 0.86667, a = 1 })
	)
	ProgressBar:CreateBackdrop("Transparent")
	ProgressFrame.Bar = ProgressBar

	local ProgressLabel = ProgressFrame:CreateFontString(nil, "OVERLAY")
	F.SetFontOutline(ProgressLabel, E.db.general.font, E.db.general.fontSize + 12)
	ProgressLabel:Point("BOTTOM", ProgressBar, "TOP", 0, 20)
	ProgressLabel:SetText(L["Scanning"])
	ProgressLabel:SetTextColor(C.ExtractRGBAFromTemplate("amber-400"))
	ProgressFrame.Label = ProgressLabel

	local ProgressBarProgressText = ProgressBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	F.SetFontOutline(ProgressBarProgressText, F.GetCompatibleFont("Chivo Mono"), 14)
	ProgressBarProgressText:SetTextColor(C.ExtractRGBAFromTemplate("neutral-50"))
	ProgressBarProgressText:Point("CENTER", ProgressBar, "CENTER", 0, -1)
	ProgressBar.ProgressText = ProgressBarProgressText
	self:Hook(ProgressFrame, "Show", function()
		SearchBox:ClearFocus()
		SearchBox:Hide()
		ControlFrame1:Hide()
		ControlFrame2:Hide()
		ScrollFrame:Hide()
	end, true)
	self:SecureHook(ProgressFrame, "Hide", function()
		SearchBox:Show()
		ControlFrame1:Show()
		ControlFrame2:Show()
		ScrollFrame:Show()
	end)

	MainFrame.UpdateDropdowns = function()
		SortDropdown:GenerateMenu()
		CategoryDropdown:GenerateMenu()
	end

	MainFrame.ProgressFrame:Hide()
	MainFrame.CriteriaLinePool = CreateFramePool("Frame", nil, "BackdropTemplate")
end

function AT:InitMainFrame()
	self:Construct()

	self:SecureHookScript(_G.AchievementFrame, "OnShow", function()
		self:RegisterEvent("ACHIEVEMENT_EARNED")
		self:RegisterEvent("CRITERIA_UPDATE")

		self.MainFrame:Show()

		if not self.states.isScanInitialized then
			self.states.isScanInitialized = true
			self:StartAchievementScan()
		end
	end)

	self:SecureHookScript(_G.AchievementFrame, "OnHide", function()
		self:UnregisterEvent("ACHIEVEMENT_EARNED")
		self:UnregisterEvent("CRITERIA_UPDATE")
		self.MainFrame:Hide()
		self.states.isScanning = false
	end)

	W:AddCommand("AchievementTracker", { "/wtat", "/wtachievements" }, function()
		if InCombatLockdown() then
			_G.UIErrorsFrame:AddMessage(ERR_NOT_IN_COMBAT, RED_FONT_COLOR:GetRGBA())
			return
		end
		self.MainFrame:Show()
		self:StartAchievementScan()
	end)
end

function AT:UpdateStyle()
	local MainFrame = self.MainFrame
	if not MainFrame then
		return
	end

	MainFrame:Size(self.db.panel.width, self.db.panel.height)
end

---Handle ACHIEVEMENT_EARNED event
---@param achievementID number
---@param alreadyEarned boolean
function AT:ACHIEVEMENT_EARNED(achievementID, alreadyEarned)
	if self.MainFrame and not alreadyEarned then
		for i, achievement in ipairs(self.states.results) do
			if achievement.id == achievementID then
				tremove(self.states.results, i)
				self:UpdateView()
				break
			end
		end
	end
end

function AT:CRITERIA_UPDATE()
	if _G.WTAchievementTracker and self.states.isScanInitialized then
		E:Delay(0.5, function()
			if _G.WTAchievementTracker and not InCombatLockdown() then
				self:UpdateView()
			end
		end)
	end
end

---@param _ any
---@param addonName string
function AT:ADDON_LOADED(_, addonName)
	if addonName == "Blizzard_AchievementUI" then
		self:UnregisterEvent("ADDON_LOADED")
		if _G.AchievementFrame then
			self:InitMainFrame()
		end
	end
end

function AT:Initialize()
	if not E.db or not E.db.WT or not E.db.WT.misc.achievementTracker then
		return
	end

	self.db = E.db.WT.misc.achievementTracker

	if not self.db.enable or self.initialized then
		return
	end

	self.db.currentThreshold = self.db.threshold.default

	if _G.AchievementFrame then
		self:InitMainFrame()
	else
		self:RegisterEvent("ADDON_LOADED")
	end

	self.initialized = true
end

AT.ProfileUpdate = AT.Initialize

W:RegisterModule(AT:GetName())
