local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local A = W:GetModule("AchievementTracker") ---@class AchievementTracker
local C = W.Utilities.Color
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs
local ipairs = ipairs
local max = max
local floor = floor
local format = format

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

	---@class WTAchievementTracker : Frame, BackdropTemplate
	local panel = CreateFrame("Frame", "WTAchievementTracker", _G.AchievementFrame, "BackdropTemplate")
	panel:SetSize(A.Config.PANEL_WIDTH, A.Config.PANEL_HEIGHT)
	panel:SetPoint("TOPLEFT", _G.AchievementFrame, "TOPRIGHT", 10, 0)
	panel:SetTemplate("Transparent")
	S:CreateShadow(panel)

	local searchBox = CreateFrame("EditBox", nil, panel, "SearchBoxTemplate")
	searchBox:SetSize(A.Config.PANEL_WIDTH - 30, 24)
	searchBox:SetPoint("TOP", panel, "TOP", 0, -10)
	searchBox:SetAutoFocus(false)
	searchBox:SetMaxLetters(50)
	S:Proxy("HandleEditBox", searchBox)

	searchBox:SetScript("OnTextChanged", function(editBox)
		local text = editBox:GetText()
		A:SetScanState("searchTerm", text)
		A:ApplyFiltersAndSort()
		A:UpdateAchievementList()
	end)

	searchBox:SetScript("OnEscapePressed", function(editBox)
		editBox:ClearFocus()
	end)

	local controlFrame = CreateFrame("Frame", nil, panel, "BackdropTemplate")
	controlFrame:SetSize(A.Config.PANEL_WIDTH - 20, 40)
	controlFrame:SetPoint("TOP", searchBox, "BOTTOM", 0, -5)
	controlFrame:SetTemplate("Transparent")

	local thresholdSlider = CreateFrame("Slider", nil, controlFrame, "OptionsSliderTemplate")
	thresholdSlider:SetOrientation("HORIZONTAL")
	thresholdSlider:SetSize(120, 14)
	thresholdSlider:SetPoint("LEFT", controlFrame, "LEFT", 15, 0)
	thresholdSlider:SetMinMaxValues(A.Config.MIN_THRESHOLD, A.Config.MAX_THRESHOLD)
	thresholdSlider:SetValueStep(1)
	thresholdSlider:SetObeyStepOnDrag(true)
	thresholdSlider:SetValue(A:GetScanState().currentThreshold)

	thresholdSlider.Text:SetPoint("BOTTOM", thresholdSlider, "TOP", 0, 2)
	thresholdSlider.Text:SetText(L["Threshold"] .. ": " .. A:GetScanState().currentThreshold .. "%")
	thresholdSlider.Text:SetTextColor(0.9, 0.9, 0.9)
	F.SetFontOutline(thresholdSlider.Text)

	thresholdSlider:SetScript("OnValueChanged", function(slider, value)
		A:SetScanState("currentThreshold", floor(value))
		slider.Text:SetText(L["Threshold"] .. ": " .. A:GetScanState().currentThreshold .. "%")
	end)

	S:Proxy("HandleSliderFrame", thresholdSlider)

	local sortDropdown = CreateFrame("DropdownButton", nil, controlFrame, "WowStyle1DropdownTemplate")
	sortDropdown:SetPoint("LEFT", thresholdSlider, "RIGHT", 15, 0)

	---@class SortOption
	---@field text string
	---@field value string

	---@param options SortOption[]
	---@return number
	local function CalculateDropdownWidth(options)
		local maxWidth = 0
		local tempFont = CreateFrame("Frame"):CreateFontString(nil, "ARTWORK", "GameFontNormal")
		tempFont:SetFont(E.media.normFont, 12, "OUTLINE")

		for _, option in ipairs(options) do
			tempFont:SetText(option.text)
			local textWidth = tempFont:GetStringWidth()
			maxWidth = max(maxWidth, textWidth)
		end

		tempFont:SetParent(nil)
		tempFont:Hide()

		return max(80, maxWidth + 40)
	end

	local sortOptions = {
		{ text = L["Percentage"], value = "percent" },
		{ text = L["Name"], value = "name" },
		{ text = L["Category"], value = "category" },
	}

	local dropdownWidth = CalculateDropdownWidth(sortOptions)
	S:Proxy("HandleDropDownBox", sortDropdown, dropdownWidth)

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

	sortDropdown:SetupMenu(SortGenerator)

	local sortOrderButton = CreateFrame("Button", nil, controlFrame, "UIPanelButtonTemplate")
	sortOrderButton:SetSize(30, 22)
	sortOrderButton:SetPoint("LEFT", sortDropdown, "RIGHT", 8, 0)
	S:Proxy("HandleButton", sortOrderButton)

	sortOrderButton.arrow = sortOrderButton:CreateTexture(nil, "OVERLAY")
	sortOrderButton.arrow:SetSize(16, 16)
	sortOrderButton.arrow:SetPoint("CENTER")
	sortOrderButton.arrow:SetTexture(W.Media.Textures.arrowDown)
	sortOrderButton.arrow:SetVertexColor(1, 1, 1)

	---@return nil
	local function UpdateArrow()
		sortOrderButton.arrow:SetRotation(A:GetScanState().sortOrder == "desc" and 0 or 3.14)
	end

	UpdateArrow()

	sortOrderButton:SetScript("OnClick", function()
		local newOrder = A:GetScanState().sortOrder == "desc" and "asc" or "desc"
		A:SetScanState("sortOrder", newOrder)
		UpdateArrow()
		A:ApplyFiltersAndSort()
		A:UpdateAchievementList()
	end)

	local refreshButton = CreateFrame("Button", nil, controlFrame, "UIPanelButtonTemplate")
	refreshButton:SetSize(60, 22)
	refreshButton:SetPoint("RIGHT", controlFrame, "RIGHT", -15, 0)
	refreshButton:SetText(L["Refresh"])
	refreshButton.Text:SetTextColor(1, 0.8, 0)
	F.SetFontOutline(refreshButton.Text)
	S:Proxy("HandleButton", refreshButton)

	refreshButton:SetScript("OnClick", function()
		A:StartAchievementScan()
	end)

	local controlFrame2 = CreateFrame("Frame", nil, panel, "BackdropTemplate")
	controlFrame2:SetSize(A.Config.PANEL_WIDTH - 20, 32)
	controlFrame2:SetPoint("TOP", controlFrame, "BOTTOM", 0, -5)
	controlFrame2:SetTemplate("Transparent")

	local categoryDropdown = CreateFrame("DropdownButton", nil, controlFrame2, "WowStyle1DropdownTemplate")
	categoryDropdown:SetPoint("LEFT", controlFrame2, "LEFT", 10, 0)
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

	local nearlyCompleteButton = CreateFrame("Button", nil, controlFrame2, "UIPanelButtonTemplate")
	nearlyCompleteButton:SetSize(90, 22)
	nearlyCompleteButton:SetPoint("LEFT", categoryDropdown, "RIGHT", 8, 0)
	nearlyCompleteButton:SetText("95%+")
	nearlyCompleteButton.Text:SetTextColor(1, 1, 1)
	F.SetFontOutline(nearlyCompleteButton.Text)
	S:Proxy("HandleButton", nearlyCompleteButton)

	nearlyCompleteButton:SetScript("OnClick", function()
		A:SetScanState("currentThreshold", 95)
		thresholdSlider:SetValue(95)
		A:StartAchievementScan()
	end)

	local rewardsFilterButton = CreateFrame("Button", nil, controlFrame2, "UIPanelButtonTemplate")
	rewardsFilterButton:SetSize(70, 22)
	rewardsFilterButton:SetPoint("LEFT", nearlyCompleteButton, "RIGHT", 5, 0)
	rewardsFilterButton:SetText(L["Rewards"] or "Rewards")
	rewardsFilterButton.Text:SetTextColor(1, 1, 1)
	F.SetFontOutline(rewardsFilterButton.Text)
	S:Proxy("HandleButton", rewardsFilterButton)

	---@return nil
	local function UpdateRewardsButtonState()
		if A:GetScanState().showOnlyRewards then
			rewardsFilterButton:SetBackdropBorderColor(0, 1, 0, 1)
		else
			rewardsFilterButton:SetBackdropBorderColor(0, 0, 0, 1)
		end
	end

	rewardsFilterButton:SetScript("OnClick", function()
		local newState = not A:GetScanState().showOnlyRewards
		A:SetScanState("showOnlyRewards", newState)
		UpdateRewardsButtonState()
		A:ApplyFiltersAndSort()
		A:UpdateAchievementList()
	end)

	UpdateRewardsButtonState()

	local showAllButton = CreateFrame("Button", nil, controlFrame2, "UIPanelButtonTemplate")
	showAllButton:SetSize(60, 22)
	showAllButton:SetPoint("RIGHT", controlFrame2, "RIGHT", -10, 0)
	showAllButton:SetText(L["Show All"] or "All")
	showAllButton.Text:SetTextColor(1, 0.8, 0)
	F.SetFontOutline(showAllButton.Text)
	S:Proxy("HandleButton", showAllButton)

	showAllButton:SetScript("OnClick", function()
		A:SetScanState("searchTerm", "")
		A:SetScanState("selectedCategory", nil)
		A:SetScanState("showOnlyRewards", false)
		A:SetScanState("currentThreshold", A.Config.MIN_THRESHOLD)
		thresholdSlider:SetValue(A.Config.MIN_THRESHOLD)
		searchBox:SetText("")
		UpdateRewardsButtonState()
		A:StartAchievementScan()
	end)

	local scrollFrame = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scrollFrame:SetSize(A.Config.PANEL_WIDTH - 20, A.Config.PANEL_HEIGHT - 140)
	scrollFrame:SetPoint("TOP", controlFrame2, "BOTTOM", 0, -5)

	local content = CreateFrame("Frame", nil, scrollFrame)
	content:SetSize(A.Config.PANEL_WIDTH - 20, 100)
	scrollFrame:SetScrollChild(content)

	scrollFrame.ScrollBar:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", -2, -2)
	scrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", -2, 2)
	S:Proxy("HandleScrollBar", scrollFrame.ScrollBar)

	local progressContainer = CreateFrame("Frame", nil, panel, "BackdropTemplate")
	progressContainer:SetSize(A.Config.PANEL_WIDTH - 20, 25)
	progressContainer:SetPoint("BOTTOM", panel, "BOTTOM", 0, -25)
	progressContainer:SetTemplate("Transparent")

	local progressBar = CreateFrame("StatusBar", nil, progressContainer)
	progressBar:SetSize(A.Config.PANEL_WIDTH - 40, 15)
	progressBar:SetPoint("CENTER", progressContainer, "CENTER", 0, 0)
	progressBar:SetStatusBarTexture(E.media.normTex)
	progressBar:SetMinMaxValues(0, 100)
	progressBar:SetValue(0)
	progressBar:SetStatusBarColor(0.22, 0.72, 0.0)
	progressBar:CreateBackdrop("Transparent")

	local progressText = progressBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	progressText:SetPoint("CENTER", progressBar, "CENTER", 0, 0)
	progressText:SetText(L["Ready to scan"])
	progressText:SetTextColor(0.7, 0.7, 0.7)
	F.SetFontOutline(progressText)

	panel.controlFrame = controlFrame
	panel.controlFrame2 = controlFrame2
	panel.searchBox = searchBox
	panel.thresholdSlider = thresholdSlider
	panel.sortDropdown = sortDropdown
	panel.categoryDropdown = categoryDropdown
	panel.sortOrderButton = sortOrderButton
	panel.refreshButton = refreshButton
	panel.nearlyCompleteButton = nearlyCompleteButton
	panel.rewardsFilterButton = rewardsFilterButton
	panel.showAllButton = showAllButton
	panel.scrollFrame = scrollFrame
	panel.content = content
	panel.progressBar = progressBar
	panel.progressText = progressText
	panel.progressContainer = progressContainer

	panel.UpdateDropdowns = function()
		if sortDropdown and sortDropdown.GenerateMenu then
			sortDropdown:GenerateMenu()
		end
		if categoryDropdown and categoryDropdown.GenerateMenu then
			categoryDropdown:GenerateMenu()
		end
	end

	panel.progressContainer:Hide()
