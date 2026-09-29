local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_BindingUI")
data.toggle = "misc"

local _G = _G

function S:Blizzard_BindingUI()
	self:CreateShadow(_G.KeyBindingFrame)
end

