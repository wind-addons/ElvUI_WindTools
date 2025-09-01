local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_CovenantRenown()
	if not self:CheckDB("covenantRenown") then
		return
	end

	self:CreateShadow(_G.CovenantRenownFrame)
	self:Proxy("HandleButton", _G.CovenantRenownFrame.LevelSkipButton, nil, nil, nil, true)
end

S:AddCallbackForAddon("Blizzard_CovenantRenown")
