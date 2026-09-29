local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("HelpFrame")
data.toggle = "help"

local _G = _G

function S:HelpFrame()
	self:CreateBackdropShadow(_G.HelpFrame)
end

