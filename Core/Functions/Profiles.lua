local F ---@class Functions
local W, F, E, L, V, P, G ---@type WindTools, Functions, ElvUI, LocaleTable, PrivateDB, ProfileDB, GlobalDB
W, F, E, L, V, P, G = unpack((select(2, ...)))

local next = next
local type = type

local SerializeCBOR = C_EncodingUtil.SerializeCBOR
local DeserializeCBOR = C_EncodingUtil.DeserializeCBOR
local CompressString = C_EncodingUtil.CompressString
local DecompressString = C_EncodingUtil.DecompressString
local EncodeBase64 = C_EncodingUtil.EncodeBase64
local DecodeBase64 = C_EncodingUtil.DecodeBase64

local compressionMethodDeflate = Enum.CompressionMethod.Deflate or 0
local compressionLevelDefault = Enum.CompressionLevel.Default or 0

---@cast F Functions

F.Profiles = {}

---@type table Generated keys configuration for profile data
local generatedKeys = {
	profile = {},
	private = {},
}

---@class Functions
---Generate compressed and encoded string from data
---@param data table The data to serialize and compress
---@return string? encodedString The compressed and encoded string
function F.Profiles.GenerateString(data)
	local serializedData = SerializeCBOR(data)
	if not serializedData then
		F.Print("Error serializing data.")
		return
	end

	local compressedData = CompressString(serializedData, compressionMethodDeflate, compressionLevelDefault)
	if not compressedData then
		F.Print("Error compressing data.")
		return
	end

	local encodedData = EncodeBase64(compressedData)
	if not encodedData then
		F.Print("Error encoding data.")
		return
	end

	return encodedData
end

---@class Functions
---Extract and deserialize data from encoded string
---@param dataString string The encoded data string
---@return table? data The deserialized data or nil if failed
function F.Profiles.ExactString(dataString)
	local decodedData = DecodeBase64(dataString)
	if not decodedData then
		F.Print("Error decoding data.")
		return
	end

	local decompressed = DecompressString(decodedData, compressionMethodDeflate)
	if not decompressed then
		F.Print("Error decompressing data.")
		return
	end

	local data = DeserializeCBOR(decompressed)
	if type(data) ~= "table" then
		F.Print("Error deserializing data.")
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
		privateData = E:CopyTable(privateData, E.private.WT)
		privateData = E:RemoveTableDuplicates(privateData, V, generatedKeys.private)
	end

	local profileString = F.Profiles.GenerateString(profileData)
	local privateString = F.Profiles.GenerateString(privateData)
	if not profileString or not privateString then
		F.Print("Error exporting profile.")
		return ""
	end

	return profileString .. "{}" .. privateString
end

---@class Functions
---Import profile and private data from string
---@param importString string The import string containing profile and private data
function F.Profiles.ImportByString(importString)
	local profileString, privateString = E:SplitString(importString, "{}")
	if not profileString or not privateString then
		F.Print("Error importing profile. String is invalid or corrupted!")
		return
	end

	local profileData = F.Profiles.ExactString(profileString)
	local privateData = F.Profiles.ExactString(privateString)

	if profileData and type(next(profileData)) ~= "nil" then
		E:CopyTable(E.db.WT, P)
		E:CopyTable(E.db.WT, profileData)
	end

	if privateData and type(next(privateData)) ~= "nil" then
		E:CopyTable(E.private.WT, V)
		E:CopyTable(E.private.WT, privateData)
	end
end
