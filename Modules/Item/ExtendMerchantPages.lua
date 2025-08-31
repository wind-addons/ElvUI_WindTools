local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local EMP = W:NewModule("ExtendMerchantPages", "AceHook-3.0")
local S = W.Modules.Skins ---@type Skins

local _G = _G
local floor = math.floor
local pairs = pairs
local unpack = unpack

local CreateFrame = CreateFrame
local GetNumBuybackItems = GetNumBuybackItems

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local BLIZZARD_MERCHANT_ITEMS_PER_PAGE = 10
local BLIZZARD_BUYBACK_ITEMS_PER_PAGE = 12

function EMP:SkinButton(index)
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.merchant) then
		return
	end

	local item = _G["MerchantItem" .. index]
	local button = _G["MerchantItem" .. index .. "ItemButton"]
	local icon = _G["MerchantItem" .. index .. "ItemButtonIconTexture"]
	local money = _G["MerchantItem" .. index .. "MoneyFrame"]
	local nameFrame = _G["MerchantItem" .. index .. "NameFrame"]
	local name = _G["MerchantItem" .. index .. "Name"]
	local slot = _G["MerchantItem" .. index .. "SlotTexture"]

	item:StripTextures(true)
	item:CreateBackdrop("Transparent")
	item:Size(155, 45)
	item.backdrop:Point("TOPLEFT", -1, 3)
	item.backdrop:Point("BOTTOMRIGHT", 2, -3)

	button:StripTextures()
	button:StyleButton()
	button:SetTemplate(nil, true)
	button:Size(40)
	button:Point("TOPLEFT", item, "TOPLEFT", 4, -2)

	icon:SetTexCoord(unpack(E.TexCoords))
	icon:SetInside()

	nameFrame:Point("LEFT", slot, "RIGHT", -6, -17)
	name:Point("LEFT", slot, "RIGHT", -4, 5)

	money:ClearAllPoints()
	money:Point("BOTTOMLEFT", button, "BOTTOMRIGHT", 3, 0)

	S:HandleMerchantItem(index)
	S:Proxy("HandleIconBorder", button.IconBorder)
end

function EMP:MerchantFrame_UpdateMerchantInfo()
	if not self.db or not self.db.enable then
		return
	end

	for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
		local button = _G["MerchantItem" .. i]
		if not button then
			break
		end

		button:Show()
		button:ClearAllPoints()

		if (i % BLIZZARD_MERCHANT_ITEMS_PER_PAGE) == 1 then
			if i == 1 then
				button:Point("TOPLEFT", _G.MerchantFrame, "TOPLEFT", 11, -69)
			else
				button:Point(
					"TOPLEFT",
					_G["MerchantItem" .. (i - (BLIZZARD_MERCHANT_ITEMS_PER_PAGE - 1))],
					"TOPRIGHT",
					12,
					0
				)
			end
		else
			if (i % 2) == 1 then
				button:Point("TOPLEFT", _G["MerchantItem" .. (i - 2)], "BOTTOMLEFT", 0, -8)
			else
				button:Point("TOPLEFT", _G["MerchantItem" .. (i - 1)], "TOPRIGHT", 12, 0)
			end
		end
	end
end

function EMP:MerchantFrame_UpdateBuybackInfo()
	if not self.db or not self.db.enable then
		return
	end

	local numBuybackItems = GetNumBuybackItems()

	for i = BLIZZARD_BUYBACK_ITEMS_PER_PAGE + 1, _G.MERCHANT_ITEMS_PER_PAGE do
		local button = _G["MerchantItem" .. i]
		if not button then
			break
		end

		button:ClearAllPoints()

		if i <= numBuybackItems then
			local row = floor((i - 1) / 3)
			local col = (i - 1) % 3

			if row == 0 then
				-- First row of buyback items
				if col == 0 then
					button:Point("TOPLEFT", _G.MerchantItem1, "TOPLEFT", 0, -60)
				else
					button:Point("TOPLEFT", _G["MerchantItem" .. (i - 1)], "TOPRIGHT", 12, 0)
				end
			else
				-- Subsequent rows
				if col == 0 then
					button:Point("TOPLEFT", _G["MerchantItem" .. (i - 3)], "BOTTOMLEFT", 0, -15)
				else
					button:Point("TOPLEFT", _G["MerchantItem" .. (i - 1)], "TOPRIGHT", 12, 0)
				end
			end
			button:Show()
		else
			button:Hide()
		end
	end
end

function EMP:Initialize()
	for _, addon in pairs({
		"ExtVendor",
		"Krowi_ExtendedVendorUI",
		"CompactVendor",
	}) do
		if C_AddOns_IsAddOnLoaded(addon) then
			self.StopRunning = addon
			return
		end
	end

	if not E.private.WT.item.extendMerchantPages.enable then
		return
	end

	self.db = E.private.WT.item.extendMerchantPages

	_G.MERCHANT_ITEMS_PER_PAGE = self.db.numberOfPages * BLIZZARD_MERCHANT_ITEMS_PER_PAGE
	_G.MerchantFrame:Width(30 + self.db.numberOfPages * 330)

	for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
		if not _G["MerchantItem" .. i] then
			local frame = CreateFrame("Frame", "MerchantItem" .. i, _G.MerchantFrame, "MerchantItemTemplate")
			self:SkinButton(i)

			local altCurrencyFrame = frame:GetChild("AltCurrencyFrame") or _G["MerchantItem" .. i .. "AltCurrencyFrame"]
			if altCurrencyFrame then
				altCurrencyFrame:Hide()
			end
		end
	end

	_G.MerchantBuyBackItem:ClearAllPoints()
	_G.MerchantBuyBackItem:Point("TOPLEFT", _G.MerchantItem10, "BOTTOMLEFT", 30, -53)

	-- Position page navigation buttons relative to the extended frame width
	local buttonOffset = 25 + ((self.db.numberOfPages - 1) * 165) -- Center the buttons in the extended frame

	_G.MerchantPrevPageButton:ClearAllPoints()
	_G.MerchantPrevPageButton:Point("CENTER", _G.MerchantFrame, "BOTTOMLEFT", buttonOffset, 93)
	F.SetFontOutline(_G.MerchantPageText)
	_G.MerchantPageText:ClearAllPoints()
	_G.MerchantPageText:Point("BOTTOM", _G.MerchantFrame, "BOTTOM", 0, 86)
	_G.MerchantNextPageButton:ClearAllPoints()
	_G.MerchantNextPageButton:Point("CENTER", _G.MerchantFrame, "BOTTOMRIGHT", -buttonOffset, 93)

	self:SecureHook("MerchantFrame_UpdateMerchantInfo", "MerchantFrame_UpdateMerchantInfo")
	self:SecureHook("MerchantFrame_UpdateBuybackInfo", "MerchantFrame_UpdateBuybackInfo")
end

function EMP:ProfileUpdate()
	self.db = E.private.WT.item.extendMerchantPages

	if self.db.enable and not self.initialized then
		self:Initialize()
	end
end

W:RegisterModule(EMP:GetName())
