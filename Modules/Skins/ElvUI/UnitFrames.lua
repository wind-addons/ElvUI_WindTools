local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local UF = E:GetModule("UnitFrames")

local next = next
local pairs = pairs

function S:ElvUI_UnitFrames_UpdateNameSettings(_, f)
	if not E.private.WT.skins.enable or not E.private.WT.skins.shadow then
		return
	end

	if not f or not f.Health or not f.Health.backdrop or not f.TargetGlow then
		return
	end

	if not f.Health.backdrop.shadow then
		self:CreateBackdropShadow(f.Health, true)
		if f.Health.backdrop.shadow then
			f.Health.backdrop.shadow:ClearAllPoints()
			f.Health.backdrop.shadow:SetAllPoints(f.TargetGlow)
		end
	end
end

function S:ElvUI_UnitFrames_Configure_Threat(_, f)
	if
		not E.private.WT.skins.enable
		or not E.private.WT.skins.elvui.enable
		or not E.private.WT.skins.elvui.unitFrames
	then
		return
	end

	if not f then
		return
	end

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
	if
		not E.private.WT.skins.enable
		or not E.private.WT.skins.elvui.enable
		or not E.private.WT.skins.elvui.unitFrames
	then
		return
	end

	if not f or not f.USE_POWERBAR or not f.Power or not f.Power.backdrop then
		return
	end

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

local function ApplyExistingUnitFrameSkins(frame)
	if not frame then
		return
	end

	S:ElvUI_UnitFrames_UpdateNameSettings(nil, frame)
	S:ElvUI_UnitFrames_Configure_Power(nil, frame)
	S:ElvUI_UnitFrames_Configure_Threat(nil, frame)

	if E.private.WT.skins.elvui.castBars and S.ElvUI_UnitFrames_SkinCastBar then
		S:ElvUI_UnitFrames_SkinCastBar(nil, frame)
	end

	if E.private.WT.skins.elvui.classBars and S.ElvUI_UnitFrames_SkinClassBar then
		S:ElvUI_UnitFrames_SkinClassBar(nil, frame)
	end
end

function S:ElvUI_UnitFrames_ApplyExistingFrames()
	for _, frame in pairs(UF.units) do
		ApplyExistingUnitFrameSkins(frame)
	end

	for unit in pairs(UF.groupunits) do
		ApplyExistingUnitFrameSkins(UF[unit])
	end

	for groupName in pairs(UF.headers) do
		local group = UF[groupName]
		if group and group.GetNumChildren then
			for _, child in next, { group:GetChildren() } do
				if child.Health then
					ApplyExistingUnitFrameSkins(child)
				elseif child.GetChildren then
					for _, nested in next, { child:GetChildren() } do
						if nested.Health then
							ApplyExistingUnitFrameSkins(nested)
						end
					end
				end
			end
		end
	end
end

function S:ElvUI_UnitFrames_Hook()
	if not self:IsHooked(UF, "UpdateNameSettings") then
		self:SecureHook(UF, "UpdateNameSettings", "ElvUI_UnitFrames_UpdateNameSettings")
	end

	if not self:IsHooked(UF, "Configure_Threat") then
		self:SecureHook(UF, "Configure_Threat", "ElvUI_UnitFrames_Configure_Threat")
	end

	if not self:IsHooked(UF, "Configure_Power") then
		self:SecureHook(UF, "Configure_Power", "ElvUI_UnitFrames_Configure_Power")
	end
end

function S:ElvUI_UnitFrames()
	if not E.private.unitframe.enable then
		return
	end
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.unitFrames) then
		return
	end

	self:ElvUI_UnitFrames_Hook()
	self:ElvUI_UnitFrames_ApplyExistingFrames()
end

S:AddCallback("ElvUI_UnitFrames")
