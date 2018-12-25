-- 原作者：ElvUI_Enhanced (Legion), Marcel Menzel
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 修复部分 boss 成就 ID
-- 聚合功能
-- 添加副本自定义功能
-- 汉化

local E, L, V, P, G = unpack(ElvUI);
local TT  = E:GetModule('Tooltip')
local WT  = E:GetModule("WindTools")
local ETT = E:NewModule('Wind_EnhancedTootip')

ETT.RP = {
	tiers = { "Uldir" },
	levels = { L["Mythic"], L["Heroic"], L["Normal"], L["LFR"] },
	bosses = {
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
}

local playerGUID = UnitGUID("player")
local progressCache = {}
local highest = { 0, 0 }

function ETT:UpdateProgression(guid)
	local kills, complete, pos = 0, false, 0
	local statFunc = guid == playerGUID and GetStatistic or GetComparisonStatistic

	progressCache[guid] = progressCache[guid] or {}
	progressCache[guid].header = progressCache[guid].header or {}
	progressCache[guid].info =  progressCache[guid].info or {}
	progressCache[guid].timer = GetTime()
		
	for tier, tierName in pairs(self.RP.tiers) do
		if self.db["Raid Progression"][tierName] then
			progressCache[guid].header[tier] = {}
			progressCache[guid].info[tier] = {}
			for level = 1, 4 do
				highest = 0
				for statInfo = 1, #self.RP.bosses[tier][level] do
					kills = tonumber((statFunc(self.RP.bosses[tier][level][statInfo])))
					if kills and kills > 0 then
						highest = highest + 1
					end
				end
				pos = highest
				if (highest > 0) then
					progressCache[guid].header[tier][level] = ("%s [%s]:"):format(L[tierName], self.RP.levels[level])
					progressCache[guid].info[tier][level] = ("%d/%d"):format(highest, #self.RP.bosses[tier][level])
					if highest == #self.RP.bosses[tier][level] then
						break
					end
				end
			end
		end
	end
end

function ETT:SetProgressionInfo(guid, tt)
	if progressCache[guid] then
		local updated = 0
		for i=1, tt:NumLines() do
			local leftTipText = _G["GameTooltipTextLeft"..i]	
			for tier, tierName in pairs(self.RP.tiers) do
				if self.db["Raid Progression"][tierName] then
					for level = 1, 4 do
						if (leftTipText:GetText() and leftTipText:GetText():find(L[tierName]) and leftTipText:GetText():find(self.RP.levels[level])) then
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
		for tier, tierName in pairs(ETT.RP.tiers) do
			if self.db["Raid Progression"][tierName] then
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
		ETT:UpdateProgression(GUID)
		GameTooltip:SetUnit(unit)
	end
	ClearAchievementComparisonUnit()
	self:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
end

function ETT.ShowInspectInfo(self, tt, unit, r, g, b)
	if InCombatLockdown() then return end
	if not ETT.db["Raid Progression"]["enabled"] then return end
	local level = UnitLevel(unit)
	if not level or level < MAX_PLAYER_LEVEL then return end
	if not (unit and CanInspect(unit)) then return end
	local guid = UnitGUID(unit)

	if not progressCache[guid] or (GetTime() - progressCache[guid].timer) > 600 then
		if guid == playerGUID then
			ETT:UpdateProgression(guid)
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
	ETT:SetProgressionInfo(guid, tt)
end

function ETT:Initialize()
	self.db = E.db.WindTools["Interface"]["Enhanced Tooltip"]
	if not self.db.enabled then return end
	-- 鼠标提示副本进度
	hooksecurefunc(TT, 'ShowInspectInfo', ETT.ShowInspectInfo)
end

local function InitializeCallback()
	ETT:Initialize()
end

E:RegisterModule(ETT:GetName(), InitializeCallback)