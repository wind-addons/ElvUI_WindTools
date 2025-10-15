local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:GuildInviteFrame()
	if not self:CheckDB("guild") then
		return
	end

	self:CreateShadow(_G.GuildInviteFrame)
end

S:AddCallback("GuildInviteFrame")
