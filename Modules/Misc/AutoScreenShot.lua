local W, F, E, L = unpack((select(2, ...)))
local M = W.Modules.Misc
local CA = W:GetModule("CombatAlert")

local _G = _G
local hooksecurefunc = hooksecurefunc

local alertFrame

function M:DelayScreenshot(id, _, _, tried)
	-- Ambassadors, Diplomacy
	if id and id == 7844 or id == 7843 then
		return
	end

	if not tried then
		tried = 0
	end

	if tried > 30 then
		return
	end

	E:Delay(0.5, function()
		if alertFrame and alertFrame.IsShown and alertFrame:IsShown() and _G.Screenshot then
			local handleCombatAlert = CA and CA.db and CA.db.enable and CA.alert:IsShown()
			if handleCombatAlert then
				CA.alert:Hide()
			end

			_G.Screenshot()
			alertFrame = nil

			if handleCombatAlert then
				CA.alert:Show()
			end

			E:Delay(1, F.Print, L["Screenshot has been automatically taken."])
		else
			self:DelayScreenshot(nil, nil, nil, tried + 1)
		end
	end)
end

function M:AutoScreenShot()
	if E.private.WT.misc.autoScreenshot then
		self:RegisterEvent("ACHIEVEMENT_EARNED", "DelayScreenshot")

		hooksecurefunc(_G.AchievementAlertSystem:GetAlertContainer(), "AddAlertFrame", function(_, frame)
			E:Delay(
				1, -- achievement alert frame will be shown after 1 second
				function()
					local thisFrame = frame
					alertFrame = frame
					E:Delay(
						14, -- wait for 15 seconds
						function()
							if thisFrame == alertFrame then
								alertFrame = nil
							end
						end
					)
				end
			)
		end)
	end
end

M:AddCallback("AutoScreenShot")
