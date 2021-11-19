local W, F, E, L = unpack(select(2, ...))
local ES = E:GetModule("Skins")
local S = W:GetModule("Skins")

local _G = _G
local gsub = gsub
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local strfind = strfind
local strlower = strlower
local tinsert = tinsert
local type = type
local unpack = unpack
local wipe = wipe

local IsAddOnLoaded = IsAddOnLoaded

local buttons = {}
local expandButtons = {}

local function RemoveBorder(frame)
    for _, region in pairs {frame:GetRegions()} do
        if region:GetObjectType() == "Texture" then
            local tex = region:GetTexture()
            if tex and strfind(strlower(tex), "quickslot2") then
                region:Kill()
            end
        end
    end
end

function S:WeakAuras_RegisterRegionOptions(name, createFunction, icon, displayName, createThumbnail, ...)
    if type(icon) == "function" then
        local OldIcon = icon
        icon = function()
            local f = OldIcon()
            RemoveBorder(f)
            return f
        end
    end

    if type(createThumbnail) == "function" then
        local OldCreateThumbnail = createThumbnail
        createThumbnail = function()
            local f = OldCreateThumbnail()
            RemoveBorder(f)
            return f
        end
    end

    self.hooks[_G.WeakAuras]["RegisterRegionOptions"](name, createFunction, icon, displayName, createThumbnail, ...)
end

local function ReskinNormalButton(button, next)
    if button.Left and button.Middle and button.Right and button.Text then
        ES:HandleButton(button)
    end
    if next then
        for _, child in pairs {button:GetChildren()} do
            if child:GetObjectType() == "Button" then
                ReskinNormalButton(child)
            end
        end
    end
end

local function ReskinChildButton(frame)
    for _, child in pairs {frame:GetChildren()} do
        if child:GetObjectType() == "Button" then
            ReskinNormalButton(child, true)
        end
    end
end

local function ApplyTextureCoords(tex, force)
    if not tex or not tex.SetTexCoord then
        return
    end

    if tex.windTexCoords and not force then
        return
    end

    tex:SetTexCoord(unpack(E.TexCoords))
    tex.windTexCoords = true
end

function S:WeakAurasMultiLineEditBox(Constructor)
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.weakAurasOptions then
        return Constructor
    end

    local function SkinedConstructor()
        local widget = Constructor()
        ES:HandleButton(widget.button)

        widget.scrollBG:SetAlpha(0)
        widget.scrollFrame:StripTextures()
        ES:HandleScrollBar(widget.scrollBar)

        widget.editBox:DisableDrawLayer("BACKGROUND")
        widget.frame:CreateBackdrop()
        widget.frame.backdrop:ClearAllPoints()
        widget.frame.backdrop:SetFrameLevel(widget.frame:GetFrameLevel())
        widget.frame.backdrop:Point("TOPLEFT", widget.scrollFrame, "TOPLEFT", -5, 2)
        widget.frame.backdrop:Point("BOTTOMRIGHT", widget.scrollFrame, "BOTTOMRIGHT", 0, 0)

        local onShow = widget.frame:GetScript("OnShow")
        widget.frame:SetScript(
            "OnShow",
            function(frame)
                onShow(frame)
                if frame.windStyle then
                    return
                end
                local self = frame.obj
                local option = self.userdata.option
                local numExtraButtons = 0
                if option and option.arg and option.arg.extraFunctions then
                    numExtraButtons = #option.arg.extraFunctions
                    for i = 1, #option.arg.extraFunctions do
                        ES:HandleButton(self.extraButtons[i])
                    end
                end
                frame.windStyle = true
            end
        )
        return widget
    end

    return SkinedConstructor
end

