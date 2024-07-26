local W, F, E, L = unpack((select(2, ...)))
local MB = W:NewModule("MinimapButtons", "AceEvent-3.0", "AceHook-3.0")
local S = W.Modules.Skins
local EM = E:GetModule("Minimap")

local _G = _G
local ceil = ceil
local floor = floor
local min = min
local pairs = pairs
local print = print
local select = select
local sort = sort
local strfind = strfind
local strlen = strlen
local strsub = strsub
local tinsert = tinsert
local tremove = tremove
local type = type
local unpack = unpack

local CreateFrame = CreateFrame
local GetSpellInfo = C_Spell.GetSpellInfo
local InCombatLockdown = InCombatLockdown
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

-- 忽略列表
local IgnoreList = {
    full = {
        "AsphyxiaUIMinimapHelpButton",
        "AsphyxiaUIMinimapVersionButton",
        "ElvConfigToggle",
        "ElvUIConfigToggle",
        "ElvUI_ConsolidatedBuffs",
        "HelpOpenTicketButton",
        "ElvUI_MinimapHolder",
        "DroodFocusMinimapButton",
        "TimeManagerClockButton",
        "MinimapZoneTextButton"
    },
    libDBIcon = {},
    startWith = {
        "Archy",
        "GatherMatePin",
        "GatherNote",
        "GuildInstance",
        "HandyNotesPin",
        "MinimMap",
        "Spy_MapNoteList_mini",
        "ZGVMarker",
        "poiMinimap",
        "GuildMap3Mini",
        "LibRockConfig-1.0_MinimapButton",
        "NauticusMiniIcon",
        "WestPointer",
        "Cork",
        "DugisArrowMinimapPoint",
        "TTMinimapButton",
        "QueueStatusButton"
    },
    partial = {
        "Node",
        "Note",
        "Pin",
        "POI"
    }
}

local TexCoordIgnoreList = {
    ["Narci_MinimapButton"] = true,
    ["ZygorGuidesViewerMapIcon"] = true
}

-- 框架名白名单
local whiteList = {}

local acceptedFrames = {
    "BagSync_MinimapButton"
}

local moveButtons = {}

function MB:HandleLibDBIconButton(button, name)
    if not strsub(name, 1, strlen("LibDBIcon")) == "LibDBIcon" then
        return true
    end

    if not button.Show or not button.Hide or not button.IsShown then
        return true
    end

    self:SecureHook(
        button,
        "Hide",
        function()
            for i, moveButtonName in pairs(moveButtons) do
                if name == moveButtonName then
                    tremove(moveButtons, i)
                    break
                end
            end

            self:UpdateLayout()
        end
    )

    self:SecureHook(
        button,
        "Show",
        function()
            for _, moveButtonName in pairs(moveButtons) do
                if name == moveButtonName then
                    return
                end
            end

            tinsert(moveButtons, name)
            self:UpdateLayout()
        end
    )

    return button:IsShown()
end

do
    local modified = false
    function MB:UpdateExpansionLandingPageMinimapIcon(icon)
        icon = icon or _G.ExpansionLandingPageMinimapButton

        if not icon then
            return
        end
        icon:SetIgnoreParentScale(true)
        icon:SetScale(E.uiscale)

        local box = _G.GarrisonLandingPageTutorialBox
        if box then
            box:SetScale(E.uiscale)
            box:SetClampedToScreen(true)
        end

        if not modified then
            icon.AlertText:Hide()
            icon.AlertText:SetAlpha(0)
            icon.AlertText.Show = E.noop
            icon.AlertText.Hide = E.noop

            icon.AlertBG:SetAlpha(0)
            icon.AlertBG:Hide()
            icon.AlertBG.Show = E.noop
            icon.AlertBG.Hide = E.noop

            icon.AlertText.SetText = function(_, text)
                if text then
                    print(F.CreateColorString(icon.title or L["Garrison"], E.db.general.valuecolor) .. ": " .. text)
                end
            end

            modified = true
        end

        self:UpdateLayout()
    end
end

do
    local originalFunction = EM.HandleExpansionButton
    function EM:HandleExpansionButton()
        local icon = _G.ExpansionLandingPageMinimapButton

        if not icon or not icon.isWindMinimapButton or InCombatLockdown() then
            return originalFunction(self)
        else
            return MB:UpdateExpansionLandingPageMinimapIcon(icon)
        end
    end
