local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Blizzard_Collections()
    if not self:CheckDB("collections") then
        return
    end

    self:CreateShadow(_G.CollectionsJournal)
    self:CreateShadow(_G.WardrobeFrame)

    for i = 1, 5 do
        self:CreateBackdropShadowAfterElvUISkins(_G["CollectionsJournalTab" .. i])
    end
end

S:AddCallbackForAddon("Blizzard_Collections")
