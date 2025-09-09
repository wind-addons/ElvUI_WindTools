local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local CB = W:NewModule("ChatBar", "AceHook-3.0", "AceEvent-3.0")
local S = W.Modules.Skins ---@type Skins
local LSM = E.Libs.LSM

local _G = _G
local format = format
local ipairs = ipairs
local pairs = pairs
local sort = sort
local strmatch = strmatch
local tinsert = tinsert
local tostring = tostring

local C_Club_GetClubInfo = C_Club.GetClubInfo
local C_GuildInfo_IsGuildOfficer = C_GuildInfo.IsGuildOfficer
local ChatFrame_AddChannel = ChatFrame_AddChannel
local ChatFrame_OpenChat = ChatFrame_OpenChat
local CreateFrame = CreateFrame
local DefaultChatFrame = _G.DEFAULT_CHAT_FRAME
local GetChannelList = GetChannelList
local GetChannelName = GetChannelName
local InCombatLockdown = InCombatLockdown
local IsEveryoneAssistant = IsEveryoneAssistant
local IsInGroup = IsInGroup
local IsInGuild = IsInGuild
local IsInRaid = IsInRaid
local JoinPermanentChannel = JoinPermanentChannel
local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
local LeaveChannelByName = LeaveChannelByName
local RandomRoll = RandomRoll
local UnitIsGroupAssistant = UnitIsGroupAssistant
local UnitIsGroupLeader = UnitIsGroupLeader

local normalChannelsIndex = { "SAY", "YELL", "PARTY", "INSTANCE", "RAID", "RAID_WARNING", "GUILD", "OFFICER", "EMOTE" }

local checkFunctions = {
	PARTY = function()
		return IsInGroup(LE_PARTY_CATEGORY_HOME)
	end,
	INSTANCE = function()
		return IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
	end,
	RAID = function()
		return IsInRaid()
	end,
	RAID_WARNING = function()
		return IsInRaid() and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player") or IsEveryoneAssistant())
	end,
	GUILD = function()
		return IsInGuild()
	end,
	OFFICER = function()
		return IsInGuild() and C_GuildInfo_IsGuildOfficer()
	end,
}

local function GetCommunityChannelByName(text)
	local channelList = { GetChannelList() }
	for k, v in pairs(channelList) do
		local clubId = strmatch(tostring(v), "Community:(.-):")
		if clubId then
			local info = C_Club_GetClubInfo(clubId)
			if info.name == text then
				return GetChannelName(tostring(v))
			end
		end
	end
end

local function GetBestWorldChannelConfig(configTable)
	local validConfigs = {}

	for _, c in pairs(configTable) do
		if
			(c.region == "ALL" or c.region == W.RealRegion)
			and (c.faction == "ALL" or c.faction == E.myfaction)
			and (c.realmID == "ALL" or c.realmID == W.CurrentRealmID)
		then
			tinsert(validConfigs, c)
		end
	end

	sort(validConfigs, function(a, b)
		if a.region ~= "ALL" and b.region == "ALL" then
			return true
		end

		if a.region == "ALL" and b.region ~= "ALL" then
			return false
		end

		if a.faciton ~= "ALL" and b.faction == "ALL" then
			return true
		end

		if a.faciton == "ALL" and b.faction ~= "ALL" then
			return false
		end

		if a.realmID == "ALL" and b.realmID ~= "ALL" then
			return true
		end

		return false
	end)

	return validConfigs[1]
end

function CB:OnEnterBar()
	if self.db.mouseOver then
		E:UIFrameFadeIn(self.bar, 0.2, self.bar:GetAlpha(), 1)
	end
end

function CB:OnLeaveBar()
	if self.db.mouseOver then
		E:UIFrameFadeOut(self.bar, 0.2, self.bar:GetAlpha(), 0)
	end
end

