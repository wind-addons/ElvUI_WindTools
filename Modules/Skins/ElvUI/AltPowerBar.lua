local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local data = S:AddCallback("ElvUI_AltPowerBar")
data.check = function()
	return (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.altPowerBar)
end

local _G = _G

function S:ElvUI_AltPowerBar()
	local bar = _G.ElvUI_AltPowerBar
	if not bar then
		return
	end

	self:CreateBackdropShadow(bar)

	bar.text:ClearAllPoints()
	bar.text:Point("CENTER", bar, "CENTER", 0, 1)
end

