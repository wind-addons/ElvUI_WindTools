local W, F, E, L = unpack((select(2, ...)))
local T = W.Modules.Tooltips
local KI = W:GetModule("KeystoneInfo")
local C = W.Utilities.Color

local format = format

function T:AddKeystone(tt, unit)
	local db = E.db.WT.tooltips.keystone

	if not db or not db.enable then
		return
	end

	local data = KI:UnitData(unit)
	local mapID = data and data.challengeMapID
	if mapID and W.MythicPlusMapData[mapID] then
		local mapData = W.MythicPlusMapData[mapID]
		local right = C.StringWithKeystoneLevel(
			format("%s (%d)", db.useAbbreviation and mapData.abbr or mapData.name, data.level),
			data.level
		)

		if db.icon.enable then
			right = F.GetIconString(mapData.tex, db.icon.height, db.icon.width, true) .. " " .. right
		end

		tt:AddDoubleLine(L["Keystone"], right)
	end
end

T:AddInspectInfoCallback(1, "AddKeystone", false)
