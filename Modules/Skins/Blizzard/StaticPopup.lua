local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("StaticPopup")
data.private = "staticPopup"

local _G = _G

function S:StaticPopup()
	for i = 1, E.MAX_STATIC_POPUPS do
		self:CreateShadow(_G["StaticPopup" .. i])
	end
end

