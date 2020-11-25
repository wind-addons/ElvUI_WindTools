local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_PlayerChoiceUI()
    if not self:CheckDB("playerChoice") then
        return
    end

    local frame = _G.PlayerChoiceFrame
    if not frame then
        return
    end
    self:CreateBackdropShadow(_G.PlayerChoiceFrame)
end

S:AddCallbackForAddon("Blizzard_PlayerChoiceUI")
