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

---@class AchievementConfig
---@field PANEL_WIDTH number
---@field PANEL_HEIGHT number
---@field MIN_THRESHOLD number
---@field MAX_THRESHOLD number
---@field DEFAULT_THRESHOLD number
---@field BATCH_SIZE number
---@field SCAN_DELAY number
---@field BUTTON_HEIGHT number
---@field BUTTON_SPACING number
---@field ICON_SIZE number
---@field PROGRESS_BAR_WIDTH number
AT.Config = {
	PANEL_WIDTH = 450,
	PANEL_HEIGHT = 500,
	MIN_THRESHOLD = 50,
	MAX_THRESHOLD = 99,
	DEFAULT_THRESHOLD = 80,
	BATCH_SIZE = 20,
	SCAN_DELAY = 0.01,
	BUTTON_HEIGHT = 48,
	BUTTON_SPACING = 4,
	ICON_SIZE = 28,
	PROGRESS_BAR_WIDTH = 90,
}

---@class AchievementScanState
---@field isScanning boolean
---@field scannedSinceInit boolean
---@field currentThreshold number
---@field results AchievementData[]
---@field filteredResults AchievementData[]
---@field sortBy "percent"|"name"|"category"
---@field sortOrder "asc"|"desc"
---@field searchTerm string
---@field selectedCategory string|nil
---@field showOnlyRewards boolean
---@field expandedAchievements table<number, boolean>
AT.states = {
	isScanning = false,
	scannedSinceInit = false,
	currentThreshold = 80,
	results = {},
	filteredResults = {},
	sortBy = "percent",
	sortOrder = "desc",
	searchTerm = "",
	selectedCategory = nil,
	showOnlyRewards = false,
	expandedAchievements = {},
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
---@param applyFiltersFunc fun()
function AT:ScanAllAchievements(callback, updateProgress, applyFiltersFunc)
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
			applyFiltersFunc()
			self.states.isScanning = false
			callback(self.states.filteredResults)
		else
			-- if self:StopScanDueToCombat() then
			-- 	return
			-- end

			E:Delay(self.db.scan.delay, scanStep)
		end
	end

	scanStep()
end

function AT:ApplyFiltersAndSort()
	-- Start with all results
	local filtered = {}

	for _, achievement in ipairs(self.states.results) do
		local includeAchievement = true

		-- Apply search filter
		if self.states.searchTerm and self.states.searchTerm ~= "" then
			local searchLower = self.states.searchTerm:lower()
			local nameLower = achievement.name:lower()
			local descLower = (achievement.description or ""):lower()
			if not (nameLower:find(searchLower, 1, true) or descLower:find(searchLower, 1, true)) then
				includeAchievement = false
			end
		end

		-- Apply category filter
		if includeAchievement and self.states.selectedCategory then
			if achievement.categoryName ~= self.states.selectedCategory then
				includeAchievement = false
			end
		end

		-- Apply rewards filter
		if includeAchievement and self.states.showOnlyRewards then
			if not achievement.rewardItemID then
				includeAchievement = false
			end
		end

		if includeAchievement then
			tinsert(filtered, achievement)
		end
	end

	self.states.filteredResults = filtered

	sort(self.states.filteredResults, function(a, b)
		local aVal, bVal

		if self.states.sortBy == "percent" then
			aVal, bVal = a.percent, b.percent
		elseif self.states.sortBy == "name" then
			aVal, bVal = a.name:lower(), b.name:lower()
		elseif self.states.sortBy == "category" then
			aVal, bVal = a.categoryName:lower(), b.categoryName:lower()
		end

		if self.states.sortOrder == "desc" then
			return aVal > bVal
		else
			return aVal < bVal
		end
	end)

	self.MainFrame:UpdateDropdowns()
end

function AT:StartAchievementScan()
	if not self.MainFrame or not self.MainFrame:IsShown() then
		return
	end

	local ProgressFrame = self.MainFrame.ProgressFrame
	ProgressFrame.Bar:SetValue(0)
	ProgressFrame.Bar.ProgressText:SetText("")

	self:ScanAllAchievements(function(_)
		ProgressFrame:Hide()
		self:UpdateAchievementList()
	end, function(_, _, progress, scanned, total)
		ProgressFrame.Bar:SetValue(progress)
		ProgressFrame.Bar.ProgressText:SetText(format("%d / %d  -  %.0f %%", scanned, total, progress))
	end, function()
		self:ApplyFiltersAndSort()
	end)

	ProgressFrame:Show()
end

function AT:GetUniqueCategories()
	local categories = {} ---@type string[]
	local seen = {} ---@type table<string, boolean>

	for _, achievement in ipairs(self.states.results) do
		if achievement.categoryName and not seen[achievement.categoryName] then
			tinsert(categories, achievement.categoryName)
			seen[achievement.categoryName] = true
		end
	end

	sort(categories)
	return categories
end

function AT:UpdateAchievementList()
	if not self.MainFrame then
		return
	end

	local Content = self.MainFrame.ScrollFrame.Content
	F.TaskManager:OutOfCombat(function()
		for _, child in pairs({ Content:GetChildren() }) do
			child:Hide()
			child:SetParent(nil)
		end

		local yOffset = -8
		for _, achievement in ipairs(self.states.filteredResults) do
			local isExpanded = self.states.expandedAchievements[achievement.id] or false
			local buttonHeight = self.db.button.height

			if isExpanded and achievement.criteria then
				local criteriaCount = #achievement.criteria
				buttonHeight = buttonHeight + (criteriaCount * 18) + 12
			end

			local Button = CreateFrame("Button", nil, Content, "UIPanelButtonTemplate")
			Button:Size(self.db.panel.width - 40, buttonHeight)
			Button:Point("TOPLEFT", Content, "TOPLEFT", 10, yOffset)

			S:Proxy("HandleButton", Button)

			local ExpandArrow = Button:CreateTexture(nil, "OVERLAY")
			ExpandArrow:Size(12, 12)
			ExpandArrow:Point("LEFT", Button, "LEFT", 4, 0)
			ExpandArrow:SetTexture(W.Media.Textures.arrowDown)
			ExpandArrow:SetVertexColor(0.8, 0.8, 0.8)
			ExpandArrow:SetRotation(isExpanded and 0 or -1.57)

			local IconFrame = CreateFrame("Frame", nil, Button)
			IconFrame:Size(AT.Config.ICON_SIZE, AT.Config.ICON_SIZE)
			IconFrame:Point("TOPLEFT", Button, "TOPLEFT", 20, -10)
			IconFrame:SetTemplate("Transparent")

			local Icon = IconFrame:CreateTexture(nil, "ARTWORK")
			Icon:Size(AT.Config.ICON_SIZE - 4, AT.Config.ICON_SIZE - 4)
			Icon:Point("CENTER", IconFrame, "CENTER", 0, 0)
			Icon:SetTexture(achievement.icon)
			Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

			local ProgressBar = CreateFrame("StatusBar", nil, Button)
			ProgressBar:Size(self.db.button.progressWidth, 12)
			ProgressBar:Point("TOPRIGHT", Button, "TOPRIGHT", -10, -18)
			ProgressBar:SetStatusBarTexture(E.media.normTex)
			ProgressBar:SetMinMaxValues(0, 100)
			ProgressBar:SetValue(achievement.percent)

			local color
			if achievement.percent >= 90 then
				color = C.GetRGBFromTemplate("emerald-500")
			elseif achievement.percent >= 75 then
				color = C.GetRGBFromTemplate("green-500")
			elseif achievement.percent >= 60 then
				color = C.GetRGBFromTemplate("yellow-500")
			else
				color = C.GetRGBFromTemplate("orange-500")
			end
			ProgressBar:SetStatusBarColor(color.r, color.g, color.b)
			ProgressBar:CreateBackdrop("Transparent")

			local ProgressText = ProgressBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
			ProgressText:Point("CENTER", ProgressBar, "CENTER", 0, 0)
			ProgressText:SetText(format("%.0f%%", achievement.percent))
			ProgressText:SetTextColor(1, 1, 1)
			F.SetFontOutline(ProgressText)

			local NameText = Button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			NameText:Point("LEFT", IconFrame, "RIGHT", 10, 6)
			NameText:Point("RIGHT", ProgressBar, "LEFT", -10, 6)
			NameText:SetText(achievement.name)
			NameText:SetTextColor(1, 1, 1)
			NameText:SetJustifyH("LEFT")
			F.SetFontOutline(NameText)

			local CategoryText = Button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
			CategoryText:Point("LEFT", IconFrame, "RIGHT", 10, -6)
			CategoryText:Point("RIGHT", ProgressBar, "LEFT", -10, -6)
			CategoryText:SetText(achievement.categoryName)
			CategoryText:SetTextColor(0.7, 0.7, 0.7)
			CategoryText:SetJustifyH("LEFT")
			F.SetFontOutline(CategoryText)

			local CriteriaText = Button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
			CriteriaText:Point("LEFT", IconFrame, "RIGHT", 10, -18)
			CriteriaText:Point("RIGHT", ProgressBar, "LEFT", -10, -18)
			CriteriaText:SetText(format(L["%d/%d criteria"], achievement.completedCriteria, achievement.totalCriteria))
			CriteriaText:SetTextColor(0.6, 0.6, 0.6)
			CriteriaText:SetJustifyH("LEFT")
			F.SetFontOutline(CriteriaText)

			local RewardIcon
			if achievement.rewardItemID then
				RewardIcon = Button:CreateTexture(nil, "OVERLAY")
				RewardIcon:Size(16, 16)
				RewardIcon:Point("RIGHT", ProgressBar, "LEFT", -5, 0)
				RewardIcon:SetTexture("Interface\\Icons\\INV_Misc_Gift_01")
				RewardIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			end

			local TrackButton = CreateFrame("CheckButton", nil, Button, "UICheckButtonTemplate")
			TrackButton:Size(20, 20)
			if RewardIcon then
				TrackButton:Point("TOPRIGHT", RewardIcon, "TOPLEFT", -4, 2)
			else
				TrackButton:Point("TOPRIGHT", ProgressBar, "TOPLEFT", -8, 2)
			end
			TrackButton:SetFrameLevel(Button:GetFrameLevel() + 2)
			S:Proxy("HandleCheckBox", TrackButton)

			local isTracked = C_ContentTracking_IsTracking(Enum_ContentTrackingType.Achievement, achievement.id)
			TrackButton:SetChecked(isTracked)
			TrackButton:SetShown(achievement.percent < 100)
			TrackButton:SetScript("OnClick", function(btn)
				local checked = btn:GetChecked()

				if checked then
					local trackedCount = #C_ContentTracking_GetTrackedIDs(Enum_ContentTrackingType.Achievement)
					if trackedCount >= Constants_ContentTrackingConsts.MaxTrackedAchievements then
						_G.UIErrorsFrame:AddMessage(
							format(
								L["Cannot track more than %d achievements"],
								Constants_ContentTrackingConsts.MaxTrackedAchievements
							),
							1.0,
							0.1,
							0.1,
							1.0
						)
						btn:SetChecked(false)
						return
					end

					local trackingError =
						C_ContentTracking_StartTracking(Enum_ContentTrackingType.Achievement, achievement.id)
					if trackingError then
						btn:SetChecked(false)
					else
						PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
					end
				else
					C_ContentTracking_StopTracking(
						Enum_ContentTrackingType.Achievement,
						achievement.id,
						Enum_ContentTrackingStopType.Manual
					)
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
				end
			end)

			TrackButton:SetScript("OnEnter", function(btn)
				GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
				if btn:GetChecked() then
					GameTooltip:SetText(L["Untrack Achievement"] or "Untrack Achievement", nil, nil, nil, nil, true)
				else
					GameTooltip:SetText(L["Track Achievement"] or "Track Achievement", nil, nil, nil, nil, true)
				end
				GameTooltip:Show()
			end)

			TrackButton:SetScript("OnLeave", function()
				GameTooltip:Hide()
			end)

			if isExpanded and achievement.criteria then
				local criteriaYOffset = -50
				for i, criteria in ipairs(achievement.criteria) do
					local statusIcon = Button:CreateTexture(nil, "OVERLAY")
					statusIcon:Size(14, 14)
					statusIcon:Point("TOPLEFT", Button, "TOPLEFT", 20, criteriaYOffset)

					if criteria.done then
						statusIcon:SetTexture("Interface/AchievementFrame/UI-Achievement-Criteria-Check")
						statusIcon:SetVertexColor(0, 1, 0)
					else
						statusIcon:SetTexture("Interface/Buttons/UI-CheckBox-Check-Disabled")
						statusIcon:SetVertexColor(0.5, 0.5, 0.5)
					end

					local criteriaLine = Button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
					criteriaLine:Point("LEFT", statusIcon, "RIGHT", 4, 0)
					criteriaLine:Point("RIGHT", Button, "RIGHT", -15, 0)
					criteriaLine:SetJustifyH("LEFT")

					local progressInfo = ""
					if criteria.required and criteria.required > 1 then
						progressInfo = format(" (%d/%d)", criteria.quantity or 0, criteria.required)
					end

					criteriaLine:SetText(format("%s%s", criteria.text or "Unknown", progressInfo))
					criteriaLine:SetTextColor(
						criteria.done and 0.9 or 0.6,
						criteria.done and 0.9 or 0.6,
						criteria.done and 0.9 or 0.6
					)
					F.SetFontOutline(criteriaLine)

					criteriaYOffset = criteriaYOffset - 18
				end
			end

			Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
			Button:SetScript("OnClick", function(_, mouseButton)
				if mouseButton == "RightButton" then
					self.states.expandedAchievements[achievement.id] = not isExpanded
					AT:UpdateAchievementList()
				else
					if _G.AchievementFrame then
						_G.AchievementFrame_SelectAchievement(achievement.id)
						if not _G.AchievementFrame:IsShown() then
							_G.AchievementFrame_ToggleAchievementFrame()
						end
					end
				end
			end)

			yOffset = yOffset - (buttonHeight + self.db.button.spacing)
		end

		local totalHeight = -yOffset + self.db.button.spacing
		Content:SetHeight(max(100, totalHeight))
	end)
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
		self.states.searchTerm = editBox:GetText()
		self:ApplyFiltersAndSort()
		self:UpdateAchievementList()
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
		self.states.selectedCategory = nil
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
			return self.states.selectedCategory == nil
		end, function()
			self.states.selectedCategory = nil
			self:ApplyFiltersAndSort()
			self:UpdateAchievementList()
		end)

		rootDescription:CreateDivider()

		local categories = self:GetUniqueCategories()
		for _, categoryName in ipairs(categories) do
			rootDescription:CreateRadio(categoryName, function()
				return self.states.selectedCategory == categoryName
			end, function()
				self.states.selectedCategory = categoryName
				self:ApplyFiltersAndSort()
				self:UpdateAchievementList()
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
	RewardsCheckButton:SetChecked(self.states.showOnlyRewards)
	RewardsCheckButton:SetScript("OnClick", function()
		self.states.showOnlyRewards = RewardsCheckButton:GetChecked()
		self:ApplyFiltersAndSort()
		self:UpdateAchievementList()
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
	local function UpdateArrow()
		SortOrderButton.Arrow:SetRotation(self.states.sortOrder == "desc" and 0 or math_pi)
	end
	SortOrderButton:SetScript("OnClick", function()
		local newOrder = self.states.sortOrder == "desc" and "asc" or "desc"
		self.states.sortOrder = newOrder
		UpdateArrow()
		self:ApplyFiltersAndSort()
		self:UpdateAchievementList()
	end)
	UpdateArrow()
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
				return self.states.sortBy == option.value
			end, function()
				self.states.sortBy = option.value
				self:ApplyFiltersAndSort()
				self:UpdateAchievementList()
			end, option.value)
		end
	end)

	local ScrollFrame = CreateFrame("ScrollFrame", nil, MainFrame, "UIPanelScrollFrameTemplate")
	ScrollFrame:Size(self.db.panel.width - 20, self.db.panel.height - 140)
	ScrollFrame:Point("TOP", ControlFrame2, "BOTTOM", 0, -5)
	ScrollFrame.ScrollBar:Point("TOPRIGHT", ScrollFrame, "TOPRIGHT", -2, -2)
	ScrollFrame.ScrollBar:Point("BOTTOMRIGHT", ScrollFrame, "BOTTOMRIGHT", -2, 2)
	S:Proxy("HandleScrollBar", ScrollFrame.ScrollBar)
	MainFrame.ScrollFrame = ScrollFrame

	local ScrollContent = CreateFrame("Frame", nil, ScrollFrame)
	ScrollContent:Size(self.db.panel.width - 20, 100)
	ScrollFrame:SetScrollChild(ScrollContent)
	ScrollFrame.Content = ScrollContent

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
end

function AT:InitMainFrame()
	self:Construct()

	self:SecureHookScript(_G.AchievementFrame, "OnShow", function()
		self:RegisterEvent("ACHIEVEMENT_EARNED")
		self:RegisterEvent("CRITERIA_UPDATE")

		self.MainFrame:Show()

		if not self.states.scannedSinceInit then
			self.states.scannedSinceInit = true
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
				self:ApplyFiltersAndSort()
				self:UpdateAchievementList()
				break
			end
		end
	end
end

function AT:CRITERIA_UPDATE()
	if _G.WTAchievementTracker and self.states.scannedSinceInit then
		E:Delay(0.5, function()
			if _G.WTAchievementTracker and not InCombatLockdown() then
				self:UpdateAchievementList()
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

W:RegisterModule(AT:GetName())
