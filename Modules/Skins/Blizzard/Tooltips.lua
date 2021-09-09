local W, F, E, L = unpack(select(2, ...))
local TT = E:GetModule("Tooltip")
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")
local _G = _G
local pairs = pairs

function S:TTSetStyle(_, tt)
    if tt and tt ~= E.ScanTooltip and not tt.IsEmbedded and not tt:IsForbidden() then
        if tt.widgetContainer then
            if tt.TopOverlay then
                tt.TopOverlay:StripTextures()
            end
            if tt.BottomOverlay then
                tt.BottomOverlay:StripTextures()
            end
            if tt.NineSlice then
                self:StripEdgeTextures(tt.NineSlice)
            end
            tt:SetTemplate("Transparent")
        end
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
    if not self:CheckDB("tooltip", "tooltips") then
        return
    end

    local styleTT = {
        _G.DataTextTooltip,
        _G.ElvUIConfigTooltip,
        _G.ElvUISpellBookTooltip,
        _G.EmbeddedItemTooltip,
        _G.FriendsTooltip,
        _G.GameTooltip,
        _G.ItemRefShoppingTooltip1,
        _G.ItemRefShoppingTooltip2,
        _G.ItemRefTooltip,
        _G.QuestScrollFrame.CampaignTooltip,
        _G.QuestScrollFrame.StoryTooltip,
        _G.ReputationParagonTooltip,
        _G.ShoppingTooltip1,
        _G.ShoppingTooltip2,
        _G.WarCampaignTooltip,
        _G.LibDBIconTooltip,
        _G.AceGUITooltip,
        _G.AceConfigDialogTooltip
    }

    for _, tt in pairs(styleTT) do
        if tt and tt ~= E.ScanTooltip and not tt.IsEmbedded and not tt:IsForbidden() then
            self:CreateShadow(tt)
        end
    end

    self:CreateShadow(_G.FloatingBattlePetTooltip)

    self:SecureHook(TT, "SetStyle", "TTSetStyle")
    self:SecureHook(TT, "GameTooltip_SetDefaultAnchor", "TTGameTooltip_SetDefaultAnchor")
    self:SecureHook("QueueStatusFrame_Update", "CreateShadow")
end

S:AddCallback("TooltipFrames")
