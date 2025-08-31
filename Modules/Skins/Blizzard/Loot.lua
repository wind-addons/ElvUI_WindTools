local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local ES = E.Skins

local _G = _G
local pairs = pairs
local unpack = unpack

function S:LootFrame()
	if not self:CheckDB("loot") then
		return
	end

	F.SetFontOutline(_G.BonusRollFrame.PromptFrame.InfoFrame.Cost)
	F.SetFontOutline(_G.BonusRollFrame.PromptFrame.InfoFrame.Label)

	self:CreateShadow(_G.BonusRollFrame)
	self:CreateBackdropShadow(_G.BonusRollLootWonFrame)
	self:CreateBackdropShadow(_G.BonusRollMoneyWonFrame)

	self:CreateShadow(_G.GroupLootHistoryFrame)
	self:CreateShadow(_G.GroupLootHistoryFrame.ResizeButton)

	_G.GroupLootHistoryFrame.ResizeButton:SetTemplate("Transparent")
	_G.GroupLootHistoryFrame:SetWidth(300)
	_G.GroupLootHistoryFrame.ResizeButton:SetWidth(300)

	_G.GroupLootHistoryFrame.ScrollBox:ClearAllPoints()
	_G.GroupLootHistoryFrame.ScrollBox:SetPoint("TOPLEFT", _G.GroupLootHistoryFrame, "TOPLEFT", 6, -90)
	_G.GroupLootHistoryFrame.ScrollBox:SetPoint("BOTTOMRIGHT", _G.GroupLootHistoryFrame, "BOTTOMRIGHT", -23, 5)

	F.Move(_G.GroupLootHistoryFrame.Timer, 0, -7)
end

S:AddCallback("LootFrame")
