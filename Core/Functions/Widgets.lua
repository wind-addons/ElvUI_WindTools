local F ---@class Functions
local W, E ---@type WindTools, ElvUI
W, F, E = unpack((select(2, ...)))

local S = W.Modules.Skins ---@class Skins

local _G = _G
local type = type
local unpack = unpack

local CreateFrame = CreateFrame

---@cast F Functions

F.Widgets = {}

---Create a styled button
---@param parent Frame The parent frame
---@param text string? Button text (optional)
---@param width number? Button width (default: 100)
---@param height number? Button height (default: 22)
---@param onClick function? Click handler function (optional)
---@return Button button The created button
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

---Create a styled close button
---@param parent Frame The parent frame
---@param size number? Button size (width and height)
---@param onClick function? Click handler function (optional)
---@return any closeButton The created close button
local function createCloseButton(parent, size, onClick)
	local frame = CreateFrame("Button", nil, parent, "UIPanelCloseButton, BackdropTemplate")

	if size then
		frame:SetSize(size, size)
	end

	if onClick then
		frame:SetScript("OnClick", onClick)
	else
		frame:SetScript("OnClick", function()
			---Default close button behavior - hide parent
			parent:Hide()
		end)
	end

	S:Proxy("HandleCloseButton", frame)

	return frame
end

---Create a texture-based button with hover effects
---@param parent Frame The parent frame
---@param texture string|number The texture path or ID
---@param normalColor table? Normal state color {r,g,b,a} (default: {1,1,1,1})
---@param hoverColor table? Hover state color (default: ElvUI highlight color)
---@param width number Button width
---@param height number Button height
---@param onClick function? Click handler function (optional)
---@return Button textureButton The created texture button
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
		---Fade in hover texture on mouse enter
		local alpha = self.hoverTex:GetAlpha()
		E:UIFrameFadeIn(self.hoverTex, 0.4 * (1 - alpha), alpha, 1)
	end)

	frame:SetScript("OnLeave", function(self)
		---Fade out hover texture on mouse leave
		local alpha = self.hoverTex:GetAlpha()
		E:UIFrameFadeIn(self.hoverTex, 0.4 * alpha, alpha, 0)
	end)

	frame:SetScript("OnClick", onClick)

	return frame
end

---Create a styled input field
---@param parent Frame The parent frame
---@param width number? Input width (default: 200)
---@param height number? Input height (default: 20)
---@param onEnterPressed function? Enter key handler function (optional)
---@return EditBox input The created input field
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
		---Clear focus on Escape key press
		self:ClearFocus()
	end)

	S:Proxy("HandleEditBox", frame)

	return frame
end

---Create a new widget of specified type
---@param widgetType string Type of widget to create ("Button", "CloseButton", "TextureButton", "Input")
---@param ... any Arguments to pass to the widget constructor
---@return Frame? widget The created widget or nil if type is invalid
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

---Add tooltip to a frame
---@param frame Frame The frame to add tooltip to
---@param text string|function The tooltip text or function that returns text
---@param anchor string? Tooltip anchor point (default: "ANCHOR_RIGHT")
---@param x number? X offset (default: 0)
---@param y number? Y offset (default: 0)
function F.Widgets.AddTooltip(frame, text, anchor, x, y)
	anchor = anchor or "ANCHOR_RIGHT"
	x = x or 0
	y = y or 0
	if type(text) == "string" then
		frame:HookScript("OnEnter", function(self)
			_G.GameTooltip:SetOwner(self, anchor, x, y)
			_G.GameTooltip:SetText(text)
		end)

		frame:HookScript("OnLeave", function()
			_G.GameTooltip:Hide()
		end)
	end
end
