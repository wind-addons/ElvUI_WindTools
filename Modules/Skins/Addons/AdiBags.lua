local addonName, addon = ...
local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G

function S:AdiBags()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.adiBags then
        return
    end
    if _G.AddAdiBagsElvUISkinPostHook then
        _G.AddAdiBagsElvUISkinPostHook(
            "frame",
            function(frame)
                S:CreateShadow(frame)
            end
        )
    end
end

S:AddCallbackForAddon("AdiBags")
