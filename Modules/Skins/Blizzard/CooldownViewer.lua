local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local ES = E:GetModule("Skins")

local _G = _G
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local pairs = pairs

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

	self:SecureHook(ES, "CooldownManager_SkinIcon", function(_, _, icon)
		if icon.__windSkin then
			return
		end
		self:CreateBackdropShadow(icon)
		icon.__windSkin = true
	end)

	self:SecureHook(ES, "CooldownManager_SkinBar", function(_, _, bar)
		---@cast bar StatusBar
		if bar.__windSkin then
			return
		end

		bar:SetStatusBarTexture(E.media.normTex)
		bar:GetStatusBarTexture():SetTextureSliceMode(0)

		for _, region in pairs({ bar:GetRegions() }) do
			if region:IsObjectType("Texture") and region.backdrop then
				self:CreateBackdropShadow(region)
				break
			end
		end
		bar.__windSkin = true
	end)
end

S:AddCallbackForAddon("Blizzard_CooldownViewer")
