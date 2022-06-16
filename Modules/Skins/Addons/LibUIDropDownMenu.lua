local W, F, E, L = unpack(select(2, ...))
local ES = E.Skins
local S = W.Modules.Skins

local _G = _G

function S:LibUIDropDownMenu()
    local DD = _G.LibStub("LibUIDropDownMenu-4.0", true)

    if not DD then
        return
    end

    local backdropFirstLayer = _G.L_DropDownList1Backdrop
    local menuBackdropFirstLayer = _G.L_DropDownList1MenuBackdrop
    local backdropSecondLayer = _G.L_DropDownList2Backdrop
    local menuBackdropSecondLayer = _G.L_DropDownList2MenuBackdrop

    if not backdropFirstLayer or not menuBackdropFirstLayer or not backdropSecondLayer or not menuBackdropSecondLayer then
        return
    end

    if not ES.L_UIDropDownMenuSkinned then
        backdropFirstLayer:SetTemplate("Transparent")
        menuBackdropFirstLayer:SetTemplate("Transparent")
        backdropSecondLayer:SetTemplate("Transparent")
        menuBackdropSecondLayer:SetTemplate("Transparent")
        ES.L_UIDropDownMenuSkinned = true
    end

    self:CreateShadow(backdropFirstLayer)
    self:CreateShadow(menuBackdropFirstLayer)
    self:CreateShadow(backdropSecondLayer)
    self:CreateShadow(menuBackdropSecondLayer)
end

S:AddCallback("LibUIDropDownMenu")