function S:WeakAurasDisplayButton(Constructor)
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.weakAurasOptions then
        return Constructor
    end

    local function SkinedConstructor()
        local widget = Constructor()
        if widget.background then
            ES:HandleButton(widget.frame, nil, nil, nil, true, "Transparent")
            widget.frame.background:SetAlpha(0)
            widget.frame.backdrop:SetFrameLevel(widget.frame:GetFrameLevel())
            widget.frame.backdrop.color = {widget.frame.backdrop.Center:GetVertexColor()}

            hooksecurefunc(
                widget.frame.background,
                "Hide",
                function()
                    widget.frame.backdrop.Center:SetVertexColor(1, 0, 0, 0.3)
                end
            )

            hooksecurefunc(
                widget.frame.background,
                "Show",
                function()
                    widget.frame.backdrop.Center:SetVertexColor(unpack(widget.frame.backdrop.color))
                end
            )
        end

        ApplyTextureCoords(widget.icon)

        if widget.renamebox then
            ES:HandleEditBox(widget.renamebox)
        end

        if widget.frame.highlight then
            widget.frame.highlight:SetTexture(E.media.blankTex)
            widget.frame.highlight:SetVertexColor(1, 1, 1, 0.15)
            widget.frame.highlight:SetInside()
        end

        -- Set Icon (Generally, Weakauras call this function to update the icon)
        if widget.SetIcon then
            local SetIcon = widget.SetIcon
            widget.SetIcon = function(frame, icon)
                SetIcon(frame, icon)
                if frame.iconRegion then
                    ApplyTextureCoords(frame.iconRegion.icon, true)
                end
            end
        end

        -- Update Thumbnail (After picking up the new icon for this aura, Weakauras will call this function)
        if widget.UpdateThumbnail then
            local UpdateThumbnail = widget.UpdateThumbnail
            widget.UpdateThumbnail = function(frame)
                UpdateThumbnail(frame)
                if frame.thumbnail then
                    ApplyTextureCoords(frame.thumbnail.icon, true)
                end
            end
        end

        if widget.expand then
            -- Expand Button
            local expandButton = widget.expand
            expandButton:StripTextures()
            expandButton.SetNormalTexture = E.noop
            expandButton.SetHighlightTexture = E.noop
            expandButton.SetPushedTexture = E.noop

            expandButton:CreateBackdrop()
            expandButton.backdrop:SetInside(nil, 2, 2)
            expandButton.backdrop.Center:Kill()
            expandButton.backdrop:SetBackdropBorderColor(0, 0, 0, 0)
            expandButton.Texture = expandButton.backdrop:CreateTexture(nil, "OVERLAY")
            expandButton.Texture:Size(12, 12)
            expandButton.Texture:SetTexture(W.Media.Icons.buttonPlus)
            expandButton.Texture:SetVertexColor(.5, .5, .5)
            expandButton.Texture:Point("CENTER")
            expandButton:HookScript(
                "OnEnter",
                function(self)
                    if not self.disabled and self.backdrop then
                        self.backdrop:SetBackdropBorderColor(1, 1, 1)
                    end
                end
            )

            expandButton:HookScript(
                "OnLeave",
                function(self)
                    if not self.disabled and self.backdrop then
                        self.backdrop:SetBackdropBorderColor(0, 0, 0, 0)
                    end
                end
            )

            local DisableExpand = widget.DisableExpand
            widget.DisableExpand = function(frame)
                DisableExpand(frame)
                expandButton.Texture:SetTexture(W.Media.Icons.buttonPlus)
                expandButton.Texture:SetVertexColor(0.3, 0.3, 0.3)
            end

            local Expand = widget.Expand
            widget.Expand = function(frame)
                Expand(frame)
                expandButton.Texture:SetTexture(W.Media.Icons.buttonMinus)
                expandButton.Texture:SetVertexColor(1, 1, 1)
            end

            local Collapse = widget.Collapse
            widget.Collapse = function(frame)
                Collapse(frame)
                expandButton.Texture:SetTexture(W.Media.Icons.buttonPlus)
                expandButton.Texture:SetVertexColor(1, 1, 1)
            end
        end

        -- Group (verb) Button
        if widget.group then
            -- Expand Button
            local groupButton = widget.group
            groupButton:StripTextures()
            groupButton.SetNormalTexture = E.noop
            groupButton.SetHighlightTexture = E.noop
            groupButton.SetPushedTexture = E.noop

            groupButton:CreateBackdrop()
            groupButton.backdrop:SetInside(nil, 2, 2)
            groupButton.backdrop.Center:Kill()
            groupButton.backdrop:SetBackdropBorderColor(0, 0, 0, 0)
            groupButton.Texture = groupButton.backdrop:CreateTexture(nil, "OVERLAY")
            groupButton.Texture:Size(9, 9)
            groupButton.Texture:SetTexture(W.Media.Icons.buttonForward)
            groupButton.Texture:Point("CENTER")
            groupButton:HookScript(
                "OnEnter",
                function(self)
                    if not self.disabled and self.backdrop then
                        self.backdrop:SetBackdropBorderColor(1, 1, 1)
                    end
                end
            )

            groupButton:HookScript(
                "OnLeave",
                function(self)
                    if not self.disabled and self.backdrop then
                        self.backdrop:SetBackdropBorderColor(0, 0, 0, 0)
                    end
                end
            )
        end

        return widget
    end

    return SkinedConstructor
end

S.WeakAurasNewButton = S.WeakAurasDisplayButton

