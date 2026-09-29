local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_AchievementUI")
data.toggle = "achievement"
data.private = "achievements"

local _G = _G

function S:Blizzard_AchievementUI()
	S:CreateShadow(_G.AchievementFrame)
	S:CreateBackdropShadow(_G.AchievementFrameComparisonHeader)

	for i = 1, 3 do
		self:ReskinTab(_G["AchievementFrameTab" .. i])
	end

	self:CreateBackdropShadow(_G.AchievementFrame.SearchPreviewContainer)
	self:CreateBackdropShadow(_G.AchievementFrame.SearchResults)
end

