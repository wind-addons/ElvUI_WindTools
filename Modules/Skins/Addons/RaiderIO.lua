local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local strfind = strfind

local skinned = false

function S:RaiderIO_DelayedSkinning()
    if skinned then
        return
    end
    skinned = true
    if _G.RaiderIO_ProfileTooltip then
        _G.RaiderIO_ProfileTooltip:StripTextures()
        _G.RaiderIO_ProfileTooltip.NineSlice:Kill()
        _G.RaiderIO_ProfileTooltip:SetTemplate("Transparent")
        local point, relativeTo, relativePoint, xOffset, yOffset = _G.RaiderIO_ProfileTooltip:GetPoint()
        if xOffset and yOffset and xOffset == 0 and yOffset == 0 then
            _G.RaiderIO_ProfileTooltip.__SetPoint = _G.RaiderIO_ProfileTooltip.SetPoint
            hooksecurefunc(
                _G.RaiderIO_ProfileTooltip,
                "SetPoint",
                function(self, point, relativeTo, relativePoint, xOffset, yOffset)
                    if xOffset and yOffset and xOffset == 0 and yOffset == 0 then
                        self:__SetPoint(point, relativeTo, relativePoint, 4, 0)
                    end
                end
            )
        end
    end

    local configFrame

    for _, frame in pairs {_G.UIParent:GetChildren()} do
        if frame.scrollbar and frame.scrollframe then
            for _, child in pairs({frame:GetChildren()}) do
                if child ~= frame.scrollbar and child ~= frame.scrollframe then
                    local numChildren = child.GetNumChildren and child:GetNumChildren()
                    if numChildren then
                        if numChildren == 1 then
                            frame.titleFrame = child
                            local title = child:GetChildren(1)
                            local titleText = title and title.text and title.text:GetText()
                            if titleText and strfind(titleText, "Raider.IO") then
                                configFrame = frame
                            end
                        elseif numChildren == 3 then
                            frame.buttonFrame = child
                        end
                    end
                end
            end
        end
    end

    if configFrame then
        configFrame:SetTemplate("Transparent")
        self:CreateShadow(configFrame)

        self:ESProxy("HandleScrollBar", configFrame.scrollbar)

        for _, frame in pairs({configFrame.buttonFrame:GetChildren()}) do
            if frame:GetObjectType() == "Button" then
                frame:SetScript("OnEnter", nil)
                frame:SetScript("OnLeave", nil)
                F.SetFontOutline(frame.text)
                self:ESProxy("HandleButton", frame)
                frame.Center:Show()
            end
        end

        if configFrame.scrollframe and configFrame.scrollframe.content then
            for _, line in pairs({configFrame.scrollframe.content:GetChildren()}) do
                for _, child in pairs({line:GetChildren()}) do
                    if child:GetObjectType() == "CheckButton" then
                        self:ESProxy("HandleCheckBox", child)
                    end
                end
            end
        end
    end
end

function S:RaiderIO()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.raiderIO then
        return
    end

    self:DisableAddOnSkin("RaiderIO")
    self:AddCallbackForEnterWorld("RaiderIO_DelayedSkinning")
end

S:AddCallbackForAddon("RaiderIO")
