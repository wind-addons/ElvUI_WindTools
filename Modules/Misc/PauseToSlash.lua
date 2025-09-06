local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local M = W.Modules.Misc ---@class Misc

local hooksecurefunc = hooksecurefunc

function M:PauseToSlash()
	if E.private.WT.misc.pauseToSlash then
		hooksecurefunc("ChatEdit_OnTextChanged", function(editBox, userInput)
			local text = editBox:GetText()
			if userInput then
				if text == "、" then
					editBox:SetText("/")
				end
			end
		end)
	end
end

M:AddCallback("PauseToSlash")
