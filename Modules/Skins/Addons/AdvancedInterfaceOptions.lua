local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

local CVAR_BROWSER_CONFIG_DIALOG_KEY = "AdvancedInterfaceOptions_cVar"

local function ReskinBrowser(frame)
	frame:StripTextures()
	frame:CreateBackdrop("Transparent")

	S:Proxy("HandleScrollBar", frame.scrollbar)
	F.Move(frame, 6, 0)
	frame:Width(frame:GetWidth() - 12)
end

function S:AdvancedInterfaceOptions()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.advancedInterfaceOptions then
		return
	end

	local dialog = _G.LibStub("AceConfigDialog-3.0", true)
	if not dialog then
		return
	end

	local frame = dialog.BlizOptions and dialog.BlizOptions[CVAR_BROWSER_CONFIG_DIALOG_KEY]
	frame = frame[CVAR_BROWSER_CONFIG_DIALOG_KEY] and frame[CVAR_BROWSER_CONFIG_DIALOG_KEY].frame
	if frame and not frame.__windSkin then
		for _, child in pairs({ frame:GetChildren() }) do
			if child:IsObjectType("EditBox") then
				self:Proxy("HandleEditBox", child)
			elseif child:IsObjectType("Frame") then
				if child.scrollbar then
					ReskinBrowser(child)
				end
			end
		end

		frame.__windSkin = true
	end
end

S:AddCallbackForAddon("AdvancedInterfaceOptions")
