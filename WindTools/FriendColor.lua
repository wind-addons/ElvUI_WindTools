-- 好友列表染色
-- 原作者：CN-阿曼尼
-- 修改：无

local _, ns = ...
local ycc = {}
ns.ycc = ycc

local GUILD_INDEX_MAX = 12
local SMOOTH = {
	1, 0, 0,
	1, 1, 0,
	0, 1, 0,
}
ycc.myName = UnitName'player'

local BC = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	BC[v] = k
end
for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
	BC[v] = k
end

local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS

local WHITE_HEX = '|cffffffff'

local function Hex(r, g, b)
	if(type(r) == 'table') then
		if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end
	
	if(not r or not g or not b) then
		r, g, b = 1, 1, 1
	end
	
	return format('|cff%02x%02x%02x', r*255, g*255, b*255)
end

-- http://www.wowwiki.com/ColorGradient
local function ColorGradient(perc, ...)
	if perc >= 1 then
		local r, g, b = select(select('#', ...) - 2, ...)
		return r, g, b
	elseif perc <= 0 then
		local r, g, b = ...
		return r, g, b
	end
	
	local num = select('#', ...) / 3

	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

--GuildControlGetNumRanks()
--GuildControlGetRankName(index)
ycc.guildRankColor = setmetatable({}, {
	__index = function(t, i)
		if i then
			local c = Hex(ColorGradient(i/GUILD_INDEX_MAX, unpack(SMOOTH)))
            if(c) then
                t[i] = c
                return c
            else
                t[i] = t[0]
            end
		end
	end
})
ycc.guildRankColor[0] = WHITE_HEX

ycc.diffColor = setmetatable({}, {
	__index = function(t,i)
		local c = i and GetQuestDifficultyColor(i)
        t[i] = c and Hex(c) or t[0]
        return t[i]
	end
})
ycc.diffColor[0] = WHITE_HEX

ycc.classColor = setmetatable({}, {
	__index = function(t,i)
		local c = i and RAID_CLASS_COLORS[BC[i] or i]
        if(c) then
            t[i] = Hex(c)
            return t[i]
        else
            return WHITE_HEX
        end
	end
})


local WHITE = {1,1,1}
ycc.classColorRaw = setmetatable({}, {
    __index = function(t, i)
        local c = i and RAID_CLASS_COLORS[BC[i] or i]
        if not c then return WHITE end
        t[i] = c
        return c
    end
})


if CUSTOM_CLASS_COLORS then
	CUSTOM_CLASS_COLORS:RegisterCallback(function()
        wipe(ycc.classColorRaw)
        wipe(ycc.classColor)
    end)
end

---好友列表着色
local _, ns = ...
local ycc = ns.ycc

local WHITE = {r = 1, g = 1, b = 1}
local FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub('%%d', '%%s')
FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub('%$d', '%$s') -- '%2$s %1$d-го уровня'
local function friendsFrame()
    local scrollFrame = FriendsFrameFriendsScrollFrame
    local offset = HybridScrollFrame_GetOffset(scrollFrame)
    local buttons = scrollFrame.buttons

    local playerArea = GetRealZoneText()

    for i = 1, #buttons do
        local nameText, infoText
        button = buttons[i]
        index = offset + i
        if(button:IsShown()) then
            if ( button.buttonType == FRIENDS_BUTTON_TYPE_WOW ) then
                local name, level, class, area, connected, status, note = GetFriendInfo(button.id)
                if(connected) then
                    nameText = ycc.classColor[class] .. name.."|r, "..format(FRIENDS_LEVEL_TEMPLATE, ycc.diffColor[level] .. level .. '|r', class)
                    if(areaName == playerArea) then
                        infoText = format('|cff00ff00%s|r', area)
                    end
                end
            elseif (button.buttonType == FRIENDS_BUTTON_TYPE_BNET) then
                local bnID, presenceName, battleTag, isBattleTagPresence, charName, gameID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(button.id)
                if(isOnline and client==BNET_CLIENT_WOW) then
                    local hasFocus, charName, client, realmName, realmID, faction, race, class, guild, zoneName, level, gameText, broadcastText, broadcastTime = BNGetGameAccountInfo(gameID)
                    if(presenceName and charName and class and faction == UnitFactionGroup("player")) then
                        nameText = presenceName .. ' ' .. FRIENDS_WOW_NAME_COLOR_CODE..'('..
                                    ycc.classColor[class] .. charName .. FRIENDS_WOW_NAME_COLOR_CODE .. ')'
                        if(zoneName == playerArea) then
                            infoText = format('|cff00ff00%s|r', zoneName)
                        end
                    end
                end
            end
        end

        if(nameText) then
            button.name:SetText(nameText)
        end
        if(infoText) then
            button.info:SetText(infoText)
        end
    end
end
hooksecurefunc(FriendsFrameFriendsScrollFrame, 'update', friendsFrame)
hooksecurefunc('FriendsFrame_UpdateFriends', friendsFrame)

--查询列表着色
local _, ns = ...
local ycc = ns.ycc

hooksecurefunc('WhoList_Update', function()
    local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame)

    local playerZone = GetRealZoneText()
    local playerGuild = GetGuildInfo'player'
    local playerRace = UnitRace'player'

    for i=1, WHOS_TO_DISPLAY, 1 do
        local index = whoOffset + i
        local nameText = getglobal('WhoFrameButton'..i..'Name')
        local levelText = getglobal('WhoFrameButton'..i..'Level')
        local classText = getglobal('WhoFrameButton'..i..'Class')
        local variableText = getglobal('WhoFrameButton'..i..'Variable')

        local name, guild, level, race, class, zone, classFileName = GetWhoInfo(index)
        if(name) then
            if zone == playerZone then
                zone = '|cff00ff00' .. zone
            end
            if guild == playerGuild then
                guild = '|cff00ff00' .. guild
            end
            if race == playerRace then
                race = '|cff00ff00' .. race
            end
            local columnTable = { zone, guild, race }

            local c = ycc.classColorRaw[classFileName]
            nameText:SetTextColor(c.r, c.g, c.b)
            levelText:SetText(ycc.diffColor[level] .. level)
            variableText:SetText(columnTable[UIDropDownMenu_GetSelectedID(WhoFrameDropDown)])
        end
    end
end)