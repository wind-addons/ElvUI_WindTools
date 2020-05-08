local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local hooksecurefunc = hooksecurefunc

local function SkinLossOfControl(s)
    s.Icon:ClearAllPoints()
    s.Icon:Point("LEFT", s, "LEFT", 0, 0)

    if not s.Icon.backdrop then
        s.Icon:CreateBackdrop()
    end
    S:CreateShadow(s.Icon.backdrop)

    s.AbilityName:ClearAllPoints()
    s.AbilityName:Point("TOPLEFT", s.Icon, "TOPRIGHT", 10, 0)

    -- 时间归位
    s.TimeLeft:ClearAllPoints()
    s.TimeLeft.NumberText:ClearAllPoints()
    s.TimeLeft.NumberText:Point("BOTTOMLEFT", s.Icon, "BOTTOMRIGHT", 10, 0)

    s.TimeLeft.SecondsText:ClearAllPoints()
    s.TimeLeft.SecondsText:Point("TOPLEFT", s.TimeLeft.NumberText, "TOPRIGHT", 3, 0)

    s:Size(s.Icon:GetWidth() + 10 + s.AbilityName:GetWidth(), s.Icon:GetHeight())
end

function S:LossOfControlFrame()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.losscontrol) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.lossOfControl) then
        return
    end

    hooksecurefunc("LossOfControlFrame_SetUpDisplay", SkinLossOfControl)
end

S:AddCallback("LossOfControlFrame")
