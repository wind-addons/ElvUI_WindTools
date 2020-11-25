local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_CovenantSanctum()
    if not self:CheckDB("covenantSanctum") then
        return
    end

    self:CreateBackdropShadow(_G.CovenantSanctumFrame)
end

S:AddCallbackForAddon("Blizzard_CovenantSanctum")
