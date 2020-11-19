local W, F, E, L = unpack(select(2, ...))
local ES = E:GetModule("Skins")
local S = W:GetModule("Skins")

local _G = _G
local gsub = gsub
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local strfind = strfind
local tinsert = tinsert
local type = type
local unpack = unpack
local wipe = wipe

local IsAddOnLoaded = IsAddOnLoaded

local buttons = {}
local expandButtons = {}

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
        ES:HandleButton(widget.frame)
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
        widget.icon:SetTexCoord(unpack(E.TexCoords))
        ES:HandleEditBox(widget.renamebox)
        widget.frame.highlight:SetTexture(E.media.blankTex)
        widget.frame.highlight:SetVertexColor(1, 1, 1, 0.15)
        widget.frame.highlight:SetInside()
        return widget
    end

    return SkinedConstructor
end

function S:WeakAurasNewButton(Constructor)
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.weakAurasOptions then
        return Constructor
    end

    local function SkinedConstructor()
        local widget = Constructor()
        ES:HandleButton(widget.frame)
        widget.frame.background:SetAlpha(0)
        widget.frame.backdrop:SetFrameLevel(widget.frame:GetFrameLevel())
        widget.icon:SetTexCoord(unpack(E.TexCoords))
        widget.icon:Size(35)
        widget.icon:ClearAllPoints()
        widget.icon:Point("LEFT", widget.frame, "LEFT", 3, 0)
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
    if _G.WeakAurasFilterInput then
        local inputBox = _G.WeakAurasFilterInput
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
                        for _, subchild in pairs {child:GetChildren()} do
                            if subchild.obj and subchild.backdrop then -- top panel backdrop
                                subchild.backdrop:Hide()
                            end
                        end
                    end
                end
            end
        end

        if numChildren == 2 then
            if child.obj and child.backdrop then -- bottom panel backdrop
                child.backdrop:Hide()
            end
        end

        if numRegions == 3 and numChildren == 1 and child.PixelSnapDisabled then -- Top right buttons(close & collapse)
            for _, region in pairs {child:GetRegions()} do
                region:StripTextures()
            end
            local button = child:GetChildren()

            if not button.windStyle and button.GetNormalTexture then
                local normalTexturePath = button:GetNormalTexture():GetTexture()
                if normalTexturePath == "Interface\\BUTTONS\\UI-Panel-CollapseButton-Up" then
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
end

S:AddCallbackForAddon("WeakAurasOptions")
S:AddCallbackForAceGUIWidget("WeakAurasMultiLineEditBox")
S:AddCallbackForAceGUIWidget("WeakAurasDisplayButton")
S:AddCallbackForAceGUIWidget("WeakAurasNewButton")
