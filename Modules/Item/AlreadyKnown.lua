local W, F, E, L = unpack(select(2, ...))
local Search = E.Libs.ItemSearch
local AK = W:NewModule("AlreadyKnown", "AceEvent-3.0", "AceHook-3.0")

local _G = _G
local mod, min, ceil, tonumber, strsplit, strmatch, format = mod, min, ceil, tonumber, strsplit, strmatch, format
local IsAddOnLoaded = IsAddOnLoaded
local GetItemInfo = GetItemInfo
local GetGuildBankItemInfo = GetGuildBankItemInfo
local GetGuildBankItemLink = GetGuildBankItemLink
local GetCurrentGuildBankTab = GetCurrentGuildBankTab
local GetMerchantItemLink = GetMerchantItemLink
local SetItemButtonDesaturated = SetItemButtonDesaturated
local SetItemButtonSlotVertexColor = SetItemButtonSlotVertexColor
local SetItemButtonTextureVertexColor = SetItemButtonTextureVertexColor
local SetItemButtonNameFrameVertexColor = SetItemButtonNameFrameVertexColor
local SetItemButtonNormalTextureVertexColor = SetItemButtonNormalTextureVertexColor
local HybridScrollFrame_GetButtons = HybridScrollFrame_GetButtons
local C_PetJournal_GetNumCollectedInfo = C_PetJournal.GetNumCollectedInfo

local PetKnownString = strmatch(_G.ITEM_PET_KNOWN, "[^%(]+")
local numberOfHookedFunctions = 0

local knownTable = {}

local questItems = {
	[128491] = 39359,
	[128251] = 39359,
	[128250] = 39358,
	[128489] = 39358
}

local containerItems = {
	[21740] = {
		21724,
		21725,
		21726
	},
	[21741] = {
		21730,
		21731,
		21732
	},
	[21742] = {
		21727,
		21728,
		21729
	},
	[21743] = {
		21733,
		21734,
		21735
	},
	[128319] = {
		128318
	}
}

local function IsAlreadyKnown(itemLink)
	if knownTable[itemLink] then
		return true
	end

	local itemId = tonumber(itemLink:match("item:(%d+)"))

	if not itemId then
		return false
	end

	if questItems[itemId] then
		return false
	elseif containerItems[itemId] then
		local knownCount, totalCount = 0, 0
		for ci = 1, #containerItems[itemId] do
			totalCount = totalCount + 1
			local thisItem = IsAlreadyKnown(format("item:%d", containerItems[itemId][ci])) -- Checkception
			if thisItem then
				knownCount = knownCount + 1
			end
		end
		return (knownCount == totalCount)
	elseif itemId == 152964 then
		local _, specialLink = GetItemInfo(141605)
		if specialLink then
			local specialTbl = {strsplit(":", specialLink)}
			local specialInfo = tonumber(specialTbl[11])
			if specialInfo == 269 then
				knownTable[itemLink] = true
				return true
			end
		else
			return false
		end
	end

	if itemLink:match("|H(.-):") == "battlepet" then
		local _, battlepetId = strsplit(":", itemLink)
		if C_PetJournal_GetNumCollectedInfo(battlepetId) > 0 then
			knownTable[itemLink] = true
			return true
		end
		return false
	end

	-- 找到 已经学会 字符串（物品，玩具）
	if Search:Tooltip(itemLink, _G.ITEM_SPELL_KNOWN) then
		knownTable[itemLink] = true
		return true
	end

	-- 找到 已收集 字符串（小宠物）
	if Search:Tooltip(itemLink, PetKnownString) then
		knownTable[itemLink] = true
		return true
	end

	return false
end

function AK:Merchant()
	if not self.db.enable then
		return
	end

	for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
		local index = (((_G.MerchantFrame.page - 1) * _G.MERCHANT_ITEMS_PER_PAGE) + i)
		local itemButton = _G["MerchantItem" .. i .. "ItemButton"]
		local merchantButton = _G["MerchantItem" .. i]
		local itemLink = GetMerchantItemLink(index)

		if itemLink and IsAlreadyKnown(itemLink) then
			if self.db.mode == "MONOCHROME" then
				_G["MerchantItem" .. i .. "ItemButtonIconTexture"]:SetDesaturated(true)
			else
				local r, g, b = self.db.color.r, self.db.color.g, self.db.color.b
				SetItemButtonNameFrameVertexColor(merchantButton, r, g, b)
				SetItemButtonSlotVertexColor(merchantButton, r, g, b)
				SetItemButtonTextureVertexColor(itemButton, 0.9 * r, 0.9 * g, 0.9 * b)
				SetItemButtonNormalTextureVertexColor(itemButton, 0.9 * r, 0.9 * g, 0.9 * b)
			end
		else
			_G["MerchantItem" .. i .. "ItemButtonIconTexture"]:SetDesaturated(false)
		end
	end
