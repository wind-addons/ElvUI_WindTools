-- 原作：(无名代码片段)
-- 原作者：heng9999（http://nga.178.com/read.php?tid=5522598&page=1#pid95992230Anchor）
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 添加自定义功能开关

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local TabChatMod = E:NewModule('TabChatMod', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

local _G = _G
local CreateFrame = CreateFrame
local tostring = tostring
local GetNumSubgroupMembers = GetNumSubgroupMembers
local IsInGroup = IsInGroup
local GetNumGroupMembers = GetNumGroupMembers
local IsInRaid = IsInRaid
local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
local IsInInstance = IsInInstance
local ChatEdit_UpdateHeader = ChatEdit_UpdateHeader
local IsInGuild = IsInGuild
local CanEditOfficerNote = CanEditOfficerNote
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local format = string.format
local hooksecurefunc = hooksecurefunc

P["WindTools"]["Tab Chat Mod"] = {
	["enabled"] = true,
	["whispercycle"] = false,
	["useofficer"] = false,
}

function TabChatMod:Initialize()
	if not E.db.WindTools["Tab Chat Mod"]["enabled"] then return end

	function ChatEdit_CustomTabPressed(self)
		if strsub(tostring(self:GetText()), 1, 1) == "/" then return end
		if  (self:GetAttribute("chatType") == "SAY")  then
			if (GetNumSubgroupMembers()>0) then
				self:SetAttribute("chatType", "PARTY");
				ChatEdit_UpdateHeader(self);
			elseif (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance()) then
				self:SetAttribute("chatType", "INSTANCE_CHAT");
				ChatEdit_UpdateHeader(self);
			elseif (GetNumGroupMembers()>0 and IsInRaid()) then
				self:SetAttribute("chatType", "RAID");
				ChatEdit_UpdateHeader(self);
			elseif (IsInGuild()) then
				self:SetAttribute("chatType", "GUILD");
				ChatEdit_UpdateHeader(self);
			elseif (CanEditOfficerNote() and E.db.WindTools["Tab Chat Mod"]["useofficer"]) then
				self:SetAttribute("chatType", "OFFICER");
				ChatEdit_UpdateHeader(self);
			else
				return;
			end
		elseif (self:GetAttribute("chatType") == "PARTY") then
			if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance())  then
				self:SetAttribute("chatType", "INSTANCE_CHAT");
				ChatEdit_UpdateHeader(self);
			elseif (GetNumGroupMembers()>0 and IsInRaid() ) then
				self:SetAttribute("chatType", "RAID");
				ChatEdit_UpdateHeader(self);
			elseif (IsInGuild()) then
				self:SetAttribute("chatType", "GUILD");
				ChatEdit_UpdateHeader(self);
			elseif (CanEditOfficerNote() and E.db.WindTools["Tab Chat Mod"]["useofficer"]) then
				self:SetAttribute("chatType", "OFFICER");
				ChatEdit_UpdateHeader(self);
			else
				self:SetAttribute("chatType", "SAY");
				ChatEdit_UpdateHeader(self);
			end
		elseif (self:GetAttribute("chatType") == "INSTANCE_CHAT") then
			if (IsInGuild()) then
				self:SetAttribute("chatType", "GUILD");
				ChatEdit_UpdateHeader(self);
			elseif (CanEditOfficerNote() and E.db.WindTools["Tab Chat Mod"]["useofficer"]) then
				self:SetAttribute("chatType", "OFFICER");
				ChatEdit_UpdateHeader(self);
			else
				self:SetAttribute("chatType", "SAY");
				ChatEdit_UpdateHeader(self);
			end
		elseif (self:GetAttribute("chatType") == "RAID") then
			if (IsInGuild) then
				self:SetAttribute("chatType", "GUILD");
				ChatEdit_UpdateHeader(self);
			elseif (CanEditOfficerNote() and E.db.WindTools["Tab Chat Mod"]["useofficer"]) then
				self:SetAttribute("chatType", "OFFICER");
				ChatEdit_UpdateHeader(self);
			else
				self:SetAttribute("chatType", "SAY");
				ChatEdit_UpdateHeader(self);
			end
		elseif (self:GetAttribute("chatType") == "GUILD") then
			if (CanEditOfficerNote() and E.db.WindTools["Tab Chat Mod"]["useofficer"]) then
				self:SetAttribute("chatType", "OFFICER");
				ChatEdit_UpdateHeader(self);
			else
				self:SetAttribute("chatType", "SAY");
				ChatEdit_UpdateHeader(self);
			end
		elseif (self:GetAttribute("chatType") == "OFFICER" and E.db.WindTools["Tab Chat Mod"]["useofficer"]) then
			self:SetAttribute("chatType", "SAY");
			ChatEdit_UpdateHeader(self);
		elseif (self:GetAttribute("chatType") == "WHISPER" and not E.db.WindTools["Tab Chat Mod"]["whispercycle"]) then
			self:SetAttribute("chatType", "SAY");
			ChatEdit_UpdateHeader(self);
		elseif (self:GetAttribute("chatType") == "CHANNEL") then
			if (GetNumSubgroupMembers()>0) then
				self:SetAttribute("chatType", "PARTY");
				ChatEdit_UpdateHeader(self);
			elseif (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance())  then
				self:SetAttribute("chatType", "INSTANCE_CHAT");
				ChatEdit_UpdateHeader(self);
			elseif (GetNumGroupMembers()>0 and IsInRaid() ) then
				self:SetAttribute("chatType", "RAID");
				ChatEdit_UpdateHeader(self);
			elseif (IsInGuild()) then
				self:SetAttribute("chatType", "GUILD");
				ChatEdit_UpdateHeader(self);
			elseif (CanEditOfficerNote() and E.db.WindTools["Tab Chat Mod"]["useofficer"]) then
				self:SetAttribute("chatType", "OFFICER");
				ChatEdit_UpdateHeader(self);
			else
				self:SetAttribute("chatType", "SAY");
				ChatEdit_UpdateHeader(self);
			end
		end
	end
end

local function InsertOptions()
	E.Options.args.WindTools.args["Chat"].args["Tab Chat Mod"].args["addwhisper"] = {
		order = 10,
		type = "group",
		name = L["Whisper Cycle"],
		args = {
			seteffect = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				get = function(info) return E.db.WindTools["Tab Chat Mod"]["whispercycle"] end,
				set = function(info, value) E.db.WindTools["Tab Chat Mod"]["whispercycle"] = value;end
			},
		}
	}
	E.Options.args.WindTools.args["Chat"].args["Tab Chat Mod"].args["addofficer"] = {
		order = 11,
		type = "group",
		name = L["Officer Channel"],
		args = {
			seteffect = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				get = function(info) return E.db.WindTools["Tab Chat Mod"]["useofficer"] end,
				set = function(info, value) E.db.WindTools["Tab Chat Mod"]["useofficer"] = value;end
			},
		}
	}
end

WT.ToolConfigs["Tab Chat Mod"] = InsertOptions
E:RegisterModule(TabChatMod:GetName())