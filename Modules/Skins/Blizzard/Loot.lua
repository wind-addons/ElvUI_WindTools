local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallback("LootFrame", "loot")

function S:LootFrame()
	self:CreateShadow(_G.BonusRollFrame)
	self:CreateBackdropShadow(_G.BonusRollLootWonFrame)
	self:CreateBackdropShadow(_G.BonusRollMoneyWonFrame)
	F.SetFont(_G.BonusRollFrame.PromptFrame.InfoFrame.Cost)
	F.SetFont(_G.BonusRollFrame.PromptFrame.InfoFrame.Label)

	self:CreateShadow(_G.GroupLootHistoryFrame)

	local ResizeButton = _G.GroupLootHistoryFrame.ResizeButton
	if ResizeButton then
		ResizeButton:SetTemplate("Transparent")
		self:CreateShadow(ResizeButton)
	end

	local Timer = _G.GroupLootHistoryFrame.Timer
	if Timer then
		F.Move(Timer, 0, -7)
	end
end
