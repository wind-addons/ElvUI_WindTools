local W, F, E, L = unpack(select(2, ...))
local ES = E:GetModule("Skins")
local S = W:GetModule("Skins")

local _G = _G
local gsub = gsub
local pairs = pairs
local strfind = strfind
local unpack = unpack

local IsAddOnLoaded = IsAddOnLoaded

local C_Timer_After = C_Timer.After

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
        C_Timer_After(
            .05,
            function()
                TryHandleButtonAfter(name, times)
            end
        )
    end
end

function S:WeakAurasMultiLineEditBox(Constructor)
    if not self:CheckDB(nil, "weakAurasOptions") then
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

        if numRegions == 3 and numChildren == 1 and child.PixelSnapDisabled then
            for _, region in pairs {child:GetRegions()} do
                region:StripTextures()
            end
            local button = child:GetChildren()

            local isCollapse = false
            for _, region in pairs {button:GetRegions()} do
                if region.GetTexture then
                    if strfind(region:GetTexture(), "Collapse") then
                        isCollapse = true
                    end
                end
            end

            if isCollapse then
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
                    end
                )

                button:SetHitRectInsets(6, 6, 7, 7)
                button:Point("TOPRIGHT", frame.backdrop, "TOPRIGHT", -25, -5)
            else
                ES:HandleCloseButton(button)
                button:ClearAllPoints()
                button:Point("TOPRIGHT", frame.backdrop, "TOPRIGHT", -3, -3)
            end
        end
    end

    frame.windStyle = true
end

function S:WeakAurasOptions()
    if not self:CheckDB(nil, "weakAurasOptions") then
        return
    end

    if not IsAddOnLoaded("WeakAuras") then
        return
    end

    self:SecureHook(_G.WeakAuras, "ShowOptions", "WeakAuras_ShowOptions")
end

S:AddCallbackForAddon("WeakAurasOptions")
S:AddCallbackForAceGUIWidget("WeakAurasMultiLineEditBox")
