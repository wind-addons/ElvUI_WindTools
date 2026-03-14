local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

local function ReskinColumnHeaders(display)
	local headers = display.Headers
	if not headers or not headers.columnHeaders then
		return
	end
	for header in headers.columnHeaders:EnumerateActive() do
		if not header.__windSkin then
			S:Proxy("HandleButton", header)
			header.__windSkin = true
		end
	end
end

function S:AddonProfiler()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.addonProfiler then
		return
	end

	local NAP = _G.NumyAddonProfiler
	local display = NAP and NAP.ProfilerFrame
	if not display then
		return
	end

	display:StripTextures(true)
	display:SetTemplate("Transparent")
	self:CreateShadow(display)

	if display.Inset then
		display.Inset:SetTemplate("Transparent")
	end

	if display.ResizeButton then
		self:HandleResizeButton(display.ResizeButton)
	end

	if display.TitleBar then
		display.TitleBar:StripTextures()
		display.TitleBar:SetFrameLevel(display:GetFrameLevel() + 10)
	end

	if display.Headers then
		display.Headers:StripTextures()
		display.Headers:SetTemplate("Transparent")
		hooksecurefunc(display, "UpdateHeaders", function()
			ReskinColumnHeaders(display)
		end)
		ReskinColumnHeaders(display)
	end

	if display.HistoryDropdown then
		self:Proxy("HandleDropDownBox", display.HistoryDropdown, 150)
	end
	if display.ModeDropdown then
		self:Proxy("HandleDropDownBox", display.ModeDropdown, 150)
	end
	if display.HistoryRangeLabel and display.TitleBar and display.HistoryDropdown then
		local label = display.HistoryRangeLabel
		label:SetParent(display.TitleBar)
		label:ClearAllPoints()
		label:SetPoint("RIGHT", display.HistoryDropdown, "LEFT", -4, 0)
		label:SetDrawLayer("OVERLAY", 0)
	end

	local searchBox = _G.NumyAddonProfilerFrameSearchBox
	if searchBox then
		self:Proxy("HandleEditBox", searchBox)
	end

	local scrollBar = _G.NumyAddonProfilerFrameScrollBar
	if scrollBar then
		self:Proxy("HandleTrimScrollBar", scrollBar)
	end

	if display.Settings then
		display.Settings:SetTemplate("Transparent")
		self:CreateShadow(display.Settings)
		display.Settings:SetSize(24, 24)
		display.Settings:ClearAllPoints()
		display.Settings:SetPoint("RIGHT", display.TitleBar, "RIGHT", -30, 3)
		local normalTex = display.Settings:GetNormalTexture()
		if normalTex then
			normalTex:SetDrawLayer("OVERLAY", 0)
		end
	end
	if display.PlayButton then
		self:Proxy("HandleButton", display.PlayButton)
		display.PlayButton:SetSize(26, 26)
	end
	if display.UpdateButton then
		self:Proxy("HandleButton", display.UpdateButton)
		display.UpdateButton:SetSize(26, 26)
		display.UpdateButton:ClearAllPoints()
		display.UpdateButton:SetPoint("LEFT", display.PlayButton, "RIGHT", 2, 0)
	end

	if NAP.ToggleButton then
		self:Proxy("HandleButton", NAP.ToggleButton)
	end

	local resetButton = _G.NumyAddonProfilerFrameReset
	if resetButton then
		self:Proxy("HandleButton", resetButton)
	end

	if display.CloseButton then
		self:Proxy("HandleCloseButton", display.CloseButton)
	end
end

S:AddCallbackForAddon("!!AddonProfiler", "AddonProfiler")
