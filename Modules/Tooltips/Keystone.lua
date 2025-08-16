local W, F, E, L = unpack((select(2, ...)))
local T = W.Modules.Tooltips
local KM = W:GetModule("KeystoneInfoManager")
local OR = E.Libs.OpenRaid
local C = W.Utilities.Color

local format = format

local UnitIsPlayer = UnitIsPlayer
local UnitName = UnitName

function T:AddKeystone(tt, unit)
	local db = E.db.WT.tooltips.keystone

	if not db or not db.enable then
		return
	end

	if not unit or not UnitIsPlayer(unit) then
		return
	end

	local data = OR.GetKeystoneInfo(unit)

	-- If Details! library no returns data, try to get it from Bigwigs library
	if not data and KM.LibKeystoneInfo then
		local name = UnitName(unit)
		local sender = name and Ambiguate(name, "none")
		data = sender and KM.LibKeystoneInfo[sender]
	end

	if not data then
		return
	end

	local mapID = data and data.challengeMapID
	if mapID and W.MythicPlusMapData[mapID] then
		local data = W.MythicPlusMapData[mapID]

		local right = C.StringWithKeystoneLevel(
			format("%s (%d)", db.useAbbreviation and data.abbr or data.name, data.level),
			data.level
		)

		if db.icon.enable then
			right = F.GetIconString(data.tex, db.icon.height, db.icon.width, true) .. " " .. right
		end

		tt:AddDoubleLine(L["Keystone"], right)
	end
end

T:AddInspectInfoCallback(1, "AddKeystone", false)
