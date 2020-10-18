local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local C_PetBattles_GetNumAuras = C_PetBattles.GetNumAuras

function S:PetBattle()
    if not self:CheckDB("petbattleui", "petBattle") then
        return
    end

    local f = _G.PetBattleFrame
    local bf = f.BottomFrame
    local actionBar = _G.ElvUIPetBattleActionBar

    self:CreateShadow(actionBar)

    if actionBar.shadow then
        actionBar.shadow:ClearAllPoints()
        actionBar.shadow:Point("TOPLEFT", bf.xpBar, "TOPLEFT", -5, 5)
        actionBar.shadow:Point("BOTTOMRIGHT", actionBar, "BOTTOMRIGHT", 5, -5)
    end

    self:CreateShadow(_G.PetBattleFrame.ActiveAlly.HealthBarBackdrop)
    self:CreateShadow(_G.PetBattleFrame.ActiveAlly.IconBackdrop)
    F.SetFontOutline(_G.PetBattleFrame.ActiveAlly.Name)

    self:CreateShadow(_G.PetBattleFrame.ActiveEnemy.HealthBarBackdrop)
    self:CreateShadow(_G.PetBattleFrame.ActiveEnemy.IconBackdrop)
    F.SetFontOutline(_G.PetBattleFrame.ActiveEnemy.Name)

    self:CreateShadow(_G.PetBattleFrame.Ally2.HealthBarBackdrop)
    self:CreateShadow(_G.PetBattleFrame.Ally2.backdrop)

    self:CreateShadow(_G.PetBattleFrame.Ally3.backdrop)
    self:CreateShadow(_G.PetBattleFrame.Ally3.HealthBarBackdrop)

    self:CreateShadow(_G.PetBattleFrame.Enemy2.HealthBarBackdrop)
    self:CreateShadow(_G.PetBattleFrame.Enemy2.backdrop)

    self:CreateShadow(_G.PetBattleFrame.Enemy3.backdrop)
    self:CreateShadow(_G.PetBattleFrame.Enemy3.HealthBarBackdrop)
end

S:AddCallback("PetBattle")
