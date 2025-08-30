local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, table, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_WarboardUI()
	if not self:CheckDB("warboard") then
		return
	end

	self:CreateShadow(_G.WarboardQuestChoiceFrame)
end

S:AddCallbackForAddon("Blizzard_WarboardUI")
