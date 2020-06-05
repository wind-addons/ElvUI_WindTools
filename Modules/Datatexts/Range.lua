local W, F, E, L = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")
local RC = LibStub("LibRangeCheck-2.0")
local strjoin = strjoin

local displayString = ""
local lastPanel
local int = 1
local curMin, curMax
local updateTargetRange = false
local forceUpdate = false

local function OnUpdate(self, t)
	if not updateTargetRange then
		return
	end

	int = int - t
	if int > 0 then
		return
	end

	int = 0.25

	local min, max = RC:GetRange("target")
	if not forceUpdate and (min == curMin and max == curMax) then
		return
	end

	curMin = min
	curMax = max
	if min and max then
		self.text:SetFormattedText(displayString, L["Distance"], min, max)
	else
		self.text:SetText("")
	end

	forceUpdate = false
	lastPanel = self
end

local function OnEvent(self, event)
	updateTargetRange = UnitName("target") ~= nil
	int = 0
	if updateTargetRange then
		forceUpdate = true
	else
		self.text:SetText("")
	end
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = strjoin("", "%s: ", hex, "%d|r - ", hex, "%d|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("Target Range", nil, {"PLAYER_TARGET_CHANGED"}, OnEvent, OnUpdate, nil, nil, nil, L["Target Range"])
