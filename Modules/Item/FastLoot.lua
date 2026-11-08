local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local FL = W:NewModule("FastLoot", "AceEvent-3.0")

local GetNumLootItems = GetNumLootItems
local GetTime = GetTime
local IsModifiedClick = IsModifiedClick
local IsFishingLoot = IsFishingLoot
local LootSlot = LootSlot

local C_Container_GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots
local C_CVar_GetCVarBool = C_CVar.GetCVarBool

local NUM_BAG_SLOTS = NUM_BAG_SLOTS

function FL:GetFreeSlots()
	local numFreeSlots = 0
	for bag = 0, NUM_BAG_SLOTS do
		numFreeSlots = numFreeSlots + (C_Container_GetContainerNumFreeSlots(bag) or 0)
	end
	return numFreeSlots
end

function FL:LOOT_READY()
	local now = GetTime()
	if now - (self.lastLootTime or 0) >= self.db.limit then
		self.lastLootTime = now
		if C_CVar_GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") and not IsFishingLoot() then
			for i = GetNumLootItems(), 1, -1 do
				if self:GetFreeSlots() > 0 then
					LootSlot(i)
				else
					if not self.bagsFullAnnounced then
						self.bagsFullAnnounced = true
						F.Print(L["Bags are full"])
					end
					break
				end
			end
			self.lastLootTime = GetTime()
		end
	end
end

function FL:LOOT_CLOSED()
	self.bagsFullAnnounced = nil
end

function FL:Initialize()
	if not E.db.WT.item.fastLoot.enable then
		return
	end
	self.db = E.db.WT.item.fastLoot

	self:RegisterEvent("LOOT_READY")
	self:RegisterEvent("LOOT_CLOSED")
end

function FL:ProfileUpdate()
	self.db = E.db.WT.item.fastLoot

	if self.db.enable then
		self:RegisterEvent("LOOT_READY")
		self:RegisterEvent("LOOT_CLOSED")
	else
		self:UnregisterEvent("LOOT_READY")
		self:UnregisterEvent("LOOT_CLOSED")
	end
end

W:RegisterModule(FL:GetName())
