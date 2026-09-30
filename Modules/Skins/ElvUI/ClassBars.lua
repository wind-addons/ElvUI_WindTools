local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local UF = E:GetModule("UnitFrames")

function S:ElvUI_UnitFrames_SkinClassBar(_, frame)
	if not frame then
		return
	end

	local classBar = frame.ClassBar and frame[frame.ClassBar]
	if classBar then
		self:CreateBackdropShadow(classBar)
	end

	local additionalPowerBar = frame.AdditionalPower
	if additionalPowerBar then
		self:CreateBackdropShadow(additionalPowerBar)
	end
end

function S:ElvUI_ClassBars()
	if not E.private.unitframe.enable then
		return
	end

	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.classBars) then
		return
	end

	if not self:IsHooked(UF, "Configure_ClassBar") then
		self:SecureHook(UF, "Configure_ClassBar", "ElvUI_UnitFrames_SkinClassBar")
	end
end

S:AddCallback("ElvUI_ClassBars")
