local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

function S:Simulationcraft_SkinMainFrame()
	if not _G.SimcFrame or _G.SimcFrame.__windSkin then
		return
	end

	_G.SimcFrame.__windSkin = true

	_G.SimcFrame:SetTemplate("Transparent")
	self:CreateShadow(_G.SimcFrame)

	self:Proxy("HandleButton", _G.SimcFrameButton)
	self:Proxy("HandleScrollBar", _G.SimcScrollFrameScrollBar)

	F.SetFontOutline(_G.SimcFrameButton:GetNormalFontObject())
	F.SetFontOutline(_G.SimcEditBox)
end

function S:Simulationcraft()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.simulationcraft then
		return
	end

	self:DisableAddOnSkin("Simulationcraft")

	local addon = _G.LibStub("AceAddon-3.0"):GetAddon("Simulationcraft")

	if addon then
		self:SecureHook(addon, "GetMainFrame", "Simulationcraft_SkinMainFrame")
	end
end

S:AddCallbackForAddon("Simulationcraft")
