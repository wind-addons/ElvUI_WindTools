local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("TutorialFrame")
data.toggle = "tutorials"
data.private = "tutorial"

local _G = _G

function S:TutorialFrame()
	self:CreateShadow(_G.TutorialFrame)
end

