local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local C_Timer_NewTicker = C_Timer.NewTicker

function S:BigWigs_CreateBar(barLib, ...)
    local bar = self.hooks[barLib]["CreateBar"](barLib, ...)

    if E.private.WT.skins.shadow then
        self:CreateShadow(bar, 5)
        bar.candyBarIconFrame:CreateBackdrop()
        self:CreateShadow(bar.candyBarIconFrame.backdrop)
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
