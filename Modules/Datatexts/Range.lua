local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local DT = E:GetModule("DataTexts")
local RangeCheck = E.Libs.RangeCheck

local strjoin = strjoin

local UnitName = UnitName
local UnitIsConnected = UnitIsConnected
local UnitIsUnit = UnitIsUnit

local displayString = ""
local int = 1
local curMinRange, curMaxRange
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

	if UnitIsConnected("target") and not UnitIsUnit("target", "player") then
		local minRange, maxRange = RangeCheck:GetRange("target")
		if not forceUpdate and (minRange == curMinRange and maxRange == curMaxRange) then
			return
		end
		curMinRange = minRange
		curMaxRange = maxRange
	else
		curMinRange = nil
		curMaxRange = nil
	end

	if curMinRange and curMaxRange then
		self.text:SetFormattedText(displayString, L["Distance"], curMinRange, curMaxRange)
	else
		self.text:SetText("")
	end

	forceUpdate = false
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

local function ValueColorUpdate(self, hex)
	displayString = strjoin("", "%s: ", hex, "%d|r - ", hex, "%d|r")

	OnEvent(self)
end

DT:RegisterDatatext(
	"Target Range",
	nil,
	{ "PLAYER_TARGET_CHANGED" },
	OnEvent,
	OnUpdate,
	nil,
	nil,
	nil,
	L["Target Range"],
	nil,
	ValueColorUpdate
)
