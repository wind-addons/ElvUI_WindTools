local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")

local module

local function SkinViaRawHook(object, method, func)
    local NetEaseGUI = LibStub("NetEaseGUI-2.0")
    local module = NetEaseGUI and NetEaseGUI:GetClass(object)
    if module and module[method] then
        local original = module[method]
        module[method] = function(self, ...)
            original(self, ...)
            if not self.windStyle then
                func(self, ...)
                self.windStyle = true
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
    ES:HandleNextPrevButton(self.MenuButton)
    self.windStyle = true
end

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
            S:CreateShadow(self.backdrop)
        end
    )

    -- DropMenu
    module = NetEaseGUI:GetClass("DropMenu")
    if module and module.Open then
        local OpenOld = module.Open
        function module:Open(level, menuTable, owner, ...)
            OpenOld(self, level, menuTable, owner, ...)
            level = level or 1
            local menu = self.menuList[level]
            if menu and not menu.windStyle then
                menu:StripTextures()
                menu:CreateBackdrop()
                self.windStyle = true
            end
        end
    end

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
            SkinDropDown(BrowsePanel.ActivityDropdown)
        end

        if BrowsePanel.NoResultBlocker then
            ES:HandleButton(BrowsePanel.NoResultBlocker.Button)
            F.SetFontOutline(BrowsePanel.NoResultBlocker.Label)
        end

        if BrowsePanel.AdvFilterPanel then
            local panel = BrowsePanel.AdvFilterPanel
            ES:HandlePortraitFrame(panel)
            S:CreateShadow(panel.backdrop)
            for _, child in pairs {panel:GetChildren()} do
                if child.GetObjectType and child:GetObjectType() == "Button" then
                    if child.GetText and child:GetText() ~= "" and child:GetText() ~= nil then
                        ES:HandleButton(child)
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
            ES:HandleButton(RecentPanel.BatchDeleteButton)
        end
    end
end

S:AddCallbackForAddon("MeetingStone")
S:DisableAddOnSkin("MeetingStone")
