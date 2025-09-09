local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local I = W:NewModule("Inspect", "AceEvent-3.0", "AceHook-3.0") ---@class Inspect: AceModule, AceEvent-3.0, AceHook-3.0
local C = W.Utilities.Color
local S = W.Modules.Skins ---@type Skins
local MF = W.Modules.MoveFrames ---@type MoveFrames

-- Modified from TinyInspect

local LibEvent = LibStub:GetLibrary("LibEvent.7000")
local LibItemInfo = LibStub:GetLibrary("LibItemInfo.7000")
local LibSchedule = LibStub:GetLibrary("LibSchedule.7000")

local _G = _G
local floor = floor
local format = format
local gsub = gsub
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local max = max
local pairs = pairs
local select = select
local time = time
local tinsert = tinsert
local unpack = unpack

local AbbreviateLargeNumbers = AbbreviateLargeNumbers
local CreateFrame = CreateFrame
local GetInspectSpecialization = GetInspectSpecialization
local GetInventoryItemLink = GetInventoryItemLink
local GetRealmName = GetRealmName
local GetSpecializationInfoByID = GetSpecializationInfoByID
local GetTime = GetTime
local SetPortraitTexture = SetPortraitTexture
local ToggleFrame = ToggleFrame
local UnitClass = UnitClass
local UnitGUID = UnitGUID
local UnitHealthMax = UnitHealthMax
local UnitLevel = UnitLevel
local UnitName = UnitName
local GetServerExpansionLevel = GetServerExpansionLevel

local HEALTH = HEALTH
local LEVEL = LEVEL
local STAT_AVERAGE_ITEM_LEVEL = STAT_AVERAGE_ITEM_LEVEL

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_Item_GetItemInfo = C_Item.GetItemInfo
local C_Item_GetItemQualityColor = C_Item.GetItemQualityColor
local C_Item_IsCorruptedItem = C_Item.IsCorruptedItem
local C_SpecializationInfo_GetSpecialization = C_SpecializationInfo.GetSpecialization
local C_SpecializationInfo_GetSpecializationInfo = C_SpecializationInfo.GetSpecializationInfo

local Enum_ItemQuality_Common = Enum.ItemQuality.Common

local guids, inspecting = {}, false

local LABEL_COLOR = C.GetRGBFromTemplate("cyan-300")
local CURRENT_EXPANSION_ID = GetServerExpansionLevel()

local DISPLAY_SLOTS = {}
for slotIndex, slotName in ipairs(W.EquipmentSlots) do
	-- Exclude Shirt, Tabard, Ranged
	if not tContains({ 4, 18, 19 }, slotIndex) then
		tinsert(DISPLAY_SLOTS, { index = slotIndex, name = gsub(slotName, "%d", "") })
	end
end

---@class InspectItemInfo
---@field level number?
---@field link string?
---@field name string?
---@field quality Enum.ItemQuality?
---@field set number?
---@field subType string?
---@field texture string?
---@field type string?

---Gets item information for a specific inventory slot of a unit
---@param unit any The unit to inspect
---@param slotIndex any The inventory slot index
---@return InspectItemInfo? The item information, or nil if no item is found
local function GetUnitSlotItemInfo(unit, slotIndex)
	local link = GetInventoryItemLink(unit, slotIndex)
	if not link then
		return
	end

	local name, _, quality, level, _, type, subType, _, itemEquipLoc, tex, _, _, _, _, expansionID, set, isCraftingReagent =
		C_Item_GetItemInfo(link)

	local craftingAtlas
	local cleanLink = gsub(link, "|h%[(.+)%]|h", function(raw)
		local name = gsub(raw, "(%s*)(|A:.-|a)", function(_, atlasString)
			craftingAtlas = gsub(atlasString, "|A:(.-):%d+:%d+::%d+|a", "%1")
			return ""
		end)
		return "|h" .. name .. "|h"
	end)

	return {
		cleanLink = cleanLink,
		craftingAtlas = craftingAtlas,
		expansionID = expansionID,
		isCraftingReagent = isCraftingReagent,
		level = level,
		link = link,
		name = name,
		quality = quality,
		set = set,
		subType = subType,
		texture = tex,
		type = type,
	}
