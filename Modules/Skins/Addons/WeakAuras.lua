local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local format = format
local pairs = pairs
local print = print
local unpack = unpack

local WeakAuras = _G.WeakAuras

-- Utility functions for common skinning operations
local function StripBlizzardElements(frame)
	frame:StripTextures(true)

	local elements = { "PortraitContainer", "portrait", "NineSlice", "Bg" }
	for _, element in pairs(elements) do
		if frame[element] then
			frame[element]:Hide()
			frame[element]:SetAlpha(0)
		end
	end

	-- Remove remaining background textures
	for i = 1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region and region:GetObjectType() == "Texture" then
			local texture = region:GetTexture()
			if
				texture
				and type(texture) == "string"
				and (texture:find("UI-Frame") or texture:find("_Border") or texture:find("Portrait"))
			then
				region:Hide()
				region:SetAlpha(0)
			end
		end
	end
end

local function SkinTitleElements(frame)
	if frame.TitleContainer then
		frame.TitleContainer:StripTextures(true)
		if frame.TitleContainer.TitleText then
			F.SetFontOutline(frame.TitleContainer.TitleText)
		end
	end

	if frame.TitleBar then
		frame.TitleBar:StripTextures(true)
		frame.TitleBar:SetTemplate("Transparent")
	end

	local titleElements = { "TitleText", "Title" }
	for _, element in pairs(titleElements) do
		if frame[element] then
			F.SetFontOutline(frame[element])
		end
	end
end

local function SkinScrollElements(frame, self)
	if frame.ScrollBox then
		frame.ScrollBox:StripTextures()
		frame.ScrollBox:SetTemplate("Transparent")

		if frame.ScrollBox.ScrollBar then
			self:Proxy("HandleScrollBar", frame.ScrollBox.ScrollBar)
		end

		-- Handle scroll child content
		if frame.ScrollBox.ScrollChild and frame.ScrollBox.ScrollChild.messageFrame then
			frame.ScrollBox.ScrollChild.messageFrame:StripTextures()
			frame.ScrollBox.ScrollChild.messageFrame:SetTemplate("Transparent")
		end

		if frame.ScrollBox.messageFrame then
			frame.ScrollBox.messageFrame:StripTextures()
			frame.ScrollBox.messageFrame:SetTemplate("Transparent")
		end
	end

	if frame.ScrollBar then
		self:Proxy("HandleTrimScrollBar", frame.ScrollBar)
	end
end

-- Core skinning functions
local function SkinDebugEditBox(self)
	local debugEditBox = _G.WADebugEditBox
	if not debugEditBox or not debugEditBox.Background or debugEditBox.Background.__windSkin then
		return
	end

	local frame = debugEditBox.Background

	-- Handle scroll bar
	local scrollBar = _G.WADebugEditBoxScrollFrameScrollBar
	if scrollBar then
		self:Proxy("HandleScrollBar", scrollBar)
	end

	frame:StripTextures()
	frame:SetTemplate("Transparent")
	self:CreateShadow(frame)

	-- Handle close button
	for _, child in pairs({ frame:GetChildren() }) do
		if child:GetNumRegions() == 3 then
			child:StripTextures()
			local subChild = child:GetChildren()
			if subChild then
				subChild:ClearAllPoints()
				subChild:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 3, 7)
				self:Proxy("HandleCloseButton", subChild)
			end
		end
	end

	frame.__windSkin = true
end

local function SkinProfilingFrame(self, frame)
	if not frame or frame.__windSkin then
		return
	end

	StripBlizzardElements(frame)
	frame:SetTemplate("Transparent")
	self:CreateShadow(frame)

	SkinTitleElements(frame)

	-- Handle close button
	if frame.CloseButton then
		self:Proxy("HandleCloseButton", frame.CloseButton)
	end

	-- Handle buttons frame
	if frame.buttons then
		local buttonHandlers = {
			report = "HandleButton",
			stop = "HandleButton",
			start = "HandleButton",
			modeDropDown = "HandleDropDownBox",
			startDropDown = "HandleDropDownBox",
		}

		for button, handler in pairs(buttonHandlers) do
			if frame.buttons[button] then
				self:Proxy(handler, frame.buttons[button])
			end
		end
	end

	-- Handle resize button
	if frame.ResizeButton then
		self:Proxy("HandleNextPrevButton", frame.ResizeButton)
	end

	-- Handle column display
	if frame.ColumnDisplay then
		frame.ColumnDisplay:StripTextures()
		frame.ColumnDisplay:SetTemplate("Transparent")
	end

	SkinScrollElements(frame, self)

	-- Style stats text
	if frame.stats then
		F.SetFontOutline(frame.stats)
	end

	frame.__windSkin = true
