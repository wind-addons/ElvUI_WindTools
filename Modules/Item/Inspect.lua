local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local IL = W:NewModule("Inspect", "AceEvent-3.0", "AceHook-3.0") -- Modified from TinyInspect
local S = W.Modules.Skins ---@type Skins
local MF = W.Modules.MoveFrames ---@type MoveFrames

local LibEvent = LibStub:GetLibrary("LibEvent.7000")
local LibItemEnchant = LibStub:GetLibrary("LibItemEnchant.7000")
local LibItemInfo = LibStub:GetLibrary("LibItemInfo.7000")
local LibItemGem = LibStub:GetLibrary("LibItemGem.7000")
local LibSchedule = LibStub:GetLibrary("LibSchedule.7000")

local _G = _G
local abs = abs
local floor = floor
local format = format
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local max = max
local pairs = pairs
local select = select
local strlen = strlen
local time = time
local tinsert = tinsert
local unpack = unpack

local AbbreviateLargeNumbers = AbbreviateLargeNumbers
local CreateFrame = CreateFrame
local GameTooltip = _G.GameTooltip
local GetInspectSpecialization = GetInspectSpecialization
local GetRealmName = GetRealmName
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecializationInfoByID = GetSpecializationInfoByID
local GetTime = GetTime
local Item = Item
local SetPortraitTexture = SetPortraitTexture
local Spell = Spell
local ToggleFrame = ToggleFrame
local UnitClass = UnitClass
local UnitGUID = UnitGUID
local UnitHealthMax = UnitHealthMax
local UnitLevel = UnitLevel
local UnitName = UnitName

local ENCHANTS = ENCHANTS
local HEALTH = HEALTH
local LEVEL = LEVEL
local NORMAL_FONT_COLOR = NORMAL_FONT_COLOR
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local STAT_AVERAGE_ITEM_LEVEL = STAT_AVERAGE_ITEM_LEVEL

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_Item_GetItemInfo = C_Item.GetItemInfo
local C_Item_GetItemQualityColor = C_Item.GetItemQualityColor
local C_Item_IsCorruptedItem = C_Item.IsCorruptedItem
local C_Spell_GetSpellTexture = C_Spell.GetSpellTexture

local guids, inspecting = {}, false

local slots = {
	{ index = 1, name = HEADSLOT },
	{ index = 2, name = NECKSLOT },
	{ index = 3, name = SHOULDERSLOT },
	{ index = 5, name = CHESTSLOT },
	{ index = 6, name = WAISTSLOT },
	{ index = 7, name = LEGSSLOT },
	{ index = 8, name = FEETSLOT },
	{ index = 9, name = WRISTSLOT },
	{ index = 10, name = HANDSSLOT },
	{ index = 11, name = FINGER0SLOT },
	{ index = 12, name = FINGER1SLOT },
	{ index = 13, name = TRINKET0SLOT },
	{ index = 14, name = TRINKET1SLOT },
	{ index = 15, name = BACKSLOT },
	{ index = 16, name = MAINHANDSLOT },
	{ index = 17, name = SECONDARYHANDSLOT },
}

local EnchantParts = {
	{ false, "HEADSLOT" },
	{ false, "NECKSLOT" },
	{ false, "SHOULDERSLOT" },
	false,
	{ true, "CHESTSLOT" },
	{ false, "WAISTSLOT" },
	{ false, "LEGSSLOT" },
	{ true, "FEETSLOT" },
	{ false, "WRISTSLOT" },
	{ false, "HANDSSLOT" },
	{ true, "FINGER0SLOT" },
	{ true, "FINGER1SLOT" },
	{ false, "TRINKET0SLOT" },
	{ false, "TRINKET1SLOT" },
	{ true, "BACKSLOT" },
	{ true, "MAINHANDSLOT" },
	{ false, "SECONDARYHANDSLOT" },
}

local function ReInspect(unit)
	local guid = UnitGUID(unit)
	if not guid then
		return
	end
	local data = guids[guid]
	if not data then
		return
	end
	LibSchedule:AddTask({
		identity = guid,
		timer = 0.5,
		elasped = 0.5,
		expired = GetTime() + 3,
		data = data,
		unit = unit,
		onExecute = function(self)
			local count, ilevel, _, weaponLevel, isArtifact, maxLevel = LibItemInfo:GetUnitItemLevel(self.unit)
			if ilevel <= 0 then
				return true
			end
			if count == 0 and ilevel > 0 then
				self.data.timer = time()
				self.data.ilevel = ilevel
				self.data.maxLevel = maxLevel
				self.data.weaponLevel = weaponLevel
				self.data.isArtifact = isArtifact
				LibEvent:trigger("UNIT_REINSPECT_READY", self.data)
				return true
			end
		end,
	})
end

local function GetInspectSpec(unit)
	local specID, specName
	if unit == "player" then
		specID = GetSpecialization()
		specName = select(2, GetSpecializationInfo(specID))
	else
		specID = GetInspectSpecialization(unit)
		if specID and specID > 0 then
			specName = select(2, GetSpecializationInfoByID(specID))
		end
	end
	return specName or ""
end

local function GetStateValue(_, _, value, default)
	return value or default
