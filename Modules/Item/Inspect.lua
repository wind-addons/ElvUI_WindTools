local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local I = W:NewModule("Inspect", "AceEvent-3.0", "AceHook-3.0") ---@class Inspect: AceModule, AceEvent-3.0, AceHook-3.0
local C = W.Utilities.Color
local S = W.Modules.Skins ---@type Skins
local MF = W.Modules.MoveFrames ---@type MoveFrames
local async = W.Utilities.Async
local EnchantLib = E.Libs.WTItemEnchant ---@type LibItemEnchantWT

-- Core logic, utility functions are modified from TinyInspect.
-- Credits & Copyright: loudsoul, Witnesscm
local _G = _G
local floor = floor
local format = format
local gsub = gsub
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local math_pi = math.pi
local max = max
local pairs = pairs
local strfind = strfind
local strmatch = strmatch
local tAppendAll = tAppendAll
local tContains = tContains
local tinsert = tinsert
local tonumber = tonumber
local tostring = tostring
local tremove = tremove
local type = type
local unpack = unpack
local wipe = wipe

local CreateFrame = CreateFrame
local GetInspectSpecialization = GetInspectSpecialization
local GetInventoryItemLink = GetInventoryItemLink
local GetServerExpansionLevel = GetServerExpansionLevel
local GetSpecializationInfoByID = GetSpecializationInfoByID
local Mixin = Mixin
local SetPortraitTexture = SetPortraitTexture
local UnitClass = UnitClass
local UnitGUID = UnitGUID
local UnitLevel = UnitLevel
local UnitName = UnitName

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_Item_GetItemGem = C_Item.GetItemGem
local C_Item_GetItemInfo = C_Item.GetItemInfo
local C_Item_GetItemNumSockets = C_Item.GetItemNumSockets
local C_Item_GetItemQualityColor = C_Item.GetItemQualityColor
local C_Item_GetItemStats = C_Item.GetItemStats
local C_Item_IsCorruptedItem = C_Item.IsCorruptedItem
local C_SpecializationInfo_GetSpecialization = C_SpecializationInfo.GetSpecialization
local C_SpecializationInfo_GetSpecializationInfo = C_SpecializationInfo.GetSpecializationInfo
local C_TooltipInfo_GetHyperlink = C_TooltipInfo.GetHyperlink
local C_TradeSkillUI_GetItemCraftedQualityByItemInfo = C_TradeSkillUI.GetItemCraftedQualityByItemInfo
local C_TradeSkillUI_GetItemReagentQualityByItemInfo = C_TradeSkillUI.GetItemReagentQualityByItemInfo

local EMPTY = EMPTY
local Enum_ItemClass = Enum.ItemClass
local Enum_ItemQuality = Enum.ItemQuality
local INVSLOT_MAINHAND = INVSLOT_MAINHAND
local INVSLOT_NECK = INVSLOT_NECK
local INVSLOT_OFFHAND = INVSLOT_OFFHAND

local MISSING_ICON = "Interface\\Cursor\\Quest"
local CIRCLE_MASK = "Interface\\FriendsFrame\\Battlenet-Portrait"
local CURRENT_EXPANSION_ID = GetServerExpansionLevel()
local LABEL_COLOR = C.GetRGBFromTemplate("cyan-300")
local PANEL_MIN_WIDTH = 250
local PANEL_COMPONENT_SPACING = 4
local ITEM_LEVEL_CHECK_INTERVAL = 0.08
local INSPECT_WAIT_MAX_SECONDS = 3
local INSPECT_WAIT_MAX_ROUNDS = floor(INSPECT_WAIT_MAX_SECONDS / ITEM_LEVEL_CHECK_INTERVAL)
local PVP_ITEM_LEVEL_PATTERN = gsub(_G.PVP_ITEM_LEVEL_TOOLTIP, "%%d", "(%%d+)")

local DISPLAY_SLOTS = {}
for index, localizedName in ipairs(W.EquipmentSlots) do
	if not tContains({ INVSLOT_BODY, INVSLOT_RANGED, INVSLOT_TABARD }, index) then
		tinsert(DISPLAY_SLOTS, { index = index, name = gsub(localizedName, "%d", "") })
	end
end

