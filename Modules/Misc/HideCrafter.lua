local W, F, E, L = unpack(select(2, ...))
local M = W.Modules.Misc

local _G = _G
local strmatch = strmatch

function M:RemoveCraftInformation(tooltip)
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

function M:HideCrafter()
    self:SecureHookScript(_G.GameTooltip, "OnTooltipSetItem", "RemoveCraftInformation")
    self:SecureHookScript(_G.ItemRefTooltip, "OnTooltipSetItem", "RemoveCraftInformation")
end

M:AddCallback("HideCrafter")
