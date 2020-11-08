local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")

local _G = _G
local unpack = unpack

function S:REHack()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.rehack then
        return
    end

    if _G.HackEditFrame then
        _G.HackEditFrameBG:StripTextures()
        _G.HackEditFrame:CreateBackdrop("Transparent")
        self:CreateShadow(_G.HackEditFrame.backdrop)
        self:MerathilisUISkin(_G.HackEditFrame)
        _G.HackEditFrameTitle:Kill()
        ES:HandleCloseButton(_G.HackEditFrameClose)
        ES:HandleScrollBar(_G.HackEditScrollFrameScrollBar)

        local SetPoint = _G.HackEditFrame.SetPoint
        _G.HackEditFrame.SetPoint = function(frame, point, relativeFrame, relativePoint, x, y)
            if point == "TOPLEFT" and relativePoint == "TOPRIGHT" and x and y == 0 then
                x = x + 7
            end
            SetPoint(frame, point, relativeFrame, relativePoint, x, y)
        end
        local tempPos = {_G.HackEditFrame:GetPoint()}
        _G.HackEditFrame:ClearAllPoints()
        _G.HackEditFrame:SetPoint(unpack(tempPos))
    end

    if _G.HackListFrame then
        _G.HackListFrameBG:StripTextures()
        _G.HackListFrame:CreateBackdrop("Transparent")
        self:CreateShadow(_G.HackListFrame.backdrop)
        self:MerathilisUISkin(_G.HackListFrame)
        _G.HackListFrameTitle:Kill()

        ES:HandleTab(_G.HackListFrameTab1)
        ES:HandleTab(_G.HackListFrameTab2)
        _G.HackListFrameTab1.backdrop:SetTemplate("Transparent")
        _G.HackListFrameTab2.backdrop:SetTemplate("Transparent")
        self:CreateShadow(_G.HackListFrameTab1.backdrop)
        self:CreateShadow(_G.HackListFrameTab2.backdrop)
        self:MerathilisUITab(_G.HackListFrameTab1)
        self:MerathilisUITab(_G.HackListFrameTab2)

        ES:HandleEditBox(_G.HackSearchEdit)

        ES:HandleCheckBox(_G.HackSearchName)
        ES:HandleCheckBox(_G.HackSearchBody)
        _G.HackSearchName:Size(20)
        _G.HackSearchBody:Size(20)

        ES:HandleCloseButton(_G.HackListFrameClose)
        _G.HackEditBoxLineBG:SetColorTexture(0, 0, 0, 0.25)
    end
end

S:AddCallbackForAddon("REHack")
S:DisableAddOnSkin("REHack")
