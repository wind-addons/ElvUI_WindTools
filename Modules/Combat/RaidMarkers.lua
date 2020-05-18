-- 原作：ElvUI_S&L 的一个增强组件
-- 原作者：ElvUI_S&L (https://www.tukui.org/addons.php?id=38)
-- 修改：mcc1, SomeBlu

local W, F, E, L = unpack(select(2, ...))
local RM = W:NewModule("RaidMarkers", "AceEvent-3.0")
local S = W:GetModule("Skins")

local _G = _G
local GameTooltip = _G.GameTooltip
local strupper = strupper
local GetTime, SetRaidTarget, ClearRaidMarker = GetTime, SetRaidTarget, ClearRaidMarker

local lastClear = 0

local TargetToWorld = {
	[1] = 5,
	[2] = 6,
	[3] = 3,
	[4] = 2,
	[5] = 7,
	[6] = 1,
	[7] = 4,
	[8] = 8
}

function RM:UpdateBar()
	local height, width

	-- adjust height/width for orientation
	if self.db.orientation == "VERTICAL" then
		width = self.db.buttonSize + 3
		height = (self.db.buttonSize * 9) + (self.db.spacing * 9)
	else
		width = (self.db.buttonSize * 9) + (self.db.spacing * 9)
		height = self.db.buttonSize + 3
	end

	self.bar:SetWidth(width)
	self.bar:SetHeight(height)

	for i = 9, 1, -1 do
		local button = self.bar.buttons[i]
		local prev = self.bar.buttons[i + 1]
		button:ClearAllPoints()

		button:SetWidth(self.db.buttonSize)
		button:SetHeight(self.db.buttonSize)

		-- align the buttons with orientation
		if self.db.orientation == "VERTICAL" then
			if i == 9 then
				button:SetPoint("TOP", 0, -3)
			else
				button:SetPoint("TOP", prev, "BOTTOM", 0, -self.db.spacing)
			end
		else
			if i == 9 then
				button:SetPoint("LEFT", 3, 0)
			else
				button:SetPoint("LEFT", prev, "RIGHT", self.db.spacing, 0)
			end
		end
	end

	if self.db.enabled then
		self.bar:Show()
	else
		self.bar:Hide()
	end
end

function RM:ToggleSettings()
	if not InCombatLockdown() then
		self:UpdateBar()

		if self.db.backdrop then
			self.bar.backdrop:Show()
			for i = 9, 1, -1 do
				local button = self.bar.buttons[i]
				if button and button.shadow then
					button.shadow:Hide()
				end
			end
		else
			self.bar.backdrop:Hide()
			for i = 9, 1, -1 do
				local button = self.bar.buttons[i]
				if button and button.shadow then
					button.shadow:Show()
				end
			end
		end

		if self.db.enabled then
			RegisterStateDriver(
				self.bar,
				"visibility",
				self.db.visibility == "DEFAULT" and "[noexists, nogroup] hide; show" or
					self.db.visibility == "ALWAYS" and "[noexists, nogroup] show; show" or
					"[group] show; hide"
			)
		else
			UnregisterStateDriver(self.bar, "visibility")
			self.bar:Hide()
		end
	end
end

function RM:CreateBar()
	if self.bar then
		return
	end

	local frame = CreateFrame("Frame", nil, E.UIParent)
	frame:Point("BOTTOMRIGHT", _G.RightChatPanel, "TOPRIGHT", -1, 3)
	frame:SetFrameStrata("BACKGROUND")
	frame:Size(500, 40)
	self.barAnchor = frame

	frame = CreateFrame("Frame", nil, E.UIParent)
	frame:SetResizable(false)
	frame:SetClampedToScreen(true)
	frame:SetFrameStrata("LOW")
	frame:CreateBackdrop("Transparent")
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", self.barAnchor, "CENTER", 0, 0)
	frame.buttons = {}
	frame:Size(500, 40)
	self.bar = frame

	self:SkinMinimapButtons()

	if E.private.WT.skins.windtools then
		S:CreateShadow(self.bar.backdrop)
	end

	E:CreateMover(
		self.barAnchor,
		"WTRaidMarkersBarAnchor",
		L["Raid Markers Bar"],
		nil,
		nil,
		nil,
		"ALL,WINDTOOLS",
		function()
			return E.db.WT.maps.raidMarkers.enable
		end
	)
end

function RM:CreateButtons()
	local modifier = self.db.modifier
	local modifierString = modifier:gsub("^%l", strupper)

	for i = 1, 9 do
		local button = CreateFrame("Button", nil, self.bar, "SecureActionButtonTemplate")
		button:Size(self.db.buttonSize)
		button:SetTemplate("Transparent")

		if E.private.WT.skins.windtools then
			S:CreateShadow(button)
		end

		local tex = button:CreateTexture(nil, "ARTWORK")
		tex:SetAllPoints()

		if i < 9 then
			tex:SetTexture(("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d"):format(i))

			button:SetAttribute("type*", "macro")
			button:SetAttribute("macrotext1", ("/tm %d"):format(i))
			button:SetAttribute("macrotext2", ("/tm 9"))

			button:SetAttribute(("%s-type*"):format(modifier), "macro")
			button:SetAttribute(("%s-macrotext1"):format(modifier), ("/wm %d"):format(TargetToWorld[i]))
			button:SetAttribute(("%s-macrotext2"):format(modifier), ("/cwm %d"):format(TargetToWorld[i]))
		else
			tex:SetTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up")

			button:SetAttribute("type", "click")
			button:SetScript(
				"OnClick",
				function(self)
					if _G[("Is%sKeyDown"):format(modifierString)]() then
						ClearRaidMarker()
					else
						local now = GetTime()
						if now - lastClear > 1 then -- limiting
							lastClear = now
							for i = 1, 9 do
								SetRaidTarget("player", i)
							end
						end
					end
				end
			)
		end

		button:RegisterForClicks("AnyDown")

		-- 鼠标提示
		button:SetScript(
			"OnEnter",
			function(self)
				self:SetBackdropBorderColor(.7, .7, 0)
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L["Raid Markers"])
				GameTooltip:AddLine(
					i == 9 and
						("%s\n%s"):format(
							L["Click to clear all marks."],
							(L["%s + Click to remove all worldmarkers."]):format(modifierString)
						) or
						("%s\n%s\n%s\n%s"):format(
							L["Left Click to mark the target with this mark."],
							L["Right Click to clear the mark on the target."],
							(L["%s + Left Click to place this worldmarker."]):format(modifierString),
							(L["%s + Right Click to clear this worldmarker."]):format(modifierString)
						),
					1,
					1,
					1
				)
				GameTooltip:Show()
			end
		)

		button:SetScript(
			"OnLeave",
			function(self)
				self:SetBackdropBorderColor(0, 0, 0)
				GameTooltip:Hide()
			end
		)

		self.bar.buttons[i] = button
	end
end

function RM:ProfileUpdate()
	self.db = E.db.WT.combat.raidMarkers

	if self.db.enable then
		self:CreateBar()
	else
	end
	self:CreateButtons()
	self:ToggleSettings()
end

function RM:Initialize()
	if not E.db.WT.combat.raidMarkers.enable then
		return
	end
	self.db = E.db.WT.combat.raidMarkers
end

W:RegisterModule(RM:GetName())
