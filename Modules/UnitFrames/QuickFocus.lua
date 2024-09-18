local W, F, E, L = unpack((select(2, ...)))
local UF = E:GetModule("UnitFrames")
local QF = W:NewModule("QuickFocus", "AceHook-3.0", "AceEvent-3.0")

local _G = _G
local format = format
local next = next
local pairs = pairs
local strmatch = strmatch
local strsub = strsub

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local SetOverrideBindingClick = SetOverrideBindingClick

local pending = {}

function QF:SetupFrame(frame)
	if not frame or frame.windQuickFocus then
		return
	end

	if frame:GetName() and strmatch(frame:GetName(), "oUF_NPs") then
		return
	end

	if not InCombatLockdown() then
		frame:SetAttribute(self.db.modifier .. "-type" .. strsub(self.db.button, 7, 7), "focus")
		frame.windQuickFocus = true
		pending[frame] = nil
	else
		pending[frame] = true
	end
end

function QF:PLAYER_REGEN_ENABLED()
	if next(pending) then
		for frame in next, pending do
			self:SetupFrame(frame)
		end
	end
end

function QF:GROUP_ROSTER_UPDATE()
	if not UF or not UF.units then
		return
	end

	for unit in pairs(UF.units) do
		local frame = UF[unit]
		if frame and not frame.windQuickFocus then
			self:SetupFrame(frame)
		end
	end

	for unit in pairs(UF.groupunits) do
		local frame = UF[unit]
		if frame and not frame.windQuickFocus then
			self:SetupFrame(frame)
		end
	end

	for _, header in pairs(UF.headers) do
		if header.GetChildren and header:GetNumChildren() > 0 then
			for _, child in pairs({ header:GetChildren() }) do
				if child.groupName and child.GetChildren and child:GetNumChildren() > 0 then
					for _, subChild in pairs({ child:GetChildren() }) do
						if subChild and not subChild.windQuickFocus then
							self:SetupFrame(subChild)
						end
					end
				end
			end
		end
	end
end

QF._GROUP_ROSTER_UPDATE = QF.GROUP_ROSTER_UPDATE
QF.GROUP_ROSTER_UPDATE = F.DelvesEventFix(QF.GROUP_ROSTER_UPDATE)

function QF:WaitUnitframesLoad(triedTimes)
	triedTimes = triedTimes or 0

	if triedTimes > 10 then
		self:Log("debug", "Failed to load unitframes after 10 times, please try again later.")
		return
	end

	if not UF.unitstoload and not UF.unitgroupstoload and not UF.headerstoload then
		self:_GROUP_ROSTER_UPDATE()
	else
		E:Delay(0.5, self.WaitUnitframesLoad, self, triedTimes + 1)
	end
end

function QF:Initialize()
	self.db = E.private.WT.unitFrames.quickFocus
	if not self.db or not self.db.enable then
		return
	end

	local button = CreateFrame("Button", "WTQuickFocusButton", E.UIParent, "SecureActionButtonTemplate")
	button:SetAttribute("type1", "macro")
	button:SetAttribute("macrotext", "/focus mouseover")
	button:RegisterForClicks(W.UseKeyDown and "AnyDown" or "AnyUp")
	SetOverrideBindingClick(button, true, self.db.modifier .. "-" .. self.db.button, "WTQuickFocusButton")

	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:WaitUnitframesLoad()
end

W:RegisterModule(QF:GetName())
