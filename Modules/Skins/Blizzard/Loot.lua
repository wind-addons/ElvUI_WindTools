local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:LootFrame()
    if not self:CheckDB("loot") then
        return
    end
    
    F.SetFontOutline(_G.BonusRollFrame.PromptFrame.InfoFrame.Cost)
    F.SetFontOutline(_G.BonusRollFrame.PromptFrame.InfoFrame.Label)
    
    self:CreateShadow(_G.BonusRollFrame)
    self:CreateShadow(_G.BonusRollLootWonFrame.backdrop)
end

S:AddCallback("LootFrame")
