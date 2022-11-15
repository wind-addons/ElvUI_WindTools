local W, F, E, L = unpack(select(2, ...))
local ET = E:GetModule("Tooltip")
local UF = E:GetModule("UnitFrames")
local T = W.Modules.Tooltips
local LFGPI = W.Utilities.LFGPlayerInfo

local _G = _G
local format = format
local ipairs = ipairs

local IsAddOnLoaded = IsAddOnLoaded
local LibStub = LibStub

local function GetIconString(role, mode)
    local template
    if mode == "NORMAL" then
        template = "|T%s:14:14:0:0:64:64:8:56:8:56|t"
    elseif mode == "COMPACT" then
        template = "|T%s:16:16:0:0:64:64:8:56:8:56|t"
    end

    return format(template, UF.RoleIconTextures[role])
end

function T:AddGroupInfo(tooltip, resultID, isMeetingStone)
    local config = E.db.WT.tooltips.groupInfo
    if not config or not config.enable then
        return
    end

    LFGPI:SetClassIconStyle(config.classIconStyle)
    LFGPI:Update(resultID)

    -- split line
    if config.title then
        tooltip:AddLine(" ")
        tooltip:AddLine(W.Title .. " " .. L["Party Info"])
    end

    -- compact Mode
    if config.mode == "COMPACT" then
        tooltip:AddLine(" ")
    end

    -- add info
    local data = LFGPI:GetPartyInfo(config.template)

    for order, role in ipairs(LFGPI:GetRoleOrder()) do
        if #data[role] > 0 and config.mode == "NORMAL" then
            tooltip:AddLine(" ")
            tooltip:AddLine(GetIconString(role, "NORMAL") .. " " .. LFGPI.GetColoredRoleName(role))
        end

        for _, line in ipairs(data[role]) do
            local icon = config.mode == "COMPACT" and GetIconString(role, "COMPACT") or ""
            tooltip:AddLine(icon .. " " .. line)
        end
    end

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
