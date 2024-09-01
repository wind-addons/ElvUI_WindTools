local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Blizzard_DelvesDifficultyPicker()
	if not self:CheckDB("lfg", "delves") then
		return
	end

	local DifficultyPickerFrame = _G.DelvesDifficultyPickerFrame
	if DifficultyPickerFrame then
		self:CreateShadow(DifficultyPickerFrame)
		DifficultyPickerFrame.CloseButton:ClearAllPoints()
		DifficultyPickerFrame.CloseButton:SetPoint("TOPRIGHT", DifficultyPickerFrame, "TOPRIGHT", -3, -3)
	end
end

function S:Blizzard_DelvesCompanionConfiguration()
	if not self:CheckDB("lfg", "delves") then
		return
	end

	local CompanionConfigurationFrame = _G.DelvesCompanionConfigurationFrame
	if CompanionConfigurationFrame then
		self:CreateShadow(CompanionConfigurationFrame)
		CompanionConfigurationFrame.CloseButton:ClearAllPoints()
		CompanionConfigurationFrame.CloseButton:SetPoint("TOPRIGHT", CompanionConfigurationFrame, "TOPRIGHT", -3, -3)

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

S:AddCallbackForAddon("Blizzard_DelvesDifficultyPicker")
S:AddCallbackForAddon("Blizzard_DelvesCompanionConfiguration")
