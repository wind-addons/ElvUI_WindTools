local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_UIPanels_Game()
	if not self:CheckDB("character") then
		return
	end

	-- Character
	self:CreateShadow(_G.CharacterFrame)
	self:CreateShadow(_G.GearManagerDialogPopup)
	self:CreateShadow(_G.EquipmentFlyoutFrameButtons)
	for i = 1, 4 do
		self:ReskinTab(_G["CharacterFrameTab" .. i])
	end

	-- Token
	self:CreateShadow(_G.TokenFramePopup)

	-- Remove the background
	local modelScene = _G.CharacterModelScene
	modelScene.BackgroundTopLeft:Hide()
	modelScene.BackgroundTopRight:Hide()
	modelScene.BackgroundBotLeft:Hide()
	modelScene.BackgroundBotRight:Hide()
	modelScene.BackgroundOverlay:Hide()
	if modelScene.backdrop then
		modelScene.backdrop:Kill()
	end

	-- Reputation
	self:CreateShadow(_G.ReputationDetailFrame)

	-- Currency Transfer
	self:CreateShadow(_G.CurrencyTransferLog)
	self:CreateShadow(_G.CurrencyTransferMenu)
end

S:AddCallbackForAddon("Blizzard_UIPanels_Game")
