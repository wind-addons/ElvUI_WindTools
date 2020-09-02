local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:LootFrame()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.loot) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.loot) then
        return
    end

    S:CreateShadow(_G.BonusRollFrame)

    F.SetFontOutline(_G.BonusRollFrame.PromptFrame.InfoFrame.Cost)
    F.SetFontOutline(_G.BonusRollFrame.PromptFrame.InfoFrame.Label)
end

S:AddCallback("LootFrame")
