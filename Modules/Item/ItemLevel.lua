local W, F, E, L = unpack(select(2, ...))
local IL = W:NewModule("ItemLevel", "AceEvent-3.0", "AceHook-3.0")
local B = E:GetModule("Bags")
local LSM = E.Libs.LSM

local _G = _G
local pairs = pairs
local select = select

local ItemLocation = _G.ItemLocation
local IsAddOnLoaded = IsAddOnLoaded
local EquipmentManager_UnpackLocation = EquipmentManager_UnpackLocation

local C_Item_DoesItemExist = C_Item.DoesItemExist
local C_Item_GetCurrentItemLevel = C_Item.GetCurrentItemLevel
local C_Item_GetItemQuality = C_Item.GetItemQuality

local ITEM_QUALITY_COLORS = ITEM_QUALITY_COLORS
local EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION = EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION

local function RefreshItemLevel(text, db, location)

    if not text or not C_Item_DoesItemExist(location) then
        return
    end

    if db.useBagsFontSetting then
        text:FontTemplate(LSM:Fetch("font", B.db.itemLevelFont), B.db.itemLevelFontSize, B.db.itemLevelFontOutline)
        text:ClearAllPoints()
        text:Point(B.db.itemLevelPosition, B.db.itemLevelxOffset, B.db.itemLevelyOffset)
    else
        F.SetFontWithDB(text, db.font)
        text:ClearAllPoints()
        text:Point("BOTTOMRIGHT", db.font.xOffset, db.font.yOffset)
    end

    local itemLevel = C_Item_GetCurrentItemLevel(location)

    if not itemLevel then
        return
    end

    text:SetText(itemLevel)

    if db.qualityColor then
        F.SetFontColorWithDB(text, ITEM_QUALITY_COLORS[C_Item_GetItemQuality(location) or 1])
    else
        F.SetFontColorWithDB(text, db.font.color)
    end
end

function IL:FlyoutButton(button)
    if
        not self.db.enable or not self.db.flyout.enable or not button.location or
            button.location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION
     then
        if button.itemLevel then
            button.itemLevel:SetText("")
        end
        return
    end

    local bags, voidStorage, slot, bag = select(3, EquipmentManager_UnpackLocation(button.location))
    if voidStorage then
        return
    end

    local itemLocation = nil
    if bags then
        itemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)
    else
        itemLocation = ItemLocation:CreateFromEquipmentSlot(slot)
    end

    if not button.itemLevel then
        button.itemLevel = button:CreateFontString(nil, "ARTWORK", nil, 1)
    end

    RefreshItemLevel(button.itemLevel, self.db.flyout, itemLocation)
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
        self:HookScrappingMachine()
    end
end

function IL:HookScrappingMachine()
    if _G.ScrappingMachineFrame then
        for button in pairs(_G.ScrappingMachineFrame.ItemSlots.scrapButtons.activeObjects) do
            self:SecureHook(button, "RefreshIcon", "ScrappingMachineButton")
        end
    end
end

function IL:ProfileUpdate()
    self.db = E.db.WT.item.itemLevel

    if self.db.enable and not self.initialized then
        self:SecureHook("EquipmentFlyout_DisplayButton", "FlyoutButton")
        if not IsAddOnLoaded("Blizzard_ScrappingMachineUI") then
            self:RegisterEvent("ADDON_LOADED")
        else
            self:HookScrappingMachine()
        end
        self.initialized = true
    end
end

IL.Initialize = IL.ProfileUpdate

W:RegisterModule(IL:GetName())
