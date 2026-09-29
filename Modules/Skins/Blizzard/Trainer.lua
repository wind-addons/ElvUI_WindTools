local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_TrainerUI")
data.toggle = "trainer"

local _G = _G

function S:Blizzard_TrainerUI()
	self:CreateShadow(_G.ClassTrainerFrame)
end

