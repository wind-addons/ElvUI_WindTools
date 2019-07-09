-- 原作者：ElvUI_Enhanced (Legion), Marcel Menzel
-- 修改：houshuu, SomeBlu
-------------------
-- 主要修改条目：
-- 修复部分 boss 成就 ID
-- 聚合功能
-- 添加副本自定义功能
-- 汉化

local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local TT  = E:GetModule('Tooltip')
local WT  = E:GetModule("WindTools")
local ETT = E:NewModule('Wind_EnhancedTootip')

ETT.RP = {
	-- sort key
	["tiers"] = { "Uldir", "BattleOfDazaralor", "CrucibleOfStorms" },
	["levels"] = { "Mythic", "Heroic", "Normal", "LFR" },
	-- stat id
	["Raid"] = {
		["Uldir"] = {
			["Mythic"] = {
				12789, 12793, 12797, 12801, 12805, 12811, 12816, 12820,
			},
			["Heroic"] = {
				12788, 12792, 12796, 12800, 12804, 12810, 12815, 12819,
			},
			["Normal"] = {
				12787, 12791, 12795, 12799, 12803, 12809, 12814, 12818,
			},
			["LFR"] = {
				12786, 12790, 12794, 12798, 12802, 12808, 12813, 12817,
			},
		},
		["BattleOfDazaralor"] = {
			["Alliance"] = {
				["Mythic"] = {
					13331, 13353, 13348, 13362, 13366, 13370, 13374, 13378, 13382,
				},
				["Heroic"] = {
					13330, 13351, 13347, 13361, 13365, 13369, 13373, 13377, 13381,
				},
				["Normal"] = {
					13329, 13350, 13346, 13359, 13364, 13368, 13372, 13376, 13380,
				},
				["LFR"] = {
					13328, 13349, 13344, 13358, 13363, 13367, 13371, 13375, 13379,
				},
			},
			["Horde"] = {
				["Mythic"] = {
					13331, 13336, 13357, 13374, 13378, 13382, 13362, 13366, 13370,
				},
				["Heroic"] = {
					13330, 13334, 13356, 13373, 13377, 13381, 13361, 13365, 13369,
				},
				["Normal"] = {
					13329, 13333, 13355, 13372, 13376, 13380, 13359, 13364, 13368,
				},
				["LFR"] = {
					13328, 13332, 13354, 13371, 13375, 13379, 13358, 13363, 13367,
				},
			},
		},
		["CrucibleOfStorms"] = {
			["Mythic"] = {
				13407, 13413,
			},
			["Heroic"] = {
				13406, 13412,
			},
			["Normal"] = {
				13405, 13411,
			},
			["LFR"] = {
				13404, 13408,
			},
		},
	},
	["Dungeon"] = {
		["MythicDungeon"] = {
			["AtalDazar"] = 12749,
			["FreeHold"] = 12752,
			["KingsRest"] = 12763,
			["ShrineOfTheStorm"] = 12768,
			["SiegeOfBoralus"] = 12773,
			["TempleOfSethrealiss"] = 12776,
			["TheMOTHERLODE!!"] = 12779,
			["TheUnderrot"] = 12745,
			["TolDagor"] = 12782,
			["WaycrestManor"] = 12785,
		},
		["Mythic+"] = {
			["Mythic+(LEG&BFA)"] = 7399,
		}
	}
}

local playerGUID = UnitGUID("player")
local playerFaction = UnitFactionGroup("player")
local progressCache = {}

local function getLevelColorString(level, short)
	local color = "ff8000"

	if level == "Mythic" then
		color = "a335ee"
	elseif level == "Heroic" then
		color = "0070dd"
	elseif level == "Normal" then
		color = "1eff00"
	end

	if short then
		return "|cff"..color..string.sub(level, 1, 1).."|r"
	else
		return "|cff"..color..L[level].."|r"
	end
end

