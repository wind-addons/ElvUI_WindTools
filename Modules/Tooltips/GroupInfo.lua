local W, F, E, L = unpack(select(2, ...))
local ET = E:GetModule("Tooltip")
local UF = E:GetModule("UnitFrames")
local T = W.Modules.Tooltips

local _G = _G
local format = format
local pairs = pairs
local sort = sort
local type = type
local wipe = wipe

local IsAddOnLoaded = IsAddOnLoaded
local LibStub = LibStub

local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo

local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE

local displayOrder = {
    [1] = "TANK",
    [2] = "HEALER",
    [3] = "DAMAGER"
}

local roleText = {
    TANK = "|cff00a8ff" .. L["Tank"] .. "|r",
    HEALER = "|cff2ecc71" .. L["Healer"] .. "|r",
    DAMAGER = "|cffe74c3c" .. L["DPS"] .. "|r"
}

local function GetIconString(role, mode)
    local template
    if mode == "NORMAL" then
        template = "|T%s:14:14:0:0:64:64:8:56:8:56|t"
    elseif mode == "COMPACT" then
        template = "|T%s:18:18:0:0:64:64:8:56:8:56|t"
    end

    return format(template, UF.RoleIconTextures[role])
end

function T:AddGroupInfo(tooltip, resultID, isMeetingStone)
    local config = E.db.WT.tooltips.groupInfo
    if not config or not config.enable then
        return
    end

    local result = C_LFGList_GetSearchResultInfo(resultID)

    if not result then
        return
    end

    local cache = {
        TANK = {},
        HEALER = {},
        DAMAGER = {}
    }

    local display = {
        TANK = false,
        HEALER = false,
        DAMAGER = false
    }

    -- 缓存成员信息
    for i = 1, result.numMembers do
        local role, class = C_LFGList_GetSearchResultMemberInfo(resultID, i)

        if not display[role] then
            display[role] = true
        end

        if not cache[role][class] then
            cache[role][class] = 0
        end

        cache[role][class] = cache[role][class] + 1
    end

    sort(
        cache,
        function(a, b)
            return displayOrder[a] > displayOrder[b]
        end
    )

    -- 隔断标题
    if config.title then
        tooltip:AddLine(" ")
        tooltip:AddLine(W.Title .. " " .. L["Party Info"])
    end

    -- 紧凑模式
    if config.mode == "COMPACT" then
        tooltip:AddLine(" ")
    end

    -- 分定位显示
    for i = 1, #displayOrder do
        local role = displayOrder[i]
        local members = cache[role]
        if members and display[role] then
            -- 非紧凑模式下添加一个分段标题
            if config.mode == "NORMAL" then
                tooltip:AddLine(" ")
                tooltip:AddLine(GetIconString(role, "NORMAL") .. " " .. roleText[role])
            end

            for class, counter in pairs(members) do
                local numberText = counter ~= 1 and format(" × %d", counter) or ""
                local icon = config.mode == "COMPACT" and GetIconString(role, "COMPACT") or ""
                local className = F.CreateClassColorString(LOCALIZED_CLASS_NAMES_MALE[class], class)
                tooltip:AddLine(icon .. className .. numberText)
            end
        end
    end

    wipe(cache)

    if not isMeetingStone then
        tooltip:ClearAllPoints()
        tooltip:SetPoint("TOPLEFT", _G.LFGListFrame, "TOPRIGHT", 10, 0)
    end
    tooltip:Show()
end

function T:GroupInfo()
    if IsAddOnLoaded("PremadeGroupsFilter") and E.db.WT.tooltips.groupInfo.enable then
        F.Print(
            format(
                L["%s detected, %s will be disabled automatically."],
                "|cffff3860" .. L["Premade Groups Filter"] .. "|r",
                "|cff00a8ff" .. L["Tooltips"] .. " - " .. L["Group Info"] .. "|r"
            )
        )
        E.db.WT.tooltips.groupInfo.enable = false
    end

    T:SecureHook("LFGListUtil_SetSearchEntryTooltip", "AddGroupInfo")

    -- Meeting Stone Hook
    if IsAddOnLoaded("MeetingStone") then
        local meetingStone = LibStub("AceAddon-3.0"):GetAddon("MeetingStone")

        if not meetingStone then
            return
        end

        local profile = meetingStone:GetModule("Profile")

        -- Special check for MeetingStone Happy Version
        local showClassIco = profile:GetSetting("showclassico")
        if profile.Getshowclassico then
            showClassIco = profile:Getshowclassico()
        end

        if showClassIco ~= nil then
            return
        end

        local mainPanel = meetingStone:GetModule("MainPanel")
        if mainPanel and mainPanel.OpenActivityTooltip then
            T:SecureHook(
                mainPanel,
                "OpenActivityTooltip",
                function(panel, activity, tooltip)
                    local id = activity and activity:GetID()
                    tooltip = tooltip or panel.GameTooltip
                    if tooltip and id then
                        T:AddGroupInfo(tooltip, id, true)
                    end
                end
            )
        end
    end
end

T:AddCallback("GroupInfo")