end

function MB:SetButtonMouseOver(button, frame, rawhook)
    if not frame.HookScript then
        return
    end

    local function ButtonOnEnter()
        if button.backdrop.SetBackdropBorderColor then
            button.backdrop:SetBackdropBorderColor(
                E.db.general.valuecolor.r,
                E.db.general.valuecolor.g,
                E.db.general.valuecolor.b
            )
        end
        if not self.db.mouseOver then
            return
        end
        E:UIFrameFadeIn(self.bar, (1 - self.bar:GetAlpha()) * 0.382, self.bar:GetAlpha(), 1)
    end

    local function ButtonOnLeave()
        if button.backdrop.SetBackdropBorderColor then
            button.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
        end
        if not self.db.mouseOver then
            return
        end
        E:UIFrameFadeOut(self.bar, self.bar:GetAlpha() * 0.382, self.bar:GetAlpha(), 0)
    end

    if not rawhook then
        frame:HookScript("OnEnter", ButtonOnEnter)
        frame:HookScript("OnLeave", ButtonOnLeave)
    else
        local OriginalOnEnter = frame:GetScript("OnEnter") or E.noop
        local OriginalOnLeave = frame:GetScript("OnLeave") or E.noop
        frame:SetScript(
            "OnEnter",
            function()
                OriginalOnEnter(frame)
                ButtonOnEnter()
            end
        )
        frame:SetScript(
            "OnLeave",
            function()
                OriginalOnLeave(frame)
                ButtonOnLeave()
            end
        )
    end
end

