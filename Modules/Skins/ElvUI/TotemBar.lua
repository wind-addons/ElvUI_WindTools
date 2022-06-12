local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G

function S:ElvUI_UpdateTotemBar(TOTEMS)
    for i = 1, 4 do
        local button = TOTEMS.bar[i]

        if button:IsShown() and not button.__windSkin then
            self:CreateShadow(button)
            button.__windSkin = true
        end
    end
end

function S:ElvUI_TotemBar()
    if not (E.private.general.totemBar and E.private.WT.skins.elvui.totemBar) then
        return
    end

    local TOTEMS = E:GetModule("Totems")

    self:SecureHook(TOTEMS, "Update", "ElvUI_UpdateTotemBar")
end

S:AddCallback("ElvUI_TotemBar")
