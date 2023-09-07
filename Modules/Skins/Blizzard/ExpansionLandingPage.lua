local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_ExpansionLandingPage()
    if not self:CheckDB("expansionLanding", "expansionLandingPage") then
        return
    end

    self:CreateShadow(_G.ExpansionLandingPage)

    -- Remove the background of the scrollable frame
    local overlay = _G.ExpansionLandingPage.Overlay
    if overlay then
        for _, child in next, {overlay:GetChildren()} do
            if child.DragonridingPanel and child.ScrollFadeOverlay then
                child.ScrollFadeOverlay:Hide()
            end
        end
    end
end

S:AddCallbackForAddon("Blizzard_ExpansionLandingPage")
