local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local A = W:GetModule("Achievements") ---@class WindTools_Achievements

local _G = _G
local C_Timer_After = C_Timer.After
local ipairs = ipairs
local tremove = tremove

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

---Hook into Achievement frame events
---@return nil
function A:HookAchievementFrame()
	if _G.AchievementFrame and not _G.AchievementFrame._windToolsHooked then
		_G.AchievementFrame._windToolsHooked = true
		_G.AchievementFrame:HookScript("OnShow", function()
			C_Timer_After(0.1, function()
				A:CreateAchievementTrackerPanel()
				_G.WindToolsAchievementTracker:Show()
				if not A:GetScanState().scannedSinceInit then
					A:SetScanState("scannedSinceInit", true)
					C_Timer_After(0.4, function()
						A:StartAchievementScan()
					end)
				end
			end)
		end)
	end
end

A:RegisterEvent("ACHIEVEMENT_EARNED")
A:RegisterEvent("CRITERIA_UPDATE")
