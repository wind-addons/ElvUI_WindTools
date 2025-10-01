local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local A = W:NewModule("AchievementTracker", "AceEvent-3.0") ---@class AchievementTracker : AceModule, AceEvent-3.0

local _G = _G
local UIParentLoadAddOn = UIParentLoadAddOn

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
A.Config = {
	PANEL_WIDTH = 450,
	PANEL_HEIGHT = 500,
	MIN_THRESHOLD = 50,
	MAX_THRESHOLD = 100,
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
---@field results table
---@field filteredResults table
---@field sortBy "percent"|"name"|"category"
---@field sortOrder "asc"|"desc"
---@field searchTerm string
---@field selectedCategory string|nil
---@field showOnlyRewards boolean
---@field expandedAchievements table<number, boolean>
A.scanState = {
	isScanning = false,
	scannedSinceInit = false,
	currentThreshold = A.Config.DEFAULT_THRESHOLD,
	results = {},
	filteredResults = {},
	sortBy = "percent",
	sortOrder = "desc",
	searchTerm = "",
	selectedCategory = nil,
	showOnlyRewards = false,
	expandedAchievements = {},
}

---Initialize the achievements module
---@return nil
function A:Initialize()
	if not E.initialized or not E.private or not E.private.WT or not E.private.WT.misc then
		return
	end

	if not E.private.WT.misc.achievementTracker or self.initialized then
		return
	end

	UIParentLoadAddOn("Blizzard_AchievementUI")
	self.initialized = true
end

---Handle profile updates
---@return nil
function A:ProfileUpdate()
	self.initialized = false
	self:Initialize()

	if not E.private.WT.misc.achievements then
		A:UnregisterEvent("ADDON_LOADED")
		A:UnregisterEvent("PLAYER_ENTERING_WORLD")
		A:UnregisterEvent("ACHIEVEMENT_EARNED")
		A:UnregisterEvent("CRITERIA_UPDATE")
		self.initialized = false
	end
end

---Handle ADDON_LOADED event
---@param _ any
---@param addonName string
---@return nil
function A:ADDON_LOADED(_, addonName)
	if addonName == "Blizzard_AchievementUI" then
		self:CreateAchievementTrackerPanel()
		self:HookAchievementFrame()
	end
end

---Handle PLAYER_ENTERING_WORLD event
---@return nil
function A:PLAYER_ENTERING_WORLD()
	self:HookAchievementFrame()
end

W:AddCommand("AchievementTracker", { "/wtat", "/wtachievements" }, function()
	if not _G.WTAchievementTracker then
		A:CreateAchievementTrackerPanel()
	end
	_G.WTAchievementTracker:Show()
	A:StartAchievementScan()
end)

A:RegisterEvent("ADDON_LOADED")
A:RegisterEvent("PLAYER_ENTERING_WORLD")

W:RegisterModule(A:GetName())
