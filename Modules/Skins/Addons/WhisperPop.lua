local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins ---@type Skins

local _G = _G
local unpack = unpack
local pairs = pairs
local hooksecurefunc = hooksecurefunc

local function notifyButton(button)
	button:CreateBackdrop()
	S:CreateBackdropShadow(button)
	button:SetScript("OnMouseDown", nil)
	button:SetScript("OnMouseUp", nil)

	button:GetHighlightTexture():SetTexture(E.Media.Textures.White8x8)
	button:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.3)

	button:GetPushedTexture():SetTexture(E.Media.Textures.White8x8)
	button:GetPushedTexture():SetVertexColor(1, 1, 0, 0.3)

	button:GetCheckedTexture():SetTexture(E.Media.Textures.White8x8)
	button:GetCheckedTexture():SetVertexColor(1, 0.875, 0.125, 0.3)

	button.icon:SetTexCoord(unpack(E.TexCoords))
end

local function mainView(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	S:Proxy("HandleCloseButton", _G.WhisperPopFrameTopCloseButton)
	S:Proxy("HandleCloseButton", _G.WhisperPopFrameListDelete)
	S:Proxy("HandleScrollBar", _G.WhisperPopFrameListScrollBar)
	S:ReskinIconButton(_G.WhisperPopFrameConfig, W.Media.Icons.buttonSetting, 14)
end

local function messageView(frame)
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	S:Proxy("HandleCloseButton", _G.WhisperPopMessageFrameTopCloseButton)
	S:Proxy("HandleCheckBox", _G.WhisperPopMessageFrameProtectCheck)

	S:Proxy("HandleNextPrevButton", _G.WhisperPopScrollingMessageFrameButtonUp, "up", nil, true)
	S:Proxy("HandleNextPrevButton", _G.WhisperPopScrollingMessageFrameButtonDown, "down", nil, true)
	S:ReskinIconButton(_G.WhisperPopScrollingMessageFrameButtonEnd, W.Media.Icons.buttonGoEnd, 22, -1.571)

	F.InternalizeMethod(frame, "SetPoint")
	hooksecurefunc(frame, "SetPoint", function(self, ...)
		F.Move(self, -6, 0)
	end)
end

local function optionFrame(frame)
	for _, child in pairs({ frame:GetChildren() }) do
		if child:IsObjectType("CheckButton") then
			S:Proxy("HandleCheckBox", child)
			child:Size(24)
			F.Move(child, 0, -3)
		elseif child:IsObjectType("Button") then
			if child.dropdown then
				child.Button = child.toggleButton
				S:Proxy("HandleDropDownBox", child, child:GetWidth())
			else
				S:Proxy("HandleButton", child)
			end
		elseif child:IsObjectType("EditBox") then
			S:Proxy("HandleEditBox", child)
		elseif child:IsObjectType("Slider") then
			S:Proxy("HandleSliderFrame", child)
		end
	end
end

function S:WhisperPop()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.whisperPop then
		return
	end

	self:DisableAddOnSkin("WhisperPop")

	if _G.WhisperPop then
		mainView(_G.WhisperPop.frame)
		messageView(_G.WhisperPop.messageFrame)
		notifyButton(_G.WhisperPop.notifyButton)
		optionFrame(_G.WhisperPop.optionFrame)
	end
end

S:AddCallbackForAddon("WhisperPop")
