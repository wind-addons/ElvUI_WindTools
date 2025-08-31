local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local M = W.Modules.Misc ---@class Misc

local _G = _G

function M:LootPanel()
	if E.db.WT.misc.noLootPanel then
		_G.BossBanner:UnregisterEvent("ENCOUNTER_LOOT_RECEIVED")
	else
		_G.BossBanner:RegisterEvent("ENCOUNTER_LOOT_RECEIVED")
	end
end

M:AddCallback("LootPanel")
M:AddCallbackForUpdate("LootPanel")
