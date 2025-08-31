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
			AdventureMapQuestChoiceDialog.TopEdge:SetParent(AdventureMapQuestChoiceDialog.shadow)
		end
	end

	F.SetFontOutline(childFrame.TitleHeader)
	F.SetFontOutline(childFrame.DescriptionText)
	F.SetFontOutline(childFrame.ObjectivesHeader)
	F.SetFontOutline(childFrame.ObjectivesText)
	F.SetFontOutline(AdventureMapQuestChoiceDialog.RewardsHeader)
end

S:AddCallbackForAddon("Blizzard_AdventureMap")
