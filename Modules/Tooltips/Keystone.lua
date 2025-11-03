local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local T = W.Modules.Tooltips
local KI = W:GetModule("KeystoneInfo") ---@class KeystoneInfo
local C = W.Utilities.Color

local format = format

---@param tt GameTooltip
---@param unit UnitToken
function T:AddKeystone(tt, unit)
	local db = E.db.WT.tooltips.keystone

	if not db or not db.enable then
		return
	end

	local data = KI:UnitData(unit)
	if not data or not data.challengeMapID or not data.level then
		return
	end

	local mythicPlusMapData = W:GetMythicPlusMapData()

	local mapData = data.challengeMapID and mythicPlusMapData[data.challengeMapID]
	if not mapData then
		return
	end

	local right = C.StringWithKeystoneLevel(
		format("%s (%d)", db.useAbbreviation and mapData.abbr or mapData.name, data.level),
		data.level
	)

	if db.icon.enable then
		right = F.GetIconString(mapData.tex, db.icon.height, db.icon.width, true) .. " " .. right
	end

	tt:AddDoubleLine(L["Keystone"], right)
end

T:AddInspectInfoCallback(1, "AddKeystone", false)
