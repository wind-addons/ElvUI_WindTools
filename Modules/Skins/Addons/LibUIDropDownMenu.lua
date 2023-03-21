local W, F, E, L = unpack(select(2, ...))
local ES = E.Skins
local S = W.Modules.Skins

local _G = _G
local pairs = pairs

function S:LibUIDropDownMenu()
    local DD = _G.LibStub("LibUIDropDownMenu-4.0", true)

    if not DD then
        return
    end

    for _, frame in pairs(
        {
            _G.L_DropDownList1Backdrop,
            _G.L_DropDownList1MenuBackdrop,
            _G.L_DropDownList2Backdrop,
            _G.L_DropDownList2MenuBackdrop
        }
    ) do
        if frame and not ES.L_UIDropDownMenuSkinned and not frame.__windSkin then
            frame:SetTemplate("Transparent")
        end
        frame:SetTemplate("Transparent")
        self:CreateShadow(frame)
        if frame.NineSlice then
            frame.NineSlice:Kill()
        end
    end

    ES.L_UIDropDownMenuSkinned = true
end

S:AddCallback("LibUIDropDownMenu")
