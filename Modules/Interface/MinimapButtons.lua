-- 原作：Square Minimap Buttons
-- 原作者：Azilroka, Sinaris, Feraldin
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 汉化

local E, _, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local L = unpack(select(2, ...))
local WT = E:GetModule("WindTools")
local MB = E:NewModule('Wind_MinimapButtons', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0')

local sub, len, find = string.sub, string.len, string.find

-- list of specific minimap frames ignored
local ignoreButtons = {
	"AsphyxiaUIMinimapHelpButton",
	"AsphyxiaUIMinimapVersionButton",
	"ElvConfigToggle",
	"ElvUIConfigToggle",
	"ElvUI_ConsolidatedBuffs",
	--"GameTimeFrame",
	"HelpOpenTicketButton",
	"MMHolder",
	"DroodFocusMinimapButton",
	"QueueStatusMinimapButton",
	"TimeManagerClockButton",
	"MinimapZoneTextButton",
}

-- list of frames that are ignored when they start with this text
local genericIgnores = {
	"Archy",
	"GatherMatePin",
	"GatherNote",
	"GuildInstance",
	"HandyNotesPin",
	"MinimMap",
	"Spy_MapNoteList_mini",
	"ZGVMarker",
}

-- ignore all frames where then name contains this text
local partialIgnores = {
	"Node",
	"Note",
	"Pin",
}

-- whitelist all frames starting with
local whiteList = {
	"LibDBIcon",
}

local moveButtons = {}
local minimapButtonBarAnchor, minimapButtonBar

local function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

local function OnEnter(self)
	if not self.db.mouseover or self.db.skinStyle == 'NOANCHOR' then return end
	UIFrameFadeIn(MinimapButtonBar, 0.2, MinimapButtonBar:GetAlpha(), 1)
	if self:GetName() ~= 'MinimapButtonBar' then
		self:SetBackdropBorderColor(.7, .7, 0)
	end
end

local function OnLeave(self)
	if not self.db.mouseover or self.db.skinStyle == 'NOANCHOR' then return end
	UIFrameFadeOut(MinimapButtonBar, 0.2, MinimapButtonBar:GetAlpha(), 0)
	if self:GetName() ~= 'MinimapButtonBar' then
		self:SetBackdropBorderColor(0, 0, 0)
	end
end

function MB:SkinButton(frame)
	if not self.db.mbcalendar then
		table.insert(ignoreButtons, "GameTimeFrame")
	end

	if frame == nil or frame:GetName() == nil or (frame:GetObjectType() ~= "Button") or not frame:IsVisible() then return end
	
	local name = frame:GetName()
	local validIcon = false
	
	for i = 1, #whiteList do
		if sub(name, 1, len(whiteList[i])) == whiteList[i] then validIcon = true break end
	end
	
	if not validIcon then
		for i = 1, #ignoreButtons do
			if name == ignoreButtons[i] then return end
		end
		
		for i = 1, #genericIgnores do
			if sub(name, 1, len(genericIgnores[i])) == genericIgnores[i] then return end
		end
		
		for i = 1, #partialIgnores do
			if find(name, partialIgnores[i]) ~= nil then return end
		end
	end
	
	if name ~= "GarrisonLandingPageMinimapButton" then 
		frame:SetPushedTexture(nil)
		frame:SetDisabledTexture(nil)
	end
	frame:SetHighlightTexture(nil)
	
	if name == "DBMMinimapButton" then frame:SetNormalTexture("Interface\\Icons\\INV_Helmet_87") end
	if name == "SmartBuff_MiniMapButton" then frame:SetNormalTexture(select(3, GetSpellInfo(12051))) end
	if name == "GarrisonLandingPageMinimapButton" and self.db.mbgarrison then frame:SetScale(1) end
	
	if not frame.isSkinned then
		frame:HookScript('OnEnter', OnEnter)
		frame:HookScript('OnLeave', OnLeave)
		frame:HookScript('OnClick', MB.DelayedUpdateLayout)
		for i = 1, frame:GetNumRegions() do
			local region = select(i, frame:GetRegions())
			frame.original = {}
			frame.original.Width, frame.original.Height = frame:GetSize()
			frame.original.Point, frame.original.relativeTo, frame.original.relativePoint, frame.original.xOfs, frame.original.yOfs = frame:GetPoint()
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

				if (texture and (type(texture) ~= "number") and (texture:find("Border") or texture:find("Background") or texture:find("AlphaMask"))) then
					region:SetTexture(nil)
				else
					region:ClearAllPoints()
					region:Point("TOPLEFT", frame, "TOPLEFT", 2, -2)
					region:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
					region:SetTexCoord( 0.1, 0.9, 0.1, 0.9 )
					region:SetDrawLayer( "ARTWORK" )
					if (name == "GameTimeFrame") then
						if (region:GetName() == "GameTimeCalendarInvitesTexture") then
							region:SetTexCoord( 0.03125, 0.6484375, 0.03125, 0.8671875 )
							region:SetDrawLayer("ARTWORK", 1)
						elseif (region:GetName() == "GameTimeCalendarInvitesGlow") then
							region:SetTexCoord( 0.1, 0.9, 0.1, 0.9 )
						elseif (region:GetName() == "GameTimeCalendarEventAlarmTexture") then
							region:SetTexCoord( 0.1, 0.9, 0.1, 0.9 )
						elseif (region:GetName() == "GameTimeTexture") then
							region:SetTexCoord( 0.0, 0.390625, 0.0, 0.78125 )
						else
							region:SetTexCoord( 0.0, 0.390625, 0.0, 0.78125 )
						end
					end

					if (name == "PS_MinimapButton") then
						region.SetPoint = function() end
					end
				end
			end
		end
		frame:SetTemplate("Tranparent")

		tinsert(moveButtons, name)
		frame.isSkinned = true
	end
end

function MB:DelayedUpdateLayout()
	if self.db.skinStyle ~= 'NOANCHOR' then
		MB:ScheduleTimer("UpdateLayout", .05)
	end
end

function MB:UpdateSkinStyle()
	local doreload = 0
	if self.db.skinStyle == 'NOANCHOR' then 
		if self.db.mbgarrison then
			self.db.mbgarrison = false
			doreload = 1
		end
		if self.db.mbcalendar then 
			self.db.mbcalendar = false
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
	if not self.db.enabled then return end
	if InCombatLockdown() then
		MB:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateLayout")	
		return
	else
		MB:UnregisterEvent("PLAYER_REGEN_ENABLED")
 	end
	
	local AnchorX, AnchorY, MaxX = 0, 1, self.db.buttonsPerRow
	local ButtonsPerRow = self.db.buttonsPerRow
	local NumColumns = ceil(#moveButtons / ButtonsPerRow)
	local Spacing, Mult = 2, 1
	local Size = self.db.buttonSize
	local ActualButtons, Maxed = 0
	local direction = self.db.layoutDirection == 'NORMAL'
	local offset = direction and -2 or 2

	if NumColumns == 1 and ButtonsPerRow > #moveButtons then
		ButtonsPerRow = #moveButtons
	end

	if self.db.skinStyle == 'HORIZONTAL' then
		minimapButtonBar:SetPoint(direction and 'LEFT' or 'RIGHT', minimapButtonBarAnchor, direction and 'LEFT' or 'RIGHT', -2, 0)
	else
		minimapButtonBar:SetPoint(direction and 'TOP' or 'BOTTOM', minimapButtonBarAnchor, direction and 'TOP' or 'BOTTOM', -2, 0)
	end
	minimapButtonBar:SetSize(self.db.buttonSize + 4, self.db.buttonSize + 4)
	
	local lastFrame, anchor1, anchor2, offsetX, offsetY
	
	for i = 1, #moveButtons do
		local frame = _G[moveButtons[i]]
		
		AnchorX = AnchorX + 1
		ActualButtons = ActualButtons + 1
		if AnchorX > MaxX then
			AnchorY = AnchorY + 1
			AnchorX = 1
			Maxed = true
		end

		if self.db.skinStyle == 'NOANCHOR' then
			frame:SetParent(frame.original.Parent)
			if frame.original.DragStart then
				frame:SetScript("OnDragStart", frame.original.DragStart)
			end
			if frame.original.DragEnd then
				frame:SetScript("OnDragStop", frame.original.DragEnd)
			end
			frame:ClearAllPoints()
			frame:SetSize(frame.original.Width, frame.original.Height)
			--if frame:GetName() == "LibDBIcon10_TradeSkillMaster" then
			--end
			if frame.original.Point ~= nil then
				frame:SetPoint(frame.original.Point, frame.original.relativeTo, frame.original.relativePoint, frame.original.xOfs, frame.original.yOfs)
			else
				frame:SetPoint("CENTER", Minimap, "CENTER", -80, -34)
			end
			frame:SetFrameStrata(frame.original.FrameStrata)
			frame:SetFrameLevel(frame.original.FrameLevel)
			frame:SetScale(frame.original.Scale)
			frame:SetMovable(true)
		else
			frame:SetParent(minimapButtonBar)
			frame:SetMovable(false)
			frame:SetScript("OnDragStart", nil)
			frame:SetScript("OnDragStop", nil)
			
			frame:ClearAllPoints()
			frame:SetFrameStrata("LOW")
			frame:SetFrameLevel(20)
			frame:Size(self.db.buttonSize)

			if self.db.skinStyle == 'HORIZONTAL' then
				anchor1 = direction and 'TOPLEFT' or 'TOPRIGHT'
				anchor2 = direction and 'TOPRIGHT' or 'TOPLEFT'
				offsetX = direction and (Spacing + ((Size + Spacing) * (AnchorX - 1))) or -(Spacing + ((Size + Spacing) * (AnchorX - 1)))
				offsetY = (- Spacing - ((Size + Spacing) * (AnchorY - 1)))
			else
				anchor1 = direction and 'BOTTOMRIGHT' or 'TOPRIGHT'
				anchor2 = direction and 'TOPRIGHT' or 'BOTTOMRIGHT'
				offsetX = (- ((Size + Spacing) * (AnchorY - 1)))
				offsetY = direction and (Spacing + ((Size + Spacing) * (AnchorX - 1))) or -(Spacing + ((Size + Spacing) * (AnchorX - 1)))
			end
			frame:SetPoint(anchor1, minimapButtonBar, anchor1, offsetX, offsetY)
			if Maxed then ActualButtons = ButtonsPerRow end
		end
		lastFrame = frame
	end
	
	if self.db.skinStyle ~= 'NOANCHOR' and #moveButtons > 0 then
		if self.db.skinStyle == "HORIZONTAL" then
			--minimapButtonBar:SetWidth((self.db.buttonSize * #moveButtons) + (2 * #moveButtons + 1) + 1)
			local BarWidth = (Spacing + ((Size * (ActualButtons * Mult)) + ((Spacing * (ActualButtons - 1)) * Mult) + (Spacing * Mult)))
			local BarHeight = (Spacing + ((Size * (AnchorY * Mult)) + ((Spacing * (AnchorY - 1)) * Mult) + (Spacing * Mult)))
			minimapButtonBar:SetSize(BarWidth, BarHeight)
		else
			--minimapButtonBar:SetHeight((self.db.buttonSize * #moveButtons) + (2 * #moveButtons + 1) + 1)
			local BarWidth = (Spacing + ((Size * (AnchorY * Mult)) + ((Spacing * (AnchorY - 1)) * Mult) + (Spacing * Mult)))
			local BarHeight = (Spacing + ((Size * (ActualButtons * Mult)) + ((Spacing * (ActualButtons - 1)) * Mult) + (Spacing * Mult)))
			minimapButtonBar:SetSize(BarWidth, BarHeight)
		end
		minimapButtonBarAnchor:SetSize(minimapButtonBar:GetSize())
		minimapButtonBar:Show()
		RegisterStateDriver(minimapButtonBar, "visibility", '[petbattle]hide;show')
	else
		UnregisterStateDriver(minimapButtonBar, "visibility")
		minimapButtonBar:Hide()
	end
	
	if self.db.backdrop then
		minimapButtonBar.backdrop:Show()
	else
		minimapButtonBar.backdrop:Hide()
	end
end

function MB:ChangeMouseOverSetting()
	if self.db.mouseover then
		minimapButtonBar:SetAlpha(0)
	else
		minimapButtonBar:SetAlpha(1)
	end
end

function MB:SkinMinimapButtons()
	MB:RegisterEvent("ADDON_LOADED", "StartSkinning")

	for i = 1, Minimap:GetNumChildren() do
		self:SkinButton(select(i, Minimap:GetChildren()))
	end
	if self.db.mbgarrison then
		self:SkinButton(GarrisonLandingPageMinimapButton)
	end
	MB:UpdateLayout()
end

function MB:StartSkinning()
	MB:UnregisterEvent("ADDON_LOADED")

	MB:ScheduleTimer("SkinMinimapButtons", 5)
end

function MB:CreateFrames()
	minimapButtonBarAnchor = CreateFrame("Frame", "MinimapButtonBarAnchor", E.UIParent)
	minimapButtonBarAnchor:Point("TOPRIGHT", RightMiniPanel, "BOTTOMRIGHT", 0, -2)
	minimapButtonBarAnchor:Size(200, 32)
	minimapButtonBarAnchor:SetFrameStrata("BACKGROUND")
	
	E:CreateMover(minimapButtonBarAnchor, "MinimapButtonAnchor", L["Minimap Button Bar"])

	minimapButtonBar = CreateFrame("Frame", "MinimapButtonBar", E.UIParent)
	minimapButtonBar:SetFrameStrata('LOW')
	minimapButtonBar:CreateBackdrop('Transparent')
	minimapButtonBar:ClearAllPoints()
	minimapButtonBar:SetPoint("CENTER", minimapButtonBarAnchor, "CENTER", 0, 0)
	minimapButtonBar:SetScript("OnEnter", OnEnter)
	minimapButtonBar:SetScript("OnLeave", OnLeave)

	minimapButtonBar.backdrop:SetAllPoints()

	self:ChangeMouseOverSetting()
	self:SkinMinimapButtons()
end

function MB:Initialize()
	if not E.db.WindTools["Interface"]["Minimap Buttons"].enabled then return end

	self.db = E.db.WindTools["Interface"]["Minimap Buttons"]
	tinsert(WT.UpdateAll, function()
		MB.db = E.db.WindTools["Interface"]["Minimap Buttons"]
	end)

	self:CreateFrames()
end

local function InitializeCallback()
	MB:Initialize()
end
E:RegisterModule(MB:GetName(), InitializeCallback)