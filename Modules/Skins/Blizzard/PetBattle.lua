local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

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

	self:CreateBackdropShadow(_G.PetBattleFrame.ActiveAlly.ActualHealthBar)
	self:CreateBackdropShadow(_G.PetBattleFrame.ActiveAlly.Icon)
	F.SetFontOutline(_G.PetBattleFrame.ActiveAlly.Name)

	self:CreateBackdropShadow(_G.PetBattleFrame.ActiveEnemy.ActualHealthBar)
	self:CreateBackdropShadow(_G.PetBattleFrame.ActiveEnemy.Icon)
	F.SetFontOutline(_G.PetBattleFrame.ActiveEnemy.Name)

	self:CreateShadow(_G.PetBattleFrame.Ally2)
	self:CreateShadow(_G.PetBattleFrame.Ally3)
	self:CreateShadow(_G.PetBattleFrame.Enemy2)
	self:CreateShadow(_G.PetBattleFrame.Enemy3)
end

S:AddCallback("PetBattle")
