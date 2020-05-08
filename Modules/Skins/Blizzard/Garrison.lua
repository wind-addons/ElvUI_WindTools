local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _
local _G = _G
local pairs = pairs

function S:GarrisonTooltips()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.garrison) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.garrison) then
        return
    end

    local tooltips = {
        _G.GarrisonFollowerTooltip,
        _G.FloatingGarrisonFollowerTooltip,
        _G.FloatingGarrisonMissionTooltip,
        _G.FloatingGarrisonShipyardFollowerTooltip,
        _G.GarrisonShipyardFollowerTooltip,
        _G.GarrisonFollowerAbilityTooltip,
        _G.FloatingGarrisonFollowerAbilityTooltip,
        _G.GarrisonFollowerMissionAbilityWithoutCountersTooltip,
        _G.GarrisonFollowerAbilityWithoutCountersTooltip
    }

    for _, tooltip in pairs(tooltips) do
        if tooltip then
            S:CreateShadow(tooltip)
        end
    end
end

function S:Blizzard_GarrisonUI()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.garrison) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.garrison) then
        return
    end

    local frames = {
        _G.GarrisonMissionFrame,
        _G.GarrisonLandingPage,
        _G.GarrisonShipyardFrame,
        _G.OrderHallMissionFrame,
        _G.OrderHallCommandBar,
        _G.BFAMissionFrame
    }

    local tabs = {
        _G.GarrisonMissionFrameTab1,
        _G.GarrisonMissionFrameTab2,
        _G.GarrisonLandingPageTab1,
        _G.GarrisonLandingPageTab2,
        _G.GarrisonLandingPageTab3,
        _G.GarrisonShipyardFrameTab1,
        _G.GarrisonShipyardFrameTab2,
        _G.OrderHallMissionFrameTab1,
        _G.OrderHallMissionFrameTab2,
        _G.OrderHallMissionFrameTab3,
        _G.BFAMissionFrameTab1,
        _G.BFAMissionFrameTab2,
        _G.BFAMissionFrameTab3
    }

    for _, frame in pairs(frames) do
        if frame then
            S:CreateShadow(frame)
        end
    end
    for _, tab in pairs(tabs) do
        if tab then
            S:CreateBackdropShadowAfterElvUISkins(tab)
        end
    end
end

S:AddCallbackForAddon("Blizzard_GarrisonUI")
S:AddCallback("GarrisonTooltips")
