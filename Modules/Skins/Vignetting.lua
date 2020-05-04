local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:UpdateVignetting()
    local frame = W.VignettingFrame
    local level = E.private.WT.skins.vignetting.level / 100
    if frame and level then frame:SetAlpha(level) end
end

function S:Vignetting()
    if not E.private.WT.skins.vignetting.enable then return end

    local frame = CreateFrame("Frame", "ShadowBackground")
    frame:Point("TOPLEFT")
    frame:Point("BOTTOMRIGHT")
    frame:SetFrameLevel(0)
    frame:SetFrameStrata("BACKGROUND")
    frame.tex = frame:CreateTexture()
    frame.tex:SetTexture(F.GetTexture("Vignetting.tga","Textures"))
    frame.tex:SetAllPoints(frame)

    W.VignettingFrame = frame

    S:UpdateVignetting()
end

S:AddCallback('Vignetting')