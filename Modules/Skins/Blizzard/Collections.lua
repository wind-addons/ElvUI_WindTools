local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_Collections()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.collections) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.collections) then
        return
    end

    S:CreateShadow(_G.CollectionsJournal)
    S:CreateShadow(_G.WardrobeFrame)

    for i = 1, 5 do
        S:CreateBackdropShadowAfterElvUISkins(_G["CollectionsJournalTab" .. i])
    end
end

S:AddCallbackForAddon("Blizzard_Collections")
