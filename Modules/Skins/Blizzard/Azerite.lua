local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Blizzard_AzeriteUI()
	if not self:CheckDB("azerite") then
		return
	end

	self:CreateBackdropShadow(_G.AzeriteEmpoweredItemUI)
	if _G.AzeriteEmpoweredItemUITitleText then
		F.SetFontOutline(_G.AzeriteEmpoweredItemUITitleText)
	end
end

S:AddCallbackForAddon("Blizzard_AzeriteUI")
