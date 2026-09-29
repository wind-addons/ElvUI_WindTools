local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local M = E:GetModule("Minimap")
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("ElvUI_MiniMap")
data.check = function()
	return E.private.general.minimap.enable
		and M.MapHolder
		and E.private.WT.skins.elvui.enable
		and E.private.WT.skins.elvui.miniMap
end

local _G = _G

function S:ElvUI_MiniMap()
	self:CreateBackdropShadow(_G.Minimap)
	self:CreateShadow(_G.MinimapRightClickMenu)
end