end

local function SkinProfilingReport(self, frame)
	if not frame or frame.__windSkinReport then
		return
	end

	StripBlizzardElements(frame)
	frame:SetTemplate("Transparent")
	self:CreateShadow(frame)

	SkinTitleElements(frame)

	-- Handle close button
	if frame.CloseButton then
		self:Proxy("HandleCloseButton", frame.CloseButton)
	end

	SkinScrollElements(frame, self)

	frame.__windSkinReport = true
end

local function SkinProfilingLine(self, frame)
	if not frame or frame.__windProfilingLine then
		return
	end

	-- Style progress bar
	if frame.progressBar then
		frame.progressBar:StripTextures()
		frame.progressBar:CreateBackdrop()
		frame.progressBar:SetStatusBarTexture(E.media.normTex)

		if frame.progressBar.name then
			F.SetFontOutline(frame.progressBar.name)
		end
	end

	-- Style text elements
	local textElements = { "time", "spike" }
	for _, element in pairs(textElements) do
		if frame[element] then
			F.SetFontOutline(frame[element])
		end
	end

	frame.__windProfilingLine = true
end

local function SkinColumnHeaders(self, columnHeaders)
	if not columnHeaders then
		return
	end

	for header in columnHeaders:EnumerateActive() do
		if header and not header.__windSkin then
			header:StripTextures()
			header:SetTemplate("Transparent")

			if header.Text then
				F.SetFontOutline(header.Text)
			end

			header.__windSkin = true
		end
	end
end

