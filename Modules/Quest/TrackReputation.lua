-- 原作：ElvUI_Enhanced, Marcel Menzel
-- 修改：houshuu
-------------------
-- 主要修改条目：
-- 模块化
local E, L, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local TrackRep = E:NewModule('Wind_TrackRep', 'AceHook-3.0', 'AceEvent-3.0');

local find, gsub, format = string.find, string.gsub, string.format

local incpat = gsub(gsub(FACTION_STANDING_INCREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
local changedpat = gsub(gsub(FACTION_STANDING_CHANGED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
local decpat = gsub(gsub(FACTION_STANDING_DECREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)")
local standing = ('%s:'):format(STANDING)
local reputation = ('%s:'):format(REPUTATION)

function TrackRep:SetWatchedFactionOnReputationBar(event, msg)
	local _, _, faction, amount = find(msg, incpat)
	if not faction then _, _, faction, amount = find(msg, changedpat) or find(msg, decpat) end
	if faction then
		if faction == GUILD then
			faction = GetGuildInfo("player")
		end

		local active = GetWatchedFactionInfo()
		for factionIndex = 1, GetNumFactions() do
			local name = GetFactionInfo(factionIndex)
			if name == faction and name ~= active then
				-- check if watch has been disabled by user
				local inactive = IsFactionInactive(factionIndex) or SetWatchedFactionIndex(factionIndex)
				break
			end
		end
	end
end

-- Set our hook function
function TrackRep:Initialize()
    if not E.db.WindTools["Quest"]["Track Reputation"]["enabled"] then return end
    self:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE", 'SetWatchedFactionOnReputationBar')
end

local function InitializeCallback()
	TrackRep:Initialize()
end

E:RegisterModule(TrackRep:GetName(), InitializeCallback)