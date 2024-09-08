local W, F, E, L = unpack((select(2, ...)))
local M = W.Modules.Misc

local BNFeaturesEnabledAndConnected = BNFeaturesEnabledAndConnected
local ConsoleExec = ConsoleExec

local C_BattleNet = C_BattleNet
local C_BattleNet_GetFriendGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo
local C_BattleNet_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
local C_CVar_GetCVar = C_CVar.GetCVar
local C_CVar_SetCVar = C_CVar.SetCVar

local function wrapBattleNetFunction(originalFunc)
	return function(...)
		local info = originalFunc(...)
		if info then
			if info.gameAccountInfo then
				info.gameAccountInfo.isInCurrentRegion = true
			else
				info.isInCurrentRegion = true
			end
		end
		return info
	end
end

local function FixLanguageFilterSideEffects()
	C_BattleNet.GetFriendGameAccountInfo = wrapBattleNetFunction(C_BattleNet_GetFriendGameAccountInfo)
	C_BattleNet.GetFriendAccountInfo = wrapBattleNetFunction(C_BattleNet_GetFriendAccountInfo)
end

-- from https://www.curseforge.com/wow/addons/fckyou
function M:AntiOverride()
	if not E.private.WT.misc.antiOverride then
		return
	end

	if not BNFeaturesEnabledAndConnected() then
		return
	end

	if C_CVar_GetCVar("portal") == "CN" then
		W.RealRegion = "CN"
		ConsoleExec("portal TW")
		FixLanguageFilterSideEffects()
	end

	C_CVar_SetCVar("profanityFilter", 0)
	C_CVar_SetCVar("overrideArchive", 0)
end

M:AddCallback("AntiOverride")
