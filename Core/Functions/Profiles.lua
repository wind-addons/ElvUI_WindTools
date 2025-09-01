local F ---@class Functions
local W, E, V, P ---@type WindTools, ElvUI, ProfileDB, PrivateDB
W, F, E, V, P = unpack((select(2, ...)))
local D = E:GetModule("Distributor")
local LibDeflate = E.Libs.Deflate

local format = format
local next = next
local type = type

---@cast F Functions

F.Profiles = {}

---@type table Generated keys configuration for profile data
local generatedKeys = {
	profile = {
		item = {
			extraItemsBar = {
				customList = true,
				blackList = true,
			},
		},
	},
	private = {},
}

---@class Functions
---Generate compressed and encoded string from data
---@param data table The data to serialize and compress
---@return string encodedString The compressed and encoded string
function F.Profiles.GenerateString(data)
	local exportString = D:Serialize(data)
	local compressedData = LibDeflate:CompressDeflate(exportString, LibDeflate.compressLevel)
	local encodedData = LibDeflate:EncodeForPrint(compressedData)
	return encodedData
end

---@class Functions
---Extract and deserialize data from encoded string
---@param dataString string The encoded data string
---@return table? data The deserialized data or nil if failed
function F.Profiles.ExactString(dataString)
	local decodedData = LibDeflate:DecodeForPrint(dataString)
	local decompressed = LibDeflate:DecompressDeflate(decodedData)

	if not decompressed then
		F.Print("Error decompressing data.")
		return
	end

	decompressed = format("%s%s", decompressed, "^^")
	local success, data = D:Deserialize(decompressed)

	if not success then
		F.Print("Error deserializing: " .. data)
		return
	end

	return data
end

---@class Functions
---Get output string for profile and private data export
---@param profile boolean Include profile data in export
---@param private boolean Include private data in export
---@return string outputString The combined export string
function F.Profiles.GetOutputString(profile, private)
	local profileData = {}
	if profile then
		profileData = E:CopyTable(profileData, E.db.WT)
		profileData = E:RemoveTableDuplicates(profileData, P, generatedKeys.profile)
	end

	local privateData = {}
	if private then
		privateData = E:CopyTable(privateData, E.private.WT, generatedKeys.private)
		privateData = E:RemoveTableDuplicates(privateData, V)
	end

	return F.Profiles.GenerateString(profileData) .. "{}" .. F.Profiles.GenerateString(privateData)
end

---@class Functions
---Import profile and private data from string
---@param importString string The import string containing profile and private data
function F.Profiles.ImportByString(importString)
	local profileString, privateString = E:SplitString(importString, "{}")
	if not profileString or not privateString then
		F.Print("Error importing profile. String is invalid or corrupted!")
	end

	local profileData = F.Profiles.ExactString(profileString)
	local privateData = F.Profiles.ExactString(privateString)

	if type(next(profileData)) ~= "nil" then
		E:CopyTable(E.db.WT, P)
		E:CopyTable(E.db.WT, profileData)
	end

	if type(next(privateData)) ~= "nil" then
		E:CopyTable(E.private.WT, V)
		E:CopyTable(E.private.WT, privateData)
	end
end
