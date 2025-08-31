local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_TrainerUI()
	if not self:CheckDB("trainer") then
		return
	end

	self:CreateShadow(_G.ClassTrainerFrame)
end

S:AddCallbackForAddon("Blizzard_TrainerUI")
