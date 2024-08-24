local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local ES = E.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs

local function ReskinText(text)
	if text then
		F.SetFontOutline(text)
	end
end

local function ReskinLabel(label)
	if label then
		F.SetFontOutline(label)
	end
end

local function ReskinBar(bar)
	if bar and bar.backdrop then
		S:CreateBackdropShadow(bar)
		ReskinLabel(bar.Label)
	end
end

local function ReskinUIWidgetContainer(container)
	if not container or not container.widgetFrames then
		return
	end

	for _, widget in pairs(container.widgetFrames) do
		if not widget.__windSkin then
			ReskinText(widget.Text)
			ReskinBar(widget.Bar)
			widget.__windSkin = true
		end
	end

	hooksecurefunc(container, "ProcessWidget", function(container)
		for _, widget in pairs(container.widgetFrames) do
			if not widget.__windSkin then
				ReskinText(widget.Text)
				ReskinBar(widget.Bar)
				widget.__windSkin = true
			end
		end
	end)
end

function S:BlizzardUIWidget()
	if not self:CheckDB("misc", "uiWidget") then
		return
	end

	self:SecureHook(_G.UIWidgetTemplateStatusBarMixin, "Setup", function(widget)
		if widget:IsForbidden() or widget.widgetSetID and widget.widgetSetID == 283 then
			return
		end

		if not widget.__windSkin then
			ReskinLabel(widget.Label)
			ReskinBar(widget.Bar)
			ReskinLabel(widget.Bar.Label)

			if widget.isJailersTowerBar and self:CheckDB(nil, "scenario") then
				widget.Bar:SetWidth(234)
			end
		end
	end)

	self:SecureHook(_G.UIWidgetTemplateCaptureBarMixin, "Setup", function(widget)
		if not widget.__windSkin then
			ReskinBar(widget.Bar)
		end
	end)

	self:SecureHook(ES, "SkinStatusBarWidget", function(_, widget)
		ReskinBar(widget.Bar)
	end)

	self:SecureHook(ES, "SkinDoubleStatusBarWidget", function(_, widget)
		ReskinBar(widget.LeftBar)
		ReskinBar(widget.RightBar)
	end)

	ES.SkinTextWithStateWidget = E.noop -- Use Blizzard default color

	ReskinUIWidgetContainer(_G.UIWidgetTopCenterContainerFrame)
end

S:AddCallback("BlizzardUIWidget")
