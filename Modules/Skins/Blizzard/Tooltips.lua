local W, F, E, L = unpack(select(2, ...))
local TT = E:GetModule("Tooltip")
local S = W:GetModule("Skins")

local _G = _G
local pairs = pairs

function S:TTSetStyle(_, tt)
    if tt and tt ~= E.ScanTooltip and not tt.IsEmbedded and not tt:IsForbidden() then
        self:CreateShadow(tt)
    end
end

function S:TTGameTooltip_SetDefaultAnchor(_, tt)
    if (tt.StatusBar) then
        self:CreateShadow(tt.StatusBar)
    end
    if _G.GameTooltipStatusBar then
        self:CreateShadow(_G.GameTooltipStatusBar, 6)
    end
end

function S:TooltipFrames()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.tooltip) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.tooltips) then
        return
    end

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
        if tt and tt ~= E.ScanTooltip and not tt.IsEmbedded and not tt:IsForbidden() then
            S:CreateShadow(tt)
        end
    end

    S:SecureHook(TT, "SetStyle", "TTSetStyle")
    S:SecureHook(TT, "GameTooltip_SetDefaultAnchor", "TTGameTooltip_SetDefaultAnchor")
    S:SecureHook("QueueStatusFrame_Update", "CreateShadow")
end

S:AddCallback("TooltipFrames")