end

---Update the achievement list display
---@return nil
function A:UpdateAchievementList()
	if not _G.WTAchievementTracker then
		return
	end

	local panel = _G.WTAchievementTracker --[[@as WTAchievementTracker]]
	local content = panel.content
	local scanState = A:GetScanState()

	for _, child in pairs({ content:GetChildren() }) do
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

		local button = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
		button:SetSize(A.Config.PANEL_WIDTH - 40, buttonHeight)
		button:SetPoint("TOPLEFT", content, "TOPLEFT", 10, yOffset)

		S:Proxy("HandleButton", button)

		local expandArrow = button:CreateTexture(nil, "OVERLAY")
		expandArrow:SetSize(12, 12)
		expandArrow:SetPoint("LEFT", button, "LEFT", 4, 0)
		expandArrow:SetTexture(W.Media.Textures.arrowDown)
		expandArrow:SetVertexColor(0.8, 0.8, 0.8)
		expandArrow:SetRotation(isExpanded and 0 or -1.57)

		local iconFrame = CreateFrame("Frame", nil, button)
		iconFrame:SetSize(A.Config.ICON_SIZE, A.Config.ICON_SIZE)
		iconFrame:SetPoint("TOPLEFT", button, "TOPLEFT", 20, -10)
		iconFrame:SetTemplate("Transparent")

		local icon = iconFrame:CreateTexture(nil, "ARTWORK")
		icon:SetSize(A.Config.ICON_SIZE - 4, A.Config.ICON_SIZE - 4)
		icon:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)
		icon:SetTexture(achievement.icon)
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

		local progressBar = CreateFrame("StatusBar", nil, button)
		progressBar:SetSize(A.Config.PROGRESS_BAR_WIDTH, 12)
		progressBar:SetPoint("TOPRIGHT", button, "TOPRIGHT", -10, -18)
		progressBar:SetStatusBarTexture(E.media.normTex)
		progressBar:SetMinMaxValues(0, 100)
		progressBar:SetValue(achievement.percent)

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
		progressBar:SetStatusBarColor(color.r, color.g, color.b)
		progressBar:CreateBackdrop("Transparent")

		local progressText = progressBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		progressText:SetPoint("CENTER", progressBar, "CENTER", 0, 0)
		progressText:SetText(format("%.0f%%", achievement.percent))
		progressText:SetTextColor(1, 1, 1)
		F.SetFontOutline(progressText)

		local nameText = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		nameText:SetPoint("LEFT", iconFrame, "RIGHT", 10, 6)
		nameText:SetPoint("RIGHT", progressBar, "LEFT", -10, 6)
		nameText:SetText(achievement.name)
		nameText:SetTextColor(1, 1, 1)
		nameText:SetJustifyH("LEFT")
		F.SetFontOutline(nameText)

		local categoryText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		categoryText:SetPoint("LEFT", iconFrame, "RIGHT", 10, -6)
		categoryText:SetPoint("RIGHT", progressBar, "LEFT", -10, -6)
		categoryText:SetText(achievement.categoryName)
		categoryText:SetTextColor(0.7, 0.7, 0.7)
		categoryText:SetJustifyH("LEFT")
		F.SetFontOutline(categoryText)

		local criteriaText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		criteriaText:SetPoint("LEFT", iconFrame, "RIGHT", 10, -18)
		criteriaText:SetPoint("RIGHT", progressBar, "LEFT", -10, -18)
		criteriaText:SetText(format(L["%d/%d criteria"], achievement.completedCriteria, achievement.totalCriteria))
		criteriaText:SetTextColor(0.6, 0.6, 0.6)
		criteriaText:SetJustifyH("LEFT")
		F.SetFontOutline(criteriaText)

		local rewardIcon
		if achievement.rewardItemID then
			rewardIcon = button:CreateTexture(nil, "OVERLAY")
			rewardIcon:SetSize(16, 16)
			rewardIcon:SetPoint("RIGHT", progressBar, "LEFT", -5, 0)
			rewardIcon:SetTexture("Interface\\Icons\\INV_Misc_Gift_01")
			rewardIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		end

		local trackButton = CreateFrame("CheckButton", nil, button, "UICheckButtonTemplate")
		trackButton:SetSize(20, 20)
		if rewardIcon then
			trackButton:SetPoint("TOPRIGHT", rewardIcon, "TOPLEFT", -4, 2)
		else
			trackButton:SetPoint("TOPRIGHT", progressBar, "TOPLEFT", -8, 2)
		end
		trackButton:SetFrameLevel(button:GetFrameLevel() + 2)
		S:Proxy("HandleCheckBox", trackButton)

		local isTracked = C_ContentTracking_IsTracking(Enum_ContentTrackingType.Achievement, achievement.id)
		trackButton:SetChecked(isTracked)

		if achievement.percent < 100 then
			trackButton:Show()
		else
			trackButton:Hide()
		end

		trackButton:SetScript("OnClick", function(btn)
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

		trackButton:SetScript("OnEnter", function(btn)
			GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
			if btn:GetChecked() then
				GameTooltip:SetText(L["Untrack Achievement"] or "Untrack Achievement", nil, nil, nil, nil, true)
			else
				GameTooltip:SetText(L["Track Achievement"] or "Track Achievement", nil, nil, nil, nil, true)
			end
			GameTooltip:Show()
		end)

		trackButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		if isExpanded and achievement.criteria then
			local criteriaYOffset = -50
			for i, criteria in ipairs(achievement.criteria) do
				local statusIcon = button:CreateTexture(nil, "OVERLAY")
				statusIcon:SetSize(14, 14)
				statusIcon:SetPoint("TOPLEFT", button, "TOPLEFT", 20, criteriaYOffset)

				if criteria.done then
					statusIcon:SetTexture("Interface/AchievementFrame/UI-Achievement-Criteria-Check")
					statusIcon:SetVertexColor(0, 1, 0)
				else
					statusIcon:SetTexture("Interface/Buttons/UI-CheckBox-Check-Disabled")
					statusIcon:SetVertexColor(0.5, 0.5, 0.5)
				end

				local criteriaLine = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
				criteriaLine:SetPoint("LEFT", statusIcon, "RIGHT", 4, 0)
				criteriaLine:SetPoint("RIGHT", button, "RIGHT", -15, 0)
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

		button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		button:SetScript("OnClick", function(_, mouseButton)
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
	content:SetHeight(max(100, totalHeight))
end
