local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local UF = E:GetModule("UnitFrames")

local function reskinClassBar(_, frame)
	local classBar = frame[frame.ClassBar]
	if classBar then
		S:CreateBackdropShadow(classBar)
	end

	local additionalPowerBar = frame.AdditionalPower
	if additionalPowerBar then
		S:CreateBackdropShadow(additionalPowerBar)
	end
end

function S:ElvUI_ClassBars()
	if not E.private.unitframe.enable then
		return
	end

	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.classBars) then
		return
	end

	self:SecureHook(UF, "Configure_ClassBar", reskinClassBar)
end

S:AddCallback("ElvUI_ClassBars")
