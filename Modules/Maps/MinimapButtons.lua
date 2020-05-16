-- 基于：Square Minimap Buttons (Azilroka, Sinaris, Feraldin)

local W, F, E, L = unpack(select(2, ...))
local MB = W:NewModule("MinimapButtons", "AceEvent-3.0", "AceHook-3.0")
local S = W:GetModule("Skins")

local _G = _G
local ceil, floor, min = ceil, floor, min
local strlen, strsub, strfind = strlen, strsub, strfind
local tinsert, type, pairs = tinsert, type, pairs

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
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

local function print_r(t)
	local print_r_cache = {}
	local function sub_print_r(t, indent)
		if (print_r_cache[tostring(t)]) then
			print(indent .. "*" .. tostring(t))
		else
			print_r_cache[tostring(t)] = true
			if (type(t) == "table") then
				for pos, val in pairs(t) do
					if (type(val) == "table") then
						print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
						sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8))
						print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
					elseif (type(val) == "string") then
						print(indent .. "[" .. pos .. '] => "' .. val .. '"')
					else
						print(indent .. "[" .. pos .. "] => " .. tostring(val))
					end
				end
			else
				print(indent .. tostring(t))
			end
		end
	end
	if (type(t) == "table") then
		print(tostring(t) .. " {")
		sub_print_r(t, "  ")
		print("}")
	else
		sub_print_r(t, "  ")
	end
	print()
end

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
			frame.original = {}
			frame.original.Width, frame.original.Height = frame:GetSize()
			frame.original.Point,
				frame.original.relativeTo,
				frame.original.relativePoint,
				frame.original.xOfs,
				frame.original.yOfs = frame:GetPoint()
			frame.original.Parent = frame:GetParent()
			frame.original.FrameStrata = frame:GetFrameStrata()
			frame.original.FrameLevel = frame:GetFrameLevel()
			frame.original.Scale = frame:GetScale()
			if frame:HasScript("OnDragStart") then
				frame.original.DragStart = frame:GetScript("OnDragStart")
			end
			if frame:HasScript("OnDragStop") then
				frame.original.DragEnd = frame:GetScript("OnDragStop")
			end
			if (region:GetObjectType() == "Texture") then
				local texture = region:GetTexture()

				if
					texture and type(texture) ~= "number" and
						(texture:find("Border") or texture:find("Background") or texture:find("AlphaMask"))
				 then
					region:SetTexture(nil)
				else
					region:ClearAllPoints()
					region:Point("TOPLEFT", frame, "TOPLEFT", 2, -2)
					region:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
					region:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					region:SetDrawLayer("ARTWORK")
					if (name == "GameTimeFrame") then
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
						region.SetPoint = function()
						end
					end
				end
			end
		end

		frame:SetTemplate("Tranparent")

		tinsert(moveButtons, name)
		S:CreateShadow(frame)

		frame.isSkinned = true
	end
end

function MB:DelayedUpdateLayout()
	if self.db.skinStyle ~= "NOANCHOR" then
		C_Timer_After(
			.1,
			function()
				MB:UpdateLayout()
			end
		)
	end
end

