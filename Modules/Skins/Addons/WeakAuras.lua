local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local format = format
local pairs = pairs
local print = print
local unpack = unpack

local WeakAuras = _G.WeakAuras

-- ============================================================================
-- Utility Functions
-- ============================================================================

---Create backdrop and shadow for a frame with common settings
---@param frame Frame The frame to apply backdrop and shadow to
---@param useDefaultTemplate boolean? Whether to use default template
local function CreateBackdropAndShadow(frame, useDefaultTemplate)
	if not frame then
		return
	end

	frame:CreateBackdrop()
	if useDefaultTemplate ~= false then
		frame.backdrop:SetTemplate("Transparent")
	end

	if E.private.WT.skins.weakAurasShadow then
		S:CreateBackdropShadow(frame, true)
	end

	frame.backdrop.Center:StripTextures()
	frame.backdrop:SetFrameLevel(0)

	-- Keep backdrop at frame level 0 when frame strata changes
	hooksecurefunc(frame, "SetFrameStrata", function()
		frame.backdrop:SetFrameLevel(0)
	end)
end

---Apply ElvUI texture coordinates to an icon
---@param icon Texture The icon texture to apply coordinates to
local function ApplyElvUITexCoords(icon)
	if not icon then
		return
	end

	icon:SetTexCoord(unpack(E.TexCoords))
	icon.SetTexCoord = E.noop
end

