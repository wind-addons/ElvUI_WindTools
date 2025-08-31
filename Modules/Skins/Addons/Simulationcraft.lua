local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

function S:Simulationcraft_SkinMainFrame()
	if not _G.SimcFrame or _G.SimcFrame.__windSkin then
		return
	end

	_G.SimcFrame.__windSkin = true

	_G.SimcFrame:SetTemplate("Transparent")
	self:CreateShadow(_G.SimcFrame)

	self:Proxy("HandleButton", _G.SimcFrameButton)
	self:Proxy("HandleCheckBox", _G.SimcFrame.CheckButton)
	self:Proxy("HandleScrollBar", _G.SimcScrollFrameScrollBar)

	F.SetFontOutline(_G.SimcFrameButton:GetNormalFontObject())
	F.SetFontOutline(_G.SimcEditBox)
	F.SetFontOutline(_G.SimcFrame.CheckButton.Text)
	F.Move(_G.SimcFrame.CheckButton.Text, 0, -3)
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
