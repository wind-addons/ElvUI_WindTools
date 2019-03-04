-- 原作：Skip Azerite Animations
-- 原作者：Permok(https://wago.io/HkUtqi7QQ)
-- 修改：SomeBlu
-------------------
-- 主要修改条目：
-- 模块化
-- 精简代码，移动设定项绑定 ElvUI 配置

local E, L, V, P, G = unpack(ElvUI)
local WT = E:GetModule("WindTools")
local SAA = E:NewModule('Wind_SkipAzeriteAnimations', 'AceHook-3.0', 'AceEvent-3.0');

function SAA:ADDON_LOADED(event,name)
    if name == "Blizzard_AzeriteUI" then
		self:SecureHook(AzeriteEmpoweredItemUI,"OnItemSet",SAA.OnItemSet)
		self:UnregisterEvent("ADDON_LOADED")
    end
end

function SAA:AZERITE_EMPOWERED_ITEM_LOOTED(event,item)
	local itemId = GetItemInfoFromHyperlink(item)
	local bag
	local slot
	
	C_Timer.After(0.4,function() 
			for i = 0, NUM_BAG_SLOTS do
				for j = 1, GetContainerNumSlots(i) do
					local id = GetContainerItemID(i,j)
					if id and id == itemId then
						slot = j
						bag = i
					end
				end
			end
			
			if slot then
				local location = ItemLocation:CreateFromBagAndSlot(bag,slot)
				
				C_AzeriteEmpoweredItem.SetHasBeenViewed(location)
				C_AzeriteEmpoweredItem.HasBeenViewed(location)
			end
	end)
end

function SAA:AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED(event,itemLocation)
	OpenAzeriteEmpoweredItemUIFromItemLocation(itemLocation)
end

function SAA.OnItemSet(self)
	local itemLocation = self.azeriteItemDataSource:GetItemLocation()
	if self:IsAnyTierRevealing() then
		C_Timer.After(0.7,function() 
				OpenAzeriteEmpoweredItemUIFromItemLocation(itemLocation)
		end)
	end
end

function SAA:Initialize()
	if not E.db.WindTools["Interface"]["Skip Azerite Animations"]["enabled"] then return end

	if not (IsAddOnLoaded("Blizzard_AzeriteUI")) then
		self:RegisterEvent("ADDON_LOADED")
		UIParentLoadAddOn("Blizzard_AzeriteUI")
	else
		self:SecureHook(AzeriteEmpoweredItemUI,"OnItemSet",SAA.OnItemSet)
	end

	self:RegisterEvent("AZERITE_EMPOWERED_ITEM_LOOTED")
	self:RegisterEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")
end

local function InitializeCallback()
	SAA:Initialize()
end
E:RegisterModule(SAA:GetName(), InitializeCallback)