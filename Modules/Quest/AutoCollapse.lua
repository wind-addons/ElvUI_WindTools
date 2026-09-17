local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local AC = W:NewModule("AutoCollapse", "AceEvent-3.0") ---@class AutoCollapse: AceModule, AceEvent-3.0
local BL = E:GetModule("Blizzard")

local _G = _G
local ipairs = ipairs

local hooksecurefunc = hooksecurefunc
local IsInInstance = IsInInstance
local IsResting = IsResting
local UnitAffectingCombat = UnitAffectingCombat
local UnitInVehicle = UnitInVehicle

local instanceTypeKeyMap = {
	none = "outOfInstance",
	pvp = "battleground",
	arena = "arena",
	party = "dungeon",
	raid = "raid",
	scenario = "scenario",
	neighborhood = "neighborhood",
	interior = "interior",
}

local visualCollapsed = false

---Re-evaluate from current conditions (priority 1 > 2 > 3 > 4).
function AC:UpdateState()
	if not self.db or not self.db.enable then
		self.state = "none"
		return
	end

	if UnitAffectingCombat("player") and self.db.combat ~= "none" then
		self.state = self.db.combat
		return
	end

	if UnitInVehicle("player") and self.db.vehicle ~= "none" then
		self.state = self.db.vehicle
		return
	end

	if IsResting() and self.db.resting ~= "none" then
		self.state = self.db.resting
		return
	end

	local _, instanceType = IsInInstance()
	local key = instanceTypeKeyMap[instanceType]
	if key and self.db[key] and self.db[key] ~= "none" then
		self.state = self.db[key] --[[@as "none" | "collapse" | "expand" | "hide"]]
		return
	end

	self.state = self.db.default
end

---@param tracker Frame
local function ApplyVisualCollapse(tracker)
	if not visualCollapsed then
		return
	end

	local modules = tracker.modules
	if modules then
		for index = 1, #modules do
			modules[index]:Hide()
		end
	end

	local header = tracker.Header
	if header then
		header:SetCollapsed(true)
	end

	local nineSlice = tracker.NineSlice
	if nineSlice and header then
		nineSlice:SetPoint("BOTTOM", header, "BOTTOM", 0, -(tracker.bottomModulePadding or 10))
		nineSlice:Show()
	end

	tracker:Show()
end

---@param tracker Frame
local function ClearVisualCollapse(tracker)
	visualCollapsed = false

	local modules = tracker.modules
	local lastModule ---@type Frame?
	if modules then
		for index = 1, #modules do
			local module = modules[index]
			if module.GetContentsHeight and module:GetContentsHeight() > 0 then
				module:Show()
				lastModule = module
			end
		end
	end

	local header = tracker.Header
	if header then
		header:SetCollapsed(false)
	end

	local nineSlice = tracker.NineSlice
	if nineSlice and lastModule then
		nineSlice:SetPoint("BOTTOM", lastModule, "BOTTOM", 0, -(tracker.bottomModulePadding or 10))
		nineSlice:Show()
	end
end

---@param tracker Frame
---@param state "none" | "collapse" | "expand" | "hide"
local function ApplyCollapseState(tracker, state)
	if state == "hide" then
		visualCollapsed = false
		if not BL:ObjectiveTracker_IsCollapsed(tracker) then
			BL:ObjectiveTracker_Collapse(tracker)
		end
		return
	end

	if BL:ObjectiveTracker_IsCollapsed(tracker) then
		BL:ObjectiveTracker_Expand(tracker)
	end

	if state == "collapse" then
		visualCollapsed = true
		ApplyVisualCollapse(tracker)
		return
	end

	if state == "expand" then
		ClearVisualCollapse(tracker)
	end
end

function AC:Apply(event, arg1)
	if
		(event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE")
		and (E:IsSecretValue(arg1) or arg1 ~= "player")
	then
		return
	end

	local tracker = _G.ObjectiveTrackerFrame
	if not tracker then
		return
	end

	self:UpdateState()

	if self.state ~= "none" then
		ApplyCollapseState(tracker, self.state)
	end
end

local events = {
	"PLAYER_ENTERING_WORLD",
	"PLAYER_REGEN_DISABLED",
	"PLAYER_REGEN_ENABLED",
	"UNIT_ENTERED_VEHICLE",
	"UNIT_EXITED_VEHICLE",
	"ZONE_CHANGED_NEW_AREA",
}

function AC:ProfileUpdate()
	self.db = E.db.WT.quest.autoCollapse

	local tracker = _G.ObjectiveTrackerFrame
	if tracker and not self.updateHooked then
		hooksecurefunc(tracker, "Update", ApplyVisualCollapse)
		self.updateHooked = true
	end

	if not self.db.enable then
		self:UnregisterAllEvents()
		self.eventRegistered = false
		if tracker and visualCollapsed then
			ClearVisualCollapse(tracker)
		end
		return
	end

	if not self.eventRegistered then
		for _, event in ipairs(events) do
			self:RegisterEvent(event, "Apply")
		end
		self.eventRegistered = true
	end

	self:Apply()
end

AC.Initialize = AC.ProfileUpdate

W:RegisterModule(AC:GetName())