local INVSLOT_SOCKET_ITEMS = {
	[INVSLOT_NECK] = { 213777, 213777 },
	[INVSLOT_FINGER1] = { 213777, 213777 },
	[INVSLOT_FINGER2] = { 213777, 213777 },
}

local INVSLOT_ENCHANT = {
	[INVSLOT_CHEST] = true,
	[INVSLOT_LEGS] = true,
	[INVSLOT_FEET] = true,
	[INVSLOT_WRIST] = true,
	[INVSLOT_FINGER1] = true,
	[INVSLOT_FINGER2] = true,
	[INVSLOT_BACK] = true,
	[INVSLOT_MAINHAND] = true,
	[INVSLOT_OFFHAND] = true,
}

---Checks if an enchantment can be applied to a specific slot based on quality and class
---@param slotIndex number The inventory slot index
---@param itemQuality Enum.ItemQuality The quality of the enchantment
---@param itemClass Enum.ItemClass The class ID of the enchantment
---@return boolean
local function CheckEnchantmentSlot(slotIndex, itemQuality, itemClass)
	if not INVSLOT_ENCHANT[slotIndex] then
		return false
	end

	if
		itemQuality == Enum_ItemQuality.Artifact
		and tContains({ INVSLOT_NECK, INVSLOT_MAINHAND, INVSLOT_OFFHAND }, slotIndex)
	then
		return false
	end

	if slotIndex == INVSLOT_OFFHAND and itemClass ~= Enum_ItemClass.Weapon then
		return false
	end

	return true
end

---@type { released: InspectCircleIcon[] }
local circleIconPool = {
	nextID = 1,
	released = {},
}

---@class InspectCircleIcon
local circleIconPrototype = {}

function circleIconPrototype:OnEnter()
	if not self.itemLink and not self.itemID and not self.name then
		return
	end

	_G.GameTooltip:SetOwner(self, "ANCHOR_CURSOR", 0, 10)
	_G.GameTooltip:ClearLines()

	if self.itemLink then
		_G.GameTooltip:SetHyperlink(self.itemLink)
	elseif self.itemID then
		_G.GameTooltip:SetItemByID(self.itemID)
	elseif self.name and self.name ~= "" then
		_G.GameTooltip:AddLine(self.name, 1, 1, 1)
	end

	_G.GameTooltip:Show()
end

function circleIconPrototype:OnLeave()
	_G.GameTooltip:Hide()
end

function circleIconPrototype:Reset()
	self.name = nil
	self.itemLink = nil
	self.itemID = nil
	self.spellID = nil
	self.Texture:SetTexture(nil)
	self.Border:SetVertexColor(1, 1, 1, 1)
	self:Hide()
end

---Updates the size of the circle icon
---@param size number? The size of the icon (default: 32)
function circleIconPrototype:UpdateSize(size)
	size = size or 17
	self:Size(size)
	self.Texture:Size(size - 2)
	self.Border:Size(size + 4)
end

---Updates the crafting level style of the circle icon
---@param config { name: string, size: number, style: string, xOffset: number, yOffset: number }
function circleIconPrototype:UpdateCraftingTierStyle(config)
	F.SetFontWithDB(self.CraftingTierText, config)
	self.CraftingTierText:ClearAllPoints()
	self.CraftingTierText:Point("CENTER", self.Texture, "BOTTOM", config.xOffset, config.yOffset)
end

---Sets the data for the circle icon
---@param data SocketGemInfo The item link to display
function circleIconPrototype:AsGemSocket(data)
	self.name, self.itemLink, self.itemID = data.name, data.link, data.socketItemID

	if not data.link then
		self:UpdateStyle(MISSING_ICON, nil, data.socketItemID and "stone-500" or "red-800")
		return
	end

	async.WithItemLink(data.link, function(item)
		if not item or item:IsItemEmpty() then
			return self:Reset()
		end

		local tex, quality = item:GetItemIcon(), item:GetItemQuality()
		if not tex then
			return self:Reset()
		end

		local level = C_TradeSkillUI_GetItemReagentQualityByItemInfo(data.link)
			or C_TradeSkillUI_GetItemCraftedQualityByItemInfo(data.link)

		local db = I.db.gemIcon.craftingTier
		if level and (level > db.maxTierToShow or level < db.minTierToShow) then
			level = nil
		end

		self:UpdateStyle(tex, quality or Enum_ItemQuality.Common, nil, level)
	end)
