local W, F, E, L, V, P, G = unpack(select(2, ...))

local _G = _G
local format = format
local gsub = gsub
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local pairs = pairs
local pcall = pcall
local print = print
local strsub = strsub
local tinsert = tinsert
local tostring = tostring
local wipe = wipe

local GetLocale = GetLocale
local GetMaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded

local C_CVar_GetCVarBool = C_CVar.GetCVarBool
local C_LFGList = C_LFGList

local ACCEPT = _G.ACCEPT
local CANCEL = _G.CANCEL

W.Title = L["WindTools"]
W.PlainTitle = gsub(W.Title, "|c........([^|]+)|r", "%1")
W.Locale = GetLocale()
W.ChineseLocale = strsub(W.Locale, 0, 2) == "zh"
W.MaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion()
W.SupportElvUIVersion = 13.06
W.ClassColor = _G.RAID_CLASS_COLORS[E.myclass]

W.RegisteredModules = {}
W.Changelog = {}

W.UseKeyDown = C_CVar_GetCVarBool("ActionButtonUseKeyDown")

-- Alerts
E.PopupDialogs.WINDTOOLS_ELVUI_OUTDATED = {
    text = format(
        "%s\n%s",
        format(L["%s not been loaded since you are using an outdated version of ElvUI."], W.Title),
        format(L["Please upgrade your ElvUI to %2.2f or newer version!"], W.SupportElvUIVersion)
    ),
    button1 = ACCEPT,
    hideOnEscape = 1
}

E.PopupDialogs.WINDTOOLS_OPEN_CHANGELOG = {
    text = format(L["Welcome to %s %s!"], W.Title, W.Version),
    button1 = L["Open Changelog"],
    button2 = CANCEL,
    OnAccept = function(self)
        E:ToggleOptions("WindTools,information,changelog")
    end,
    hideOnEscape = 1
}

E.PopupDialogs.WINDTOOLS_BUTTON_FIX_RELOAD = {
    text = format(
        "%s\n%s\n\n|cffaaaaaa%s|r",
        format(L["%s detects CVar %s has been changed."], W.Title, "|cff209ceeActionButtonUseKeyDown|r"),
        L["It will cause some buttons not work properly before UI reloading."],
        format(L["You can disable this alert in [%s]-[%s]-[%s]"], W.Title, L["Advanced"], L["Game Fix"])
    ),
    button1 = L["Reload UI"],
    button2 = CANCEL,
    OnAccept = _G.ReloadUI
}

-- Keybinds
_G.BINDING_CATEGORY_ELVUI_WINDTOOLS = W.Title
for i = 1, 5 do
    _G["BINDING_HEADER_WTEXTRAITEMSBAR" .. i] =
        F.CreateColorString(L["Extra Items Bar"] .. " " .. i, E.db.general.valuecolor)
    for j = 1, 12 do
        _G[format("BINDING_NAME_CLICK WTExtraItemsBar%dButton%d:LeftButton", i, j)] = L["Button"] .. " " .. j
    end
end

_G.BINDING_CATEGORY_ELVUI_WINDTOOLS_EXTRA = W.Title .. " - " .. L["Extra"]
_G.BINDING_HEADER_WTEXTRABUTTONS = L["Extra Buttons"]
_G["BINDING_NAME_CLICK WTExtraBindingButtonLogout:LeftButton"] = L["Logout"]
_G["BINDING_NAME_CLICK WTExtraBindingButtonLeaveGroup:LeftButton"] = L["Leave Party"]
_G["BINDING_NAME_CLICK WTExtraBindingButtonLeavePartyIfSoloing:LeftButton"] = L["Leave Party if soloing"]

--[[
    WindTools module registration
    @param {string} name The name of module
]]
function W:RegisterModule(name)
    if not name then
        F.Developer.ThrowError("The name of module is required!")
        return
    end
    if self.initialized then
        self:GetModule(name):Initialize()
    else
        tinsert(self.RegisteredModules, name)
    end
end