end

local function GetUnitSpecializationInfo(unit)
	if unit == "player" then
		local _, name, _, icon = C_SpecializationInfo_GetSpecializationInfo(C_SpecializationInfo_GetSpecialization())
		return { icon = icon, name = name }
	end

	local _, name, _, icon = GetSpecializationInfoByID(GetInspectSpecialization(unit))
	return { icon = icon, name = name }
end

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
			local itemLevel = E:GetUnitItemLevel("player")
			if itemLevel <= 0 then
				return true
			end
			if itemLevel > 0 then
				self.data.itemLevel = itemLevel
				LibEvent:trigger("UNIT_REINSPECT_READY", self.data)
				return true
			end
		end,
	})
end

local function GetInspectSpec(unit)
	local specID, specName
	if unit == "player" then
		specID = C_SpecializationInfo_GetSpecialization()
		specName = select(2, C_SpecializationInfo_GetSpecializationInfo(specID))
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
local function ShowInspectItemStatsFrame(frame, unit)
	if not frame.expandButton then
		local expandButton = CreateFrame("Button", nil, frame)
		expandButton:Size(12, 12)
		expandButton:Point("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
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
		statsFrame:SetTemplate("Transparent")
		S:CreateShadowModule(statsFrame)
		S:MerathilisUISkin(statsFrame)
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
			F.SetFontWithDB(statsFrame["stat" .. i].Label, I.db.statsText)
			F.SetFontWithDB(statsFrame["stat" .. i].Value, I.db.statsText)
			F.SetFontWithDB(statsFrame["stat" .. i].PlayerValue, I.db.statsText)
		end
		local mask = statsFrame:CreateTexture()
		mask:SetTexture("Interface\\Buttons\\WHITE8X8")
		mask:Point("TOPLEFT", statsFrame, "TOPRIGHT", -60, 0)
		mask:Point("BOTTOMRIGHT", statsFrame, "BOTTOMRIGHT", 0, 0)
		mask:SetBlendMode("ADD")
		mask:SetVertexColor(1, 1, 1)
		mask:SetAlpha(0.2)

		MF:InternalHandle(statsFrame, frame.MoveFrame or frame)

		frame.statsFrame = statsFrame
	elseif I.db and I.db.levelText and I.db.equipText then
		for i = 1, 30 do
			F.SetFontWithDB(frame.statsFrame["stat" .. i].Label, I.db.statsText)
			F.SetFontWithDB(frame.statsFrame["stat" .. i].Value, I.db.statsText)
			F.SetFontWithDB(frame.statsFrame["stat" .. i].PlayerValue, I.db.statsText)
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

function I:BuildInspectItemListFrame(parent)
	local frame = CreateFrame("Frame", nil, parent)
	local height = parent:GetHeight()

	-- Frame
	frame:Size(160, height)
	frame:SetFrameLevel(0)
	frame:Point("LEFT", parent, "RIGHT", 5, 0)
	frame:SetTemplate("Transparent")
	S:CreateShadowModule(frame)
	S:MerathilisUISkin(frame)

	frame.CloseButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton, BackdropTemplate") --[[@as Button]]
	frame.CloseButton:Point("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
	S:Proxy("HandleCloseButton", frame.CloseButton)
	frame.CloseButton:SetScript("OnClick", function(self)
		self:GetParent():Hide()
	end)

	hooksecurefunc(parent, "Hide", function()
		frame:Hide()
	end)

	MF:InternalHandle(frame, parent.MoveFrame or parent)

	-- Portrait
	frame.PortraitFrame = CreateFrame("Frame", nil, frame, "GarrisonFollowerPortraitTemplate") --[[@as GarrisonFollowerPortraitMixin]]
	frame.PortraitFrame:StripTextures()
	frame.PortraitFrame:Point("TOPLEFT", frame, "TOPLEFT", 16, -12)
	frame.PortraitFrame:SetScale(0.9)

	F.SetFontOutline(frame.PortraitFrame.Level, F.GetCompatibleFont("Chivo Mono"), 18)
	frame.PortraitFrame.Level:ClearAllPoints()
	frame.PortraitFrame.Level:Point("BOTTOMRIGHT", frame.PortraitFrame, "BOTTOMRIGHT")
	frame.PortraitFrame.LevelBorder:SetAlpha(0)

	frame.PortraitBorder = frame:CreateTexture(nil, "BORDER")
	frame.PortraitBorder:SetTexture(W.Media.Textures.round)
	frame.PortraitBorder:Size(49)
	frame.PortraitBorder:Point("CENTER", frame.PortraitFrame.Portrait)

	-- Player Information
	frame.PlayerName = frame:CreateFontString(nil, "ARTWORK")
	frame.PlayerItemLevel = frame:CreateFontString(nil, "ARTWORK")
	F.SetFontOutline(frame.PlayerName, E.db.general.font, 18)
	F.SetFontOutline(frame.PlayerItemLevel, E.db.general.font, 14)
	frame.PlayerItemLevel:SetTextColor(C.ExtractRGBFromTemplate("amber-400"))
	frame.PlayerName:Point("TOPLEFT", frame, "TOPLEFT", 75, -17)
	frame.PlayerItemLevel:Point("TOPLEFT", frame, "TOPLEFT", 75, -42)

	frame.SpecIcon = frame:CreateTexture(nil, "ARTWORK")
	frame.SpecIcon:Size(38, 38)
	frame.SpecIcon:Point("TOPRIGHT", frame, "TOPRIGHT", -28, -17)
	frame.SpecIcon:SetTexCoord(unpack(E.TexCoords))
	frame.SpecIcon:SetShown(false)
	frame.SpecIcon:CreateBackdrop()

	frame.SpecIcon:SetScript("OnEnter", function()
		if frame.specName and frame.specName ~= "" then
			_G.GameTooltip:SetOwner(frame, "ANCHOR_CURSOR", 0, 0)
			_G.GameTooltip:SetText(frame.specName, 1, 1, 1)
			_G.GameTooltip:Show()
		end
	end)

	frame.SpecIcon:SetScript("OnLeave", function()
		_G.GameTooltip:Hide()
	end)

	-- Lines
	frame.Lines = {}
	frame.lineHeight = (height - 82) / #DISPLAY_SLOTS
	frame.maxLabelTextWidth, frame.maxItemLevelTextWidth, frame.maxItemNameTextWidth = 30, 0, 0

	for displayIndex, slotInfo in ipairs(DISPLAY_SLOTS) do
		-- Line
		local line = CreateFrame("Button", nil, frame, "BackdropTemplate")
		line:Size(160, frame.lineHeight)
		line.index = slotInfo.index
		if displayIndex == 1 then
			line:Point("TOPLEFT", frame, "TOPLEFT", 15, -70)
		else
			line:Point("TOPLEFT", frame.Lines[displayIndex - 1], "BOTTOMLEFT")
		end
		frame.Lines[displayIndex] = line

		-- Label
		line.Label = CreateFrame("Frame", nil, line, "BackdropTemplate")
		line.Label:Size(38, 18)
		line.Label:Point("LEFT")
		line.Label:SetTemplate()
		line.Label:SetBackdropBorderColor(LABEL_COLOR.r, LABEL_COLOR.g, LABEL_COLOR.b, 0.5)
		line.Label:SetBackdropColor(LABEL_COLOR.r, LABEL_COLOR.g, LABEL_COLOR.b, 0.2)

		line.Label.Text = line.Label:CreateFontString(nil, "ARTWORK")
		F.SetFontWithDB(line.Label.Text, self.db.slotText)
		line.Label.Text:Point("CENTER", 1, 0)
		line.Label.Text:SetText(slotInfo.name)
		line.Label.Text:Height(self.db.slotText.size + 2)
		local textWidth = line.Label.Text:GetStringWidth() + 4
		frame.maxLabelTextWidth = max(frame.maxLabelTextWidth, textWidth)
		line.Label.Text:Width(textWidth)
		line.Label.Text:SetTextColor(LABEL_COLOR.r, LABEL_COLOR.g, LABEL_COLOR.b, 0.8)

		-- Item Level
		line.ItemLevel = line:CreateFontString(nil, "ARTWORK")
		F.SetFontWithDB(line.ItemLevel, self.db.levelText)
		line.ItemLevel:Point("LEFT", line.Label, "RIGHT", 4, 0)
		line.ItemLevel:SetJustifyH("RIGHT")

		-- Item Texture
		line.ItemTextureFrame = CreateFrame("Frame", nil, line, "BackdropTemplate")
		line.ItemTextureFrame.Texture = line.ItemTextureFrame:CreateTexture(nil, "ARTWORK")
		frame.iconHeight = frame.lineHeight - 5
		frame.iconWidth = floor((frame.iconHeight / 0.8) + 0.5)
		line.ItemTextureFrame:Size(frame.iconWidth, frame.iconHeight)
		line.ItemTextureFrame:Point("LEFT", line.ItemLevel, "RIGHT", 4, 0)
		line.ItemTextureFrame.Texture:SetInside(line.ItemTextureFrame)
		line.ItemTextureFrame.Texture:SetTexCoord(
			E:CropRatio(line.ItemTextureFrame.Texture:GetWidth(), line.ItemTextureFrame.Texture:GetHeight())
		)
		line.ItemTextureFrame:SetTemplate()

		line.ItemTextureFrame.SpecialIndicator = line.ItemTextureFrame:CreateFontString(nil, "OVERLAY")
		F.SetFontOutline(line.ItemTextureFrame.SpecialIndicator, F.GetCompatibleFont("Chivo Mono"), 20)
		line.ItemTextureFrame.SpecialIndicator:Point("CENTER", line.ItemTextureFrame.Texture, "TOPRIGHT", 1, -2)

		-- Item Name
		line.ItemName = line:CreateFontString(nil, "ARTWORK")
		F.SetFontWithDB(line.ItemName, self.db.equipText)
		line.ItemName:Height(self.db.equipText.size + 2)
		line.ItemName:Point("LEFT", line.ItemTextureFrame, "RIGHT", 6, -1)
		line.ItemName:SetJustifyH("LEFT")

		-- Tooltips
		line:SetScript("OnEnter", function(this)
			this.Label:SetBackdropColor(LABEL_COLOR.r, LABEL_COLOR.g, LABEL_COLOR.b, 0.7)
			this.Label:SetBackdropBorderColor(LABEL_COLOR.r, LABEL_COLOR.g, LABEL_COLOR.b, 1)
			if this.link or (this.level and this.level > 0) then
				_G.GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT", 15, 30)
				_G.GameTooltip:SetInventoryItem(this:GetParent().unit, this.index)
				_G.GameTooltip:Show()
			end
		end)

		line:SetScript("OnLeave", function(this)
			this.Label:SetBackdropColor(LABEL_COLOR.r, LABEL_COLOR.g, LABEL_COLOR.b, 0.2)
			this.Label:SetBackdropBorderColor(LABEL_COLOR.r, LABEL_COLOR.g, LABEL_COLOR.b, 0.5)
			_G.GameTooltip:Hide()
		end)

		line:SetScript("OnDoubleClick", function(this)
			if this.link then
				_G.ChatEdit_ActivateChat(_G.ChatEdit_ChooseBoxForSend())
				_G.ChatEdit_InsertLink(this.link)
			end
		end)
	end

	-- Adjust label width to same
	for _, line in ipairs(frame.Lines) do
		line.Label:Width(frame.maxLabelTextWidth + 6)
	end

	return frame
end

function I:ShowInspectItemListFrame(unit, parent, ilevel)
	if not parent:IsShown() or not self.db or not self.db.enable then
		return
	end

	parent.WindInspectFrame = parent.WindInspectFrame or self:BuildInspectItemListFrame(parent)
	local frame = parent.WindInspectFrame

	frame.unit = unit

	local _, class = UnitClass(unit)
	local classColor = E:ClassColor(class, true) --[[@as ClassColor]]

	frame.PortraitFrame:SetLevel(UnitLevel(unit))
	SetPortraitTexture(frame.PortraitFrame.Portrait, unit)
	frame.PortraitBorder:SetVertexColor(classColor.r, classColor.g, classColor.b)

	frame.PlayerName:SetText(UnitName(unit))
	frame.PlayerName:SetTextColor(classColor.r, classColor.g, classColor.b)
	frame.PlayerItemLevel:SetText(format("%s %0d", L["Item Level"], ilevel))

	local specInfo = GetUnitSpecializationInfo(unit)
	frame.specName = specInfo and specInfo.name
	if specInfo and specInfo.icon then
		frame.SpecIcon.backdrop:SetBackdropBorderColor(classColor.r, classColor.g, classColor.b)
		frame.SpecIcon:SetTexture(specInfo.icon)
		frame.SpecIcon:SetShown(true)
	else
		frame.SpecIcon:SetShown(false)
	end

	for displayIndex, slotInfo in ipairs(DISPLAY_SLOTS) do
		local line = frame.Lines[displayIndex]
		local itemInfo = GetUnitSlotItemInfo(unit, slotInfo.index)

		line.name = itemInfo and itemInfo.name
		line.link = itemInfo and itemInfo.link
		line.level = itemInfo and itemInfo.level
		line.quality = itemInfo and itemInfo.quality
		line.ItemName:SetWidth(0)

		F.SetFontWithDB(line.Label.Text, self.db.slotText)
		line.Label.Text:Height(self.db.slotText.size + 2)
		F.SetFontWithDB(line.ItemLevel, self.db.levelText)
		line.ItemLevel:Height(self.db.levelText.size + 2)
		F.SetFontWithDB(line.ItemName, self.db.equipText)
		line.ItemName:Height(self.db.equipText.size + 2)

		if itemInfo and itemInfo.level > 0 then
			line.ItemLevel:SetText(format("%d", itemInfo.level))
			line.ItemName:SetText(itemInfo.cleanLink or itemInfo.link or itemInfo.name)
		else
			line.ItemLevel:SetText("")
			line.ItemName:SetText(L["Not Equipped"])
		end

		line.ItemTextureFrame:ClearAllPoints()
		if self.db.icon.enable then
			line.ItemTextureFrame:Point("LEFT", line.ItemLevel, "RIGHT", 4, 0)
			if itemInfo and itemInfo.level > 0 then
				line.ItemTextureFrame.Texture:SetTexture(itemInfo.texture)
				local r, g, b = E.db.general.bordercolor.r, E.db.general.bordercolor.g, E.db.general.bordercolor.b
				if self.db.icon.qualityBorder then
					r, g, b = C_Item_GetItemQualityColor(itemInfo.quality or Enum_ItemQuality_Common)
				end
				line.ItemTextureFrame:SetBackdropBorderColor(r, g, b)
				line.ItemTextureFrame:Show()
			else
				line.ItemTextureFrame:Hide()
			end
		else
			line.ItemTextureFrame:Point("RIGHT", line.ItemLevel, "RIGHT", -2, 0)
			line.ItemTextureFrame:Hide()
		end

		if self.db.icon.enable and self.db.icon.specialIndicator and itemInfo then
			if itemInfo.set and itemInfo.set > 0 then
				if itemInfo.expansionID >= CURRENT_EXPANSION_ID then
					line.ItemTextureFrame.SpecialIndicator:SetTextColor(C.ExtractRGBFromTemplate("pink-500"))
				else
					line.ItemTextureFrame.SpecialIndicator:SetTextColor(C.ExtractRGBFromTemplate("gray-400"))
				end
				line.ItemTextureFrame.SpecialIndicator:SetText("*")
				line.ItemTextureFrame.SpecialIndicator:Show()
			elseif itemInfo.craftingAtlas then
				line.ItemTextureFrame.SpecialIndicator:SetText("|A:" .. itemInfo.craftingAtlas .. ":8:8|a")
				line.ItemTextureFrame.SpecialIndicator:Show()
			else
				line.ItemTextureFrame.SpecialIndicator:Hide()
			end
		else
			line.ItemTextureFrame.SpecialIndicator:Hide()
		end

		-- Update colors for some expansion special items
		if itemInfo and itemInfo.link then
			if C_Item_IsCorruptedItem(itemInfo.link) then
				line.ItemLevel:SetTextColor(C.ExtractRGBFromTemplate("indigo-400"))
			else
				line.ItemLevel:SetTextColor(C.ExtractRGBFromTemplate("neutral-100"))
			end
		end

		if slotInfo.index == 16 or slotInfo.index == 17 then
			line:SetAlpha(itemInfo and itemInfo.level > 0 and 1 or 0.4)
		end

		-- Width adjustment for dynamic font size
		local labelTextWidth = line.Label.Text:GetStringWidth() + 3
		frame.maxLabelTextWidth = max(frame.maxLabelTextWidth, labelTextWidth)
		line.Label.Text:Width(labelTextWidth)
		frame.maxItemLevelTextWidth = max(frame.maxItemLevelTextWidth, line.ItemLevel:GetStringWidth() + 3)
		frame.maxItemNameTextWidth = max(frame.maxItemNameTextWidth, line.ItemName:GetStringWidth() + 3)
	end

	local lineWidth = 15
		+ frame.maxLabelTextWidth
		+ 12
		+ frame.maxItemLevelTextWidth
		+ frame.iconWidth
		+ frame.maxItemNameTextWidth
	for _, line in ipairs(frame.Lines) do
		line.Label:Width(frame.maxLabelTextWidth + 6)
		line.ItemLevel:Width(frame.maxItemLevelTextWidth)
		line.ItemName:Width(frame.maxItemNameTextWidth)
		line:Width(lineWidth)
	end

	frame:SetWidth(lineWidth + 24)
	frame:Show()

	-- LibEvent:trigger("INSPECT_FRAME_SHOWN", frame, parent, ilevel)
	-- Plugin_Spec(unit, parent, ilevel, maxLevel)
	-- Plugin_GemAndEnchant(unit, parent, ilevel, maxLevel)
	-- if W.AsianLocale or W.Locale == "enUS" then
	-- 	Plugin_Stats(unit, parent, ilevel, maxLevel)
	-- end

	return frame
end

function I:Inspect()
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
				local ilevel = E:GetUnitItemLevel(self.data.unit)
				if ilevel <= 0 then
					return true
				end
				if ilevel > 0 then
					self.data.timer = time()
					self.data.name = UnitName(self.data.unit)
					self.data.class = select(2, UnitClass(self.data.unit))
					self.data.ilevel = ilevel
					self.data.spec = GetInspectSpec(self.data.unit)
					self.data.hp = UnitHealthMax(self.data.unit)
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
			local frame = self:ShowInspectItemListFrame(_G.InspectFrame.unit, _G.InspectFrame, data.ilevel)
			LibEvent:trigger("INSPECT_FRAME_COMPARE", frame)
		end
	end)

	--自己裝備列表
	LibEvent:attachTrigger("INSPECT_FRAME_COMPARE", function(_, frame)
		if not frame then
			return
		end
		if self.db and self.db.playerOnInspect then
			local ilevel = E:GetUnitItemLevel("player")
			local playerFrame = self:ShowInspectItemListFrame("player", frame, ilevel)
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

function I:Player()
	self:HookScript(_G.PaperDollFrame, "OnShow", function(frame)
		if not self.db or not self.db.player then
			return
		end
		self:ShowInspectItemListFrame("player", frame, E:GetUnitItemLevel("player"))
	end)

	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", function()
		if not self.db or not self.db.player or not _G.CharacterFrame:IsShown() then
			return
		end

		self:ShowInspectItemListFrame("player", _G.PaperDollFrame, E:GetUnitItemLevel("player"))
	end)
end

function I:Initialize()
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

I.ProfileUpdate = I.Initialize

W:RegisterModule(I:GetName())
