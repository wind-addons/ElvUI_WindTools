local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local AC = W:NewModule("AutoCollapse", "AceHook-3.0", "AceEvent-3.0") ---@class AutoCollapse: AceModule, AceHook-3.0, AceEvent-3.0
local BL = E:GetModule("Blizzard")

local _G = _G

local IsInInstance = IsInInstance

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

function AC:Apply(event)
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

	ApplyCollapseState(frame, self.state)
end

function AC:PLAYER_ENTERING_WORLD()
	E:Delay(0.5, self.Apply, self)
end

function AC:ProfileUpdate()
	self.db = E.db.WT.quest.autoCollapse

	if self.db.enable then
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("PLAYER_REGEN_DISABLED", "Apply")
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "Apply")
		self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "Apply")

		if _G.ObjectiveTrackerFrame and not self:IsHooked(_G.ObjectiveTrackerFrame, "SetCollapsed") then
			self:SecureHook(_G.ObjectiveTrackerFrame, "SetCollapsed", "ObjectiveTrackerFrame_SetCollapsed")
		end

		self:Apply()
	else
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	end
end

AC.Initialize = AC.ProfileUpdate

W:RegisterModule(AC:GetName())
