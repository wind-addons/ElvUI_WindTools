
local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_BindingUI()
    if not self:CheckDB("binding") then
        return
    end

    self:CreateBackdropShadowAfterElvUISkins(_G.QuickKeybindFrame)
end

S:AddCallbackForAddon("Blizzard_BindingUI")
