local W, F, E, L = unpack((select(2, ...)))
local T = W.Modules.Tooltips
local openRaidLib = E.Libs.OpenRaid
local C = W.Utilities.Color

local format = format

local UnitIsPlayer = UnitIsPlayer

function T:AddKeystone(tt, unit)
	local db = E.db.WT.tooltips.keystone

	if not db or not db.enable then
		return
	end

	if not unit or not UnitIsPlayer(unit) then
		return
	end

	local info = openRaidLib.GetKeystoneInfo(unit)
	if info then
		local mapID = info and info.challengeMapID
		if mapID and W.MythicPlusMapData[mapID] then
			local data = W.MythicPlusMapData[mapID]

			local right = C.StringWithKeystoneLevel(
				format("%s (%d)", db.useAbbreviation and data.abbr or data.name, info.level),
				info.level
			)

			if db.icon and db.iconHeight and db.iconWidth then
				right = F.GetIconString(data.tex, db.iconHeight, db.iconWidth, true) .. " " .. right
			end

			tt:AddDoubleLine(L["Keystone"], right)
		end
	end
end

T:AddInspectInfoCallback(1, "AddKeystone", false)
