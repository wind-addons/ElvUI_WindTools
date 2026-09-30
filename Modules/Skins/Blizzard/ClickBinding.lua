local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_ClickBindingUI", nil, "binding", "clickBinding")

function S:Blizzard_ClickBindingUI()
	self:CreateShadow(_G.ClickBindingFrame)
	self:CreateShadow(_G.ClickBindingFrame.TutorialFrame)
end
