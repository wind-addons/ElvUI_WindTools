local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local AK = W:NewModule("AlreadyKnown", "AceEvent-3.0", "AceHook-3.0") ---@class AlreadyKnown : AceModule, AceEvent-3.0, AceHook-3.0

-- Some check logic references code from Legion Remix Helper & AlreadyKnown

local _G = _G
local ceil = ceil
local format = format
local ipairs = ipairs
local mod = mod
local select = select
local strfind = strfind
local strmatch = strmatch
local tonumber = tonumber

local ContainsIf = ContainsIf
local GetBuybackItemInfo = GetBuybackItemInfo
local GetBuybackItemLink = GetBuybackItemLink
local GetCurrentGuildBankTab = GetCurrentGuildBankTab
local GetGuildBankItemInfo = GetGuildBankItemInfo
local GetGuildBankItemLink = GetGuildBankItemLink
local GetMerchantItemLink = GetMerchantItemLink
local GetMerchantNumItems = GetMerchantNumItems
local GetNumBuybackItems = GetNumBuybackItems
local PlayerHasToy = PlayerHasToy
local RunNextFrame = RunNextFrame
local SetItemButtonDesaturated = SetItemButtonDesaturated
local SetItemButtonTextureVertexColor = SetItemButtonTextureVertexColor

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_Item_GetItemInfoInstant = C_Item.GetItemInfoInstant
local C_Item_GetItemInventoryTypeByID = C_Item.GetItemInventoryTypeByID
local C_Item_GetItemLearnTransmogSet = C_Item.GetItemLearnTransmogSet
local C_Item_IsCosmeticItem = C_Item.IsCosmeticItem
local C_MerchantFrame_GetItemInfo = C_MerchantFrame.GetItemInfo
local C_MountJournal_GetMountFromItem = C_MountJournal.GetMountFromItem
local C_MountJournal_GetMountInfoByID = C_MountJournal.GetMountInfoByID
local C_PetJournal_GetNumCollectedInfo = C_PetJournal.GetNumCollectedInfo
local C_PetJournal_GetPetInfoByItemID = C_PetJournal.GetPetInfoByItemID
local C_TooltipInfo_GetGuildBankItem = C_TooltipInfo.GetGuildBankItem
local C_TooltipInfo_GetHyperlink = C_TooltipInfo.GetHyperlink
local C_ToyBox_GetToyInfo = C_ToyBox.GetToyInfo
local C_TransmogCollection_PlayerHasTransmogByItemInfo = C_TransmogCollection.PlayerHasTransmogByItemInfo
local C_TransmogSets_GetSetInfo = C_TransmogSets.GetSetInfo
local C_Transmog_GetAllSetAppearancesByID = C_Transmog.GetAllSetAppearancesByID

local Enum_ItemClass_Battlepet = Enum.ItemClass.Battlepet
local BUYBACK_ITEMS_PER_PAGE = BUYBACK_ITEMS_PER_PAGE
local COLLECTED = COLLECTED
local ITEM_SPELL_KNOWN = ITEM_SPELL_KNOWN
local PET_SEARCH_PATTERN = strmatch(ITEM_PET_KNOWN, "[^%(（]+")
local MAX_GUILDBANK_SLOTS_PER_TAB = 98
local NUM_SLOTS_PER_GUILDBANK_GROUP = 14

local knowables = {
	[Enum.ItemClass.Consumable] = true,
	[Enum.ItemClass.Weapon] = true,
	[Enum.ItemClass.Armor] = true,
	[Enum.ItemClass.ItemEnhancement] = true,
	[Enum.ItemClass.Recipe] = true,
	[Enum.ItemClass.Miscellaneous] = true,
	[Enum.ItemClass.Battlepet] = true,
}

local transmogInventoryTypes = {
	[Enum.InventoryType.IndexBodyType] = true,
	[Enum.InventoryType.IndexTabardType] = true,
}

local knowns = {}

local function IsPetCollected(speciesID)
	local num = speciesID and C_PetJournal_GetNumCollectedInfo(speciesID)
	return num and num > 0
end

local function IsTransmogCollected(itemID)
	if not C_Item_IsCosmeticItem(itemID) then
		local inventoryType = C_Item_GetItemInventoryTypeByID(itemID)
		if not transmogInventoryTypes[inventoryType] then
			return false
		end
	end

	return C_TransmogCollection_PlayerHasTransmogByItemInfo(itemID)
end