function ETT:ItemIcons()
	if not self.db.item_icon.enabled then return end

	-- 来自 Ndui
	local newString = "0:0:64:64:5:59:5:59"

	local function setTooltipIcon(self, icon)
		local title = icon and _G[self:GetName().."TextLeft1"]
		if title then
			title:SetFormattedText("|T%s:20:20:"..newString..":%d|t %s", icon, 20, title:GetText())
		end
	
		for i = 2, self:NumLines() do
			local line = _G[self:GetName().."TextLeft"..i]
			if not line then break end
			local text = line:GetText() or ""
			if strfind(text, "|T.+|t") then
				line:SetText(gsub(text, ":(%d+)|t", ":20:20:"..newString.."|t"))
			end
		end
	end
	
	local function newTooltipHooker(method, func)
		return function(tooltip)
			local modified = false
			tooltip:HookScript("OnTooltipCleared", function()
				modified = false
			end)
			tooltip:HookScript(method, function(self, ...)
				if not modified then
					modified = true
					func(self, ...)
				end
			end)
		end
	end
	
	local hookItem = newTooltipHooker("OnTooltipSetItem", function(self)
		local _, link = self:GetItem()
		if link then
			setTooltipIcon(self, GetItemIcon(link))
		end
	end)
	
	local hookSpell = newTooltipHooker("OnTooltipSetSpell", function(self)
		local _, id = self:GetSpell()
		if id then
			setTooltipIcon(self, GetSpellTexture(id))
		end
	end)
	
	for _, tooltip in pairs{GameTooltip, ItemRefTooltip} do
		hookItem(tooltip)
		hookSpell(tooltip)
	end
	
	-- Tooltip rewards icon
	_G.BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT = "|T%1$s:16:16:"..newString.."|t |cffffffff%2$s|r %3$s"
	_G.BONUS_OBJECTIVE_REWARD_FORMAT = "|T%1$s:16:16:"..newString.."|t %2$s"
	
	local function ReskinRewardIcon(self)
		if self and self.Icon then
			self.Icon:SetTexCoord(unpack(E.TexCoords))
			self.IconBorder:Hide()
		end
	end

	hooksecurefunc("EmbeddedItemTooltip_SetItemByQuestReward", ReskinRewardIcon)
	hooksecurefunc("EmbeddedItemTooltip_SetItemByID", ReskinRewardIcon)
	hooksecurefunc("EmbeddedItemTooltip_SetCurrencyByID", ReskinRewardIcon)
	hooksecurefunc("QuestUtils_AddQuestCurrencyRewardsToTooltip", function(_, _, self) ReskinRewardIcon(self) end)
end

