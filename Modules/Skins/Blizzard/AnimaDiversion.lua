local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_AnimaDiversionUI")
data.toggle = "animaDiversion"

local _G = _G

function S:Blizzard_AnimaDiversionUI()
	self:CreateShadow(_G.AnimaDiversionFrame)
end

