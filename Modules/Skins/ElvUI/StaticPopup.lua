local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local pairs = pairs

S:AddCallback("ElvUI_StaticPopup", S:CreateElvUICheck("staticPopup"))

function S:ElvUI_StaticPopup()
	for _, popup in pairs(E.StaticPopupFrames) do
		self:CreateShadow(popup)
	end
end
