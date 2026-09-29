local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("ElvUI_Nameplates")
data.check = function()
	return E.private.nameplates.enable and E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.nameplates
end
local NP = E:GetModule("NamePlates")

function S:NP_StylePlate(_, plate)
	self:CreateBackdropShadow(plate.Health)
	self:CreateBackdropShadow(plate.Power)
	self:CreateBackdropShadow(plate.ClassPower)
	self:CreateBackdropShadow(plate.Portrait)
	self:CreateBackdropShadow(plate.Castbar)
	self:CreateShadow(plate.Castbar.Button)
end

function S:ElvUI_Nameplates()
	self:SecureHook(NP, "StylePlate", "NP_StylePlate")
end

