local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local AC = W:NewModule("AutoCollapse", "AceHook-3.0", "AceEvent-3.0") ---@class AutoCollapse: AceModule, AceHook-3.0, AceEvent-3.0
local BL = E:GetModule("Blizzard")

local _G = _G
local ipairs = ipairs

local IsInInstance = IsInInstance
local IsResting = IsResting

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

function AC:UpdateState(event)
	if not self.db or not self.db.enable then
		self.state = "none"
		return
	end

	if event == "PLAYER_REGEN_DISABLED" and self.db.combat ~= "none" then
		self.state = self.db.combat
		return
	end

	if event == "UNIT_ENTERED_VEHICLE" and self.db.vehicle ~= "none" then
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
		self.state = self.db[key] --[[@as "none" | "collapse" | "expand"]]
		return
	end

	self.state = self.db.default
end

local function ApplyCollapseState(tracker, state)
	if state == "hide" then
		if not BL:ObjectiveTracker_IsCollapsed(tracker) then
			BL:ObjectiveTracker_Collapse(tracker)
		end
		return
	end

	if BL:ObjectiveTracker_IsCollapsed(tracker) then
		BL:ObjectiveTracker_Expand(tracker)
	end

	local isCollapsed = tracker:IsCollapsed()
	if state == "collapse" and not isCollapsed or state == "expand" and isCollapsed then
		tracker:SetCollapsed(not isCollapsed)
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

	self:UpdateState(event)

	if self.state ~= "none" then
		ApplyCollapseState(tracker, self.state)
	end
end

function AC:ObjectiveTrackerFrame_SetCollapsed(frame)
	if not self.db or not self.db.enable or self.state == "none" then
		return
	end

	local header = frame.Header
	local isUserAction = header and header.MinimizeButton and header.MinimizeButton:IsMouseOver()

	if not self.db.ignoreManualToggle and isUserAction then
		self.state = "none"
		return
	end

	ApplyCollapseState(frame, self.state)
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

	if not self.db.enable then
		self:UnregisterAllEvents()
		self.eventRegistered = false
		return
	end

	if not self.eventRegistered then
		for _, event in ipairs(events) do
			self:RegisterEvent(event, "Apply")
		end
		self.eventRegistered = true
	end

	local tracker = _G.ObjectiveTrackerFrame
	if tracker then
		if not self:IsHooked(tracker, "SetCollapsed") then
			self:SecureHook(tracker, "SetCollapsed", "ObjectiveTrackerFrame_SetCollapsed")
		end
	end

	self:Apply()
end

AC.Initialize = AC.ProfileUpdate

W:RegisterModule(AC:GetName())
