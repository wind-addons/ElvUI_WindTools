local W, F, E, L = unpack(select(2, ...))
local RM = W:NewModule("RaidMarkers", "AceEvent-3.0")
local S = W:GetModule("Skins")

local _G = _G
local GameTooltip = _G.GameTooltip

local format = format
local gsub = gsub
local strupper = strupper

local ClearRaidMarker = ClearRaidMarker
local CreateFrame = CreateFrame
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local RegisterStateDriver = RegisterStateDriver
local SetRaidTarget = SetRaidTarget
local UIFrameFadeIn = UIFrameFadeOut
local UIFrameFadeOut = UIFrameFadeOut
local UnregisterStateDriver = UnregisterStateDriver

local C_PartyInfo_DoCountdown = C_PartyInfo.DoCountdown

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
	if not self.db.enable then
		self.bar:Hide()
		return
	end

	local previousButton
	local numButtons = 0

	for i = 1, 11 do
		local button = self.bar.buttons[i]
		button:ClearAllPoints()
		button:Size(self.db.buttonSize)

		if (i == 10 and not self.db.readyCheck) or (i == 11 and not self.db.countDown) then
			button:Hide()
		else
			button:Show()
			if self.db.orientation == "VERTICAL" then
				if i == 1 then
					button:Point("TOP", 0, -self.db.backdropSpacing)
				else
					button:Point("TOP", previousButton, "BOTTOM", 0, -self.db.spacing)
				end
			else
				if i == 1 then
					button:SetPoint("LEFT", self.db.backdropSpacing, 0)
				else
					button:SetPoint("LEFT", previousButton, "RIGHT", self.db.spacing, 0)
				end
			end
			previousButton = button
			numButtons = numButtons + 1
		end
	end

	local height = self.db.buttonSize + self.db.backdropSpacing * 2
	local width = self.db.backdropSpacing * 2 + self.db.buttonSize * numButtons + self.db.spacing * (numButtons - 1)

	if self.db.orientation == "VERTICAL" then
		width, height = height, width
	end

	self.bar:Show()
	self.bar:Size(width, height)
	self.barAnchor:Size(width, height)

	if self.db.backdrop then
		self.bar.backdrop:Show()
	else
		self.bar.backdrop:Hide()
	end
end

function RM:UpdateButtons()
	if not self.bar or not self.bar.buttons then
		return
	end

	self.modifierString = gsub(self.db.modifier, "^%l", strupper)

	for i = 1, 11 do
		local button = self.bar.buttons[i]

		-- WindSkins 阴影处理
		if button and button.shadow then
			if self.db.backdrop then
				button.shadow:Hide()
			else
				button.shadow:Show()
			end
		end

		-- 宏按键绑定
		if button.isMarkButton then
			local button = self.bar.buttons[i]
			button:SetAttribute("shift-type*", nil)
			button:SetAttribute("alt-type*", nil)
			button:SetAttribute("ctrl-type*", nil)
			button:SetAttribute(format("%s-type*", self.db.modifier), "macro")
			button:SetAttribute(format("%s-macrotext1", self.db.modifier), format("/wm %d", TargetToWorld[i]))
			button:SetAttribute(format("%s-macrotext2", self.db.modifier), format("/cwm %d", TargetToWorld[i]))
		end
	end
end

function RM:ToggleSettings()
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "ToggleSettings")
		return
	else
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end

	if not self.db.enable then
		UnregisterStateDriver(self.bar, "visibility")
		self.bar:Hide()
		return
	end

	self:UpdateButtons()
	self:UpdateBar()

	-- 注册团队状况显隐
	RegisterStateDriver(
		self.bar,
		"visibility",
		self.db.visibility == "DEFAULT" and "[noexists, nogroup] hide; show" or
			self.db.visibility == "ALWAYS" and "[noexists, nogroup] show; show" or
			"[group] show; hide"
	)

	-- 鼠标显隐
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

function RM:CreateBar()
	if self.bar then
		return
	end

	local frame = CreateFrame("Frame", nil, E.UIParent)
	frame:Point("BOTTOMRIGHT", _G.RightChatPanel, "TOPRIGHT", -1, 3)
	frame:SetFrameStrata("DIALOG")
	self.barAnchor = frame

	frame = CreateFrame("Frame", nil, E.UIParent, "BackdropTemplate")
	frame:SetResizable(false)
	frame:SetClampedToScreen(true)
	frame:SetFrameStrata("LOW")
	frame:CreateBackdrop("Transparent")
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", self.barAnchor, "CENTER", 0, 0)
	frame.buttons = {}
	self.bar = frame

	self:CreateButtons()
	self:ToggleSettings()

	if E.private.WT.skins.enable and E.private.WT.skins.windtools and E.private.WT.skins.shadow then
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
			return E.db.WT.combat.raidMarkers.enable
		end
	)
end

