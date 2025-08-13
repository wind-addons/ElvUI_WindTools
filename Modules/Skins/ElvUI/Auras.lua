local W, F, E, L = unpack((select(2, ...)))
local A = E:GetModule("Auras")
local S = W.Modules.Skins

local _G = _G

function S:ElvUI_Auras_SkinIcon(_, button)
	if not button.__windSkin then
		self:CreateLowerShadow(button)
		self:BindShadowColorWithBorder(button)
		button.__windSkin = true
	end
end

function S:ElvUI_Auras()
	if not E.private.auras.enable or not E.private.WT.skins.elvui.enable or not E.private.WT.skins.elvui.auras then
		return
	end

	self:SecureHook(A, "CreateIcon", "ElvUI_Auras_SkinIcon")
	self:SecureHook(A, "UpdateAura", "ElvUI_Auras_SkinIcon")
	self:SecureHook(A, "UpdateTempEnchant", "ElvUI_Auras_SkinIcon")
end

S:AddCallback("ElvUI_Auras")
