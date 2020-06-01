-- 原作者：Leatrix (https://wow.curseforge.com/projects/leatrix-plus)
local W, F, E, L = unpack(select(2, ...))
local FL = W:NewModule("FastLoot", "AceEvent-3.0")

local GetTime = GetTime
local LootSlot = LootSlot
local GetCVarBool = GetCVarBool
local GetNumLootItems = GetNumLootItems
local IsModifiedClick = IsModifiedClick

function FL:LOOT_READY()
	local tDelay = 0
	if GetTime() - tDelay >= self.db.limit then
		tDelay = GetTime()
		if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
			for i = GetNumLootItems(), 1, -1 do
				LootSlot(i)
			end
			tDelay = GetTime()
		end
	end
end

function FL:Initialize()
	if not E.db.WT.item.fastLoot.enable then return end
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