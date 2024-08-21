local W, F, E, L = unpack((select(2, ...)))
local M = W.Modules.Misc

local hooksecurefunc = hooksecurefunc

function M:PauseToSlash()
	if E.private.WT.misc.pauseToSlash then
		hooksecurefunc("ChatEdit_OnTextChanged", function(self, userInput)
			local text = self:GetText()
			if userInput then
				if text == "、" then
					self:SetText("/")
				end
			end
		end)
	end
end

M:AddCallback("PauseToSlash")
