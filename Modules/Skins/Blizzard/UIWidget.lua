local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins
local ES = E.Skins
local C = W.Utilities.Color

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local strlower = strlower

local function ReskinText(text)
	if not text then
		return
	end

	F.SetFont(text)

	F.InternalizeMethod(text, "SetText")
	hooksecurefunc(text, "SetText", function(self, newText)
		local styled = S:StyleTextureString(newText)
		if styled and styled ~= newText then
			F.CallMethod(self, "SetText", styled)
		end
	end)

	local currentText = text:GetText()
	if currentText then
		text:SetText(currentText)
	end
end

local function ReskinLabel(label)
	if label then
		F.SetFont(label)
	end
end

local function ReskinBar(bar)
	if bar and bar.backdrop then
		S:CreateBackdropShadow(bar)
		if bar.Label then
			ReskinLabel(bar.Label)
		end
	end
end

local function ReskinUIWidgetContainer(container)
	for _, widget in pairs(container.widgetFrames) do
		if not widget.__windSkin then
			ReskinText(widget.Text)
			ReskinBar(widget.Bar)
			widget.__windSkin = true
		end
	end
end

local function ReskinPartitionFrame(partitionFrame)
	if partitionFrame.__windSkin then
		return
	end

	hooksecurefunc(partitionFrame.Tex, "SetAtlas", function(self, atlas)
		if strlower(atlas) == "widgetstatusbar-bordertick" then
			self:SetTexture(E.media.blankTex)
			self:SetTexCoord(0, 1, 0, 1)
			self:SetVertexColor(1, 1, 1)
			self:SetAlpha(0.382)
			self:Height(15)
			self:Width(1)
		else
			self:SetAlpha(1)
		end
	end)

	partitionFrame.__windSkin = true
end

do
	local hookedWidget = {}
	function S:ReskinWidgetPartition(widget)
		local pool = widget.partitionPool
		if not pool or hookedWidget[widget] then
			return
		end

		hookedWidget[widget] = true

		for partitionFrame in pool:EnumerateActive() do
			ReskinPartitionFrame(partitionFrame)
		end

		hooksecurefunc(pool, "Acquire", function(_pool)
			for partitionFrame in _pool:EnumerateActive() do
				ReskinPartitionFrame(partitionFrame)
			end
		end)
	end
end

local barAtalsColorMapping = {
	["widgetstatusbar-fill-red"] = C.GetRGBFromTemplate("rose-600"),
	["widgetstatusbar-fill-blue"] = C.GetRGBFromTemplate("sky-600"),
	["widgetstatusbar-fill-green"] = C.GetRGBFromTemplate("emerald-600"),
	["widgetstatusbar-fill-yellow"] = C.GetRGBFromTemplate("amber-600"),
	["widgetstatusbar-fill-white"] = C.GetRGBFromTemplate("neutral-50"),
}

local function GetColorFromAtlas(tex)
	if not tex or not tex.GetAtlas then
		return
	end

	local atlas = tex:GetAtlas()
	if atlas then
		return barAtalsColorMapping[atlas]
	end
end

local cachedColors = {}
function S:BlizzardUIWidget()
	if not self:CheckDB("misc", "uiWidget") then
		return
	end

	-- Partitions
	self:SecureHook(_G.UIWidgetBaseStatusBarTemplateMixin, "InitPartitions", "ReskinWidgetPartition")
	self:SecureHook(_G.UIWidgetTemplateUnitPowerBarMixin, "InitPartitions", "ReskinWidgetPartition")
	self:SecureHook(_G.UIWidgetTemplateStatusBarMixin, "Setup", function(widget)
		if widget:IsForbidden() or widget.widgetSetID and widget.widgetSetID == 283 then
			return
		end

		if not widget.__windSkin then
			if widget.Label then
				ReskinLabel(widget.Label)
			end
			if widget.Bar then
				ReskinBar(widget.Bar)
				if widget.Bar.Label then
					ReskinLabel(widget.Bar.Label)
				end
				if widget.isJailersTowerBar and self:CheckDB(nil, "scenario") then
					widget.Bar:Width(234)
				end
			end
		end

		-- Always apply global status bar texture so widget bars match user preference
		local bar = widget.Bar
		if bar and bar:IsObjectType("StatusBar") then
			---@cast bar StatusBar
			E:RegisterStatusBar(bar)
			local color = GetColorFromAtlas(bar:GetStatusBarTexture())
				or cachedColors[bar]
				or barAtalsColorMapping["widgetstatusbar-fill-white"]
			cachedColors[bar] = color
			bar:SetStatusBarTexture(E.media.normTex)
			if color then
				bar:SetStatusBarColor(color.r, color.g, color.b)
			end
			if bar.Spark then
				bar.Spark:SetAlpha(0)
			end
			if bar.BackgroundGlow then
				bar.BackgroundGlow:SetAlpha(0)
			end
		end
	end)

	self:SecureHook(_G.UIWidgetTemplateCaptureBarMixin, "Setup", function(widget)
		if not widget.__windSkin then
			ReskinBar(widget.Bar)
		end
		self:ReskinWidgetPartition(widget)
	end)

	self:SecureHook(ES, "SkinStatusBarWidget", function(_, widget)
		if widget and widget.Bar then
			ReskinBar(widget.Bar)
		end
	end)

	self:SecureHook(ES, "SkinDoubleStatusBarWidget", function(_, widget)
		if widget then
			if widget.LeftBar then
				ReskinBar(widget.LeftBar)
			end
			if widget.RightBar then
				ReskinBar(widget.RightBar)
			end
		end
	end)

	ES.SkinTextWithStateWidget = E.noop -- Use Blizzard default color

	for _, container in pairs({ _G.UIWidgetTopCenterContainerFrame, _G.UIWidgetBelowMinimapContainerFrame }) do
		if not container or not container.widgetFrames then
			return
		end

		ReskinUIWidgetContainer(container)
		hooksecurefunc(container, "ProcessWidget", ReskinUIWidgetContainer)
	end
end

S:AddCallback("BlizzardUIWidget")
