local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_WeeklyRewards")
data.toggle = "weeklyRewards"

local _G = _G

function S:Blizzard_WeeklyRewards()
	self:CreateShadow(_G.WeeklyRewardsFrame)

	if _G.WeeklyRewardExpirationWarningDialog then
		self:CreateShadow(_G.WeeklyRewardExpirationWarningDialog.NineSlice)
	end
end

