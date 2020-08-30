local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_OrderHallUI()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.orderhall) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.orderHall) then
        return
    end

    local talentPanel = _G.OrderHallTalentFrame
    if talentPanel then
        S:CreateShadow(talentPanel)
    end

    local bar = _G.OrderHallCommandBar
    if bar then
        F.SetFontOutline(bar.AreaName)
        F.SetFontOutline(bar.Currency)
        bar.AreaName:ClearAllPoints()
        bar.AreaName:SetPoint("CENTER", 0, 0)
    end
end

S:AddCallbackForAddon("Blizzard_OrderHallUI")
