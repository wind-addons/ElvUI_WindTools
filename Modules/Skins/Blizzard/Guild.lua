local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:GuildInviteFrame()
	if not self:CheckDB("guild") then
		return
	end

	self:CreateShadow(_G.GuildInviteFrame)
end

function S:Blizzard_GuildUI()
	if not self:CheckDB("guild") then
		return
	end

	self:CreateShadow(_G.GuildFrame)

	for i = 1, 5 do
		self:ReskinTab(_G["GuildFrameTab" .. i])
	end
end

S:AddCallbackForAddon("Blizzard_GuildUI")
S:AddCallback("GuildInviteFrame")
