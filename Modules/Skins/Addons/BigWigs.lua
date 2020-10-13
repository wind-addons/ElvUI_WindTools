local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local C_Timer_NewTicker = C_Timer.NewTicker

function S:BigWigs_CreateBar(barLib, ...)
    local bar = self.hooks[barLib]["CreateBar"](barLib, ...)

    S:CreateShadow(bar, 5)

    if bar:Get("bigwigs:AddOnSkins:ibg") then
        print(1)
    end

    if bar.candyBarIconFrameBackdrop then
        S:CreateShadow(bar.candyBarIconFrameBackdrop)
    end

    C_Timer_NewTicker(
        0.1,
        function()
            local addOnSkinsBG = bar.Get and bar:Get("bigwigs:AddOnSkins:ibg")
            if addOnSkinsBG and not addOnSkinsBG.shadow then
                S:CreateShadow(addOnSkinsBG)
            end
        end,
        3
    )

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
