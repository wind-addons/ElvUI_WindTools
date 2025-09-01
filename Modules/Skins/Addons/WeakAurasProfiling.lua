local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins
local MF = W.Modules.MoveFrames

local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs

---Skin a profiling line frame
---@param frame Frame The profiling line frame to skin
local function SkinProfilingLine(frame)
	if not frame or frame.__windSkin then
		return
	end

	if frame.progressBar then
		frame.progressBar:SetStatusBarTexture(E.media.normTex)
		F.SetFontOutline(frame.progressBar.name, W.AsianLocale and E.db.general.font or nil)
	end

	if frame.time then
		F.SetFontOutline(frame.time)
	end

	if frame.spike then
		F.SetFontOutline(frame.spike)
	end

	frame.__windSkin = true
end

---Skin the main profiling frame
---@param frame Frame The profiling frame to skin
local function SkinProfilingFrame(frame)
	if not frame or frame.__windSkin then
		return
	end

	S:Proxy("HandlePortraitFrame", frame)
	S:CreateShadow(frame)
	MF:InternalHandle(frame, nil, false)

	for _, region in pairs({ frame.ResizeButton:GetRegions() }) do
		if region:IsObjectType("Texture") then
			region:SetTexture(E.Media.Textures.ArrowUp)
			region:SetTexCoord(0, 1, 0, 1)
			region:SetRotation(-2.35)
			region:SetAllPoints()
		end
	end

	frame.TitleBar:Hide()
	S:Proxy("HandleNextPrevButton", frame.MaxMinButtonFrame.MaximizeButton, "up", nil, true)
	S:Proxy("HandleNextPrevButton", frame.MaxMinButtonFrame.MinimizeButton, "down", nil, true)
	S:Proxy("HandleCloseButton", frame.CloseButton)
	frame.MaxMinButtonFrame:Size(20)

	if frame.buttons then
		S:Proxy("HandleButton", frame.buttons.report)
		S:Proxy("HandleButton", frame.buttons.stop)
		S:Proxy("HandleButton", frame.buttons.start)
		S:Proxy("HandleDropDownBox", frame.buttons.modeDropDown, frame.buttons.modeDropDown:GetWidth(), nil, true)
		S:Proxy("HandleDropDownBox", frame.buttons.startDropDown, frame.buttons.startDropDown:GetWidth(), nil, true)
	end

	if frame.ColumnDisplay then
		frame.ColumnDisplay:StripTextures()
		if frame.ColumnDisplay.columnHeaders then
			for header in frame.ColumnDisplay.columnHeaders:EnumerateActive() do
				header:StripTextures()
				header:SetTemplate("Transparent")
			end
		end
	end

	S:Proxy("HandleTrimScrollBar", frame.ScrollBar)
	local scrollBox = frame.ScrollBox ---@type WowScrollBoxList
	scrollBox:StripTextures()
	scrollBox:SetTemplate("Transparent")
	hooksecurefunc(scrollBox, "Update", function()
		scrollBox:ForEachFrame(SkinProfilingLine)
	end)

	if frame.stats then
		F.SetFontOutline(frame.stats)
	end

	frame.__windSkin = true
end

---Skin the profiling report frame
---@param frame Frame The profiling report frame to skin
local function SkinProfilingReport(frame)
	if not frame or frame.__windSkin then
		return
	end

	S:Proxy("HandlePortraitFrame", frame)
	S:CreateShadow(frame)

	frame.TitleBar:Hide()
	S:Proxy("HandleCloseButton", frame.CloseButton)

	local scrollFrame = frame.ScrollBox
	scrollFrame:StripTextures()
	scrollFrame:SetTemplate("Transparent")
	S:Proxy("HandleTrimScrollBar", scrollFrame.ScrollBar)
	F.Move(scrollFrame.ScrollBar, 13, 0)

	if scrollFrame.messageFrame then
		F.SetFontOutline(scrollFrame.messageFrame)
	end

	frame.__windSkin = true
end

function S:SkinWeakAurasProfilingFrames()
	if not _G.WeakAurasProfilingFrame or not _G.WeakAurasProfilingReport then
		return false
	end

	S:SecureHook(_G.WeakAurasProfilingFrame, "Show", SkinProfilingFrame)
	S:SecureHook(_G.WeakAurasProfilingReport, "Show", SkinProfilingReport)

	if self:IsHooked(_G.WeakAuras, "ShowProfilingWindow") then
		self:Unhook(_G.WeakAuras, "ShowProfilingWindow")
	end

	return true
end

function S:WeakAurasProfiling()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.weakAurasOptions then
		return
	end

	if self:SkinWeakAurasProfilingFrames() then
		return
	end

	if _G.WeakAuras.ShowProfilingWindow then
		S:SecureHook(_G.WeakAuras, "ShowProfilingWindow", "SkinWeakAurasProfilingFrames")
	end
end

S:AddCallbackForAddon("WeakAuras", "WeakAurasProfiling")
