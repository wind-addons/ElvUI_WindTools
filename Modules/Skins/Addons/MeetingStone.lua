local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")

function S:MeetingStone()
    -- if not E.private.WT.skins.enable or not E.private.WT.skins.addons.hekili then
    --     return
    -- end

    local NetEaseEnv = LibStub("NetEaseEnv-1.0")
    local NetEaseGUI = LibStub("NetEaseGUI-2.0")

    if not NetEaseEnv or not NetEaseGUI then
        return
    end

    for k in pairs(NetEaseEnv._NSInclude) do
        if type(k) == "table" then
            NEG = k
        end
    end

    if not NEG then
        return
    end

    -- Main Panel
    local MainPanel = NEG.MainPanel
    if MainPanel then
        ES:HandlePortraitFrame(MainPanel)
        S:CreateShadow(MainPanel.backdrop)
        MainPanel.PortraitFrame:Hide()
        local close =
            CreateFrame("Button", "WTMeetingStoneCloseButton", MainPanel, "UIPanelCloseButton, BackdropTemplate")
        close:Point("TOPRIGHT", MainPanel.backdrop, "TOPRIGHT", 2, 4)
        close:SetScript("OnClick", MainPanel.CloseButton:GetScript("OnClick"))
        ES:HandleCloseButton(close)
        MainPanel.CloseButton:Kill()
        MainPanel.CloseButton = close
    end

    -- Tabs
    local module = NetEaseGUI:GetClass("BottomTabButton")
    if module and module.SetStatus then
        local SetStatusOld = module.SetStatus
        function module:SetStatus(status)
            SetStatusOld(self, status)
            if self and not self.windStyle then
                self.tActiveLeft:StripTextures()
                self.tActiveRight:StripTextures()
                self.tActiveMid:StripTextures()
                self.tLeft:StripTextures()
                self.tRight:StripTextures()
                self.tMid:StripTextures()
                self:GetHighlightTexture():StripTextures()
                self:CreateBackdrop("Transparent")
                self.backdrop:Point("TOPLEFT", 6, E.PixelMode and -1 or -3)
                self.backdrop:Point("BOTTOMRIGHT", -6, 3)
                S:CreateShadow(self.backdrop)
                self.windStyle = true
            end
        end
    end

    -- Browse Panel (查找活动)
    local BrowsePanel = NEG.BrowsePanel
    if BrowsePanel then
        if BrowsePanel.RefreshButton then
            ES:HandleButton(BrowsePanel.RefreshButton)
            BrowsePanel.RefreshButton.backdrop:ClearAllPoints()
            BrowsePanel.RefreshButton.backdrop:SetOutside(BrowsePanel.RefreshButton, -1, -1)
        end

        if BrowsePanel.AdvButton then
            ES:HandleButton(BrowsePanel.AdvButton)
            BrowsePanel.AdvButton.backdrop:ClearAllPoints()
            BrowsePanel.AdvButton.backdrop:SetOutside(BrowsePanel.AdvButton, -1, -1)
        end

        if BrowsePanel.SignUpButton then
            ES:HandleButton(BrowsePanel.SignUpButton)
        end

        if BrowsePanel.ActivityDropdown then
            BrowsePanel.ActivityDropdown:StripTextures()
            BrowsePanel.ActivityDropdown:CreateBackdrop("Transparent")
            BrowsePanel.ActivityDropdown.backdrop:ClearAllPoints()
            BrowsePanel.ActivityDropdown.backdrop:SetOutside(BrowsePanel.ActivityDropdown, 1, -3)
            ES:HandleNextPrevButton(BrowsePanel.ActivityDropdown.MenuButton)
        end
    end
end

S:AddCallbackForAddon("MeetingStone")
S:DisableAddOnSkin("MeetingStone")
