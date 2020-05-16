local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local LO = E:GetModule("Layout")

local _G = _G
local hooksecurefunc = hooksecurefunc

local function ToggleShadows()
    local leftDB = E.db.chat.datatexts.panels.LeftChatDataPanel
    local rightDB = E.db.chat.datatexts.panels.RightChatDataPanel

    if leftDB.enable and leftDB.backdrop then
        _G.LeftChatDataPanel.shadow:Show()
    else
        _G.LeftChatDataPanel.shadow:Hide()
    end

    if rightDB.enable and rightDB.backdrop then
        _G.RightChatDataPanel.shadow:Show()
    else
        _G.RightChatDataPanel.shadow:Hide()
    end
end

function S:ElvUI_ChatPanels()
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.chatPanels) then
        return
    end

    S:CreateShadow(_G.LeftChatDataPanel)
    S:CreateShadow(_G.RightChatDataPanel)
    ToggleShadows()

    hooksecurefunc(LO, "ToggleChatPanels", ToggleShadows)
end

S:AddCallback("ElvUI_ChatPanels")
