local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_BindingUI")
data.toggle = "binding"

local _G = _G

function S:Blizzard_BindingUI()
	self:CreateBackdropShadow(_G.QuickKeybindFrame)
end

