local W, F, E, L = unpack(select(2, ...))
local FL = W:NewModule("FastLoot", "AceEvent-3.0")

local _G = _G
local tonumber = tonumber

local GetCVarBool = GetCVarBool
local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local GetNumLootItems = GetNumLootItems
local GetTime = GetTime
local IsModifiedClick = IsModifiedClick
local LootSlot = LootSlot

local NUM_BAG_SLOTS = NUM_BAG_SLOTS

do
	local localizedType
	function FL:IsFishing()
		if not localizedType or strlen(localizedType) < 2 then
			localizedType = select(7, GetItemInfo(6256))
			self:IsFishing()
			return
		end

		local mainHandWeaponID = GetInventoryItemID("player", 16)
		local weaponType = select(7, GetItemInfo(mainHandWeaponID))
		if weaponType and localizedType == weaponType then
			return true
		end
		return false
	end
end

function FL:GetFreeSlots()
	local numFreeSlots = 0
	for bag = 0, NUM_BAG_SLOTS do
		numFreeSlots = numFreeSlots + tonumber((GetContainerNumFreeSlots(bag))) or 0
	end
	return numFreeSlots
end

function FL:LOOT_READY()
	local tDelay = 0
	if GetTime() - tDelay >= self.db.limit then
		tDelay = GetTime()
		if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") and not self:IsFishing() then
			for i = GetNumLootItems(), 1, -1 do
				if self:GetFreeSlots() > 0 then
					LootSlot(i)
				else
					_G.UIErrorsFrame:AddMessage(E.InfoColor .. L["Bags are full"])
				end
			end
			tDelay = GetTime()
		end
	end
end

function FL:Initialize()
	if not E.db.WT.item.fastLoot.enable then
		return
	end
	self.db = E.db.WT.item.fastLoot

	self:RegisterEvent("LOOT_READY")
end

function FL:ProfileUpdate()
	self.db = E.db.WT.item.fastLoot

	if self.db.enable then
		self:RegisterEvent("LOOT_READY")
	else
		self:UnregisterEvent("LOOT_READY")
	end
end

W:RegisterModule(FL:GetName())
