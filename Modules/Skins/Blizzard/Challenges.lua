local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

if not E.Forever then
	local data = S:AddCallbackForAddon("Blizzard_ChallengesUI")
	data.toggle = "lfg"
	data.private = "challenges"
end

local _G = _G

function S:Blizzard_ChallengesUI()
	self:CreateShadow(_G.ChallengesKeystoneFrame)
end