-- WindTools module initialization
function W:InitializeModules()
    for _, moduleName in pairs(W.RegisteredModules) do
        local module = self:GetModule(moduleName)
        if module.Initialize then
            pcall(module.Initialize, module)
        end
    end
end

-- WindTools module update after profile switch
function W:UpdateModules()
    self:UpdateScripts()
    for _, moduleName in pairs(self.RegisteredModules) do
        local module = W:GetModule(moduleName)
        if module.ProfileUpdate then
            pcall(module.ProfileUpdate, module)
        end
    end
end

-- Check ElvUI version, if not matched, show a popup to user
function W:CheckElvUIVersion()
    if W.SupportElvUIVersion > E.version then
        E:StaticPopup_Show("WINDTOOLS_ELVUI_OUTDATED")
        return false
    end
    return true
end

-- Check install version, show changelog and run update scripts
function W:CheckInstalledVersion()
    if InCombatLockdown() then
        return
    end

    if self.showChangeLog then
        E:StaticPopup_Show("WINDTOOLS_OPEN_CHANGELOG")
        self.showChangeLog = false
    end
end

function W:GameFixing()
    -- -- fix duplicated party in lfg frame
    -- -- from: https://wago.io/tWVx_hIx3/4
    if E.global.WT.core.noDuplicatedParty then
        if not _G["ShowLFGRemoveDuplicates"] and not IsAddOnLoaded("LFMPlus") then
            hooksecurefunc(
                "LFGListUtil_SortSearchResults",
                function(results, ...)
                    if (not _G.LFGListFrame.SearchPanel:IsShown()) then
                        return
                    end

                    local applications = {}

                    for _, resultId in ipairs(_G.LFGListFrame.SearchPanel.applications) do
                        applications[resultId] = true
                    end

                    local resultCount = #results
                    local filteredCount = 0
                    local filtered = {}

                    for _, resultId in ipairs(results) do
                        if not applications[resultId] then
                            filteredCount = filteredCount + 1
                            filtered[filteredCount] = resultId
                        end
                    end
                    if filteredCount < resultCount then
                        wipe(results)

                        for i = 1, filteredCount do
                            results[i] = filtered[i]
                        end
                    end
                end
            )

            _G["ShowLFGRemoveDuplicates"] = true
        end
    end

    -- fix playstyle string
    -- from Premade Groups Filter & LFMPlus

    if E.global.WT.core.fixPlaystyle then
        if C_LFGList.IsPlayerAuthenticatedForLFG(703) then
            function C_LFGList.GetPlaystyleString(playstyle, activityInfo)
                if
                    not (activityInfo and playstyle and playstyle ~= 0 and
                        C_LFGList.GetLfgCategoryInfo(activityInfo.categoryID).showPlaystyleDropdown)
                 then
                    return nil
                end
                local globalStringPrefix
                if activityInfo.isMythicPlusActivity then
                    globalStringPrefix = "GROUP_FINDER_PVE_PLAYSTYLE"
                elseif activityInfo.isRatedPvpActivity then
                    globalStringPrefix = "GROUP_FINDER_PVP_PLAYSTYLE"
                elseif activityInfo.isCurrentRaidActivity then
                    globalStringPrefix = "GROUP_FINDER_PVE_RAID_PLAYSTYLE"
                elseif activityInfo.isMythicActivity then
                    globalStringPrefix = "GROUP_FINDER_PVE_MYTHICZERO_PLAYSTYLE"
                end
                return globalStringPrefix and _G[globalStringPrefix .. tostring(playstyle)] or nil
            end

            _G.LFGListEntryCreation_SetTitleFromActivityInfo = function(_)
            end
        end
    end

    if E.global.WT.core.cvarAlert then
        self:RegisterEvent(
            "CVAR_UPDATE",
            function(_, cvar, value)
                if cvar == "ActionButtonUseKeyDown" and W.UseKeyDown ~= (value == "1") then
                    E:StaticPopup_Show("WINDTOOLS_BUTTON_FIX_RELOAD")
                end
            end
        )
    end
end
