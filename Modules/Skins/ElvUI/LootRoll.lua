local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local M = E:GetModule("Misc")
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs
local hooksecurefunc = hooksecurefunc

function S:ElvUI_SkinLootRollFrame(frame)
	if not frame or frame:IsForbidden() or frame.__windSkin then
		return
	end

	self:CreateBackdropShadow(frame.button)
	self:CreateBackdropShadow(frame.status)

	F.InternalizeMethod(frame.button, "SetPoint")
	F.Move(frame.button, -4, 0)
	hooksecurefunc(frame.button, "SetPoint", function()
		F.Move(frame.button, -4, 0)
	end)

	frame.__windSkin = true
end

function S:ElvUI_LootRoll()
	if not (E.private.general.lootRoll and E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.lootRoll) then
		return
	end

	self:SecureHook(M, "LootRoll_Create", function(_, index)
		self:ElvUI_SkinLootRollFrame(_G["ElvUI_LootRollFrame" .. index])
	end)

	for _, bar in pairs(M.RollBars) do
		self:ElvUI_SkinLootRollFrame(bar)
	end
end

S:AddCallback("ElvUI_LootRoll")

-- debug note:
-- itemLink = select(2, C_Item.GetItemInfo(193652))
-- local texture, name, count, quality, canNeed, canGreed, canDisenchant, canTransmog = 606551, 'test', 1, 1, true, true, true, true
-- call the function
-- E:GetModule("Misc"):START_LOOT_ROLL(_, 1, 19)