function MB:UpdateSkinStyle()
	local doreload = 0
	if self.db.skinStyle == "NOANCHOR" then
		if self.db.garrison then
			self.db.garrison = false
			doreload = 1
		end
		if self.db.calendar then
			self.db.calendar = false
			doreload = 1
		end
		if doreload == 1 then
			E:StaticPopup_Show("PRIVATE_RL")
		else
			self:UpdateLayout()
		end
	else
		self:UpdateLayout()
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
	local buttonSize = self.db.buttonSize
	local direction = self.db.layoutDirection == "NORMAL"

	-- 更新按钮
	local buttonX, buttonY, anchor, offsetX, offsetY

	for i, moveButton in pairs(moveButtons) do
		local frame = _G[moveButton]

		if self.db.skinStyle == "NOANCHOR" then
			frame:SetParent(frame.original.Parent)
			if frame.original.DragStart then
				frame:SetScript("OnDragStart", frame.original.DragStart)
			end
			if frame.original.DragEnd then
				frame:SetScript("OnDragStop", frame.original.DragEnd)
			end

			frame:ClearAllPoints()
			frame:Size(frame.original.Width, frame.original.Height)

			if frame.original.Point ~= nil then
				frame:SetPoint(
					frame.original.Point,
					frame.original.relativeTo,
					frame.original.relativePoint,
					frame.original.xOfs,
					frame.original.yOfs
				)
			else
				frame:Point("CENTER", Minimap, "CENTER", -80, -34)
			end
			frame:SetFrameStrata(frame.original.FrameStrata)
			frame:SetFrameLevel(frame.original.FrameLevel)
			frame:SetScale(frame.original.Scale)
			frame:SetMovable(true)
		else
			-- 找到默认布局下的 X 行 Y 列 （从 1 开始）
			buttonX = i % buttonsPerRow
			buttonY = floor(i / buttonsPerRow) + 1

			if buttonX == 0 then
				buttonX = numOfRows
			end

			frame:SetParent(self.bar)
			frame:SetMovable(false)
			frame:SetScript("OnDragStart", nil)
			frame:SetScript("OnDragStop", nil)

			frame:ClearAllPoints()
			frame:SetFrameStrata("LOW")
			frame:SetFrameLevel(20)
			frame:Size(buttonSize)

			anchor = "TOPLEFT"
			offsetX = spacing + (buttonX - 1) * (buttonSize + spacing)
			offsetY = spacing + (buttonY - 1) * (buttonSize + spacing)

			if self.db.skinStyle == "HORIZONTAL" then
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
	end

	-- 更新条
	buttonsPerRow = min(buttonsPerRow, #moveButtons)

	if self.db.skinStyle ~= "NOANCHOR" and #moveButtons > 0 then
		local width = buttonSize * buttonsPerRow + spacing * (buttonsPerRow + 1)
		local height = buttonSize * numOfRows + spacing * (numOfRows + 1)

		if not self.db.skinStyle == "HORIZONTAL" then
			width, height = height, width
		end

		self.bar:Size(width, height)
		self.barAnchor:Size(width, height)
		self.bar:Show()
		RegisterStateDriver(self.bar, "visibility", "[petbattle]hide;show")
	else
		UnregisterStateDriver(self.bar, "visibility")
		self.bar:Hide()
	end

	if self.db.skinStyle == "HORIZONTAL" then
		anchor = direction and "LEFT" or "RIGHT"
	else
		anchor = direction and "TOP" or "BOTTOM"
	end

	self.bar:Point(anchor, self.barAnchor, anchor, 0, 0)

	if self.db.backdrop then
		self.bar.backdrop:Show()

		if E.private.WT.skins.windtools then
			S:CreateShadow(self.bar.backdrop)
		end
	else
		self.bar.backdrop:Hide()
	end

	-- 鼠标显隐功能
	if self.db.mouseover then
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

		for _, moveButton in pairs(moveButtons) do
			local frame = _G[moveButton]
			frame:HookScript(
				"OnEnter",
				function(self)
					UIFrameFadeIn(MB.bar, 0.2, MB.bar:GetAlpha(), 1)
					self:SetBackdropBorderColor(.7, .7, 0)
				end
			)
			frame:HookScript(
				"OnLeave",
				function(self)
					UIFrameFadeOut(MB.bar, 0.2, MB.bar:GetAlpha(), 0)
					self:SetBackdropBorderColor(0, 0, 0)
				end
			)
		end
	else
		self.bar:SetScript("OnEnter", nil)
		self.bar:SetScript("OnLeave", nil)
		self.bar:SetAlpha(1)
		for _, moveButton in pairs(moveButtons) do
			local frame = _G[moveButton]
			frame:HookScript("OnEnter", nil)
			frame:HookScript("OnLeave", nil)
		end
	end
end

function MB:SkinMinimapButtons()
	self:RegisterEvent("ADDON_LOADED", "StartSkinning")

	for i = 1, _G.Minimap:GetNumChildren() do
		self:SkinButton(select(i, _G.Minimap:GetChildren()))
	end

	if self.db.garrison then
		self:SkinButton(_G.GarrisonLandingPageMinimapButton)
	end

	self:UpdateLayout()
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

	E:CreateMover(
		self.barAnchor,
		"WTMinimapButtonBarAnchor",
		L["Minimap Button Bar"],
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
	self:UpdateMouseoverConfig()
end

function MB:ProfileUpdate()
	-- self:UpdateScale()
end

W:RegisterModule(MB:GetName())