local function IsTransmogSetCollected(itemID)
	local setID = C_Item_GetItemLearnTransmogSet(itemID)
	if not setID then
		return false
	end

	local info = C_TransmogSets_GetSetInfo(setID)
	if not info then
		return false
	end

	if info.collected then
		return true
	end

	local items = C_Transmog_GetAllSetAppearancesByID(setID)
	if not items then
		return false
	end

	return not ContainsIf(items, function(item)
		return not C_TransmogCollection_PlayerHasTransmogByItemInfo(item.itemID)
	end)
end

local function IsMountCollected(itemID)
	local mountID = C_MountJournal_GetMountFromItem(itemID)
	return mountID and select(11, C_MountJournal_GetMountInfoByID(mountID))
end

local function IsToyCollected(itemID)
	return C_ToyBox_GetToyInfo(itemID) and PlayerHasToy(itemID)
end

local function IsPetItemCollected(itemID)
	local speciesID = select(13, C_PetJournal_GetPetInfoByItemID(itemID))
	return speciesID and IsPetCollected(speciesID)
end

local function IsKnown(link, index)
	if not link then
		return
	end

	local linkType, linkID = strmatch(link, "|H(%a+):(%d+)")
	linkID = tonumber(linkID)

	if linkType == "battlepet" then
		return IsPetCollected(linkID)
	elseif linkType == "item" then
		local classID = select(6, C_Item_GetItemInfoInstant(link))
		if classID == Enum_ItemClass_Battlepet and index then
			local tab = GetCurrentGuildBankTab() --[[@as number]]
			local data = C_TooltipInfo_GetGuildBankItem(tab, index)
			if data then
				return data.battlePetSpeciesID and IsPetCollected(data.battlePetSpeciesID)
			end
		else
			if knowns[link] then
				return true
			end

			if not knowables[classID] then
				return
			end

			if
				IsMountCollected(linkID)
				or IsToyCollected(linkID)
				or IsPetItemCollected(linkID)
				or IsTransmogCollected(linkID)
				or IsTransmogSetCollected(linkID)
			then
				knowns[link] = true
				return true
			end

			-- Final check via tooltip parsing
			local data = C_TooltipInfo_GetHyperlink(link)
			if data then
				for _, line in ipairs(data.lines) do
					local text = line.leftText
					if text then
						if
							strfind(text, COLLECTED, 1, true)
							or strfind(text, ITEM_SPELL_KNOWN, 1, true)
							or strmatch(text, PET_SEARCH_PATTERN)
						then
							knowns[link] = true
							return true
						end
					end
				end
			end
		end
	end
end

local texCache = {}

function AK:UpdateMerchantItemButton(button, _, _, _, skip)
	if skip or not button:IsShown() then
		return
	end

	local tex = texCache[button]
	local index = button:GetID()
	local info = C_MerchantFrame_GetItemInfo(index)
	if info and info.isUsable and IsKnown(GetMerchantItemLink(index)) then
		if self.db.mode == "MONOCHROME" then
			tex:SetDesaturated(true)
		else
			local r, g, b = self.db.color.r, self.db.color.g, self.db.color.b
			if info.numAvailable == 0 then
				r, g, b = r * 0.5, g * 0.5, b * 0.5
			end
			button:SetItemButtonTextureVertexColor(0.9 * r, 0.9 * g, 0.9 * b, true)
		end
	else
		tex:SetDesaturated(false)
	end
end

function AK:Merchant()
	if not self.db.enable then
		return
	end

	local numItems = GetMerchantNumItems()
	for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
		local index = (_G.MerchantFrame.page - 1) * _G.MERCHANT_ITEMS_PER_PAGE + i
		if index > numItems then
			return
		end

		local itemButton = _G["MerchantItem" .. i .. "ItemButton"]
		local itemButtonTex = _G["MerchantItem" .. i .. "ItemButtonIconTexture"]
		if itemButton and itemButtonTex and not self:IsHooked(itemButton, "SetItemButtonTextureVertexColor") then
			texCache[itemButton] = itemButtonTex
			self:SecureHook(itemButton, "SetItemButtonTextureVertexColor", "UpdateMerchantItemButton")
			self:UpdateMerchantItemButton(itemButton)
		end
	end
end

function AK:Buyback()
	if not self.db.enable then
		return
	end

	local numItems = GetNumBuybackItems()
	for index = 1, BUYBACK_ITEMS_PER_PAGE do
		if index > numItems then
			return
		end

		local button = _G["MerchantItem" .. index .. "ItemButton"]
		if button and button:IsShown() then
			local isUsable = select(6, GetBuybackItemInfo(index))
			if isUsable and IsKnown(GetBuybackItemLink(index)) then
				if self.db.mode == "MONOCHROME" then
					_G["MerchantItem" .. index .. "ItemButtonIconTexture"]:SetDesaturated(true)
				else
					local r, g, b = self.db.color.r, self.db.color.g, self.db.color.b
					SetItemButtonTextureVertexColor(button, 0.9 * r, 0.9 * g, 0.9 * b)
				end
			else
				_G["MerchantItem" .. index .. "ItemButtonIconTexture"]:SetDesaturated(false)
			end
		end
	end
