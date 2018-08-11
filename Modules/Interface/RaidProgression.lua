-- 原作：Progression (ElvUI_Enhanced (Legion) 的一个组件)
-- 原作者：ElvUI_Enhanced (Legion)
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 修复部分 boss 成就 ID
-- 添加副本自定义功能
-- 汉化

local E, L, V, P, G = unpack(ElvUI);
local TT = E:GetModule('Tooltip')
local WT = E:GetModule("WindTools")

P["WindTools"]["Raid Progression"] = {
	["enabled"] = true,
	["Uldir"] = true,
}

local tiers = { "Uldir" }
local levels = { 
	L["Mythic"], 
	L["Heroic"], 
	L["Normal"],
	L["LFR"],
}

local bosses = {
	{ -- 奧迪爾
		{ -- 傳奇
			12789, 12793, 12797, 12801, 12805, 12811, 12816, 12820,
		},
		{ -- 英雄
			12788, 12792, 12796, 12800, 12804, 12810, 12815, 12819,
		},
		{ -- 普通
			12787, 12791, 12795, 12799, 12803, 12809, 12814, 12818,
		},
		{ -- 團隊搜尋器
			12786, 12790, 12794, 12798, 12802, 12808, 12813, 12817,
		},
	},
}

local playerGUID = UnitGUID("player")
local progressCache = {}
local highest = { 0, 0 }

local function GetProgression(guid)
	local kills, complete, pos = 0, false, 0
	local statFunc = guid == playerGUID and GetStatistic or GetComparisonStatistic
	
	for tier, tierName in pairs(tiers) do
		if E.db.WindTools["Raid Progression"][tierName] then
			progressCache[guid].header[tier] = {}
			progressCache[guid].info[tier] = {}
			for level = 1, 4 do
				highest = 0
				for statInfo = 1, #bosses[tier][level] do
					kills = tonumber((statFunc(bosses[tier][level][statInfo])))
					if kills and kills > 0 then						
						highest = highest + 1
					end
				end
				pos = highest
				if (highest > 0) then
					progressCache[guid].header[tier][level] = ("%s [%s]:"):format(L[tierName], levels[level])
					progressCache[guid].info[tier][level] = ("%d/%d"):format(highest, #bosses[tier][level])
					if highest == #bosses[tier][level] then
						break
					end
				end
			end
		end
	end		
end

local function UpdateProgression(guid)
	progressCache[guid] = progressCache[guid] or {}
	progressCache[guid].header = progressCache[guid].header or {}
	progressCache[guid].info =  progressCache[guid].info or {}
	progressCache[guid].timer = GetTime()
		
	GetProgression(guid)	
end

local function SetProgressionInfo(guid, tt)
	if progressCache[guid] then
		local updated = 0
		for i=1, tt:NumLines() do
			local leftTipText = _G["GameTooltipTextLeft"..i]	
			for tier, tierName in pairs(tiers) do
				if E.db.WindTools["Raid Progression"][tierName] then
					for level = 1, 4 do
						if (leftTipText:GetText() and leftTipText:GetText():find(L[tierName]) and leftTipText:GetText():find(levels[level])) then
							-- update found tooltip text line
							local rightTipText = _G["GameTooltipTextRight"..i]
							leftTipText:SetText(progressCache[guid].header[tier][level])
							rightTipText:SetText(progressCache[guid].info[tier][level])
							updated = 1
						end
					end
				end
			end
		end
		if updated == 1 then return end
		-- add progression tooltip line
		if highest > 0 then tt:AddLine(" ") end
		for tier, tierName in pairs(tiers) do
			if E.db.WindTools["Raid Progression"][tierName] then
				for level = 1, 4 do
					tt:AddDoubleLine(progressCache[guid].header[tier][level], progressCache[guid].info[tier][level], nil, nil, nil, 1, 1, 1)
				end
			end
		end
	end
end

function TT:INSPECT_ACHIEVEMENT_READY(event, GUID)
	if (self.compareGUID ~= GUID) then return end

	local unit = "mouseover"
	if UnitExists(unit) then
		UpdateProgression(GUID)
		GameTooltip:SetUnit(unit)
	end
	ClearAchievementComparisonUnit()
	self:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
end

hooksecurefunc(TT, 'ShowInspectInfo', function(self, tt, unit, level, r, g, b, numTries)
	if InCombatLockdown() then return end
	if not E.db.WindTools["Raid Progression"]["enabled"] then return end
	if not level or level < MAX_PLAYER_LEVEL then return end
	if not (unit and CanInspect(unit)) then return end
	
	local guid = UnitGUID(unit)
	if not progressCache[guid] or (GetTime() - progressCache[guid].timer) > 600 then
		if guid == playerGUID then
			UpdateProgression(guid)
		else
			ClearAchievementComparisonUnit()		
			if not self.loadedComparison and select(2, IsAddOnLoaded("Blizzard_AchievementUI")) then
				AchievementFrame_DisplayComparison(unit)
				HideUIPanel(AchievementFrame)
				ClearAchievementComparisonUnit()
				self.loadedComparison = true
			end
			
			self.compareGUID = guid
			if SetAchievementComparisonUnit(unit) then
				self:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
			end
			return
		end
	end

	SetProgressionInfo(guid, tt)
end)

local function InsertOptions()
	E.Options.args.WindTools.args["Interface"].args["Raid Progression"].args["raidsetting"] = {
		order = 11,
		type = "group",
		name = L["Raid Setting"],
		guiInline = true,
		get = function(info) return E.db.WindTools["Raid Progression"][info[#info]] end,
		set = function(info, value) E.db.WindTools["Raid Progression"][info[#info]] = value end,
		args = {
			Uldir = {
				order = 1,
				type = "toggle",
				name = L["Uldir"],
			},
		}
	}
end

WT.ToolConfigs["Raid Progression"] = InsertOptions