function CB:UpdateButton(name, func, anchorPoint, x, y, color, tex, tooltip, tips, abbr)
	local ElvUIValueColor = E.db.general.valuecolor

	if not self.bar[name] then
		-- Button
		local button = CreateFrame("Button", nil, self.bar, "SecureActionButtonTemplate, BackdropTemplate")
		button:StripTextures()
		button:SetBackdropBorderColor(0, 0, 0)
		button:RegisterForClicks("AnyDown")
		button:SetScript("OnMouseUp", func)

		button.colorBlock = button:CreateTexture(nil, "ARTWORK")
		button.colorBlock:SetAllPoints()
		button:CreateBackdrop("Transparent")
		S:CreateShadow(button.backdrop, 3, nil, nil, nil, true)

		button.text = button:CreateFontString(nil, "OVERLAY")
		button.text:SetPoint("CENTER", button, "CENTER", 0, 0)
		F.SetFontWithDB(button.text, self.db.font)
		button.defaultFontSize = self.db.font.size

		-- Tooltip
		button:SetScript("OnEnter", function(btn)
			if CB.db.style == "BLOCK" then
				if btn.backdrop.shadow then
					btn.backdrop.shadow:SetBackdropBorderColor(ElvUIValueColor.r, ElvUIValueColor.g, ElvUIValueColor.b)
					btn.backdrop.shadow:Show()
				end
			else
				local fontName, _, fontFlags = btn.text:GetFont()
				btn.text:FontTemplate(fontName, btn.defaultFontSize + 4, fontFlags)
			end

			_G.GameTooltip:SetOwner(btn, "ANCHOR_TOP", 0, 7)
			_G.GameTooltip:SetText(button.tooltip or _G[name] or "")

			if tips then
				for _, tip in ipairs(button.tips) do
					_G.GameTooltip:AddLine(tip)
				end
			end

			_G.GameTooltip:Show()
		end)

		button:SetScript("OnLeave", function(btn)
			_G.GameTooltip:Hide()
			if CB.db.style == "BLOCK" then
				btn.backdrop.shadow:SetBackdropBorderColor(0, 0, 0)

				if not CB.db.blockShadow then
					if btn.backdrop.shadow then
						btn.backdrop.shadow:Hide()
					end
				end
			else
				local fontName, _, fontFlags = btn.text:GetFont()
				btn.text:FontTemplate(fontName, btn.defaultFontSize, fontFlags)
			end
		end)

		self:HookScript(button, "OnEnter", "OnEnterBar")
		self:HookScript(button, "OnLeave", "OnLeaveBar")

		self.bar[name] = button
	end

	self.bar[name].tooltip = tooltip
	self.bar[name].tips = tips

	-- Block style
	if self.db.style == "BLOCK" then
		self.bar[name].colorBlock:SetTexture(tex and LSM:Fetch("statusbar", tex) or E.media.normTex)

		if color then
			self.bar[name].colorBlock:SetVertexColor(color.r, color.g, color.b, color.a)
		end

		self.bar[name].colorBlock:Show()
		self.bar[name].backdrop:Show()
		if self.bar[name].backdrop.shadow then
			if self.db.blockShadow then
				self.bar[name].backdrop.shadow:Show()
			else
				self.bar[name].backdrop.shadow:Hide()
			end
		end

		self.bar[name].text:Hide()
	else
		local buttonText = self.db.color and F.CreateColorString(abbr, color) or abbr
		self.bar[name].text:SetText(buttonText)
		self.bar[name].defaultFontSize = self.db.font.size
		F.SetFontWithDB(self.bar[name].text, self.db.font)
		self.bar[name].text:Show()

		self.bar[name].colorBlock:Hide()
		self.bar[name].backdrop:Hide()
	end

	-- Update size and position
	self.bar[name]:SetSize(CB.db.buttonWidth, CB.db.buttonHeight)
	self.bar[name]:ClearAllPoints()
	self.bar[name]:SetPoint(anchorPoint, CB.bar, anchorPoint, x, y)

	self.bar[name]:Show()
	return self.bar[name]
end

function CB:DisableButton(name)
	if self.bar[name] then
		self.bar[name]:Hide()
	end
end

