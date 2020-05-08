local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:ElvUI_StaticPopup()
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.staticPopup) then
        return
    end

    for i = 1, 3 do
        local f = _G["ElvUI_StaticPopup" .. i]
        if f then
            S:CreateShadow(f)
        end
    end
end

S:AddCallback("ElvUI_StaticPopup")
