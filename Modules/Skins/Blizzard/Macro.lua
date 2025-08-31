local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_MacroUI()
	if not self:CheckDB("macro") then
		return
	end

	self:CreateShadow(_G.MacroFrame)
	self:CreateShadow(_G.MacroPopupFrame)
end

S:AddCallbackForAddon("Blizzard_MacroUI")