end

-- Gems
--創建圖標框架
local function CreateIconFrame(frame, index)
	local icon = CreateFrame("Button", nil, frame)
	icon.index = index
	icon:Hide()
	icon:Size(16, 16)
	icon:SetScript("OnEnter", function(self)
		if self.itemLink then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetHyperlink(self.itemLink)
			GameTooltip:Show()
		elseif self.spellID then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetSpellByID(self.spellID)
			GameTooltip:Show()
		elseif self.title then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.title)
			GameTooltip:Show()
		end
	end)
	icon:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	icon:SetScript("OnDoubleClick", function(self)
		if self.itemLink or self.title then
			_G.ChatEdit_ActivateChat(_G.ChatEdit_ChooseBoxForSend())
			_G.ChatEdit_InsertLink(self.itemLink or self.title)
		end
	end)
	icon.bg = icon:CreateTexture(nil, "BACKGROUND")
	icon.bg:Size(16, 16)
	icon.bg:Point("CENTER")
	icon.bg:SetTexture(W.Media.Textures.inspectGemBG)
	icon.texture = icon:CreateTexture(nil, "BORDER")
	icon.texture:Size(12, 12)
	icon.texture:Point("CENTER")
	icon.texture:SetMask("Interface\\FriendsFrame\\Battlenet-Portrait")
	frame["xicon" .. index] = icon
	return frame["xicon" .. index]
end

--隱藏所有圖標框架
local function HideAllIconFrame(frame)
	local index = 1
	while frame["xicon" .. index] do
		frame["xicon" .. index].title = nil
		frame["xicon" .. index].itemLink = nil
		frame["xicon" .. index].spellID = nil
		frame["xicon" .. index]:Hide()
		index = index + 1
	end
	LibSchedule:RemoveTask("InspectGemAndEnchant", true)
end

--獲取可用的圖標框架
local function GetIconFrame(frame)
	local index = 1
	while frame["xicon" .. index] do
		if not frame["xicon" .. index]:IsShown() then
			return frame["xicon" .. index]
		end
		index = index + 1
	end
	return CreateIconFrame(frame, index)
end

--執行圖標更新
local function onExecute(self)
	if self.dataType == "item" then
		local _, itemLink, quality, _, _, _, _, _, _, texture = C_Item_GetItemInfo(self.data)
		if texture then
			local r, g, b = C_Item_GetItemQualityColor(quality or 0)
			self.icon.bg:SetVertexColor(r, g, b)
			self.icon.texture:SetTexture(texture)
			if not self.icon.itemLink then
				self.icon.itemLink = itemLink
			end
			return true
		end
	elseif self.dataType == "spell" then
		local texture = C_Spell_GetSpellTexture(self.data)
		if texture then
			self.icon.texture:SetTexture(texture)
			return true
		end
	end
end

-- Use Item and Spell Mixin to dynamically update information
local function DynamicUpdateIconTexture(type, targetIcon, data)
	if type == "itemId" then
		local item = Item:CreateFromItemID(data)
		item:ContinueOnItemLoad(function()
			local qualityColor = item:GetItemQualityColor()
			targetIcon.bg:SetVertexColor(qualityColor.r, qualityColor.g, qualityColor.b)
			targetIcon.texture:SetTexture(item:GetItemIcon())
			targetIcon.itemLink = item:GetItemLink()
		end)
	elseif type == "itemLink" then
		local item = Item:CreateFromItemLink(data)
		item:ContinueOnItemLoad(function()
			local qualityColor = item:GetItemQualityColor()
			targetIcon.bg:SetVertexColor(qualityColor.r, qualityColor.g, qualityColor.b)
			targetIcon.texture:SetTexture(item:GetItemIcon())
			targetIcon.itemLink = item:GetItemLink()
		end)
	elseif type == "spellId" then
		local spell = Spell:CreateFromSpellID(data)
		spell:ContinueOnSpellLoad(function()
			targetIcon.texture:SetTexture(spell:GetSpellTexture())
			targetIcon.spellID = spell:GetSpellID()
		end)
	elseif type == "spellLink" then
		local spell = Item:CreateFromSpellLink(data)
		spell:ContinueOnSpellLoad(function()
			targetIcon.texture:SetTexture(spell:GetSpellTexture())
			targetIcon.spellID = spell:GetSpellID()
		end)
	end
end

