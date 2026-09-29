local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_ClickBindingUI")
data.toggle = "binding"
data.private = "clickBinding"

local _G = _G

function S:Blizzard_ClickBindingUI()
	self:CreateShadow(_G.ClickBindingFrame)
	self:CreateShadow(_G.ClickBindingFrame.TutorialFrame)
end

