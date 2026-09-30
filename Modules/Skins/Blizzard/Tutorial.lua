local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallback("TutorialFrame", "tutorials", "tutorial")

function S:TutorialFrame()
	self:CreateShadow(_G.TutorialFrame)
end