--讀取並顯示圖標
local function ShowGemAndEnchant(frame, ItemLink, anchorFrame, itemframe)
	if not ItemLink then
		return 0
	end
	local num, info, qty = LibItemGem:GetItemGemInfo(ItemLink)
	local icon
	for i, v in ipairs(info) do
		icon = GetIconFrame(frame)
		if v.link then
			icon.texture:SetTexture("Interface\\Cursor\\Quest")
			DynamicUpdateIconTexture("itemLink", icon, v.link)
		else
			icon.bg:SetVertexColor(1, 0.82, 0, 0.5)
			icon.texture:SetTexture("Interface\\Cursor\\Quest")
		end
		icon.title = v.name
		icon.itemLink = v.link
		icon:ClearAllPoints()
		icon:Point("LEFT", anchorFrame, "RIGHT", i == 1 and 6 or 1, 0)
		icon:Show()
		anchorFrame = icon
	end
	local enchantItemID, enchantID = LibItemEnchant:GetEnchantItemID(ItemLink)
	local enchantSpellID = LibItemEnchant:GetEnchantSpellID(ItemLink)
	if enchantItemID then
		num = num + 1
		icon = GetIconFrame(frame)
		DynamicUpdateIconTexture("itemId", icon, enchantItemID)
		icon:ClearAllPoints()
		icon:Point("LEFT", anchorFrame, "RIGHT", num == 1 and 6 or 1, 0)
		icon:Show()
		anchorFrame = icon
	elseif enchantSpellID then
		num = num + 1
		icon = GetIconFrame(frame)
		icon.bg:SetVertexColor(1, 0.82, 0)
		DynamicUpdateIconTexture("spellId", icon, enchantSpellID)
		icon:ClearAllPoints()
		icon:Point("LEFT", anchorFrame, "RIGHT", num == 1 and 6 or 1, 0)
		icon:Show()
		anchorFrame = icon
	elseif enchantID then
		num = num + 1
		icon = GetIconFrame(frame)
		icon.title = "#" .. enchantID
		icon.bg:SetVertexColor(0.1, 0.1, 0.1)
		icon.texture:SetTexture("Interface\\FriendsFrame\\InformationIcon")
		icon:ClearAllPoints()
		icon:Point("LEFT", anchorFrame, "RIGHT", num == 1 and 6 or 1, 0)
		icon:Show()
		anchorFrame = icon
	elseif not enchantID and EnchantParts[itemframe.index] and EnchantParts[itemframe.index][1] then
		if not (qty == 6 and (itemframe.index == 2 or itemframe.index == 16 or itemframe.index == 17)) then
			num = num + 1
			icon = GetIconFrame(frame)
			icon.title = ENCHANTS .. ": " .. (_G[EnchantParts[itemframe.index][2]] or EnchantParts[itemframe.index][2])
			icon.bg:SetVertexColor(1, 0.2, 0.2, 0.6)
			icon.texture:SetTexture("Interface\\Cursor\\Quest") --QuestRepeatable
			icon:ClearAllPoints()
			icon:Point("LEFT", anchorFrame, "RIGHT", num == 1 and 6 or 1, 0)
			icon:Show()
			anchorFrame = icon
		end
	end

	return num * 18
end

