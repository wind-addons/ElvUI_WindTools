local W, F, E, L = unpack((select(2, ...)))
local IL = W:NewModule("ItemLevel", "AceEvent-3.0", "AceHook-3.0")
local B = E:GetModule("Bags")
local LSM = E.Libs.LSM

local _G = _G
local pairs = pairs
local select = select
local type = type

local EquipmentManager_UnpackLocation = EquipmentManager_UnpackLocation
local Item = Item
local ItemLocation = ItemLocation

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_Item_DoesItemExist = C_Item.DoesItemExist

local EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION = EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION

local function UpdateFlyoutItemLevelTextStyle(text, db)
	if db.useBagsFontSetting then
		text:FontTemplate(LSM:Fetch("font", B.db.itemLevelFont), B.db.itemLevelFontSize, B.db.itemLevelFontOutline)
		text:ClearAllPoints()
		text:Point(B.db.itemLevelPosition, B.db.itemLevelxOffset, B.db.itemLevelyOffset)
	else
		F.SetFontWithDB(text, db.font)
		text:ClearAllPoints()
		text:Point("BOTTOMRIGHT", db.font.xOffset, db.font.yOffset)
	end
end

local function RefreshItemLevel(text, db, location)
	if not text or not C_Item_DoesItemExist(location) then
		return
	end

	UpdateFlyoutItemLevelTextStyle(text, db)

	local item = Item:CreateFromItemLocation(location)
	item:ContinueOnItemLoad(function()
		text:SetText(item:GetCurrentItemLevel())
		F.SetFontColorWithDB(text, db.qualityColor and item:GetItemQualityColor() or db.font.color)
	end)
end

function IL:FlyoutButton()
	local flyout = _G.EquipmentFlyoutFrame
	local buttons = flyout.buttons
	local flyoutSettings = flyout.button:GetParent().flyoutSettings

	if not self.db.enable or not self.db.flyout.enable then
		if buttons then
			for _, button in pairs(buttons) do
				if button.itemLevel then
					button.itemLevel:SetText("")
				end
			end
		end
		return
	end

	for _, button in pairs(buttons) do
		if not button.itemLevel then
			button.itemLevel = button:CreateFontString(nil, "ARTWORK", nil, 1)
			UpdateFlyoutItemLevelTextStyle(button.itemLevel, self.db.flyout)
		end

		local itemLocation

		if flyoutSettings.useItemLocation then
			itemLocation = button.itemLocation
		elseif
			button.location
			and type(button.location) == "number"
			and not (button.location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION)
		then
			local bags, voidStorage, slot, bag = select(3, EquipmentManager_UnpackLocation(button.location))
			if not voidStorage then
				if bags then
					itemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)
				else
					itemLocation = ItemLocation:CreateFromEquipmentSlot(slot)
				end
			end
		end

		if itemLocation then
			RefreshItemLevel(button.itemLevel, self.db.flyout, itemLocation)
		else
			button.itemLevel:SetText("")
		end
	end
end

function IL:ScrappingMachineButton(button)
	if not self.db.enable or not self.db.scrappingMachine.enable or not button.itemLocation then
		if button.itemLevel then
			button.itemLevel:SetText("")
		end
		return
	end

	if not button.itemLevel then
		button.itemLevel = button:CreateFontString(nil, "ARTWORK", nil, 1)
	end

	RefreshItemLevel(button.itemLevel, self.db.scrappingMachine, button.itemLocation)
end

function IL:ADDON_LOADED(_, addon)
	if addon == "Blizzard_ScrappingMachineUI" then
		self:UnregisterEvent("ADDON_LOADED")
		self:ScrappingMachine_Loaded()
	end
end

function IL:ReskinAllButtonsInScrappingMachine()
	for button in _G.ScrappingMachineFrame.ItemSlots.scrapButtons:EnumerateActive() do
		if button and not button.__windItemLevelHooked then
			self:SecureHook(button, "RefreshIcon", "ScrappingMachineButton")
			button.__windItemLevelHooked = true
		end
	end
end

function IL:ScrappingMachine_Loaded()
	if
		not _G.ScrappingMachineFrame
		or not _G.ScrappingMachineFrame.ItemSlots
		or not _G.ScrappingMachineFrame.ItemSlots.scrapButtons
	then
		return
	end

	self:SecureHook(_G.ScrappingMachineFrame.ItemSlots.scrapButtons, "Acquire", "ReskinAllButtonsInScrappingMachine")
	self:ReskinAllButtonsInScrappingMachine()
end

function IL:ProfileUpdate()
	self.db = E.db.WT.item.itemLevel

	if self.db.enable and not self.initialized then
		self:SecureHook("EquipmentFlyout_UpdateItems", "FlyoutButton")
		if not C_AddOns_IsAddOnLoaded("Blizzard_ScrappingMachineUI") then
			self:RegisterEvent("ADDON_LOADED")
		else
			self:ScrappingMachine_Loaded()
		end

		self.initialized = true
	end
end

IL.Initialize = IL.ProfileUpdate

W:RegisterModule(IL:GetName())
