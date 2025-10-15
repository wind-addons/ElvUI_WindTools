local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

local hooksecurefunc = hooksecurefunc
local unpack = unpack

local CreateFrame = CreateFrame

function S:Blizzard_AdventureMap()
	if not self:CheckDB("adventureMap") then
		return
	end

	local AdventureMapQuestChoiceDialog = _G.AdventureMapQuestChoiceDialog
	local childFrame = AdventureMapQuestChoiceDialog.Details.Child

	self:CreateShadow(AdventureMapQuestChoiceDialog)

	if AdventureMapQuestChoiceDialog.shadow then
		AdventureMapQuestChoiceDialog.shadow:SetFrameStrata("LOW")
	end

	if AdventureMapQuestChoiceDialog.Portrait then
		AdventureMapQuestChoiceDialog
			.Portrait--[[@as Texture]]
			:SetDrawLayer("OVERLAY", 3)
	end

	F.SetFont(childFrame.TitleHeader)
	F.SetFont(childFrame.DescriptionText)
	F.SetFont(childFrame.ObjectivesHeader)
	F.SetFont(childFrame.ObjectivesText)
	F.SetFont(AdventureMapQuestChoiceDialog.RewardsHeader)

	hooksecurefunc(AdventureMapQuestChoiceDialog, "RefreshRewards", function()
		for reward in AdventureMapQuestChoiceDialog.rewardPool:EnumerateActive() do
			if not reward.__windSkin then
				if reward.Icon then
					reward.Icon:CreateBackdrop()
					reward.Icon:SetTexCoord(unpack(E.TexCoords))
				end

				if reward.ItemNameBG then
					reward.ItemNameBG:SetAlpha(0)
					reward.windItemNameBG = CreateFrame("Frame", nil, reward)
					S:Reposition(reward.windItemNameBG, reward.ItemNameBG, 2, 0, 0, -3, -1)
					reward.windItemNameBG:SetFrameLevel(reward:GetFrameLevel())
					reward.windItemNameBG:SetTemplate("Transparent")
				end
				reward.__windSkin = true
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_AdventureMap")
