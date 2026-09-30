local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local pairs = pairs

local CVAR_BROWSER_CONFIG_DIALOG_KEY = "AdvancedInterfaceOptions_cVar"

local data = S:AddCallbackForAddon("AdvancedInterfaceOptions", nil, S:CreateAddonCheck("advancedInterfaceOptions"))

local function ReskinBrowser(frame)
	frame:StripTextures()
	frame:CreateBackdrop("Transparent")

	S:Proxy("HandleScrollBar", frame.scrollbar)
	F.Move(frame, 6, 0)
	frame:Width(frame:GetWidth() - 12)
end

---@param frame Frame?
function data:CVarBrowser(frame)
	if not frame or frame.__windSkin then
		return
	end

	for _, child in pairs({ frame:GetChildren() }) do
		if child:IsObjectType("EditBox") then
			S:Proxy("HandleEditBox", child)
		elseif child:IsObjectType("Frame") then
			if child.scrollbar then
				ReskinBrowser(child)
			end
		end
	end

	frame.__windSkin = true
end

function S:AdvancedInterfaceOptions()
	local dialog = _G.LibStub("AceConfigDialog-3.0", true)
	if not dialog then
		return
	end

	local frame ---@type Frame?

	F.WaitFor(function()
		frame = dialog.BlizOptions and dialog.BlizOptions[CVAR_BROWSER_CONFIG_DIALOG_KEY]
		frame = frame and frame[CVAR_BROWSER_CONFIG_DIALOG_KEY] and frame[CVAR_BROWSER_CONFIG_DIALOG_KEY].frame
		return frame ~= nil
	end, function()
		data:CVarBrowser(frame)
	end)
end
