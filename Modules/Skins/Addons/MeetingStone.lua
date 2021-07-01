local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")

local hooksecurefunc = hooksecurefunc
local pairs = pairs
local type = type

local CreateFrame = CreateFrame
local LibStub = LibStub

local NEG
local module

local function SkinViaRawHook(object, method, func, noLabel)
    local NetEaseGUI = LibStub("NetEaseGUI-2.0")
    local module = NetEaseGUI and NetEaseGUI:GetClass(object)
    if module and module[method] then
        local original = module[method]
        module[method] = function(self, ...)
            original(self, ...)
            if noLabel then
                func(self, ...)
            else
                if not self.windStyle then
                    func(self, ...)
                    self.windStyle = true
                end
            end
        end
    end
end

local function SkinDropDown(self)
    if self.windStyle then
        return
    end
    self:StripTextures()
    self:CreateBackdrop("Transparent")
    self.backdrop:ClearAllPoints()
    self.backdrop:SetOutside(self, 1, -3)
    ES:HandleNextPrevButton(self.MenuButton, "down")
    self.windStyle = true
end

local function SkinListTitle(self)
    if self.windStyle then
        return
    end

    for _, button in pairs(self.sortButtons) do
        button:StripTextures()
        ES:HandleButton(button, nil, nil, nil, true, "Transparent")
        button.backdrop:ClearAllPoints()
        button.backdrop:SetOutside(button, -2, 0)
    end

    local scrollBar = self:GetScrollBar()

    if scrollBar then
        ES:HandleNextPrevButton(scrollBar.ScrollUpButton, "up")
        ES:HandleNextPrevButton(scrollBar.ScrollDownButton, "down")
        ES:HandleScrollBar(scrollBar)
    end

    self.windStyle = true
end

