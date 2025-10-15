local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local AT = W:NewModule("AchievementTracker", "AceEvent-3.0", "AceHook-3.0") ---@class AchievementTracker : AceModule, AceEvent-3.0, AceHook-3.0
local C = W.Utilities.Color
local async = W.Utilities.Async
local MF = W.Modules.MoveFrames
local S = W.Modules.Skins

local _G = _G
local coroutine = coroutine
local floor = floor
local format = format
local ipairs = ipairs
local math_pi = math.pi
local max = max
local pairs = pairs
local select = select
local sort = sort
local strfind = strfind
local strlower = strlower
local strtrim = strtrim
local tFilter = tFilter
local tinsert = tinsert
local tonumber = tonumber
local tostring = tostring
local tremove = tremove
local unpack = unpack

local CreateDataProvider = CreateDataProvider
local CreateFrame = CreateFrame
local CreateFramePool = CreateFramePool
local CreateScrollBoxListLinearView = CreateScrollBoxListLinearView
local GameTooltip = _G.GameTooltip
local GetAchievementCriteriaInfo = GetAchievementCriteriaInfo
local GetAchievementInfo = GetAchievementInfo
local GetAchievementNumCriteria = GetAchievementNumCriteria
local GetCategoryInfo = GetCategoryInfo
local GetCategoryList = GetCategoryList
local GetCategoryNumAchievements = GetCategoryNumAchievements
local GetKeysArray = GetKeysArray
local PlaySound = PlaySound

local C_AchievementInfo_GetRewardItemID = C_AchievementInfo.GetRewardItemID
local C_AchievementInfo_IsGuildAchievement = C_AchievementInfo.IsGuildAchievement
local C_AchievementInfo_IsValidAchievement = C_AchievementInfo.IsValidAchievement
local C_ContentTracking_GetTrackedIDs = C_ContentTracking.GetTrackedIDs
local C_ContentTracking_IsTracking = C_ContentTracking.IsTracking
local C_ContentTracking_StartTracking = C_ContentTracking.StartTracking
local C_ContentTracking_StopTracking = C_ContentTracking.StopTracking

local Constants_ContentTrackingConsts = Constants.ContentTrackingConsts
local Enum_ContentTrackingStopType = Enum.ContentTrackingStopType
local Enum_ContentTrackingType = Enum.ContentTrackingType
local RED_FONT_COLOR = RED_FONT_COLOR
local SOUNDKIT = SOUNDKIT
local ScrollBoxConstants = ScrollBoxConstants
local ScrollUtil = ScrollUtil

local LEFT_BUTTON_ICON = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t"
local RIGHT_BUTTON_ICON = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:410|t"
local SCROLL_BUTTON_ICON = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t"
local TIP_TOOLTIP_SPACING = 4
local ELEMENT_ICON_SIZE = 36
local ELEMENT_PADDING = 8
local ELEMENT_CRITERIA_LINE_HEIGHT = 12
local ELEMENT_CRITERIA_LINE_SPACING = 2
local ELEMENT_PERCENTAGE_HEIGHT = 35
local REWARDS_ICON_OFFSET_X = 80

---@class AchievementData
---@field id number
---@field name string
---@field nameLower? string cached lowercase name for sorting
---@field description string
---@field icon number
---@field category { id: number, name: string }
---@field criteriaData AchievementCriteriaData
---@field flags number
---@field reward { itemID: number|nil, text: string }
---@field isExpanded? boolean whether the element is expanded to show details
---@field isLastElement? boolean used to avoid cutting off the last element when expanding

---@class AchievementCriteriaDataDetail
---@field text string
---@field completed boolean
---@field quantity number
---@field reqQuantity number

---@class AchievementCriteriaData
---@field completed number
---@field total number
---@field percent number
---@field details AchievementCriteriaDataDetail[]

AT.states = {
	isScanning = false, ---@type boolean
	results = {}, ---@type AchievementData[]
	filters = {
		categoryID = nil, ---@type string|nil
		hasRewards = false, ---@type boolean
		minPercent = 0, ---@type number
		pattern = "", ---@type string
	},
	sort = {
		by = "percent", ---@type "percent"|"name"|"category"
		order = "desc", ---@type "asc"|"desc"
	},
	cache = {
		categoryNames = {}, ---@type table<number, string> Cache for category names
		progressColors = {}, ---@type table<number, {r: number, g: number, b: number}> Cache for progress bar colors
	},
}

---Get cached category name or fetch and cache it
---@param categoryID number
---@param cache table<number, string>
---@return string
local function GetCachedCategoryName(categoryID, cache)
	if not cache[categoryID] then
		cache[categoryID] = GetCategoryInfo(categoryID)
	end
	return cache[categoryID]
end

---Get cached progress bar color based on percent
---@param percent number
---@param cache table<number, {r: number, g: number, b: number}>
---@return {r: number, g: number, b: number}
local function GetCachedProgressColor(percent, cache)
	local key = floor(percent / 5) * 5 -- Cache by 5% increments
	if not cache[key] then
		if percent >= 90 then
			cache[key] = C.GetRGBFromTemplate("emerald-500")
		elseif percent >= 75 then
			cache[key] = C.GetRGBFromTemplate("green-500")
		elseif percent >= 60 then
			cache[key] = C.GetRGBFromTemplate("yellow-500")
		else
			cache[key] = C.GetRGBFromTemplate("orange-500")
		end
	end
	return cache[key]