-- WeakAuras region skinning
local function SkinWeakAurasRegion(frame, regionType)
	if not frame or frame.__windSkin then
		return
	end

	if regionType == "icon" then
		-- Custom texture coordinate handling for icons
		if frame.icon then
			frame.icon.SetTexCoordOld = frame.icon.SetTexCoord
			frame.icon.SetTexCoord = function(self, ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
				local cLeft, cRight, cTop, cDown
				if URx and URy and LRx and LRy then
					cLeft, cRight, cTop, cDown = ULx, LRx, ULy, LRy
				else
					cLeft, cRight, cTop, cDown = ULx, ULy, LLx, LLy
				end

				local left, right, top, down = unpack(E.TexCoords)
				if cLeft == 0 or cRight == 0 or cTop == 0 or cDown == 0 then
					local width, height = cRight - cLeft, cDown - cTop
					if width == height then
						self:SetTexCoordOld(left, right, top, down)
					elseif width > height then
						self:SetTexCoordOld(left, right, top + cTop * (right - left), top + cDown * (right - left))
					else
						self:SetTexCoordOld(left + cLeft * (down - top), left + cRight * (down - top), top, down)
					end
				else
					self:SetTexCoordOld(cLeft, cRight, cTop, cDown)
				end
			end
			frame.icon:SetTexCoord(frame.icon:GetTexCoord())
		end

		frame:CreateBackdrop()
		if E.private.WT.skins.weakAurasShadow then
			S:CreateBackdropShadow(frame, true)
		end
		frame.backdrop.Center:StripTextures()
		frame.backdrop:SetFrameLevel(0)

		-- Sync backdrop alpha with icon
		if frame.icon then
			frame.backdrop.icon = frame.icon
			frame.backdrop:HookScript("OnUpdate", function(self)
				self:SetAlpha(self.icon:GetAlpha())
				if self.shadow then
					self.shadow:SetAlpha(self.icon:GetAlpha())
				end
			end)
		end

		hooksecurefunc(frame, "SetFrameStrata", function()
			frame.backdrop:SetFrameLevel(0)
		end)
	elseif regionType == "aurabar" then
		frame:CreateBackdrop()
		frame.backdrop.Center:StripTextures()
		frame.backdrop:SetFrameLevel(0)

		if E.private.WT.skins.weakAurasShadow then
			S:CreateBackdropShadow(frame, true)
		end

		if frame.icon then
			frame.icon:SetTexCoord(unpack(E.TexCoords))
			frame.icon.SetTexCoord = E.noop
		end

		if frame.iconFrame then
			frame.iconFrame:SetAllPoints(frame.icon)
			frame.iconFrame:CreateBackdrop()

			hooksecurefunc(frame.icon, "Hide", function()
				frame.iconFrame.backdrop:SetShown(false)
			end)

			hooksecurefunc(frame.icon, "Show", function()
				frame.iconFrame.backdrop:SetShown(true)
			end)
		end

		hooksecurefunc(frame, "SetFrameStrata", function()
			frame.backdrop:SetFrameLevel(0)
		end)
	end

	frame.__windSkin = true
end

-- Hook management
local function SetupProfilingHooks(self)
	local function SkinProfilingFrames()
		local profilingFrame = _G.WeakAurasProfilingFrame
		if profilingFrame and not profilingFrame.__windSkin then
			SkinProfilingFrame(self, profilingFrame)

			-- Handle column headers
			if profilingFrame.ColumnDisplay and profilingFrame.ColumnDisplay.columnHeaders then
				SkinColumnHeaders(self, profilingFrame.ColumnDisplay.columnHeaders)
			end

			-- Hook scroll box updates for profiling lines
			if profilingFrame.ScrollBox and profilingFrame.ScrollBox.SetDataProvider then
				hooksecurefunc(profilingFrame.ScrollBox, "Update", function()
					for _, elementFrame in pairs({ profilingFrame.ScrollBox:GetFrames() }) do
						if elementFrame and not elementFrame.__windProfilingLine then
							SkinProfilingLine(self, elementFrame)
						end
					end
				end)
			end
		end

		local reportFrame = _G.WeakAurasProfilingReport
		if reportFrame and not reportFrame.__windSkinReport then
			SkinProfilingReport(self, reportFrame)
		end
	end

	-- Hook various entry points
	if WeakAuras.ShowProfilingWindow then
		self:SecureHook(WeakAuras, "ShowProfilingWindow", SkinProfilingFrames)
	end

	if WeakAuras.PrintProfile then
		self:SecureHook(WeakAuras, "PrintProfile", function()
			SkinDebugEditBox(self)
		end)
	end

	-- Initial skin attempt
	SkinProfilingFrames()
end

-- Main initialization function
function S:WeakAuras()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.weakAuras then
		return
	end

	-- Check for WeakAurasPatched
	if not WeakAuras or not WeakAuras.Private then
		local alertMessage = format(
			"%s: %s %s %s",
			W.Title,
			L["You are using Official WeakAuras, the skin of WeakAuras will not be loaded due to the limitation."],
			L["If you want to use WeakAuras skin, please install |cffff0000WeakAurasPatched|r (https://wow-ui.net/wap)."],
			L["You can disable this alert via disabling WeakAuras Skin in Skins - Addons."]
		)
		E:Delay(10, print, alertMessage)
		return
	end

	-- Hook region options registration
	if WeakAuras.Private.RegisterRegionOptions then
		self:RawHook(WeakAuras.Private, "RegisterRegionOptions", "WeakAuras_RegisterRegionOptions")
	end

	-- Hook texture/atlas setting for region skinning
	if WeakAuras.Private.SetTextureOrAtlas then
		hooksecurefunc(WeakAuras.Private, "SetTextureOrAtlas", function(icon)
			local parent = icon:GetParent()
			local region = parent.regionType and parent or parent:GetParent()
			if region and region.regionType then
				SkinWeakAurasRegion(region, region.regionType)
			end
		end)
	end

	-- Setup profiling window hooks
	SetupProfilingHooks(self)
end

S:AddCallbackForAddon("WeakAuras")
