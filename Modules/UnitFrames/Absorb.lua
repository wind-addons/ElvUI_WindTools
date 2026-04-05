local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local A = W:NewModule("Absorb", "AceHook-3.0") ---@class Absorb: AceModule, AceHook-3.0, AceEvent-3.0
local LSM = E.Libs.LSM
local UF = E.UnitFrames

local rad = rad

function A:UpdateStatusBar( obj, key, texture)
	if self.db[key] and self.db[key].enable and obj[key] then
		local tex = nil
		if self.db[key].blizzardStyle then
			tex = "Interface/RaidFrame/Shield-Fill"
		elseif self.db[key].custom then
			tex = LSM:Fetch("statusbar", self.db[key].custom)
		end

		if tex and tex ~= texture then
			obj[key]:SetStatusBarTexture(tex)
		end
	end
end

function A:SetTexture_HealComm(module, obj, texture)
	if not self.db or not self.db.enable then
		return self.hooks[module].SetTexture_HealComm(module, obj, texture)
	end

	if not obj then
		return self.hooks[module].SetTexture_HealComm(module, obj, texture)
	end

	self.hooks[module].SetTexture_HealComm(module, obj, texture)

	self:UpdateStatusBar(obj, "healAbsorb", texture)
	self:UpdateStatusBar(obj, "damageAbsorb", texture)

	-- Overlay
	if self.db.blizzardAbsorbOverlay and obj.damageAbsorb then
		if not obj.damageAbsorb.__shieldOverlay then
			local overlay = obj.damageAbsorb:CreateTexture(nil, "ARTWORK", nil, 1)
			overlay:SetAllPoints(obj.damageAbsorb:GetStatusBarTexture())
			overlay:SetTexture("Interface/RaidFrame/Shield-Overlay", true, true)
			overlay:SetHorizTile(true)
			overlay:SetVertTile(true)
			obj.damageAbsorb.__shieldOverlay = overlay
		end
	elseif obj.damageAbsorb.__shieldOverlay then
		obj.damageAbsorb.__shieldOverlay:Hide()
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
		if obj.overDamageAbsorbIndicator == obj.__shieldGlow then
			obj.overDamageAbsorbIndicator = nil
		end
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
