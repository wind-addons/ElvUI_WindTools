local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local A = W:GetModule("AchievementTracker") ---@class AchievementTracker
local C = W.Utilities.Color
local S = W.Modules.Skins ---@type Skins
local MF = W.Modules.MoveFrames

local _G = _G
local pairs = pairs
local ipairs = ipairs
local max = max
local floor = floor
local format = format
local InCombatLockdown = InCombatLockdown
local C_Timer_After = C_Timer.After

local C_ContentTracking_GetTrackedIDs = C_ContentTracking.GetTrackedIDs
local C_ContentTracking_IsTracking = C_ContentTracking.IsTracking
local C_ContentTracking_StartTracking = C_ContentTracking.StartTracking
local C_ContentTracking_StopTracking = C_ContentTracking.StopTracking
local Constants_ContentTrackingConsts = Constants.ContentTrackingConsts
local CreateFrame = CreateFrame
local Enum_ContentTrackingStopType = Enum.ContentTrackingStopType
local Enum_ContentTrackingType = Enum.ContentTrackingType
local GameTooltip = _G.GameTooltip
local PlaySound = PlaySound
local SOUNDKIT = SOUNDKIT
local UIErrorsFrame = _G.UIErrorsFrame

---@class AchievementTrackerPanel
---@field controlFrame Frame
---@field controlFrame2 Frame
---@field searchBox EditBox
---@field thresholdSlider Slider
---@field sortDropdown DropdownButton
---@field categoryDropdown DropdownButton
---@field sortOrderButton Button
---@field refreshButton Button
---@field nearlyCompleteButton Button
---@field rewardsFilterButton Button
---@field showAllButton Button
---@field scrollFrame ScrollFrame
---@field content Frame
---@field progressBar StatusBar
---@field progressText FontString
---@field progressContainer Frame
---@field UpdateDropdowns fun()

