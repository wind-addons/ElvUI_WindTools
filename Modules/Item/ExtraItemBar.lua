local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local EB = W:NewModule("ExtraItemsBar", "AceEvent-3.0") ---@class ExtraItemsBar : AceModule, AceEvent-3.0
local async = W.Utilities.Async
local S = W.Modules.Skins ---@type Skins
local AB = E.ActionBars

local _G = _G
local ceil = ceil
local format = format
local ipairs = ipairs
local pairs = pairs
local strmatch = strmatch
local strsplit = strsplit
local tinsert = tinsert
local tonumber = tonumber
local unpack = unpack
local wipe = wipe

local CooldownFrame_Set = CooldownFrame_Set
local CreateAtlasMarkup = CreateAtlasMarkup
local CreateFrame = CreateFrame
local GameTooltip = _G.GameTooltip
local GetBindingKey = GetBindingKey
local GetInventoryItemCooldown = GetInventoryItemCooldown
local GetInventoryItemID = GetInventoryItemID
local GetQuestLogSpecialItemCooldown = GetQuestLogSpecialItemCooldown
local GetQuestLogSpecialItemInfo = GetQuestLogSpecialItemInfo
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver

local C_Item_GetItemCooldown = C_Item.GetItemCooldown
local C_Item_GetItemCount = C_Item.GetItemCount
local C_Item_IsItemInRange = C_Item.IsItemInRange
local C_Item_IsUsableItem = C_Item.IsUsableItem
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_Timer_NewTicker = C_Timer.NewTicker
local C_TradeSkillUI_GetItemCraftedQualityByItemInfo = C_TradeSkillUI.GetItemCraftedQualityByItemInfo
local C_TradeSkillUI_GetItemReagentQualityByItemInfo = C_TradeSkillUI.GetItemReagentQualityByItemInfo

local questItemList = {}
local function UpdateQuestItemList()
	wipe(questItemList)
	for questLogIndex = 1, C_QuestLog_GetNumQuestLogEntries() do
		local link = GetQuestLogSpecialItemInfo(questLogIndex)
		if link then
			local itemID = tonumber(strmatch(link, "|Hitem:(%d+):"))
			local data = {
				questLogIndex = questLogIndex,
				itemID = itemID,
			}
			tinsert(questItemList, data)
		end
	end
end

local forceUsableItems = {
	[193634] = true, -- 茂發種子
	[206448] = true, --『夢境裂斧』菲拉雷斯
}

local equipmentList = {}
local function UpdateEquipmentList()
	wipe(equipmentList)
	for slotID = 1, 18 do
		local itemID = GetInventoryItemID("player", slotID)
		if itemID and (C_Item_IsUsableItem(itemID) or forceUsableItems[itemID]) then
			tinsert(equipmentList, slotID)
		end
	end
end

local function ParseSlotFilter(slotStr)
	if not slotStr or slotStr == "" then
		return nil
	end

	local allowedSlots = {}

	if strmatch(slotStr, "^(%d+)-(%d+)$") then
		local startSlot, endSlot = strmatch(slotStr, "^(%d+)-(%d+)$")
		startSlot, endSlot = tonumber(startSlot), tonumber(endSlot)
		if startSlot and endSlot and startSlot <= endSlot then
			for slotID = startSlot, endSlot do
				if slotID >= 1 and slotID <= 18 then
					allowedSlots[slotID] = true
				end
			end
		end
	elseif strmatch(slotStr, "^%d+$") then
		local slotID = tonumber(slotStr)
		if slotID and slotID >= 1 and slotID <= 18 then
			allowedSlots[slotID] = true
		end
	end

	return allowedSlots
end

local UpdateAfterCombat = {
	[1] = false,
	[2] = false,
	[3] = false,
}

do
	local fakeButton = {
		HotKey = {
			text = "",
			SetText = function(self, text)
				self.text = text
			end,
			GetText = function(self)
				return self.text
			end,
		},
	}

	function EB:GetBindingKeyWithElvUI(key)
		local keybind = GetBindingKey(key)

		if not keybind or keybind == "" then
			return ""
		end

		fakeButton.HotKey:SetText(keybind)
		AB:FixKeybindText(fakeButton)
		return fakeButton.HotKey:GetText()
	end
