local W, F, E, L = unpack(select(2, ...))
local ES = E.Skins
local S = W.Modules.Skins

local _G = _G

local function SkinWarpDeplete()
    for _, barFrame in pairs(_G.WarpDeplete.bars) do
        local bar = barFrame.bar
        if not bar.windStyle then
            S:CreateShadow(bar)
            bar.windStyle = true
        end
    end

    S:CreateShadow(_G.WarpDeplete.forces.bar)
end

function S:WarpDeplete()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.warpDeplete then
        return
    end

    if not _G.WarpDeplete then
        return
    end

    if _G.WarpDeplete.bars then
        SkinWarpDeplete()
    else
        hooksecurefunc(_G.WarpDeplete, "InitDisplay", SkinWarpDeplete)
    end
end

S:AddCallbackForAddon("WarpDeplete")
