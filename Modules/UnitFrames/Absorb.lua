local W, F, E, L = unpack((select(2, ...)))
local A = W:NewModule("Absorb", "AceHook-3.0", "AceEvent-3.0")
local LSM = E.Libs.LSM
local UF = E.UnitFrames

local _G = _G
local pairs = pairs
local rad = rad

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local UnitIsConnected = UnitIsConnected

local framePool = {}

function A:ConstructTextures(frame)
	if not frame or not frame.HealthPrediction then
		return
	end

	if not frame.windAbsorb then
		local absorbFrame = CreateFrame("Frame", nil, frame)
		absorbFrame:SetFrameStrata(frame.HealthPrediction.absorbBar:GetFrameStrata())
		absorbFrame:SetFrameLevel(frame.HealthPrediction.absorbBar:GetFrameLevel() + 1)
		frame.windAbsorb = absorbFrame
	end

	local absorb = frame.windAbsorb

	if not absorb.overlay then
		local overlay = absorb:CreateTexture(nil, "OVERLAY", nil, 6)
		overlay:SetTexture("Interface/RaidFrame/Shield-Overlay", true, true)
		absorb.overlay = overlay
	end

	if not absorb.glow then
		local glow = absorb:CreateTexture(nil, "OVERLAY", nil, 7)
		glow:SetTexture("Interface/RaidFrame/Shield-Overshield")
		glow:SetBlendMode("ADD")
		glow:SetWidth(16)
		absorb.glow = glow
	end
end

function A:ConfigureTextures(_, frame)
	if not (frame and frame.db and frame.db.healPrediction and frame.db.healPrediction.enable and frame.windAbsorb) then
		return
	end

	local pred = frame.HealthPrediction
	local overlay = frame.windAbsorb.overlay
	local glow = frame.windAbsorb.glow

	if not frame.db.health or not frame.Health or not self.db.enable then
		overlay:Hide()
		glow:Hide()
	else
		local isHorizontal = frame.Health:GetOrientation() == "HORIZONTAL"
		local isReverse = frame.Health:GetReverseFill()

		if self.db.blizzardAbsorbOverlay then
			overlay:ClearAllPoints()
			if isHorizontal then
				local anchor = isReverse and "RIGHT" or "LEFT"
				overlay.SetOverlaySize = function(self, percent)
					self:SetWidth(frame.Health:GetWidth() * percent)
					self:SetTexCoord(0, overlay:GetWidth() / 32, 0, overlay:GetHeight() / 32)
				end
				overlay:SetPoint("TOP" .. anchor, pred.absorbBar, "TOP" .. anchor)
				overlay:SetPoint("BOTTOM" .. anchor, pred.absorbBar, "BOTTOM" .. anchor)
			else
				local anchor = isReverse and "TOP" or "BOTTOM"

				overlay.SetOverlaySize = function(self, percent)
					self:SetHeight(frame.Health:GetHeight() * percent)
					self:SetTexCoord(0, overlay:GetWidth() / 32, 0, overlay:GetHeight() / 32)
				end

				overlay:SetPoint(anchor .. "LEFT", pred.absorbBar, anchor .. "LEFT")
				overlay:SetPoint(anchor .. "RIGHT", pred.absorbBar, anchor .. "RIGHT")
			end
			overlay:Show()
		else
			overlay:Hide()
		end

		if self.db.blizzardOverAbsorbGlow then
			glow:ClearAllPoints()
			if isHorizontal then
				local offset = isReverse and -3 or 3
				local anchor = isReverse and "LEFT" or "RIGHT"
				glow:SetPoint("TOP", frame.Health, "TOP" .. anchor, offset, 2)
				glow:SetPoint("BOTTOM", frame.Health, "BOTTOM" .. anchor, offset, -2)
				glow:SetRotation(rad(isReverse and 180 or 0))
			else
				local offset = isReverse and 2 or -2
				local anchor = isReverse and "BOTTOM" or "TOP"
				local healthBarWidth = frame.Health:GetWidth()
				local halfWidth = healthBarWidth / 2

				glow:SetPoint("TOP", frame.Health, anchor, 0, halfWidth + 2 + offset)
				glow:SetPoint("BOTTOM", frame.Health, anchor, 0, offset - 1 - halfWidth)
				glow:SetRotation(rad(isReverse and 90 or 270))
			end
			glow:Show()
		else
			glow:Hide()
		end
	end
end

