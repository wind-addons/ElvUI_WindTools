local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local M = W.Modules.Misc ---@class Misc

local _G = _G
local hooksecurefunc = hooksecurefunc
local tinsert = tinsert

local PaperDollFrame_SetMovementSpeed = PaperDollFrame_SetMovementSpeed

function M:MoveSpeed()
	if E.private.WT.misc.moveSpeed then
		local tempstatFrame
		hooksecurefunc("PaperDollFrame_SetMovementSpeed", function(statFrame, unit)
			if tempstatFrame and tempstatFrame ~= statFrame then
				tempstatFrame:SetScript("OnUpdate", nil)
			end
			statFrame:SetScript("OnUpdate", _G.MovementSpeed_OnUpdate)
			tempstatFrame = statFrame
			statFrame:Show()
		end)

		_G.PAPERDOLL_STATINFO["MOVESPEED"].updateFunc = function(statFrame, unit)
			PaperDollFrame_SetMovementSpeed(statFrame, unit)
		end
		tinsert(_G.PAPERDOLL_STATCATEGORIES[1].stats, { stat = "MOVESPEED" })
	end
end

M:AddCallback("MoveSpeed")
