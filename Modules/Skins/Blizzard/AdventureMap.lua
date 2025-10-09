local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_AdventureMap()
	if not self:CheckDB("adventureMap") then
		return
	end

	local AdventureMapQuestChoiceDialog = _G.AdventureMapQuestChoiceDialog
	local childFrame = AdventureMapQuestChoiceDialog.Details.Child

	self:CreateShadow(AdventureMapQuestChoiceDialog)

	if AdventureMapQuestChoiceDialog.shadow then
		AdventureMapQuestChoiceDialog.shadow:SetFrameStrata("LOW")
		if AdventureMapQuestChoiceDialog.TopEdge then
			AdventureMapQuestChoiceDialog.TopEdge--[[@as Texture]]:SetDrawLayer("BACKGROUND", 0)
		end
	end

	F.SetFont(childFrame.TitleHeader)
	F.SetFont(childFrame.DescriptionText)
	F.SetFont(childFrame.ObjectivesHeader)
	F.SetFont(childFrame.ObjectivesText)
	F.SetFont(AdventureMapQuestChoiceDialog.RewardsHeader)
end

S:AddCallbackForAddon("Blizzard_AdventureMap")
