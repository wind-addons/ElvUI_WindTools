local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_UIPanels_Game")
data.toggle = "character"
data = S:AddCallbackForAddon("Blizzard_TokenUI")
data.toggle = "character"

local _G = _G

function S:Blizzard_UIPanels_Game()
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
	self:CreateShadow(_G.ReputationFrame.ReputationDetailFrame)
	_G.ReputationFrame.ReputationDetailFrame:ClearAllPoints()
	_G.ReputationFrame.ReputationDetailFrame:Point("TOPLEFT", _G.ReputationFrame, "TOPRIGHT", 3, 0)
end

function S:Blizzard_TokenUI()
	self:CreateShadow(_G.CurrencyTransferLog)
	self:CreateShadow(_G.CurrencyTransferMenu)
end