end

function EB:CreateButton(name, barDB)
	local button = CreateFrame("Button", name, E.UIParent, "SecureActionButtonTemplate, BackdropTemplate")
	button:SetSize(barDB.buttonWidth, barDB.buttonHeight)
	button:SetTemplate("Default")
	button:SetClampedToScreen(true)
	button:SetAttribute("type", "item")
	button:EnableMouse(false)
	button:RegisterForClicks(W.UseKeyDown and "AnyDown" or "AnyUp")

	local tex = button:CreateTexture(nil, "OVERLAY", nil)
	tex:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
	tex:SetTexCoord(unpack(E.TexCoords))

	local qualityTier = button:CreateFontString(nil, "OVERLAY")
	qualityTier:SetTextColor(1, 1, 1, 1)
	qualityTier:SetPoint("TOPLEFT", button, "TOPLEFT")
	qualityTier:SetJustifyH("CENTER")
	F.SetFontWithDB(qualityTier, {
		size = barDB.qualityTier.size,
		name = E.db.general.font,
		style = "OUTLINE",
	})

	local count = button:CreateFontString(nil, "OVERLAY")
	count:SetTextColor(1, 1, 1, 1)
	count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
	count:SetJustifyH("CENTER")
	F.SetFontWithDB(count, barDB.countFont)

	local bind = button:CreateFontString(nil, "OVERLAY")
	bind:SetTextColor(0.6, 0.6, 0.6)
	bind:SetPoint("TOPRIGHT", button, "TOPRIGHT")
	bind:SetJustifyH("CENTER")
	F.SetFontWithDB(bind, barDB.bindFont)

	local cooldown = CreateFrame("Cooldown", name .. "Cooldown", button, "CooldownFrameTemplate")
	E:RegisterCooldown(cooldown)

	button.tex = tex
	button.qualityTier = qualityTier
	button.count = count
	button.bind = bind
	button.cooldown = cooldown

	button.SetTier = function(self, itemIDOrLink)
		local level = C_TradeSkillUI_GetItemReagentQualityByItemInfo(itemIDOrLink)
			or C_TradeSkillUI_GetItemCraftedQualityByItemInfo(itemIDOrLink)

		if not level or level == 0 then
			self.qualityTier:SetText("")
			self.qualityTier:Hide()
		else
			self.qualityTier:SetText(CreateAtlasMarkup(format("Professions-Icon-Quality-Tier%d-Small", level)))
			self.qualityTier:Show()
		end
	end

	button:StyleButton()

	S:CreateShadowModule(button)
	S:BindShadowColorWithBorder(button)

	return button
end