function RM:CreateButtons()
	self.modifierString = self.db.modifier:gsub("^%l", strupper)

	for i = 1, 11 do
		local button = self.bar.buttons[i]
		if not button then
			button = CreateFrame("Button", nil, self.bar, "SecureActionButtonTemplate, BackdropTemplate")
			button:SetTemplate("Transparent")
		end
		button:Size(self.db.buttonSize)

		if E.private.WT.skins.enable and E.private.WT.skins.windtools and E.private.WT.skins.shadow then
			S:CreateShadow(button)
		end

		local tex = button:CreateTexture(nil, "ARTWORK")
		tex:Point("TOPLEFT", button, "TOPLEFT", 2, -2)
		tex:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)

		if i < 9 then -- 标记
			tex:SetTexture(format("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d", i))

			button:SetAttribute("type*", "macro")
			button:SetAttribute("macrotext1", format("/tm %d", i))
			button:SetAttribute("macrotext2", "/tm 9")

			button:SetAttribute(format("%s-type*", self.db.modifier), "macro")
			button:SetAttribute(format("%s-macrotext1", self.db.modifier), format("/wm %d", TargetToWorld[i]))
			button:SetAttribute(format("%s-macrotext2", self.db.modifier), format("/cwm %d", TargetToWorld[i]))

			button.isMarkButton = true
		elseif i == 9 then -- 清除按钮
			tex:SetTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up")

			button:SetAttribute("type", "click")
			button:SetScript(
				"OnClick",
				function(self)
					if _G[format("Is%sKeyDown", RM.modifierString)]() then
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
		elseif i == 10 then -- 准备确认 & 战斗记录
			tex:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
			button:SetAttribute("type*", "macro")
			button:SetAttribute("macrotext1", "/readycheck")
			button:SetAttribute("macrotext2", "/combatlog")
		elseif i == 11 then -- 开怪倒数
			tex:SetTexture("Interface\\Icons\\Spell_unused2")
			tex:SetTexCoord(0.25, 0.8, 0.2, 0.75)
			if IsAddOnLoaded("BigWigs") then
				button:SetAttribute("type*", "macro")
				button:SetAttribute("macrotext1", "/pull " .. RM.db.countDownTime)
				button:SetAttribute("macrotext2", "/pull 0")
			elseif IsAddOnLoaded("DBM-Core") then
				button:SetAttribute("type*", "macro")
				button:SetAttribute("macrotext1", "/dbm pull " .. RM.db.countDownTime)
				button:SetAttribute("macrotext2", "/dbm pull 0")
			else
				button:SetAttribute("type*", "click")
				button:SetScript(
					"OnClick",
					function(_, button)
						if button == "LeftButton" then
							C_PartyInfo_DoCountdown(RM.db.countDownTime)
						elseif button == "RightButton" then
							C_PartyInfo_DoCountdown(-1)
						end
					end
				)
			end
		end

		button:RegisterForClicks("AnyDown")

		-- 鼠标提示
		local tooltipText = ""

		if i < 9 then
			tooltipText =
				format(
				"%s\n%s\n%s\n%s",
				L["Left Click to mark the target with this mark."],
				L["Right Click to clear the mark on the target."],
				format(L["%s + Left Click to place this worldmarker."], RM.modifierString),
				format(L["%s + Right Click to clear this worldmarker."], RM.modifierString)
			)
		elseif i == 9 then
			tooltipText =
				format(
				"%s\n%s",
				L["Click to clear all marks."],
				format(L["%s + Click to remove all worldmarkers."], RM.modifierString)
			)
		elseif i == 10 then
			tooltipText = format("%s\n%s", L["Left Click to ready check."], L["Right click to toggle advanced combat logging."])
		elseif i == 11 then
			tooltipText = format("%s\n%s", L["Left Click to start count down."], L["Right click to stop count down."])
		end

		local tooltipTitle = i <= 9 and L["Raid Markers"] or L["Raid Utility"]

		button:SetScript(
			"OnEnter",
			function(self)
				local icon = F.GetIconString(W.Media.Textures.smallLogo, 14)
				self:SetBackdropBorderColor(.7, .7, 0)
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(tooltipTitle .. " " .. icon)
				GameTooltip:AddLine(tooltipText, 1, 1, 1)
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

		-- 鼠标显隐
		button:HookScript(
			"OnEnter",
			function()
				if not self.db.mouseOver then
					return
				end
				UIFrameFadeIn(self.bar, 0.2, self.bar:GetAlpha(), 1)
				button:SetBackdropBorderColor(.7, .7, 0)
			end
		)

		button:HookScript(
			"OnLeave",
			function()
				if not self.db.mouseOver then
					return
				end
				UIFrameFadeOut(self.bar, 0.2, self.bar:GetAlpha(), 0)
				button:SetBackdropBorderColor(0, 0, 0)
			end
		)

		self.bar.buttons[i] = button
	end
end

function RM:ProfileUpdate()
	self.db = E.db.WT.combat.raidMarkers

	if self.db.enable and not self.bar then
		self:CreateBar()
		return
	end

	self.modifierString = self.db.modifier:gsub("^%l", strupper)

	self:ToggleSettings()
end

function RM:Initialize()
	if not E.db.WT.combat.raidMarkers.enable then
		return
	end

	self.db = E.db.WT.combat.raidMarkers

	self:CreateBar()
end

W:RegisterModule(RM:GetName())
