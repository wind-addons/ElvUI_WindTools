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

local CreateFrame = CreateFrame

---@class AchievementTrackerPanel
---@field controlFrame Frame
---@field thresholdSlider Slider
---@field sortDropdown DropdownButton
---@field sortOrderButton Button
---@field refreshButton Button
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

	local controlFrame = CreateFrame("Frame", nil, panel, "BackdropTemplate")
	controlFrame:SetSize(A.Config.PANEL_WIDTH - 20, 40)
	controlFrame:SetPoint("TOP", panel, "TOP", 0, -10)
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

	--- TODO: See why this doesn't work like I want it to...
	---Calculate dynamic width based on text length.
	---@param options SortOption[]
	---@return number
	local function CalculateDropdownWidth(options)
		local maxWidth = 0
		local tempFont = sortDropdown:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		tempFont:SetFont(E.media.normFont, 12, "OUTLINE")

		for _, option in ipairs(options) do
			tempFont:SetText(option.text)
			local textWidth = tempFont:GetStringWidth()
			maxWidth = max(maxWidth, textWidth)
		end

		tempFont:SetParent(nil)
		tempFont:Hide()

		return max(60, maxWidth + 30)
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

	local scrollFrame = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scrollFrame:SetSize(A.Config.PANEL_WIDTH - 20, A.Config.PANEL_HEIGHT - 60)
	scrollFrame:SetPoint("TOP", controlFrame, "BOTTOM", 0, -5)

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
	panel.thresholdSlider = thresholdSlider
	panel.sortDropdown = sortDropdown
	panel.sortOrderButton = sortOrderButton
	panel.refreshButton = refreshButton
	panel.scrollFrame = scrollFrame
	panel.content = content
	panel.progressBar = progressBar
	panel.progressText = progressText
	panel.progressContainer = progressContainer

	panel.UpdateDropdowns = function()
		if sortDropdown and sortDropdown.GenerateMenu then
			sortDropdown:GenerateMenu()
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
		local button = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
		button:SetSize(A.Config.PANEL_WIDTH - 40, A.Config.BUTTON_HEIGHT)
		button:SetPoint("TOPLEFT", content, "TOPLEFT", 10, yOffset)

		S:Proxy("HandleButton", button)

		local iconFrame = CreateFrame("Frame", nil, button)
		iconFrame:SetSize(A.Config.ICON_SIZE, A.Config.ICON_SIZE)
		iconFrame:SetPoint("LEFT", button, "LEFT", 8, 0)
		iconFrame:SetTemplate("Transparent")

		local icon = iconFrame:CreateTexture(nil, "ARTWORK")
		icon:SetSize(A.Config.ICON_SIZE - 4, A.Config.ICON_SIZE - 4)
		icon:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)
		icon:SetTexture(achievement.icon)
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

		local progressBar = CreateFrame("StatusBar", nil, button)
		progressBar:SetSize(A.Config.PROGRESS_BAR_WIDTH, 12)
		progressBar:SetPoint("RIGHT", button, "RIGHT", -10, 0)
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
		F.SetFontOutline(nameText)

		local categoryText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		categoryText:SetPoint("LEFT", iconFrame, "RIGHT", 10, -6)
		categoryText:SetPoint("RIGHT", progressBar, "LEFT", -10, -6)
		categoryText:SetText(achievement.categoryName)
		categoryText:SetTextColor(0.7, 0.7, 0.7)
		F.SetFontOutline(categoryText)

		local criteriaText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		criteriaText:SetPoint("LEFT", iconFrame, "RIGHT", 10, -18)
		criteriaText:SetPoint("RIGHT", progressBar, "LEFT", -10, -18)
		criteriaText:SetText(format(L["%d/%d criteria"], achievement.completedCriteria, achievement.totalCriteria))
		criteriaText:SetTextColor(0.6, 0.6, 0.6)
		F.SetFontOutline(criteriaText)

		if achievement.rewardItemID then
			local rewardIcon = button:CreateTexture(nil, "OVERLAY")
			rewardIcon:SetSize(16, 16)
			rewardIcon:SetPoint("RIGHT", progressBar, "LEFT", -5, 0)
			rewardIcon:SetTexture("Interface\\Icons\\INV_Misc_Gift_01")
			rewardIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		end

		button:SetScript("OnClick", function()
			if _G.AchievementFrame then
				_G.AchievementFrame_SelectAchievement(achievement.id)
				if not _G.AchievementFrame:IsShown() then
					_G.AchievementFrame_ToggleAchievementFrame()
				end
			end
		end)

		yOffset = yOffset - (A.Config.BUTTON_HEIGHT + A.Config.BUTTON_SPACING)
	end

	content:SetHeight(max(100, #scanState.filteredResults * (A.Config.BUTTON_HEIGHT + A.Config.BUTTON_SPACING) + 10))
end
