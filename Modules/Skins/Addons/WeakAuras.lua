local W, F, E, L = unpack(select(2, ...))
local ES = E:GetModule("Skins")
local S = W:GetModule("Skins")

local _G = _G
local pairs = pairs
local strfind = strfind
local unpack = unpack

function S:WeakAuras_PrintProfile()
    local frame = _G.WADebugEditBox.Background

    if frame and not frame.windStyle then
        local textArea = _G.WADebugEditBoxScrollFrame:GetRegions()
        ES:HandleScrollBar(_G.WADebugEditBoxScrollFrameScrollBar)

        frame:StripTextures()
        frame:CreateBackdrop("Transparent")
        S:CreateShadow(frame)

        for _, child in pairs {frame:GetChildren()} do
            if child:GetNumRegions() == 3 then
                child:StripTextures()
                local subChild = child:GetChildren()
                ES:HandleCloseButton(subChild)
                subChild:ClearAllPoints()
                subChild:Point("TOPRIGHT", frame, "TOPRIGHT", 3, 7)
            end
        end

        frame.windStyle = true
    end
end

function S:ProfilingWindow_UpdateButtons(frame)
    -- 下方 4 个按钮
    for _, button in pairs {frame.statsFrame:GetChildren()} do
        ES:HandleButton(button)
    end

    -- 顶部 2 个按钮
    for _, button in pairs {frame.titleFrame:GetChildren()} do
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
                ES:HandleCloseButton(button)
                button:ClearAllPoints()
                button:Point("TOPRIGHT", frame.titleFrame, "TOPRIGHT", 3, 5)
            end

            button.windStyle = true
        end
    end
end

local function Skin_WeakAuras(f, fType)
    -- 来源于 NDui
    if fType == "icon" then
        if not f.windStyle then
            f.icon:SetTexCoord(unpack(E.TexCoords))
            f.icon.SetTexCoord = E.noop
            f:CreateBackdrop()
            S:CreateShadow(f.backdrop)
            f.backdrop:StripTextures()
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

            f.windStyle = true
        end
    elseif fType == "aurabar" then
        if not f.windStyle then
            f:CreateBackdrop()
            f.backdrop:StripTextures()
            f.backdrop:SetFrameLevel(0)
            S:CreateShadow(f.backdrop)
            f.icon:SetTexCoord(unpack(E.TexCoords))
            f.icon.SetTexCoord = E.noop
            f.iconFrame:SetAllPoints(f.icon)
            f.iconFrame:CreateBackdrop()

            f.windStyle = true
        end
    end
end

function S:WeakAuras()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.weakAuras then
        return
    end

    local regionTypes = _G.WeakAuras.regionTypes
    local Create_Icon, Modify_Icon = regionTypes.icon.create, regionTypes.icon.modify
    local Create_AuraBar, Modify_AuraBar = regionTypes.aurabar.create, regionTypes.aurabar.modify

    regionTypes.icon.create = function(parent, data)
        local region = Create_Icon(parent, data)
        Skin_WeakAuras(region, "icon")
        return region
    end

    regionTypes.aurabar.create = function(parent)
        local region = Create_AuraBar(parent)
        Skin_WeakAuras(region, "aurabar")
        return region
    end

    regionTypes.icon.modify = function(parent, region, data)
        Modify_Icon(parent, region, data)
        Skin_WeakAuras(region, "icon")
    end

    regionTypes.aurabar.modify = function(parent, region, data)
        Modify_AuraBar(parent, region, data)
        Skin_WeakAuras(region, "aurabar")
    end

    for weakAura, regions in pairs(_G.WeakAuras.regions) do
        if regions.regionType == "icon" or regions.regionType == "aurabar" then
            Skin_WeakAuras(regions.region, regions.regionType)
        end
    end

    -- 效能分析
    local profilingWindow = _G.WeakAuras.frames["RealTime Profiling Window"]
    if profilingWindow then
        self:CreateShadow(profilingWindow)
        self:SecureHook(profilingWindow, "UpdateButtons", "ProfilingWindow_UpdateButtons")
        self:SecureHook(_G.WeakAuras, "PrintProfile", "WeakAuras_PrintProfile")
    end
end

S:AddCallbackForAddon("WeakAuras")