function S:WeakAurasLoadedHeaderButton(Constructor)
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.weakAurasOptions then
        return Constructor
    end

    local function SkinedConstructor()
        local widget = Constructor()

        if widget.expand then
            -- Expand Button
            local expandButton = widget.expand
            expandButton:StripTextures()
            expandButton.SetNormalTexture = E.noop
            expandButton.SetHighlightTexture = E.noop
            expandButton.SetPushedTexture = E.noop

            expandButton:CreateBackdrop()
            expandButton.backdrop:SetInside(nil, 2, 2)
            expandButton.backdrop.Center:Kill()
            expandButton.backdrop:SetBackdropBorderColor(0, 0, 0, 0)
            expandButton.Texture = expandButton.backdrop:CreateTexture(nil, "OVERLAY")
            expandButton.Texture:Size(12, 12)
            expandButton.Texture:SetTexture(W.Media.Icons.buttonPlus)
            expandButton.Texture:SetVertexColor(.5, .5, .5)
            expandButton.Texture:Point("CENTER")
            expandButton:HookScript(
                "OnEnter",
                function(self)
                    if not self.disabled and self.backdrop then
                        self.backdrop:SetBackdropBorderColor(1, 1, 1)
                    end
                end
            )

            expandButton:HookScript(
                "OnLeave",
                function(self)
                    if not self.disabled and self.backdrop then
                        self.backdrop:SetBackdropBorderColor(0, 0, 0, 0)
                    end
                end
            )

            local DisableExpand = widget.DisableExpand
            widget.DisableExpand = function(frame)
                DisableExpand(frame)
                expandButton.Texture:SetTexture(W.Media.Icons.buttonPlus)
                expandButton.Texture:SetVertexColor(0.3, 0.3, 0.3)
            end

            local Expand = widget.Expand
            widget.Expand = function(frame)
                Expand(frame)
                expandButton.Texture:SetTexture(W.Media.Icons.buttonMinus)
                expandButton.Texture:SetVertexColor(1, 1, 1)
            end

            local Collapse = widget.Collapse
            widget.Collapse = function(frame)
                Collapse(frame)
                expandButton.Texture:SetTexture(W.Media.Icons.buttonPlus)
                expandButton.Texture:SetVertexColor(1, 1, 1)
            end
        end

        return widget
    end

    return SkinedConstructor
end

do
    local AnchorDict = {
        ["TOP"] = "up",
        ["BOTTOM"] = "down",
        ["LEFT"] = "left",
        ["RIGHT"] = "right"
    }
    function S:WeakAurasOptionMoverSizer()
        if not _G.WeakAurasOptions or not _G.WeakAurasOptions.moversizer then
            return
        end

        local frame = _G.WeakAurasOptions.moversizer

        -- Mover Edge
        self:StripEdgeTextures(frame)
        frame:CreateBackdrop()
        frame.backdrop:SetInside(frame, 2, 2)
        frame.backdrop.Center:Kill()
        frame.backdrop:SetBackdropBorderColor(1, 1, 1)
        self:CreateShadow(frame.backdrop, 4, 1, 1, 1, true)

        -- Mover Buttons
        for _, child in pairs {frame:GetChildren()} do
            local numChildren = child:GetNumChildren()
            local numRegions = child:GetNumRegions()
            if numChildren == 2 and numRegions == 0 then
                for _, button in pairs {child:GetChildren()} do
                    local anchor = button:GetPoint()
                    if anchor then
                        button:StripTextures()
                        button:Size(16, 16)
                        button:CreateBackdrop()
                        self:CreateShadow(button.backdrop)
                        button.Texture = button.backdrop:CreateTexture(nil, "OVERLAY")
                        button.Texture:SetTexture(E.Media.Textures.ArrowUp)
                        button.Texture:Point("CENTER")
                        button.Texture:Size(16, 16)
                        button.Texture:SetRotation(ES.ArrowRotation[AnchorDict[anchor]])

                        button:HookScript(
                            "OnEnter",
                            function(self)
                                if self.Texture then
                                    self.Texture:SetVertexColor(unpack(E.media.rgbvaluecolor))
                                end
                            end
                        )

                        button:HookScript(
                            "OnLeave",
                            function(self)
                                if self.Texture then
                                    self.Texture:SetVertexColor(1, 1, 1)
                                end
                            end
                        )
                    end
                end
            end
        end
    end
end