local function ShowInspectItemStatsFrame(frame, unit)
	if not frame.expandButton then
		local expandButton = CreateFrame("Button", nil, frame)
		expandButton:Size(12, 12)
		expandButton:Point("TOPRIGHT", -5, -5)
		expandButton:SetNormalTexture("Interface\\Cursor\\Item")
		expandButton:GetNormalTexture():SetTexCoord(12 / 32, 0, 0, 12 / 32)
		expandButton:SetScript("OnClick", function(self)
			local parent = self:GetParent()
			ToggleFrame(parent.statsFrame)
			if parent.statsFrame:IsShown() then
				ShowInspectItemStatsFrame(parent, parent.unit)
			end
		end)
		frame.expandButton = expandButton
	end
	if not frame.statsFrame then
		local statsFrame = CreateFrame("Frame", nil, frame)
		statsFrame:CreateBackdrop("Transparent")
		S:CreateShadowModule(statsFrame.backdrop)
		S:MerathilisUISkin(statsFrame.backdrop)
		statsFrame:Size(197, 157)
		statsFrame:Point("TOPLEFT", frame, "TOPRIGHT", 5, 0)
		for i = 1, 30 do
			statsFrame["stat" .. i] = CreateFrame("FRAME", nil, statsFrame, "CharacterStatFrameTemplate")
			statsFrame["stat" .. i]:EnableMouse(false)
			statsFrame["stat" .. i]:SetWidth(197)
			statsFrame["stat" .. i]:Point("TOPLEFT", 0, -17 * i + 13)
			statsFrame["stat" .. i].Background:SetVertexColor(0, 0, 0)
			statsFrame["stat" .. i].Value:Point("RIGHT", -64, 0)
			statsFrame["stat" .. i].PlayerValue =
				statsFrame["stat" .. i]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
			statsFrame["stat" .. i].PlayerValue:Point("LEFT", statsFrame["stat" .. i], "RIGHT", -54, 0)
			F.SetFontWithDB(statsFrame["stat" .. i].Label, IL.db.statsText)
			F.SetFontWithDB(statsFrame["stat" .. i].Value, IL.db.statsText)
			F.SetFontWithDB(statsFrame["stat" .. i].PlayerValue, IL.db.statsText)
		end
		local mask = statsFrame:CreateTexture()
		mask:SetTexture("Interface\\Buttons\\WHITE8X8")
		mask:Point("TOPLEFT", statsFrame.backdrop, "TOPRIGHT", -60, 0)
		mask:Point("BOTTOMRIGHT", statsFrame.backdrop, "BOTTOMRIGHT", 0, 0)
		mask:SetBlendMode("ADD")
		mask:SetVertexColor(1, 1, 1)
		mask:SetAlpha(0.2)

		if MF and MF.db and MF.db.enable then
			MF:HandleFrame(statsFrame.backdrop, frame.MoveFrame or frame)
			statsFrame.MoveFrame = statsFrame.backdrop.MoveFrame
		end

		frame.statsFrame = statsFrame
	elseif IL.db and IL.db.levelText and IL.db.equipText then
		for i = 1, 30 do
			F.SetFontWithDB(frame.statsFrame["stat" .. i].Label, IL.db.statsText)
			F.SetFontWithDB(frame.statsFrame["stat" .. i].Value, IL.db.statsText)
			F.SetFontWithDB(frame.statsFrame["stat" .. i].PlayerValue, IL.db.statsText)
		end
	end

	if not frame.statsFrame:IsShown() then
		return
	end
	local inspectStats, playerStats = {}, {}
	local _, inspectItemLevel = LibItemInfo:GetUnitItemLevel(unit, inspectStats)
	local _, playerItemLevel = LibItemInfo:GetUnitItemLevel("player", playerStats)
	local baseInfo = {}
	tinsert(baseInfo, { label = LEVEL, iv = UnitLevel(unit), pv = UnitLevel("player") })
	tinsert(baseInfo, {
		label = HEALTH,
		iv = AbbreviateLargeNumbers(UnitHealthMax(unit)),
		pv = AbbreviateLargeNumbers(UnitHealthMax("player")),
	})
	tinsert(
		baseInfo,
		{ label = STAT_AVERAGE_ITEM_LEVEL, iv = format("%.1f", inspectItemLevel), pv = format("%.1f", playerItemLevel) }
	)
	local index = 1
	for _, v in pairs(baseInfo) do
		frame.statsFrame["stat" .. index].Label:SetText(v.label)
		frame.statsFrame["stat" .. index].Label:SetTextColor(0.2, 1, 1)
		frame.statsFrame["stat" .. index].Value:SetText(v.iv)
		frame.statsFrame["stat" .. index].Value:SetTextColor(0, 0.7, 0.9)
		frame.statsFrame["stat" .. index].PlayerValue:SetText(v.pv)
		frame.statsFrame["stat" .. index].PlayerValue:SetTextColor(0, 0.7, 0.9)
		frame.statsFrame["stat" .. index].Background:SetShown(index % 2 ~= 0)
		frame.statsFrame["stat" .. index]:Show()
		index = index + 1
	end
	for k, v in pairs(inspectStats) do
		if v.r + v.g + v.b < 1.2 then
			frame.statsFrame["stat" .. index].Label:SetText(k)
			frame.statsFrame["stat" .. index].Label:SetTextColor(v.r, v.g, v.b)
			frame.statsFrame["stat" .. index].Value:SetText(GetStateValue(unit, k, v.value))
			frame.statsFrame["stat" .. index].Value:SetTextColor(v.r, v.g, v.b)
			frame.statsFrame["stat" .. index].PlayerValue:SetText(
				GetStateValue("player", k, playerStats[k] and playerStats[k].value, "-")
			)
			frame.statsFrame["stat" .. index].PlayerValue:SetTextColor(v.r, v.g, v.b)
			frame.statsFrame["stat" .. index].Background:SetShown(index % 2 ~= 0)
			frame.statsFrame["stat" .. index]:Show()
			index = index + 1
		end
	end
	for k, v in pairs(playerStats) do
		if not inspectStats[k] and v.r + v.g + v.b < 1.2 then
			frame.statsFrame["stat" .. index].Label:SetText(k)
			frame.statsFrame["stat" .. index].Label:SetTextColor(v.r, v.g, v.b)
			frame.statsFrame["stat" .. index].Value:SetText("-")
			frame.statsFrame["stat" .. index].Value:SetTextColor(v.r, v.g, v.b)
			frame.statsFrame["stat" .. index].PlayerValue:SetText(GetStateValue("player", k, v.value))
			frame.statsFrame["stat" .. index].PlayerValue:SetTextColor(v.r, v.g, v.b)
			frame.statsFrame["stat" .. index].Background:SetShown(index % 2 ~= 0)
			frame.statsFrame["stat" .. index]:Show()
			index = index + 1
		end
	end
	for k, v in pairs(inspectStats) do
		if v.r + v.g + v.b > 1.2 then
			frame.statsFrame["stat" .. index].Label:SetText(k)
			frame.statsFrame["stat" .. index].Label:SetTextColor(1, 0.82, 0)
			frame.statsFrame["stat" .. index].Value:SetText(v.value)
			frame.statsFrame["stat" .. index].Value:SetTextColor(v.r, v.g, v.b)
			if playerStats[k] then
				frame.statsFrame["stat" .. index].PlayerValue:SetText(playerStats[k].value)
				frame.statsFrame["stat" .. index].PlayerValue:SetTextColor(
					playerStats[k].r,
					playerStats[k].g,
					playerStats[k].b
				)
			else
				frame.statsFrame["stat" .. index].PlayerValue:SetText("-")
			end
			frame.statsFrame["stat" .. index].Background:SetShown(index % 2 ~= 0)
			frame.statsFrame["stat" .. index]:Show()
			index = index + 1
		end
	end
	for k, v in pairs(playerStats) do
		if not inspectStats[k] and v.r + v.g + v.b > 1.2 then
			local f = frame.statsFrame["stat" .. index]
			if f then
				f.Label:SetText(k)
				f.Label:SetTextColor(1, 0.82, 0)
				f.Value:SetText("-")
				f.Value:SetTextColor(v.r, v.g, v.b)
				f.PlayerValue:SetText(v.value)
				f.PlayerValue:SetTextColor(v.r, v.g, v.b)
				f.Background:SetShown(index % 2 ~= 0)
				f:Show()
			end
			index = index + 1
		end
	end
	frame.statsFrame:SetHeight(index * 17 - 10)
	while frame.statsFrame["stat" .. index] do
		frame.statsFrame["stat" .. index]:Hide()
		index = index + 1
	end
