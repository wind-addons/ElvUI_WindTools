local W, F, E, L = unpack((select(2, ...)))
local M = W.Modules.Misc

local _G = _G
local BNFeaturesEnabledAndConnected = BNFeaturesEnabledAndConnected
local ConsoleExec = ConsoleExec

local C_BattleNet = C_BattleNet
local C_BattleNet_GetFriendGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo
local C_BattleNet_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
local C_CVar_GetCVar = C_CVar.GetCVar
local C_CVar_SetCVar = C_CVar.SetCVar

local function FixLanguageFilterSideEffects()
	function C_BattleNet.GetFriendGameAccountInfo(...)
		local gameAccountInfo = C_BattleNet_GetFriendGameAccountInfo(...)
		if gameAccountInfo then
			gameAccountInfo.isInCurrentRegion = true
		end
		return gameAccountInfo
	end

	function C_BattleNet.GetFriendAccountInfo(...)
		local accountInfo = C_BattleNet_GetFriendAccountInfo(...)
		if accountInfo and accountInfo.gameAccountInfo then
			accountInfo.gameAccountInfo.isInCurrentRegion = true
		end
		return accountInfo
	end
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
		ConsoleExec("portal TW")
		FixLanguageFilterSideEffects()
	end

	C_CVar_SetCVar("profanityFilter", 0)
	C_CVar_SetCVar("overrideArchive", 0)
end

M:AddCallback("AntiOverride")
