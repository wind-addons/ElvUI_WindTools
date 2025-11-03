local W ---@class WindTools
local F, E ---@type Functions, ElvUI
W, F, E = unpack((select(2, ...)))

local KI = W:NewModule("KeystoneInfo", "AceEvent-3.0") ---@class KeystoneInfo : AceModule, AceEvent-3.0
local OR = E.Libs.OpenRaid
local KS = E.Libs.Keystone

local select = select

local Ambiguate = Ambiguate
local GetInstanceInfo = GetInstanceInfo
local IsInGroup = IsInGroup
local UnitIsPlayer = UnitIsPlayer
local UnitName = UnitName

local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME

---@class KeystoneInfoData
---@field level number
---@field challengeMapID number
---@field rating number

---@type table<string, KeystoneInfoData>
KI.LibKeystoneInfo = {}

function KI.RequestData()
	-- Disable in Delve
	local difficulty = select(3, GetInstanceInfo())
	if difficulty and difficulty == 208 then
		return
	end

	if not OR.RequestKeystoneDataFromRaid() then
		if IsInGroup(LE_PARTY_CATEGORY_HOME) then
			KS.Request("PARTY")
		end
		OR.RequestKeystoneDataFromParty()
	end
end

KS.Register(KI, function(keyLevel, keyChallengeMapID, playerRating, sender)
	KI.LibKeystoneInfo[sender] = {
		level = keyLevel,
		challengeMapID = keyChallengeMapID,
		rating = playerRating,
	}
end)

---@param unit UnitToken
---@return KeystoneInfoData?
function KI:UnitData(unit)
	if not unit or not UnitIsPlayer(unit) then
		return
	end

	local data = OR.GetKeystoneInfo(unit)

	-- If Details! library no returns data, try to get it from Bigwigs library
	if self.LibKeystoneInfo and (not data or not data.level or data.level == 0) then
		local name = UnitName(unit)
		local sender = name and Ambiguate(name, "none")
		data = sender and self.LibKeystoneInfo[sender]
	end

	return data
end

KI:RegisterEvent("GROUP_ROSTER_UPDATE", "RequestData")
KI:RegisterEvent("CHALLENGE_MODE_COMPLETED", "RequestData")
KI:RegisterEvent("CHALLENGE_MODE_START", "RequestData")
KI:RegisterEvent("CHALLENGE_MODE_RESET", "RequestData")
F.TaskManager:AfterLogin(KI.RequestData)
F.TaskManager:AfterLogin(KS.Request, "PARTY") -- For own keystone info
