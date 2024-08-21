local W, F, E, L = unpack((select(2, ...)))
local A = E:GetModule("Auras")
local S = W.Modules.Skins

local _G = _G

function S:ElvUI_Panels()
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.panels) then
		return
	end

	self:CreateShadow(_G.ElvUI_TopPanel)
	self:CreateShadow(_G.ElvUI_BottomPanel)
end

S:AddCallback("ElvUI_Panels")
