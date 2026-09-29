local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("ElvUI_Panels")
data.check = function()
	return (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.panels)
end

local _G = _G

function S:ElvUI_Panels()
	self:CreateShadow(_G.ElvUI_TopPanel)
	self:CreateShadow(_G.ElvUI_BottomPanel)
end

