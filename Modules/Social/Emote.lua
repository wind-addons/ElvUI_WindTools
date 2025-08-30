local W, F, E, L, _, _, G = unpack((select(2, ...)))
local CE = W:NewModule("Emote", "AceHook-3.0", "AceTimer-3.0")
local S = W.Modules.Skins ---@type Skins

local _G = _G
local ceil = ceil
local floor = floor
local gsub = gsub
local ipairs = ipairs
local pairs = pairs
local strsub = strsub

local ChatEdit_ActivateChat = ChatEdit_ActivateChat
local ChatEdit_ChooseBoxForSend = ChatEdit_ChooseBoxForSend
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter
local CreateFrame = CreateFrame

local C_ChatBubbles_GetAllChatBubbles = C_ChatBubbles.GetAllChatBubbles

local emotes = {
	{ key = "angel", zhTW = "天使", zhCN = "天使" },
	{ key = "angry", zhTW = "生氣", zhCN = "生气" },
	{ key = "biglaugh", zhTW = "大笑", zhCN = "大笑" },
	{ key = "clap", zhTW = "鼓掌", zhCN = "鼓掌" },
	{ key = "cool", zhTW = "酷", zhCN = "酷" },
	{ key = "cry", zhTW = "哭", zhCN = "哭" },
	{ key = "cutie", zhTW = "可愛", zhCN = "可爱" },
	{ key = "despise", zhTW = "鄙視", zhCN = "鄙视" },
	{ key = "dreamsmile", zhTW = "美夢", zhCN = "美梦" },
	{ key = "embarrass", zhTW = "尷尬", zhCN = "尴尬" },
	{ key = "evil", zhTW = "邪惡", zhCN = "邪恶" },
	{ key = "excited", zhTW = "興奮", zhCN = "兴奋" },
	{ key = "faint", zhTW = "暈", zhCN = "晕" },
	{ key = "fight", zhTW = "打架", zhCN = "打架" },
	{ key = "flu", zhTW = "流感", zhCN = "流感" },
	{ key = "freeze", zhTW = "呆", zhCN = "呆" },
	{ key = "frown", zhTW = "皺眉", zhCN = "皱眉" },
	{ key = "greet", zhTW = "致敬", zhCN = "致敬" },
	{ key = "grimace", zhTW = "鬼臉", zhCN = "鬼脸" },
	{ key = "growl", zhTW = "齜牙", zhCN = "龇牙" },
	{ key = "happy", zhTW = "開心", zhCN = "开心" },
	{ key = "heart", zhTW = "心", zhCN = "心" },
	{ key = "horror", zhTW = "恐懼", zhCN = "恐惧" },
	{ key = "ill", zhTW = "生病", zhCN = "生病" },
	{ key = "innocent", zhTW = "無辜", zhCN = "无辜" },
	{ key = "kongfu", zhTW = "功夫", zhCN = "功夫" },
	{ key = "love", zhTW = "花痴", zhCN = "花痴" },
	{ key = "mail", zhTW = "郵件", zhCN = "邮件" },
	{ key = "makeup", zhTW = "化妝", zhCN = "化妆" },
	{ key = "mario", zhTW = "馬里奧", zhCN = "马里奥" },
	{ key = "meditate", zhTW = "沉思", zhCN = "沉思" },
	{ key = "miserable", zhTW = "可憐", zhCN = "可怜" },
	{ key = "okay", zhTW = "好", zhCN = "好" },
	{ key = "pretty", zhTW = "漂亮", zhCN = "漂亮" },
	{ key = "puke", zhTW = "吐", zhCN = "吐" },
	{ key = "shake", zhTW = "握手", zhCN = "握手" },
	{ key = "shout", zhTW = "喊", zhCN = "喊" },
	{ key = "shuuuu", zhTW = "閉嘴", zhCN = "闭嘴" },
	{ key = "shy", zhTW = "害羞", zhCN = "害羞" },
	{ key = "sleep", zhTW = "睡覺", zhCN = "睡觉" },
	{ key = "smile", zhTW = "微笑", zhCN = "微笑" },
	{ key = "suprise", zhTW = "吃驚", zhCN = "吃惊" },
	{ key = "surrender", zhTW = "失敗", zhCN = "失败" },
	{ key = "sweat", zhTW = "流汗", zhCN = "流汗" },
	{ key = "tear", zhTW = "流淚", zhCN = "流泪" },
	{ key = "tears", zhTW = "悲劇", zhCN = "悲剧" },
	{ key = "think", zhTW = "想", zhCN = "想" },
	{ key = "titter", zhTW = "偷笑", zhCN = "偷笑" },
	{ key = "ugly", zhTW = "猥瑣", zhCN = "猥琐" },
	{ key = "victory", zhTW = "勝利", zhCN = "胜利" },
	{ key = "volunteer", zhTW = "雷鋒", zhCN = "雷锋" },
	{ key = "wronged", zhTW = "委屈", zhCN = "委屈" },
	-- 指定了texture一般用於BLIZ自帶的素材
	{ key = "wrong", zhTW = "錯", zhCN = "错", texture = "Interface\\RaidFrame\\ReadyCheck-NotReady" },
	{ key = "right", zhTW = "對", zhCN = "对", texture = "Interface\\RaidFrame\\ReadyCheck-Ready" },
	{ key = "question", zhTW = "疑問", zhCN = "疑问", texture = "Interface\\RaidFrame\\ReadyCheck-Waiting" },
	{ key = "skull", zhTW = "骷髏", zhCN = "骷髅", texture = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull" },
	{ key = "sheep", zhTW = "羊", zhCN = "羊", texture = "Interface\\TargetingFrame\\UI-TargetingFrame-Sheep" },
}

local function EmoteButton_OnClick(self, button)
	local editBox = ChatEdit_ChooseBoxForSend()
	ChatEdit_ActivateChat(editBox)
	editBox:SetText(gsub(editBox:GetText(), "{$", "") .. self.emote)
	if button == "LeftButton" then
		self:GetParent():Hide()
	end
end

local function EmoteButton_OnEnter(self)
	self:GetParent().title:SetText(self.emote)
end

local function EmoteButton_OnLeave(self)
	self:GetParent().title:SetText("")
end

local function ReplaceEmote(value)
	local emote = gsub(value, "[%{%}]", "")
	for _, v in ipairs(emotes) do
		if emote == v.key or emote == v.zhCN or emote == v.zhTW then
			return "|T"
				.. ((v.texture or "Interface\\AddOns\\ElvUI_WindTools\\Media\\Emotes\\") .. v.key)
				.. ":"
				.. CE.db.size
				.. "|t"
		end
	end
	return value
end

local function EmoteFilter(self, event, msg, ...)
	if CE.db.enable then
		msg = gsub(msg, "%{.-%}", ReplaceEmote)
	end

	return false, msg, ...
end

function CE:CreateInterface()
	local button
	local width, height, column, space = 20, 20, 10, 6
	local index = 0
	-- 创建 ElvUI 风格框体
	local frame = CreateFrame("Frame", "WTCustomEmoteFrame", E.UIParent, "UIPanelDialogTemplate")
	_G.WTCustomEmoteFrameTitleBG:Hide()
	_G.WTCustomEmoteFrameDialogBG:Hide()
	frame:StripTextures()
	frame:CreateBackdrop("Transparent")
	S:CreateShadowModule(frame.backdrop)
	S:MerathilisUISkin(frame.backdrop)
	S:Proxy("HandleCloseButton", _G.WTCustomEmoteFrameClose)

	-- 定位
	frame:SetWidth(column * (width + space) + 24)
	frame:SetClampedToScreen(true)
	frame:SetFrameStrata("DIALOG")
	frame:SetPoint("LEFT", _G.LeftChatPanel, "RIGHT", 60, 0)

	-- 拖动
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")

	frame:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" and not self.isMoving then
			self:StartMoving()
			self.isMoving = true
		end
	end)
	frame:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" and self.isMoving then
			self:StopMovingOrSizing()
			self.isMoving = false
		elseif button == "RightButton" and not self.isMoving then
			-- 右键复原
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", _G.WTCustomEmoteFrameMover, "TOPLEFT", 0, 0)
		end
	end)
	frame:SetScript("OnHide", function(self)
		if self.isMoving then
			self:StopMovingOrSizing()
			self.isMoving = false
		end
	end)

	-- 标题
	frame.title = frame:CreateFontString(nil, "ARTWORK", "ChatFontNormal")
	frame.title:SetPoint("TOP", frame, "TOP", 0, -9)
	frame.title:FontTemplate(E.media.normFont, 16, "OUTLINE")

	-- 帮助提示
	local tipsButton = CreateFrame("Frame", nil, frame)
	tipsButton:SetSize(25, 25)
	tipsButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -4)
	tipsButton.text = tipsButton:CreateFontString(nil, "ARTWORK")
	tipsButton.text:SetPoint("CENTER", 0, 0)
	tipsButton.text:FontTemplate(E.media.normFont, 14, "OUTLINE")
	tipsButton.text:SetText("?")
	tipsButton:SetScript("OnEnter", function()
		frame.title:SetText(L["Move (L\124\124R) Reset"])
	end)
	tipsButton:SetScript("OnLeave", function()
		frame.title:SetText("")
	end)

	-- 建立表情
	for _, v in ipairs(emotes) do
		button = CreateFrame("Button", nil, frame)
		button.emote = "{" .. (v[E.global.general.locale] or v.key) .. "}"
		button:SetSize(width, height)
		if v.texture then
			button:SetNormalTexture(v.texture)
		else
			button:SetNormalTexture("Interface\\Addons\\ElvUI_WindTools\\Media\\Emotes\\" .. v.key)
		end
		button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
		button:SetPoint(
			"TOPLEFT",
			16 + (index % column) * (width + space),
			-36 - floor(index / column) * (height + space)
		)
		button:SetScript("OnMouseUp", EmoteButton_OnClick)
		button:SetScript("OnEnter", EmoteButton_OnEnter)
		button:SetScript("OnLeave", EmoteButton_OnLeave)
		index = index + 1
	end
	frame:SetHeight(ceil(index / column) * (height + space) + 46)
	frame:Hide()

	-- 让输入框支持当输入 { 时自动弹出聊天表情选择框
	self:SecureHook("ChatEdit_OnTextChanged")

	self.EmoteSelector = frame

	E:CreateMover(frame, "WTCustomEmoteFrameMover", L["Emote Selector"], nil, nil, nil, "ALL,WINDTOOLS", function()
		return self.db.enable
	end, "WindTools,social,emote")
end

function CE:ChatEdit_OnTextChanged(chatEdit, userInput)
	if not (self.db and self.db.panel and self.db.enable) then
		return
	end
	local text = chatEdit:GetText()
	if userInput and (strsub(text, -1) == "{") then
		self.EmoteSelector:Show()
	end
end

function CE:ParseChatBubbles()
	for _, frame in pairs(C_ChatBubbles_GetAllChatBubbles()) do
		local holder = frame:GetChildren()
		if holder and not holder:IsForbidden() then
			local str = holder and holder.String
			if str then
				local oldMessage = str:GetText()
				local afterMessage = gsub(oldMessage, "%{.-%}", ReplaceEmote)
				if oldMessage ~= afterMessage then
					str:SetText(afterMessage)
				end
			end
		end
	end
end

function CE:HandleEmoteWithBubble()
	if self.db and self.db.enable and self.db.chatBubbles then
		self.bubbleTimer = self:ScheduleRepeatingTimer("ParseChatBubbles", 0.1)
	else
		if self.bubbleTimer then
			self:CancelTimer(self.bubbleTimer)
			self.bubbleTimer = nil
		end
	end
end

function CE:Initialize()
	self.db = E.db.WT.social.emote

	if self.initialized or not self.db.enable then
		return
	end

	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", EmoteFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", EmoteFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", EmoteFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", EmoteFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", EmoteFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", EmoteFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", EmoteFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", EmoteFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", EmoteFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", EmoteFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", EmoteFilter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", EmoteFilter)

	self:CreateInterface()
	self:HandleEmoteWithBubble()
	self.initialized = true
end

function CE:ProfileUpdate()
	self:Initialize()

	if self.initialized and not self.db.enable then
		self.EmoteSelector:Hide()
	end

	-- 由于有表情按键, 需要更新一下
	W:GetModule("ChatBar"):UpdateBar()

	self:HandleEmoteWithBubble()
end

W:RegisterModule(CE:GetName())
