local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local A = W:GetModule("Announcement")

local gsub = gsub
local strlower = strlower

local C_Container_GetContainerItemID = C_Container.GetContainerItemID
local C_Container_GetContainerItemLink = C_Container.GetContainerItemLink
local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots

local C_Item_IsItemKeystoneByID = C_Item.IsItemKeystoneByID
local C_MythicPlus_GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local C_MythicPlus_GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel

local NUM_BAG_SLOTS = NUM_BAG_SLOTS

local cache = {}

local function getKeystoneLink()
	for bagIndex = 0, NUM_BAG_SLOTS do
		for slotIndex = 1, C_Container_GetContainerNumSlots(bagIndex) do
			local itemID = C_Container_GetContainerItemID(bagIndex, slotIndex)
			if itemID and C_Item_IsItemKeystoneByID(itemID) then
				return C_Container_GetContainerItemLink(bagIndex, slotIndex)
			end
		end
	end
end

function A:Keystone(event)
	local config = self.db.keystone

	if not config or not config.enable then
		return
	end

	local mapID = C_MythicPlus_GetOwnedKeystoneChallengeMapID()
	local keystoneLevel = C_MythicPlus_GetOwnedKeystoneLevel()

	if event == "PLAYER_ENTERING_WORLD" then
		cache.mapID = mapID
		cache.keystoneLevel = keystoneLevel
	elseif event == "CHALLENGE_MODE_COMPLETED" or event == "ITEM_CHANGED" then
		if cache.mapID ~= mapID or cache.keystoneLevel ~= keystoneLevel then
			cache.mapID = mapID
			cache.keystoneLevel = keystoneLevel

			local link = getKeystoneLink()
			if link then
				local message = gsub(config.text, "%%keystone%%", link)
				self:SendMessage(message, self:GetChannel(config.channel))
			end
		end
	end
end

function A:KeystoneLink(event, text)
	local config = self.db.keystone

	if not config or not config.enable or not config.command then
		return
	end

	if strlower(text) ~= "!keys" then
		return
	end

	local channel
	if event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" then
		channel = "PARTY"
	elseif event == "CHAT_MSG_GUILD" then
		channel = "GUILD"
	end

	if channel then
		local link = getKeystoneLink()
		if link then
			self:SendMessage(link, channel)
		end
	end
end
