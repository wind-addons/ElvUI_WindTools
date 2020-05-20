-- 原作：Already Known?
-- 原作者：ahak (https://wow.curseforge.com/projects/alreadyknown)

local W, F, E, L = unpack(select(2, ...))
local AK = W:NewModule("AlreadyKnown", "AceEvent-3.0", "AceHook-3.0")

local _G = _G
local mod, ceil = mod, ceil
local IsAddOnLoaded = IsAddOnLoaded
local GetCurrentGuildBankTab = GetCurrentGuildBankTab
local SetItemButtonDesaturated = SetItemButtonDesaturated
local SetItemButtonTextureVertexColor = SetItemButtonTextureVertexColor
local SetItemButtonNormalTextureVertexColor = SetItemButtonNormalTextureVertexColor

local MAX_GUILDBANK_SLOTS_PER_TAB = MAX_GUILDBANK_SLOTS_PER_TAB
local NUM_SLOTS_PER_GUILDBANK_GROUP = NUM_SLOTS_PER_GUILDBANK_GROUP

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
	if knownTable[itemLink] then -- Check if we have scanned this item already and it was known then
		return true
	end

	local itemId = tonumber(itemLink:match("item:(%d+)"))
	--if itemId == 82800 then Print("itemLink:", gsub(itemLink, "\124", "\124\124")) end
	-- How to handle Pet Cages inside GBanks? They look like this and don't have any information about the pet inside:
	-- |cff0070dd|Hitem:82800::::::::120:269::::::|h[Pet Cage]|h|r
	if itemId and questItems[itemId] then -- Check if item is a quest item.
		if ((isClassic) and IsQuestFlaggedCompleted(questItems[itemId])) or ((not isClassic) and C_QuestLog.IsQuestFlaggedCompleted(questItems[itemId])) then -- Check if the quest for item is already done.
			if db.debug and not knownTable[itemLink] then Print("%d - QuestItem", itemId) end
			knownTable[itemLink] = true -- Mark as known for later use
			return true -- This quest item is already known
		end
		return false -- Quest item is uncollected... or something went wrong
	elseif itemId and specialItems[itemId] then -- Check if we need special handling, this is most likely going to break with then next item we add to this
		local specialData = specialItems[itemId]
		local _, specialLink = GetItemInfo(specialData[1])
		if specialLink then
			local specialTbl = { strsplit(":", specialLink) }
			local specialInfo = tonumber(specialTbl[specialData[2]])
			if specialInfo == specialData[3] then
				if db.debug and not knownTable[itemLink] then Print("%d, %d - SpecialItem", itemId, specialInfo) end
				knownTable[itemLink] = true -- Mark as known for later use
				return true -- This specialItem is already known
			end
		end
		return false -- Item is specialItem, but data isn't special
	elseif itemId and containerItems[itemId] then -- Check the known contents of the item
		local knownCount, totalCount = 0, 0
		for ci = 1, #containerItems[itemId] do
			totalCount = totalCount + 1
			local thisItem = _checkIfKnown(format("item:%d", containerItems[itemId][ci])) -- Checkception
			if thisItem then
				knownCount = knownCount + 1
			end
		end
		if db.debug and not knownTable[itemLink] then Print("%d (%d/%d) - ContainerItem", itemId, knownCount, totalCount) end
		return (knownCount == totalCount)
	end

	if not isClassic then -- No Pet Journal in Classic
		if itemLink:match("|H(.-):") == "battlepet" then -- Check if item is Caged Battlepet (dummy item 82800)
			local _, battlepetId = strsplit(":", itemLink)
			if C_PetJournal.GetNumCollectedInfo(battlepetId) > 0 then
				if db.debug and not knownTable[itemLink] then Print("%d - BattlePet: %s %d", itemId, battlepetId, C_PetJournal.GetNumCollectedInfo(battlepetId)) end
				knownTable[itemLink] = true -- Mark as known for later use
				return true -- Battlepet is collected
			end
			return false -- Battlepet is uncollected... or something went wrong
		end
	end

	scantip:ClearLines()
	scantip:SetHyperlink(itemLink)

	--for i = 2, scantip:NumLines() do -- Line 1 is always the name so you can skip it.
	local lines = scantip:NumLines()
	for i = 2, lines do -- Line 1 is always the name so you can skip it.
		local text = _G["AKScanningTooltipTextLeft"..i]:GetText()
		if text == _G.ITEM_SPELL_KNOWN or strmatch(text, S_PET_KNOWN) then
			if db.debug and not knownTable[itemLink] then Print("%d - Tip %d/%d: %s (%s / %s)", itemID, i, lines, tostring(text), text == _G.ITEM_SPELL_KNOWN and "true" or "false", strmatch(text, S_PET_KNOWN) and "true" or "false") end
			--knownTable[itemLink] = true -- Mark as known for later use
			--return true -- Item is known and collected
			if isClassic then -- Fix for Classic, hope this covers all the cases.
				knownTable[itemLink] = true -- Mark as known for later use
				return true -- Item is known and collected
			elseif lines - i <= 3 then -- Mounts have Riding skill and Reputation requirements under Already Known -line
				knownTable[itemLink] = true -- Mark as known for later use
			end
		elseif text == _G.TOY and _G["AKScanningTooltipTextLeft"..i + 2] and _G["AKScanningTooltipTextLeft"..i + 2]:GetText() == _G.ITEM_SPELL_KNOWN then
			-- Check if items is Toy already known
			if db.debug and not knownTable[itemLink] then Print("%d - Toy %d", itemId, i) end
			knownTable[itemLink] = true
		end
	end

	--return false -- Item is not known, uncollected... or something went wrong
	return knownTable[itemLink] and true or false
end

function AK:Merchant()
    print(self:GetName())
end

function AK:GuildBank()
    local tab = GetCurrentGuildBankTab()
	for i = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
		index = mod(i, NUM_SLOTS_PER_GUILDBANK_GROUP)
		if (index == 0) then
			index = NUM_SLOTS_PER_GUILDBANK_GROUP
		end
		column = ceil((i - .5) / NUM_SLOTS_PER_GUILDBANK_GROUP)
		button = _G["GuildBankColumn" .. column .. "Button" .. index]
		local _ = GetGuildBankItemInfo(tab, i)
		local itemLink = GetGuildBankItemLink(tab, i)

		if itemLink and IsAlreadyKnown(itemLink) then
			SetItemButtonTextureVertexColor(button, 0.9*db.r, 0.9*db.g, 0.9*db.b)
			SetItemButtonNormalTextureVertexColor(button, 0.9*db.r, 0.9*db.g, 0.9*db.b)
			SetItemButtonDesaturated(button, db.monochrome)
		end
	end
end

function AK:AutionHouse()
end

local numberOfHookedFunctions = 0

function AK:ADDON_LOADED(event, addOnName)
    if addOnName == "Blizzard_AuctionHouseUI" then
        local frame = _G.AuctionHouseFrame.BrowseResultsFrame.ItemList
        self:SecureHook(frame, "RefreshScrollFrame", "AutionHouseUI")
        numberOfHookedFunctions = numberOfHookedFunctions + 1
    elseif addOnName == "Blizzard_GuildBankUI" then
        --self:SecureHook("GuildBankFrame_Update", "GuildBank")
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