function EB:SetUpButton(button, itemData, slotID, waitGroup)
	button.itemName = nil
	button.itemID = nil
	button.spellName = nil
	button.slotID = nil
	button.countText = nil

	if itemData then
		button.itemID = itemData.itemID
		button.countText = C_Item_GetItemCount(itemData.itemID, nil, true)
		button.questLogIndex = itemData.questLogIndex
		button:SetBackdropBorderColor(0, 0, 0)

		waitGroup.count = waitGroup.count + 1
		async.WithItemID(itemData.itemID, function(item)
			button.itemName = item:GetItemName()
			button.tex:SetTexture(item:GetItemIcon())
			button:SetTier(itemData.itemID)
			E:Delay(0.1, function()
				-- delay for quality tier fetching and text changing
				waitGroup.count = waitGroup.count - 1
			end)
		end)
	elseif slotID then
		button.slotID = slotID

		waitGroup.count = waitGroup.count + 1
		async.WithItemSlotID(slotID, function(item)
			button.itemName = item:GetItemName()
			button.tex:SetTexture(item:GetItemIcon())

			local color = item:GetItemQualityColor()

			if color then
				button:SetBackdropBorderColor(color.r, color.g, color.b)
			end

			button:SetTier(item:GetItemID())

			E:Delay(0.1, function()
				-- delay for quality tier fetching and text changing
				waitGroup.count = waitGroup.count - 1
			end)
		end)
	end

	-- Count
	if button.countText and button.countText > 1 then
		button.count:SetText(button.countText)
	else
		button.count:SetText()
	end

	-- OnUpdate
	local OnUpdateFunction
	if button.itemID then
		OnUpdateFunction = function(self)
			local start, duration, enable
			if self.questLogIndex and self.questLogIndex > 0 then
				start, duration, enable = GetQuestLogSpecialItemCooldown(self.questLogIndex)
			else
				start, duration, enable = C_Item_GetItemCooldown(self.itemID)
			end
			CooldownFrame_Set(self.cooldown, start, duration, enable)
			if duration and duration > 0 and enable and enable == 0 then
				self.tex:SetVertexColor(0.4, 0.4, 0.4)
			elseif not InCombatLockdown() and C_Item_IsItemInRange(self.itemID, "target") == false then
				self.tex:SetVertexColor(1, 0, 0)
			else
				self.tex:SetVertexColor(1, 1, 1)
			end
		end
	elseif button.slotID then
		OnUpdateFunction = function(self)
			local start, duration, enable = GetInventoryItemCooldown("player", self.slotID)
			CooldownFrame_Set(self.cooldown, start, duration, enable)
		end
	end
	button:SetScript("OnUpdate", OnUpdateFunction)

	-- Tooltips
	button:SetScript("OnEnter", function(self)
		local bar = self:GetParent()
		local barDB = EB.db["bar" .. bar.id]
		if not bar or not barDB then
			return
		end

		if barDB.globalFade then
			if AB.fadeParent and not AB.fadeParent.mouseLock then
				E:UIFrameFadeIn(AB.fadeParent, 0.2, AB.fadeParent:GetAlpha(), 1)
			end
		elseif barDB.mouseOver then
			local alphaCurrent = bar:GetAlpha()
			E:UIFrameFadeIn(
				bar,
				barDB.fadeTime * (barDB.alphaMax - alphaCurrent) / (barDB.alphaMax - barDB.alphaMin),
				alphaCurrent,
				barDB.alphaMax
			)
		end

		if barDB.tooltip then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, -2)
			GameTooltip:ClearLines()

			if self.slotID then
				GameTooltip:SetInventoryItem("player", self.slotID)
			else
				GameTooltip:SetItemByID(self.itemID)
			end

			GameTooltip:Show()
		end
	end)

	button:SetScript("OnLeave", function(self)
		local bar = self:GetParent()
		local barDB = EB.db["bar" .. bar.id]
		if not bar or not barDB then
			return
		end

		if barDB.globalFade then
			if AB.fadeParent and not AB.fadeParent.mouseLock then
				E:UIFrameFadeOut(AB.fadeParent, 0.2, AB.fadeParent:GetAlpha(), 1 - AB.db.globalFadeAlpha)
			end
		elseif barDB.mouseOver then
			local alphaCurrent = bar:GetAlpha()
			E:UIFrameFadeOut(
				bar,
				barDB.fadeTime * (alphaCurrent - barDB.alphaMin) / (barDB.alphaMax - barDB.alphaMin),
				alphaCurrent,
				barDB.alphaMin
			)
		end

		GameTooltip:Hide()
	end)

	-- Attributes
	if not InCombatLockdown() then
		button:EnableMouse(true)
		button:Show()
		button:SetAttribute("type", "macro")

		local macroText
		if button.slotID then
			macroText = "/use " .. button.slotID
		elseif button.itemName then
			macroText = "/use item:" .. button.itemID
			if button.itemID == 172347 then
				macroText = macroText .. "\n/use 5"
			end
		end

		if macroText then
			button:SetAttribute("macrotext", macroText)
		end
	end
end

function EB:UpdateButtonSize(button, barDB)
	button:SetSize(barDB.buttonWidth, barDB.buttonHeight)
	local left, right, top, bottom = unpack(E.TexCoords)

	if barDB.buttonWidth > barDB.buttonHeight then
		local offset = (bottom - top) * (1 - barDB.buttonHeight / barDB.buttonWidth) / 2
		top = top + offset
		bottom = bottom - offset
	elseif barDB.buttonWidth < barDB.buttonHeight then
		local offset = (right - left) * (1 - barDB.buttonWidth / barDB.buttonHeight) / 2
		left = left + offset
		right = right - offset
	end

	button.tex:SetTexCoord(left, right, top, bottom)
