local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local AB = E.ActionBars

local _G = _G
local MICRO_BUTTONS = _G.MICRO_BUTTONS
	or {
		"CharacterMicroButton",
		"SpellbookMicroButton",
		"TalentMicroButton",
		"AchievementMicroButton",
		"QuestLogMicroButton",
		"GuildMicroButton",
		"LFDMicroButton",
		"EJMicroButton",
		"CollectionsMicroButton",
		"MainMenuMicroButton",
		"HelpMicroButton",
		"StoreMicroButton",
	}

function S:MicroButtons()
	if not self:CheckDB(nil, "microButtons") then
		return
	end

	local microBar = _G.ElvUI_MicroBar
	local elvuiButtons = AB and AB.MICRO_BUTTONS
	if microBar and elvuiButtons then
		self:TryCreateBackdropShadow(microBar)

		for _, name in next, elvuiButtons do
			local button = _G[name]
			if button then
				self:CreateLowerShadow(button)
				self:BindShadowColorWithBorder(button)
			end
		end

		return
	end

	-- Fallback to Blizzard micro buttons
	for i = 1, #MICRO_BUTTONS do
		local button = _G[MICRO_BUTTONS[i]]
		if button and button.CreateBackdrop and not button.backdrop then
			button:CreateBackdrop()
			self:CreateBackdropShadow(button, true)
		elseif button then
			self:TryCreateBackdropShadow(button)
		end
	end
end

S:AddCallback("MicroButtons")
