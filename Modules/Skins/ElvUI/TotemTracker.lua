local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G

function S:ElvUI_UpdateTotemTracker(totemTracker)
    for i = 1, 4 do
        local button = totemTracker.bar[i]

        if button:IsShown() and not button.__windSkin then
            self:CreateShadow(button)
            button.__windSkin = true
        end
    end
end

function S:ElvUI_TotemTracker()
    if not (E.private.general.totemBar and E.private.WT.skins.elvui.totemBar) then
        return
    end

    local totemTracker = E:GetModule("TotemTracker")

    self:SecureHook(totemTracker, "Update", "ElvUI_UpdateTotemTracker")
end

S:AddCallback("ElvUI_TotemTracker")
