local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:LootFrame()
	if not self:CheckDB("loot") then
		return
	end

	self:CreateShadow(_G.BonusRollFrame)
	self:CreateBackdropShadow(_G.BonusRollLootWonFrame)
	self:CreateBackdropShadow(_G.BonusRollMoneyWonFrame)
	F.SetFont(_G.BonusRollFrame.PromptFrame.InfoFrame.Cost)
	F.SetFont(_G.BonusRollFrame.PromptFrame.InfoFrame.Label)

	self:CreateShadow(_G.GroupLootHistoryFrame)
	_G.GroupLootHistoryFrame:Width(300)

	local ResizeButton = _G.GroupLootHistoryFrame.ResizeButton
	if ResizeButton then
		ResizeButton:SetTemplate("Transparent")
		self:CreateShadow(ResizeButton)
		ResizeButton:Width(300)
	end

	local ScrollBox = _G.GroupLootHistoryFrame.ScrollBox
	if ScrollBox then
		ScrollBox:ClearAllPoints()
		ScrollBox:Point("TOPLEFT", _G.GroupLootHistoryFrame, "TOPLEFT", 6, -90)
		ScrollBox:Point("BOTTOMRIGHT", _G.GroupLootHistoryFrame, "BOTTOMRIGHT", -23, 5)
	end

	local Timer = _G.GroupLootHistoryFrame.Timer
	if Timer then
		F.Move(Timer, 0, -7)
	end
end

S:AddCallback("LootFrame")
