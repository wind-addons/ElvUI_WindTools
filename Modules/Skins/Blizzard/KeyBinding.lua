local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_BindingUI()
	if not self:CheckDB("misc") then
		return
	end

	self:CreateShadow(_G.KeyBindingFrame)
end

S:AddCallbackForAddon("Blizzard_BindingUI")
