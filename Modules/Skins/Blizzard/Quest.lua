local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

function S.QuestInfo_Display()
	F.SetFontOutline(_G.QuestInfoTitleHeader)
	F.SetFontOutline(_G.QuestInfoDescriptionHeader)
	F.SetFontOutline(_G.QuestInfoObjectivesHeader)
	F.SetFontOutline(_G.QuestInfoRewardsFrame.Header)
	F.SetFontOutline(_G.QuestInfoDescriptionText)
	F.SetFontOutline(_G.QuestInfoObjectivesText)
	F.SetFontOutline(_G.QuestInfoGroupSize)
	F.SetFontOutline(_G.QuestInfoRewardText)
	F.SetFontOutline(_G.QuestInfoRewardsFrame.Label)
	F.SetFontOutline(_G.QuestInfoRewardsFrame.ItemChooseText)
	F.SetFontOutline(_G.QuestInfoRewardsFrame.ItemReceiveText)
	F.SetFontOutline(_G.QuestInfoRewardsFrame.PlayerTitleText)
	F.SetFontOutline(_G.QuestInfoRewardsFrame.XPFrame.ReceiveText)

	for _, objText in pairs(_G.QuestInfoObjectivesFrame.Objectives) do
		if objText then
			F.SetFontOutline(objText)
		end
	end
end

function S:BlizzardQuestFrames()
	if not self:CheckDB("quest") then
		return
	end

	self:CreateShadow(_G.QuestFrame)
	hooksecurefunc("QuestInfo_Display", self.QuestInfo_Display)

	self:CreateShadow(_G.QuestModelScene)
	self:CreateBackdropShadow(_G.QuestModelScene.ModelTextFrame)
	self:Reposition(_G.QuestModelScene.ModelTextFrame.backdrop, _G.QuestModelScene.ModelTextFrame, 0, 8, 5, 0, 0)
	F.SetFontOutline(_G.QuestNPCModelText)
	self:CreateShadow(_G.QuestLogPopupDetailFrame)

	F.SetFontOutline(_G.QuestNPCModelNameText)
	self:CreateShadow(_G.QuestNPCModelTextFrame)
end

S:AddCallback("BlizzardQuestFrames")
