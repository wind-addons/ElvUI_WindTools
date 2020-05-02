local W, F, E, L = unpack(select(2, ...))
local TT = E:GetModule('Tooltip')
local S = W:GetModule('Skins')

local _G = _G

function S:TooltipFrames()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.tooltip) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.tooltip) then return end

    local styleTT = {
        _G.GameTooltip,
        _G.ItemRefTooltip,
        _G.FriendsTooltip,
        _G.WarCampaignTooltip,
        _G.EmbeddedItemTooltip,
        _G.ReputationParagonTooltip,
        _G.QuestScrollFrame.StoryTooltip
    }

    for _, tt in pairs(styleTT) do
        if tt and tt ~= E.ScanTooltip and not tt.IsEmbedded and not tt:IsForbidden() then S:CreateShadow(tt) end
    end

    hooksecurefunc(TT, "SetStyle", function(_, tt) S:CreateShadow(tt) end)

    hooksecurefunc(TT, "GameTooltip_SetDefaultAnchor", function(_, tt)
        if (tt.StatusBar) then S:CreateShadow(tt.StatusBar) end
        if _G.GameTooltipStatusBar then S:CreateShadow(_G.GameTooltipStatusBar) end
    end)

    hooksecurefunc("QueueStatusFrame_Update", function(self) S:CreateShadow(self) end)
end

S:AddCallback('TooltipFrames')
