local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule('Skins')

local _G = _G

function S:Blizzard_AuctionHouseUI()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.auctionhouse) then return end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.auctionHouse) then return end

    local tabs = {_G.AuctionHouseFrameBuyTab, _G.AuctionHouseFrameSellTab, _G.AuctionHouseFrameAuctionsTab}

    S:CreateShadow(_G.AuctionHouseFrame)

    for _, tab in pairs(tabs) do if tab then S:CreateTabShadowAfterElvUISkins(tab) end end
end

S:AddCallbackForAddon('Blizzard_AuctionHouseUI')
