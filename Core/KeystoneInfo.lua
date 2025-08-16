local W, F, E, L, V, P, G = unpack((select(2, ...)))
local KI = W:NewModule("KeystoneInfo", "AceEvent-3.0")
local OR = E.Libs.OpenRaid
local KS = E.Libs.Keystone

KI.LibKeystoneInfo = {}
function KI.EventHandler()
	-- Disable in Delve
	local difficulty = select(3, GetInstanceInfo())
	if difficulty and difficulty == 208 then
		return
	end

	if not OR.RequestKeystoneDataFromRaid() then
		KS.Request("PARTY")
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

function KI:UnitData(unit)
	if not unit or not UnitIsPlayer(unit) then
		return
	end

	local data = OR.GetKeystoneInfo(unit)

	-- If Details! library no returns data, try to get it from Bigwigs library
	if not data and self.LibKeystoneInfo then
		local name = UnitName(unit)
		local sender = name and Ambiguate(name, "none")
		data = sender and self.LibKeystoneInfo[sender]
	end

    return data
end

KI:RegisterEvent("GROUP_ROSTER_UPDATE", "EventHandler")
KI:RegisterEvent("CHALLENGE_MODE_COMPLETED", "EventHandler")
KI:RegisterEvent("CHALLENGE_MODE_START", "EventHandler")
KI:RegisterEvent("CHALLENGE_MODE_RESET", "EventHandler")
F.TaskManager:AfterLogin(KI.EventHandler)