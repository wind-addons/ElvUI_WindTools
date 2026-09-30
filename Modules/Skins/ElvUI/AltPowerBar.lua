local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

S:AddCallback("ElvUI_AltPowerBar", S:CreateElvUICheck("altPowerBar"))

function S:ElvUI_AltPowerBar()
	local bar = _G.ElvUI_AltPowerBar
	if not bar then
		return
	end

	self:CreateBackdropShadow(bar)

	bar.text:ClearAllPoints()
	bar.text:Point("CENTER", bar, "CENTER", 0, 1)
end
