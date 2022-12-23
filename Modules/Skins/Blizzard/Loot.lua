local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G

local C_LootHistory_GetNumItems = C_LootHistory.GetNumItems

function S:LootHistoryFrame_FullUpdate()
    local numItems = C_LootHistory_GetNumItems()
    for i = 1, numItems do
        local frame = _G.LootHistoryFrame.itemFrames[i]
        if frame and not frame.__windSkin then
            F.SetFontWithDB(frame.WinnerRoll, E.private.WT.skins.rollResult)
            frame.__windSkin = true
        end
    end
end

function S:LootFrame()
    self:SecureHook("LootHistoryFrame_FullUpdate")

    if not self:CheckDB("loot") then
        return
    end

    F.SetFontOutline(_G.BonusRollFrame.PromptFrame.InfoFrame.Cost)
    F.SetFontOutline(_G.BonusRollFrame.PromptFrame.InfoFrame.Label)

    self:CreateShadow(_G.BonusRollFrame)
    self:CreateBackdropShadow(_G.BonusRollLootWonFrame)
    self:CreateBackdropShadow(_G.BonusRollMoneyWonFrame)

    self:CreateShadow(_G.LootHistoryFrame)
    _G.LootHistoryFrame:SetWidth(300)
    self:CreateShadow(_G.LootHistoryFrame.ResizeButton)
    _G.LootHistoryFrame.ResizeButton:SetWidth(300)
    _G.LootHistoryFrame.ResizeButton:SetTemplate("Transparent")
end

S:AddCallback("LootFrame")
