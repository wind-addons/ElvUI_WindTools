local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:UpdateVignetting()
    local frame = W.VignettingFrame
    local level = E.db.WT.skins.vignetting.level / 100
    if frame and level then
        frame:SetAlpha(level)
    end
end

function S:Vignetting()
    if not E.db.WT.skins.vignetting.enable then
        return
    end

    local frame = CreateFrame("Frame", "ShadowBackground", E.UIParent)
    frame:Point("TOPLEFT")
    frame:Point("BOTTOMRIGHT")
    frame:SetFrameLevel(0)
    frame:SetFrameStrata("BACKGROUND")
    frame.tex = frame:CreateTexture()
    frame.tex:SetTexture(W.Media.Textures.vignetting)
    frame.tex:SetAllPoints(frame)

    W.VignettingFrame = frame

    S:UpdateVignetting()
end

function S:UpdateVignettingConfig()
    if not E.db.WT.skins.vignetting.enable then
        if W.VignettingFrame then
            W.VignettingFrame:Hide()
        end
    else
        if not W.VignettingFrame then
            self:Vignetting()
            return
        end
        W.VignettingFrame:Show()
        self:UpdateVignetting()
    end
end

S:AddCallback("Vignetting")
S:AddCallbackForUpdate("UpdateVignettingConfig")
