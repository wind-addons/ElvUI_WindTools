local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local A = W:GetModule("AchievementTracker") ---@class AchievementTracker

local _G = _G
local C_Timer_After = C_Timer.After
local ipairs = ipairs
local tremove = tremove
local InCombatLockdown = InCombatLockdown

---Handle ACHIEVEMENT_EARNED event
---@param achievementID number
---@param alreadyEarned boolean
---@return nil
function A:ACHIEVEMENT_EARNED(achievementID, alreadyEarned)
	if self.MainFrame and not alreadyEarned then
		for i, achievement in ipairs(self.States.results) do
			if achievement.id == achievementID then
				tremove(self.States.results, i)
				self:ApplyFiltersAndSort()
				self:UpdateAchievementList()
				break
			end
		end
	end
end

---Handle CRITERIA_UPDATE event
---@return nil
function A:CRITERIA_UPDATE()
	if _G.WTAchievementTracker and self.States.scannedSinceInit then
		E:Delay(0.5, function()
			if _G.WTAchievementTracker and not InCombatLockdown() then
				self:UpdateAchievementList()
			end
		end)
	end
end

---Handle PLAYER_REGEN_ENABLED event (leaving combat)
---@return nil
function A:PLAYER_REGEN_ENABLED()
	-- Resume scan if we were scanning before combat
	if _G.WTAchievementTracker and _G.WTAchievementTracker:IsVisible() and not self.States.isScanning then
		E:Delay(1.0, function()
			if _G.WTAchievementTracker and _G.WTAchievementTracker:IsVisible() and not InCombatLockdown() then
				self:StartAchievementScan()
			end
		end)
	end
end

---Handle PLAYER_REGEN_DISABLED event (entering combat)
---@return nil
function A:PLAYER_REGEN_DISABLED()
	-- Stop any ongoing scan when entering combat
	if self.States.isScanning then
		self:StopScanDueToCombat()
	end
end

---Hook into Achievement frame events
---@return nil
function A:HookAchievementFrame()
	if not self:IsHooked(_G.AchievementFrame, "OnShow") then
		self:SecureHookScript(_G.AchievementFrame, "OnShow", function()
			self:RegisterEvent("ACHIEVEMENT_EARNED")
			self:RegisterEvent("CRITERIA_UPDATE")
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")

			self:CreateAchievementTrackerPanel()
			self.MainFrame:Show()

			if not self.States.scannedSinceInit then
				self.States.scannedSinceInit = true
				E:Delay(0.4, self.StartAchievementScan, self)
			end
		end)
	end

	if not self:IsHooked(_G.AchievementFrame, "OnHide") then
		self:SecureHookScript(_G.AchievementFrame, "OnHide", function()
			self:UnregisterEvent("ACHIEVEMENT_EARNED")
			self:UnregisterEvent("CRITERIA_UPDATE")
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
			_G.WTAchievementTracker:Hide()
			self.States.isScanning = false
		end)
	end
end