end

function AK:GuildBank()
	if not self.db.enable then
		return
	end

	local tab = GetCurrentGuildBankTab()

	for i = 1, _G.MAX_GUILDBANK_SLOTS_PER_TAB do
		local index = mod(i, _G.NUM_SLOTS_PER_GUILDBANK_GROUP)

		if (index == 0) then
			index = _G.NUM_SLOTS_PER_GUILDBANK_GROUP
		end

		local column = ceil((i - .5) / _G.NUM_SLOTS_PER_GUILDBANK_GROUP)
		local button = _G["GuildBankColumn" .. column .. "Button" .. index]

		local _ = GetGuildBankItemInfo(tab, i)
		local itemLink = GetGuildBankItemLink(tab, i)

		if itemLink and IsAlreadyKnown(itemLink) then
			if self.db.mode == "MONOCHROME" then
				SetItemButtonDesaturated(button, true)
			else
				local r, g, b = self.db.color.r, self.db.color.g, self.db.color.b
				SetItemButtonTextureVertexColor(button, 0.9 * r, 0.9 * g, 0.9 * b)
				SetItemButtonNormalTextureVertexColor(button, 0.9 * r, 0.9 * g, 0.9 * b)
			end
		end
	end
end

function AK:AutionHouse()
	if not self.db.enable then
		return
	end

	local frame = _G.AuctionHouseFrame.BrowseResultsFrame.ItemList
	local numResults = frame.getNumEntries()
	local buttons = HybridScrollFrame_GetButtons(frame.ScrollFrame)
	local buttonCount = buttons and #buttons or 0
	local offset = frame:GetScrollOffset()
	local populateCount = min(buttonCount, numResults)
	for i = 1, buttonCount do
		local visible = i + offset <= numResults
		local button = buttons[i]
		if visible then
			if button.rowData.itemKey.itemID then
				local itemLink
				if button.rowData.itemKey.itemID == 82800 then -- BattlePet
					itemLink = format("|Hbattlepet:%d::::::|h[Dummy]|h", button.rowData.itemKey.battlePetSpeciesID)
				else
					itemLink = format("item:%d", button.rowData.itemKey.itemID)
				end

				if itemLink and IsAlreadyKnown(itemLink) then
					button.SelectedHighlight:Show()
					button.SelectedHighlight:SetAlpha(.2)
					if self.db.mode == "MONOCHROME" then
						button.SelectedHighlight:SetVertexColor(1, 1, 1)
						button.cells[2].Icon:SetDesaturated(true)
					else
						local r, g, b = self.db.color.r, self.db.color.g, self.db.color.b
						button.SelectedHighlight:SetVertexColor(r, g, b)
						button.cells[2].Icon:SetVertexColor(r, g, b)
						button.cells[2].IconBorder:SetVertexColor(r, g, b)
					end
				else
					button.SelectedHighlight:SetVertexColor(1, 1, 1)
					button.cells[2].Icon:SetVertexColor(1, 1, 1)
					button.cells[2].IconBorder:SetVertexColor(1, 1, 1)
					button.cells[2].Icon:SetDesaturated(false)
				end
			end
		end
	end
end

function AK:ADDON_LOADED(event, addOnName)
	if addOnName == "Blizzard_AuctionHouseUI" then
		local frame = _G.AuctionHouseFrame.BrowseResultsFrame.ItemList
		self:SecureHook(frame, "RefreshScrollFrame", "AutionHouse")
		numberOfHookedFunctions = numberOfHookedFunctions + 1
	elseif addOnName == "Blizzard_GuildBankUI" then
		self:SecureHook("GuildBankFrame_Update", "GuildBank")
		numberOfHookedFunctions = numberOfHookedFunctions + 1
	end

	if numberOfHookedFunctions == 2 then
		self:UnregisterEvent("ADDON_LOADED")
	end
end

function AK:Initialize()
	if IsAddOnLoaded("AlreadyKnown") then
		return
	end

	if not E.db.WT.item.alreadyKnown.enable then
		return
	end

	self.db = E.db.WT.item.alreadyKnown
	self.initialized = true
	self:SecureHook("MerchantFrame_UpdateMerchantInfo", "Merchant")
	self:RegisterEvent("ADDON_LOADED")
end

function AK:ToggleSetting()
	if IsAddOnLoaded("AlreadyKnown") then
		return
	end

	self.db = E.db.WT.item.alreadyKnown

	if self.db.enable and not self.initialized then
		self:Initialize()
	end
end

AK.ProfileUpdate = AK.ToggleSetting

W:RegisterModule(AK:GetName())