end

---Sets the data for the circle icon
---@param data EnchantInfo The enchantment information to display
function circleIconPrototype:AsEnchant(data)
	self.name, self.itemID, self.spellID = data.name, data.itemID, data.spellID

	if not data.enchantID then
		self:UpdateStyle(MISSING_ICON, nil, "indigo-400")
		return
	end

	if data.itemID then
		async.WithItemID(data.itemID, function(item)
			if not item or item:IsItemEmpty() then
				return self:Reset()
			end

			local tex, quality = item:GetItemIcon(), item:GetItemQuality()
			if not tex then
				return self:Reset()
			end

			local level = C_TradeSkillUI_GetItemReagentQualityByItemInfo(data.itemID)
				or C_TradeSkillUI_GetItemCraftedQualityByItemInfo(data.itemID)

			local db = I.db.enchantIcon.craftingTier
			if level and (level > db.maxTierToShow or level < db.minTierToShow) then
				level = nil
			end

			self:UpdateStyle(tex, quality or Enum_ItemQuality.Common, nil, level)
		end)
	elseif data.spellID then
		async.WithSpellID(data.spellID, function(spell)
			if not spell or spell:IsSpellEmpty() then
				return self:Reset()
			end

			local tex = spell:GetSpellTexture()
			if not tex then
				return self:Reset()
			end

			self:UpdateStyle(tex, Enum_ItemQuality.Common)
		end)
	else
		self:Reset()
	end
end

---Applies the texture and border color to the circle icon
---@param texture string|number The texture path or texture ID
---@param quality Enum.ItemQuality? The item quality for the border color
---@param colorTemplate ColorTemplate? The color template for the border
---@param craftingTier number? The crafting quality level for the overlay
function circleIconPrototype:UpdateStyle(texture, quality, colorTemplate, craftingTier)
	self.Texture:SetTexture(texture)
	self.Texture:SetMask(CIRCLE_MASK)

	if texture == MISSING_ICON then
		self.Texture:SetRotation(-math_pi / 18)
		self.Texture:SetScale(0.92)
	else
		self.Texture:SetRotation(0)
	end

	local r, g, b, a
	if quality then
		r, g, b = C_Item_GetItemQualityColor(quality)
		a = 1
	else
		r, g, b = C.ExtractRGBFromTemplate(colorTemplate or "red-800")
		a = 0.7
	end

	if craftingTier then
		self.CraftingTierText:SetText(tostring(craftingTier))
		local tierColorTemplate = "amber-300" ---@type ColorTemplate
		if craftingTier < 3 then
			tierColorTemplate = "yellow-600"
		end
		self.CraftingTierText:SetTextColor(C.ExtractRGBFromTemplate(tierColorTemplate))
		self.CraftingTierText:Show()
	else
		self.CraftingTierText:Hide()
	end

	self.Border:SetVertexColor(r, g, b, a)
	self.Texture:Show()
	self.Border:Show()
	self:Show()
end

---Creates a new circle icon
---@return InspectCircleIcon
function circleIconPool:CreateIcon()
	---@class InspectCircleIcon : Frame, BackdropTemplateMixin
	local frame = CreateFrame("Frame", "WTInspectCircleIcon" .. self.nextID, E.UIParent)
	Mixin(frame, circleIconPrototype)

	frame.Texture = frame:CreateTexture(nil, "ARTWORK")
	frame.Texture:SetPoint("CENTER")
	frame.Texture:SetMask(CIRCLE_MASK)

	frame.CraftingTierText = frame:CreateFontString(nil, "OVERLAY")
	frame.CraftingTierText:Point("CENTER", frame.Texture, "BOTTOM")
	F.SetFont(frame.CraftingTierText, F.GetCompatibleFont("Chivo Mono"), 8)
	frame.CraftingTierText:SetJustifyH("CENTER")
	frame.CraftingTierText:SetJustifyV("MIDDLE")

	frame.Border = frame:CreateTexture(nil, "BORDER")
	frame.Border:SetTexture(W.Media.Textures.inspectGemBG)
	frame.Border:SetPoint("CENTER", frame.Texture, "CENTER")

	frame:SetScript("OnEnter", frame.OnEnter)
	frame:SetScript("OnLeave", frame.OnLeave)

	self.nextID = self.nextID + 1

	return frame
