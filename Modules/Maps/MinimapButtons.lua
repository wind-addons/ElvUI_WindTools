-- 基于：Square Minimap Buttons (Azilroka, Sinaris, Feraldin)

local W, F, E, L = unpack(select(2, ...))
local MB = W:NewModule("MinimapButtons", "AceEvent-3.0", "AceHook-3.0")
local S = W:GetModule("Skins")
local MM = E:GetModule("Minimap")

local _G = _G
local tinsert, type, pairs, hooksecurefunc = tinsert, type, pairs, hooksecurefunc
local ceil, floor, min, strlen, strsub, strfind = ceil, floor, min, strlen, strsub, strfind
local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut
local CreateFrame, InCombatLockdown = CreateFrame, InCombatLockdown
local RegisterStateDriver, UnregisterStateDriver = RegisterStateDriver, UnregisterStateDriver
local C_Timer_After = C_Timer.After

-- 忽略列表
local IgnoreList = {
	full = {
		"AsphyxiaUIMinimapHelpButton",
		"AsphyxiaUIMinimapVersionButton",
		"ElvConfigToggle",
		"ElvUIConfigToggle",
		"ElvUI_ConsolidatedBuffs",
		"HelpOpenTicketButton",
		"MMHolder",
		"DroodFocusMinimapButton",
		"QueueStatusMinimapButton",
		"TimeManagerClockButton",
		"MinimapZoneTextButton"
	},
	startWith = {
		"Archy",
		"GatherMatePin",
		"GatherNote",
		"GuildInstance",
		"HandyNotesPin",
		"MinimMap",
		"Spy_MapNoteList_mini",
		"ZGVMarker",
		"poiMinimap",
		"GuildMap3Mini",
		"LibRockConfig-1.0_MinimapButton",
		"NauticusMiniIcon",
		"WestPointer",
		"Cork",
		"DugisArrowMinimapPoint"
	},
	partial = {
		"Node",
		"Note",
		"Pin",
		"POI"
	}
}

-- 框架名白名单
local whiteList = {
	"LibDBIcon"
}

local moveButtons = {}

function MB:ResetGarrisonSize()
	if InCombatLockdown() then
		return
	end

	_G.GarrisonLandingPageMinimapButton:Size(self.db.buttonSize)
end

