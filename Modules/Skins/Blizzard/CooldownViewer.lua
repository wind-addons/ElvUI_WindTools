local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

function S:Blizzard_CooldownViewer()
	if not self:CheckDB("cooldownManager", "cooldownViewer") then
		return
	end

	local CooldownViewerSettings = _G.CooldownViewerSettings
	if not CooldownViewerSettings then
		return
	end

	self:CreateShadow(CooldownViewerSettings)

	for i, tab in ipairs({ CooldownViewerSettings.SpellsTab, CooldownViewerSettings.AurasTab }) do
		if tab.backdrop then
			self:CreateBackdropShadow(tab)
			tab.backdrop:SetTemplate("Transparent")
		end

		if i == 1 then
			hooksecurefunc(tab, "SetPoint", function(theTab, _, _, _, x, y)
				if x == 1 and y == -10 then
					theTab:ClearAllPoints()
					_G.UIParent.SetPoint(theTab, "TOPLEFT", CooldownViewerSettings, "TOPRIGHT", 3, -10)
				end
			end)

			tab:ClearAllPoints()
			_G.UIParent.SetPoint(tab, "TOPLEFT", CooldownViewerSettings, "TOPRIGHT", 3, -10)
		else
			F.Move(tab, 0, -2)
		end
	end
end

S:AddCallbackForAddon("Blizzard_CooldownViewer")