end

function EB:PLAYER_REGEN_ENABLED()
	for i = 1, 5 do
		if UpdateAfterCombat[i] then
			self:UpdateBar(i)
			UpdateAfterCombat[i] = false
		end
	end
end

function EB:UpdateBarTextOnCombat(i)
	for k = 1, 12 do
		local button = self.bars[i].buttons[k]
		if button.itemID and button:IsShown() then
			button.countText = C_Item_GetItemCount(button.itemID, nil, true)
			if button.countText and button.countText > 1 then
				button.count:SetText(button.countText)
			else
				button.count:SetText()
			end
		end
	end
end

function EB:CreateBar(id)
	if not self.db or not self.db["bar" .. id] then
		return
	end

	local barDB = self.db["bar" .. id]

	local anchor = CreateFrame("Frame", "WTExtraItemsBar" .. id .. "Anchor", E.UIParent)
	anchor:SetClampedToScreen(true)
	anchor:SetPoint("BOTTOMLEFT", _G.RightChatPanel or _G.LeftChatPanel, "TOPLEFT", 0, (id - 1) * 45)
	anchor:SetSize(200, 40)
	E:CreateMover(
		anchor,
		"WTExtraItemsBar" .. id .. "Mover",
		L["Extra Items Bar"] .. " " .. id,
		nil,
		nil,
		nil,
		"ALL,WINDTOOLS",
		function()
			return EB.db.enable and barDB.enable
		end,
		"WindTools,item,extraItemBar"
	)

	-- Bar
	local bar = CreateFrame("Frame", "WTExtraItemsBar" .. id, E.UIParent, "SecureHandlerStateTemplate")
	bar.id = id
	bar:ClearAllPoints()
	bar:SetParent(anchor)
	bar:SetPoint("CENTER", anchor, "CENTER", 0, 0)
	bar:SetSize(200, 40)
	bar:CreateBackdrop("Transparent")
	bar:SetFrameStrata("LOW")

	-- Buttons
	bar.buttons = {}
	for i = 1, 12 do
		bar.buttons[i] = self:CreateButton(bar:GetName() .. "Button" .. i, barDB)
		bar.buttons[i]:SetParent(bar)
		if i == 1 then
			bar.buttons[i]:SetPoint("LEFT", bar, "LEFT", 5, 0)
		else
			bar.buttons[i]:SetPoint("LEFT", bar.buttons[i - 1], "RIGHT", 5, 0)
		end
	end

	bar:SetScript("OnEnter", function(self)
		if not barDB then
			return
		end

		if not barDB.globalFade and barDB.mouseOver and barDB.alphaMax and barDB.alphaMin then
			local alphaCurrent = bar:GetAlpha()
			E:UIFrameFadeIn(
				bar,
				barDB.fadeTime * (barDB.alphaMax - alphaCurrent) / (barDB.alphaMax - barDB.alphaMin),
				alphaCurrent,
				barDB.alphaMax
			)
		end
	end)

	bar:SetScript("OnLeave", function(self)
		if not barDB then
			return
		end

		if not barDB.globalFade and barDB.mouseOver and barDB.alphaMax and barDB.alphaMin then
			local alphaCurrent = bar:GetAlpha()
			E:UIFrameFadeOut(
				bar,
				barDB.fadeTime * (alphaCurrent - barDB.alphaMin) / (barDB.alphaMax - barDB.alphaMin),
				alphaCurrent,
				barDB.alphaMin
			)
		end
	end)

	self.bars[id] = bar
end

function EB:ValidateItem(itemID)
	if not itemID then
		return false
	end

	if self.db.blackList[itemID] then
		return false
	end

	if self.StateCheckList[itemID] and not self:GetState(self.StateCheckList[itemID]) then
		return false
	end

	local count = C_Item_GetItemCount(itemID)
	local countThreshold = self.CountThreshold[itemID] or 1
	if not count or count < countThreshold then
		return false
	end

	return true