function MB:SkinButton(frame)
	if not self.db.calendar then
		tinsert(IgnoreList.full, "GameTimeFrame")
	end

	if frame == nil or frame:GetName() == nil or (frame:GetObjectType() ~= "Button") or not frame:IsVisible() then
		return
	end

	local name = frame:GetName()
	local validIcon = false

	for i = 1, #whiteList do
		if strsub(name, 1, strlen(whiteList[i])) == whiteList[i] then
			validIcon = true
			break
		end
	end

	if not validIcon then
		for _, ignoreName in pairs(IgnoreList.full) do
			if name == ignoreName then
				return
			end
		end
		for _, ignoreName in pairs(IgnoreList.startWith) do
			if strsub(name, 1, strlen(ignoreName)) == ignoreName then
				return
			end
		end

		for _, ignoreName in pairs(IgnoreList.partial) do
			if strfind(name, ignoreName) ~= nil then
				return
			end
		end
	end

	if name ~= "GarrisonLandingPageMinimapButton" then
		frame:SetPushedTexture(nil)
		frame:SetDisabledTexture(nil)
		frame:SetHighlightTexture(nil)
	end

	if name == "DBMMinimapButton" then
		frame:SetNormalTexture("Interface\\Icons\\INV_Helmet_87")
	end

	if name == "SmartBuff_MiniMapButton" then
		frame:SetNormalTexture(select(3, GetSpellInfo(12051)))
	end

	if name == "GarrisonLandingPageMinimapButton" and self.db.garrison then
		frame:SetScale(1)
		if not frame.isRegister then
			MB:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ResetGarrisonSize")
			MB:RegisterEvent("ZONE_CHANGED", "ResetGarrisonSize")
			MB:RegisterEvent("ZONE_CHANGED_INDOORS", "ResetGarrisonSize")
			MB:RegisterEvent("GARRISON_SHOW_LANDING_PAGE", "ResetGarrisonSize")
		end
		frame.isRegister = true
	end

	if name == "GRM_MinimapButton" then
		frame.GRM_MinimapButtonBorder:Hide()
	end

	if not frame.isSkinned then
		frame:HookScript("OnClick", self.DelayedUpdateLayout)
		for _, region in pairs({frame:GetRegions()}) do
			local original = {}
			original.Width, original.Height = frame:GetSize()
			original.Point, original.relativeTo, original.relativePoint, original.xOfs, original.yOfs = frame:GetPoint()
			original.Parent = frame:GetParent()
			original.FrameStrata = frame:GetFrameStrata()
			original.FrameLevel = frame:GetFrameLevel()
			original.Scale = frame:GetScale()
			if frame:HasScript("OnDragStart") then
				original.DragStart = frame:GetScript("OnDragStart")
			end
			if frame:HasScript("OnDragStop") then
				original.DragEnd = frame:GetScript("OnDragStop")
			end

			frame.original = original

			if name == "GameTimeFrame" and region:IsObjectType("FontString") then
				region:SetDrawLayer("ARTWORK")
				region:SetParent(frame)
				frame.windToday = region
			end

			if region:IsObjectType("Texture") then
				local t = region:GetTexture()

				if t and type(t) ~= "number" and (t:find("Border") or t:find("Background") or t:find("AlphaMask")) then
					region:SetTexture(nil)
				else
					region:ClearAllPoints()
					region:Point("TOPLEFT", frame, "TOPLEFT", 2, -2)
					region:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
					region:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					region:SetDrawLayer("ARTWORK")
					if (name == "GameTimeFrame") then
						if t == [[Interface\Calendar\UI-Calendar-Button]] then
							region:SetAlpha(0)
						end

						if not frame.windTex then
							local tex = frame:CreateTexture()
							tex:SetTexture(W.Media.Icons.calendar)
							tex:Point("TOPLEFT", frame, "TOPLEFT", 2, -2)
							tex:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
							frame.windTex = tex
						end

						if (region:GetName() == "GameTimeCalendarInvitesTexture") then
							region:SetTexCoord(0.03125, 0.6484375, 0.03125, 0.8671875)
							region:SetDrawLayer("ARTWORK", 1)
						elseif (region:GetName() == "GameTimeCalendarInvitesGlow") then
							region:SetTexCoord(0.1, 0.9, 0.1, 0.9)
						elseif (region:GetName() == "GameTimeCalendarEventAlarmTexture") then
							region:SetTexCoord(0.1, 0.9, 0.1, 0.9)
						elseif (region:GetName() == "GameTimeTexture") then
							region:SetTexCoord(0.0, 0.390625, 0.0, 0.78125)
						else
							region:SetTexCoord(0.0, 0.390625, 0.0, 0.78125)
						end
					end

					if (name == "PS_MinimapButton") then
						region.SetPoint = E.noop
					end
				end
			end
		end

		frame:SetTemplate("Tranparent")
		if E.private.WT.skins.windtools then
			S:CreateShadow(frame)
		end

		frame:HookScript(
			"OnEnter",
			function()
				if not self.db.mouseOver then
					return
				end
				UIFrameFadeIn(self.bar, 0.2, self.bar:GetAlpha(), 1)
				frame:SetBackdropBorderColor(.7, .7, 0)
			end
		)
		frame:HookScript(
			"OnLeave",
			function()
				if not self.db.mouseOver then
					return
				end
				UIFrameFadeOut(self.bar, 0.2, self.bar:GetAlpha(), 0)
				frame:SetBackdropBorderColor(0, 0, 0)
			end
		)

		tinsert(moveButtons, name)

		frame.isSkinned = true
	end
end

function MB.DelayedUpdateLayout()
	if MB.db.orientation ~= "NOANCHOR" then
		C_Timer_After(
			.1,
			function()
				MB:UpdateLayout()
			end
		)
	end
end

