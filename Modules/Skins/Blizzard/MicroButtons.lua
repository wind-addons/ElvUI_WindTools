local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

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

	for i = 1, #MICRO_BUTTONS do
		if _G[MICRO_BUTTONS[i]] then
			if not _G[MICRO_BUTTONS[i]].backdrop then
				_G[MICRO_BUTTONS[i]]:CreateBackdrop()
				self:CreateBackdropShadow(_G[MICRO_BUTTONS[i]], true)
			end
		end
	end
end

S:AddCallback("MicroButtons")