---@return nil
function A:CreateAchievementTrackerPanel()
	if _G.WTAchievementTracker then
		return
	end

	local PREFIX = "WTAchievementTracker"

	---@class WTAchievementTracker : Frame, BackdropTemplate
	local Panel = CreateFrame("Frame", PREFIX, _G.AchievementFrame, "BackdropTemplate")
	Panel:Size(A.Config.PANEL_WIDTH, A.Config.PANEL_HEIGHT)
	Panel:Point("TOPLEFT", _G.AchievementFrame, "TOPRIGHT", 10, 0)
	Panel:SetTemplate("Transparent")
	S:CreateShadow(Panel)
	MF:InternalHandle(Panel, _G.AchievementFrame)

	local SearchBox = CreateFrame("EditBox", PREFIX .. "SearchBox", Panel, "SearchBoxTemplate")
	SearchBox:Size(A.Config.PANEL_WIDTH - 28, 24)
	SearchBox:Point("TOP", Panel, "TOP", 0, -10)
	SearchBox:SetAutoFocus(false)
	SearchBox:SetMaxLetters(50)
	S:Proxy("HandleEditBox", SearchBox)

	SearchBox:SetScript("OnTextChanged", function(editBox)
		local text = editBox:GetText()
		A:SetScanState("searchTerm", text)
		A:ApplyFiltersAndSort()
		A:UpdateAchievementList()
	end)

	SearchBox:SetScript("OnEscapePressed", function(editBox)
		editBox:ClearFocus()
	end)

	local ControlFrame = CreateFrame("Frame", PREFIX .. "ControlFrame", Panel, "BackdropTemplate")
	ControlFrame:Size(A.Config.PANEL_WIDTH - 20, 40)
	ControlFrame:Point("TOP", SearchBox, "BOTTOM", 0, -5)
	ControlFrame:SetTemplate("Transparent")

	local ThresholdSlider = CreateFrame("Slider", PREFIX .. "ThresholdSlider", ControlFrame, "OptionsSliderTemplate")
	ThresholdSlider:SetOrientation("HORIZONTAL")
	ThresholdSlider:Size(120, 14)
	ThresholdSlider:Point("LEFT", ControlFrame, "LEFT", 15, 0)
	ThresholdSlider:SetMinMaxValues(A.Config.MIN_THRESHOLD, A.Config.MAX_THRESHOLD)
	ThresholdSlider:SetValueStep(1)
	ThresholdSlider:SetObeyStepOnDrag(true)
	ThresholdSlider:SetValue(A:GetScanState().currentThreshold)

	ThresholdSlider.Text:Point("BOTTOM", ThresholdSlider, "TOP", 0, 2)
	ThresholdSlider.Text:SetText(L["Threshold"] .. ": " .. A:GetScanState().currentThreshold .. "%")
	ThresholdSlider.Text:SetTextColor(0.9, 0.9, 0.9)
	F.SetFontOutline(ThresholdSlider.Text)

	ThresholdSlider:SetScript("OnValueChanged", function(slider, value)
		A:SetScanState("currentThreshold", floor(value))
		slider.Text:SetText(L["Threshold"] .. ": " .. A:GetScanState().currentThreshold .. "%")
	end)

	S:Proxy("HandleSliderFrame", ThresholdSlider)

	local SortDropdown =
		CreateFrame("DropdownButton", PREFIX .. "SortDropdown", ControlFrame, "WowStyle1DropdownTemplate")
	SortDropdown:Point("LEFT", ThresholdSlider, "RIGHT", 15, 0)

	---@class SortOption
	---@field text string
	---@field value string

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

	---@param dropdown DropdownButton
	---@param rootDescription any
	---@return nil
	local function SortGenerator(dropdown, rootDescription)
		for _, option in ipairs(sortOptions) do
			rootDescription:CreateRadio(option.text, function()
				return A:GetScanState().sortBy == option.value
			end, function()
				A:SetScanState("sortBy", option.value)
				A:ApplyFiltersAndSort()
				A:UpdateAchievementList()
			end, option.value)
		end
	end

	SortDropdown:SetupMenu(SortGenerator)

	local SortOrderButton = CreateFrame("Button", nil, ControlFrame, "UIPanelButtonTemplate")
	SortOrderButton:Size(30, 22)
	SortOrderButton:Point("LEFT", SortDropdown, "RIGHT", 8, 0)
	S:Proxy("HandleButton", SortOrderButton)

	SortOrderButton.arrow = SortOrderButton:CreateTexture(nil, "OVERLAY")
	SortOrderButton.arrow:Size(16, 16)
	SortOrderButton.arrow:Point("CENTER")
	SortOrderButton.arrow:SetTexture(W.Media.Textures.arrowDown)
	SortOrderButton.arrow:SetVertexColor(1, 1, 1)

	---@return nil
	local function UpdateArrow()
		SortOrderButton.arrow:SetRotation(A:GetScanState().sortOrder == "desc" and 0 or 3.14)
	end

	UpdateArrow()

	SortOrderButton:SetScript("OnClick", function()
		local newOrder = A:GetScanState().sortOrder == "desc" and "asc" or "desc"
		A:SetScanState("sortOrder", newOrder)
		UpdateArrow()
		A:ApplyFiltersAndSort()
		A:UpdateAchievementList()
	end)

	local RefreshButton = CreateFrame("Button", nil, ControlFrame, "UIPanelButtonTemplate")
	RefreshButton:Size(60, 22)
	RefreshButton:Point("RIGHT", ControlFrame, "RIGHT", -15, 0)
	RefreshButton:SetText(L["Refresh"])
	RefreshButton.Text:SetTextColor(1, 0.8, 0)
	F.SetFontOutline(RefreshButton.Text)
	S:Proxy("HandleButton", RefreshButton)

	RefreshButton:SetScript("OnClick", function()
		A:StartAchievementScan()
	end)

	local ControlFrame2 = CreateFrame("Frame", nil, Panel, "BackdropTemplate")
	ControlFrame2:Size(A.Config.PANEL_WIDTH - 20, 32)
	ControlFrame2:Point("TOP", ControlFrame, "BOTTOM", 0, -5)
	ControlFrame2:SetTemplate("Transparent")

	local categoryDropdown = CreateFrame("DropdownButton", nil, ControlFrame2, "WowStyle1DropdownTemplate")
	categoryDropdown:Point("LEFT", ControlFrame2, "LEFT", 10, 0)
	S:Proxy("HandleDropDownBox", categoryDropdown, 150)

	---@param dropdown DropdownButton
	---@param rootDescription any
	---@return nil
	local function CategoryGenerator(dropdown, rootDescription)
		rootDescription:CreateRadio(L["All Categories"] or "All Categories", function()
			return A:GetScanState().selectedCategory == nil
		end, function()
			A:SetScanState("selectedCategory", nil)
			A:ApplyFiltersAndSort()
			A:UpdateAchievementList()
		end)

		rootDescription:CreateDivider()

		local categories = A:GetUniqueCategories()
		for _, categoryName in ipairs(categories) do
			rootDescription:CreateRadio(categoryName, function()
				return A:GetScanState().selectedCategory == categoryName
			end, function()
				A:SetScanState("selectedCategory", categoryName)
				A:ApplyFiltersAndSort()
				A:UpdateAchievementList()
			end)
		end
	end

	categoryDropdown:SetupMenu(CategoryGenerator)

	local NearlyCompleteButton = CreateFrame("Button", nil, ControlFrame2, "UIPanelButtonTemplate")
	NearlyCompleteButton:Size(90, 22)
	NearlyCompleteButton:Point("LEFT", categoryDropdown, "RIGHT", 8, 0)
	NearlyCompleteButton:SetText("95%+")
	NearlyCompleteButton.Text:SetTextColor(1, 1, 1)
	F.SetFontOutline(NearlyCompleteButton.Text)
	S:Proxy("HandleButton", NearlyCompleteButton)

	NearlyCompleteButton:SetScript("OnClick", function()
		A:SetScanState("currentThreshold", 95)
		ThresholdSlider:SetValue(95)
		A:StartAchievementScan()
	end)

	local RewardsFilterButton = CreateFrame("Button", nil, ControlFrame2, "UIPanelButtonTemplate")
	RewardsFilterButton:Size(70, 22)
	RewardsFilterButton:Point("LEFT", NearlyCompleteButton, "RIGHT", 5, 0)
	RewardsFilterButton:SetText(L["Rewards"] or "Rewards")
	RewardsFilterButton.Text:SetTextColor(1, 1, 1)
	F.SetFontOutline(RewardsFilterButton.Text)
	S:Proxy("HandleButton", RewardsFilterButton)

	---@return nil
	local function UpdateRewardsButtonState()
		if A:GetScanState().showOnlyRewards then
			RewardsFilterButton:SetBackdropBorderColor(0, 1, 0, 1)
		else
			RewardsFilterButton:SetBackdropBorderColor(0, 0, 0, 1)
		end
	end

	RewardsFilterButton:SetScript("OnClick", function()
		local newState = not A:GetScanState().showOnlyRewards
		A:SetScanState("showOnlyRewards", newState)
		UpdateRewardsButtonState()
		A:ApplyFiltersAndSort()
		A:UpdateAchievementList()
	end)

	UpdateRewardsButtonState()

	local ShowAllButton = CreateFrame("Button", nil, ControlFrame2, "UIPanelButtonTemplate")
	ShowAllButton:Size(60, 22)
	ShowAllButton:Point("RIGHT", ControlFrame2, "RIGHT", -10, 0)
	ShowAllButton:SetText(L["Show All"] or "All")
	ShowAllButton.Text:SetTextColor(1, 0.8, 0)
	F.SetFontOutline(ShowAllButton.Text)
	S:Proxy("HandleButton", ShowAllButton)

	ShowAllButton:SetScript("OnClick", function()
		A:SetScanState("searchTerm", "")
		A:SetScanState("selectedCategory", nil)
		A:SetScanState("showOnlyRewards", false)
		A:SetScanState("currentThreshold", A.Config.MIN_THRESHOLD)
		ThresholdSlider:SetValue(A.Config.MIN_THRESHOLD)
		SearchBox:SetText("")
		UpdateRewardsButtonState()
		A:StartAchievementScan()
	end)

	local ScrollFrame = CreateFrame("ScrollFrame", nil, Panel, "UIPanelScrollFrameTemplate")
	ScrollFrame:Size(A.Config.PANEL_WIDTH - 20, A.Config.PANEL_HEIGHT - 140)
	ScrollFrame:Point("TOP", ControlFrame2, "BOTTOM", 0, -5)

	local content = CreateFrame("Frame", nil, ScrollFrame)
	content:Size(A.Config.PANEL_WIDTH - 20, 100)
	ScrollFrame:SetScrollChild(content)

	ScrollFrame.ScrollBar:Point("TOPRIGHT", ScrollFrame, "TOPRIGHT", -2, -2)
	ScrollFrame.ScrollBar:Point("BOTTOMRIGHT", ScrollFrame, "BOTTOMRIGHT", -2, 2)
	S:Proxy("HandleScrollBar", ScrollFrame.ScrollBar)

	local ProgressContainer = CreateFrame("Frame", nil, Panel, "BackdropTemplate")
	ProgressContainer:Size(A.Config.PANEL_WIDTH - 20, 25)
	ProgressContainer:Point("BOTTOM", Panel, "BOTTOM", 0, -25)
	ProgressContainer:SetTemplate("Transparent")

	local ProgressBar = CreateFrame("StatusBar", nil, ProgressContainer)
	ProgressBar:Size(A.Config.PANEL_WIDTH - 40, 15)
	ProgressBar:Point("CENTER", ProgressContainer, "CENTER", 0, 0)
	ProgressBar:SetStatusBarTexture(E.media.normTex)
	ProgressBar:SetMinMaxValues(0, 100)
	ProgressBar:SetValue(0)
	ProgressBar:SetStatusBarColor(0.22, 0.72, 0.0)
	ProgressBar:CreateBackdrop("Transparent")

	local ProgressText = ProgressBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	ProgressText:Point("CENTER", ProgressBar, "CENTER", 0, 0)
	ProgressText:SetText(L["Ready to scan"])
	ProgressText:SetTextColor(0.7, 0.7, 0.7)
	F.SetFontOutline(ProgressText)

	Panel.ControlFrame = ControlFrame
	Panel.ControlFrame2 = ControlFrame2
	Panel.SearchBox = SearchBox
	Panel.ThresholdSlider = ThresholdSlider
	Panel.SortDropdown = SortDropdown
	Panel.CategoryDropdown = categoryDropdown
	Panel.SortOrderButton = SortOrderButton
	Panel.RefreshButton = RefreshButton
	Panel.NearlyCompleteButton = NearlyCompleteButton
	Panel.RewardsFilterButton = RewardsFilterButton
	Panel.ShowAllButton = ShowAllButton
	Panel.ScrollFrame = ScrollFrame
	Panel.Content = content
	Panel.ProgressBar = ProgressBar
	Panel.ProgressText = ProgressText
	Panel.ProgressContainer = ProgressContainer

	Panel.UpdateDropdowns = function()
		if SortDropdown and SortDropdown.GenerateMenu then
			SortDropdown:GenerateMenu()
		end
		if categoryDropdown and categoryDropdown.GenerateMenu then
			categoryDropdown:GenerateMenu()
		end
	end

	Panel.ProgressContainer:Hide()
