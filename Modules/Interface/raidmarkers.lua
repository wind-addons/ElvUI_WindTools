local E, L, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore

local WT = E:GetModule("WindTools")
local RM = E:NewModule('Wind_RaidMarkerBar', 'AceEvent-3.0')

local layouts = { 
	[1] = {RT = 1, WM = 5},	-- yellow/star 
	[2] = {RT = 2, WM = 6},	-- orange/circle 
	[3] = {RT = 3, WM = 3},	-- purple/diamond 
	[4] = {RT = 4, WM = 2},	-- green/triangle 
	[5] = {RT = 5, WM = 7},	-- white/moon 
	[6] = {RT = 6, WM = 1},	-- blue/square 
	[7] = {RT = 7, WM = 4},	-- red/cross 
	[8] = {RT = 8, WM = 8},	-- white/skull 
	[9] = {RT = 0, WM = 0},	-- clear target/worldmarker 
}


function RM:CreateButtons()
	for k, layout in ipairs(layouts) do
		local button = CreateFrame("Button", ("RaidMarkerBarButton%d"):format(k), self.frame, "SecureActionButtonTemplate")
		button:SetHeight(self.db.buttonSize)
		button:SetWidth(self.db.buttonSize)
		button:SetTemplate('Transparent')
		
		local image = button:CreateTexture(nil, "ARTWORK")
		image:SetAllPoints()
		image:SetTexture(k == 9 and "Interface\\BUTTONS\\UI-GroupLoot-Pass-Up" or ("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d"):format(k))
	
		local target, worldmarker = layout.RT, layout.WM
		-- target icons
		if target then
			button:SetAttribute("type1", "macro")
			button:SetAttribute("macrotext1", ("/tm %d"):format(k))
		end
	
		button:RegisterForClicks("AnyDown")
		self.frame.buttons[k] = button
	end
end

function RM:UpdateWorldMarkersAndTooltips()
	for i = 1, 9 do
		local target, worldmarker = layouts[i].RT, layouts[i].WM
		local button = self.frame.buttons[i]

		if target and not worldmarker then
			-- tooltip
			button:SetScript("OnEnter", function(self)
				self:SetBackdropBorderColor(.7, .7, 0)
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L["Raid Markers"])
				GameTooltip:AddLine(k == 9 and L["Click to clear the mark."] or L["Click to mark the target."], 1, 1, 1)
				GameTooltip:Show()
			end)
		else
			-- add worldmarkers to the macro texts
			local modifier = self.db.modifier or "shift-"
			button:SetAttribute(("%stype1"):format(modifier), "macro")
			button.modifier = modifier
			button:SetAttribute(("%smacrotext1"):format(modifier), worldmarker == 0 and "/cwm all" or ("/cwm %d\n/wm %d"):format(worldmarker, worldmarker))	
			
			button:SetScript("OnEnter", function(self)
				self:SetBackdropBorderColor(.7, .7, 0)
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L["Raid Markers"])
				GameTooltip:AddLine(i == 9 and ("%s\n%s"):format(L["Click to clear the mark."], (L["%sClick to remove all worldmarkers."]):format(button.modifier:upper()))
					or ("%s\n%s"):format(L["Click to mark the target."], (L["%sClick to place a worldmarker."]):format(button.modifier:upper())), 1, 1, 1)
				GameTooltip:Show()
			end)			
		end
		
		-- tooltip
		button:SetScript("OnLeave", function(self)
			self:SetBackdropBorderColor(0, 0, 0)
			GameTooltip:Hide() 
		end)	
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
		self:UpdateWorldMarkersAndTooltips()
	
		if self.db.enabled then
			RegisterStateDriver(self.frame, "visibility", self.db.visibility == 'DEFAULT' and '[noexists, nogroup] hide; show' or self.db.visibility == 'ALWAYS' and '[noexists, nogroup] show; show' or '[group] show; hide')
		else
			UnregisterStateDriver(self.frame, "visibility")
			self.frame:Hide()
		end
		if self.db.backdrop then
			self.frame.backdrop:Show()
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