end

---Acquires a circle icon from the pool
---@return InspectCircleIcon icon The acquired circle icon
function circleIconPool:Acquire()
	return tremove(self.released) or self:CreateIcon()
end

---Releases a circle icon back to the pool
---@param icon InspectCircleIcon The circle icon to release
function circleIconPool:Release(icon)
	if not icon then
		return
	end

	icon:Reset()
	icon:SetParent(E.UIParent)
	icon:ClearAllPoints()
	tinsert(self.released, icon)
end

---@alias SocketGemInfo { name: string?, link: string?, socketItemID: number? }

---Gets gem information for an item including empty sockets
---Modified from TinyInspect
---@param itemLink string The item link to analyze
---@return SocketGemInfo[]? gemInfo Array of gem information including empty sockets
local function GetItemGemInfo(itemLink)
	local info = {} ---@type SocketGemInfo[]
	local stats = C_Item_GetItemStats(itemLink)
	for key, num in pairs(stats) do
		if strfind(key, "EMPTY_SOCKET_", 1, true) then
			for _ = 1, num do
				tinsert(info, { name = _G[key] or EMPTY })
			end
		end
	end
	for i = 1, 4 do
		local name, link = C_Item_GetItemGem(itemLink, i)
		if link then
			if info[i] then
				info[i].name, info[i].link = name, link
			else
				tinsert(info, { name = name, link = link })
			end
		end
	end

	return info
end

---Gets the PvP item level from an item's tooltip
---Modified from TinyInspect
---@param itemLink string The item link to check
---@return number? pvpItemLevel The PvP item level if found, nil otherwise
local function GetPvPItemLevel(itemLink)
	local tooltipData = C_TooltipInfo_GetHyperlink(itemLink, nil, nil, true)
	if not tooltipData then
		return
	end

	local text, level
	for _, lineData in ipairs(tooltipData.lines) do
		text = lineData.leftText
		level = text and strmatch(text, PVP_ITEM_LEVEL_PATTERN)
		if level then
			break
		end
	end

	return tonumber(level)
end

---Gets additional socket items that can be added to an item
---Checks if the item is eligible for socket additions based on item level and PvP status
---Modified from TinyInspect
---@param itemLink string The item link to check
---@param slotIndex number The inventory slot index (must be neck, finger1, or finger2)
---@param itemLevel number The item's current item level
---@return SocketGemInfo[]? socketItems Array of item IDs that can be socketed, nil if not eligible
local function GetItemAddableSockets(itemLink, slotIndex, itemLevel)
	local socketItems = INVSLOT_SOCKET_ITEMS[slotIndex]
	if not socketItems then
		return
	end

	if itemLevel < 584 then
		return
	end

	local pvpItemLevel = GetPvPItemLevel(itemLink)
	if pvpItemLevel and pvpItemLevel > 0 then
		return
	end

	local data = {}
	local numSockets = C_Item_GetItemNumSockets(itemLink)
	for i = numSockets + 1, #socketItems do
		tinsert(data, { socketItemID = socketItems[i] })
	end

	return data
end

---@alias EnchantInfo { enchantID: string?, itemID: number?, spellID: number? }

---Gets enchantment information from an item link
---@param itemInfo InspectItemInfo The item information to analyze
---@return EnchantInfo? enchantInfo The enchantment information, or nil if not found
local function GetItemEnchantInfo(itemInfo)
	local enchantID = tonumber(strmatch(itemInfo.link, "item:%d+:(%d+):"))

	if not enchantID then
		local isMissing = CheckEnchantmentSlot(itemInfo.slotIndex, itemInfo.quality, itemInfo.classID)
		return isMissing and { name = L["Enchant Missing"] } or nil
	end

	return {
		enchantID = enchantID,
		itemID = EnchantLib:GetEnchantItemID(enchantID),
		spellID = EnchantLib:GetEnchantSpellID(enchantID),
	}
end

---@alias InspectItemInfo {
--- classID: Enum.ItemClass,
--- cleanLink: string,
--- craftingAtlas: string?,
--- expansionID: number,
--- isCraftingReagent: boolean,
--- level: number,
--- link: string,
--- name: string,
--- quality: Enum.ItemQuality,
--- set: number?,
--- slotIndex: number,
--- subType: string,
--- texture: string,
--- type: string,
---}

