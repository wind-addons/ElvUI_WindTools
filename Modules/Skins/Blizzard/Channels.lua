local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallbackForAddon("Blizzard_Channels", nil, "channels")

function S:Blizzard_Channels()
	self:CreateShadow(_G.ChannelFrame)
	self:CreateShadow(_G.CreateChannelPopup)
end
