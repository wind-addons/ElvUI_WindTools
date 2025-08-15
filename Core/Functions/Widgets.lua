local W, F, E, L, V, P, G = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G
local type = type
local unpack = unpack

local CreateFrame = CreateFrame

F.Widgets = {}

local function createButton(parent, text, width, height, onClick)
	local frame = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")

	if text then
		frame:SetText(text)
	end

	if width then
		frame:SetWidth(width)
	else
		frame:SetWidth(100)
	end

	if height then
		frame:SetHeight(height)
	else
		frame:SetHeight(22)
	end

	if onClick then
		frame:SetScript("OnClick", onClick)
	end

	S:Proxy("HandleButton", frame)

	return frame
end

local function createCloseButton(parent, size, onClick)
	local frame = CreateFrame("Button", nil, parent, "UIPanelCloseButton, BackdropTemplate")

	if size then
		frame:SetSize(size, size)
	end

	if onClick then
		frame:SetScript("OnClick", onClick)
	else
		frame:SetScript("OnClick", function()
			parent:Hide()
		end)
	end

	S:Proxy("HandleCloseButton", frame)

	return frame
end

local function createTextureButton(parent, texture, normalColor, hoverColor, width, height, onClick)
	if not normalColor then
		normalColor = { 1, 1, 1, 1 }
	end

	if not hoverColor then
		hoverColor = E.media.rgbvaluecolor
	end

	local frame = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate")
	frame:RegisterForClicks("AnyUp")
	frame:SetSize(width, height)

	frame.normalTex = frame:CreateTexture(nil, "ARTWORK")
	frame.normalTex:SetPoint("CENTER")
	frame.normalTex:SetSize(width, height)
	frame.normalTex:SetTexture(texture)
	frame.normalTex:SetAlpha(1)

	frame.normalTex:SetVertexColor(unpack(normalColor))

	frame.hoverTex = frame:CreateTexture(nil, "ARTWORK")
	frame.hoverTex:SetPoint("CENTER")
	frame.hoverTex:SetSize(width, height)
	frame.hoverTex:SetTexture(texture)
	frame.hoverTex:SetVertexColor(unpack(hoverColor))
	frame.hoverTex:SetAlpha(0)

	frame:SetScript("OnEnter", function(self)
		local alpha = self.hoverTex:GetAlpha()
		E:UIFrameFadeIn(self.hoverTex, 0.4 * (1 - alpha), alpha, 1)
	end)

	frame:SetScript("OnLeave", function(self)
		local alpha = self.hoverTex:GetAlpha()
		E:UIFrameFadeIn(self.hoverTex, 0.4 * alpha, alpha, 0)
	end)

	frame:SetScript("OnClick", onClick)

	return frame
end

local function createInput(parent, width, height, onEnterPressed)
	local frame = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")

	if width then
		frame:SetWidth(width)
	end

	if height then
		frame:SetHeight(height)
	end

	frame:SetScript("OnEnterPressed", onEnterPressed)

	frame:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)

	S:Proxy("HandleEditBox", frame)

	return frame
end

function F.Widgets.New(widgetType, ...)
	if not widgetType then
		return
	end

	if widgetType == "Button" then
		return createButton(...)
	elseif widgetType == "CloseButton" then
		return createCloseButton(...)
	elseif widgetType == "TextureButton" then
		return createTextureButton(...)
	elseif widgetType == "Input" then
		return createInput(...)
	end
end

function F.Widgets.AddTooltip(frame, text, anchor, x, y)
	anchor = anchor or "ANCHOR_RIGHT"
	x = x or 0
	y = y or 0
	if type(text) == "string" then
		frame:HookScript("OnEnter", function(self)
			_G.GameTooltip:SetOwner(self, anchor, x, y)
			_G.GameTooltip:SetText(text)
		end)

		frame:HookScript("OnLeave", function(self)
			_G.GameTooltip:Hide()
		end)
	end
end