function S:WeakAurasIconButton(Constructor)
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.weakAurasOptions then
        return Constructor
    end

    local function SkinedConstructor()
        local widget = Constructor()
        widget.frame:CreateBackdrop()
        widget.frame.backdrop.Center:StripTextures()
        ApplyTextureCoords(widget.texture)
        widget.texture:SetInside(widget.frame, 3, 3)
        widget.frame.backdrop:SetInside(widget.frame, 2, 2)

        local highlightTexture = widget.frame:GetHighlightTexture()
        if highlightTexture then
            highlightTexture:StripTextures()
        end

        widget.frame:HookScript(
            "OnEnter",
            function(self)
                if self.backdrop then
                    self.backdrop:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
                end
            end
        )

        widget.frame:HookScript(
            "OnLeave",
            function(self)
                if self.backdrop then
                    self.backdrop:SetBackdropBorderColor(0, 0, 0)
                end
            end
        )

        return widget
    end

    return SkinedConstructor
end

function S:WeakAuras_ShowOptions()
    local frame = _G.WeakAurasOptions
    if not frame or frame.windStyle then
        return
    end

    -- Remove background
    frame:SetBackdrop(nil)
    frame:CreateBackdrop("Transparent")
    self:CreateBackdropShadow(frame)

    for _, region in pairs {frame:GetRegions()} do
        if region:GetObjectType() == "Texture" then
            region:SetTexture(nil)
            region.SetTexture = E.noop
        end
    end

    -- Mover Sizer
    self:WeakAurasOptionMoverSizer()

    -- Buttons
    -- ReskinExpandButtons()

    for _, child in pairs {frame:GetChildren()} do
        if child:GetObjectType() == "Button" then
            ReskinNormalButton(child, true)
        elseif child:GetObjectType() == "Frame" then
            ReskinChildButton(child)
            ReskinNormalButton(child, true)
        end
    end

    -- Change position of resize buttons
    frame.bottomLeftResizer:ClearAllPoints()
    frame.bottomLeftResizer:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", -5, -5)
    frame.bottomRightResizer:ClearAllPoints()
    frame.bottomRightResizer:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 5, -5)

    -- Filter editbox
    if frame.filterInput then
        local inputBox = frame.filterInput
        local rightPart
        ES:HandleEditBox(inputBox)
        for i = 1, inputBox:GetNumPoints() do
            local point, relativeFrame = inputBox:GetPoint(i)
            if point == "RIGHT" then
                rightPart = relativeFrame
                break
            end
        end
        if rightPart then
            inputBox:SetHeight(inputBox:GetHeight() + 3)
            inputBox:ClearAllPoints()
            inputBox:Point("TOP", frame, "TOP", 0, -43)
            inputBox:Point("LEFT", frame, "LEFT", 18, 0)
            inputBox:Point("RIGHT", rightPart, "LEFT", -2, 0)
        end
    end

    for _, child in pairs {frame:GetChildren()} do
        local numRegions = child:GetNumRegions()
        local numChildren = child:GetNumChildren()
        local frameStrata = child:GetFrameStrata()

        if numRegions == 1 then
            local recognized = false

            local firstRegion = child:GetRegions()
            local text = firstRegion.GetText and firstRegion:GetText()
            if text and strfind(text, "^WeakAuras%s%d") then -- Title
                child:SetFrameLevel(3)
                child:CreateBackdrop()
                S:CreateBackdropShadow(child, true)
                F.SetFontOutline(firstRegion)
                recognized = true
            end

            if not recognized then
                if child:GetNumPoints() == 3 then
                    local point, _, relativePoint, xOfs, yOfs = child:GetPoint(1)
                    if point == "TOP" and relativePoint == "TOP" and xOfs == 0 and yOfs == -46 then
                        for _, subChild in pairs {child:GetChildren()} do
                            if subChild.obj and subChild.backdrop then -- top panel backdrop
                                subChild.backdrop:Hide()
                            end
                        end
                    end
                end
            end
        end

        if numRegions == 3 and numChildren == 1 and child.PixelSnapDisabled then -- Top right buttons(close & collapse)
            for _, region in pairs {child:GetRegions()} do
                region:StripTextures()
            end
            local button = child:GetChildren()

            if not button.windStyle and button.GetNormalTexture then
                local normalTexturePath = button:GetNormalTexture():GetTexture()
                if normalTexturePath == 252125 then
                    button:StripTextures()

                    button.Texture = button:CreateTexture(nil, "OVERLAY")
                    button.Texture:Point("CENTER")
                    button.Texture:SetTexture(E.Media.Textures.ArrowUp)
                    button.Texture:Size(14, 14)

                    button:HookScript(
                        "OnEnter",
                        function(self)
                            if self.Texture then
                                self.Texture:SetVertexColor(unpack(E.media.rgbvaluecolor))
                            end
                        end
                    )

                    button:HookScript(
                        "OnLeave",
                        function(self)
                            if self.Texture then
                                self.Texture:SetVertexColor(1, 1, 1)
                            end
                        end
                    )

                    button:HookScript(
                        "OnClick",
                        function(self)
                            self:SetNormalTexture("")
                            self:SetPushedTexture("")
                            if self:GetParent():GetParent().minimized then
                                button.Texture:SetRotation(ES.ArrowRotation["down"])
                            else
                                button.Texture:SetRotation(ES.ArrowRotation["up"])
                            end
                        end
                    )

                    button:SetHitRectInsets(6, 6, 7, 7)
                    button:Point("TOPRIGHT", frame.backdrop, "TOPRIGHT", -25, -5)
                else
                    ES:HandleCloseButton(button)
                    button:ClearAllPoints()
                    button:Point("TOPRIGHT", frame.backdrop, "TOPRIGHT", -3, -3)
                end

                button.windStyle = true
            end
        end

        -- tipPopup
        if frameStrata == "FULLSCREEN" then
            child:StripTextures()
            child:CreateBackdrop("Transparent")
            self:CreateShadow(child.backdrop)
            for _, subChild in pairs {child:GetChildren()} do
                if subChild.GetObjectType and subChild:GetObjectType() == "EditBox" then
                    ES:HandleEditBox(subChild)
                    subChild.backdrop:SetInside(nil, 0, 7)
                end
            end
        end
    end

    local tooltipAnchor = _G.WeakAurasTooltipImportButton:GetParent()
    if tooltipAnchor then
        for _, child in pairs {tooltipAnchor:GetChildren()} do
            if child.Text then
                ES:HandleButton(child)
            end
        end
    end

    -- Snippets Frame
    local snippetsFrame = _G.WeakAurasSnippets
    if snippetsFrame then
        snippetsFrame:ClearAllPoints()
        snippetsFrame:Point("TOPLEFT", frame, "TOPRIGHT", 5, 0)
        snippetsFrame:Point("BOTTOMLEFT", frame, "BOTTOMRIGHT", 5, 0)
        snippetsFrame:StripTextures()
        snippetsFrame:CreateBackdrop("Transparent")
        self:CreateBackdropShadow(snippetsFrame)
        ReskinChildButton(snippetsFrame)
    end

    -- Top Panel
    if frame.toolbarContainer.frame then
        self:StripEdgeTextures(frame.toolbarContainer.frame)
        frame.toolbarContainer.frame:ClearAllPoints()
        frame.toolbarContainer.frame:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -20)
        frame.toolbarContainer.frame:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -16, -20)
        frame.toolbarContainer.frame:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 20, -38)
    end

    -- Bottom Panel
    if frame.tipFrame.frame then
        self:StripEdgeTextures(frame.tipFrame.frame)
        frame.tipFrame.frame:ClearAllPoints()
        frame.tipFrame.frame:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", 16, 10)
        frame.tipFrame.frame:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -16, 10)
    end

    if frame.iconPicker.frame then
        for _, child in pairs {frame.iconPicker.frame:GetChildren()} do
            if child.GetObjectType and child:GetObjectType() == "EditBox" then
                child.Left:Kill()
                child.Middle:Kill()
                child.Right:Kill()
                child:CreateBackdrop()
            end
        end
    end

    frame.windStyle = true
