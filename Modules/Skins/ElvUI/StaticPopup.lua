local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G

function S:ElvUI_StaticPopup()
    if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.staticPopup) then
        return
    end

    for i = 1, 3 do
        self:CreateShadow(_G["ElvUI_StaticPopup" .. i])
    end
end

S:AddCallback("ElvUI_StaticPopup")
