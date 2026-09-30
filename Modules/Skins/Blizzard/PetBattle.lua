local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

if not E.Forever then
	S:AddCallback("PetBattle", "petbattleui", "petBattle")
end

function S:PetBattle()
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
	F.SetFont(_G.PetBattleFrame.ActiveAlly.Name)

	self:CreateBackdropShadow(_G.PetBattleFrame.ActiveEnemy.ActualHealthBar)
	self:CreateBackdropShadow(_G.PetBattleFrame.ActiveEnemy.Icon)
	F.SetFont(_G.PetBattleFrame.ActiveEnemy.Name)

	self:CreateShadow(_G.PetBattleFrame.Ally2)
	self:CreateShadow(_G.PetBattleFrame.Ally3)
	self:CreateShadow(_G.PetBattleFrame.Enemy2)
	self:CreateShadow(_G.PetBattleFrame.Enemy3)
end
