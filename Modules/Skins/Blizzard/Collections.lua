local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_Collections()
    if not self:CheckDB("collections") then
        return
    end

    self:CreateBackdropShadowAfterElvUISkins(_G.CollectionsJournal)
    self:CreateBackdropShadowAfterElvUISkins(_G.WardrobeFrame)
    self:CreateBackdropShadowAfterElvUISkins(_G.WardrobeOutfitEditFrame)

    for i = 1, 5 do
        self:ReskinTab(_G["CollectionsJournalTab" .. i])
    end
end

S:AddCallbackForAddon("Blizzard_Collections")
