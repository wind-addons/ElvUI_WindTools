-- 原作：Already Known?
-- 原作者：ahak (https://wow.curseforge.com/projects/alreadyknown)

local W, F, E, L = unpack(select(2, ...))
local AK = W:NewModule("AlreadyKnown", "AceEvent-3.0", "AceHook-3.0")
local Search = E.Libs.ItemSearch

local _G = _G
local mod, min, ceil, tonumber, strsplit, strmatch, format = mod, min, ceil, tonumber, strsplit, strmatch, format

local IsAddOnLoaded = IsAddOnLoaded
local GetItemInfo = GetItemInfo
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

local db = {
	r = 0,
	g = 1,
	b = 0
}

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
		return
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
		return true
	end

	-- 找到 已收集 字符串（小宠物）
	if Search:Tooltip(itemLink, PetKnownString) then
		return true
	end

	return false
end

function AK:Merchant()
	for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
		local index = (((MerchantFrame.page - 1) * _G.MERCHANT_ITEMS_PER_PAGE) + i)
		local itemButton = _G["MerchantItem" .. i .. "ItemButton"]
		local merchantButton = _G["MerchantItem" .. i]
		local itemLink = GetMerchantItemLink(index)

		if itemLink and IsAlreadyKnown(itemLink) then
			SetItemButtonNameFrameVertexColor(merchantButton, db.r, db.g, db.b)
			SetItemButtonSlotVertexColor(merchantButton, db.r, db.g, db.b)
			SetItemButtonTextureVertexColor(itemButton, 0.9 * db.r, 0.9 * db.g, 0.9 * db.b)
			SetItemButtonNormalTextureVertexColor(itemButton, 0.9 * db.r, 0.9 * db.g, 0.9 * db.b)

			if db.monochrome then
				_G["MerchantItem" .. i .. "ItemButtonIconTexture"]:SetDesaturated(true)
			end
		else
			_G["MerchantItem" .. i .. "ItemButtonIconTexture"]:SetDesaturated(false)
		end
	end
end

function AK:GuildBank()
	local tab = GetCurrentGuildBankTab()

	for i = 1, _G.MAX_GUILDBANK_SLOTS_PER_TAB do
		index = mod(i, _G.NUM_SLOTS_PER_GUILDBANK_GROUP)

		if (index == 0) then
			index = _G.NUM_SLOTS_PER_GUILDBANK_GROUP
		end

		column = ceil((i - .5) / _G.NUM_SLOTS_PER_GUILDBANK_GROUP)
		button = _G["GuildBankColumn" .. column .. "Button" .. index]

		local _ = GetGuildBankItemInfo(tab, i)
		local itemLink = GetGuildBankItemLink(tab, i)

		if itemLink and IsAlreadyKnown(itemLink) then
			SetItemButtonTextureVertexColor(button, 0.9 * db.r, 0.9 * db.g, 0.9 * db.b)
			SetItemButtonNormalTextureVertexColor(button, 0.9 * db.r, 0.9 * db.g, 0.9 * db.b)
			SetItemButtonDesaturated(button, db.monochrome)
		end
	end
end

function AK:AutionHouse()
	local frame = _G.RefreshScrollFrame
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
					button.SelectedHighlight:SetVertexColor(db.r, db.g, db.b)
					button.SelectedHighlight:SetAlpha(.2)

					button.cells[2].Icon:SetVertexColor(db.r, db.g, db.b)
					button.cells[2].IconBorder:SetVertexColor(db.r, db.g, db.b)
					button.cells[2].Icon:SetDesaturated(db.monochrome)
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

local numberOfHookedFunctions = 0

function AK:ADDON_LOADED(event, addOnName)
	if addOnName == "Blizzard_AuctionHouseUI" then
		local frame = _G.AuctionHouseFrame.BrowseResultsFrame.ItemList
		self:SecureHook(frame, "RefreshScrollFrame", "AutionHouseUI")
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

	self:SecureHook("MerchantFrame_UpdateMerchantInfo", "Merchant")

	self:RegisterEvent("ADDON_LOADED")
end

function AK:ProfileUpdate()
	if not E.db.WT.item.delete.enable then
		self:UnregisterEvent("DELETE_ITEM_CONFIRM")
	else
		self:Initialize()
	end
end

W:RegisterModule(AK:GetName())