function ETT:UpdateProgression(guid, faction)
	local statFunc = guid == playerGUID and GetStatistic or GetComparisonStatistic

	progressCache[guid] = progressCache[guid] or {}
	progressCache[guid].info =  progressCache[guid].info or {}
	progressCache[guid].timer = GetTime()

	if self.db["Progression"]["Raid"]["enabled"] then -- raid progress
		progressCache[guid].info["Raid"] = {}
		for _,tier in ipairs(self.RP.tiers) do -- arranged by tier
			if self.db["Progression"]["Raid"][tier] then
				progressCache[guid].info["Raid"][tier] = {}
				local bosses = tier == "BattleOfDazaralor" and self.RP["Raid"][tier][faction] or self.RP["Raid"][tier]

				for _,level in ipairs(self.RP.levels) do -- sorted by level
					local highest = 0
					for _,statId in ipairs(bosses[level]) do
						local kills = tonumber(statFunc(statId),10)
						if kills and kills > 0 then
							highest = highest + 1
						end
					end
					if (highest > 0) then
						progressCache[guid].info["Raid"][tier][level] = ("%d/%d"):format(highest, #bosses[level])
						if highest == #bosses[level] then
							break
						end
					end
				end
			end
		end
	end

	if self.db["Progression"]["Dungeon"]["enabled"] then -- mythic dungeons and mythic+
		progressCache[guid].info["Dungeon"] = {}
		for k,v in pairs(self.RP["Dungeon"]) do
			if self.db["Progression"]["Dungeon"][k] then
				progressCache[guid].info["Dungeon"][k] = {}
				for dungeon,statId in pairs(v) do
					progressCache[guid].info["Dungeon"][k][dungeon] = tonumber(statFunc(statId),10)
				end
			end
		end
	end
end

function ETT:SetProgressionInfo(guid, tt)
	if progressCache[guid] then
		local updated = false
		for i=1, tt:NumLines() do
			local leftTip = _G["GameTooltipTextLeft"..i]
			local leftTipText = leftTip:GetText()
			local found = false
			if (leftTipText) then
				if self.db["Progression"]["Raid"]["enabled"] then -- raid progress
					for _,tier in ipairs(self.RP.tiers) do
						if self.db["Progression"]["Raid"][tier] then
							for _,level in ipairs(self.RP.levels) do
								if (leftTipText:find(L[tier]) and leftTipText:find(L[level])) then
									-- update found tooltip text line
									local rightTip = _G["GameTooltipTextRight"..i]
									leftTip:SetText(("%s %s:"):format(L[tier], getLevelColorString(level, false)))
									rightTip:SetText(progressCache[guid].info["Raid"][tier][level])
									updated = true
									found = true
									break
								end
							end
							if found then break end
						end
					end
				end
				if self.db["Progression"]["Dungeon"]["enabled"] then -- mythic dungeons and mythic+
					for k,v in pairs(self.RP["Dungeon"]) do
						if self.db["Progression"]["Dungeon"][k] then
							for dungeon,statId in pairs(v) do
								if (leftTipText:find(L[dungeon])) then
									-- update found tooltip text line
									local rightTip = _G["GameTooltipTextRight"..i]
									leftTip:SetText(L[dungeon]..":")
									rightTip:SetText(getLevelColorString(level, true)..progressCache[guid].info["Dungeon"][k][dungeon])
									updated = true
									found = true
									break
								end
							end
							if found then break end
						end
					end
				end
			end
		end
		if updated then return end
		-- add progression tooltip line
		if self.db["Progression"]["Raid"]["enabled"] then -- raid progress
			tt:AddLine(" ")
			tt:AddLine(L["Raids"])
			for _,tier in ipairs(self.RP.tiers) do -- Raid
				if self.db["Progression"]["Raid"][tier] then
					for _,level in ipairs(self.RP.levels) do
						if (progressCache[guid].info["Raid"][tier][level]) then
							tt:AddDoubleLine(("%s %s:"):format(L[tier], getLevelColorString(level, false)), getLevelColorString(level, true).." "..progressCache[guid].info["Raid"][tier][level], nil, nil, nil, 1, 1, 1)
						end
					end
				end
			end
		end
		if self.db["Progression"]["Dungeon"]["enabled"] then -- mythic dungeons and mythic+
			tt:AddLine(" ")
			tt:AddLine(L["Dungeon"])
			for k,v in pairs(self.RP["Dungeon"]) do
				if self.db["Progression"]["Dungeon"][k] then
					for dungeon,statId in pairs(v) do
						tt:AddDoubleLine(L[dungeon]..":", progressCache[guid].info["Dungeon"][k][dungeon], nil, nil, nil, 1, 1, 1)
					end
				end
			end
		end
	end
end

function TT:INSPECT_ACHIEVEMENT_READY(event, GUID)
	if (self.compareGUID ~= GUID) then return end

	local unit = "mouseover"
	if UnitExists(unit) then
		local race = select(3,UnitRace(unit))
		local faction = race and C_CreatureInfo.GetFactionInfo(race).groupTag
		if (faction) then
			ETT:UpdateProgression(GUID, faction)
			GameTooltip:SetUnit(unit)
		end
	end
	ClearAchievementComparisonUnit()
	self:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
end

function ETT.AddInspectInfo(self, tt, unit, numTries, r, g, b)
	if InCombatLockdown() then return end
	if not ETT.db["Progression"]["enabled"] then return end
	if not (unit and CanInspect(unit)) then return end
	local level = UnitLevel(unit)
	if not level or level < MAX_PLAYER_LEVEL then return end
	local guid = UnitGUID(unit)

	if not progressCache[guid] or (GetTime() - progressCache[guid].timer) > 600 then
		if guid == playerGUID then
			ETT:UpdateProgression(guid, playerFaction)
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
	if not E.db.WindTools["Interface"]["Enhanced Tooltip"].enabled then return end

	self.db = E.db.WindTools["Interface"]["Enhanced Tooltip"]
	tinsert(WT.UpdateAll, function()
		ETT.db = E.db.WindTools["Interface"]["Enhanced Tooltip"]
	end)

	self:ItemIcons()
	hooksecurefunc(TT, 'AddInspectInfo', ETT.AddInspectInfo)
end

local function InitializeCallback()
	ETT:Initialize()
end

E:RegisterModule(ETT:GetName(), InitializeCallback)