local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local A = W:GetModule("Achievements") ---@class WindTools_Achievements

local _G = _G
local C_Timer_After = C_Timer.After
local ipairs = ipairs
local tremove = tremove

-- Track event registration state.
local eventsRegistered = false

---Handle ACHIEVEMENT_EARNED event
---@param achievementID number
---@param alreadyEarned boolean
---@return nil
function A:ACHIEVEMENT_EARNED(achievementID, alreadyEarned)
	if _G.WindToolsAchievementTracker and not alreadyEarned then
		local scanState = A:GetScanState()
		for i, achievement in ipairs(scanState.results) do
			if achievement.id == achievementID then
				tremove(scanState.results, i)
				A:ApplyFiltersAndSort()
				A:UpdateAchievementList()
				break
			end
		end
	end
end

---Handle CRITERIA_UPDATE event
---@return nil
function A:CRITERIA_UPDATE()
	if _G.WindToolsAchievementTracker and A:GetScanState().scannedSinceInit then
		C_Timer_After(0.5, function()
			if _G.WindToolsAchievementTracker then
				A:UpdateAchievementList()
			end
		end)
	end
end

---Register events for achievement tracking
---@return nil
local function RegisterAchievementEvents()
	if not eventsRegistered then
		A:RegisterEvent("ACHIEVEMENT_EARNED")
		A:RegisterEvent("CRITERIA_UPDATE")
		eventsRegistered = true
	end
end

---Unregister events for achievement tracking
---@return nil
local function UnregisterAchievementEvents()
	if eventsRegistered then
		A:UnregisterEvent("ACHIEVEMENT_EARNED")
		A:UnregisterEvent("CRITERIA_UPDATE")
		eventsRegistered = false
	end
end

---Hide and cleanup the tracker panel
---@return nil
local function HideTrackerPanel()
	if _G.WindToolsAchievementTracker then
		-- Don't destroy the panel, just hide it to avoid recreation overhead.
		_G.WindToolsAchievementTracker:Hide()
	end

	-- Stop any ongoing scans when hiding
	if A:GetScanState().isScanning then
		A:SetScanState("isScanning", false)
	end
end

---Hook into Achievement frame events
---@return nil
function A:HookAchievementFrame()
	if _G.AchievementFrame and not _G.AchievementFrame._windToolsHooked then
		_G.AchievementFrame._windToolsHooked = true

		_G.AchievementFrame:HookScript("OnShow", function()
			-- Register events when UI is shown
			RegisterAchievementEvents()

			C_Timer_After(0.1, function()
				A:CreateAchievementTrackerPanel()
				if _G.WindToolsAchievementTracker then
					_G.WindToolsAchievementTracker:Show()
				end

				if not A:GetScanState().scannedSinceInit then
					A:SetScanState("scannedSinceInit", true)
					C_Timer_After(0.4, function()
						A:StartAchievementScan()
					end)
				end
			end)
		end)

		_G.AchievementFrame:HookScript("OnHide", function()
			-- Unregister events and hide tracker when UI is hidden
			UnregisterAchievementEvents()
			HideTrackerPanel()
		end)
	end
end