end

function EB:UpdateBar(id)
	if not self.db or not self.db["bar" .. id] then
		return
	end

	local bar = self.bars[id]
	local barDB = self.db["bar" .. id]

	if bar.waitGroup and bar.waitGroup.ticker then
		bar.waitGroup.ticker:Cancel()
	end

	bar.waitGroup = { count = 0 }

	if InCombatLockdown() then
		self:UpdateBarTextOnCombat(id)
		UpdateAfterCombat[id] = true
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	if not self.db.enable or not barDB.enable then
		if bar.register then
			UnregisterStateDriver(bar, "visibility")
			bar.register = false
		end
		bar:Hide()
		return
	end

	local buttonID = 1

	local function addNormalButton(itemID)
		if self:ValidateItem(itemID) and buttonID <= barDB.numButtons then
			self:SetUpButton(bar.buttons[buttonID], { itemID = itemID }, nil, bar.waitGroup)
			self:UpdateButtonSize(bar.buttons[buttonID], barDB)
			buttonID = buttonID + 1
		end
	end

	local function addSlotButton(slotID)
		local itemID = GetInventoryItemID("player", slotID)
		if self:ValidateItem(itemID) and buttonID <= barDB.numButtons then
			self:SetUpButton(bar.buttons[buttonID], nil, slotID, bar.waitGroup)
			self:UpdateButtonSize(bar.buttons[buttonID], barDB)
			buttonID = buttonID + 1
		end
	end

	local function addNormalButtons(list)
		for _, itemID in pairs(list) do
			addNormalButton(itemID)
		end
	end

	for _, module in ipairs({ strsplit("[, ]", barDB.include) }) do
		if buttonID <= barDB.numButtons then
			if self.moduleList[module] then
				addNormalButtons(self.moduleList[module])
			elseif module == "QUEST" then -- Quest Items
				for _, data in pairs(questItemList) do
					addNormalButton(data.itemID)
				end
			elseif module == "EQUIP" then -- Equipments
				for _, slotID in pairs(equipmentList) do
					addSlotButton(slotID)
				end
			elseif strmatch(module, "^SLOT:") then -- Equipments filtered by slot ID
				local slotFilter = strmatch(module, "^SLOT:(.+)$")
				local allowedSlots = ParseSlotFilter(slotFilter)
				if allowedSlots then
					for _, slotID in pairs(equipmentList) do
						if allowedSlots[slotID] then
							addSlotButton(slotID)
						end
					end
				end
			elseif module == "CUSTOM" then -- Custom Items
				addNormalButtons(self.db.customList)
			end
		end
	end

	-- Resize bar
	local numRows = ceil((buttonID - 1) / barDB.buttonsPerRow)
	local numCols = buttonID > barDB.buttonsPerRow and barDB.buttonsPerRow or (buttonID - 1)
	local newBarWidth = 2 * barDB.backdropSpacing + numCols * barDB.buttonWidth + (numCols - 1) * barDB.spacing
	local newBarHeight = 2 * barDB.backdropSpacing + numRows * barDB.buttonHeight + (numRows - 1) * barDB.spacing
	bar:SetSize(newBarWidth, newBarHeight)

	-- Update anchor size
	local numMoverRows = ceil(barDB.numButtons / barDB.buttonsPerRow)
	local numMoverCols = barDB.buttonsPerRow
	local newMoverWidth = 2 * barDB.backdropSpacing
		+ numMoverCols * barDB.buttonWidth
		+ (numMoverCols - 1) * barDB.spacing
	local newMoverHeight = 2 * barDB.backdropSpacing
		+ numMoverRows * barDB.buttonHeight
		+ (numMoverRows - 1) * barDB.spacing
	bar:GetParent():SetSize(newMoverWidth, newMoverHeight)

	bar:ClearAllPoints()
	bar:SetPoint(barDB.anchor)

	-- Hide buttons not in use
	if buttonID == 1 then
		if bar.register then
			UnregisterStateDriver(bar, "visibility")
			bar.register = false
		end
		bar:Hide()
		return
	end

	if buttonID <= 12 then
		for hideButtonID = buttonID, 12 do
			bar.buttons[hideButtonID]:Hide()
		end
	end

	for i = 1, buttonID - 1 do
		-- Reposition icons
		local anchor = barDB.anchor
		local button = bar.buttons[i]

		button:ClearAllPoints()

		if i == 1 then
			if anchor == "TOPLEFT" then
				button:SetPoint(anchor, bar, anchor, barDB.backdropSpacing, -barDB.backdropSpacing)
			elseif anchor == "TOPRIGHT" then
				button:SetPoint(anchor, bar, anchor, -barDB.backdropSpacing, -barDB.backdropSpacing)
			elseif anchor == "BOTTOMLEFT" then
				button:SetPoint(anchor, bar, anchor, barDB.backdropSpacing, barDB.backdropSpacing)
			elseif anchor == "BOTTOMRIGHT" then
				button:SetPoint(anchor, bar, anchor, -barDB.backdropSpacing, barDB.backdropSpacing)
			end
		elseif i <= barDB.buttonsPerRow then
			local nearest = bar.buttons[i - 1]
			if anchor == "TOPLEFT" or anchor == "BOTTOMLEFT" then
				button:SetPoint("LEFT", nearest, "RIGHT", barDB.spacing, 0)
			else
				button:SetPoint("RIGHT", nearest, "LEFT", -barDB.spacing, 0)
			end
		else
			local nearest = bar.buttons[i - barDB.buttonsPerRow]
			if anchor == "TOPLEFT" or anchor == "TOPRIGHT" then
				button:SetPoint("TOP", nearest, "BOTTOM", 0, -barDB.spacing)
			else
				button:SetPoint("BOTTOM", nearest, "TOP", 0, barDB.spacing)
			end
		end

		F.SetFontWithDB(button.qualityTier, {
			size = barDB.qualityTier.size,
			name = E.db.general.font,
			style = "OUTLINE",
		})

		F.SetFontWithDB(button.count, barDB.countFont)
		F.SetFontWithDB(button.bind, barDB.bindFont)

		F.SetFontColorWithDB(button.count, barDB.countFont.color)
		F.SetFontColorWithDB(button.bind, barDB.bindFont.color)

		button.qualityTier:ClearAllPoints()
		button.qualityTier:SetPoint("TOPLEFT", button, "TOPLEFT", barDB.qualityTier.xOffset, barDB.qualityTier.yOffset)

		button.count:ClearAllPoints()
		button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", barDB.countFont.xOffset, barDB.countFont.yOffset)

		button.bind:ClearAllPoints()
		button.bind:SetPoint("TOPRIGHT", button, "TOPRIGHT", barDB.bindFont.xOffset, barDB.bindFont.yOffset)
	end

	if not bar.register then
		RegisterStateDriver(bar, "visibility", barDB.visibility)
		bar.register = true
	end

	-- Toggle shadow
	if barDB.backdrop then
		bar.backdrop:Show()
		if E.private.WT.skins.enable and E.private.WT.skins.windtools and E.private.WT.skins.shadow then
			for i = 1, 12 do
				if bar.buttons[i].shadow then
					bar.buttons[i].shadow:Hide()
				end
			end
		end
	else
		bar.backdrop:Hide()
		if E.private.WT.skins.enable and E.private.WT.skins.windtools and E.private.WT.skins.shadow then
			for i = 1, 12 do
				if bar.buttons[i].shadow then
					bar.buttons[i].shadow:Show()
				end
			end
		end
	end

	bar.waitGroup.ticker = C_Timer_NewTicker(0.1, function()
		if bar.waitGroup.count == 0 then
			if bar.waitGroup.ticker then
				bar.waitGroup.ticker:Cancel()
			end
			bar.alphaMin = barDB.alphaMin
			bar.alphaMax = barDB.alphaMax

			if barDB.globalFade then
				bar:SetAlpha(1)
			else
				bar:SetAlpha(barDB.mouseOver and barDB.alphaMin or barDB.alphaMax)
			end

			local anchor = bar:GetParent()
			local alphaParent = barDB.globalFade and AB.fadeParent or E.UIParent

			if anchor and anchor:GetParent() ~= alphaParent then
				F.TaskManager:OutOfCombat(anchor.SetParent, anchor, alphaParent)
			end

			bar.waitGroup = nil
		end
	end)
