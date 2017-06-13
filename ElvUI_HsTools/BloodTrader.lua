-- 萨血购买增强
-- 原作者：Improved Blood Trader
-- 修改：无

local BLOODTRADER_NPCID = 115264
local BLOOD_ITEMID = 124124
local BLOODTRADER_CACHE_INDEX = 1
local RESOURCES_CURRENCYID = 1220

-- helper function to check if we are interacting with the blood trader npc
local function IsBloodTrader()
  local guid = UnitGUID("npc")
  if not guid then return end
  local _, _, _, _, _, npcid = strsplit("-", guid)
  if not npcid then return end
  if tonumber(npcid) ~= BLOODTRADER_NPCID then return end
  return true
end



-- === CURRENCY HOOKS

-- handle itemids being shown as currency in merchant windows
-- (copied+modified from MerchantFrame.lua)
--local oldMerchantFrame_UpdateCurrencies = MerchantFrame_UpdateCurrencies
MerchantFrame_UpdateCurrencies = function()
  local currencies = { GetMerchantCurrencies() }
  if IsBloodTrader() then
    currencies = { -BLOOD_ITEMID, RESOURCES_CURRENCYID }
  end
  
  if ( #currencies == 0 ) then  -- common case
    MerchantFrame:UnregisterEvent("CURRENCY_DISPLAY_UPDATE")
    MerchantFrame:UnregisterEvent("BAG_UPDATE")
    MerchantMoneyFrame:SetPoint("BOTTOMRIGHT", -4, 8)
    MerchantMoneyFrame:Show()
    MerchantExtraCurrencyInset:Hide()
    MerchantExtraCurrencyBg:Hide()
  else
    MerchantFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
    MerchantFrame:RegisterEvent("BAG_UPDATE")
    MerchantExtraCurrencyInset:Show()
    MerchantExtraCurrencyBg:Show()
    local numCurrencies = #currencies
    if ( numCurrencies > 3 ) then
      MerchantMoneyFrame:Hide()
    else
      MerchantMoneyFrame:SetPoint("BOTTOMRIGHT", -169, 8)
      MerchantMoneyFrame:Show()
    end
    for index = 1, numCurrencies do
      local tokenButton = _G["MerchantToken"..index]
      -- if this button doesn't exist yet, create it and anchor it
      if ( not tokenButton ) then
        tokenButton = CreateFrame("BUTTON", "MerchantToken"..index, MerchantFrame, "BackpackTokenTemplate")
        -- token display order is: 6 5 4 | 3 2 1
        if ( index == 1 ) then
          tokenButton:SetPoint("BOTTOMRIGHT", -16, 8)
        elseif ( index == 4 ) then
          tokenButton:SetPoint("BOTTOMLEFT", 89, 8)
        else
          tokenButton:SetPoint("RIGHT", _G["MerchantToken"..index - 1], "LEFT", 0, 0)
        end
        tokenButton:SetScript("OnEnter", MerchantFrame_ShowCurrencyTooltip)
      end

      tokenButton.itemID = nil
      tokenButton.currencyID = nil
      
      local name, count, icon
      if currencies[index] < 0 then
        currencies[index] = -currencies[index]
        name = GetItemInfo(currencies[index]) or RETRIEVING_ITEM_INFO
        count = GetItemCount(currencies[index], true)
        icon = GetItemIcon(currencies[index])
        tokenButton.itemID = currencies[index]
      else
        name, count, icon = GetCurrencyInfo(currencies[index])
        tokenButton.currencyID = currencies[index]
      end
      if ( name and name ~= "" ) then
        if ( count <= 99999 ) then
          tokenButton.count:SetText(count)
        else
          tokenButton.count:SetText("*")
        end
        tokenButton.icon:SetTexture(icon)
        tokenButton:Show()
      else
        tokenButton.currencyID = nil
        tokenButton.itemID = nil
        tokenButton:Hide()
      end
    end
  end
  
  for i = #currencies + 1, MAX_MERCHANT_CURRENCIES do
    local tokenButton = _G["MerchantToken"..i]
    if ( tokenButton ) then
      tokenButton.currencyID = nil
      tokenButton.itemID = nil
      tokenButton:Hide()
    else
      break
    end
  end
end

-- handle itemids when updating currency amounts in merchant windows
-- (copied+modified from MerchantFrame.lua)
--local oldMerchantFrame_UpdateCurrencyAmounts = MerchantFrame_UpdateCurrencyAmounts
MerchantFrame_UpdateCurrencyAmounts = function()
  for i = 1, MAX_MERCHANT_CURRENCIES do
    local tokenButton = _G["MerchantToken"..i]
    if not tokenButton then return end
    
    local _, count
    if (tokenButton.itemID) then
      count = GetItemCount(tokenButton.itemID, true)
    elseif (tokenButton.currencyID) then
      _, count = GetCurrencyInfo(tokenButton.currencyID)
    end
    if not count then return end
    
    if ( count <= 99999 ) then
      tokenButton.count:SetText(count)
    else
      tokenButton.count:SetText("*")
    end
  end
end

-- handle itemids for merchant currency tooltips
--local oldMerchantFrame_ShowCurrencyTooltip = MerchantFrame_ShowCurrencyTooltip
MerchantFrame_ShowCurrencyTooltip = function(self)
  GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
  if self.itemID then
    GameTooltip:SetItemByID(self.itemID)
  elseif self.currencyID then
    GameTooltip:SetCurrencyByID(self.currencyID)
  end
end

-- have merchant window listen for BAG_UPDATE and forward it to CURRENCY_DISPLAY_UPDATE
MerchantFrame:HookScript("OnEvent", function(self,event,...)
  if event == "BAG_UPDATE" then
    MerchantFrame_OnEvent(self, "CURRENCY_DISPLAY_UPDATE")
  end
end)



-- === ITEMBUTTON CLICK HOOKS

-- get rid of confirmation when right-clicking or click-dragging to bags
local oldMerchantItemButton_OnClick = MerchantItemButton_OnClick
MerchantItemButton_OnClick = function(self, button, ...)
  -- ignore if not blood trader or on buyback tab
  if not IsBloodTrader() or MerchantFrame.selectedTab ~= 1 then return oldMerchantItemButton_OnClick(self, button, ...) end

  MerchantFrame.extendedCost = nil
  MerchantFrame.highPrice = nil
  
  if ( button == "LeftButton" ) then
    if ( MerchantFrame.refundItem ) then
      if ( ContainerFrame_GetExtendedPriceString(MerchantFrame.refundItem, MerchantFrame.refundItemEquipped)) then
        -- a confirmation dialog has been shown
        return
      end
    end

    PickupMerchantItem(self:GetID())
  else
    BuyMerchantItem(self:GetID())
  end
end

-- allow shift-clicking to buy stacks of items
local oldMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
MerchantItemButton_OnModifiedClick = function(self, button, ...)
  -- ignore if not blood trader or on buyback tab
  if not IsBloodTrader() or MerchantFrame.selectedTab ~= 1 then return oldMerchantItemButton_OnModifiedClick(self, button, ...) end

  if ( HandleModifiedItemClick(GetMerchantItemLink(self:GetID())) ) then
    return
  end
  if ( IsModifiedClick("SPLITSTACK")) then
    local maxStack = GetMerchantItemMaxStack(self:GetID())
    -- if buying resource caches, max out at free bag space
    if self:GetID() == BLOODTRADER_CACHE_INDEX then maxStack = MainMenuBarBackpackButton.freeSlots end
    
    -- hook splitstack callback to round up stacks to next multiple of stacksize
    if not self.oldSplitStack then
      self.oldSplitStack = self.SplitStack
      self.SplitStack = function(button, split, ...)
        if not IsBloodTrader() then return button.oldSplitStack(button, split, ...) end

        local _, _, _, stackCount = GetMerchantItemInfo(button:GetID())
        local maxStack = GetMerchantItemMaxStack(button:GetID())
        if button:GetID() == BLOODTRADER_CACHE_INDEX then maxStack = MainMenuBarBackpackButton.freeSlots end

        -- round up to multiple of stack size
        if split % stackCount ~= 0 then
          split = min(maxStack, split + stackCount) -- stop it from going above maxStack
          local overage = split % stackCount
          split = split - overage
        end

        return button.oldSplitStack(button, split, ...)
      end
    end
    
    OpenStackSplitFrame(maxStack, self, "BOTTOMLEFT", "TOPLEFT")
  end
end

-- allow stacks of caches by buying 1 at a time in a loop
-- this is easier if we hook BuyMerchantItem
local oldBuyMerchantItem = BuyMerchantItem
BuyMerchantItem = function(index, amount, ...)
  if not IsBloodTrader() or index ~= BLOODTRADER_CACHE_INDEX or amount == 1 or not amount then return oldBuyMerchantItem(index, amount, ...) end
  
  amount = min(amount, MainMenuBarBackpackButton.freeSlots)
  while amount > 0 do
    oldBuyMerchantItem(index, 1)
    oldBuyMerchantItem(0, 0) -- slight delay to prevent "item is busy" errors
    oldBuyMerchantItem(0, 0)
    amount = amount - 1
  end
end
