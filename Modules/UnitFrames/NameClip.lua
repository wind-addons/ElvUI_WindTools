local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local NC = W:NewModule("NameClip", "AceHook-3.0") ---@class NameClip: AceModule, AceHook-3.0
local UF = E.UnitFrames

local ipairs = ipairs
local pairs = pairs
local strfind = strfind
local wipe = wipe

local dbToUnitKey = {}

local function BuildDBMap()
	wipe(dbToUnitKey)
	if not E.db.unitframe or not E.db.unitframe.units then
		return
	end

	for unitKey, unitDB in pairs(E.db.unitframe.units) do
		dbToUnitKey[unitDB] = unitKey
	end
end

local function GetTargetFontString(frame, target)
	if not target or target == "__Name__" then
		return frame.Name
	end

	return frame.customTexts and frame.customTexts[target]
end

local function ResetFrame(frame)
	if frame.Name then
		frame.Name:Width(0)
	end
	if frame.customTexts then
		for _, fs in pairs(frame.customTexts) do
			fs:Width(0)
		end
	end
end

local function ApplyClip(frame)
	if not frame then
		return
	end

	local unitKey = frame.db and dbToUnitKey[frame.db]
	if not unitKey then
		return
	end

	ResetFrame(frame)

	local unitDB = NC.db[unitKey]
	if not unitDB or not unitDB.enable then
		return
	end

	local fs = GetTargetFontString(frame, unitDB.target)
	if not fs then
		return
	end

	if unitDB.target == "__Name__" and frame.db and frame.db.name then
		local position = frame.db.name.position or "CENTER"
		if strfind(position, "RIGHT") then
			fs:SetJustifyH("RIGHT")
		elseif strfind(position, "LEFT") then
			fs:SetJustifyH("LEFT")
		else
			fs:SetJustifyH("CENTER")
		end
	end

	fs:Width(unitDB.width)
	fs:SetWordWrap(false)
end

local function ResetAll()
	if not E.oUF or not E.oUF.objects then
		return
	end

	for _, frame in ipairs(E.oUF.objects) do
		ResetFrame(frame)
	end
end

function NC:Initialize()
	self.db = E.db.WT.unitFrames.nameClip

	if not self.db or not self.db.enable or self.initialized then
		return
	end

	BuildDBMap()

	self:SecureHook(UF, "UpdateNameSettings", function(_, frame)
		ApplyClip(frame)
	end)
	self:SecureHook(UF, "PostNamePosition", function(_, frame)
		ApplyClip(frame)
	end)
	self:SecureHook(UF, "Configure_CustomTexts", function(_, frame)
		ApplyClip(frame)
	end)

	self.initialized = true
	UF:Update_AllFrames()
end

function NC:ProfileUpdate()
	self.db = E.db.WT.unitFrames.nameClip

	if self.db and self.db.enable then
		if not self.initialized then
			self:Initialize()
		else
			BuildDBMap()
			F.Throttle(0.5, "NameClipUpdate", UF.Update_AllFrames, UF)
		end
	else
		if self.initialized then
			self:UnhookAll()
			self.initialized = false
			ResetAll()
			UF:Update_AllFrames()
		end
	end
end

W:RegisterModule(NC:GetName())
