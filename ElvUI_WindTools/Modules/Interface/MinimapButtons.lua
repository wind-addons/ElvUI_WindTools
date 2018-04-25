-- 原作：Square Minimap Buttons
-- 原作者：Azilroka, Sinaris, Feraldin
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 汉化

local E, L, V, P, G = unpack(ElvUI);
local WT = E:GetModule("WindTools")
local MB = E:NewModule('MinimapButtons', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

P["WindTools"]["Minimap Buttons"] = {
	["enabled"] = false,
	['skinStyle'] = 'HORIZONTAL',
	['backdrop'] = false,
	['layoutDirection'] = 'NORMAL',
	['buttonSize'] = 28,
	['mouseover'] = false,
	['mbcalendar'] =  false,
	['mbgarrison'] = false,
}

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
	if not E.minimapbuttons.db.mouseover or E.minimapbuttons.db.skinStyle == 'NOANCHOR' then return end
	UIFrameFadeIn(MinimapButtonBar, 0.2, MinimapButtonBar:GetAlpha(), 1)
	if self:GetName() ~= 'MinimapButtonBar' then
		self:SetBackdropBorderColor(.7, .7, 0)
	end
end

local function OnLeave(self)
	if not E.minimapbuttons.db.mouseover or E.minimapbuttons.db.skinStyle == 'NOANCHOR' then return end
	UIFrameFadeOut(MinimapButtonBar, 0.2, MinimapButtonBar:GetAlpha(), 0)
	if self:GetName() ~= 'MinimapButtonBar' then
		self:SetBackdropBorderColor(0, 0, 0)
	end
end

function MB:SkinButton(frame)
	if not E.minimapbuttons.db.mbcalendar then
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
	if name == "GarrisonLandingPageMinimapButton" and E.minimapbuttons.db.mbgarrison then frame:SetScale(1) end
	
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
	if E.minimapbuttons.db.skinStyle ~= 'NOANCHOR' then
		MB:ScheduleTimer("UpdateLayout", .05)
	end
end

function MB:UpdateSkinStyle()
	local doreload = 0
	if E.minimapbuttons.db.skinStyle == 'NOANCHOR' then 
		if E.minimapbuttons.db.mbgarrison then
			E.minimapbuttons.db.mbgarrison = false
			doreload = 1
		end
		if E.minimapbuttons.db.mbcalendar then 
			E.minimapbuttons.db.mbcalendar = false
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
	if not E.minimapbuttons then return end
	if InCombatLockdown() then
		MB:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateLayout")	
		return
	else
		MB:UnregisterEvent("PLAYER_REGEN_ENABLED")
 	end
	
	local direction = E.minimapbuttons.db.layoutDirection == 'NORMAL'
	local offset = direction and -2 or 2

	if E.minimapbuttons.db.skinStyle == 'HORIZONTAL' then
		minimapButtonBar:SetPoint(direction and 'LEFT' or 'RIGHT', minimapButtonBarAnchor, direction and 'LEFT' or 'RIGHT', -2, 0)
	else
		minimapButtonBar:SetPoint(direction and 'TOP' or 'BOTTOM', minimapButtonBarAnchor, direction and 'TOP' or 'BOTTOM', -2, 0)
	end
	minimapButtonBar:SetSize(E.minimapbuttons.db.buttonSize + 4, E.minimapbuttons.db.buttonSize + 4)
	
	local lastFrame, anchor1, anchor2, offsetX, offsetY
	
	for i = 1, #moveButtons do
		local frame =	_G[moveButtons[i]]
		
		if E.minimapbuttons.db.skinStyle == 'NOANCHOR' then
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
			frame:Size(E.minimapbuttons.db.buttonSize)

			if E.minimapbuttons.db.skinStyle == 'HORIZONTAL' then
				anchor1 = direction and 'RIGHT' or 'LEFT'
				anchor2 = direction and 'LEFT' or 'RIGHT'
				offsetX = offset
				offsetY = 0
			else
				anchor1 = direction and 'TOP' or 'BOTTOM'
				anchor2 = direction and 'BOTTOM' or 'TOP'
				offsetX = 0
				offsetY = offset
			end
			
			if not lastFrame then
				frame:SetPoint(anchor1, minimapButtonBar, anchor1, offsetX, offsetY)
			else
				frame:SetPoint(anchor1, lastFrame, anchor2, offsetX, offsetY)
			end
		end
		lastFrame = frame	
	end
	
	if E.minimapbuttons.db.skinStyle ~= 'NOANCHOR' and #moveButtons > 0 then
		if E.minimapbuttons.db.skinStyle == "HORIZONTAL" then
			minimapButtonBar:SetWidth((E.minimapbuttons.db.buttonSize * #moveButtons) + (2 * #moveButtons + 1) + 1)
		else
			minimapButtonBar:SetHeight((E.minimapbuttons.db.buttonSize * #moveButtons) + (2 * #moveButtons + 1) + 1)
		end
		minimapButtonBarAnchor:SetSize(minimapButtonBar:GetSize())
		minimapButtonBar:Show()
		RegisterStateDriver(minimapButtonBar, "visibility", '[petbattle]hide;show')
	else
		UnregisterStateDriver(minimapButtonBar, "visibility")
		minimapButtonBar:Hide()
	end
	
	if E.minimapbuttons.db.backdrop then
		minimapButtonBar.backdrop:Show()
	else
		minimapButtonBar.backdrop:Hide()
	end
end

function MB:ChangeMouseOverSetting()
	if E.minimapbuttons.db.mouseover then
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
	if E.minimapbuttons.db.mbgarrison then
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
	
	--if E.db.auras.consolidatedBuffs.enable then
	--	minimapButtonBarAnchor:Point("TOPRIGHT", ElvConfigToggle, "BOTTOMRIGHT", 0, -2)
	--else
	minimapButtonBarAnchor:Point("TOPRIGHT", RightMiniPanel, "BOTTOMRIGHT", 0, -2)
	--end
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
	E.minimapbuttons = MB
	E.minimapbuttons.db = E.db.WindTools["Minimap Buttons"]

	if not E.minimapbuttons.db.enabled then return end

	self:CreateFrames()
end

local function InsertOptions()
	E.Options.args.WindTools.args["Interface"].args["Minimap Buttons"].args["featureconfig"] = {
		order = 10,
		type = "group",
		get = function(info) return E.db.WindTools["Minimap Buttons"][ info[#info] ] end,
		set = function(info, value) E.db.WindTools["Minimap Buttons"][ info[#info] ] = value; MB:UpdateLayout() end,
		name = L["Minimap Button Bar"],
		args = {
			skinStyle = {
				order = 1,
				type = 'select',
				name = L['Skin Style'],
				desc = L['Change settings for how the minimap buttons are skinned.'],
				set = function(info, value) E.db.WindTools["Minimap Buttons"][ info[#info] ] = value; MB:UpdateSkinStyle() end,
				values = {
					['NOANCHOR'] = L['No Anchor Bar'],
					['HORIZONTAL'] = L['Horizontal Anchor Bar'],
					['VERTICAL'] = L['Vertical Anchor Bar'],
				},
			},
			layoutDirection = {
				order = 3,
				type = 'select',
				name = L['Layout Direction'],
				desc = L['Normal is right to left or top to bottom, or select reversed to switch directions.'],
				values = {
					['NORMAL'] = L['Normal'],
					['REVERSED'] = L['Reversed'],
				},
			},
			buttonSize = {
				order = 4,
				type = 'range',
				name = L['Button Size'],
				desc = L['The size of the minimap buttons.'],
				min = 16, max = 40, step = 1,
				disabled = function() return E.db.WindTools["Minimap Buttons"]["skinStyle"] == 'NOANCHOR' end,
			},
			backdrop = {
				type = 'toggle',
				order = 5,
				name = L["Backdrop"],
				disabled = function() return E.db.WindTools["Minimap Buttons"]["skinStyle"] == 'NOANCHOR' end,
			},			
			mouseover = {
				order = 6,
				name = L['Mouse Over'],
				desc = L['The frame is not shown unless you mouse over the frame.'],
				type = "toggle",
				set = function(info, value) E.db.WindTools["Minimap Buttons"]["mouseover"] = value; MB:ChangeMouseOverSetting() end,
				disabled = function() return E.db.WindTools["Minimap Buttons"]["skinStyle"] == 'NOANCHOR' end,
			},
			mmbuttons = {
				order = 7,
				type = "group",
				name = L["Minimap Buttons"],
				guiInline = true,
				args = {
					mbgarrison = {
						order = 1,
						name = GARRISON_LOCATION_TOOLTIP,
						desc = L['TOGGLESKIN_DESC'],
						type = "toggle",
						disabled = function() return E.db.WindTools["Minimap Buttons"]["skinStyle"] == 'NOANCHOR' end,
						set = function(info, value) E.db.WindTools["Minimap Buttons"]["mbgarrison"] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					},
					mbcalendar = {
						order = 1,
						name = L['Calendar'],
						desc = L['TOGGLESKIN_DESC'],
						type = "toggle",
						disabled = function() return E.db.WindTools["Minimap Buttons"]["skinStyle"] == 'NOANCHOR' end,
						set = function(info, value) E.db.WindTools["Minimap Buttons"]["mbcalendar"] = value; E:StaticPopup_Show("PRIVATE_RL") end,
					}
				}
			}
		}
	}
end


WT.ToolConfigs["Minimap Buttons"] = InsertOptions
E:RegisterModule(MB:GetName())