---Gets item information for a specific inventory slot of a unit
---@param unit UnitToken The unit to inspect
---@param slotIndex number The inventory slot index
---@return InspectItemInfo? itemInfo The item information, or nil if no item is found
local function GetUnitSlotItemInfo(unit, slotIndex)
	local link = GetInventoryItemLink(unit, slotIndex)
	if not link then
		return
	end

	local itemName, _, itemQuality, itemLevel, _, itemType, itemSubType, _, _, itemTexture, _, itemClassID, _, _, expansionID, setID, isCraftingReagent =
		C_Item_GetItemInfo(link)

	local craftingAtlas ---@type string?
	local cleanLink = gsub(link, "|h%[(.+)%]|h", function(raw)
		local name = gsub(raw, "(%s*)(|A:.-|a)", function(_, atlasString)
			craftingAtlas = gsub(atlasString, "|A:(.-):%d+:%d+::%d+|a", "%1")
			return ""
		end)
		return "|h" .. name .. "|h"
	end)

	return {
		classID = itemClassID,
		cleanLink = cleanLink,
		craftingAtlas = craftingAtlas,
		expansionID = expansionID,
		isCraftingReagent = isCraftingReagent,
		level = itemLevel,
		link = link,
		name = itemName,
		quality = itemQuality,
		set = setID,
		slotIndex = slotIndex,
		subType = itemSubType,
		texture = itemTexture,
		type = itemType,
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

function I:ShouldShowPanel(unit, parent)
	if not self.db or not self.db.enable or not parent or not parent:IsShown() then
		return false
	end

	if parent == _G.PaperDollFrame then
		if not self.db.player then
			return false
		end
	elseif parent == _G.InspectFrame then
		if not self.db.inspect then
			return false
		end
	elseif unit == "player" and _G.InspectFrame.WTInspect and parent == _G.InspectFrame.WTInspect then
		if not self.db.playerOnInspect then
			return false
		end
	end

	return true
end

function I:CreatePanel(parent)
	if parent.WTInspect then
		return parent.WTInspect
	end

	local frame = CreateFrame("Frame", nil, parent)
	local height = parent:GetHeight()

	-- Frame
	frame:Size(PANEL_MIN_WIDTH, height)
	frame:SetFrameLevel(0)
	frame:Point("LEFT", parent, "RIGHT", 5, 0)
	frame:SetTemplate("Transparent")
	S:CreateShadowModule(frame)
	S:MerathilisUISkin(frame)

	frame.CloseButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton, BackdropTemplate") --[[@as Button]]
	frame.CloseButton:Point("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
	S:Proxy("HandleCloseButton", frame.CloseButton)
	frame.CloseButton:SetScript("OnClick", function(_)
		frame:Hide()
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

	F.SetFont(frame.PortraitFrame.Level, F.GetCompatibleFont("Chivo Mono"), 18)
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
	F.SetFont(frame.PlayerName, E.db.general.font, 18)
	F.SetFont(frame.PlayerItemLevel, E.db.general.font, 14)
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
		line.Label.Text:Width(textWidth)
		line.Label.Text:SetTextColor(LABEL_COLOR.r, LABEL_COLOR.g, LABEL_COLOR.b, 0.8)

		-- Item Level
		line.ItemLevel = line:CreateFontString(nil, "ARTWORK")
		F.SetFontWithDB(line.ItemLevel, self.db.levelText)
		line.ItemLevel:Point("LEFT", line.Label, "RIGHT", PANEL_COMPONENT_SPACING, 0)
		line.ItemLevel:SetJustifyH("RIGHT")

		-- Item Texture
		line.ItemTextureFrame = CreateFrame("Frame", nil, line, "BackdropTemplate")
		line.ItemTextureFrame.Texture = line.ItemTextureFrame:CreateTexture(nil, "ARTWORK")
		line.ItemTextureFrame:Size(self.db.itemIcon.width, self.db.itemIcon.height)
		line.ItemTextureFrame:Point("LEFT", line.ItemLevel, "RIGHT", PANEL_COMPONENT_SPACING, 0)
		line.ItemTextureFrame.Texture:SetInside(line.ItemTextureFrame)
		line.ItemTextureFrame.Texture:SetTexCoord(E:CropRatio(self.db.itemIcon.width, self.db.itemIcon.height))
		line.ItemTextureFrame:SetTemplate()

		line.ItemTextureFrame.Indicator = line.ItemTextureFrame:CreateFontString(nil, "OVERLAY")
		F.SetFont(line.ItemTextureFrame.Indicator, F.GetCompatibleFont("Chivo Mono"), 20)
		line.ItemTextureFrame.Indicator:Point("CENTER", line.ItemTextureFrame.Texture, "TOPRIGHT", 1, -2)

		-- Item Name
		line.ItemName = line:CreateFontString(nil, "ARTWORK")
		F.SetFontWithDB(line.ItemName, self.db.itemNameText)
		line.ItemName:Height(self.db.itemNameText.size + 2)
		line.ItemName:Point("LEFT", line.ItemTextureFrame, "RIGHT", PANEL_COMPONENT_SPACING + 2, -1)
		line.ItemName:SetJustifyH("LEFT")

		-- Tooltips
		line:SetScript("OnEnter", function(this)
			this.Label:SetBackdropColor(LABEL_COLOR.r, LABEL_COLOR.g, LABEL_COLOR.b, 0.7)
			this.Label:SetBackdropBorderColor(LABEL_COLOR.r, LABEL_COLOR.g, LABEL_COLOR.b, 1)
			if this.link or (this.level and this.level > 0) then
				_G.GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT", 18, 30)
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

	parent.WTInspect = frame

	return frame
end

function I:ShowPanel(unit, parent, ilevel)
	if not self:ShouldShowPanel(unit, parent) then
		if parent and parent.WTInspect then
			parent.WTInspect:Hide()
		end
		return
	end

	local frame = self:CreatePanel(parent)
	frame.unit = unit

	local _, class = UnitClass(unit)
	local classColor = E:ClassColor(class, true) --[[@as ClassColor]]

	frame.PortraitFrame:SetLevel(UnitLevel(unit))
	SetPortraitTexture(frame.PortraitFrame.Portrait, unit)
	frame.PortraitBorder:SetVertexColor(classColor.r, classColor.g, classColor.b)

	frame.PlayerName:SetText(UnitName(unit))
	frame.PlayerName:SetTextColor(classColor.r, classColor.g, classColor.b)
	frame.PlayerItemLevel:SetText(format("%s %s", L["Item Level"], ilevel == "tooSoon" and "..." or (ilevel or 0)))

	local specInfo = GetUnitSpecializationInfo(unit)
	frame.specName = specInfo and specInfo.name
	if specInfo and specInfo.icon then
		frame.SpecIcon.backdrop:SetBackdropBorderColor(classColor.r, classColor.g, classColor.b)
		frame.SpecIcon:SetTexture(specInfo.icon)
		frame.SpecIcon:SetShown(true)
	else
		frame.SpecIcon:SetShown(false)
	end

	local maxLabelTextWidth, maxItemLevelTextWidth, maxItemNameTextWidth = 30, 0, 0

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
		F.SetFontWithDB(line.ItemName, self.db.itemNameText)
		line.ItemName:Height(self.db.itemNameText.size + 2)

		if itemInfo and itemInfo.level > 0 then
			line.ItemLevel:SetText(format("%d", itemInfo.level))
			line.ItemName:SetText(itemInfo.cleanLink or itemInfo.link or itemInfo.name)
		else
			line.ItemLevel:SetText("")
			line.ItemName:SetText(L["Not Equipped"])
		end

		line.ItemTextureFrame:ClearAllPoints()
		if self.db.itemIcon.enable then
			line.ItemTextureFrame:Size(self.db.itemIcon.width, self.db.itemIcon.height)
			line.ItemTextureFrame.Texture:SetTexCoord(E:CropRatio(self.db.itemIcon.width, self.db.itemIcon.height))
			line.ItemTextureFrame:Point("LEFT", line.ItemLevel, "RIGHT", 4, 0)
			if itemInfo and itemInfo.level > 0 then
				line.ItemTextureFrame.Texture:SetTexture(itemInfo.texture)
				local r, g, b = E.db.general.bordercolor.r, E.db.general.bordercolor.g, E.db.general.bordercolor.b
				if self.db.itemIcon.qualityBorder then
					r, g, b = C_Item_GetItemQualityColor(itemInfo.quality or Enum_ItemQuality.Common)
				end
				line.ItemTextureFrame:SetBackdropBorderColor(r, g, b)
				line.ItemTextureFrame:Show()
			else
				line.ItemTextureFrame:Hide()
			end
		else
			line.ItemTextureFrame:Point("RIGHT", line.ItemLevel, "RIGHT", -3, 0)
			line.ItemTextureFrame:Hide()
		end

		if self.db.itemIcon.enable and self.db.itemIcon.indicator and itemInfo then
			if itemInfo.set and itemInfo.set > 0 then
				line.ItemTextureFrame.Indicator:SetText("*")
				local colorTemplate = "gray-400"
				if W.CurrentTierSetTable[itemInfo.set] then
					colorTemplate = "pink-500"
				elseif itemInfo.expansionID >= CURRENT_EXPANSION_ID then
					colorTemplate = "sky-600"
				end
				line.ItemTextureFrame.Indicator:SetTextColor(C.ExtractRGBFromTemplate(colorTemplate))
				line.ItemTextureFrame.Indicator:Show()
			elseif itemInfo.craftingAtlas then
				line.ItemTextureFrame.Indicator:SetText("|A:" .. itemInfo.craftingAtlas .. ":8:8|a")
				line.ItemTextureFrame.Indicator:Show()
			else
				line.ItemTextureFrame.Indicator:Hide()
			end
		else
			line.ItemTextureFrame.Indicator:Hide()
		end

		-- Update colors for some expansion special items
		if itemInfo and itemInfo.link then
			local colorTemplate = C_Item_IsCorruptedItem(itemInfo.link) and "indigo-400" or "neutral-100"
			line.ItemLevel:SetTextColor(C.ExtractRGBFromTemplate(colorTemplate))
		end

		if slotInfo.index == 16 or slotInfo.index == 17 then
			line:SetAlpha(itemInfo and itemInfo.level > 0 and 1 or 0.4)
		end

		-- Icons
		if line.circleIcons then
			for _, icon in ipairs(line.circleIcons) do
				circleIconPool:Release(icon)
			end
			wipe(line.circleIcons)
		else
			line.circleIcons = {}
		end

		local circleIconsWidth = 0

		local function UpdateCircleIconPosition(icon)
			if #line.circleIcons == 0 then
				icon:Point("LEFT", line.ItemName, "RIGHT", PANEL_COMPONENT_SPACING, 0)
				circleIconsWidth = circleIconsWidth + self.db.gemIcon.size
			else
				icon:Point("LEFT", line.circleIcons[#line.circleIcons], "RIGHT", 3, 0)
				circleIconsWidth = circleIconsWidth + self.db.gemIcon.size + 3
			end
		end

		if self.db.enchantIcon.enable then
			local enchantInfo = itemInfo and GetItemEnchantInfo(itemInfo)
			if enchantInfo and (enchantInfo.enchantID or enchantInfo.name) then
				local icon = circleIconPool:Acquire()
				icon:SetParent(line)
				icon:AsEnchant(enchantInfo)
				icon:UpdateSize(self.db.enchantIcon.size)
				icon:UpdateCraftingTierStyle(self.db.enchantIcon.craftingTier)
				UpdateCircleIconPosition(icon)
				tinsert(line.circleIcons, icon)
			end
		end

		if self.db.gemIcon.enable then
			local gemSocketInfo = itemInfo and GetItemGemInfo(itemInfo.link) or {}
			local addableSockets = self.db.gemIcon.showAddableSockets
					and itemInfo
					and itemInfo.link
					and GetItemAddableSockets(itemInfo.link, slotInfo.index, itemInfo.level)
				or {}

			tAppendAll(gemSocketInfo, addableSockets)
			for _, data in ipairs(gemSocketInfo) do
				local icon = circleIconPool:Acquire()
				icon:SetParent(line)
				icon:AsGemSocket(data)
				icon:UpdateSize(self.db.gemIcon.size)
				icon:UpdateCraftingTierStyle(self.db.gemIcon.craftingTier)
				UpdateCircleIconPosition(icon)
				tinsert(line.circleIcons, icon)
			end
		end

		-- Width adjustment for dynamic font size
		local BETTER_GETSTRING_WIDTH = 1
		maxLabelTextWidth = max(maxLabelTextWidth, line.Label.Text:GetStringWidth())
		maxItemLevelTextWidth = max(maxItemLevelTextWidth, line.ItemLevel:GetStringWidth() + BETTER_GETSTRING_WIDTH)
		local itemNameTextWidth = line.ItemName:GetStringWidth() + BETTER_GETSTRING_WIDTH
		if #line.circleIcons > 0 then
			itemNameTextWidth = itemNameTextWidth + circleIconsWidth + PANEL_COMPONENT_SPACING
		end
		maxItemNameTextWidth = max(maxItemNameTextWidth, itemNameTextWidth)
	end

	local lineWidth = (maxLabelTextWidth + 3 * 2) -- padding is 3
		+ PANEL_COMPONENT_SPACING
		+ maxItemLevelTextWidth
		+ PANEL_COMPONENT_SPACING
		+ maxItemNameTextWidth

	if self.db.itemIcon.enable then
		lineWidth = lineWidth + self.db.itemIcon.width + 2 + PANEL_COMPONENT_SPACING
	end

	lineWidth = max(lineWidth, PANEL_MIN_WIDTH)

	for _, line in ipairs(frame.Lines) do
		line.Label.Text:Width(maxLabelTextWidth + 3 * 2)
		line.Label:Width(maxLabelTextWidth + 3 * 2)
		line.ItemLevel:Width(maxItemLevelTextWidth)
		line:Width(lineWidth)
	end

	frame:Width(lineWidth + 15 * 2)
	frame:Show()

	-- TODO:
	-- [ ] Stats

	return frame
end

function I:ShowAllPlayerPanels()
	self:ShowPanel("player", _G.PaperDollFrame, E:GetUnitItemLevel("player"))
	self:ShowPanel("player", _G.InspectFrame and _G.InspectFrame.WTInspect, E:GetUnitItemLevel("player"))
end

function I:ShowInspectPanels(unit, itemLevel)
	local frame = self:ShowPanel(unit, _G.InspectFrame, itemLevel)
	self:ShowPanel("player", frame, E:GetUnitItemLevel("player"))
end

function I:NotifyInspect(unit)
	for k in pairs(self.inspecting) do
		if self.inspecting[k] == unit then
			self.inspecting[k] = nil
		end
	end

	local guid = UnitGUID(unit)
	if guid then
		self.inspecting[guid] = unit
	end
end

function I:INSPECT_READY(_, guid)
	if not self.inspecting[guid] then
		return
	end

	local itemLevelContext = nil ---@type number?

	F.WaitFor(function()
		if self.inspecting[guid] == nil then
			return "end"
		end

		local unit = self.inspecting[guid]
		if not unit or UnitGUID(unit) ~= guid then
			return false
		end

		local itemLevel = E:GetUnitItemLevel(unit)
		if type(itemLevel) ~= "number" or itemLevel <= 0 then
			return false
		end

		itemLevelContext = itemLevel
		return true
	end, function()
		local latestUnit = _G.InspectFrame and _G.InspectFrame.unit
		local latestGUID = latestUnit and UnitGUID(latestUnit)
		if itemLevelContext and latestGUID == guid then
			local key = "ShowInspectPanels_" .. latestUnit
			F.Throttle(0.05, key, self.ShowInspectPanels, self, latestUnit, itemLevelContext)
		end
	end, ITEM_LEVEL_CHECK_INTERVAL, INSPECT_WAIT_MAX_ROUNDS)
end

function I:UNIT_INVENTORY_CHANGED(_, unit)
	if _G.InspectFrame and _G.InspectFrame.unit and _G.InspectFrame.unit == unit then
		local guid = UnitGUID(unit)
		if guid then
			self:INSPECT_READY(_, guid)
		end
	end
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

	-- Player
	self:HookScript(_G.PaperDollFrame, "OnShow", function()
		self:ShowPanel("player", _G.PaperDollFrame, E:GetUnitItemLevel("player"))
	end)

	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "ShowAllPlayerPanels")
	self:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_UPDATE", "ShowAllPlayerPanels")

	-- Inspect
	self.inspecting = {}
	self:SecureHook("NotifyInspect")
	self:RegisterEvent("INSPECT_READY")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")

	self.initialized = true
end

I.ProfileUpdate = I.Initialize

W:RegisterModule(I:GetName())
