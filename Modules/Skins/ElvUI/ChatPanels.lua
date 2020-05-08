local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local LO = E:GetModule("Layout")

local _G = _G
local hooksecurefunc = hooksecurefunc

local function ToggleShadows()
    local panelBackdrop = E.db.chat.panelBackdrop
    if panelBackdrop == "SHOWBOTH" then
        _G.LeftChatPanel.shadow:Show()
        _G.RightChatPanel.shadow:Show()
    elseif panelBackdrop == "HIDEBOTH" then
        _G.LeftChatPanel.shadow:Hide()
        _G.RightChatPanel.shadow:Hide()
    elseif panelBackdrop == "LEFT" then
        _G.LeftChatPanel.shadow:Show()
        _G.RightChatPanel.shadow:Hide()
    else
        _G.LeftChatPanel.shadow:Hide()
        _G.RightChatPanel.shadow:Show()
    end
end

function S:ElvUI_ChatPanels()
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.chatPanels) then
        return
    end

    S:CreateShadow(_G.LeftChatPanel)
    S:CreateShadow(_G.RightChatPanel)
    ToggleShadows()

    hooksecurefunc(LO, "ToggleChatPanels", ToggleShadows)
end

S:AddCallback("ElvUI_ChatPanels")