end

---Calculate completion percentage and get detailed info for an achievement
---@param achievementID number
---@return AchievementCriteriaData
local function GetCriteriaData(achievementID)
	local total, completed = GetAchievementNumCriteria(achievementID), 0
	if not total or total == 0 then
		return { percent = 0, total = 0, details = {}, completed = 0 }
	end

	local details = {}
	for i = 1, total do
		local criteriaString, _, criteriaCompleted, quantity, reqQuantity = GetAchievementCriteriaInfo(achievementID, i)
		tinsert(
			details,
			{ text = criteriaString, completed = criteriaCompleted, quantity = quantity, reqQuantity = reqQuantity }
		)
		if criteriaCompleted then
			completed = completed + 1
		end
	end

	return { percent = (completed / total) * 100, total = total, details = details, completed = completed }
end

local function processNextFrame(self)
	if not self.states.isScanning or not self.scanCoroutine then
		return
	end

	local success, errorMessage = coroutine.resume(self.scanCoroutine)
	if not success then
		self.states.isScanning = false
		self.scanCoroutine = nil
		F.Developer.ThrowError(errorMessage)
		if self.MainFrame and self.MainFrame:IsVisible() then
			self.MainFrame.ProgressFrame:Hide()
		end
		return
	end

	if coroutine.status(self.scanCoroutine) ~= "dead" and self.states.isScanning then
		E:Delay(self.db.scan.batchInterval, function()
			processNextFrame(self)
		end)
	else
		self.states.isScanning = false
		self.scanCoroutine = nil
		if self.MainFrame and self.MainFrame:IsVisible() then
			self.MainFrame.ProgressFrame:Hide()
			self:UpdateView()
		end
	end
end

function AT:ScanAchievements()
	if self.states.isScanning then
		return
	end

	if self.MainFrame and self.MainFrame:IsVisible() then
		self.MainFrame.ProgressFrame.Bar:SetValue(0)
		self.MainFrame.ProgressFrame.Bar.ProgressText:SetText("")
		self.MainFrame.ProgressFrame:Show()
	end

	self.states.isScanning = true
	self.states.results = {}

	local categories = GetCategoryList()

	local total = 0
	for _, categoryID in ipairs(categories) do
		total = total + GetCategoryNumAchievements(categoryID)
	end

	self.scanCoroutine = coroutine.create(function()
		local scanned = 0
		local stepScanned = 0
		local categoryNameCache = self.states.cache.categoryNames

		for _, categoryID in ipairs(categories) do
			local numAchievements = GetCategoryNumAchievements(categoryID)
			local categoryName = GetCachedCategoryName(categoryID, categoryNameCache)

			for i = 1, numAchievements do
				if not self.states.isScanning then
					return
				end

				local id = select(1, GetAchievementInfo(categoryID, i))
				if id and C_AchievementInfo_IsValidAchievement(id) and not C_AchievementInfo_IsGuildAchievement(id) then
					async.WithAchievementID(id, function(data)
						local _, name, _, completed, _, _, _, description, flags, icon, rewardText = unpack(data)
						if completed then
							return
						end

						---@type AchievementData
						local result = {
							id = id,
							name = name,
							nameLower = strlower(name), -- Cache lowercase for sorting
							description = description,
							icon = icon,
							category = { id = categoryID, name = categoryName },
							criteriaData = GetCriteriaData(id),
							flags = flags,
							reward = { itemID = C_AchievementInfo_GetRewardItemID(id), text = rewardText },
						}

						tinsert(self.states.results, result)
					end)
				end

				scanned = scanned + 1
				stepScanned = stepScanned + 1

				if self.MainFrame and self.MainFrame:IsVisible() then
					F.Throttle(0.1, "AchievementTrackerScanProgress", function()
						local progress = (scanned / total) * 100
						self.MainFrame.ProgressFrame.Bar:SetValue(progress)
						self.MainFrame.ProgressFrame.Bar.ProgressText:SetText(
							format("%d / %d  -  %.0f %%", scanned, total, progress)
						)
					end)
				end

				if stepScanned >= self.db.scan.batchSize then
					coroutine.yield()
					stepScanned = 0
				end
			end
		end
	end)

	processNextFrame(self)
end

