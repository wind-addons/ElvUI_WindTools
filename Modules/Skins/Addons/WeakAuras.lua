local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins
local ES = E.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local strfind = strfind
local unpack = unpack

function S:WeakAuras_PrintProfile()
    local frame = _G.WADebugEditBox.Background

    if frame and not frame.__windSkin then
        local textArea = _G.WADebugEditBoxScrollFrame:GetRegions()
        self:ESProxy("HandleScrollBar", _G.WADebugEditBoxScrollFrameScrollBar)

        frame:StripTextures()
        frame:SetTemplate("Transparent")
        self:CreateShadow(frame)

        for _, child in pairs {frame:GetChildren()} do
            if child:GetNumRegions() == 3 then
                child:StripTextures()
                local subChild = child:GetChildren()
                subChild:ClearAllPoints()
                subChild:Point("TOPRIGHT", frame, "TOPRIGHT", 3, 7)
                self:ESProxy("HandleCloseButton", subChild)
            end
        end

        frame.__windSkin = true
    end
end

function S:ProfilingWindow_UpdateButtons(frame)
    -- 下方 4 个按钮
    for _, button in pairs {frame.statsFrame:GetChildren()} do
        self:ESProxy("HandleButton", button)
    end

    -- 顶部 2 个按钮
    for _, button in pairs {frame.titleFrame:GetChildren()} do
        if not button.__windSkin and button.GetNormalTexture then
            local normalTextureID = button:GetNormalTexture():GetTexture()
            if normalTextureID == 252125 then
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
                        self.Texture:Show("")
                        if self:GetParent():GetParent().minimized then
                            button.Texture:SetRotation(ES.ArrowRotation["down"])
                        else
                            button.Texture:SetRotation(ES.ArrowRotation["up"])
                        end
                    end
                )

                button:SetHitRectInsets(6, 6, 7, 7)
                button:Point("TOPRIGHT", frame.titleFrame, "TOPRIGHT", -19, 3)
            else
                self:ESProxy("HandleCloseButton", button)
                button:ClearAllPoints()
                button:Point("TOPRIGHT", frame.titleFrame, "TOPRIGHT", 3, 5)
            end

            button.__windSkin = true
        end
    end
end

local function Skin_WeakAuras(f, fType)
    if fType == "icon" then
        if not f.__windSkin then
            f.icon.SetTexCoordOld = f.icon.SetTexCoord
            f.icon.SetTexCoord = function(self, ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
                local cLeft, cRight, cTop, cDown
                if URx and URy and LRx and LRy then
                    cLeft, cRight, cTop, cDown = ULx, LRx, ULy, LRy
                else
                    cLeft, cRight, cTop, cDown = ULx, ULy, LLx, LLy
                end

                local left, right, top, down = unpack(E.TexCoords)
                if cLeft == 0 or cRight == 0 or cTop == 0 or cDown == 0 then
                    local width, height = cRight - cLeft, cDown - cTop
                    if width == height then
                        self:SetTexCoordOld(left, right, top, down)
                    elseif width > height then
                        self:SetTexCoordOld(left, right, top + cTop * (right - left), top + cDown * (right - left))
                    else
                        self:SetTexCoordOld(left + cLeft * (down - top), left + cRight * (down - top), top, down)
                    end
                else
                    self:SetTexCoordOld(cLeft, cRight, cTop, cDown)
                end
            end
            f.icon:SetTexCoord(f.icon:GetTexCoord())
            f:CreateBackdrop()
            if E.private.WT.skins.weakAurasShadow then
                S:CreateBackdropShadow(f, true)
            end
            f.backdrop.Center:StripTextures()
            f.backdrop:SetFrameLevel(0)
            f.backdrop.icon = f.icon
            f.backdrop:HookScript(
                "OnUpdate",
                function(self)
                    self:SetAlpha(self.icon:GetAlpha())
                    if self.shadow then
                        self.shadow:SetAlpha(self.icon:GetAlpha())
                    end
                end
            )

            f.__windSkin = true
        end
    elseif fType == "aurabar" then
        if not f.__windSkin then
            f:CreateBackdrop()
            f.backdrop.Center:StripTextures()
            f.backdrop:SetFrameLevel(0)
            if E.private.WT.skins.weakAurasShadow then
                S:CreateBackdropShadow(f, true)
            end
            f.icon:SetTexCoord(unpack(E.TexCoords))
            f.icon.SetTexCoord = E.noop
            f.iconFrame:SetAllPoints(f.icon)
            f.iconFrame:CreateBackdrop()
            hooksecurefunc(
                f.icon,
                "Hide",
                function()
                    f.iconFrame.backdrop:SetShown(false)
                end
            )

            hooksecurefunc(
                f.icon,
                "Show",
                function()
                    f.iconFrame.backdrop:SetShown(true)
                end
            )

            f.__windSkin = true
        end
    end
end

function S:WeakAuras()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.weakAuras then
        return
    end

    -- Handle the options region type registration
    if _G.WeakAuras and _G.WeakAuras.RegisterRegionOptions then
        self:RawHook(_G.WeakAuras, "RegisterRegionOptions", "WeakAuras_RegisterRegionOptions")
    end

    -- Handle the options region type registration
    -- from NDui
    local function OnPrototypeCreate(region)
        Skin_WeakAuras(region, region.regionType)
    end

    local function OnPrototypeModifyFinish(_, region)
        Skin_WeakAuras(region, region.regionType)
    end

    self:SecureHook(WeakAuras.regionPrototype, "create", OnPrototypeCreate)
    self:SecureHook(WeakAuras.regionPrototype, "modifyFinish", OnPrototypeModifyFinish)

    -- Real Time Profiling Window
    local profilingWindow = _G.WeakAuras.RealTimeProfilingWindow
    if profilingWindow then
        self:CreateShadow(profilingWindow)
        self:SecureHook(profilingWindow, "UpdateButtons", "ProfilingWindow_UpdateButtons")
        self:SecureHook(_G.WeakAuras, "PrintProfile", "WeakAuras_PrintProfile")
    end
end

S:AddCallbackForAddon("WeakAuras")
