local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_StableUI()
	if not self:CheckDB("stable") then
		return
	end

	self:CreateShadow(_G.StableFrame)
end

S:AddCallbackForAddon("Blizzard_StableUI")
