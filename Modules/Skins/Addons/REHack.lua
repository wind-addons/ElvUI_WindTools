local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")

local _G = _G
local unpack = unpack

local DeleteRegions = {
    "Center",
    "BottomEdge",
    "LeftEdge",
    "RightEdge",
    "TopEdge",
    "BottomLeftCorner",
    "BottomRightCorner",
    "TopLeftCorner",
    "TopRightCorner"
}

local function StripEdgeTextures(frame)
    for _, regionKey in pairs(DeleteRegions) do
        if frame[regionKey] then
            frame[regionKey]:Kill()
        end
    end
end

function S:REHack()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.rehack then
        return
    end

    if _G.HackEditFrame then
        StripEdgeTextures(_G.HackEditFrame)
        _G.HackEditFrameBG:StripTextures()
        _G.HackEditFrame:CreateBackdrop("Transparent")
        self:CreateBackdropShadow(_G.HackEditFrame)
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
        StripEdgeTextures(_G.HackListFrame)
        _G.HackListFrameBG:StripTextures()
        _G.HackListFrame:CreateBackdrop("Transparent")
        self:CreateBackdropShadow(_G.HackListFrame)
        self:MerathilisUISkin(_G.HackListFrame)
        _G.HackListFrameTitle:Kill()

        ES:HandleTab(_G.HackListFrameTab1)
        ES:HandleTab(_G.HackListFrameTab2)
        self:CreateBackdropShadow(_G.HackListFrameTab1)
        self:CreateBackdropShadow(_G.HackListFrameTab2)
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
