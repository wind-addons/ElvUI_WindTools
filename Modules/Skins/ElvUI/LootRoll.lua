local W, F, E, L = unpack((select(2, ...)))
local M = E:GetModule("Misc")
local S = W.Modules.Skins

local _G = _G
local pairs = pairs
local tinsert = tinsert
local unpack = unpack

function S:ElvUI_SkinLootRollFrame(frame)
	if not frame or frame:IsForbidden() or frame.__windSkin then
		return
	end

	frame.button.__Point = frame.button.Point
	frame.button.Point = function(f, anchor, parent, point, x, y)
		if anchor == "RIGHT" and parent == frame and point == "LEFT" then
			f:__Point(anchor, parent, point, x and x - 4, y)
		else
			f:__Point(anchor, parent, point, x, y)
		end
	end

	local points = {}
	for i = 1, frame.button:GetNumPoints() do
		tinsert(points, { frame.button:GetPoint(i) })
	end

	if #points > 0 then
		frame.button:ClearAllPoints()
		for _, point in pairs(points) do
			frame.button:Point(unpack(point))
		end
	end

	self:CreateBackdropShadow(frame.button)
	self:CreateBackdropShadow(frame.status)

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
-- texture, name, count, quality, bop, canNeed, canGreed, canDisenchant = 123, 'test', 1, 1, true, true, true, true
-- call the function
-- E:GetModule("Misc"):START_LOOT_ROLL(_, 1, 19)
