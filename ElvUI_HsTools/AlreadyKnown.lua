-- 已学配方染色
-- 原作者：ItemInfo
-- 修改：houshuu

local ADDON_NAME = ...
--local _G = getfenv(0)
local knownTable = {} -- Save known items for later use
local db
local questItems = { -- Quest items and matching quests
	-- Equipment Blueprint: Tuskarr Fishing Net
	[128491] = 39359, -- Alliance
	[128251] = 39359, -- Horde
	-- Equipment Blueprint: Unsinkable
	[128250] = 39358, -- Alliance
	[128489] = 39358, -- Horde
}

-- Tooltip and scanning by Phanx @ http://www.wowinterface.com/forums/showthread.php?p=271406
-- Search string by Phanx @ https://github.com/Phanx/BetterBattlePetTooltip/blob/master/Addon.lua
local S_PET_KNOWN = strmatch(_G.ITEM_PET_KNOWN, "[^%(]+")

local scantip = CreateFrame("GameTooltip", "AKScanningTooltip", nil, "GameTooltipTemplate")
scantip:SetOwner(UIParent, "ANCHOR_NONE")

local function _checkIfKnown(itemLink)
	if knownTable[itemLink] then -- Check if we have scanned this item already and it was known then
		return true
	end

	local itemID = tonumber(itemLink:match("item:(%d+)"))
	if itemID and questItems[itemID] then -- Check if item is a quest item.
		if IsQuestFlaggedCompleted(questItems[itemID]) then -- Check if the quest for item is already done.
			knownTable[itemLink] = true -- Mark as known for later use
			return true -- This quest item is already known
		end
		return false -- Quest item is uncollected... or something went wrong
	end

	if itemLink:match("|H(.-):") == "battlepet" then -- Check if item is Caged Battlepet (dummy item 82800)
		local _, battlepetID = strsplit(":", itemLink)
		if C_PetJournal.GetNumCollectedInfo(battlepetID) > 0 then
			knownTable[itemLink] = true -- Mark as known for later use
			return true -- Battlepet is collected
		end
		return false -- Battlepet is uncollected... or something went wrong
	end

	scantip:ClearLines()
	scantip:SetHyperlink(itemLink)

	for i = 2, scantip:NumLines() do -- Line 1 is always the name so you can skip it.
		local text = _G["AKScanningTooltipTextLeft"..i]:GetText()
		if text == _G.ITEM_SPELL_KNOWN or strmatch(text, S_PET_KNOWN) then
			knownTable[itemLink] = true -- Mark as known for later use
			return true -- Item is known and collected
		end
	end
	return false -- Item is not known, uncollected... or something went wrong
end

hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function() -- Most of this found from FrameXML/MerchantFrame.lua
	for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
		local index = (((MerchantFrame.page - 1) * _G.MERCHANT_ITEMS_PER_PAGE) + i)
		local itemButton = _G["MerchantItem"..i.."ItemButton"]
		local merchantButton = _G["MerchantItem"..i]
		local itemLink = GetMerchantItemLink(index)

		if itemLink and _checkIfKnown(itemLink) then
			SetItemButtonNameFrameVertexColor(merchantButton, db.r, db.g, db.b)
			SetItemButtonSlotVertexColor(merchantButton, db.r, db.g, db.b)
			SetItemButtonTextureVertexColor(itemButton, 0.9*db.r, 0.9*db.g, 0.9*db.b)
			SetItemButtonNormalTextureVertexColor(itemButton, 0.9*db.r, 0.9*db.g, 0.9*db.b)

			if db.monochrome then
				_G["MerchantItem"..i.."ItemButtonIconTexture"]:SetDesaturated(true)
			end
		else
			_G["MerchantItem"..i.."ItemButtonIconTexture"]:SetDesaturated(false)
		end
	end
end)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" and (...) == ADDON_NAME then
		if IsAddOnLoaded("Blizzard_AuctionUI") then
			self:UnregisterEvent("ADDON_LOADED")
			hooksecurefunc("AuctionFrameBrowse_Update", function() -- Most of this found from AddOns/Blizzard_AuctionUI/Blizzard_AuctionUI.lua
				local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)

				for i=1, _G.NUM_BROWSE_TO_DISPLAY do
					local itemLink = GetAuctionItemLink('list', offset + i)

					if itemLink and _checkIfKnown(itemLink) then
						_G["BrowseButton"..i.."ItemIconTexture"]:SetVertexColor(db.r, db.g, db.b)
						if db.monochrome then
							_G["BrowseButton"..i.."ItemIconTexture"]:SetDesaturated(true)
						end
					else
						_G["BrowseButton"..i.."ItemIconTexture"]:SetVertexColor(1, 1, 1)
						_G["BrowseButton"..i.."ItemIconTexture"]:SetDesaturated(false)
					end
				end
			end)
		end

		if type(AlreadyKnownSettings) ~= "table" then
			AlreadyKnownSettings = {r = 0, g = 1, b = 0, monochrome = false}
		end
		db = AlreadyKnownSettings
	elseif event == "ADDON_LOADED" and (...) == "Blizzard_AuctionUI" then
		if IsAddOnLoaded(ADDON_NAME) then
			self:UnregisterEvent("ADDON_LOADED")
		end

		hooksecurefunc("AuctionFrameBrowse_Update", function() -- Most of this found from AddOns/Blizzard_AuctionUI/Blizzard_AuctionUI.lua
			local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)

			for i=1, _G.NUM_BROWSE_TO_DISPLAY do
				local itemLink = GetAuctionItemLink('list', offset + i)

				if itemLink and _checkIfKnown(itemLink) then
					_G["BrowseButton"..i.."ItemIconTexture"]:SetVertexColor(db.r, db.g, db.b)
					if db.monochrome then
						_G["BrowseButton"..i.."ItemIconTexture"]:SetDesaturated(true)
					end
				else
					_G["BrowseButton"..i.."ItemIconTexture"]:SetVertexColor(1, 1, 1)
					_G["BrowseButton"..i.."ItemIconTexture"]:SetDesaturated(false)
				end
			end
		end)
	end
end)

local function _RGBToHex(r, g, b)
	r = r <= 255 and r >= 0 and r or 0
	g = g <= 255 and g >= 0 and g or 0
	b = b <= 255 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r, g, b)
end

local function _changedCallback(restore)
	local R, G, B
	if restore then -- The user bailed, we extract the old color from the table created by ShowColorPicker.
		R, G, B = unpack(restore)
	else -- Something changed
		R, G, B = ColorPickerFrame:GetColorRGB()
	end

	db.r, db.g, db.b = R, G, B
	DEFAULT_CHAT_FRAME:AddMessage("|cffffcc00".. ADDON_NAME ..":|r |cff".._RGBToHex(db.r*255, db.g*255, db.b*255).."custom|r monochrome ".. (db.monochrome and "|cff00ff00true|r" or "|cffff0000false|r"))
end

local function _ShowColorPicker(r, g, b, a, changedCallback)
	ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = false, 1
	ColorPickerFrame.previousValues = { r, g, b }
	ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = changedCallback, changedCallback, changedCallback
	ColorPickerFrame:SetColorRGB(r, g, b)
	ColorPickerFrame:Hide() -- Need to run the OnShow handler.
	ColorPickerFrame:Show()
end