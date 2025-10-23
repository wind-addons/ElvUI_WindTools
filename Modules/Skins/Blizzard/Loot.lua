local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local ES = E.Skins

local _G = _G
local pairs = pairs
local unpack = unpack

function S:LootFrame()
	if not self:CheckDB("loot") then
		return
	end

	F.SetFont(_G.BonusRollFrame.PromptFrame.InfoFrame.Cost)
	F.SetFont(_G.BonusRollFrame.PromptFrame.InfoFrame.Label)

	self:CreateShadow(_G.BonusRollFrame)
	self:CreateBackdropShadow(_G.BonusRollLootWonFrame)
	self:CreateBackdropShadow(_G.BonusRollMoneyWonFrame)

	self:CreateShadow(_G.GroupLootHistoryFrame)
	self:CreateShadow(_G.GroupLootHistoryFrame.ResizeButton)

	_G.GroupLootHistoryFrame.ResizeButton:SetTemplate("Transparent")
	_G.GroupLootHistoryFrame:Width(300)
	_G.GroupLootHistoryFrame.ResizeButton:Width(300)

	_G.GroupLootHistoryFrame.ScrollBox:ClearAllPoints()
	_G.GroupLootHistoryFrame.ScrollBox:Point("TOPLEFT", _G.GroupLootHistoryFrame, "TOPLEFT", 6, -90)
	_G.GroupLootHistoryFrame.ScrollBox:Point("BOTTOMRIGHT", _G.GroupLootHistoryFrame, "BOTTOMRIGHT", -23, 5)

	F.Move(_G.GroupLootHistoryFrame.Timer, 0, -7)
end

S:AddCallback("LootFrame")