end

-- Gem Plugin
local function Plugin_GemAndEnchant(unit, parent, itemLevel, maxLevel)
	local frame = parent.inspectFrame
	if not frame then
		return
	end
	local i = 1
	local itemframe
	local width, iconWidth = frame:GetWidth(), 0
	HideAllIconFrame(frame)
	while frame["item" .. i] do
		itemframe = frame["item" .. i]
		iconWidth = ShowGemAndEnchant(frame, itemframe.link, itemframe.itemString, itemframe)
		if width < itemframe.width + iconWidth + 36 then
			width = itemframe.width + iconWidth + 36
		end
		i = i + 1
	end
	if width > frame:GetWidth() then
		frame:SetWidth(width)
	end
end

-- Spec Plugin
local function Plugin_Spec(unit, parent, itemLevel, maxLevel)
	local frame = parent.inspectFrame
	if not frame then
		return
	end
	if not frame.specicon then
		frame.specicon = frame:CreateTexture(nil, "BORDER")
		frame.specicon:SetTexCoord(unpack(E.TexCoords))
		frame.specicon:Size(35)
		frame.specicon:Point("TOPRIGHT", -12, -15)
		frame.specicon:SetAlpha(0.4)
		frame.specicon:CreateBackdrop()
		frame.spectext = frame:CreateFontString(nil, "BORDER")
		F.SetFontWithDB(frame.spectext, {
			name = E.db.general.font,
			size = 10,
			style = "OUTLINE",
		})
		frame.spectext:Point("BOTTOM", frame.specicon, "BOTTOM", 0, 2)
		frame.spectext:SetJustifyH("CENTER")
		frame.spectext:SetAlpha(0.5)
	end
	local _, specID, specName, specIcon
	if unit == "player" then
		specID = GetSpecialization()
		_, specName, _, specIcon = GetSpecializationInfo(specID)
	else
		specID = GetInspectSpecialization(unit)
		_, specName, _, specIcon = GetSpecializationInfoByID(specID)
	end
	if specIcon then
		frame.spectext:SetText(specName)
		frame.specicon:SetTexture(specIcon)
		frame.specicon:Show()
	else
		frame.spectext:SetText("")
		frame.specicon:Hide()
	end
end

-- Stats Plugin
local function Plugin_Stats(unit, parent, itemLevel, maxLevel)
	local frame = parent.inspectFrame
	if not frame then
		return
	end
	if unit == "player" then
		return
	end
	if not IL.db or not IL.db.stats then
		if frame.statsFrame then
			frame.statsFrame:Hide()
		end
		return
	end
	ShowInspectItemStatsFrame(frame, unit)
end

local function RefreshAlign(frame)
	local maxWidth = 0
	for i in ipairs(slots) do
		local itemframe = frame["item" .. i]
		if itemframe then
			local width = itemframe.levelString:GetStringWidth()
			if width > maxWidth then
				maxWidth = width
			end
		end
	end

	if maxWidth > 0 then
		for i in ipairs(slots) do
			local itemframe = frame["item" .. i]
			if itemframe then
				itemframe.levelString:Width(maxWidth + 1)
			end
		end
	end
end

