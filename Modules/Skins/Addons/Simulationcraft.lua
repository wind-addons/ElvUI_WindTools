local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

local data = S:AddCallbackForAddon("Simulationcraft", nil, S:CreateAddonCheck("simulationcraft"))

function data:SkinMainFrame() -- self is the Simulationcraft addon, not data
	if not _G.SimcFrame or _G.SimcFrame.__windSkin then
		return
	end

	_G.SimcFrame.__windSkin = true

	_G.SimcFrame:SetTemplate("Transparent")
	S:CreateShadow(_G.SimcFrame)

	S:Proxy("HandleButton", _G.SimcFrameButton)
	S:Proxy("HandleCheckBox", _G.SimcFrame.CheckButton)
	S:Proxy("HandleScrollBar", _G.SimcScrollFrameScrollBar)

	F.SetFont(_G.SimcFrameButton:GetNormalFontObject())
	F.SetFont(_G.SimcEditBox)
	F.SetFont(_G.SimcFrame.CheckButton.Text)
	F.Move(_G.SimcFrame.CheckButton.Text, 0, -3)
end

function S:Simulationcraft()
	self:DisableAddOnSkin("Simulationcraft")

	local addon = _G.LibStub("AceAddon-3.0"):GetAddon("Simulationcraft")

	if addon then
		self:SecureHook(addon, "GetMainFrame", data.SkinMainFrame)
	end
end