function MB:SkinButton(frame)
    tinsert(IgnoreList.full, "GameTimeFrame")

    if frame == nil or frame:GetName() == nil or not frame:IsVisible() then
        return
    end
    local tmp
    local frameType = frame:GetObjectType()
    if frameType == "Button" then
        tmp = 1
    elseif frameType == "Frame" then
        for _, f in pairs(acceptedFrames) do
            if frame:GetName() == f then
                tmp = 2
                break
            end
        end
    end
    if not tmp then
        return
    end

    local name = frame:GetName()
    local validIcon = false

    for i = 1, #whiteList do
        if strsub(name, 1, strlen(whiteList[i])) == whiteList[i] then
            validIcon = true
            break
        end
    end

    if strsub(name, 1, strlen("LibDBIcon")) == "LibDBIcon" then
        validIcon = true
        for _, ignoreName in pairs(IgnoreList.libDBIcon) do
            if strsub(name, strlen("LibDBIcon10_") + 1) == ignoreName then
                return
            end
        end
    end

    if not validIcon then
        for _, ignoreName in pairs(IgnoreList.full) do
            if name == ignoreName then
                return
            end
        end

        for _, ignoreName in pairs(IgnoreList.startWith) do
            if strsub(name, 1, strlen(ignoreName)) == ignoreName then
                return
            end
        end

        for _, ignoreName in pairs(IgnoreList.partial) do
            if strfind(name, ignoreName) ~= nil then
                return
            end
        end
    end

    -- If the relative frame is Minimap, then replace it to fake Minimap
    -- It must run before FarmHud moving the Minimap
    if C_AddOns_IsAddOnLoaded("FarmHud") then
        if frame.SetPoint and not frame.__SetPoint then
            frame.__SetPoint = frame.SetPoint
            frame.SetPoint = function(btn, ...)
                local point, relativeTo, relativePoint, xOfs, yOfs = ...
                if relativeTo == _G.Minimap then
                    return
                end
                relativeTo = relativeTo == _G.Minimap and self.fakeMinimap or relativeTo
                frame.__SetPoint(btn, point, relativeTo, relativePoint, xOfs, yOfs)
            end
        end
    end

    if name == "DBMMinimapButton" then
        frame:SetNormalTexture("Interface\\Icons\\INV_Helmet_87")
    elseif name == "SmartBuff_MiniMapButton" then
        frame:SetNormalTexture(select(3, GetSpellInfo(12051)))
    elseif name == "ExpansionLandingPageMinimapButton" then
        if self.db.garrison then
            if not frame.isWindMinimapButton then
                frame.isWindMinimapButton = true
                self:UpdateExpansionLandingPageMinimapIcon(_G.ExpansionLandingPageMinimapButton)
            end
        end
    elseif name == "GRM_MinimapButton" then
        frame.GRM_MinimapButtonBorder:Hide()
        frame:SetPushedTexture("")
        frame:SetHighlightTexture("")
        frame.SetPushedTexture = E.noop
        frame.SetHighlightTexture = E.noop
        if frame:HasScript("OnEnter") then
            self:SetButtonMouseOver(frame, frame, true)
            frame.OldSetScript = frame.SetScript
            frame.SetScript = E.noop
        end
    elseif strsub(name, 1, strlen("TomCats-")) == "TomCats-" then
        frame:SetPushedTexture("")
        frame:SetDisabledTexture("")
        frame:GetHighlightTexture():Kill()
    elseif tmp ~= 2 then
        frame:SetPushedTexture("")
        frame:SetDisabledTexture("")
        frame:SetHighlightTexture("")
    end

    if not frame.isSkinned then
        if tmp ~= 2 then
            frame:HookScript("OnClick", self.DelayedUpdateLayout)
        end
        for _, region in pairs({frame:GetRegions()}) do
            local original = {}
            original.Width, original.Height = frame:GetSize()
            original.Point, original.relativeTo, original.relativePoint, original.xOfs, original.yOfs = frame:GetPoint()
            original.Parent = frame:GetParent()
            original.FrameStrata = frame:GetFrameStrata()
            original.FrameLevel = frame:GetFrameLevel()
            original.Scale = frame:GetScale()
            if frame:HasScript("OnDragStart") then
                original.DragStart = frame:GetScript("OnDragStart")
            end
            if frame:HasScript("OnDragStop") then
                original.DragEnd = frame:GetScript("OnDragStop")
            end

            frame.original = original

            -- TODO: Handling calendar
            if region:IsObjectType("Texture") then
                local t = region:GetTexture()

                -- Remove rings and backdrops of LibDBIcon icons
                if t and strsub(name, 1, strlen("LibDBIcon")) == "LibDBIcon" then
                    if region ~= frame.icon then
                        region:SetTexture(nil)
                    end
                end

                if
                    t and type(t) ~= "number" and
                        (strfind(t, "Border") or strfind(t, "Background") or strfind(t, "AlphaMask"))
                 then
                    region:SetTexture(nil)
                else
                    if name == "BagSync_MinimapButton" then
                        region:SetTexture("Interface\\AddOns\\BagSync\\media\\icon")
                    end

                    if not TexCoordIgnoreList[name] then
                        region:SetTexCoord(0.1, 0.9, 0.1, 0.9)
                    end

                    region:ClearAllPoints()
                    region:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
                    region:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
                    region:SetDrawLayer("ARTWORK")

                    if (name == "PS_MinimapButton") then
                        region.SetPoint = E.noop
                    end
                end
            end
        end

        if frame.backdrop then
            if name == "LibDBIcon10_Musician" then
                frame.backdrop:Kill()
                frame.backdrop = nil
            end
        end

        frame:CreateBackdrop("Tranparent")
        if E.private.WT.skins.enable and E.private.WT.skins.windtools and E.private.WT.skins.shadow then
            S:CreateBackdropShadow(frame)
        end

        self:SetButtonMouseOver(frame, frame)

        if name == "Narci_MinimapButton" then
            self:SetButtonMouseOver(frame, frame.Panel)
            for _, child in pairs {frame.Panel:GetChildren()} do
                if child.SetScript and not child.Highlight then
                    self:SetButtonMouseOver(frame, child, true)
                end
            end
        elseif name == "TomCats-MinimapButton" then
            if _G["TomCats-MinimapButtonBorder"] then
                _G["TomCats-MinimapButtonBorder"]:SetAlpha(0)
            end
            if _G["TomCats-MinimapButtonBackground"] then
                _G["TomCats-MinimapButtonBackground"]:SetAlpha(0)
            end
            if _G["TomCats-MinimapButtonIcon"] then
                _G["TomCats-MinimapButtonIcon"]:ClearAllPoints()
                _G["TomCats-MinimapButtonIcon"]:SetInside(frame.backdrop)
                _G["TomCats-MinimapButtonIcon"].SetPoint = E.noop
                _G["TomCats-MinimapButtonIcon"]:SetTexCoord(0, 0.65, 0, 0.65)
            end
        end

        frame.isSkinned = true

        if self:HandleLibDBIconButton(frame, name) then
            tinsert(moveButtons, name)
        end
    end
