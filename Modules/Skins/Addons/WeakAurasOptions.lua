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

    -- 建立新的背景
    frame.LeftEdge:Kill()
    frame.TopEdge:Kill()
    frame.RightEdge:Kill()
    frame.BottomEdge:Kill()
    frame.TopLeftCorner:Kill()
    frame.TopRightCorner:Kill()
    frame.BottomLeftCorner:Kill()
    frame.BottomRightCorner:Kill()
    frame.Center:Kill()
    frame:CreateBackdrop("Transparent")
    S:CreateShadow(frame)

    -- 尺寸修改图标位置位移
    frame.bottomLeftResizer:ClearAllPoints()
    frame.bottomLeftResizer:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", -5, -5)
    frame.bottomRightResizer:ClearAllPoints()
    frame.bottomRightResizer:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 5, -5)

    for _, region in pairs {frame:GetRegions()} do
        if region.GetTexture then
            region:StripTextures()
        end
    end

    for _, child in pairs {frame:GetChildren()} do
        local numRegions = child:GetNumRegions()
        local numChildren = child:GetNumChildren()

        if numRegions == 1 then -- 标题
            local firstRegion = child:GetRegions()
            local text = firstRegion.GetText and firstRegion:GetText()
            if text and strfind(text, "^WeakAuras%s%d") then
                child:SetFrameLevel(3)
                child:CreateBackdrop()
                S:CreateShadow(child.backdrop)
                F.SetFontOutline(firstRegion)
            end
        end

        if numRegions == 3 and numChildren == 1 and child.PixelSnapDisabled then -- 右上按钮
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

    frame.TopEdge:Kill()
    frame.LeftEdge:Kill()
    frame.RightEdge:Kill()
    frame.BottomEdge:Kill()
    frame.TopLeftCorner:Kill()
    frame.TopRightCorner:Kill()
    frame.BottomLeftCorner:Kill()
    frame.BottomRightCorner:Kill()
    frame.Center:Kill()
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
