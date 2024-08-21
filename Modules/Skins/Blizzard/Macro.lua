local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_MacroUI()
	if not self:CheckDB("macro") then
		return
	end

	self:CreateShadow(_G.MacroFrame)
	self:CreateShadow(_G.MacroPopupFrame)
end

S:AddCallbackForAddon("Blizzard_MacroUI")
