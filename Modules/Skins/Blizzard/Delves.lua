local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallbackForAddon("Blizzard_DelvesDifficultyPicker")
data.toggle = "lfg"
data.private = "delves"
data = S:AddCallbackForAddon("Blizzard_DelvesCompanionConfiguration")
data.toggle = "lfg"
data.private = "delves"

local _G = _G
local pairs = pairs

function S:Blizzard_DelvesDifficultyPicker()
	local DifficultyPickerFrame = _G.DelvesDifficultyPickerFrame
	if DifficultyPickerFrame then
		self:CreateShadow(DifficultyPickerFrame)
	end
end

function S:Blizzard_DelvesCompanionConfiguration()
	local CompanionConfigurationFrame = _G.DelvesCompanionConfigurationFrame
	if CompanionConfigurationFrame then
		self:CreateShadow(CompanionConfigurationFrame)

		for _, frame in pairs({
			CompanionConfigurationFrame.CompanionCombatRoleSlot,
			CompanionConfigurationFrame.CompanionUtilityTrinketSlot,
			CompanionConfigurationFrame.CompanionCombatTrinketSlot,
		}) do
			self:CreateShadow(frame.OptionsList)
			self:HighAlphaTransparent(frame.OptionsList)
		end
	end

	local CompanionAbilityListFrame = _G.DelvesCompanionAbilityListFrame
	if CompanionAbilityListFrame then
		self:CreateShadow(CompanionAbilityListFrame)
	end
end

