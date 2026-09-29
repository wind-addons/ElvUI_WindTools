local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("ElvUI_StaticPopup")
data.check = function()
	return (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.staticPopup)
end

local pairs = pairs

function S:ElvUI_StaticPopup()
	for _, popup in pairs(E.StaticPopupFrames) do
		self:CreateShadow(popup)
	end
end

