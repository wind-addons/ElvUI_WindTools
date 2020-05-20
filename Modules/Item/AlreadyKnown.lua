-- 原作：Already Known?
-- 原作者：ahak (https://wow.curseforge.com/projects/alreadyknown)

local W, F, E, L = unpack(select(2, ...))
local AK = W:NewModule("AlreadyKnown", "AceEvent-3.0", "AceHook-3.0")

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

local C_PetJournal_GetNumCollectedInfo = C_PetJournal.GetNumCollectedInfo

local MERCHANT_ITEMS_PER_PAGE = MERCHANT_ITEMS_PER_PAGE

local HybridScrollFrame_GetButtons = HybridScrollFrame_GetButtons

local db = {
	r = 0,
	g = 1,
	b = 0
}

local knownTable = {}

local questItems = {
	-- Quest items and matching quests
	-- Equipment Blueprint: Tuskarr Fishing Net
	[128491] = 39359, -- Alliance
	[128251] = 39359, -- Horde
	-- Equipment Blueprint: Unsinkable
	[128250] = 39358, -- Alliance
	[128489] = 39358 -- Horde
}

local specialItems = {
	-- Items needing special treatment
	-- Krokul Flute -> Flight Master's Whistle
	[152964] = {141605, 11, 269} -- 269 for Flute applied Whistle, 257 (or anything else than 269) for pre-apply Whistle
}

local containerItems = {
	-- These items are containers containing items we might know already, but don't get any marking about us knowing the contents already
	[21740] = {
		-- Small Rocket Recipes
		21724, -- Schematic: Small Blue Rocket
		21725, -- Schematic: Small Green Rocket
		21726 -- Schematic: Small Red Rocket
	},
	[21741] = {
		-- Cluster Rocket Recipes
		21730, -- Schematic: Blue Rocket Cluster
		21731, -- Schematic: Green Rocket Cluster
		21732 -- Schematic: Red Rocket Cluster
	},
	[21742] = {
		-- Large Rocket Recipes
		21727, -- Schematic: Large Blue Rocket
		21728, -- Schematic: Large Green Rocket
		21729 -- Schematic: Large Red Rocket
	},
	[21743] = {
		-- Large Cluster Rocket Recipes
		21733, -- Schematic: Large Blue Rocket Cluster
		21734, -- Schematic: Large Green Rocket Cluster
		21735 -- Schematic: Large Red Rocket Cluster
	},
	[128319] = {
		-- Void-Shrouded Satchel
		128318 -- Touch of the Void
	}
}

local function IsAlreadyKnown(itemLink)
	if knownTable[itemLink] then
		return true
	end

	local itemId = tonumber(itemLink:match("item:(%d+)"))

	if itemId and questItems[itemId] then
		return false
	elseif itemId and specialItems[itemId] then
		local specialData = specialItems[itemId]
		local _, specialLink = GetItemInfo(specialData[1])
		if specialLink then
			local specialTbl = {strsplit(":", specialLink)}
			local specialInfo = tonumber(specialTbl[specialData[2]])
			if specialInfo == specialData[3] then
				knownTable[itemLink] = true
				return true
			end
		end
		return false
	elseif itemId and containerItems[itemId] then
		local knownCount, totalCount = 0, 0
		for ci = 1, #containerItems[itemId] do
			totalCount = totalCount + 1
			local thisItem = IsAlreadyKnown(format("item:%d", containerItems[itemId][ci])) -- Checkception
			if thisItem then
				knownCount = knownCount + 1
			end
		end
		return (knownCount == totalCount)
	end

	if itemLink:match("|H(.-):") == "battlepet" then
		local _, battlepetId = strsplit(":", itemLink)
		if C_PetJournal_GetNumCollectedInfo(battlepetId) > 0 then
			knownTable[itemLink] = true
			return true
		end
		return false
	end

	E.ScanTooltip:ClearLines()
	E.ScanTooltip:SetHyperlink(itemLink)

	local lines = E.ScanTooltip:NumLines()
	for i = 2, lines do
		local text = _G["AKScanningTooltipTextLeft" .. i]:GetText()
		if text == _G.ITEM_SPELL_KNOWN or strmatch(text, S_PET_KNOWN) then
			if lines - i <= 3 then
				knownTable[itemLink] = true
			end
		elseif
			text == _G.TOY and _G["AKScanningTooltipTextLeft" .. i + 2] and
				_G["AKScanningTooltipTextLeft" .. i + 2]:GetText() == _G.ITEM_SPELL_KNOWN
		 then
			knownTable[itemLink] = true
		end
	end

	return knownTable[itemLink] and true or false
end

function AK:Merchant()
	for i = 1, MERCHANT_ITEMS_PER_PAGE do
		local index = (((_G.MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i)
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
