local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("GuildInviteFrame")
data.toggle = "guild"

local _G = _G

function S:GuildInviteFrame()
	self:CreateShadow(_G.GuildInviteFrame)
end

