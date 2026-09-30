local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_BindingUI", nil, "binding")

function S:Blizzard_BindingUI()
	self:CreateBackdropShadow(_G.QuickKeybindFrame)
end
