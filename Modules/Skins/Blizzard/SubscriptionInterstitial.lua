local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")
local ES = E:GetModule("Skins")

local _G = _G

function S:Blizzard_SubscriptionInterstitialUI()
    if not self:CheckDB("playerChoice", "subscriptionInterstitial") then
        return
    end

    local frame = _G.SubscriptionInterstitialFrame

    frame:StripTextures()
    frame:CreateBackdrop('Transparent')
    frame.ShadowOverlay:Kill()

    ES:HandleCloseButton(frame.CloseButton)
    ES:HandleButton(frame.ClosePanelButton)

    self:CreateShadow(frame)
end

S:AddCallbackForAddon("Blizzard_SubscriptionInterstitialUI")
