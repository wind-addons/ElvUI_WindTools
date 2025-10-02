local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local A = W:GetModule("AchievementTracker") ---@class AchievementTracker
local async = W.Utilities.Async

local _G = _G
local C_Timer_After = C_Timer.After
local ipairs = ipairs
local select = select
local unpack = unpack
local tinsert = tinsert
local sort = sort
local format = format
local InCombatLockdown = InCombatLockdown

local GetAchievementInfo = GetAchievementInfo
local GetAchievementNumCriteria = GetAchievementNumCriteria
local GetAchievementCriteriaInfo = GetAchievementCriteriaInfo
local GetCategoryList = GetCategoryList
local GetCategoryNumAchievements = GetCategoryNumAchievements
local GetCategoryInfo = GetCategoryInfo
local C_AchievementInfo_IsValidAchievement = C_AchievementInfo.IsValidAchievement
local C_AchievementInfo_GetRewardItemID = C_AchievementInfo.GetRewardItemID
local C_AchievementInfo_IsGuildAchievement = C_AchievementInfo.IsGuildAchievement

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

---@alias ScanCallback fun(results: AchievementData[])
---@alias ProgressCallback fun(categoryIndex: number, achievementIndex: number, progress: number, scanned: number, total: number)
---@alias ApplyFiltersCallback fun()

---@param callback ScanCallback
---@param updateProgress ProgressCallback|nil
---@param applyFiltersFunc ApplyFiltersCallback|nil
---@return nil
local function ScanAchievements(callback, updateProgress, applyFiltersFunc)
	if A.States.isScanning then
		return
	end

	A.States.isScanning = true
	A.States.results = {}

	local categories = GetCategoryList()
	local currentCategory = 1
	local currentAchievement = 1
	local totalAchievements = 0
	local scannedAchievements = 0

	for _, categoryID in ipairs(categories) do
		totalAchievements = totalAchievements + GetCategoryNumAchievements(categoryID)
	end

	local function scanStep()
		if A:StopScanDueToCombat() then
			return
		end

		local scanned = 0

		while currentCategory <= #categories and scanned < A.Config.BATCH_SIZE do
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
							if details.percent >= A.States.currentThreshold then
								local categoryName = GetCategoryInfo(categoryID)
								local rewardItemID = C_AchievementInfo_GetRewardItemID(achievementID)

								tinsert(A.States.results, {
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
			if applyFiltersFunc then
				applyFiltersFunc()
			end
			A.States.isScanning = false
			callback(A.States.filteredResults)
		else
			if A:StopScanDueToCombat() then
				return
			end
			C_Timer_After(A.Config.SCAN_DELAY, scanStep)
		end
	end

	scanStep()
end

---Apply filters and sorting to results
---@return nil
function A:ApplyFiltersAndSort()
	-- Start with all results
	local filtered = {}

	for _, achievement in ipairs(A.States.results) do
		local includeAchievement = true

		-- Apply search filter
		if A.States.searchTerm and A.States.searchTerm ~= "" then
			local searchLower = A.States.searchTerm:lower()
			local nameLower = achievement.name:lower()
			local descLower = (achievement.description or ""):lower()
			if not (nameLower:find(searchLower, 1, true) or descLower:find(searchLower, 1, true)) then
				includeAchievement = false
			end
		end

		-- Apply category filter
		if includeAchievement and A.States.selectedCategory then
			if achievement.categoryName ~= A.States.selectedCategory then
				includeAchievement = false
			end
		end

		-- Apply rewards filter
		if includeAchievement and A.States.showOnlyRewards then
			if not achievement.rewardItemID then
				includeAchievement = false
			end
		end

		if includeAchievement then
			tinsert(filtered, achievement)
		end
	end

	A.States.filteredResults = filtered

	sort(A.States.filteredResults, function(a, b)
		local aVal, bVal

		if A.States.sortBy == "percent" then
			aVal, bVal = a.percent, b.percent
		elseif A.States.sortBy == "name" then
			aVal, bVal = a.name:lower(), b.name:lower()
		elseif A.States.sortBy == "category" then
			aVal, bVal = a.categoryName:lower(), b.categoryName:lower()
		end

		if A.States.sortOrder == "desc" then
			return aVal > bVal
		else
			return aVal < bVal
		end
	end)

	local panel = _G.WTAchievementTracker --[[@as WTAchievementTracker]]
	if panel and panel.UpdateDropdowns then
		panel:UpdateDropdowns()
	end
end

---Start the achievement scan
---@return nil
function A:StartAchievementScan()
	if not self.MainFrame or not self.MainFrame:IsShown() then
		return
	end

	if InCombatLockdown() then
		return
	end

	local ProgressFrame = self.MainFrame.ProgressFrame
	ProgressFrame:Show()
	ProgressFrame.Bar:SetValue(0)
	ProgressFrame.Bar.Text:SetText(L["Starting scan..."])
	ProgressFrame.Bar.Text:SetTextColor(0.7, 0.7, 0.7)

	ScanAchievements(function(results)
		ProgressFrame:Hide()
		A:UpdateAchievementList()
	end, function(categoryIndex, achievementIndex, progress, scanned, total)
		ProgressFrame.Bar:SetValue(progress)
		ProgressFrame.Bar.Text:SetText(format(L["Scanning... %d/%d (%.0f%%)"], scanned, total, progress))
		ProgressFrame.Bar.Text:SetTextColor(0.7, 0.7, 0.7)
	end, function()
		A:ApplyFiltersAndSort()
	end)
end

---Get unique categories from current results
---@return table<string>
function A:GetUniqueCategories()
	local categories = {}
	local seen = {}

	for _, achievement in ipairs(A.States.results) do
		if achievement.categoryName and not seen[achievement.categoryName] then
			tinsert(categories, achievement.categoryName)
			seen[achievement.categoryName] = true
		end
	end

	sort(categories)
	return categories
end
