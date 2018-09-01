-- 原作：EUI 的一个增强组件
-- 原作者：Gentoo/Asem/聂荣/才人/大爱无疆/Suse/我真的是上帝/siweia/eui.cc
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
-- 删减设定项
-- 个人不用 说 通报，而是发送到聊天框

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local QuestAnnouncment = E:NewModule('QuestAnnouncment', 'AceHook-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

local GetQuestLogTitle = GetQuestLogTitle
local GetQuestLink = GetQuestLink
local IsQuestWatched = IsQuestWatched
local RemoveQuestWatch = RemoveQuestWatch
local GetNumQuestLeaderBoards = GetNumQuestLeaderBoards
local GetQuestLogLeaderBoard = GetQuestLogLeaderBoard
local SendChatMessage = SendChatMessage
local IsInGroup, IsInRaid, LE_PARTY_CATEGORY_HOME, LE_PARTY_CATEGORY_INSTANCE, UnitInParty, UnitInRaid = IsInGroup, IsInRaid, LE_PARTY_CATEGORY_HOME, LE_PARTY_CATEGORY_INSTANCE, UnitInParty, UnitInRaid
local find, pairs = string.find, pairs

local QN_Locale   = {
	["Colon"]       = ":",
	["Quest"]       = "Quest",
	["Progress"]    = "Progress",
	["Complete"]    = "Completed!", 
	["Accept"]      = "Accept Quest",
}
if GetLocale() == 'zhCN' then
	QN_Locale = {
		["Colon"]       = "：",
		["Quest"]       = "任务",
		["Progress"]    = "进度",
		["Complete"]    = "已完成!",
		["Accept"]      = "接受任务",
	}
elseif GetLocale() == 'zhTW' then
	QN_Locale = {
		["Colon"]       = ":",
		["Quest"]       = "任務",
		["Progress"]    = "進度",
		["Complete"]    = "已完成!",
		["Accept"]      = "接受任務",
	}
end

local QHisFirst = true
local lastList
local RGBStr = {
	R = "|CFFFF0000",
	G = "|CFF00FF00",
	B = "|CFF0000FF",
	Y = "|CFFFFFF00",
	K = "|CFF00FFFF",
	D = "|C0000AAFF",
	P = "|CFFD74DE1"
}

local function RScanQuests()
	local QuestList = {}
	local qIndex = 1
	local qLink
	local splitdot = QN_Locale["Colon"]           -- zh_CN 为全角" ：" ,en_US 为半角的 ":" ,zh_TW 请自行试验
	while GetQuestLogTitle(qIndex) do
		local qTitle, qLevel, qGroup, qisHeader, qisCollapsed, qisComplete, frequency, qID = GetQuestLogTitle(qIndex)
		local qTag, qTagName = GetQuestTagInfo(qID)
		if not qisHeader then
			qLink = GetQuestLink(qID)
				QuestList[qID]={
				Title    =qTitle,       -- String
				Level    =qLevel,       -- Integer
				Tag      =qTagName,         -- String
				Group    =qGroup,       -- Integer
				Header   =qisHeader,    -- boolean
				Collapsed=qisCollapsed, -- boolean
				Complete =qisComplete,  -- Integer
				Daily    =0, --frequency,     -- Integer
				QuestID  =qID,          -- Integer
				Link     =qLink
			}
			if qisComplete == 1 and ( IsQuestWatched(qIndex) ) then
				RemoveQuestWatch(qIndex)
			--	WatchFrame_Update()
				ObjectiveTracker_Update()
			end
			for i=1,GetNumQuestLeaderBoards(qIndex) do
				local leaderboardTxt, itemType, isDone = GetQuestLogLeaderBoard (i,qIndex);
			--	local j, k, itemName, numItems, numNeeded = string.find(leaderboardTxt, "(.*)"..splitdot.."%s*([%d]+)%s*/%s*([%d]+)");
				local _, _, numItems, numNeeded, itemName = find(leaderboardTxt, "(%d+)/(%d+) ?(.*)")
			--	local numstr, itemName = strsplit(" ", leaderboardTxt)
			--	local numItems, numNeeded = strsplit("/", numstr)
				-- print(qID,qTitle,qLevel,qTag,qGroup,qisHeader,qisCollapsed,qisComplete,qisDaily,leaderboardTxt,itemType,isDone,j,k,itemName,numItems,numNeeded)
				QuestList[qID][i]={
					NeedItem =itemName,             -- String
					NeedNum  = numNeeded,            -- Integer
					DoneNum  = numItems             -- Integer
				}
			end
		end

		qIndex = qIndex + 1
	end
	return QuestList
end

local function PrtChatMsg(msg)
	if (not IsInGroup(LE_PARTY_CATEGORY_HOME) or IsInRaid(LE_PARTY_CATEGORY_HOME)) and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		if E.db.WindTools["Quest"]["Quest Announcment"]["Instance"] then
			SendChatMessage(msg, "instance_chat", nil)
		end
	elseif UnitInRaid("player") then
		if E.db.WindTools["Quest"]["Quest Announcment"]["Raid"] then
			SendChatMessage(msg, "raid", nil)
		end
	elseif UnitInParty("Party1") then
		if E.db.WindTools["Quest"]["Quest Announcment"]["Party"] then
			SendChatMessage(msg, "party", nil)
		end
	else
		if E.db.WindTools["Quest"]["Quest Announcment"]["Solo"] then
			ChatFrame1:AddMessage(msg)
		end
	end
end

function QuestAnnouncment:Initialize()
	if not E.db.WindTools["Quest"]["Quest Announcment"]["enabled"] then return end
	local QN = CreateFrame("Frame")
	QN:RegisterEvent("QUEST_LOG_UPDATE")
	QN:SetScript("OnEvent", function(self, event)
		local QN_Progress = QN_Locale["Progress"]
		local QN_ItemMsg,QN_ItemColorMsg = " "," "

		if QHisFirst then
			lastList = RScanQuests()
			QHisFirst = false
		end

		local currList = RScanQuests()

		for i,v in pairs(currList) do
			local TagStr = " ";
			if currList[i].Tag and (currList[i].Group < 2) then TagStr = RGBStr.Y .. "["..currList[i].Tag.."]|r" end
			if currList[i].Tag and (currList[i].Group > 1) then TagStr = RGBStr.Y .. "["..currList[i].Tag..currList[i].Group.."]|r" end
			if currList[i].Daily == 1 and currList[i].Tag then
				TagStr = RGBStr.D .. "[" .. DAILY .. currList[i].Tag .. "]|r" ;
			elseif currList[i].Daily == 1 then
				TagStr = RGBStr.D .. "[" .. DAILY .. "]|r";
			elseif currList[i].Tag then
				TagStr = "["..currList[i].Tag .. "]";
			end

			if lastList[i] then  -- 已有任务，上次和本次Scan都有这一个任务
				if not lastList[i].Complete then
					if (#currList[i] > 0) and (#lastList[i] > 0) then
						for j=1,#currList[i] do
							if currList[i][j] and lastList[i][j] and currList[i][j].DoneNum and lastList[i][j].DoneNum then
								if currList[i][j].DoneNum > lastList[i][j].DoneNum then
									--QN_ItemMsg = QN_Locale["Quest"]..currList[i].Link..QN_Progress ..": ".. currList[i][j].NeedItem ..":".. currList[i][j].DoneNum .. "/"..currList[i][j].NeedNum
									QN_ItemMsg = QN_Progress ..":" .. currList[i][j].NeedItem ..": ".. currList[i][j].DoneNum .. "/"..currList[i][j].NeedNum
									QN_ItemColorMsg = RGBStr.G..QN_Locale["Quest"].."|r".. RGBStr.P .. "["..currList[i].Level.."]|r "..currList[i].Link..RGBStr.G..QN_Progress..":|r"..RGBStr.K..currList[i][j].NeedItem..":|r"..RGBStr.Y..currList[i][j].DoneNum .. "/"..currList[i][j].NeedNum .."|r"
									if not E.db.WindTools["Quest"]["Quest Announcment"]["NoDetail"] then
										PrtChatMsg(QN_ItemMsg)
									end
								end
							end
						end
					end
				end
				if (#currList[i] > 0) and (#lastList[i] > 0) and (currList[i].Complete == 1) then
					if not lastList[i].Complete then
						if (currList[i].Group > 1) and currList[i].Tag then
							QN_ItemMsg = QN_Locale["Quest"].."["..currList[i].Level.."]".."["..currList[i].Tag..currList[i].Group.."]"..currList[i].Link.." "..QN_Locale["Complete"]
						else
							QN_ItemMsg = QN_Locale["Quest"].."["..currList[i].Level.."]"..currList[i].Link.." "..QN_Locale["Complete"]
						end
						QN_ItemColorMsg = RGBStr.G .. QN_Locale["Quest"] .. "|r" .. RGBStr.P .. "[" .. currList[i].Level .. "]|r " .. currList[i].Link .. TagStr .. RGBStr.K .. QN_Locale["Complete"] .. "|r"
						PrtChatMsg(QN_ItemMsg)
						UIErrorsFrame:AddMessage(QN_ItemColorMsg);
					end
				end
			end

			if not lastList[i] then  -- last List have not the Quest, New Quest Accepted
				if (currList[i].Group > 1) and currList[i].Tag then
					QN_ItemMsg = QN_Locale["Accept"]..":["..currList[i].Level.."]".."["..currList[i].Tag..currList[i].Group.."]"..currList[i].Link
				elseif currList[i].Daily == 1 then
					QN_ItemMsg = QN_Locale["Accept"]..":["..currList[i].Level.."]".."[" .. DAILY .. "]"..currList[i].Link
				else
					QN_ItemMsg = QN_Locale["Accept"]..":["..currList[i].Level.."]"..currList[i].Link
				end
				QN_ItemColorMsg = RGBStr.K .. QN_Locale["Accept"]..":|r" .. RGBStr.P .."["..currList[i].Level.."]|r "..TagStr..currList[i].Link
				PrtChatMsg(QN_ItemMsg)
			end
		end

		lastList = currList
	end)
end

E:RegisterModule(QuestAnnouncment:GetName())