end

---Update the achievement list display
---@return nil
function A:UpdateAchievementList()
	if not _G.WTAchievementTracker then
		return
	end

	if InCombatLockdown() then
		return
	end

	local Panel = _G.WTAchievementTracker --[[@as WTAchievementTracker]]
	local Content = Panel.Content
	local scanState = A:GetScanState()

	for _, child in pairs({ Content:GetChildren() }) do
		child:Hide()
		child:SetParent(nil)
	end

	local yOffset = -8
	for _, achievement in ipairs(scanState.filteredResults) do
		local isExpanded = scanState.expandedAchievements[achievement.id] or false
		local buttonHeight = A.Config.BUTTON_HEIGHT

		if isExpanded and achievement.criteria then
			local criteriaCount = #achievement.criteria
			buttonHeight = A.Config.BUTTON_HEIGHT + (criteriaCount * 18) + 12
		end

		local Button = CreateFrame("Button", nil, Content, "UIPanelButtonTemplate")
		Button:Size(A.Config.PANEL_WIDTH - 40, buttonHeight)
		Button:Point("TOPLEFT", Content, "TOPLEFT", 10, yOffset)

		S:Proxy("HandleButton", Button)

		local ExpandArrow = Button:CreateTexture(nil, "OVERLAY")
		ExpandArrow:Size(12, 12)
		ExpandArrow:Point("LEFT", Button, "LEFT", 4, 0)
		ExpandArrow:SetTexture(W.Media.Textures.arrowDown)
		ExpandArrow:SetVertexColor(0.8, 0.8, 0.8)
		ExpandArrow:SetRotation(isExpanded and 0 or -1.57)

		local IconFrame = CreateFrame("Frame", nil, Button)
		IconFrame:Size(A.Config.ICON_SIZE, A.Config.ICON_SIZE)
		IconFrame:Point("TOPLEFT", Button, "TOPLEFT", 20, -10)
		IconFrame:SetTemplate("Transparent")

		local Icon = IconFrame:CreateTexture(nil, "ARTWORK")
		Icon:Size(A.Config.ICON_SIZE - 4, A.Config.ICON_SIZE - 4)
		Icon:Point("CENTER", IconFrame, "CENTER", 0, 0)
		Icon:SetTexture(achievement.icon)
		Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

		local ProgressBar = CreateFrame("StatusBar", nil, Button)
		ProgressBar:Size(A.Config.PROGRESS_BAR_WIDTH, 12)
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
					UIErrorsFrame:AddMessage(
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
				scanState.expandedAchievements[achievement.id] = not isExpanded
				A:UpdateAchievementList()
			else
				if _G.AchievementFrame then
					_G.AchievementFrame_SelectAchievement(achievement.id)
					if not _G.AchievementFrame:IsShown() then
						_G.AchievementFrame_ToggleAchievementFrame()
					end
				end
			end
		end)

		yOffset = yOffset - (buttonHeight + A.Config.BUTTON_SPACING)
	end

	local totalHeight = -yOffset + A.Config.BUTTON_SPACING
	Content:SetHeight(max(100, totalHeight))
end
