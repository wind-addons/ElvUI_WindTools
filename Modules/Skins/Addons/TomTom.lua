local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

local RunNextFrame = RunNextFrame

local function SkinPasteWindow(pasteWindow)
	if not pasteWindow or pasteWindow.__windSkin then
		return
	end

	pasteWindow:StripTextures()
	pasteWindow:SetTemplate("Transparent")
	S:CreateShadow(pasteWindow)

	local EditBox = pasteWindow.EditBox
	if EditBox then
		EditBox:StripTextures()
		S:Proxy("HandleEditBox", EditBox.ScrollingEditBox)
		EditBox.ScrollingEditBox.backdrop:SetOutside(EditBox.ScrollingEditBox, 4, 4)
	end

	local CloseButton = pasteWindow.CloseButton
	if CloseButton then
		S:Proxy("HandleButton", CloseButton)
	end

	local PasteButton = pasteWindow.PasteButton
	if PasteButton then
		S:Proxy("HandleButton", PasteButton)
	end

	pasteWindow.__windSkin = true
end

function S:TomTom()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.tomTom then
		return
	end

	if not _G.TomTom then
		return
	end

	if _G.TomTomBlock then
		self:Proxy("HandleFrame", _G.TomTomBlock)
		self:CreateShadow(_G.TomTomBlock)
		self:BindShadowColorWithBorder(_G.TomTomBlock)

		if _G.TomTomBlock.Text then
			F.SetFont(_G.TomTomBlock.Text, E.db.general.font)
		end
	end

	F.ListenValueUpdate(_G.TomTom, "pasteWindow", function(stop, pasteWindow)
		RunNextFrame(function()
			SkinPasteWindow(pasteWindow)
		end)
		stop()
	end)

	self:DisableAddOnSkin("TomTom")
end

S:AddCallbackForAddon("TomTom")
