local W, F, E, L = unpack((select(2, ...)))
local AK = W:NewModule("AlreadyKnown", "AceEvent-3.0", "AceHook-3.0")

local _G = _G
local ceil = ceil
local format = format
local mod = mod
local select = select
local strfind = strfind
local strmatch = strmatch
local tonumber = tonumber

local GetBuybackItemInfo = GetBuybackItemInfo
local GetBuybackItemLink = GetBuybackItemLink
local GetCurrentGuildBankTab = GetCurrentGuildBankTab
local GetGuildBankItemInfo = GetGuildBankItemInfo
local GetGuildBankItemLink = GetGuildBankItemLink
local C_MerchantFrame_GetItemInfo = C_MerchantFrame.GetItemInfo
local GetMerchantItemLink = GetMerchantItemLink
local GetMerchantNumItems = GetMerchantNumItems
local GetNumBuybackItems = GetNumBuybackItems
local SetItemButtonDesaturated = SetItemButtonDesaturated
local SetItemButtonTextureVertexColor = SetItemButtonTextureVertexColor

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_Item_GetItemInfo = C_Item.GetItemInfo
local C_PetJournal_GetNumCollectedInfo = C_PetJournal.GetNumCollectedInfo
local C_TooltipInfo_GetGuildBankItem = C_TooltipInfo.GetGuildBankItem
local C_TooltipInfo_GetHyperlink = C_TooltipInfo.GetHyperlink

local Enum_ItemClass_Battlepet = Enum.ItemClass.Battlepet

local BUYBACK_ITEMS_PER_PAGE = BUYBACK_ITEMS_PER_PAGE
local COLLECTED = COLLECTED
local ITEM_SPELL_KNOWN = ITEM_SPELL_KNOWN
local MAX_GUILDBANK_SLOTS_PER_TAB = MAX_GUILDBANK_SLOTS_PER_TAB or 98
local NUM_SLOTS_PER_GUILDBANK_GROUP = NUM_SLOTS_PER_GUILDBANK_GROUP or 14

local knowables = {
	[Enum.ItemClass.Consumable] = true,
	[Enum.ItemClass.Recipe] = true,
	[Enum.ItemClass.Miscellaneous] = true,
	[Enum.ItemClass.ItemEnhancement] = true,
}
local knowns = {}

local function isPetCollected(speciesID)
	if not speciesID or speciesID == 0 then
		return
	end
	local numOwned = C_PetJournal_GetNumCollectedInfo(speciesID)
	if numOwned > 0 then
		return true
	end
end

local function IsAlreadyKnown(link, index)
	if not link then
		return
	end

	local linkType, linkID = strmatch(link, "|H(%a+):(%d+)")
	linkID = tonumber(linkID)

	if linkType == "battlepet" then
		return isPetCollected(linkID)
	elseif linkType == "item" then
		local name, _, _, level, _, _, _, _, _, _, _, itemClassID = C_Item_GetItemInfo(link)
		if not name then
			return
		end

		if itemClassID == Enum_ItemClass_Battlepet and index then
			local data = C_TooltipInfo_GetGuildBankItem(GetCurrentGuildBankTab(), index)
			if data then
				return data.battlePetSpeciesID and isPetCollected(data.battlePetSpeciesID)
			end
		else
			if knowns[link] then
				return true
			end
			if not knowables[itemClassID] then
				return
			end

			local data = C_TooltipInfo_GetHyperlink(link, nil, nil, true)
			if data then
				for i = 1, #data.lines do
					local lineData = data.lines[i]
					local argVal = lineData and lineData.args
					local text = lineData and lineData.leftText
					if text then
						if strfind(text, COLLECTED) or text == ITEM_SPELL_KNOWN then
							knowns[link] = true
							return true
						end
					end
				end
			end
		end
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
		if itemButton and itemButton:IsShown() then
			local info = C_MerchantFrame_GetItemInfo(index)
			local numAvailable, isUsable = info.numAvailable, info.isUsable
			if isUsable and IsAlreadyKnown(GetMerchantItemLink(index)) then
				if self.db.mode == "MONOCHROME" then
					_G["MerchantItem" .. i .. "ItemButtonIconTexture"]:SetDesaturated(true)
				else
					local r, g, b = self.db.color.r, self.db.color.g, self.db.color.b
					if numAvailable == 0 then
						r, g, b = r * 0.5, g * 0.5, b * 0.5
					end
					SetItemButtonTextureVertexColor(itemButton, 0.9 * r, 0.9 * g, 0.9 * b)
				end
			else
				_G["MerchantItem" .. i .. "ItemButtonIconTexture"]:SetDesaturated(false)
			end
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
			if isUsable and IsAlreadyKnown(GetBuybackItemLink(index)) then
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

	local tab = GetCurrentGuildBankTab()
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
				if IsAlreadyKnown(GetGuildBankItemLink(tab, i), i) then
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

				if itemLink and IsAlreadyKnown(itemLink) then
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
		self.StopRunning = "AlreadyKnonwn"
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
		self.StopRunning = "AlreadyKnonwn"
		return
	end

	self.db = E.db.WT.item.alreadyKnown

	if self.db.enable and not self.initialized then
		self:Initialize()
	end
end

AK.ProfileUpdate = AK.ToggleSetting

W:RegisterModule(AK:GetName())