function CB:UpdateBar()
	if not self.bar then
		return
	end

	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	local numberOfButtons = 0 -- 记录按钮个数来方便更新条的大小
	local width, height

	local anchor = self.db.orientation == "HORIZONTAL" and "LEFT" or "TOP"
	local offsetX = 0
	local offsetY = 0

	if self.db.backdrop then
		if anchor == "LEFT" then
			offsetX = offsetX + self.db.backdropSpacing
		else
			offsetY = offsetY - self.db.backdropSpacing
		end
	end

	for _, name in ipairs(normalChannelsIndex) do
		local db = self.db.channels[name]
		local show = db and db.enable

		if show and self.db.autoHide then
			if checkFunctions[name] then
				show = checkFunctions[name]() and true or false
			end
		end

		if show then
			local chatFunc = function(btn, mouseButton)
				if mouseButton ~= "LeftButton" or not db.cmd then
					return
				end
				local currentText = DefaultChatFrame.editBox:GetText()
				local command = format("/%s ", db.cmd)
				ChatFrame_OpenChat(command .. currentText, DefaultChatFrame)
			end

			self:UpdateButton(name, chatFunc, anchor, offsetX, offsetY, db.color, self.db.tex, nil, nil, db.abbr)
			numberOfButtons = numberOfButtons + 1

			if anchor == "LEFT" then
				offsetX = offsetX + (self.db.buttonWidth + self.db.spacing)
			else
				offsetY = offsetY - (self.db.buttonHeight + self.db.spacing)
			end
		else
			self:DisableButton(name)
		end
	end

	if self.db.channels.world.enable then
		local db = self.db.channels.world
		local config = GetBestWorldChannelConfig(db.config)

		if not config or not config.name or config.name == "" then
			self:Log("warning", L["World channel no found, please setup again."])
			self:DisableButton("WORLD")
		else
			local chatFunc = function(btn, mouseButton)
				local channelId = GetChannelName(config.name)
				if mouseButton == "LeftButton" then
					local autoJoined = false
					if channelId == 0 and config.autoJoin then
						JoinPermanentChannel(config.name)
						ChatFrame_AddChannel(DefaultChatFrame, config.name)
						channelId = GetChannelName(config.name)
						autoJoined = true
					end
					if channelId == 0 then
						return
					end
					local currentText = DefaultChatFrame.editBox:GetText()
					local command = format("/%s ", channelId)
					if autoJoined then
						-- 刚切过去要稍微过一会才能让聊天框反映为频道
						E:Delay(0.5, function()
							ChatFrame_OpenChat(command .. currentText, DefaultChatFrame)
						end)
					else
						ChatFrame_OpenChat(command .. currentText, DefaultChatFrame)
					end
				elseif mouseButton == "RightButton" then
					if channelId == 0 then
						JoinPermanentChannel(config.name)
						ChatFrame_AddChannel(DefaultChatFrame, config.name)
					else
						LeaveChannelByName(config.name)
					end
				end
			end

			self:UpdateButton("WORLD", chatFunc, anchor, offsetX, offsetY, db.color, self.db.tex, config.name, {
				L["Left Click: Change to"] .. " " .. config.name,
				L["Right Click: Join/Leave"] .. " " .. config.name,
			}, db.abbr)

			numberOfButtons = numberOfButtons + 1

			-- 调整锚点到下一个按钮的位置上
			if anchor == "LEFT" then
				offsetX = offsetX + (self.db.buttonWidth + self.db.spacing)
			else
				offsetY = offsetY - (self.db.buttonHeight + self.db.spacing)
			end
		end
	else
		self:DisableButton("WORLD")
	end

	-- 建立社群频道条
	if self.db.channels.community.enable then
		local db = self.db.channels.community
		local name = db.name
		if not name or name == "" then
			self:Log("warning", L["Club channel no found, please setup again."])
			self:DisableButton("CLUB")
		else
			local chatFunc = function(_, mouseButton)
				if mouseButton ~= "LeftButton" then
					return
				end
				local clubChannelId = GetCommunityChannelByName(name)
				if not clubChannelId then
					self:Log(
						"warning",
						format(L["Club channel %s no found, please use the full name of the channel."], name)
					)
				else
					local currentText = DefaultChatFrame.editBox:GetText()
					local command = format("/%s ", clubChannelId)
					ChatFrame_OpenChat(command .. currentText, DefaultChatFrame)
				end
			end

			self:UpdateButton("CLUB", chatFunc, anchor, offsetX, offsetY, db.color, self.db.tex, name, nil, db.abbr)

			numberOfButtons = numberOfButtons + 1

			-- 调整锚点到下一个按钮的位置上
			if anchor == "LEFT" then
				offsetX = offsetX + (self.db.buttonWidth + self.db.spacing)
			else
				offsetY = offsetY - (self.db.buttonHeight + self.db.spacing)
			end
		end
	else
		self:DisableButton("CLUB")
	end

	-- 建立表情按键
	if self.db.channels.emote.enable and E.db.WT.social.emote.enable then
		local db = self.db.channels.emote

		local chatFunc = function(btn, mouseButton)
			if mouseButton == "LeftButton" then
				if _G.WTCustomEmoteFrame then
					if _G.WTCustomEmoteFrame:IsShown() then
						_G.WTCustomEmoteFrame:Hide()
					else
						_G.WTCustomEmoteFrame:Show()
					end
				else
					CB:Log("warning", L["Please enable Emote module in WindTools Social category."])
				end
			end
		end

		local abbr = db.icon
				and ("|TInterface\\AddOns\\ElvUI_WindTools\\Media\\Emotes\\mario:" .. self.db.font.size .. "|t")
			or db.abbr
		self:UpdateButton(
			"WindEmote",
			chatFunc,
			anchor,
			offsetX,
			offsetY,
			db.color,
			self.db.tex,
			"Wind " .. L["Emote"],
			{ L["Left Click: Toggle"] },
			abbr
		)

		numberOfButtons = numberOfButtons + 1

		-- 调整锚点到下一个按钮的位置上
		if anchor == "LEFT" then
			offsetX = offsetX + (self.db.buttonWidth + self.db.spacing)
		else
			offsetY = offsetY - (self.db.buttonHeight + self.db.spacing)
		end
	else
		self:DisableButton("WindEmote")
	end

	-- 建立Roll点键
	if self.db.channels.roll.enable then
		local db = self.db.channels.roll

		local chatFunc = function(btn, mouseButton)
			if mouseButton == "LeftButton" then
				RandomRoll(1, 100)
			end
		end

		local abbr = (db.icon and "|TInterface\\Buttons\\UI-GroupLoot-Dice-Up:" .. self.db.font.size .. "|t") or db.abbr

		self:UpdateButton("ROLL", chatFunc, anchor, offsetX, offsetY, db.color, self.db.tex, nil, nil, abbr)

		numberOfButtons = numberOfButtons + 1

		-- 调整锚点到下一个按钮的位置上
		if anchor == "LEFT" then
			offsetX = offsetX + (self.db.buttonWidth + self.db.spacing)
		else
			offsetY = offsetY - (self.db.buttonHeight + self.db.spacing)
		end
	else
		self:DisableButton("ROLL")
	end

	-- 计算条大小
	if self.db.backdrop then
		if self.db.orientation == "HORIZONTAL" then
			width = self.db.backdropSpacing * 2
				+ self.db.buttonWidth * numberOfButtons
				+ self.db.spacing * (numberOfButtons - 1)
			height = self.db.backdropSpacing * 2 + self.db.buttonHeight
		else
			width = self.db.backdropSpacing * 2 + self.db.buttonWidth
			height = self.db.backdropSpacing * 2
				+ self.db.buttonHeight * numberOfButtons
				+ self.db.spacing * (numberOfButtons - 1)
		end
	else
		if self.db.orientation == "HORIZONTAL" then
			width = self.db.buttonWidth * numberOfButtons + self.db.spacing * (numberOfButtons - 1)
			height = self.db.buttonHeight
		else
			width = self.db.buttonWidth
			height = self.db.buttonHeight * numberOfButtons + self.db.spacing * (numberOfButtons - 1)
		end
	end

	if self.db.mouseOver then
		self.bar:SetAlpha(0)
		if not self.db.backdrop then
			-- 为鼠标显隐模式稍微增加一点可点击区域
			height = height + 6
		end
	else
		self.bar:SetAlpha(1)
	end

	self.bar:SetSize(width, height)

	if self.db.backdrop then
		self.bar.backdrop:Show()
		if E.private.WT.skins.shadow and self.bar.shadow then
			self.bar.shadow:Show()
		end
	else
		self.bar.backdrop:Hide()
		if E.private.WT.skins.shadow and self.bar.shadow then
			self.bar.shadow:Hide()
		end
	end
