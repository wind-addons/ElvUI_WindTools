local W, F, E, L = unpack((select(2, ...)))
local M = W.Modules.Misc
local CA = W:GetModule("CombatAlert")

local _G = _G
local hooksecurefunc = hooksecurefunc

local GenerateClosure = GenerateClosure
local RunNextFrame = RunNextFrame

local alertFrame

local function isAlertFrameShown()
	if alertFrame and alertFrame.IsShown and alertFrame:IsShown() then
		alertFrame = nil
		return true
	end
	return false
end

local function withHidingCombatAlert(f)
	local handle = CA and CA.db and CA.db.enable and CA.alert and CA.alert:IsShown()
	if handle then
		CA.alert:Hide()
	end

	RunNextFrame(f)

	if handle then
		E:Delay(0.2, CA.alert.Show, CA.alert)
	end
end

function M:DelayScreenshot(_, id, _, tried)
	tried = tried or 0

	if tried <= 4 then
		E:Delay(1, function()
			if isAlertFrameShown() then
				withHidingCombatAlert(function()
					_G.Screenshot()
					RunNextFrame(GenerateClosure(F.Print, L["Screenshot has been automatically taken."]))
				end)
			else
				self:DelayScreenshot(nil, nil, nil, tried + 1)
			end
		end)
	end
end

function M:AutoScreenShot()
	if E.private.WT.misc.autoScreenshot then
		self:RegisterEvent("ACHIEVEMENT_EARNED", "DelayScreenshot")

		hooksecurefunc(_G.AchievementAlertSystem:GetAlertContainer(), "AddAlertFrame", function(_, frame)
			alertFrame = frame
			E:Delay(
				3, -- wait for 3 seconds
				function()
					if frame == alertFrame then
						alertFrame = nil
					end
				end
			)
		end)
	end
end

M:AddCallback("AutoScreenShot")