end

function MB.DelayedUpdateLayout()
    if MB.db.orientation ~= "NOANCHOR" then
        E:Delay(1, MB.UpdateLayout, MB)
    end
end

function MB:UpdateLayout()
    if not self.db.enable then
        return
    end

    if InCombatLockdown() then
        self:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateLayout")
        return
    else
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end

    sort(moveButtons)

    local buttonsPerRow = self.db.buttonsPerRow
    local numOfRows = ceil(#moveButtons / buttonsPerRow)
    local spacing = self.db.spacing
    local backdropSpacing = self.db.backdropSpacing
    local buttonSize = self.db.buttonSize
    local direction = not self.db.inverseDirection

    -- 更新按钮
    local buttonX, buttonY, anchor, offsetX, offsetY

    for i, moveButton in pairs(moveButtons) do
        local frame = _G[moveButton]

        if self.db.orientation == "NOANCHOR" then
            local original = frame.original
            frame:SetParent(original.Parent)
            if original.DragStart then
                frame:SetScript("OnDragStart", original.DragStart)
            end
            if original.DragEnd then
                frame:SetScript("OnDragStop", original.DragEnd)
            end

            frame:ClearAllPoints()
            frame:SetSize(original.Width, original.Height)

            if original.Point ~= nil then
                frame:SetPoint(
                    original.Point,
                    original.relativeTo,
                    original.relativePoint,
                    original.xOfs,
                    original.yOfs
                )
            else
                frame:SetPoint("CENTER", _G.Minimap, "CENTER", -80, -34)
            end
            frame:SetFrameStrata(original.FrameStrata)
            frame:SetFrameLevel(original.FrameLevel)
            frame:SetScale(original.Scale)
            frame:SetMovable(true)
        else
            -- 找到默认布局下的 X 行 Y 列 （从 1 开始）
            buttonX = i % buttonsPerRow
            buttonY = floor(i / buttonsPerRow) + 1

            if buttonX == 0 then
                buttonX = buttonsPerRow
                buttonY = buttonY - 1
            end

            frame:SetParent(self.bar)
            frame:SetMovable(false)
            frame:SetScript("OnDragStart", nil)
            frame:SetScript("OnDragStop", nil)

            frame:ClearAllPoints()
            frame:SetFrameStrata("LOW")
            frame:SetFrameLevel(20)
            frame:SetSize(buttonSize, buttonSize)
            offsetX = backdropSpacing + (buttonX - 1) * (buttonSize + spacing)
            offsetY = backdropSpacing + (buttonY - 1) * (buttonSize + spacing)

            if self.db.orientation == "HORIZONTAL" then
                if direction then
                    anchor = "TOPLEFT"
                    offsetY = -offsetY
                else
                    anchor = "TOPRIGHT"
                    offsetX, offsetY = -offsetX, -offsetY
                end
            else
                if direction then
                    anchor = "TOPLEFT"
                    offsetX, offsetY = offsetY, -offsetX
                else
                    anchor = "BOTTOMLEFT"
                    offsetX, offsetY = offsetY, offsetX
                end
            end

            frame:ClearAllPoints()
            frame:SetPoint(anchor, self.bar, anchor, offsetX, offsetY)
        end

        if
            E.private.WT.skins.enable and E.private.WT.skins.windtools and E.private.WT.skins.shadow and
                frame.backdrop.shadow
         then
            if not self.db.backdrop then
                frame.backdrop.shadow:Show()
            else
                frame.backdrop.shadow:Hide()
            end
        end

        if moveButton == "GameTimeFrame" then
            frame.windToday:ClearAllPoints()
            frame.windToday:SetPoint("CENTER", frame, "CENTER", 0, -0.15 * buttonSize)
        end
    end

    -- 更新条
    buttonsPerRow = min(buttonsPerRow, #moveButtons)

    if self.db.orientation ~= "NOANCHOR" and #moveButtons > 0 then
        local width = buttonSize * buttonsPerRow + spacing * (buttonsPerRow - 1) + backdropSpacing * 2
        local height = buttonSize * numOfRows + spacing * (numOfRows - 1) + backdropSpacing * 2

        if self.db.orientation == "VERTICAL" then
            width, height = height, width
        end

        self.bar:SetSize(width, height)
        self.barAnchor:SetSize(width, height)
        RegisterStateDriver(self.bar, "visibility", "[petbattle]hide;show")
        self.bar:Show()
    else
        UnregisterStateDriver(self.bar, "visibility")
        self.bar:Hide()
    end

    if self.db.orientation == "HORIZONTAL" then
        anchor = direction and "LEFT" or "RIGHT"
    else
        anchor = direction and "TOP" or "BOTTOM"
    end

    self.bar:SetPoint(anchor, self.barAnchor, anchor, 0, 0)

    if self.db.backdrop then
        self.bar.backdrop:Show()
    else
        self.bar.backdrop:Hide()
    end
end

function MB:SkinMinimapButtons()
    self:RegisterEvent("ADDON_LOADED", "StartSkinning")

    for _, child in pairs({_G.Minimap:GetChildren()}) do
        self:SkinButton(child)
    end

    if self.db.expansionLandingPage then
        self:SkinButton(_G.ExpansionLandingPageMinimapButton)
    end

    self:UpdateLayout()
end

function MB:UpdateMouseOverConfig()
    -- 鼠标显隐功能
    if self.db.mouseOver then
        self.bar:SetScript(
            "OnEnter",
            function(self)
                E:UIFrameFadeIn(self, (1 - self:GetAlpha()) * 0.382, self:GetAlpha(), 1)
            end
        )

        self.bar:SetScript(
            "OnLeave",
            function(self)
                E:UIFrameFadeOut(self, self:GetAlpha() * 0.382, self:GetAlpha(), 0)
            end
        )

        self.bar:SetAlpha(0)
    else
        self.bar:SetScript("OnEnter", nil)
        self.bar:SetScript("OnLeave", nil)
        self.bar:SetAlpha(1)
    end
end

function MB:StartSkinning()
    self:UnregisterEvent("ADDON_LOADED")
    E:Delay(5, self.SkinMinimapButtons, self)
end

function MB:CreateFrames()
    if self.bar then
        return
    end

    local frame = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
    frame:SetPoint("TOPRIGHT", EM.MapHolder, "BOTTOMRIGHT", 0, -5)
    frame:SetFrameStrata("BACKGROUND")
    self.barAnchor = frame

    frame = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
    frame:SetFrameStrata("LOW")
    frame:CreateBackdrop("Transparent")
    frame:ClearAllPoints()
    frame:SetPoint("CENTER", self.barAnchor, "CENTER", 0, 0)
    self.bar = frame

    self:SkinMinimapButtons()

    S:CreateShadowModule(self.bar.backdrop)
    S:MerathilisUISkin(self.bar.backdrop)

    E:CreateMover(
        self.barAnchor,
        "WTMinimapButtonBarAnchor",
        L["Minimap Buttons Bar"],
        nil,
        nil,
        nil,
        "ALL,WINDTOOLS",
        function()
            return E.private.WT.maps.minimapButtons.enable
        end,
        "WindTools,maps,minimapButtons"
    )
end

function MB:SetUpdateHook()
    if not self.initialized then
        self:SecureHook(EM, "SetGetMinimapShape", "UpdateLayout")
        self:SecureHook(EM, "UpdateSettings", "UpdateLayout")
        self:SecureHook(E, "UpdateAll", "UpdateLayout")
        self.initialized = true
    end
end

function MB:PLAYER_ENTERING_WORLD()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:SetUpdateHook()
    E:Delay(1, self.SkinMinimapButtons, self)
end

function MB:Initialize()
    self.db = E.private.WT.maps.minimapButtons
    if not self.db.enable then
        return
    end

    self:CreateFrames()
    self:UpdateMouseOverConfig()

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

W:RegisterModule(MB:GetName())
