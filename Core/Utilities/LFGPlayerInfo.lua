local W, F, E, L, V, P, G = unpack(select(2, ...))

local gsub = gsub
local format = format

local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo

-- Initialize
W.Utilities.LFGPlayerInfo = {}
local U = W.Utilities.LFGPlayerInfo

-- Inject WindTools logger
function U:GetName()
    return "Utilities:LFGPlayerInfo"
end

F.Developer.InjectLogger(U)

-- Variables
local roleOrder = {
    [1] = "TANK",
    [2] = "HEALER",
    [3] = "DAMAGER"
}

function U.GetRoleOrder()
    return roleOrder
end

local coloredRoleName = {
    TANK = "|cff00a8ff" .. L["Tank"] .. "|r",
    HEALER = "|cff2ecc71" .. L["Healer"] .. "|r",
    DAMAGER = "|cffe74c3c" .. L["DPS"] .. "|r"
}

function U.GetColoredRoleName(role)
    return coloredRoleName[role]
end

local classFileToID = {} -- { ["WARRIOR"] = 1 }
local localizedSpecNameToID = {} -- { ["Protection"] = 73 }
local localizedSpecNameToIcon = {} -- { ["Protection"] = "Interface\\Icons\\ability_warrior_defensivestance" }

for classID = 1, 13 do
    -- Scan all specs and specilizations, 13 is Evoker
    local classFile = select(2, GetClassInfo(classID)) -- "WARRIOR"

    if classFile then
        classFileToID[classFile] = classID

        for specIndex = 1, 4 do
            -- Druid has the max amount of specs, which is 4
            local specId, localizedSpecName, _, icon = GetSpecializationInfoForClassID(classID, specIndex)
            if specId and localizedSpecName and icon then
                localizedSpecNameToID[localizedSpecName] = specId
                localizedSpecNameToIcon[localizedSpecName] = icon
            end
        end
    end
end

-- Cache
U.cache = {}

function U.cache:Clear()
    for _, role in pairs(roleOrder) do
        self[role] = {
            totalAmount = 0,
            playerList = {}
        }
    end
end

function U.cache:AddPlayer(role, class, spec)
    if not self[role] then
        U:Log("warning", format("cache not been initialized correctly, the role:%s is nil.", role))
    end

    if not self[role].playerList[class] then
        self[role].playerList[class] = {}
    end

    if not self[role].playerList[class][spec] then
        self[role].playerList[class][spec] = 0
    end

    self[role].playerList[class][spec] = self[role].playerList[class][spec] + 1
    self[role].totalAmount = self[role].totalAmount + 1
end

-- Main logic
function U:Update(resultID)
    local result = C_LFGList_GetSearchResultInfo(resultID)

    if not result then
        self:Log("debug", "cache not updated correctly, the number of results is nil.")
    end

    if not result.numMembers or result.numMembers == 0 then
        self:Log("debug", "cache not updated correctly, the number of result.numMembers is nil or 0.")
    end

    self.cache:Clear()

    for i = 1, result.numMembers do
        local role, class, _, spec = C_LFGList_GetSearchResultMemberInfo(resultID, i)

        if not role then
            self:Log("debug", "cache not updated correctly, the role is nil.")
            return
        end

        if not class then
            self:Log("debug", "cache not updated correctly, the class is nil.")
            return
        end

        if not spec then
            self:Log("debug", "cache not updated correctly, the spec is nil.")
            return
        end

        self.cache:AddPlayer(role, class, spec)
    end
end

