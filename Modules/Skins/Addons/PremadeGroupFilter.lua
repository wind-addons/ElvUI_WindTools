local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:PremadeGroupsFilter()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.premadeGroupsFilter then
        return
    end



end

S:AddCallbackForAddon("PremadeGroupsFilter")
S:DisableAddOnSkin("PremadeGroupsFilter")