function A:HealthPrediction_OnUpdate(object, unit, _, _, absorb, _, hasOverAbsorb, _, health, maxHealth)
	if not self.db or not self.db.enable then
		return
	end

	local frame = object.frame
	local pred = frame.HealthPrediction
	local overlay = frame.windAbsorb.overlay
	local glow = frame.windAbsorb.glow
	local frameDB = frame and frame.db and frame.db.healPrediction

	if not frameDB or not frameDB.enable or not framePool[frame] or not overlay.SetOverlaySize then
		return
	end

	frame.windSmooth:DoJob(function()
		if not self.db.blizzardAbsorbOverlay or maxHealth == health or absorb == 0 or not UnitIsConnected(unit) then
			overlay:Hide()
		else
			if maxHealth > health + absorb then
				overlay:SetOverlaySize(absorb / maxHealth)
				overlay:Show()
			else
				if frameDB.absorbStyle == "OVERFLOW" then
					if health == maxHealth and self.db.blizzardOverAbsorbGlow then
						pred.absorbBar:SetValue(0)
					end
					overlay:SetOverlaySize((maxHealth - health) / maxHealth)
					overlay:Show()
				else -- Do not show the overlay if in normal mode
					overlay:Hide()
				end
			end
		end

		if self.db.blizzardOverAbsorbGlow and hasOverAbsorb and UnitIsConnected(unit) then
			if health == maxHealth and frameDB.absorbStyle == "NORMAL" then
				pred.absorbBar:SetValue(0)
			end
			glow:Show()
		else
			glow:Hide()
		end
	end)
end

function A:SetupFrame(frame)
	if not frame or framePool[frame] or not frame.HealthPrediction then
		return
	end

	self:SmoothTweak(frame)
	self:ConstructTextures(frame)

	if frame.HealthPrediction.PostUpdate then
		self:SecureHook(frame.HealthPrediction, "PostUpdate", "HealthPrediction_OnUpdate")
	end

	framePool[frame] = true
end

function A:WaitForUnitframesLoad(triedTimes)
	triedTimes = triedTimes or 0

	if triedTimes > 10 then
		self:Log("debug", "Failed to load unitframes after 10 times, please try again later.")
		return
	end

	if not UF.unitstoload and not UF.unitgroupstoload and not UF.headerstoload then
		for unit in pairs(UF.units) do
			self:SetupFrame(UF[unit])
		end

		for unit in pairs(UF.groupunits) do
			self:SetupFrame(UF[unit])
		end

		for group, header in pairs(UF.headers) do
			if header.GetChildren and header:GetNumChildren() > 0 then
				for _, child in pairs({ header:GetChildren() }) do
					if child.groupName and child.GetChildren and child:GetNumChildren() > 0 then
						for _, subChild in pairs({ child:GetChildren() }) do
							self:SetupFrame(subChild)
						end
					end
				end
			end
		end

		-- Refresh all frames to make sure the replacing of textures
		self:SecureHook(UF, "Configure_HealComm", "ConfigureTextures")
		if InCombatLockdown() then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		else
			UF:Update_AllFrames()
		end
	else
		E:Delay(0.3, self.WaitForUnitframesLoad, self, triedTimes + 1)
	end
end

function A:PLAYER_REGEN_ENABLED()
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	UF:Update_AllFrames()
end

function A:SmoothTweak(frame)
	if frame.windSmooth then
		return
	end

	frame.windSmooth = CreateFrame("statusbar", nil, E.UIParent)

	-- If triggered by ElvUI smooth, do the job
	frame.windSmooth.SetValue = function(self)
		if self.job then
			self.job()
			self.job = nil
		end
	end

	-- Add the job to the smooth queue
	frame.windSmooth.DoJob = function(self, job)
		if UF and UF.db and UF.db.smoothbars then
			self.job = job
			self:SetValue(0)
		else
			job()
		end
	end

	-- Let ElvUI change the SetValue method
	E:SetSmoothing(frame.windSmooth, true)
end

function A:SetTexture_HealComm(module, obj, texture)
	local func = self.hooks[module].SetTexture_HealComm

	if self.db and self.db.enable and self.db.texture and self.db.texture.enable then
		if self.db.texture.blizzardStyle then
			texture = "Interface/RaidFrame/Shield-Fill"
		elseif self.db.texture.custom then
			texture = LSM:Fetch("statusbar", self.db.texture.custom)
		end
	end

	return self.hooks[module].SetTexture_HealComm(module, obj, texture)
end

function A:Initialize()
	self.db = E.db.WT.unitFrames.absorb

	if not self.db or not self.db.enable or self.initialized then
		return
	end

	self:RawHook(UF, "SetTexture_HealComm")
	self:WaitForUnitframesLoad()

	self.initialized = true
end

function A:ProfileUpdate()
	self:Initialize()

	if not self.db or not self.db.enable then
		for frame in pairs(framePool) do
			self:ConfigureTextures(frame)
		end
	end

	UF:Update_AllFrames()
end

function A:ChangeDB(callback)
	for frame in pairs(framePool) do
		local db = frame and frame.db and frame.db.healPrediction
		if db then
			callback(db)
		end
	end

	UF:Update_AllFrames()
end

W:RegisterModule(A:GetName())
