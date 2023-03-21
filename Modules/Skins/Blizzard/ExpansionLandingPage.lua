local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_ExpansionLandingPage()
    if not self:CheckDB("expansionLanding", "expansionLandingPage") then
        return
    end

    self:CreateShadow(_G.ExpansionLandingPage)
end

S:AddCallbackForAddon("Blizzard_ExpansionLandingPage")