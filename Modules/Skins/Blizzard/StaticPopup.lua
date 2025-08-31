local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:StaticPopup()
	if not self:CheckDB(nil, "staticPopup") then
		return
	end

	for i = 1, E.MAX_STATIC_POPUPS do
		self:CreateShadow(_G["StaticPopup" .. i])
	end
end

S:AddCallback("StaticPopup")
