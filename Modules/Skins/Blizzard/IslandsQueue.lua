local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_IslandsQueueUI()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.tooltip) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.tooltip) then
        return
    end
    local tt = _G.IslandsQueueFrameTooltip:GetParent()
    S:CreateShadow(tt)
end

S:AddCallbackForAddon("Blizzard_IslandsQueueUI")