--- Set the element data for the achievement tracker
function AT:UpdateView()
	local filters = self.states.filters
	local results = tFilter(self.states.results, function(data)
		---@cast data AchievementData
		if filters.hasRewards and not data.reward.itemID then
			return false
		end

		if filters.categoryID and data.category.id ~= filters.categoryID then
			return false
		end

		if data.criteriaData.percent < self.db.threshold then
			return false
		end

		if filters.pattern and strtrim(filters.pattern) ~= "" then
			local found = false

			local isNumber = tostring(tonumber(filters.pattern)) == filters.pattern
			if isNumber then
				local id = tonumber(filters.pattern)
				if id and (id == data.id or id == data.reward.itemID) then
					found = true
				end
			else
				local patternLower = strlower(filters.pattern)
				for _, targetFields in pairs({ data.name, data.description, data.reward.text }) do
					if targetFields and strfind(strlower(targetFields), patternLower, 1, true) then
						found = true
						break
					end
				end
			end

			if not found then
				return false
			end
		end

		return true
	end, true)

	sort(results, function(a, b)
		---@cast a AchievementData
		---@cast b AchievementData
		local aVal, bVal

		if self.states.sort.by == "percent" then
			aVal, bVal = a.criteriaData.percent, b.criteriaData.percent
		elseif self.states.sort.by == "name" then
			aVal, bVal = a.nameLower or strlower(a.name), b.nameLower or strlower(b.name)
		elseif self.states.sort.by == "category" then
			aVal, bVal = a.category.id, b.category.id
		end

		if self.states.sort.order == "desc" then
			return aVal > bVal
		else
			return aVal < bVal
		end
	end)

	if self.LastElement then
		self.LastElement.isLastElement = nil
		self.LastElement = nil
	end

	if #results > 0 then
		self.LastElement = results[#results]
		self.LastElement.isLastElement = true
	end

	local dataProvider = CreateDataProvider()
	dataProvider:InsertTable(results)
	self
		.MainFrame
		.ScrollFrame
		.ScrollBox--[[@as ScrollBoxListMixin]]
		:SetDataProvider(dataProvider)
	self.MainFrame:UpdateDropdowns()
end

---Update criteria data for an achievement
---@param data AchievementData
function AT:UpdateCriteriaData(data)
	local latest = GetCriteriaData(data.id)
	local old = data.criteriaData
	if old.completed == latest.completed and old.total == latest.total then
		return
	end

	data.criteriaData = latest
end

---Apply achievement data to a UI element
---@param frame Frame
---@param data AchievementData
function AT:ScrollElementInitializer(frame, data, scrollBox)
	self:UpdateCriteriaData(data)

	frame.data = data

	if not frame.Initialized then
		frame:SetTemplate()
		frame:SetBackdropColor(C.ExtractRGBAFromTemplate("neutral-900"))

		local TooltipFrame = CreateFrame("Frame", nil, self.MainFrame, "BackdropTemplate")
		TooltipFrame:SetFrameStrata("TOOLTIP")
		TooltipFrame:SetTemplate("Transparent")
		TooltipFrame:SetBackdropColor(0, 0, 0, 0.95)
		TooltipFrame:Hide()
		S:CreateShadow(TooltipFrame)
		frame.TooltipFrame = TooltipFrame

		local HintContainer = CreateFrame("Frame", nil, TooltipFrame)
		TooltipFrame.HintContainer = HintContainer

		local TooltipHint1 = HintContainer:CreateFontString(nil, "OVERLAY")
		F.SetFont(TooltipHint1, E.db.general.font, 12)
		TooltipHint1:SetTextColor(C.ExtractRGBAFromTemplate("neutral-50"))
		TooltipHint1:SetJustifyH("CENTER")
		TooltipHint1:SetText(LEFT_BUTTON_ICON .. " " .. L["Toggle Details"])
		HintContainer.Hint1 = TooltipHint1

		local TooltipHint2 = HintContainer:CreateFontString(nil, "OVERLAY")
		F.SetFont(TooltipHint2, E.db.general.font, 12)
		TooltipHint2:SetTextColor(C.ExtractRGBAFromTemplate("neutral-50"))
		TooltipHint2:SetJustifyH("CENTER")
		TooltipHint2:SetText(SCROLL_BUTTON_ICON .. " " .. L["Track"])
		HintContainer.Hint2 = TooltipHint2

		local TooltipHint3 = HintContainer:CreateFontString(nil, "OVERLAY")
		F.SetFont(TooltipHint3, E.db.general.font, 12)
		TooltipHint3:SetTextColor(C.ExtractRGBAFromTemplate("neutral-50"))
		TooltipHint3:SetJustifyH("CENTER")
		TooltipHint3:SetText(RIGHT_BUTTON_ICON .. " " .. L["Open in Achievement"])
		HintContainer.Hint3 = TooltipHint3

		local hint1Width = TooltipHint1:GetStringWidth()
		local hint2Width = TooltipHint2:GetStringWidth()
		local hint3Width = TooltipHint3:GetStringWidth()
		local totalWidth = hint1Width + hint2Width + hint3Width + 2 * TIP_TOOLTIP_SPACING + 16
		local hintHeight =
			max(TooltipHint1:GetStringHeight(), TooltipHint2:GetStringHeight(), TooltipHint3:GetStringHeight())

		TooltipHint1:Point("LEFT", HintContainer, "LEFT", 0, 0)
		TooltipHint2:Point("LEFT", TooltipHint1, "RIGHT", TIP_TOOLTIP_SPACING, 0)
		TooltipHint3:Point("LEFT", TooltipHint2, "RIGHT", TIP_TOOLTIP_SPACING, 0)

		HintContainer:Size(totalWidth, hintHeight)
		HintContainer:Point("CENTER", TooltipFrame, "CENTER", 0, 0)

		TooltipFrame:Size(totalWidth + 16, hintHeight + 16)

		frame:SetScript("OnEnter", function(f)
			f:SetBackdropColor(C.ExtractRGBAFromTemplate("neutral-700"))
			if f.TooltipFrame and self.db.tooltip then
				f.TooltipFrame:ClearAllPoints()
				f.TooltipFrame:Point("BOTTOM", f, "TOP", 0, 3)
				f.TooltipFrame:Show()
			end
		end)
		frame:SetScript("OnLeave", function(f)
			f:SetBackdropColor(C.ExtractRGBAFromTemplate("neutral-900"))
			if f.TooltipFrame and self.db.tooltip then
				f.TooltipFrame:Hide()
			end
		end)

		local ProgressBackdrop = CreateFrame("StatusBar", nil, frame)
		E:SetSmoothing(ProgressBackdrop, true)
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
		F.SetFont(PercentageText, F.GetCompatibleFont("Accidental Presidency"), 20)
		PercentageText:SetJustifyH("LEFT")
		PercentageText:SetJustifyV("BOTTOM")
		PercentageText:Size(24, PercentageFrame:GetHeight())
		PercentageText:SetText("%")
		PercentageText:Point("RIGHT", PercentageFrame, "RIGHT", 0, 0)
		frame.PercentageFrame.PercentageText = PercentageText

		local ValueText = PercentageFrame:CreateFontString(nil, "OVERLAY")
		F.SetFont(ValueText, F.GetCompatibleFont("Accidental Presidency"), 40)
		ValueText:SetJustifyH("RIGHT")
		ValueText:SetJustifyV("BOTTOM")
		ValueText:Height(PercentageFrame:GetHeight())
		ValueText:Point("RIGHT", PercentageText, "LEFT", 0, -4)
		frame.PercentageFrame.ValueText = ValueText

		local IndicatorFrame = CreateFrame("Frame", nil, frame)
		IndicatorFrame:SetAllPoints(ProgressBackdrop)
		IndicatorFrame:SetFrameLevel(frame:GetFrameLevel() + 2)
		frame.IndicatorFrame = IndicatorFrame

		local TrackingText = IndicatorFrame:CreateFontString(nil, "OVERLAY")
		F.SetFont(TrackingText, E.db.general.font, 10)
		TrackingText:SetJustifyH("CENTER")
		TrackingText:SetJustifyV("MIDDLE")
		TrackingText:Point("CENTER", IndicatorFrame, "BOTTOM", 0, 1)
		TrackingText:SetText(L["Tracking"])
		TrackingText:SetTextColor(C.ExtractRGBAFromTemplate("green-200"))
		frame.IndicatorFrame.TrackingText = TrackingText

		local RewardsIcon = IndicatorFrame:CreateTexture(nil, "OVERLAY")
		RewardsIcon:Size(floor(ELEMENT_ICON_SIZE * 0.68))
		RewardsIcon:Point("RIGHT", -REWARDS_ICON_OFFSET_X, 0)
		RewardsIcon:CreateBackdrop()
		RewardsIcon:SetTexCoord(unpack(E.TexCoords))
		RewardsIcon:SetScript("OnEnter", function(icon)
			if not frame.data.reward.itemID then
				return
			end
			GameTooltip:SetOwner(icon, "ANCHOR_RIGHT")
			GameTooltip:SetItemByID(frame.data.reward.itemID)
			GameTooltip:Show()
		end)
		RewardsIcon:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		frame.IndicatorFrame.RewardsIcon = RewardsIcon

		local TextFrame = CreateFrame("Frame", nil, frame)
		TextFrame:Point("TOPLEFT", frame.IconFrame, "TOPRIGHT", 8, -4)
		TextFrame:Point("BOTTOMRIGHT", frame.PercentageFrame, "BOTTOMLEFT", -8, 0)
		frame.TextFrame = TextFrame

		local Name = TextFrame:CreateFontString(nil, "OVERLAY")
		F.SetFont(Name, E.db.general.font, 15)
		Name:SetTextColor(C.ExtractRGBAFromTemplate("amber-400"))
		Name:SetJustifyH("LEFT")
		Name:Point("TOPLEFT", TextFrame, "TOPLEFT", 0, 0)
		frame.TextFrame.Name = Name

		local Category = TextFrame:CreateFontString(nil, "OVERLAY")
		F.SetFont(Category, E.db.general.font, 12)
		Category:SetJustifyH("LEFT")
		Category:SetTextColor(C.ExtractRGBAFromTemplate("neutral-300"))
		Category:Point("TOPLEFT", Name, "BOTTOMLEFT", 0, -3)
		frame.TextFrame.Category = Category

		local DetailFrame = CreateFrame("Frame", nil, frame)
		DetailFrame:Point("TOPLEFT", ProgressBackdrop, "BOTTOMLEFT", 0, 0)
		DetailFrame:Point("TOPRIGHT", ProgressBackdrop, "BOTTOMRIGHT", 0, 0)
		DetailFrame:SetFrameLevel(frame:GetFrameLevel() + 2)
		DetailFrame:Hide()
		frame.DetailFrame = DetailFrame
		frame.DetailFrame.Criteria = {}

		local Description = DetailFrame:CreateFontString(nil, "OVERLAY")
		F.SetFont(Description, E.db.general.font, 13, "NONE")
		Description:Point("TOP", DetailFrame, "TOP", 0, -ELEMENT_PADDING)
		Description:Width(frame:GetWidth() - 4 * ELEMENT_PADDING)
		Description:SetJustifyH("CENTER")
		Description:SetJustifyV("MIDDLE")
		Description:SetTextColor(C.ExtractRGBAFromTemplate("neutral-200"))
		Description:SetWordWrap(true)

		frame.DetailFrame.Description = Description
		frame:EnableMouse(true)

		frame.UpdateHeight = function(f)
			f.data.height = 2 + f.ProgressBackdrop:GetHeight()

			if f.data.isExpanded then
				f.data.height = f.data.height + f.DetailFrame:GetHeight()
			end

			f:Height(f.data.height)
		end

		frame:SetScript("OnMouseDown", function(f, button)
			if button == "LeftButton" then
				f.data.isExpanded = not f.data.isExpanded
				f.DetailFrame:SetShown(f.data.isExpanded)
				f:UpdateHeight()

				scrollBox:FullUpdate(ScrollBoxConstants.UpdateImmediately)
				if f.data.isLastElement then
					scrollBox:ScrollToEnd()
				end
			elseif button == "MiddleButton" then
				if not C_ContentTracking_IsTracking(Enum_ContentTrackingType.Achievement, f.data.id) then
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

					local err = C_ContentTracking_StartTracking(Enum_ContentTrackingType.Achievement, f.data.id)
					if not err then
						PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
						IndicatorFrame.TrackingText:SetShown(true)
					end
				else
					C_ContentTracking_StopTracking(
						Enum_ContentTrackingType.Achievement,
						f.data.id,
						Enum_ContentTrackingStopType.Manual
					)
					PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
					IndicatorFrame.TrackingText:SetShown(false)
				end
			elseif button == "RightButton" then
				_G.AchievementFrame_SelectAchievement(f.data.id)
			end
		end)

		frame.DetailFrame:SetScript("OnShow", function()
			for i, detail in ipairs(frame.data.criteriaData.details) do
				local line = self.MainFrame.CriteriaLinePool:Acquire() ---@type Frame
				line:SetParent(frame.DetailFrame)
				line:Size(frame.DetailFrame:GetWidth(), ELEMENT_CRITERIA_LINE_HEIGHT)

				if not line.StatusIcon then
					line.StatusIcon = line:CreateTexture(nil, "OVERLAY")
					line.StatusIcon:Size(14, 14)
					line.StatusIcon:Point("LEFT", line, "LEFT", 5, 0)
					line.StatusIcon:SetTexture(W.Media.Icons.buttonCheck)
					line.StatusIcon:SetVertexColor(C.ExtractRGBFromTemplate("emerald-500"))
				end

				if not line.Text then
					line.Text = line:CreateFontString(nil, "OVERLAY")
					F.SetFont(line.Text, E.db.general.font, 12, "SHADOW")
					line.Text:Point("LEFT", line.StatusIcon, "RIGHT", 4, 0)
					line.Text:Point("RIGHT", line, "RIGHT", 0, 0)
					line.Text:SetJustifyH("LEFT")
					line.Text:SetJustifyV("MIDDLE")
				end

				line.StatusIcon:SetShown(detail.completed)
				local text = detail.text or L["Unknown"]
				if detail.reqQuantity and detail.reqQuantity > 1 then
					text = text .. format(" (%d/%d)", detail.quantity, detail.reqQuantity)
				end
				line.Text:SetText(text)
				if detail.completed then
					line.Text:SetTextColor(C.ExtractRGBAFromTemplate("emerald-500"))
				else
					line.Text:SetTextColor(C.ExtractRGBAFromTemplate("neutral-300"))
				end
				line:Point(
					"TOPLEFT",
					frame.DetailFrame.Description,
					"BOTTOMLEFT",
					0,
					-ELEMENT_PADDING - (i - 1) * (ELEMENT_CRITERIA_LINE_HEIGHT + ELEMENT_CRITERIA_LINE_SPACING)
				)
				line:Show()
				frame.DetailFrame.Criteria[i] = line
			end
		end)

		frame.DetailFrame:SetScript("OnHide", function()
			for i = #frame.DetailFrame.Criteria, 1, -1 do
				local line = tremove(frame.DetailFrame.Criteria, i)
				line:ClearAllPoints()
				line:Hide()
				line:SetParent(self.MainFrame)
				self.MainFrame.CriteriaLinePool:Release(line)
			end
		end)

		frame.Initialized = true
	end

	local color = GetCachedProgressColor(data.criteriaData.percent, self.states.cache.progressColors)
	frame.ProgressBackdrop:SetStatusBarColor(color.r, color.g, color.b)
	frame.ProgressBackdrop:SetValue(data.criteriaData.percent)
	frame.IndicatorFrame.TrackingText:SetShown(
		C_ContentTracking_IsTracking(Enum_ContentTrackingType.Achievement, data.id)
	)
	frame.IndicatorFrame.RewardsIcon:Hide()
	frame.IndicatorFrame.RewardsIcon.backdrop:Hide()
	if data.reward.itemID then
		async.WithItemID(data.reward.itemID, function(item)
			if not item then
				return
			end
			frame.IndicatorFrame.RewardsIcon:SetTexture(item:GetItemIcon())
			if item:GetItemQuality() then
				frame.IndicatorFrame.RewardsIcon.backdrop:SetBackdropBorderColor(item:GetItemQualityColorRGB())
			else
				frame.IndicatorFrame.RewardsIcon.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
			frame.IndicatorFrame.RewardsIcon:Show()
			frame.IndicatorFrame.RewardsIcon.backdrop:Show()
		end)
	end

	frame.IconFrame.Icon:SetTexture(data.icon)
	frame.PercentageFrame.ValueText:SetText(tostring(floor(data.criteriaData.percent)))
	frame.TextFrame.Name:SetText(data.name)
	frame.TextFrame.Category:SetText(data.category.name)
	frame.DetailFrame.Description:SetText(data.description)
	local detailFrameHeight = 2 * ELEMENT_PADDING
		+ frame.DetailFrame.Description:GetLineHeight() * frame.DetailFrame.Description:GetNumLines()
	if data.criteriaData.total > 0 then
		detailFrameHeight = detailFrameHeight
			+ ELEMENT_PADDING
			+ data.criteriaData.total * (ELEMENT_CRITERIA_LINE_HEIGHT + ELEMENT_CRITERIA_LINE_SPACING)
			- ELEMENT_CRITERIA_LINE_SPACING
	end

	frame.DetailFrame:Height(detailFrameHeight)
	frame.DetailFrame:SetShown(data.isExpanded)
	frame:UpdateHeight()
end

function AT:ScrollElementResetter(frame)
	frame.DetailFrame:Hide()
end

function AT:Construct()
	if self.MainFrame then
		return
	end

	---@class WTAchievementTracker : Frame, BackdropTemplate
	local MainFrame = CreateFrame("Frame", "WTAchievementTracker", E.UIParent, "BackdropTemplate")
	MainFrame:Size(self.db.width, self.db.height)
	MainFrame:SetTemplate("Transparent")
	MainFrame:SetShown(self.db.enabled and self.db.show)
	S:CreateShadow(MainFrame)
	self.MainFrame = MainFrame
	MainFrame.States = self.states

	local SearchBox = CreateFrame("EditBox", "WTAchievementTrackerSearchBox", MainFrame, "SearchBoxTemplate")
	SearchBox:Height(24)
	SearchBox:Point("TOPLEFT", MainFrame, "TOPLEFT", 12, -8)
	SearchBox:Point("TOPRIGHT", MainFrame, "TOPRIGHT", -12, -8)
	SearchBox:SetFont(E.db.general.font, E.db.general.fontSize, "OUTLINE")
	SearchBox:SetAutoFocus(false)
	SearchBox:SetMaxLetters(50)
	SearchBox.Instructions:SetText(L["Search by name, description, ID"])
	SearchBox:HookScript("OnEnterPressed", function(editBox)
		self.states.filters.pattern = editBox:GetText()
		self:UpdateView()
	end)
	SearchBox:HookScript("OnTextSet", function(editBox)
		self.states.filters.pattern = editBox:GetText()
		self:UpdateView()
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
	ThresholdSlider:SetMinMaxValues(0, 100)
	ThresholdSlider:SetValueStep(1)
	ThresholdSlider:SetValue(self.db.threshold)
	S:Proxy("HandleSliderFrame", ThresholdSlider)
	ThresholdSlider.Text = ThresholdSlider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	ThresholdSlider.Text:Point("BOTTOM", ThresholdSlider, "TOP", 0, 2)
	ThresholdSlider.Text:SetText(L["Threshold"] .. ": " .. self.db.threshold .. "%")
	ThresholdSlider.Text:SetTextColor(C.ExtractRGBAFromTemplate("neutral-50"))
	F.SetFont(ThresholdSlider.Text)
	ThresholdSlider:SetScript("OnValueChanged", function(slider, value)
		self.db.threshold = floor(value)
		slider.Text:SetText(L["Threshold"] .. ": " .. self.db.threshold .. "%")
		F.Throttle(1, "AchievementTrackerThreshold", function()
			self:UpdateView()
		end)
	end)
	ControlFrame1.ThresholdSlider = ThresholdSlider

	local ShowAllButton = CreateFrame("Button", nil, ControlFrame1, "UIPanelButtonTemplate")
	ShowAllButton:Size(80, 25)
	ShowAllButton:Point("LEFT", ThresholdSlider, "RIGHT", 15, 8)
	ShowAllButton:SetText(L["All"])
	F.SetFont(ShowAllButton.Text, E.db.general.font)
	S:Proxy("HandleButton", ShowAllButton)
	ShowAllButton:SetScript("OnClick", function()
		self.states.filters.pattern = ""
		self.states.filters.categoryID = nil
		self.states.filters.hasRewards = false
		self.db.threshold = 0
		ThresholdSlider:SetValue(0)
		SearchBox:SetText("")
		self:UpdateView()
	end)
	ControlFrame1.ShowAllButton = ShowAllButton

	local NearlyCompleteButton = CreateFrame("Button", nil, ControlFrame1, "UIPanelButtonTemplate")
	NearlyCompleteButton:Size(80, 25)
	NearlyCompleteButton:Point("LEFT", ShowAllButton, "RIGHT", 8, 0)
	NearlyCompleteButton:SetText("95%+")
	F.SetFont(NearlyCompleteButton.Text)
	S:Proxy("HandleButton", NearlyCompleteButton)
	NearlyCompleteButton:SetScript("OnClick", function()
		self.db.threshold = 95
		ThresholdSlider:SetValue(95)
		self:UpdateView()
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
		self:ScanAchievements()
	end)
	RefreshButton:SetScript("OnEnter", function(btn)
		GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
		GameTooltip:SetText(L["Rescan All Achievements"], 1, 1, 1)
		GameTooltip:Show()
	end)
	RefreshButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	ControlFrame1.RefreshButton = RefreshButton

	local ControlFrame2 = CreateFrame("Frame", nil, MainFrame, "BackdropTemplate")
	ControlFrame2:Height(32)
	ControlFrame2:Point("TOPLEFT", ControlFrame1, "BOTTOMLEFT", 0, -5)
	ControlFrame2:Point("TOPRIGHT", ControlFrame1, "BOTTOMRIGHT", 0, -5)
	ControlFrame2:SetTemplate("Transparent")
	MainFrame.ControlFrame2 = ControlFrame2

	local CategoryDropdown = CreateFrame("DropdownButton", nil, ControlFrame2, "WowStyle1DropdownTemplate")
	CategoryDropdown:Point("LEFT", ControlFrame2, "LEFT", 8, 0)
	S:Proxy("HandleDropDownBox", CategoryDropdown, 150)
	CategoryDropdown:SetupMenu(function(_, rootDescription)
		---@cast rootDescription RootMenuDescriptionProxy
		rootDescription:CreateRadio(L["All Categories"] or "All Categories", function()
			return self.states.filters.categoryID == nil
		end, function()
			self.states.filters.categoryID = nil
			self:UpdateView()
		end)

		rootDescription:CreateDivider()

		local categories = GetCategoryList()
		local categoryTable = {} ---@type table<number, { id: number, name: string, subCategories: { id: number, name: string }[] }>
		for _, categoryID in ipairs(categories) do
			local title, parentCategoryID = GetCategoryInfo(categoryID)
			if parentCategoryID and parentCategoryID > 0 then
				if categoryTable[parentCategoryID] == nil then
					categoryTable[parentCategoryID] = {
						id = parentCategoryID,
						name = GetCategoryInfo(parentCategoryID),
						subCategories = {},
					}
				end

				categoryTable[parentCategoryID].subCategories[#categoryTable[parentCategoryID].subCategories + 1] = {
					id = categoryID,
					name = title,
				}
			end
		end

		for _, category in pairs(categoryTable) do
			sort(category.subCategories, function(a, b)
				return a.name < b.name
			end)
		end

		local sortedKeys = GetKeysArray(categoryTable)
		sort(sortedKeys, function(a, b)
			return categoryTable[a].id < categoryTable[b].id
		end)

		for _, parentCategoryID in ipairs(sortedKeys) do
			local category = categoryTable[parentCategoryID]
			local parent = rootDescription:CreateTitle(category.name)
			for _, subCategory in ipairs(category.subCategories) do
				parent:CreateRadio(subCategory.name, function()
					return self.states.filters.categoryID == subCategory.id
				end, function()
					self.states.filters.categoryID = subCategory.id
					self:UpdateView()
				end)
			end
		end
	end)

	ControlFrame2.CategoryDropdown = CategoryDropdown

	local RewardsCheckButton = CreateFrame("CheckButton", nil, ControlFrame2, "UICheckButtonTemplate")
	RewardsCheckButton:Size(22, 22)
	RewardsCheckButton:Point("LEFT", CategoryDropdown, "RIGHT", 15, 0)
	RewardsCheckButton.Text:SetText(L["Rewards"])
	RewardsCheckButton.Text:SetTextColor(1, 1, 1)
	F.SetFont(RewardsCheckButton.Text)
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

	local ScrollView = CreateScrollBoxListLinearView() --[[@as ScrollBoxLinearBaseViewMixin]]

	local DataProvider = CreateDataProvider()
	DataProvider:InsertTable({})

	ScrollView:SetPadding(8, 8, 8, 8, 8)
	ScrollView:SetElementInitializer("BackdropTemplate", function(frame, data)
		self:ScrollElementInitializer(frame, data, ScrollBox)
	end)
	ScrollView:SetElementExtentCalculator(function(dataIndex, elementData)
		return elementData.height or (ELEMENT_ICON_SIZE + 2 * ELEMENT_PADDING)
	end)
	ScrollView:SetElementResetter(function(frame)
		self:ScrollElementResetter(frame)
	end)
	ScrollUtil.InitScrollBoxListWithScrollBar(ScrollBox, ScrollBar, ScrollView)
	ScrollBox--[[@as ScrollBoxListMixin]]:SetDataProvider(DataProvider)
	ScrollFrame.ScrollView = ScrollView

	local ProgressFrame = CreateFrame("Frame", nil, MainFrame)
	ProgressFrame:SetFrameStrata("DIALOG")
	ProgressFrame:SetAllPoints(MainFrame)
	MainFrame.ProgressFrame = ProgressFrame

	local ProgressBar = CreateFrame("StatusBar", nil, ProgressFrame)
	E:SetSmoothing(ProgressBar, true)
	ProgressBar:Size(self.db.width - 50, 26)
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
	F.SetFont(ProgressLabel, E.db.general.font, E.db.general.fontSize + 12)
	ProgressLabel:Point("BOTTOM", ProgressBar, "TOP", 0, 20)
	ProgressLabel:SetText(L["Scanning"])
	ProgressLabel:SetTextColor(C.ExtractRGBAFromTemplate("amber-400"))
	ProgressFrame.Label = ProgressLabel

	local ProgressBarProgressText = ProgressBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	F.SetFont(ProgressBarProgressText, F.GetCompatibleFont("Chivo Mono"), 14)
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

	MainFrame:SetScript("OnShow", function()
		if not MainFrame:IsVisible() or not MainFrame.positionUpdated then
			return
		end

		if self.states.isScanning then
			MainFrame.ProgressFrame:Show()
			return
		else
			MainFrame.ProgressFrame:Hide()
		end

		if #self.states.results == 0 and self.db.scan.automation.enable and self.db.scan.automation.onShow then
			self:ScanAchievements()
			return
		end

		self:UpdateView()
	end)

	MainFrame.ProgressFrame:Hide()
	MainFrame.CriteriaLinePool = CreateFramePool("Frame", nil, "BackdropTemplate")
end

---Handle ACHIEVEMENT_EARNED event
---@param id number
---@param alreadyEarned boolean
function AT:ACHIEVEMENT_EARNED(id, alreadyEarned)
	if alreadyEarned and #self.states.results > 0 then
		return
	end

	for i, achievement in ipairs(self.states.results) do
		if achievement.id == id then
			tremove(self.states.results, i)
			if self.MainFrame:IsVisible() then
				self:UpdateView()
			end
			break
		end
	end
end

function AT:CRITERIA_UPDATE()
	F.Throttle(0.5, "AchievementTrackerCriteriaUpdate", function()
		if self.MainFrame and self.MainFrame:IsVisible() then
			self
				.MainFrame
				.ScrollFrame
				.ScrollBox--[[@as ScrollBoxBaseMixin]]
				:FullUpdate(ScrollBoxConstants.UpdateImmediately)
		end
	end)
end

---@param _ any
---@param addonName string
function AT:ADDON_LOADED(_, addonName)
	if addonName == "Blizzard_AchievementUI" then
		self:UnregisterEvent("ADDON_LOADED")
		self:UpdatePosition()
	end
end

function AT:UpdatePosition()
	if not _G.AchievementFrame then
		return false
	end

	self.MainFrame:ClearAllPoints()
	self.MainFrame:Point("TOPLEFT", _G.AchievementFrame, "TOPRIGHT", 4, 0)
	self.MainFrame:SetParent(_G.AchievementFrame)
	self.MainFrame.positionUpdated = true
	MF:InternalHandle(self.MainFrame, _G.AchievementFrame)

	self.ToggleButton = CreateFrame("Button", nil, _G.AchievementFrame, "UIPanelButtonTemplate")
	self.ToggleButton:Point("BOTTOMRIGHT", _G.AchievementFrame, "BOTTOMRIGHT", -4, 4)
	self.ToggleButton:SetText(F.GetWindStyleText(L["Achievement Tracker"]))
	F.SetFont(self.ToggleButton.Text, E.db.general.font, 10)
	local buttonWidth = 20 + max(40, F.GetAdaptiveTextWidth(E.media.normFont, 10, "OUTLINE", L["Achievement Tracker"]))
	self.ToggleButton:Size(buttonWidth, 18)
	self.ToggleButton:SetScript("OnClick", function()
		self.db.show = not self.MainFrame:IsShown()
		self.MainFrame:SetShown(self.db.show)
	end)
	S:Proxy("HandleButton", self.ToggleButton)
	return true
end

function AT:Initialize()
	if not E.db or not E.db.WT or not E.db.WT.misc.achievementTracker then
		return
	end

	self.db = E.db.WT.misc.achievementTracker

	if not self.db.enable then
		self:Disable()
		if self.initialized then
			self.MainFrame:Hide()
			self.ToggleButton:Hide()
			if self.ToggleButton then
				self.ToggleButton:Hide()
			end
			self.MainFrame.CriteriaLinePool:ReleaseAll()
		end
		return
	end

	if not self.initialized then
		self:Construct()
		if not self:UpdatePosition() then
			self:RegisterEvent("ADDON_LOADED")
		end

		self:RegisterEvent("ACHIEVEMENT_EARNED")
		self:RegisterEvent("CRITERIA_UPDATE")
	end

	self:Enable()
	if self.ToggleButton then
		self.ToggleButton:Show()
	end
	self.MainFrame:SetShown(self.db.show)
	self.MainFrame:Size(self.db.width, self.db.height)

	F.TaskManager:AfterLogin(function()
		if #self.states.results == 0 and self.db.scan.automation.enable and self.db.scan.automation.onLogin then
			self:ScanAchievements()
		else
			self:UpdateView()
		end
	end)

	self.initialized = true
end

AT.ProfileUpdate = AT.Initialize

W:RegisterModule(AT:GetName())
