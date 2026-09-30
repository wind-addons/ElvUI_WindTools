local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local M = E:GetModule("Minimap")
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallback("ElvUI_MiniMap", function()
	return E.private.general.minimap.enable
			and M.MapHolder
			and E.private.WT.skins.elvui.enable
			and E.private.WT.skins.elvui.miniMap
			and true
		or false
end)

function S:ElvUI_MiniMap()
	self:CreateBackdropShadow(_G.Minimap)
	self:CreateShadow(_G.MinimapRightClickMenu)
end