function MB:UpdateLayout()
	if not self.db.enable then
		return
	end

	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateLayout")
		return
	else
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end

	local buttonsPerRow = self.db.buttonsPerRow
	local numOfRows = ceil(#moveButtons / buttonsPerRow)
	local spacing = self.db.spacing
	local backdropSpacing = self.db.backdropSpacing
	local buttonSize = self.db.buttonSize
	local direction = not self.db.inverseDirection

	-- 更新按钮
	local buttonX, buttonY, anchor, offsetX, offsetY

	for i, moveButton in pairs(moveButtons) do
		local frame = _G[moveButton]

		if self.db.orientation == "NOANCHOR" then
			local original = frame.original
			frame:SetParent(original.Parent)
			if original.DragStart then
				frame:SetScript("OnDragStart", original.DragStart)
			end
			if original.DragEnd then
				frame:SetScript("OnDragStop", original.DragEnd)
			end

			frame:ClearAllPoints()
			frame:Size(original.Width, original.Height)

			if original.Point ~= nil then
				frame:SetPoint(original.Point, original.relativeTo, original.relativePoint, original.xOfs, original.yOfs)
			else
				frame:Point("CENTER", _G.Minimap, "CENTER", -80, -34)
			end
			frame:SetFrameStrata(original.FrameStrata)
			frame:SetFrameLevel(original.FrameLevel)
			frame:SetScale(original.Scale)
			frame:SetMovable(true)
		else
			-- 找到默认布局下的 X 行 Y 列 （从 1 开始）
			buttonX = i % buttonsPerRow
			buttonY = floor(i / buttonsPerRow) + 1

			if buttonX == 0 then
				buttonX = buttonsPerRow
				buttonY = buttonY - 1
			end

			frame:SetParent(self.bar)
			frame:SetMovable(false)
			frame:SetScript("OnDragStart", nil)
			frame:SetScript("OnDragStop", nil)

			frame:ClearAllPoints()
			frame:SetFrameStrata("LOW")
			frame:SetFrameLevel(20)
			frame:Size(buttonSize)

			offsetX = backdropSpacing + (buttonX - 1) * (buttonSize + spacing)
			offsetY = backdropSpacing + (buttonY - 1) * (buttonSize + spacing)

			if self.db.orientation == "HORIZONTAL" then
				if direction then
					anchor = "TOPLEFT"
					offsetY = -offsetY
				else
					anchor = "TOPRIGHT"
					offsetX, offsetY = -offsetX, -offsetY
				end
			else
				if direction then
					anchor = "TOPLEFT"
					offsetX, offsetY = offsetY, -offsetX
				else
					anchor = "BOTTOMLEFT"
					offsetX, offsetY = offsetY, offsetX
				end
			end

			frame:ClearAllPoints()
			frame:Point(anchor, self.bar, anchor, offsetX, offsetY)
		end

		if E.private.WT.skins.windtools and not self.db.backdrop then
			frame.shadow:Show()
		else
			frame.shadow:Hide()
		end

		if moveButton == "GameTimeFrame" then
			frame.windToday:ClearAllPoints()
			frame.windToday:Point("TOP", frame, "TOP", 0, -0.45 * buttonSize)
		end
	end

	-- 更新条
	buttonsPerRow = min(buttonsPerRow, #moveButtons)

	if self.db.orientation ~= "NOANCHOR" and #moveButtons > 0 then
		local width = buttonSize * buttonsPerRow + spacing * (buttonsPerRow - 1) + backdropSpacing * 2
		local height = buttonSize * numOfRows + spacing * (numOfRows - 1) + backdropSpacing * 2

		if self.db.orientation == "VERTICAL" then
			width, height = height, width
		end

		self.bar:Size(width, height)
		self.barAnchor:Size(width, height)
		RegisterStateDriver(self.bar, "visibility", "[petbattle]hide;show")
		self.bar:Show()
	else
		UnregisterStateDriver(self.bar, "visibility")
		self.bar:Hide()
	end

	if self.db.orientation == "HORIZONTAL" then
		anchor = direction and "LEFT" or "RIGHT"
	else
		anchor = direction and "TOP" or "BOTTOM"
	end

	self.bar:Point(anchor, self.barAnchor, anchor, 0, 0)

	if self.db.backdrop then
		self.bar.backdrop:Show()
	else
		self.bar.backdrop:Hide()
	end
end

function MB:SkinMinimapButtons()
	self:RegisterEvent("ADDON_LOADED", "StartSkinning")

	for _, child in pairs({_G.Minimap:GetChildren()}) do
		self:SkinButton(child)
	end

	if self.db.garrison then
		self:SkinButton(_G.GarrisonLandingPageMinimapButton)
	end

	self:UpdateLayout()
end

function MB:UpdateMouseOverConfig()
	-- 鼠标显隐功能
	if self.db.mouseOver then
		self.bar:SetScript(
			"OnEnter",
			function(self)
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
			end
		)

		self.bar:SetScript(
			"OnLeave",
			function(self)
				UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
			end
		)

		self.bar:SetAlpha(0)
	else
		self.bar:SetScript("OnEnter", nil)
		self.bar:SetScript("OnLeave", nil)
		self.bar:SetAlpha(1)
	end
end

function MB:StartSkinning()
	MB:UnregisterEvent("ADDON_LOADED")

	C_Timer_After(
		5,
		function()
			MB:SkinMinimapButtons()
		end
	)
end

function MB:CreateFrames()
	if self.bar then
		return
	end

	local frame = CreateFrame("Frame", nil, E.UIParent)
	frame:Point("TOPRIGHT", RightMiniPanel, "BOTTOMRIGHT", 0, -2)
	frame:SetFrameStrata("BACKGROUND")
	self.barAnchor = frame

	frame = CreateFrame("Frame", nil, E.UIParent)
	frame:SetFrameStrata("LOW")
	frame:CreateBackdrop("Transparent")
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", self.barAnchor, "CENTER", 0, 0)
	self.bar = frame

	self:SkinMinimapButtons()

	if E.private.WT.skins.windtools then
		S:CreateShadow(self.bar.backdrop)
	end

	E:CreateMover(
		self.barAnchor,
		"WTMinimapButtonBarAnchor",
		L["Minimap Buttons Bar"],
		nil,
		nil,
		nil,
		"ALL,WINDTOOLS",
		function()
			return E.private.WT.maps.minimapButtons.enable
		end
	)
end

function MB:Initialize()
	if not E.private.WT.maps.minimapButtons.enable then
		return
	end
	self.db = E.private.WT.maps.minimapButtons

	self:CreateFrames()
	self:UpdatemouseOverConfig()

	hooksecurefunc(
		MM,
		"UpdateSettings",
		function()
			MB:UpdateLayout()
		end
	)
end

W:RegisterModule(MB:GetName())