function U:Conduct(template, role, class, spec, amount)
    -- This function allow you do a very simple template rendering.
    -- The syntax like a mix of React and Vue.
    -- The field between `{{` and `}}` should NOT have any space.
    -- The {{tagStart}} and {{tagEnd}} is a tag pair like HTML tag, but it has been designed for matching latest close tag.
    -- [Sample]
    -- {{classIcon}}{{specIcon}} {{classColorStart}}{{className}}{{classColorEnd}}{{amountStart}} x {{amount}}{{amountEnd}}

    local result = template

    -- {{classIcon}}
    result =
        gsub(
        result,
        "{{classIcon:([0-9,]-)}}",
        function(sub)
            if not class then
                self:Log("warning", "className not found, class is not given.")
                return ""
            end

            local size = {strsplit(",", sub)}
            local height = size[1] and size[1] ~= "" and tonumber(size[1]) or 14
            local width = size[2] and size[2] ~= "" and tonumber(size[2]) or height

            return F.GetTextureStringFromTexCoord(
                W.Media.Textures.CLASSES,
                width,
                {x = 256, y = 256},
                {F.GetClassTexCoord(class)}
            )
        end
    )

    -- {{className}}
    result =
        gsub(
        result,
        "{{className}}",
        function(sub)
            if not class then
                self:Log("warning", "className not found, class is not given.")
                return ""
            end
            return LOCALIZED_CLASS_NAMES_MALE[class]
        end
    )

    -- {{classId}}
    result =
        gsub(
        result,
        "{{classId}}",
        function(sub)
            if not class then
                self:Log("warning", "classId not found, class is not given.")
                return ""
            end

            local classID = classFileToID[class]

            if not classID then
                self:Log("warning", format("class:%s not found in classFileToID.", class))
                return ""
            end

            return classID
        end
    )

    -- {{specIcon}}
    result =
        gsub(
        result,
        "{{specIcon:([0-9,]-)}}",
        function(sub)
            if not spec then
                self:Log("warning", "specIcon not found, spec is not given.")
                return ""
            end

            local icon = localizedSpecNameToIcon[spec]

            if not icon then
                self:Log("warning", format("spec:%s not found in localizedSpecNameToIcon.", spec))
                return ""
            end

            local size = {strsplit(",", sub)}
            local height = size[1] and size[1] ~= "" and tonumber(size[1]) or 14
            local width = size[2] and size[2] ~= "" and tonumber(size[2]) or height

            return F.GetIconString(icon, height, width, true)
        end
    )

    -- {{specName}}
    result =
        gsub(
        result,
        "{{specName}}",
        function(sub)
            if not spec then
                self:Log("warning", "specName not found, spec is not given.")
                return ""
            end
            return spec
        end
    )

    -- {{specId}}
    result =
        gsub(
        result,
        "{{specId}}",
        function(sub)
            if not class then
                self:Log("warning", "specId not found, spec is not given.")
                return ""
            end

            local specID = localizedSpecNameToID[spec]

            if not specID then
                self:Log("warning", format("spec:%s not found in classFileToID.", spec))
                return ""
            end

            return specID
        end
    )

    -- {{classColorStart}} ... {{classColorEnd}}
    result =
        gsub(
        result,
        "{{classColorStart}}(.-){{classColorEnd}}",
        function(sub)
            if not class then
                self:Log("warning", "className not found, class is not given.")
                return ""
            end
            return F.CreateClassColorString(sub, class)
        end
    )

    -- {{amountStart}} ... {{amountEnd}}
    result =
        gsub(
        result,
        "{{amountStart}}(.-){{amountEnd}}",
        function(sub)
            if amount <= 1 then -- should not show amount if the amount is only one
                return ""
            else
                -- {{amount}}
                if not amount then
                    self:Log("warning", "amount not found, amount is not given.")
                    return ""
                end
                return gsub(sub, "{{amount}}", amount)
            end
        end
    )

    -- {{classColorStart}} ... {{classColorEnd}}
    result =
        gsub(
        result,
        "{{classColorStart}}(.-){{classColorEnd}}",
        function(sub)
            if not class then
                self:Log("warning", "className not found, class is not given.")
                return ""
            end
            return F.CreateClassColorString(sub, class)
        end
    )

    return result
end

function U:ConductPreview(template)
    return self:Conduct(template, "TANK", E.myclass, E.myspec, 2)
end

function U:GetPartyInfo(template)
    if not template then
        self:Log("warning", "template is nil.")
        return
    end

    local dataTable = {}

    for order, role in ipairs(roleOrder) do
        dataTable[role] = {}

        local members = self.cache[role]

        for class, numberOfPlayersSortBySpec in pairs(members.playerList) do
            for spec, numberOfPlayers in pairs(numberOfPlayersSortBySpec) do
                local result = self:Conduct(template, role, class, spec, numberOfPlayers)
                tinsert(dataTable[role], result)
            end
        end
    end

    return dataTable
end
