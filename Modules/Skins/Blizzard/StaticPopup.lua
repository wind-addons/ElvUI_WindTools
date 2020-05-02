local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:StaticPopup()
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.staticPopup) then return end

    for i = 1, 4 do
        local f = _G["StaticPopup" .. i]
        if f then S:CreateShadow(f) end
    end
end

S:AddCallback('StaticPopup')
