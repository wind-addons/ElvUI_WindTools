local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local M = W.Modules.Misc ---@class Misc

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

		---@diagnostic disable-next-line: duplicate-set-field
		C_LFGList.GetAvailableLanguageSearchFilter = function()
			return filters
		end
	end
end

M:AddCallback("AddCNFilter")
