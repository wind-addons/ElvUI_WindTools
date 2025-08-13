local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
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
