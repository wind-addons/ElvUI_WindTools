local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:ElvUI_Panels()
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.panels) then
		return
	end

	self:CreateShadow(_G.ElvUI_TopPanel)
	self:CreateShadow(_G.ElvUI_BottomPanel)
end

S:AddCallback("ElvUI_Panels")
