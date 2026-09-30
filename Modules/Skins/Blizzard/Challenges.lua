local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

if not E.Forever then
	S:AddCallbackForAddon("Blizzard_ChallengesUI", nil, "lfg", "challenges")
end

function S:Blizzard_ChallengesUI()
	self:CreateShadow(_G.ChallengesKeystoneFrame)
end
