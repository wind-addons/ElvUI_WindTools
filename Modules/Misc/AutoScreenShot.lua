local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local M = W.Modules.Misc ---@class Misc
local CA = W:GetModule("CombatAlert") ---@class CombatAlert

local _G = _G
local hooksecurefunc = hooksecurefunc

local RunNextFrame = RunNextFrame

local blizzardAlertFrame ---@type Frame?
local isProcessingScreenshot = false

function M:DelayScreenshot(_, _, alreadyEarned)
	if alreadyEarned or isProcessingScreenshot then
		return
	end

	isProcessingScreenshot = true

	-- Add a slight delay to ensure achievements earned simultaneously are processed only once
	E:Delay(0.1, function()
		F.WaitFor(function()
			if blizzardAlertFrame and blizzardAlertFrame.IsShown and blizzardAlertFrame:IsShown() then
				return true
			end

			return false
		end, function()
			local isCombatAlertShowing = CA and CA.AlertFrame and CA.AlertFrame:IsShown()
			if isCombatAlertShowing then
				CA.AlertFrame:Hide()
			end

			E:Delay(1, function()
				_G.Screenshot()
				RunNextFrame(function()
					F.Print(L["Screenshot has been automatically taken."])
					if isCombatAlertShowing then
						CA.AlertFrame:Show()
					end
					isProcessingScreenshot = false
				end)
			end)
		end, 0.1, 20)
	end)
end

function M:AutoScreenShot()
	if not E.private.WT.misc.autoScreenshot then
		return
	end

	-- Mark the alert frame when it's created
	hooksecurefunc(_G.AchievementAlertSystem:GetAlertContainer(), "AddAlertFrame", function(_, frame)
		blizzardAlertFrame = frame
		E:Delay(2, function()
			if frame == blizzardAlertFrame then
				blizzardAlertFrame = nil
			end
		end)
	end)

	self:RegisterEvent("ACHIEVEMENT_EARNED", "DelayScreenshot")
end

M:AddCallback("AutoScreenShot")
