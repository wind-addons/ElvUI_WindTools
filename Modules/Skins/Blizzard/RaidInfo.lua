local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("RaidInfoFrame")
data.toggle = "nonraid"
data.private = "raidInfo"

local _G = _G

function S:RaidInfoFrame()
	self:CreateShadow(_G.RaidInfoFrame)
end

