local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local UF = E:GetModule("UnitFrames")

function S:ElvUI_UnitFrames_UpdateNameSettings(_, f)
	if not E.private.WT.skins.enable or not E.private.WT.skins.shadow then
		return
	end

	if f.Health.backdrop and not f.Health.backdrop.shadow then
		self:CreateBackdropShadow(f.Health, true)
		f.Health.backdrop.shadow:ClearAllPoints()
		f.Health.backdrop.shadow:SetAllPoints(f.TargetGlow)
	end
end

function S:ElvUI_UnitFrames_Configure_Threat(_, f)
	local threat = f.ThreatIndicator
	if not threat then
		return
	end
	threat.PostUpdate = function(_, unit, status, r, g, b)
		UF.UpdateThreat(threat, unit, status, r, g, b)
		local parent = threat:GetParent()
		if not unit or parent.unit ~= unit then
			return
		end
		if parent.db and parent.db.threatStyle == "GLOW" then
			if parent.Health and parent.Health.backdrop and parent.Health.backdrop.shadow then
				parent.Health.backdrop.shadow:SetShown(not threat.MainGlow:IsShown())
			end
			if
				parent.Power
				and parent.Power.backdrop
				and parent.Power.backdrop.shadow
				and parent.USE_POWERBAR_OFFSET
			then
				parent.Power.backdrop.shadow:SetShown(not threat.MainGlow:IsShown())
			end
		end
	end
end

function S:ElvUI_UnitFrames_Configure_Power(_, f)
	if f.USE_POWERBAR then
		local shadow = f.Power.backdrop.shadow
		if f.POWERBAR_DETACHED or f.USE_POWERBAR_OFFSET then
			if not shadow then
				self:CreateBackdropShadow(f.Power, true)
			else
				shadow:Show()
			end
		else
			if shadow then
				shadow:Hide()
			end
		end
	end
end

function S:ElvUI_UnitFrames()
	if not E.private.unitframe.enable then
		return
	end
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.unitFrames) then
		return
	end

	-- Update shadow of unit frames with low frequency
	self:SecureHook(UF, "UpdateNameSettings", "ElvUI_UnitFrames_UpdateNameSettings")

	-- Auto hide/show shadow on oUF updating threat
	self:SecureHook(UF, "Configure_Threat", "ElvUI_UnitFrames_Configure_Threat")

	-- Separated power bar
	self:SecureHook(UF, "Configure_Power", "ElvUI_UnitFrames_Configure_Power")
end

S:AddCallback("ElvUI_UnitFrames")
