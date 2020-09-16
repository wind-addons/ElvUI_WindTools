local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:BigWigs_CreateBar(barLib, ...)
    local bar = self.hooks[barLib]["CreateBar"](barLib, ...)
    S:CreateShadow(bar, 6)
    if bar.candyBarIconFrameBackdrop then
        S:CreateShadow(bar.candyBarIconFrameBackdrop)
    end
    return bar
end

function S:BigWigs_Plugins()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.bigWigs then
        return
    end

    if not _G.BigWigs then
        return
    end

    local barLib = _G.BigWigs:GetPlugin("Bars")
    self:RawHook(barLib, "CreateBar", "BigWigs_CreateBar")
end

S:AddCallbackForAddon("BigWigs_Plugins")
