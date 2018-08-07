-- 原作：Friend Color
-- 原作者：Awbee (http://www.wowinterface.com/downloads/info8679-FriendColor.html)
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 染色逻辑
-- 添加新的rgb函数

local E, L, V, P, G = unpack(ElvUI);
local FriendColor = E:NewModule('FriendColor', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

P["WindTools"]["Friend Color"] = {
    ["enabled"] = true
}

local function Hex(r, g, b)
    if(type(r) == 'table') then
        if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
    end
    if(not r or not g or not b) then
        r, g, b = 1, 1, 1
    end
    return format('|cff%02x%02x%02x', r*255, g*255, b*255)
end

local function Hook_FriendsList_Update()
	local friendOffset = HybridScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame);
	if not friendOffset then
		return;
	end
	if friendOffset < 0 then
		friendOffset = 0;
	end

	local numBNetTotal, numBNetOnline = BNGetNumFriends();
	if numBNetOnline > 0 then
		for i=1, numBNetOnline, 1 do
			local _, realName, _, _, toonName, toonID, client, _, _, _, _, _, _, _, _, _ = BNGetFriendInfo(i);
			if client == BNET_CLIENT_WOW then
				local _, _, _, realmName, _, _, _, class, _, zoneName, level, _, _, _, _, _ = BNGetGameAccountInfo(toonID);
				for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
				if GetLocale() ~= "enUS" then
					for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
				end
				local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
				if not classc then
					return;
				end
				local nameString = _G["FriendsFrameFriendsScrollFrameButton"..(i-friendOffset).."Name"];
				if nameString then
					nameString:SetText(realName.." ("..Hex(classc.r, classc.g, classc.b)..toonName.."|r, "..Hex(.945, .769, .059)..level.."|r)")
				end
				if CanCooperateWithGameAccount(toonID) ~= true then
					local nameString = _G["FriendsFrameFriendsScrollFrameButton"..(i-friendOffset).."Info"];
					if nameString then
						nameString:SetText(zoneName.." ("..realmName..")");
					end
				end
			end
		end
	end

	local numberOfFriends, onlineFriends = GetNumFriends();
	if onlineFriends > 0 then
		for i=1, onlineFriends, 1 do
			j = i + numBNetOnline;
			local name, level, class, area, connected, status, note, RAF = GetFriendInfo(i);
			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
			if GetLocale() ~= "enUS" then
				for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
			end
			local classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
			if not classc then
				return;
			end
			if connected then
				local nameString = _G["FriendsFrameFriendsScrollFrameButton"..(j-friendOffset).."Name"];
				if nameString and name then
					nameString:SetText(name..", L"..level);
					nameString:SetTextColor(classc.r, classc.g, classc.b);
				end
			end
		end
	end
end;

function FriendColor:Initialize()
    if not E.db.WindTools["Friend Color"]["enabled"] then return end
    hooksecurefunc("FriendsList_Update", Hook_FriendsList_Update)
    hooksecurefunc("HybridScrollFrame_Update", Hook_FriendsList_Update)
end

E:RegisterModule(FriendColor:GetName())