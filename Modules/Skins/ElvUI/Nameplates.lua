local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local NP = E:GetModule("NamePlates")

function S:NP_StylePlate(_, plate)
	self:CreateBackdropShadow(plate.Health)
	self:CreateBackdropShadow(plate.Power)
	self:CreateBackdropShadow(plate.ClassPower)
	self:CreateBackdropShadow(plate.Portrait)
	self:CreateBackdropShadow(plate.Castbar)
	self:CreateShadow(plate.Castbar.Button)
end

function S:NP_Construct_AuraIcon(_, button)
	if button.__windSkin then
		return
	end

	self:CreateLowerShadow(button)
	self:BindShadowColorWithBorder(button)
	button.__windSkin = true
end

function S:ElvUI_UnitFrames()
	if not E.private.nameplates.enable then
		return
	end

	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.nameplates) then
		return
	end

	self:SecureHook(NP, "StylePlate", "NP_StylePlate")
	self:SecureHook(NP, "Construct_AuraIcon", "NP_Construct_AuraIcon")
end

S:AddCallback("ElvUI_UnitFrames")
