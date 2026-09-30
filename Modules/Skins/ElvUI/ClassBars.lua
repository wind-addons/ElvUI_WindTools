local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local UF = E:GetModule("UnitFrames")

local data = S:AddCallback("ElvUI_ClassBars", function()
	return E.private.unitframe.enable
			and E.private.WT.skins.elvui.enable
			and E.private.WT.skins.elvui.classBars
			and true
		or false
end)

function data:SkinClassBar(frame) -- self is the UnitFrames module, not data
	if not frame then
		return
	end

	local classBar = frame.ClassBar and frame[frame.ClassBar]
	if classBar then
		S:CreateBackdropShadow(classBar)
	end

	local additionalPowerBar = frame.AdditionalPower
	if additionalPowerBar then
		S:CreateBackdropShadow(additionalPowerBar)
	end
end

function S:ElvUI_ClassBars()
	if not self:IsHooked(UF, "Configure_ClassBar") then
		self:SecureHook(UF, "Configure_ClassBar", data.SkinClassBar)
	end
end
