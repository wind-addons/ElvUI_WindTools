local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local TT = E:GetModule("Tooltip")

function S:AppearanceTooltip()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.appearanceTooltip then
		return
	end

	local tooltip = _G.AppearanceTooltipTooltip
	if tooltip then
		TT:SetStyle(tooltip)
	end
end

S:AddCallbackForAddon("AppearanceTooltip")
