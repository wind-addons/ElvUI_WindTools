local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local NP = E:GetModule("NamePlates")

local data = S:AddCallback("ElvUI_Nameplates", function()
	return E.private.nameplates.enable
			and E.private.WT.skins.elvui.enable
			and E.private.WT.skins.elvui.nameplates
			and true
		or false
end)

function data:StylePlate(plate) -- self is the NamePlates module, not data
	S:CreateBackdropShadow(plate.Health)
	S:CreateBackdropShadow(plate.Power)
	S:CreateBackdropShadow(plate.ClassPower)
	S:CreateBackdropShadow(plate.Portrait)
	S:CreateBackdropShadow(plate.Castbar)
	S:CreateShadow(plate.Castbar.Button)
end

function S:ElvUI_Nameplates()
	self:SecureHook(NP, "StylePlate", data.StylePlate)
end