function S:MeetingStone()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.meetingStone then
        return
    end

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
        self:CreateShadow(MainPanel)
        self:MerathilisUISkin(MainPanel)
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
    SkinViaRawHook(
        "BottomTabButton",
        "SetStatus",
        function(self)
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
            S:CreateBackdropShadow(self)
            S:MerathilisUITab(self)
        end
    )

    -- DropMenu
    SkinViaRawHook(
        "DropMenu",
        "Open",
        function(self, level)
            level = level or 1
            local menu = self.menuList[level]
            if menu and not menu.windStyle then
                menu:StripTextures()
                menu:CreateBackdrop()
                self.windStyle = true
            end
        end,
        true
    )

    -- DropMenuItem
    SkinViaRawHook(
        "DropMenuItem",
        "SetHasArrow",
        function(self)
            if self.Arrow then
                self.Arrow:SetTexture(E.Media.Textures.ArrowUp)
                self.Arrow:SetRotation(ES.ArrowRotation.right)
                self.Arrow:SetVertexColor(1, 1, 1)
            end
        end
    )

    -- Scroll Bar
    SkinViaRawHook(
        "PageScrollBar",
        "Constructor",
        function(self)
            ES:HandleScrollBar(self)
        end
    )

    -- List elements
    SkinViaRawHook(
        "ListView",
        "UpdateItems",
        function(self)
            for i = 1, #self.buttons do
                local button = self:GetButton(i)
                if button:IsShown() and not button.windStyle then
                    button:StripTextures()
                    if button.Icon then -- prevent cause error in ElvUI Skin functions
                        button.Icon.GetTexture = button.Icon.GetTexture or E.noop
                    end
                    ES:HandleButton(button)

                    local selectedTex = button.backdrop:CreateTexture(nil)
                    local classColor = E:ClassColor(E.myclass)
                    selectedTex:SetTexture(E.media.blankTex)
                    selectedTex:SetVertexColor(classColor.r, classColor.g, classColor.b, 0.25)
                    selectedTex:SetInside()
                    selectedTex:Hide()
                    button.backdrop.selectedTex = selectedTex

                    hooksecurefunc(
                        button,
                        "SetChecked",
                        function(_, isChecked)
                            if isChecked then
                                selectedTex:Show()
                            else
                                selectedTex:Hide()
                            end
                        end
                    )

                    button.windStyle = true
                end
            end
        end,
        true
    )

    -- Browse Panel (查找活动)
    local BrowsePanel = NEG.BrowsePanel
    if BrowsePanel then
        if BrowsePanel.RefreshButton then
            ES:HandleButton(BrowsePanel.RefreshButton, nil, nil, nil, true, "Transparent")
            BrowsePanel.RefreshButton.backdrop:ClearAllPoints()
            BrowsePanel.RefreshButton.backdrop:SetOutside(BrowsePanel.RefreshButton, -1, -1)
        end

        if BrowsePanel.AdvButton then
            ES:HandleButton(BrowsePanel.AdvButton, nil, nil, nil, true, "Transparent")
            BrowsePanel.AdvButton.backdrop:ClearAllPoints()
            BrowsePanel.AdvButton.backdrop:SetOutside(BrowsePanel.AdvButton, -1, -1)
        end

        if BrowsePanel.SignUpButton then
            ES:HandleButton(BrowsePanel.SignUpButton, nil, nil, nil, true, "Transparent")
        end

        if BrowsePanel.ActivityDropdown then
            SkinDropDown(BrowsePanel.ActivityDropdown)
        end

        if BrowsePanel.ActivityList then
            SkinListTitle(BrowsePanel.ActivityList)
        end

        if BrowsePanel.NoResultBlocker then
            ES:HandleButton(BrowsePanel.NoResultBlocker.Button, nil, nil, nil, true, "Transparent")
            F.SetFontOutline(BrowsePanel.NoResultBlocker.Label)
        end

        if BrowsePanel.AdvFilterPanel then
            local panel = BrowsePanel.AdvFilterPanel
            ES:HandlePortraitFrame(panel)
            S:CreateBackdropShadow(panel, true)
            for _, child in pairs {panel:GetChildren()} do
                if child.GetObjectType and child:GetObjectType() == "Button" then
                    if child.GetText and child:GetText() ~= "" and child:GetText() ~= nil then
                        ES:HandleButton(child, nil, nil, nil, true, "Transparent")
                        child.backdrop:ClearAllPoints()
                        child.backdrop:SetOutside(child, -1, 0)
                    else
                        ES:HandleCloseButton(child)
                    end
                end
            end

            for _, child in pairs {panel.Inset:GetChildren()} do
                if child.Check and child.MaxBox and child.MinBox then
                    ES:HandleCheckBox(child.Check)
                    child.MaxBox:StripTextures()
                    ES:HandleEditBox(child.MaxBox)
                    child.MinBox:StripTextures()
                    ES:HandleEditBox(child.MinBox)
                end
            end
        end
    end

    -- Manager Panel (管理活动)
    local ManagerPanel = NEG.ManagerPanel
    if ManagerPanel then
        for _, child in pairs {ManagerPanel:GetChildren()} do
            if child.CreateWidget then
                ManagerPanel.LeftPart = child
            elseif child.ApplicantList then
                ManagerPanel.RightPart = child
            end
        end

        if ManagerPanel.RefreshButton then
            ES:HandleButton(ManagerPanel.RefreshButton, nil, nil, nil, true, "Transparent")
            ManagerPanel.RefreshButton.backdrop:ClearAllPoints()
            ManagerPanel.RefreshButton.backdrop:SetOutside(ManagerPanel.RefreshButton, -1, -2)
        end

        for _, child in pairs {ManagerPanel.LeftPart:GetChildren()} do
            if child:GetNumRegions() == 3 then
                for _, region in pairs {child:GetRegions()} do
                    if region.GetObjectType and region:GetObjectType() == "Texture" then
                        if region.GetTexture then
                            local tex = region:GetTexture()
                            if tex and tex == "Interface\\FriendsFrame\\UI-ChannelFrame-VerticalBar" then
                                child:StripTextures()
                                break
                            end
                        end
                    end
                end
            end
        end

        if ManagerPanel.LeftPart and ManagerPanel.LeftPart.CreateButton then
            ES:HandleButton(ManagerPanel.LeftPart.CreateButton, nil, nil, nil, true, "Transparent")
        end

        if ManagerPanel.LeftPart and ManagerPanel.LeftPart.DisbandButton then
            ES:HandleButton(ManagerPanel.LeftPart.DisbandButton, nil, nil, nil, true, "Transparent")
        end

        if ManagerPanel.LeftPart and ManagerPanel.LeftPart.CreateWidget then
            for _, child in pairs {ManagerPanel.LeftPart.CreateWidget:GetChildren()} do
                for _, subChild in pairs {child:GetChildren()} do
                    if subChild.MenuButton and subChild.Text then
                        SkinDropDown(subChild)
                    elseif subChild.tLeft and subChild.tRight then
                        for _, region in pairs {subChild:GetRegions()} do
                            if region.GetObjectType and region:GetObjectType() == "Texture" then
                                if region.GetTexture then
                                    local tex = region:GetTexture()
                                    if tex and tex == "Interface\\Common\\Common-Input-Border" then
                                        region:StripTextures()
                                    end
                                end
                            end
                        end
                        ES:HandleEditBox(subChild)
                        subChild.backdrop:ClearAllPoints()
                        subChild.backdrop:SetOutside(subChild, -1, -2)
                    elseif subChild:GetObjectType() == "CheckButton" then
                        ES:HandleCheckBox(subChild)
                    end
                end
            end
        end

        if ManagerPanel.RightPart and ManagerPanel.RightPart.ApplicantList then
            SkinListTitle(ManagerPanel.RightPart.ApplicantList)
        end
    end

    -- Recent Panel (最近玩友)
    local RecentPanel = NEG.RecentPanel
    if RecentPanel then
        if RecentPanel.ActivityDropdown then
            SkinDropDown(RecentPanel.ActivityDropdown)
        end

        if RecentPanel.ClassDropdown then
            SkinDropDown(RecentPanel.ClassDropdown)
        end

        if RecentPanel.RoleDropdown then
            SkinDropDown(RecentPanel.RoleDropdown)
        end

        if RecentPanel.SearchInput then
            for _, region in pairs {RecentPanel.SearchInput:GetRegions()} do
                if region.GetObjectType and region:GetObjectType() == "Texture" then
                    if region.GetTexture then
                        local tex = region:GetTexture()
                        if tex and tex == "Interface\\Common\\Common-Input-Border" then
                            region:StripTextures()
                        end
                    end
                end
            end
            ES:HandleEditBox(RecentPanel.SearchInput)
        end

        if RecentPanel.BatchDeleteButton then
            ES:HandleButton(RecentPanel.BatchDeleteButton, nil, nil, nil, true, "Transparent")
        end

        if RecentPanel.MemberList then
            SkinListTitle(RecentPanel.MemberList)
        end
    end

    -- Broker Panel (悬浮框)
    local BrokerPanel = NEG.DataBroker.BrokerPanel
    if BrokerPanel then
        BrokerPanel:SetBackdrop(nil)
        BrokerPanel:CreateBackdrop("Transparent")
        self:CreateBackdropShadow(BrokerPanel)
        self:MerathilisUISkin(BrokerPanel)
    end
end

S:AddCallbackForAddon("MeetingStone")
S:AddCallbackForAddon("MeetingStonePlus", "MeetingStone")
S:DisableAddOnSkin("MeetingStone")
