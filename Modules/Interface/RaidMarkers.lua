-- 原作：ElvUI_S&L 的一个增强组件
-- 原作者：ElvUI_S&L (https://www.tukui.org/addons.php?id=38)
-- 修改：mcc1, SomeBlu

local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore

local WT = E:GetModule("WindTools")
local WS = E:GetModule('Wind_Skins')
local RM = E:NewModule('Wind_RaidMarkerBar', 'AceEvent-3.0')

local lastClear = 0

local DictOfTargetToWorld = {
	[1] = 5,
	[2] = 6,
	[3] = 3,
	[4] = 2,
	[5] = 7,
	[6] = 1,
	[7] = 4,
	[8] = 8,
}

function RM:CreateButtons()
	local modifier = self.db.modifier
	local modifierString = modifier:gsub("^%l", string.upper)
	local modifierLocale = L[modifierString .. " Key"]
	for i = 1,9 do
		local button = CreateFrame("Button", ("RaidMarkerBarButton%d"):format(i), self.frame, "SecureActionButtonTemplate")
		button:SetHeight(self.db.buttonSize)
		button:SetWidth(self.db.buttonSize)
		button:SetTemplate('Transparent')

		local image = button:CreateTexture(nil, "ARTWORK")
		image:SetAllPoints()

		if i < 9 then
			image:SetTexture(("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d"):format(i))

			button:SetAttribute("type*", "macro")
			button:SetAttribute("macrotext1", ("/tm %d"):format(i))
			button:SetAttribute("macrotext2", ("/tm 9"))

			button:SetAttribute(("%s-type*"):format(modifier), "macro")
			button:SetAttribute(("%s-macrotext1"):format(modifier), ("/wm %d"):format(DictOfTargetToWorld[i]))
			button:SetAttribute(("%s-macrotext2"):format(modifier), ("/cwm %d"):format(DictOfTargetToWorld[i]))
		else
			image:SetTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up")

			button:SetAttribute("type", "click")
			button:SetScript("OnClick", function(self)
				if _G[("Is%sKeyDown"):format(modifierString)]() then
					ClearRaidMarker()
				else
					local now = GetTime()
					if now - lastClear > 1 then -- limiting
						lastClear = now
						for i = 1,9 do
							SetRaidTarget("player", i) 
						end
					end
				end
			end)
		end

		button:RegisterForClicks("AnyDown")
		button:SetScript("OnEnter", function(self)
			self:SetBackdropBorderColor(.7, .7, 0)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(L["Raid Markers"])
			GameTooltip:AddLine(i == 9 and ("%s\n%s"):format(L["Click to clear all marks."], (L["%s + Click to remove all worldmarkers."]):format(modifierLocale))
				or ("%s\n%s\n%s\n%s"):format(L["Left Click to mark the target with this mark."], L["Right Click to clear the mark on the target."], (L["%s + Left Click to place this worldmarker."]):format(modifierLocale), (L["%s + Right Click to clear this worldmarker."]):format(modifierLocale)), 1, 1, 1)
			GameTooltip:Show()
		end)

		-- tooltip
		button:SetScript("OnLeave", function(self)
			self:SetBackdropBorderColor(0, 0, 0)
			GameTooltip:Hide() 
		end)

		self.frame.buttons[i] = button
		if WS.db.elvui.general and not self.db.backdrop then
			button:CreateShadow()
		end
	end
end

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
	
	self.frame:SetWidth(width)
	self.frame:SetHeight(height)
	
	for i = 9, 1, -1 do
		local button = self.frame.buttons[i]
		local prev = self.frame.buttons[i + 1]
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
	
	if self.db.enabled then self.frame:Show() else self.frame:Hide() end
end

function RM:ToggleSettings()
	if not InCombatLockdown() then
		self:UpdateBar()
	
		if self.db.enabled then
			RegisterStateDriver(self.frame, "visibility", self.db.visibility == 'DEFAULT' and '[noexists, nogroup] hide; show' or self.db.visibility == 'ALWAYS' and '[noexists, nogroup] show; show' or '[group] show; hide')
		else
			UnregisterStateDriver(self.frame, "visibility")
			self.frame:Hide()
		end
		if self.db.backdrop then
			self.frame.backdrop:Show()
			if WS.db.elvui.general then self.frame.backdrop:CreateShadow() end
		else
			self.frame.backdrop:Hide()
		end
	end
end

-- function RM:Initialize()
-- 	self.db = E.private.general.raidmarkerbar
	
-- 	self.frame = CreateFrame("Frame", "RaidMarkerBar", E.UIParent, "SecureHandlerStateTemplate")
-- 	self.frame:SetResizable(false)
-- 	self.frame:SetClampedToScreen(true)
-- 	self.frame:SetFrameStrata('LOW')
-- 	self.frame:CreateBackdrop('Transparent')
-- 	self.frame:ClearAllPoints()
-- 	self.frame:Point("BOTTOMRIGHT", RightChatPanel, "TOPRIGHT", -1, 3)
-- 	self.frame.buttons = {}
	
-- 	self.frame.backdrop:SetAllPoints()

-- 	E:CreateMover(self.frame, "RaidMarkerBarAnchor", L['Raid Marker Bar'])
	
-- 	--self:RegisterEvent("GROUP_ROSTER_UPDATE", "ToggleSettings")
-- 	self:CreateButtons()
-- 	self:ToggleSettings()
-- end

function RM:Initialize()
	if not E.db.WindTools["Interface"]["Raid Markers"].enabled then return end

	self.db = E.db.WindTools["Interface"]["Raid Markers"]
	tinsert(WT.UpdateAll, function()
		RM.db = E.db.WindTools["Interface"]["Raid Markers"]
		RM:CreateButtons()
		RM:ToggleSettings()
	end)
	self.db.modifier = self.db.modifier:gsub("-", "") -- db conversion

	self.frame = CreateFrame("Frame", "RaidMarkerBar", E.UIParent, "SecureHandlerStateTemplate")
	self.frame:SetResizable(false)
	self.frame:SetClampedToScreen(true)
	self.frame:SetFrameStrata('LOW')
	self.frame:CreateBackdrop('Transparent')
	self.frame:ClearAllPoints()
	self.frame:Point("BOTTOMRIGHT", RightChatPanel, "TOPRIGHT", -1, 3)
	self.frame.buttons = {}

	self.frame.backdrop:SetAllPoints()

	E:CreateMover(self.frame, "RaidMarkerBarAnchor", L['Raid Marker Bar'])
	
	--self:RegisterEvent("GROUP_ROSTER_UPDATE", "ToggleSettings")
	self:CreateButtons()
	self:ToggleSettings()
end

local function InitializeCallback()
	RM:Initialize()
end

E:RegisterModule(RM:GetName(), InitializeCallback)