end

function CB:CreateBar()
	if self.bar then
		return
	end

	local bar = CreateFrame("Frame", "WTChatBar", E.UIParent, "SecureHandlerStateTemplate")

	bar:SetResizable(false)
	bar:SetClampedToScreen(true)
	bar:SetFrameStrata("LOW")
	bar:SetFrameLevel(5) -- 高于 ElvUI 经验条
	bar:CreateBackdrop("Transparent")
	bar:ClearAllPoints()
	bar:SetPoint("BOTTOMLEFT", _G.LeftChatPanel, "TOPLEFT", 6, 3)
	S:CreateBackdropShadow(bar)

	self.bar = bar

	self:HookScript(self.bar, "OnEnter", "OnEnterBar")
	self:HookScript(self.bar, "OnLeave", "OnLeaveBar")
end

function CB:PLAYER_REGEN_ENABLED()
	self:UpdateBar()
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

function CB:Initialize()
	self.db = E.db.WT.social.chatBar
	if not self.db.enable then
		return
	end

	CB:CreateBar()
	CB:UpdateBar()

	E:CreateMover(CB.bar, "WTChatBarMover", L["Chat Bar"], nil, nil, nil, "ALL,WINDTOOLS", function()
		return CB.db.enable
	end, "WindTools,social,chatBar")

	if self.db.autoHide then
		self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateBar")
		self:RegisterEvent("PLAYER_GUILD_UPDATE", "UpdateBar")
	end
end

function CB:ProfileUpdate()
	self.db = E.db.WT.social.chatBar

	if not self.db.enable then
		if self.bar then
			self.bar:Hide()
		end
		return
	end

	if self.db.enable and not self.bar then
		self:Initialize()
	end

	self.bar:Show()

	if self.db.autoHide then
		self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateBar")
		self:RegisterEvent("PLAYER_GUILD_UPDATE", "UpdateBar")
	else
		self:UnregisterEvent("GROUP_ROSTER_UPDATE")
		self:UnregisterEvent("PLAYER_GUILD_UPDATE")
	end
end

W:RegisterModule(CB:GetName())
