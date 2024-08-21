local W, F, E, L = unpack((select(2, ...)))
local M = W.Modules.Misc

local tinsert = tinsert

local C_LFGList = C_LFGList

function M:AddCNFilter()
	if E.private.WT.misc.addCNFilter then
		local filters = C_LFGList.GetAvailableLanguageSearchFilter() or {}

		for i = 1, #filters do
			if filters[i] == "zhCN" then
				return
			end
		end

		tinsert(filters, "zhCN")

		C_LFGList.GetAvailableLanguageSearchFilter = function()
			return filters
		end
	end
end

M:AddCallback("AddCNFilter")
