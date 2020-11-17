local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_Collections()
    if not self:CheckDB("collections") then
        return
    end

    self:CreateBackdropShadow(_G.CollectionsJournal)
    self:CreateBackdropShadow(_G.WardrobeFrame)
    self:CreateBackdropShadow(_G.WardrobeOutfitEditFrame)

    for i = 1, 5 do
        self:ReskinTab(_G["CollectionsJournalTab" .. i])
    end
end

S:AddCallbackForAddon("Blizzard_Collections")