---Handle complex texture coordinate calculations for icons
---@param icon Texture The icon texture to handle
local function HandleComplexTexCoords(icon)
	if not icon then
		return
	end

	icon.SetTexCoordOld = icon.SetTexCoord
	icon.SetTexCoord = function(self, ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
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

	icon:SetTexCoord(icon:GetTexCoord())
end

---Sync backdrop alpha with icon alpha
---@param frame Frame The frame containing the backdrop
---@param icon Texture The icon to sync with
local function SyncBackdropAlpha(frame, icon)
	if not frame.backdrop or not icon then
		return
	end

	frame.backdrop.icon = icon
	frame.backdrop:HookScript("OnUpdate", function(self)
		self:SetAlpha(self.icon:GetAlpha())
		if self.shadow then
			self.shadow:SetAlpha(self.icon:GetAlpha())
		end
	end)
end

-- ============================================================================
-- Region Type Skinners
-- ============================================================================

---Skin an icon region
---@param frame Frame The icon frame to skin
local function SkinIconRegion(frame)
	if not frame or frame.__windSkin then
		return
	end

	-- Handle texture coordinates
	if frame.icon then
		HandleComplexTexCoords(frame.icon)
	end

	-- Create backdrop and shadow
	CreateBackdropAndShadow(frame)

	-- Sync alpha with icon
	if frame.icon then
		SyncBackdropAlpha(frame, frame.icon)
	end

	frame.__windSkin = true
end

---Skin an aurabar region
---@param frame Frame The aurabar frame to skin
local function SkinAurabarRegion(frame)
	if not frame or frame.__windSkin then
		return
	end

	-- Create backdrop and shadow
	CreateBackdropAndShadow(frame)

	-- Handle icon
	if frame.icon then
		ApplyElvUITexCoords(frame.icon)
	end

	-- Handle icon frame
	if frame.iconFrame then
		frame.iconFrame:SetAllPoints(frame.icon)
		frame.iconFrame:CreateBackdrop()

		-- Sync icon frame backdrop visibility with icon
		hooksecurefunc(frame.icon, "Hide", function()
			frame.iconFrame.backdrop:SetShown(false)
		end)

		hooksecurefunc(frame.icon, "Show", function()
			frame.iconFrame.backdrop:SetShown(true)
		end)
	end

	frame.__windSkin = true
end

---Main function to skin WeakAuras regions
---@param frame Frame The frame to skin
---@param regionType string The type of region ("icon", "aurabar", etc.)
local function SkinWeakAuras(frame, regionType)
	if not frame or frame.__windSkin then
		return
	end

	if regionType == "icon" then
		SkinIconRegion(frame)
	elseif regionType == "aurabar" then
		SkinAurabarRegion(frame)
	end
end

-- ============================================================================
-- Profiling Window Skinners
-- ============================================================================

---Strip Blizzard PortraitFrameTemplate elements
---@param frame Frame The frame to strip elements from
local function StripPortraitElements(frame)
	if frame.NineSlice then
		frame.NineSlice:Hide()
		frame.NineSlice:SetAlpha(0)
	end
	if frame.PortraitContainer then
		frame.PortraitContainer:Hide()
		frame.PortraitContainer:SetAlpha(0)
	end
	if frame.portrait then
		frame.portrait:Hide()
		frame.portrait:SetAlpha(0)
	end
end

---Skin a profiling line frame
---@param frame Frame The profiling line frame to skin
local function SkinProfilingLine(frame)
	if not frame or frame.__windProfilingLine then
		return
	end

	-- Style progress bar
	if frame.progressBar then
		frame.progressBar:StripTextures()
		frame.progressBar:CreateBackdrop()
		frame.progressBar:SetStatusBarTexture(E.media.normTex)

		-- Style progress bar name text
		if frame.progressBar.name then
			F.SetFontOutline(frame.progressBar.name)
		end
	end

	-- Style time and spike text
	if frame.time then
		F.SetFontOutline(frame.time)
	end
	if frame.spike then
		F.SetFontOutline(frame.spike)
	end

	frame.__windProfilingLine = true
end

---Skin the main profiling frame
---@param frame Frame The profiling frame to skin
local function SkinProfilingFrame(frame)
	if not frame or frame.__windSkin then
		return
	end

	-- Handle main frame
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	-- Strip portrait elements
	StripPortraitElements(frame)

	-- Handle title bar
	if frame.TitleBar then
		frame.TitleBar:StripTextures()
		frame.TitleBar:SetTemplate("Transparent")
	end

	-- Handle close button
	if frame.CloseButton then
		S:Proxy("HandleCloseButton", frame.CloseButton)
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

		for buttonName, handlerType in pairs(buttonHandlers) do
			if frame.buttons[buttonName] then
				S:Proxy(handlerType, frame.buttons[buttonName])
			end
		end
	end

	-- Handle resize button
	if frame.ResizeButton then
		S:Proxy("HandleNextPrevButton", frame.ResizeButton)
	end

	-- Handle column display
	if frame.ColumnDisplay then
		frame.ColumnDisplay:StripTextures()
		frame.ColumnDisplay:SetTemplate("Transparent")

		-- Handle column headers
		if frame.ColumnDisplay.columnHeaders then
			for header in frame.ColumnDisplay.columnHeaders:EnumerateActive() do
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
	end

	-- Handle modern scroll box
	if frame.ScrollBox then
		frame.ScrollBox:StripTextures()
		frame.ScrollBox:SetTemplate("Transparent")
	end

	-- Handle modern scroll bar
	if frame.ScrollBar then
		S:Proxy("HandleTrimScrollBar", frame.ScrollBar)
	end

	-- Style stats text
	if frame.stats then
		F.SetFontOutline(frame.stats)
	end

	frame.__windSkin = true
end

---Skin the profiling report frame
---@param frame Frame The profiling report frame to skin
local function SkinProfilingReport(frame)
	if not frame or frame.__windSkinReport then
		return
	end

	-- Handle main frame
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	S:CreateShadow(frame)

	-- Strip portrait elements
	StripPortraitElements(frame)

	-- Handle title bar
	if frame.TitleBar then
		frame.TitleBar:StripTextures()
		frame.TitleBar:SetTemplate("Transparent")
	end

	-- Handle close button
	if frame.CloseButton then
		S:Proxy("HandleCloseButton", frame.CloseButton)
	end

	-- Handle scroll frame for report
	if frame.ScrollBox then
		local scrollFrame = frame.ScrollBox
		scrollFrame:StripTextures()
		scrollFrame:SetTemplate("Transparent")

		-- Handle scroll bar
		local scrollBar = scrollFrame.ScrollBar
		if not scrollBar and scrollFrame:GetName() then
			scrollBar = _G[scrollFrame:GetName() .. "ScrollBar"]
		end

		if scrollBar and scrollBar.SetAlpha then
			scrollBar:SetAlpha(0)
		end

		-- Handle message frame
		if scrollFrame.messageFrame then
			scrollFrame.messageFrame:StripTextures()
			scrollFrame.messageFrame:SetTemplate("Transparent")
			F.SetFontOutline(scrollFrame.messageFrame)
		end
	end

	frame.__windSkinReport = true
end

-- ============================================================================
-- Hook Management
-- ============================================================================

---Setup profiling window hooks
local function SetupProfilingHooks()
	local function SkinProfilingFrames()
		-- Skin main profiling frame
		local profilingFrame = _G.WeakAurasProfilingFrame
		if profilingFrame and not profilingFrame.__windSkin then
			SkinProfilingFrame(profilingFrame)

			-- Hook scroll box updates for profiling lines
			if profilingFrame.ScrollBox then
				hooksecurefunc(profilingFrame.ScrollBox, "Update", function()
					for _, elementFrame in pairs({ profilingFrame.ScrollBox:GetFrames() }) do
						if elementFrame and not elementFrame.__windProfilingLine then
							SkinProfilingLine(elementFrame)
						end
					end
				end)
			end
		end

		-- Skin profiling report frame
		local reportFrame = _G.WeakAurasProfilingReport
		if reportFrame and not reportFrame.__windSkinReport then
			SkinProfilingReport(reportFrame)
		end
	end

	-- Hook profiling window show
	if WeakAuras.ShowProfilingWindow then
		S:SecureHook(WeakAuras, "ShowProfilingWindow", SkinProfilingFrames)
	end

	-- Initial skin attempt
	SkinProfilingFrames()
end

---Setup region skinning hooks
local function SetupRegionHooks()
	-- Hook texture/atlas setting for region skinning
	if WeakAuras.Private.SetTextureOrAtlas then
		hooksecurefunc(WeakAuras.Private, "SetTextureOrAtlas", function(icon)
			local parent = icon:GetParent()
			local region = parent.regionType and parent or parent:GetParent()
			if region and region.regionType then
				SkinWeakAuras(region, region.regionType)
			end
		end)
	end
end

-- ============================================================================
-- Main Initialization
-- ============================================================================

---Main initialization function
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

	-- Setup hooks
	SetupRegionHooks()
	SetupProfilingHooks()
end

S:AddCallbackForAddon("WeakAuras")
