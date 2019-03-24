-- 原创模块
local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local AS = E:NewModule('Wind_AnnounceSystem', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

local gsub = string.gsub
local format = string.format
local pairs = pairs

local player_name = UnitName("player")

function AS:SendMessage(text, channel)
	-- 忽视不通告讯息
	if channel == "NONE" then return end
	-- 聊天框输出
	if channel == "SELF" then print(text) return end
	-- 表情频道前置冒号以优化显示
	if channel == "EMOTE" then text = ": "..text end

	SendChatMessage(text, channel)
end

function AS:Interrupt(...)
	local _, _, _, sourceGUID, sourceName, _, _, _, destName, _, _, _, sourceSpellId, _, targetSpellID = ...
	local config = self.db.interrupt
	
	local function FormatMessage(custom_message)
		custom_message = gsub(custom_message, "%%player%%", sourceName)
		custom_message = gsub(custom_message, "%%target%%", destName)
		custom_message = gsub(custom_message, "%%player_spell%%", GetSpellLink(sourceSpellId))
		custom_message = gsub(custom_message, "%%target_spell%%", GetSpellLink(targetSpellID))
		return custom_message
	end

	local function GetChannel(channel_db)
		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			return channel_db.instance
		elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
			return channel_db.raid
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			return channel_db.party
		elseif channel_db.solo then
			return channel_db.solo
		end
		return "NONE"
	end

	-- 如果无法获取到打断法术及被打断法术ID时就终止，否则在某些情况下可能出错
	if not (sourceSpellId and targetSpellID) then return end

	-- 自己打断
	if sourceGUID == UnitGUID("player") or sourceGUID == UnitGUID("pet") then
		if config.player.enabled then
			self:SendMessage(FormatMessage(config.player.text), GetChannel(config.player.channel))
		end
		
		return
	end

	-- 为了防止在开放世界时刷屏，在团队或是队伍中才会开启。
	if not (IsInGroup() or IsInRaid()) then return end
	-- 他人打断
	if config.others.enabled then
		self:SendMessage(FormatMessage(config.others.text), GetChannel(self.db.others.channel))
	end
end

function AS:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local event_type = select(2, CombatLogGetCurrentEventInfo())
    --timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags
    
    -- 打断
    if event_type == "SPELL_INTERRUPT" and self.db.interrupt.enabled then
		self:Interrupt(CombatLogGetCurrentEventInfo())
    end
end

function AS:Initialize()
	self.db = E.db.WindTools["More Tools"]["Announce System"]
	if not self.db.enabled then return end
	-- 监视战斗日志
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local function InitializeCallback()
	AS:Initialize()
end

E:RegisterModule(AS:GetName(), InitializeCallback)