end

function AK:GuildBank(frame)
	if not self.db.enable then
		return
	end

	if frame.mode ~= "bank" then
		return
	end

	local tab = GetCurrentGuildBankTab() --[[@as number]]
	for i = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
		local index = mod(i, NUM_SLOTS_PER_GUILDBANK_GROUP)
		if index == 0 then
			index = NUM_SLOTS_PER_GUILDBANK_GROUP
		end

		local column = ceil((i - 0.5) / NUM_SLOTS_PER_GUILDBANK_GROUP)
		local button = frame.Columns[column].Buttons[index]
		if button and button:IsShown() then
			local texture, _, locked = GetGuildBankItemInfo(tab, i)
			if texture and not locked then
				if IsKnown(GetGuildBankItemLink(tab, i), i) then
					if self.db.mode == "MONOCHROME" then
						SetItemButtonDesaturated(button, true)
					else
						local r, g, b = self.db.color.r, self.db.color.g, self.db.color.b
						SetItemButtonTextureVertexColor(button, r, g, b)
					end
				else
					SetItemButtonTextureVertexColor(button, 1, 1, 1)
					SetItemButtonDesaturated(button, false)
				end
			end
		end
	end
end

function AK:AuctionHouse(frame)
	if not self.db.enable then
		return
	end

	for i = 1, frame.ScrollTarget:GetNumChildren() do
		local child = select(i, frame.ScrollTarget:GetChildren())
		if child.cells then
			local button = child.cells[2]
			local itemKey = button and button.rowData and button.rowData.itemKey
			if itemKey and itemKey.itemID then
				local itemLink
				if itemKey.itemID == 82800 then
					itemLink = format("|Hbattlepet:%d::::::|h[Dummy]|h", itemKey.battlePetSpeciesID)
				else
					itemLink = format("|Hitem:%d", itemKey.itemID)
				end

				if itemLink and IsKnown(itemLink) then
					if self.db.mode == "MONOCHROME" then
						button.Icon:SetDesaturated(true)
					else
						local r, g, b = self.db.color.r, self.db.color.g, self.db.color.b
						child.SelectedHighlight:Show()
						child.SelectedHighlight:SetVertexColor(r, g, b)
						child.SelectedHighlight:SetAlpha(0.25)
						button.Icon:SetVertexColor(r, g, b)
						button.IconBorder:SetVertexColor(r, g, b)
						button.Icon:SetDesaturated(false)
					end
				else
					child.SelectedHighlight:SetVertexColor(1, 1, 1)
					button.Icon:SetVertexColor(1, 1, 1)
					button.IconBorder:SetVertexColor(1, 1, 1)
					button.Icon:SetDesaturated(false)
				end
			end
		end
	end
end

do
	local numHooked = 0
	function AK:ADDON_LOADED(event, addOnName)
		if addOnName == "Blizzard_AuctionHouseUI" then
			self:SecureHook(_G.AuctionHouseFrame.BrowseResultsFrame.ItemList.ScrollBox, "Update", "AuctionHouse")
			numHooked = numHooked + 1
		elseif addOnName == "Blizzard_GuildBankUI" then
			self:SecureHook(_G.GuildBankFrame, "Update", "GuildBank")
			numHooked = numHooked + 1
		end

		if numHooked == 2 then
			self:UnregisterEvent("ADDON_LOADED")
		end
	end
end

function AK:Initialize()
	if C_AddOns_IsAddOnLoaded("AlreadyKnown") then
		self.StopRunning = "AlreadyKnown"
		return
	end

	if not E.db.WT.item.alreadyKnown.enable then
		return
	end

	self.db = E.db.WT.item.alreadyKnown
	self.initialized = true
	self:SecureHook("MerchantFrame_UpdateMerchantInfo", "Merchant")
	self:SecureHook("MerchantFrame_UpdateBuybackInfo", "Buyback")
	self:RegisterEvent("ADDON_LOADED")
end

function AK:ToggleSetting()
	if C_AddOns_IsAddOnLoaded("AlreadyKnown") then
		self.StopRunning = "AlreadyKnown"
		return
	end

	self.db = E.db.WT.item.alreadyKnown

	if self.db.enable and not self.initialized then
		self:Initialize()
	end
end

AK.ProfileUpdate = AK.ToggleSetting

W:RegisterModule(AK:GetName())
