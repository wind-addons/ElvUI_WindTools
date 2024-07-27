local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

function S:Blizzard_StableUI()
    if not self:CheckDB("stable") then
        return
    end

    self:CreateShadow(_G.StableFrame)
end

S:AddCallbackForAddon("Blizzard_StableUI")
