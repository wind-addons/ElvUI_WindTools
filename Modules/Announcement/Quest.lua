local W, F, E, L = unpack(select(2, ...))
local A = W:GetModule("Announcement")

local GetQuestLogTitle, GetNumQuestLeaderBoards = GetQuestLogTitle, GetNumQuestLeaderBoards
local lastList

local rgbStringing = {
	R = "|CFFFF0000",
	G = "|CFF00FF00",
	B = "|CFF0000FF",
	Y = "|CFFFFFF00",
	K = "|CFF00FFFF",
	D = "|C0000AAFF",
	P = "|CFFD74DE1"
}

local function ScanQuests()
    local questList = {}
    local index = 1
    local link

    while GetQuestLogTitle(index) do
        local title, level, suggestedGroup, isHeader, isCollapsed, isComplete,
        frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI,
        isTask, isStory = GetQuestLogTitle(index)

        local tag, tagName = GetQuestTagInfo(questID)
    
        if not isHeader then
            link = GetQuestLink(questID)
            questList[questID]={
                Title    =title,       -- String
                Level    =level,       -- Integer
                Tag      =tagName,         -- String
                Group    =suggestedGroup,       -- Integer
                Header   =isHeader,    -- boolean
                Collapsed=isCollapsed, -- boolean
                Complete =isComplete,  -- Integer
                Daily    = frequency,     -- Integer
                QuestID  = questID,          -- Integer
                Link     =link
            }
            for i=1,GetNumQuestLeaderBoards(index) do
				local leaderboardTxt, itemType, isDone = GetQuestLogLeaderBoard (i, index);
				local _, _, numItems, numNeeded, itemName = find(leaderboardTxt, "(%d+)/(%d+) ?(.*)")
                questList[questID][i]={
					NeedItem =itemName,             -- String
					NeedNum  = numNeeded,            -- Integer
					DoneNum  = numItems             -- Integer
				}
			end
        end
    
        index = index + 1

    
    end
    return questList

end

function A:Quest(text)
    local QN_Progress = QN_Locale["Progress"]
	local QN_ItemMsg,QN_ItemColorMsg = " "," "

	if not lastList then
		lastList = RScanQuests()
	end

	local currentList = ScanQuests()

	for questID, questDetails in pairs(currentList) do
		local tagString = " ";
		if currentList[questID].Tag and (currentList[questID].Group < 2) then tagString = rgbString.Y .. "["..currentList[questID].Tag.."]|r" end
		if currentList[questID].Tag and (currentList[questID].Group > 1) then tagString = rgbString.Y .. "["..currentList[questID].Tag..currentList[questID].Group.."]|r" end
		if currentList[questID].Daily == 1 and currentList[questID].Tag then
			tagString = rgbString.D .. "[" .. DAILY .. currentList[questID].Tag .. "]|r" ;
		elseif currentList[questID].Daily == 1 then
			tagString = rgbString.D .. "[" .. DAILY .. "]|r";
		elseif currentList[questID].Tag then
			tagString = "["..currentList[questID].Tag .. "]";
		end

		if lastList[questID] then  -- 已有任务，上次和本次Scan都有这一个任务
			if not lastList[questID].Complete then -- 未完成
				if (#currentList[questID] > 0) and (#lastList[questID] > 0) then
					for i=1,#currentList[questID] do
						if currentList[questID][i] and lastList[questID][i] and currentList[questID][i].DoneNum and lastList[questID][i].DoneNum then
							if currentList[questID][i].DoneNum > lastList[questID][i].DoneNum then
								QN_ItemMsg = QN_Progress ..":" .. currentList[i][j].NeedItem ..": ".. currentList[i][j].DoneNum .. "/"..currentList[i][j].NeedNum
								QN_ItemColorMsg = rgbString.G..QN_Locale["Quest"].."|r".. rgbString.P .. "["..currentList[i].Level.."]|r "..currentList[i].Link..rgbString.G..QN_Progress..":|r"..rgbString.K..currentList[i][j].NeedItem..":|r"..rgbString.Y..currentList[i][j].DoneNum .. "/"..currentList[i][j].NeedNum .."|r"
								if not self.db["NoDetail"] then
									PrtChatMsg(QN_ItemMsg)
								end
							end
						end
					end
				end
			end
			if (#currentList[i] > 0) and (#lastList[i] > 0) and (currentList[i].Complete == 1) then
				if not lastList[i].Complete then
					if (currentList[i].Group > 1) and currentList[i].Tag then
						QN_ItemMsg = QN_Locale["Quest"].."["..currentList[i].Level.."]".."["..currentList[i].Tag..currentList[i].Group.."]"..currentList[i].Link.." "..QN_Locale["Complete"]
					else
						QN_ItemMsg = QN_Locale["Quest"].."["..currentList[i].Level.."]"..currentList[i].Link.." "..QN_Locale["Complete"]
					end
					QN_ItemColorMsg = rgbString.G .. QN_Locale["Quest"] .. "|r" .. rgbString.P .. "[" .. currentList[i].Level .. "]|r " .. currentList[i].Link .. tagString .. rgbString.K .. QN_Locale["Complete"] .. "|r"
					PrtChatMsg(QN_ItemMsg)
					UIErrorsFrame:AddMessage(QN_ItemColorMsg);
				end
			end
		end

		if not lastList[i] and not isSuppliesQuest(currentList[i].Title) then  -- last List have not the Quest, New Quest Accepted
			if (currentList[i].Group > 1) and currentList[i].Tag then
				QN_ItemMsg = QN_Locale["Accept"]..":["..currentList[i].Level.."]".."["..currentList[i].Tag..currentList[i].Group.."]"..currentList[i].Link
			elseif currentList[i].Daily == 1 then
				QN_ItemMsg = QN_Locale["Accept"]..":["..currentList[i].Level.."]".."[" .. DAILY .. "]"..currentList[i].Link
			else
				QN_ItemMsg = QN_Locale["Accept"]..":["..currentList[i].Level.."]"..currentList[i].Link
			end
			QN_ItemColorMsg = rgbString.K .. QN_Locale["Accept"]..":|r" .. rgbString.P .."["..currentList[i].Level.."]|r "..tagString..currentList[i].Link
			PrtChatMsg(QN_ItemMsg)
		end
	end

	lastList = currentList
end