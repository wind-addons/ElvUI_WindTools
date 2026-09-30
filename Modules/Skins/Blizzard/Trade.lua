local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallback("TutorialFrame", "trade")

function S:TutorialFrame()
	self:CreateShadow(_G.TradeFrame)
end