end

function EB:UpdateBars()
	self:UpdateState(EB.STATE.IN_DELVE)
	for i = 1, 5 do
		self:UpdateBar(i)
	end
end

do
	local lastUpdateTime = 0
	function EB:UNIT_INVENTORY_CHANGED()
		local now = GetTime()
		if now - lastUpdateTime < 0.25 then
			return
		end
		lastUpdateTime = now
		UpdateQuestItemList()
		UpdateEquipmentList()

		self:UpdateBars()
	end
end

function EB:UpdateQuestItem()
	UpdateQuestItemList()
	self:UpdateBars()
end

function EB:UpdateEquipmentItem()
	UpdateEquipmentList()
	self:UpdateBars()
end

do
	local InUpdating = false
	function EB:ITEM_LOCKED()
		if InUpdating then
			return
		end

		InUpdating = true
		E:Delay(1, function()
			UpdateEquipmentList()
			self:UpdateBars()
			InUpdating = false
		end)
	end
end

function EB:CreateAll()
	self.bars = {}

	for i = 1, 5 do
		self:CreateBar(i)
		S:CreateShadowModule(self.bars[i].backdrop)
		S:MerathilisUISkin(self.bars[i].backdrop)
	end
end

function EB:UpdateBinding()
	if not self.db then
		return
	end

	for i = 1, 5 do
		for j = 1, 12 do
			local button = self.bars[i].buttons[j]
			if button then
				local bindingName = format("CLICK WTExtraItemsBar%dButton%d:LeftButton", i, j)
				button.bind:SetText(self:GetBindingKeyWithElvUI(bindingName))
			end
		end
	end
