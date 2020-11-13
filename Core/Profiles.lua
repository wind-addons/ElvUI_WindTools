local W, F, E, L, V, P, G = unpack(select(2, ...))
local D = E:GetModule("Distributor")
local LibCompress = E.Libs.Compress
local LibBase64 = E.Libs.Base64

F.Profiles = {}

function F.Profiles.GenerateString(data)
    local exportString = D:Serialize(data)
    local compressedData = LibCompress:Compress(exportString)
    local encodedData = LibBase64:Encode(compressedData)
    return encodedData
end

function F.Profiles.ExactString(dataString)
    local decodedData = LibBase64:Decode(dataString)
    local decompressedData, decompressedMessage = LibCompress:Decompress(decodedData)

    if not decompressedData then
        F.Print("Error decompressing data:", decompressedMessage)
        return
    end

    decompressedData = format("%s%s", decompressedData, "^^")
    local success, data = D:Deserialize(decompressedData)

    if not success then
        F.Print("Error deserializing:", profileData)
        return
    end

    return data
end

function F.Profiles.GetOutputString()
    local profileData = E:CopyTable(profileData, E.db.WT)
    local privateData = E:CopyTable(privateData, E.private.WT)
    profileData = E:RemoveTableDuplicates(profileData, P)
    privateData = E:RemoveTableDuplicates(privateData, V)
    outputString = F.Profiles.GenerateString(profileData) .. "{}" .. F.Profiles.GenerateString(privateData)
    return outputString
end

function F.Profiles.ImportByString(importString)
    local profileString, privateString = E:SplitString(importString, "{}")
    if not profileString or not privateString then
        F.Print("Error importing profile. String is invalid or corrupted!")
    end

    local profileData = ExactString(profileString)
    local priavteData = ExactString(privateString)

    E:CopyTable(E.db.WT, P)
    E:CopyTable(E.db.WT, profileData)

    E:CopyTable(E.private.WT, V)
    E:CopyTable(E.private.WT, priavteData)
end
