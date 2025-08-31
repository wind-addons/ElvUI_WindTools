local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local pairs = pairs

function S:ElvUI_StaticPopup()
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.staticPopup) then
		return
	end

	for _, popup in pairs(E.StaticPopupFrames) do
		self:CreateShadow(popup)
	end
end

S:AddCallback("ElvUI_StaticPopup")
