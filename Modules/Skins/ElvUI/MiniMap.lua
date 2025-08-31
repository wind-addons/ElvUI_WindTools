local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local M = E:GetModule("Minimap")
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:ElvUI_MiniMap()
	if not E.private.general.minimap.enable or not M.MapHolder then
		return
	end

	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.miniMap) then
		return
	end

	self:CreateBackdropShadow(_G.Minimap)
	self:CreateShadow(_G.MinimapRightClickMenu)
end

S:AddCallback("ElvUI_MiniMap")
