local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

local hooksecurefunc = hooksecurefunc

local CreateFrame = CreateFrame

function S:Blizzard_AdventureMap()
	if not self:CheckDB("adventureMap") then
		return
	end

	local AdventureMapQuestChoiceDialog = _G.AdventureMapQuestChoiceDialog
	local childFrame = AdventureMapQuestChoiceDialog.Details.Child

	self:CreateBackdropShadow(AdventureMapQuestChoiceDialog)

	F.SetFont(childFrame.TitleHeader)
	F.SetFont(childFrame.DescriptionText)
	F.SetFont(childFrame.ObjectivesHeader)
	F.SetFont(childFrame.ObjectivesText)
	F.SetFont(AdventureMapQuestChoiceDialog.RewardsHeader)

	hooksecurefunc(AdventureMapQuestChoiceDialog, "RefreshRewards", function()
		for reward in AdventureMapQuestChoiceDialog.rewardPool:EnumerateActive() do
			if not reward.__windSkin then
				reward.windItemNameBG = CreateFrame("Frame", nil, reward)
				reward.windItemNameBG:SetFrameLevel(reward:GetFrameLevel())
				reward.windItemNameBG:SetTemplate("Transparent")
				S:Reposition(reward.windItemNameBG, reward.ItemNameBG, 2, 0, -1, -3, -1)
				reward.__windSkin = true
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_AdventureMap")
