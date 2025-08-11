local W, F, E, L = unpack((select(2, ...)))
local M = W.Modules.Misc

local _G = _G
local strmatch = strmatch

local TooltipDataProcessor_AddTooltipPostCall = TooltipDataProcessor.AddTooltipPostCall
local Enum_TooltipDataType_Item = Enum.TooltipDataType.Item

local tooltips = {
	"GameTooltip",
	"ItemRefTooltip",
	"ShoppingTooltip1",
	"ShoppingTooltip2",
	"ItemRefShoppingTooltip1",
	"ItemRefShoppingTooltip2",
}

local function removeCraftInformation(tooltip, data)
	if not E.db.WT.misc.hideCrafter then
		return
	end

	local tooltipName = tooltip:GetName()
	if F.In(tooltipName, tooltips) then
		for dataIndex = #data.lines, (10 < #data.lines and 10 or 0), -1 do
			local line = data.lines[dataIndex] and data.lines[dataIndex].leftText
			if line and strmatch(line, "^|cff00ff00<(.+)>|r$") then
				for tooltipLineIndex = dataIndex, dataIndex + 2 do
					local realLine = _G[tooltipName .. "TextLeft" .. tooltipLineIndex]
					if realLine and realLine:GetText() == line then
						realLine:SetText("")
					end
				end
			end
		end
	end
end

function M:HideCrafter()
	TooltipDataProcessor_AddTooltipPostCall(Enum_TooltipDataType_Item, removeCraftInformation)
end

M:AddCallback("HideCrafter")
