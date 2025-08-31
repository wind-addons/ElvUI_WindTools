local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local M = W.Modules.Misc ---@class Misc
local AB = E.ActionBars

local hooksecurefunc = hooksecurefunc
local pairs = pairs

local CreateFrame = CreateFrame

local function setParent(button)
	if button.windHotKeyFrame or not button.cooldown then
		return
	end
	button.windHotKeyFrame = CreateFrame("Frame", nil, button)
	button.windHotKeyFrame:SetAllPoints(button)
	button.windHotKeyFrame:SetFrameStrata("LOW")
	button.windHotKeyFrame:SetFrameLevel(button.cooldown:GetFrameLevel() + 11) -- The glow is about 10
	button.HotKey:SetParent(button.windHotKeyFrame)
end

function M:KeybindTextAbove()
	if not E.private.actionbar.enable or not E.db.cooldown.enable or not E.private.WT.misc.keybindTextAbove then
		return
	end

	hooksecurefunc(E, "CreateCooldownTimer", function(_, button)
		if button and button.cooldown and AB.handledbuttons[button] then
			setParent(button)
		end
	end)

	for button in pairs(AB.handledbuttons) do
		setParent(button)
	end
end

M:AddCallback("KeybindTextAbove")
