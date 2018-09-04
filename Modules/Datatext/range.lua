local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DT = E:GetModule('DataTexts')

-- LibMapData-1.0 for zone sizes
local rc = LibStub("LibRangeCheck-2.0")
local displayString = ''
local lastPanel
local int = 1
local curMin, curMax
local updateTargetRange = false
local forceUpdate = false

local function OnUpdate(self, t)
	if not updateTargetRange then return end

	int = int - t
	if int > 0 then return end
	int = .25

	local min, max = rc:GetRange('target')
	if not forceUpdate and (min == curMin and max == curMax) then return end

	curMin = min
	curMax = max
	
	if min and max then
		self.text:SetFormattedText(displayString, L['Distance'], min, max)
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
	displayString = string.join("", "%s: ", hex, "%d|r - ", hex, "%d|r")
	
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

--[[
	DT:RegisterDatatext(name, events, eventFunc, updateFunc, clickFunc, onEnterFunc)
	
	name - name of the datatext (required)
	events - must be a table with string values of event names to register 
	eventFunc - function that gets fired when an event gets triggered
	updateFunc - onUpdate script target function
	click - function to fire when clicking the datatext
	onEnterFunc - function to fire OnEnter
]]
DT:RegisterDatatext(L['Target Range'], {"PLAYER_TARGET_CHANGED"}, OnEvent, OnUpdate)