end

function S:WeakAuras_TextEditor()
    ES:HandleButton(_G.WASettingsButton)

    local frame = _G.WASnippetsButton:GetParent()
    if not frame then
        return
    end

    for _, child in pairs {frame:GetChildren()} do
        if child.Text then
            ES:HandleButton(child)
        end
    end

    frame = _G.WeakAurasSnippets
    if not frame then
        return
    end

    frame:SetBackdrop(nil)
    frame:CreateBackdrop("Transparent")
    S:CreateShadow(frame)

    for _, child in pairs {frame:GetChildren()} do
        if child.Text then
            ES:HandleButton(child)
        end
    end
end

function S:WeakAurasOptions()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.weakAurasOptions then
        return
    end

    self:SecureHook(_G.WeakAuras, "ShowOptions", "WeakAuras_ShowOptions")
    -- self:SecureHook(_G.WeakAuras, "TextEditor", "WeakAuras_TextEditor")
end

S:AddCallbackForAddon("WeakAurasOptions")
S:AddCallbackForAceGUIWidget("WeakAurasMultiLineEditBox")
S:AddCallbackForAceGUIWidget("WeakAurasDisplayButton")
S:AddCallbackForAceGUIWidget("WeakAurasIconButton")
S:AddCallbackForAceGUIWidget("WeakAurasNewButton")
S:AddCallbackForAceGUIWidget("WeakAurasLoadedHeaderButton")
