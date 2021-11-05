local W, F, E, L = unpack(select(2, ...))
local Scanner = E.Libs.ItemSearch.Scanner
local AK = W:NewModule("AlreadyKnown", "AceEvent-3.0", "AceHook-3.0")

local _G = _G
local ceil = ceil
local format = format
local gsub = gsub
local min = min
local mod = mod
local strmatch = strmatch
local strsplit = strsplit
local tonumber = tonumber

local GetCurrentGuildBankTab = GetCurrentGuildBankTab
local GetGuildBankItemLink = GetGuildBankItemLink
local GetItemInfo = GetItemInfo
local GetMerchantItemLink = GetMerchantItemLink
local HybridScrollFrame_GetButtons = HybridScrollFrame_GetButtons
local IsAddOnLoaded = IsAddOnLoaded
local SetItemButtonDesaturated = SetItemButtonDesaturated
local SetItemButtonNameFrameVertexColor = SetItemButtonNameFrameVertexColor
local SetItemButtonNormalTextureVertexColor = SetItemButtonNormalTextureVertexColor
local SetItemButtonSlotVertexColor = SetItemButtonSlotVertexColor
local SetItemButtonTextureVertexColor = SetItemButtonTextureVertexColor

local C_PetJournal_GetNumCollectedInfo = C_PetJournal.GetNumCollectedInfo
local C_QuestLog_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted

local S_PET_KNOWN = strmatch(_G.ITEM_PET_KNOWN, "[^%(]+")
local S_ITEM_MIN_LEVEL = "^" .. gsub(_G.ITEM_MIN_LEVEL, "%%d", "(%%d+)")
local S_ITEM_CLASSES_ALLOWED = "^" .. gsub(_G.ITEM_CLASSES_ALLOWED, "%%s", "(%%a+)")

local knownTable = {}

local questItems = {
	[128491] = 39359,
	[128251] = 39359,
	[128250] = 39358,
	[128489] = 39358,
	[181313] = 62420,
	[181314] = 62421,
	[182165] = 62422,
	[182166] = 62423,
	[182168] = 62424,
	[182169] = 62425,
	[182170] = 62426,
	[182171] = 62427,
	[182172] = 62428,
	[182174] = 62429,
	[182175] = 62430,
	[182176] = 62431,
	[182177] = 62432,
	[182178] = 62433,
	[182179] = 62434,
	[182180] = 62435,
	[182181] = 62437,
	[182182] = 62438,
	[182183] = 62439,
	[182184] = 62440,
	[182185] = 62436
}

