local W, F, E, L = unpack(select(2, ...))
local ES = E:GetModule("Skins")
local S = W:GetModule("Skins")

local _G = _G
local gsub = gsub
local pairs = pairs
local strfind = strfind
local unpack = unpack

local IsAddOnLoaded = IsAddOnLoaded

local function TryHandleButtonAfter(name, times)
    times = times or 0
    if times > 10 then
        return
    end

    local handled = false

    for i = 1, 2 do
        if _G[name .. i] then
            ES:HandleButton(_G[name .. i])
            handled = true
        end
    end

    if not handled then
        times = times + 1
        E:Delay(0.02, TryHandleButtonAfter, name, times)
    end
end

local function TryHandleTextureAfter(name, times)
    times = times or 0
    if times > 10 then
        return
    end

    local handled = false

    if _G[name] then
        for _, child in pairs {_G[name]:GetChildren()} do
            if child.model or child.texture or child.mask or child.region or child.defaultIcon then
                local firstRegion = child:GetRegions()
                firstRegion:SetTexture("")
                handled = true
            end
        end
    end

    if not handled then
        times = times + 1
        E:Delay(0.05, TryHandleButtonAfter, name, times)
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

        local expandButtonName = gsub(widget.button:GetName(), "Button", "ExpandButton")
        TryHandleButtonAfter(expandButtonName)
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
        widget.frame.backdrop:SetFrameLevel(widget.frame:GetFrameLevel())
        widget.frame.background:SetAlpha(0)
        widget.icon:SetTexCoord(unpack(E.TexCoords))
        TryHandleTextureAfter(widget.frame:GetName())
        ES:HandleEditBox(widget.renamebox)
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
        TryHandleTextureAfter(widget.frame:GetName())
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
    S:CreateShadow(frame)

    for _, region in pairs {frame:GetRegions()} do
        if region:GetObjectType() == "Texture" then
            region:SetTexture(nil)
            region.SetTexture = E.noop
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
            inputBox:SetHeight(inputBox:GetHeight()+3)
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
                S:CreateShadow(child.backdrop)
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
S:AddCallbackForAceGUIWidget("WeakAurasNewButton")
