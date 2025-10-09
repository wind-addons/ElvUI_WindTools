local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local ES = E.Skins

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
		ReskinLabel(bar.Label)
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

local function reskinPartitionFrame(partitionFrame)
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
			reskinPartitionFrame(partitionFrame)
		end

		hooksecurefunc(pool, "Acquire", function(_pool)
			for partitionFrame in _pool:EnumerateActive() do
				reskinPartitionFrame(partitionFrame)
			end
		end)
	end
end

function S:BlizzardUIWidget()
	if not self:CheckDB("misc", "uiWidget") then
		return
	end

	-- Partitions
	self:SecureHook(_G.UIWidgetBaseStatusBarTemplateMixin, "InitPartitions", "ReskinWidgetPartition")
	self:SecureHook(_G.UIWidgetTemplateUnitPowerBarMixin, "InitPartitions", "ReskinWidgetPartition")
	self:SecureHook(_G.UIWidgetTemplateStatusBarMixin, "Setup", function(widget, widgetInfo)
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
		self:ReskinWidgetPartition(widget)
	end)

	self:SecureHook(ES, "SkinStatusBarWidget", function(_, widget)
		ReskinBar(widget.Bar)
	end)

	self:SecureHook(ES, "SkinDoubleStatusBarWidget", function(_, widget)
		ReskinBar(widget.LeftBar)
		ReskinBar(widget.RightBar)
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
