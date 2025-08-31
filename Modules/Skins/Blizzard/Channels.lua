local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_Channels()
	if not self:CheckDB("channels") then
		return
	end

	self:CreateShadow(_G.ChannelFrame)
	self:CreateShadow(_G.CreateChannelPopup)
end

S:AddCallbackForAddon("Blizzard_Channels")