local specialItems = {
	[152964] = {141605, 11, 269}
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
		if C_QuestLog_IsQuestFlaggedCompleted(questItems[itemId]) then
			knownTable[itemLink] = true
			return true
		end
		return false
	elseif specialItems[itemId] then -- Check if we need special handling, this is most likely going to break with then next item we add to this
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

	Scanner:ClearLines()
	Scanner:SetOwner(_G.UIParent, "ANCHOR_NONE")
	Scanner:SetHyperlink(itemLink)

	local prefix = Scanner:GetName() .. "TextLeft"

	local lines = Scanner:NumLines()
	local comboLevelClass = 0
	local comboLevelTemp = 0

	for i = 2, lines do
		local text = _G[prefix .. i]:GetText()
		if text == _G.ITEM_SPELL_KNOWN or strmatch(text, S_PET_KNOWN) then
			if lines - i <= 3 then
				knownTable[itemLink] = true
			end
		elseif text == _G.TOY and _G[prefix .. i + 2] and _G[prefix .. i + 2]:GetText() == _G.ITEM_SPELL_KNOWN then
			knownTable[itemLink] = true
		end
	end
	return knownTable[itemLink] and true or false
end

function AK:Merchant()
	if not self.db.enable then
		return
	end

	local r, g, b = self.db.color.r, self.db.color.g, self.db.color.b

	for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
		local index = (((_G.MerchantFrame.page - 1) * _G.MERCHANT_ITEMS_PER_PAGE) + i)
		local itemButton = _G["MerchantItem" .. i .. "ItemButton"]
		local merchantButton = _G["MerchantItem" .. i]
		local itemLink = GetMerchantItemLink(index)

		if itemLink and IsAlreadyKnown(itemLink) then
			SetItemButtonNameFrameVertexColor(merchantButton, r, g, b)
			SetItemButtonSlotVertexColor(merchantButton, r, g, b)
			SetItemButtonTextureVertexColor(itemButton, 0.9 * r, 0.9 * g, 0.9 * b)
			SetItemButtonNormalTextureVertexColor(itemButton, 0.9 * r, 0.9 * g, 0.9 * b)

			_G["MerchantItem" .. i .. "ItemButtonIconTexture"]:SetDesaturated(self.db.mode == "MONOCHROME")
		else
			_G["MerchantItem" .. i .. "ItemButtonIconTexture"]:SetDesaturated(false)
		end
	end
end

do
	local MAX_GUILDBANK_SLOTS_PER_TAB = _G.MAX_GUILDBANK_SLOTS_PER_TAB or 98 -- These ain't Globals anymore in the new Mixin version so fallback for hardcoded version
	local NUM_SLOTS_PER_GUILDBANK_GROUP = _G.NUM_SLOTS_PER_GUILDBANK_GROUP or 14
	function AK:GuildBank()
		if not self.db.enable then
			return
		end
		local r, g, b = self.db.color.r, self.db.color.g, self.db.color.b

		local tab = GetCurrentGuildBankTab()
		for i = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
			local index = mod(i, NUM_SLOTS_PER_GUILDBANK_GROUP)
			if (index == 0) then
				index = NUM_SLOTS_PER_GUILDBANK_GROUP
			end
			local column = ceil((i - 0.5) / NUM_SLOTS_PER_GUILDBANK_GROUP)
			local button = _G.GuildBankFrame.Columns[column].Buttons[index]
			local itemLink = GetGuildBankItemLink(tab, i)

			if itemLink and itemLink:match("item:82800") then
				Scanner:ClearLines()
				Scanner:SetOwner(_G.UIParent, "ANCHOR_NONE")
				local speciesId = Scanner:SetGuildBankItem(tab, i)

				if speciesId and speciesId > 0 then
					itemLink = format("|Hbattlepet:%d::::::|h[Dummy]|h", speciesId)
				end
			end

			if itemLink and IsAlreadyKnown(itemLink) then
				SetItemButtonTextureVertexColor(button, 0.9 * r, 0.9 * g, 0.9 * b)
				button:GetNormalTexture():SetVertexColor(0.9 * r, 0.9 * g, 0.9 * b)
				SetItemButtonDesaturated(button, self.db.mode == "MONOCHROME")
			else
				SetItemButtonTextureVertexColor(button, 1, 1, 1)
				button:GetNormalTexture():SetVertexColor(1, 1, 1)
				SetItemButtonDesaturated(button, false)
			end
		end
	end
end

function AK:AuctionHouse(frame)
	if not self.db.enable then
		return
	end

	local r, g, b = self.db.color.r, self.db.color.g, self.db.color.b

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
					button.SelectedHighlight:SetVertexColor(r, g, b)
					button.SelectedHighlight:SetAlpha(.2)
					button.cells[2].Icon:SetVertexColor(r, g, b)
					button.cells[2].IconBorder:SetVertexColor(r, g, b)
					button.cells[2].Icon:SetDesaturated(self.db.mode == "MONOCHROME")
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

do
	local numberOfHookedFunctions = 0
	function AK:ADDON_LOADED(event, addOnName)
		if addOnName == "Blizzard_AuctionHouseUI" then
			local frame = _G.AuctionHouseFrame.BrowseResultsFrame.ItemList
			self:SecureHook(frame, "RefreshScrollFrame", "AuctionHouse")
			numberOfHookedFunctions = numberOfHookedFunctions + 1
		elseif addOnName == "Blizzard_GuildBankUI" then
			self:SecureHook(_G.GuildBankFrame, "Update", "GuildBank")
			numberOfHookedFunctions = numberOfHookedFunctions + 1
		end

		if numberOfHookedFunctions == 2 then
			self:UnregisterEvent("ADDON_LOADED")
		end
	end
end

function AK:Initialize()
	if IsAddOnLoaded("AlreadyKnown") then
		self.StopRunning = "AlreadyKnonwn"
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