local function GetInspectItemListFrame(parent)
	if not IL.db or not IL.db.enable then
		return
	end
	if not parent.inspectFrame then
		local itemfont = "ChatFontNormal"
		local frame = CreateFrame("Frame", nil, parent)
		local height = parent:GetHeight()
		height = height < 424 and 424 or height

		frame:Size(160, height - 2)
		frame:SetFrameLevel(0)
		frame:Point("LEFT", parent, "RIGHT", 5, 0)
		frame:CreateBackdrop("Transparent")
		S:CreateShadowModule(frame.backdrop)
		S:MerathilisUISkin(frame.backdrop)
		frame.portrait = CreateFrame("Frame", nil, frame, "GarrisonFollowerPortraitTemplate")
		frame.portrait:Point("TOPLEFT", frame, "TOPLEFT", 16, -10)
		frame.portrait:SetScale(0.8)
		local portraitBorder = frame:CreateTexture(nil, "BACKGROUND")
		portraitBorder:SetTexture(W.Media.Textures.inspectGemBG)
		portraitBorder:Point("TOPLEFT", frame.portrait.Portrait, "TOPLEFT", -3, 4)
		portraitBorder:Point("BOTTOMRIGHT", frame.portrait.Portrait, "BOTTOMRIGHT", 4, -4)
		frame.portraitBorder = portraitBorder
		frame.title = frame:CreateFontString(nil, "ARTWORK")
		F.SetFontWithDB(frame.title, {
			name = E.db.general.font,
			size = 16,
			style = "OUTLINE",
		})
		frame.title:Point("TOPLEFT", frame, "TOPLEFT", 66, -14)
		frame.level = frame:CreateFontString(nil, "ARTWORK")
		frame.level:Point("TOPLEFT", frame, "TOPLEFT", 66, -38)
		F.SetFontWithDB(frame.level, {
			name = E.db.general.font,
			size = 14,
			style = "OUTLINE",
		})

		local itemframe
		local backdrop = {
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Buttons\\WHITE8X8",
			tile = true,
			tileSize = 8,
			edgeSize = 1,
			insets = { left = 1, right = 1, top = 1, bottom = 1 },
		}
		for i, v in ipairs(slots) do
			itemframe = CreateFrame("Button", nil, frame, "BackdropTemplate")
			itemframe:Size(120, (height - 82) / #slots)
			itemframe.index = v.index
			itemframe.backdrop = backdrop
			if i == 1 then
				itemframe:Point("TOPLEFT", frame, "TOPLEFT", 15, -70)
			else
				itemframe:Point("TOPLEFT", frame["item" .. (i - 1)], "BOTTOMLEFT")
			end
			itemframe.label = CreateFrame("Frame", nil, itemframe, "BackdropTemplate")
			itemframe.label:Size(38, 18)
			itemframe.label:Point("LEFT")
			itemframe.label:SetBackdrop(backdrop)
			itemframe.label:SetBackdropBorderColor(0, 0.9, 0.9, 0.2)
			itemframe.label:SetBackdropColor(0, 0.9, 0.9, 0.2)
			itemframe.label.text = itemframe.label:CreateFontString(nil, "ARTWORK")
			if IL.db and IL.db.equipText then
				F.SetFontWithDB(itemframe.label.text, IL.db.slotText)
			end
			itemframe.label.text:Size(34, 14)
			itemframe.label.text:Point("CENTER", 1, 0)
			itemframe.label.text:SetText(v.name)
			itemframe.label.text:SetTextColor(0, 0.9, 0.9)
			itemframe.levelString = itemframe:CreateFontString(nil, "ARTWORK")
			if IL.db and IL.db.levelText then
				F.SetFontWithDB(itemframe.levelString, IL.db.levelText)
			end

			itemframe.levelString:Point("LEFT", itemframe.label, "RIGHT", 4, 0)
			itemframe.levelString:SetJustifyH("RIGHT")
			itemframe.itemString = itemframe:CreateFontString(nil, "ARTWORK")
			if IL.db and IL.db.equipText then
				F.SetFontWithDB(itemframe.itemString, IL.db.equipText)
			end
			itemframe.itemString:SetHeight(16)
			itemframe.itemString:Point("LEFT", itemframe.levelString, "RIGHT", 2, 0)
			itemframe:SetScript("OnEnter", function(self)
				local r, g, b, a = self.label:GetBackdropColor()
				if a then
					self.label:SetBackdropColor(r, g, b, a + 0.5)
				end
				if self.link or (self.level and self.level > 0) then
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:SetInventoryItem(self:GetParent().unit, self.index)
					GameTooltip:Show()
				end
			end)
			itemframe:SetScript("OnLeave", function(self)
				local r, g, b, a = self.label:GetBackdropColor()
				if a then
					self.label:SetBackdropColor(r, g, b, abs(a - 0.5))
				end
				GameTooltip:Hide()
			end)
			itemframe:SetScript("OnDoubleClick", function(self)
				if self.link then
					_G.ChatEdit_ActivateChat(_G.ChatEdit_ChooseBoxForSend())
					_G.ChatEdit_InsertLink(self.link)
				end
			end)
			frame["item" .. i] = itemframe
			LibEvent:trigger("INSPECT_ITEMFRAME_CREATED", itemframe)
		end

		frame.closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton, BackdropTemplate")
		frame.closeButton:Point("TOPRIGHT", frame.backdrop, "TOPRIGHT", 5, 5)
		S:Proxy("HandleCloseButton", frame.closeButton)
		frame.closeButton:SetScript("OnClick", function(self)
			self:GetParent():Hide()
		end)

		parent:HookScript("OnHide", function(self)
			frame:Hide()
		end)

		if MF and MF.db and MF.db.enable then
			MF:HandleFrame(frame.backdrop, parent.MoveFrame or parent)
			frame.MoveFrame = frame.backdrop.MoveFrame
		end

		parent.inspectFrame = frame
		LibEvent:trigger("INSPECT_FRAME_CREATED", frame, parent)
	else
		for i in ipairs(slots) do
			local itemframe = parent.inspectFrame["item" .. i]
			if itemframe and IL.db then
				if IL.db then
					F.SetFontWithDB(itemframe.label.text, IL.db.slotText)
					F.SetFontWithDB(itemframe.levelString, IL.db.levelText)
					F.SetFontWithDB(itemframe.itemString, IL.db.equipText)
				end
			end
		end

		RefreshAlign(parent.inspectFrame)
	end

	E:Delay(0.2, RefreshAlign, parent.inspectFrame)

	return parent.inspectFrame
end

local function ShowInspectItemListFrame(unit, parent, ilevel, maxLevel)
	if not IL.db or not IL.db.enable then
		return
	end

	if not parent:IsShown() then
		return
	end

	local frame = GetInspectItemListFrame(parent)
	local class = select(2, UnitClass(unit))
	local color = RAID_CLASS_COLORS[class] or NORMAL_FONT_COLOR
	frame.unit = unit
	frame.portrait:SetLevel(UnitLevel(unit))
	frame.portrait:StripTextures()
	SetPortraitTexture(frame.portrait.Portrait, unit)
	if frame.portraitBorder then
		frame.portraitBorder:SetVertexColor(color.r, color.g, color.b)
	end
	frame:CreateBackdrop("Transparent")
	F.SetFontWithDB(frame.portrait.Level, {
		name = F.GetCompatibleFont("Montserrat"),
		size = 16,
		style = "OUTLINE",
	})
	frame.portrait.Level:ClearAllPoints()
	frame.portrait.Level:Point("BOTTOMRIGHT", frame.portrait, "BOTTOMRIGHT")

	frame.title:SetText(UnitName(unit))
	frame.title:SetTextColor(color.r, color.g, color.b)
	frame.level:SetText(format("%s %0d", L["Item Level"], ilevel))
	frame.level:SetTextColor(1, 0.82, 0)
	local _, name, level, link, quality
	local itemframe, mframe, oframe, itemwidth
	local width = 160
	local formats = "%3s"
	if maxLevel then
		formats = "%" .. strlen(floor(maxLevel)) .. "s"
	end
	for i, v in ipairs(slots) do
		_, level, name, link, quality = LibItemInfo:GetUnitItemInfo(unit, v.index)
		itemframe = frame["item" .. i]
		itemframe.name = name
		itemframe.link = link
		itemframe.level = level
		itemframe.quality = quality
		itemframe.itemString:SetWidth(0)
		if level > 0 then
			itemframe.levelString:SetText(format(formats, level))
			itemframe.itemString:SetText(link or name)
		else
			itemframe.levelString:SetText(format(formats, ""))
			itemframe.itemString:SetText("")
		end
		if link and C_Item_IsCorruptedItem(link) then
			itemframe.levelString:SetTextColor(0.5, 0.5, 1)
		else
			itemframe.levelString:SetTextColor(1, 1, 1)
		end
		itemwidth = itemframe.itemString:GetWidth()
		if itemwidth > 208 then
			itemwidth = 208
			itemframe.itemString:SetWidth(itemwidth)
		end
		itemframe.width = itemwidth + max(64, floor(itemframe.label:GetWidth() + itemframe.levelString:GetWidth()) + 4)
		itemframe:SetWidth(itemframe.width)
		if width < itemframe.width then
			width = itemframe.width
		end
		if v.index == 16 then
			mframe = itemframe
			mframe:SetAlpha(1)
		elseif v.index == 17 then
			oframe = itemframe
			oframe:SetAlpha(1)
		end
		LibEvent:trigger("INSPECT_ITEMFRAME_UPDATED", itemframe)
	end
	if mframe and oframe and (mframe.quality == 6 or oframe.quality == 6) then
		level = max(mframe.level, oframe.level)
		if mframe.link then
			mframe.levelString:SetText(format(formats, level))
		end
		if oframe.link then
			oframe.levelString:SetText(format(formats, level))
		end
	end
	if mframe and mframe.level <= 0 then
		mframe:SetAlpha(0.4)
	end
	if oframe and oframe.level <= 0 then
		oframe:SetAlpha(0.4)
	end
	frame:SetWidth(width + 36)
	frame:Show()

	LibEvent:trigger("INSPECT_FRAME_SHOWN", frame, parent, ilevel)
	Plugin_Spec(unit, parent, ilevel, maxLevel)
	Plugin_GemAndEnchant(unit, parent, ilevel, maxLevel)
	if W.Locale == "koKR" or W.Locale == "enUS" or W.Locale == "zhCN" or W.Locale == "zhTW" then
		Plugin_Stats(unit, parent, ilevel, maxLevel)
	end

	return frame
end

function IL:Inspect()
	hooksecurefunc("ClearInspectPlayer", function()
		inspecting = false
	end)

	-- @trigger UNIT_INSPECT_STARTED
	hooksecurefunc("NotifyInspect", function(unit)
		local guid = UnitGUID(unit)
		if not guid then
			return
		end
		local data = guids[guid]
		if data then
			data.unit = unit
			data.name, data.realm = UnitName(unit)
		else
			data = {
				unit = unit,
				guid = guid,
				class = select(2, UnitClass(unit)),
				level = UnitLevel(unit),
				ilevel = -1,
				spec = nil,
				hp = UnitHealthMax(unit),
				timer = time(),
			}
			data.name, data.realm = UnitName(unit)
			guids[guid] = data
		end
		if not data.realm then
			data.realm = GetRealmName()
		end
		data.expired = time() + 3
		inspecting = data
		LibEvent:trigger("UNIT_INSPECT_STARTED", data)
	end)

	-- @trigger UNIT_INSPECT_READY
	LibEvent:attachEvent("INSPECT_READY", function(this, guid)
		if not guids[guid] then
			return
		end
		LibSchedule:AddTask({
			identity = guid,
			timer = 0.5,
			elasped = 0.8,
			expired = GetTime() + 4,
			data = guids[guid],
			onTimeout = function(self)
				inspecting = false
			end,
			onExecute = function(self)
				local count, ilevel, _, weaponLevel, isArtifact, maxLevel = LibItemInfo:GetUnitItemLevel(self.data.unit)
				if ilevel <= 0 then
					return true
				end
				if count == 0 and ilevel > 0 then
					--if (UnitIsVisible(self.data.unit) or self.data.ilevel == ilevel) then
					self.data.timer = time()
					self.data.name = UnitName(self.data.unit)
					self.data.class = select(2, UnitClass(self.data.unit))
					self.data.ilevel = ilevel
					self.data.maxLevel = maxLevel
					self.data.spec = GetInspectSpec(self.data.unit)
					self.data.hp = UnitHealthMax(self.data.unit)
					self.data.weaponLevel = weaponLevel
					self.data.isArtifact = isArtifact
					LibEvent:trigger("UNIT_INSPECT_READY", self.data)
					inspecting = false
					return true
					--else
					--    self.data.ilevel = ilevel
					--    self.data.maxLevel = maxLevel
					--end
				end
			end,
		})
	end)

	--裝備變更時
	LibEvent:attachEvent("UNIT_INVENTORY_CHANGED", function(_, unit)
		if _G.InspectFrame and _G.InspectFrame.unit and _G.InspectFrame.unit == unit then
			ReInspect(unit)
		end
	end)

	--@see InspectCore.lua
	LibEvent:attachTrigger("UNIT_INSPECT_READY, UNIT_REINSPECT_READY", function(_, data)
		if not self.db or not self.db.inspect then
			return
		end
		if _G.InspectFrame and _G.InspectFrame.unit and UnitGUID(_G.InspectFrame.unit) == data.guid then
			local frame = ShowInspectItemListFrame(_G.InspectFrame.unit, _G.InspectFrame, data.ilevel, data.maxLevel)
			LibEvent:trigger("INSPECT_FRAME_COMPARE", frame)
		end
	end)

	--高亮橙裝和武器
	LibEvent:attachTrigger("INSPECT_ITEMFRAME_UPDATED", function(self, itemframe)
		local r, g, b = 0, 0.9, 0.9
		if itemframe.quality and itemframe.quality > 4 then
			r, g, b = C_Item_GetItemQualityColor(itemframe.quality)
		elseif itemframe.name and not itemframe.link then
			r, g, b = 0.9, 0.8, 0.4
		elseif not itemframe.link then
			r, g, b = 0.5, 0.5, 0.5
		end
		itemframe.label:SetBackdropBorderColor(r, g, b, 0.2)
		itemframe.label:SetBackdropColor(r, g, b, 0.2)
		itemframe.label.text:SetTextColor(r, g, b)
	end)

	--自己裝備列表
	LibEvent:attachTrigger("INSPECT_FRAME_COMPARE", function(_, frame)
		if not frame then
			return
		end
		if self.db and self.db.playerOnInspect then
			local _, ilevel, _, _, _, maxLevel = LibItemInfo:GetUnitItemLevel("player")
			local playerFrame = ShowInspectItemListFrame("player", frame, ilevel, maxLevel)
			if frame.statsFrame then
				frame.statsFrame:SetParent(playerFrame)
			end
		elseif frame.statsFrame then
			frame.statsFrame:SetParent(frame)
		end
		if frame.statsFrame then
			frame.statsFrame:Point("TOPLEFT", frame.statsFrame:GetParent(), "TOPRIGHT", 5, 0)
		end
	end)
end

function IL:Player()
	_G.PaperDollFrame:HookScript("OnShow", function(frame)
		if not self.db or not self.db.player then
			return
		end
		local _, ilevel, _, _, _, maxLevel = LibItemInfo:GetUnitItemLevel("player")
		ShowInspectItemListFrame("player", frame, ilevel, maxLevel)
	end)

	LibEvent:attachEvent("PLAYER_EQUIPMENT_CHANGED", function()
		if not self.db or not self.db.player or not _G.CharacterFrame:IsShown() then
			return
		end
		local _, ilevel, _, _, _, maxLevel = LibItemInfo:GetUnitItemLevel("player")
		ShowInspectItemListFrame("player", _G.PaperDollFrame, ilevel, maxLevel)
	end)
end

function IL:Initialize()
	self.db = E.db.WT.item.inspect

	if C_AddOns_IsAddOnLoaded("TinyInspect") then
		self.StopRunning = "TinyInspect"
		return
	end

	if not self.db.enable or self.initialized then
		return
	end

	self:Player()
	self:Inspect()

	self.initialized = true
end

IL.ProfileUpdate = IL.Initialize

W:RegisterModule(IL:GetName())
