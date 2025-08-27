local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G
local LibStub = _G.LibStub

local function reskinIconButton(button, icon, size)
	button:StripTextures()
	button.Icon = button:CreateTexture(nil, "ARTWORK")
	button.Icon:SetTexture(icon)
	button.Icon:Size(size, size)
	button.Icon:Point("CENTER")

	button:HookScript("OnEnter", function(self)
		self.Icon:SetVertexColor(E.media.rgbvaluecolor.r, E.media.rgbvaluecolor.g, E.media.rgbvaluecolor.b)
	end)
	button:HookScript("OnLeave", function(self)
		self.Icon:SetVertexColor(1, 1, 1)
	end)
end

local function mainView(frame)
    frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)
    S:Proxy("HandleCloseButton", _G.WhisperPopFrameTopCloseButton)
    S:Proxy("HandleCloseButton", _G.WhisperPopFrameListDelete)
    S:Proxy("HandleScrollBar", _G.WhisperPopFrameListScrollBar)
    reskinIconButton(_G.WhisperPopFrameConfig, W.Media.Icons.buttonSetting, 14)
end

local function messageView(frame)
    frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)
    S:Proxy("HandleCloseButton", _G.WhisperPopMessageFrameTopCloseButton)
    S:Proxy("HandleCheckBox", _G.WhisperPopMessageFrameProtectCheck)

    S:Proxy("HandleNextPrevButton", _G.WhisperPopScrollingMessageFrameButtonEnd, "down", nil, true)
    S:Proxy("HandleNextPrevButton", _G.WhisperPopScrollingMessageFrameButtonDown, "down", nil, true)
    S:Proxy("HandleNextPrevButton", _G.WhisperPopScrollingMessageFrameButtonUp, "up", nil, true)
    
end

function S:WhisperPop()
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.whisperPop then
        return
    end

	self:DisableAddOnSkin("WhisperPop")

    if _G.WhisperPopFrame then
		mainView(_G.WhisperPopFrame)
	end

    if _G.WhisperPopMessageFrame then
		messageView(_G.WhisperPopMessageFrame)
	end
end

S:AddCallbackForAddon("WhisperPop")