local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local A = W:NewModule("Absorb", "AceHook-3.0") ---@class Absorb: AceModule, AceHook-3.0, AceEvent-3.0
local LSM = E.Libs.LSM
local UF = E.UnitFrames

local pairs = pairs
local rad = rad

function A:SetTexture_HealComm(module, obj, texture)
	if not self.db or not self.db.enable then
		return self.hooks[module].SetTexture_HealComm(module, obj, texture)
	end

	if self.db.texture and self.db.texture.enable then
		if self.db.texture.blizzardStyle then
			texture = "Interface/RaidFrame/Shield-Fill"
		elseif self.db.texture.custom then
			texture = LSM:Fetch("statusbar", self.db.texture.custom)
		end
	end

	for _, barKey in pairs({
		"healingPlayer",
		"healingOther",
		"damageAbsorb",
		"healAbsorb",
	}) do
		local bar = obj[barKey]

		bar:SetStatusBarTexture(texture)

		-- Overlay
		if self.db.blizzardAbsorbOverlay then
			if not bar.__shieldOverlay then
				local overlay = bar:CreateTexture(nil, "ARTWORK", nil, 1)
				overlay:SetAllPoints(bar:GetStatusBarTexture())
				overlay:SetTexture("Interface/RaidFrame/Shield-Overlay", true, true)
				overlay:SetHorizTile(true)
				overlay:SetVertTile(true)
				bar.__shieldOverlay = overlay
			end
		elseif bar.__shieldOverlay then
			bar.__shieldOverlay:Hide()
		end
	end

	-- Glow
	if self.db.blizzardOverAbsorbGlow and obj.health then
		if not obj.__shieldGlow then
			local glow = obj.health:CreateTexture(nil, "OVERLAY")
			glow:SetTexture("Interface/RaidFrame/Shield-Overshield")
			glow:SetBlendMode("ADD")
			glow:SetWidth(16)
			obj.__shieldGlow = glow
			obj.overDamageAbsorbIndicator = obj.__shieldGlow -- Let oUF change the alpha
		end

		local isHorizontal = obj.health:GetOrientation() == "HORIZONTAL"
		local isReverse = obj.health:GetReverseFill()

		obj.__shieldGlow:ClearAllPoints()

		if isHorizontal then
			local offset = isReverse and -3 or 3
			local anchor = isReverse and "LEFT" or "RIGHT"
			obj.__shieldGlow:Point("TOP", obj.health, "TOP" .. anchor, offset, 2)
			obj.__shieldGlow:Point("BOTTOM", obj.health, "BOTTOM" .. anchor, offset, -2)
			obj.__shieldGlow:SetRotation(rad(isReverse and 180 or 0))
		else
			local offset = isReverse and 2 or -2
			local anchor = isReverse and "BOTTOM" or "TOP"
			local healthBarWidth = obj.health:GetWidth()
			local halfWidth = healthBarWidth / 2

			obj.__shieldGlow:Point("TOP", obj.health, anchor, 0, halfWidth + 2 + offset)
			obj.__shieldGlow:Point("BOTTOM", obj.health, anchor, 0, offset - 1 - halfWidth)
			obj.__shieldGlow:SetRotation(rad(isReverse and 90 or 270))
		end

		obj.__shieldGlow:Show()
	elseif obj.__shieldGlow then
		obj.__shieldGlow:Hide()
	end
end

function A:Initialize()
	self.db = E.db.WT.unitFrames.absorb

	if not self.db or not self.db.enable or self.initialized then
		return
	end

	self:RawHook(UF, "SetTexture_HealComm")

	self.initialized = true
end

function A:ProfileUpdate()
	self:Initialize()
	UF:Update_AllFrames()
end

W:RegisterModule(A:GetName())