end

function EB:Initialize()
	self.db = E.db.WT.item.extraItemsBar
	if not self.db or not self.db.enable or self.initialized then
		return
	end

	self:CreateAll()
	UpdateQuestItemList()
	UpdateEquipmentList()
	self:UpdateBars()
	self:UpdateBinding()

	self:RegisterEvent("BAG_UPDATE_DELAYED", "UpdateBars")
	self:RegisterEvent("ITEM_LOCKED")
	self:RegisterEvent("PLAYER_ALIVE", "UpdateBars")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdateEquipmentItem")
	self:RegisterEvent("PLAYER_UNGHOST", "UpdateBars")
	self:RegisterEvent("QUEST_ACCEPTED", "UpdateQuestItem")
	self:RegisterEvent("QUEST_LOG_UPDATE", "UpdateQuestItem")
	self:RegisterEvent("QUEST_TURNED_IN", "UpdateQuestItem")
	self:RegisterEvent("QUEST_WATCH_LIST_CHANGED", "UpdateQuestItem")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	self:RegisterEvent("UPDATE_BINDINGS", "UpdateBinding")
	self:RegisterEvent("ZONE_CHANGED", "UpdateBars")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "UpdateBars")

	self.initialized = true
end

function EB:ProfileUpdate()
	self:Initialize()

	if self.db.enable then
		UpdateQuestItemList()
		UpdateEquipmentList()
	elseif self.initialized then
		self:UnregisterEvent("BAG_UPDATE_DELAYED")
		self:UnregisterEvent("PLAYER_ALIVE")
		self:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
		self:UnregisterEvent("PLAYER_UNGHOST")
		self:UnregisterEvent("QUEST_ACCEPTED")
		self:UnregisterEvent("QUEST_LOG_UPDATE")
		self:UnregisterEvent("QUEST_TURNED_IN")
		self:UnregisterEvent("QUEST_WATCH_LIST_CHANGED")
		self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
		self:UnregisterEvent("UPDATE_BINDINGS")
		self:UnregisterEvent("ZONE_CHANGED")
		self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	end

	self:UpdateBars()
end

W:RegisterModule(EB:GetName())
