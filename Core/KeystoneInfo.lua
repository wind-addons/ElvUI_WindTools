local W ---@class WindTools
local F, E ---@type Functions, ElvUI
W, F, E = unpack((select(2, ...)))

local KI = W:NewModule("KeystoneInfo", "AceEvent-3.0") ---@class KeystoneInfo : AceModule, AceEvent-3.0
local OR = E.Libs.OpenRaid
local KS = E.Libs.Keystone

local select = select
local strsplit = strsplit
local tonumber = tonumber

local Ambiguate = Ambiguate
local GetInstanceInfo = GetInstanceInfo
local GetUnitName = GetUnitName
local IsInGroup = IsInGroup
local UnitIsPlayer = UnitIsPlayer
local PlayerIsTimerunning = PlayerIsTimerunning

local C_Container_GetContainerItemID = C_Container.GetContainerItemID
local C_Container_GetContainerItemLink = C_Container.GetContainerItemLink
local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_Item_IsItemKeystoneByID = C_Item.IsItemKeystoneByID
local C_MythicPlus_GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local C_MythicPlus_GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel

local LE_PARTY_CATEGORY_HOME = LE_PARTY_CATEGORY_HOME
local NUM_BAG_SLOTS = NUM_BAG_SLOTS

---@class KeystoneInfoData
---@field level number
---@field challengeMapID number
---@field rating number

---@type table<string, KeystoneInfoData>
KI.LibKeystoneInfo = {}

---@class KeystoneInfo.PlayerKeystone
---@field level number?
---@field mapID number?
KI.PlayerKeystone = {}

function KI:GetPlayerKeystoneLink()
	for bagIndex = 0, NUM_BAG_SLOTS do
		for slotIndex = 1, C_Container_GetContainerNumSlots(bagIndex) do
			local itemID = C_Container_GetContainerItemID(bagIndex, slotIndex)
			if itemID and C_Item_IsItemKeystoneByID(itemID) then
				return C_Container_GetContainerItemLink(bagIndex, slotIndex)
			end
		end
	end
end

---@return number? mapID
---@return number? level
---@return string? link
function KI:GetPlayerKeystone()
	local link = self:GetPlayerKeystoneLink()
	if not link then
		return nil, nil, nil
	end

	if not PlayerIsTimerunning() then
		return C_MythicPlus_GetOwnedKeystoneChallengeMapID(), C_MythicPlus_GetOwnedKeystoneLevel(), link
	end

	local challengeMapID, level = select(3, strsplit(":", link))
	if not challengeMapID or not level then
		return nil, nil, link
	end

	local mapID = tonumber(challengeMapID)
	local keystoneLevel = tonumber(level)

	if not mapID or not keystoneLevel then
		return nil, nil, link
	end

	return mapID, keystoneLevel, link
end

---@param skipEmit boolean? the flag to skip sending custom message to other modules
function KI:RequestAndCheckPlayerKeystone(skipEmit)
	self.RequestData()
	self:CheckPlayerKeystone(skipEmit)
end

---@param skipEmit boolean? the flag to skip sending custom message to other modules
function KI:CheckPlayerKeystone(skipEmit)
	local mapID, level, link = self:GetPlayerKeystone()

	if self.PlayerKeystone.mapID ~= mapID or self.PlayerKeystone.level ~= level then
		if not skipEmit then
			self:SendMessage("WINDTOOLS_PLAYER_KEYSTONE_CHANGED", mapID, level, link)
		end

		KS.Request("GUILD")
	end

	self.PlayerKeystone.mapID, self.PlayerKeystone.level = mapID, level
end

function KI:DelayedCheckPlayerKeystone()
	return E:Delay(0.5, KI.CheckPlayerKeystone, KI)
end

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
		local name = GetUnitName(unit, true)
		local sender = name and Ambiguate(name, "none")
		data = sender and self.LibKeystoneInfo[sender]
	end

	return data
end

KI:RegisterEvent("GROUP_ROSTER_UPDATE", "RequestData")
KI:RegisterEvent("CHALLENGE_MODE_START", "RequestData")
KI:RegisterEvent("CHALLENGE_MODE_RESET", "RequestData")
KI:RegisterEvent("CHALLENGE_MODE_COMPLETED", "RequestAndCheckPlayerKeystone")
KI:RegisterEvent("ITEM_CHANGED", "DelayedCheckPlayerKeystone")
KI:RegisterEvent("ITEM_PUSH", "DelayedCheckPlayerKeystone")

F.TaskManager:AfterLogin(KI.RequestAndCheckPlayerKeystone, KI, true)
