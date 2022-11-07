local W, F, E, L = unpack(select(2, ...))
local M = W.Modules.Misc

local _G = _G
local strmatch = strmatch

local TooltipDataProcessor = TooltipDataProcessor

local Enum_TooltipDataType_Item = Enum.TooltipDataType.Item

local tooltips = {
    "GameTooltip",
    "ItemRefTooltip",
    "ShoppingTooltip1",
    "ShoppingTooltip2",
    "ItemRefShoppingTooltip1",
    "ItemRefShoppingTooltip2"
}

-- TODO: remove this after 10.0.2
function M:SL_RemoveCraftInformation(tooltip)
    if not E.db.WT.misc.hideCrafter then
        return
    end

    local tooltipName = tooltip:GetName()
    if not tooltipName then
        return
    end

    for i = tooltip:NumLines(), 10, -1 do
        local line = _G[tooltipName .. "TextLeft" .. i]
        if line then
            local text = line:GetText()
            if text and strmatch(text, "<(.+)>|r$") then
                line:SetText("")
            end
        end
    end
end

local function removeCraftInformation(tooltip, data)
    if not E.db.WT.misc.hideCrafter then
        return
    end

    local tooltipName = tooltip:GetName()
    if F.In(tooltipName, tooltips) then
        for dataIndex = #(data.lines), 10, -1 do
            local line = data.lines[dataIndex] and data.lines[dataIndex].leftText
            if line and strmatch(line, "<(.+)>|r$") then
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
    -- TODO: remove this after 10.0.2
    if E.wowpatch ~= "10.0.2" then
        self:SecureHookScript(_G.GameTooltip, "OnTooltipSetItem", "SL_RemoveCraftInformation")
        self:SecureHookScript(_G.ItemRefTooltip, "OnTooltipSetItem", "SL_RemoveCraftInformation")
    else
        TooltipDataProcessor.AddTooltipPostCall(Enum_TooltipDataType_Item, removeCraftInformation)
    end
end

M:AddCallback("HideCrafter")
