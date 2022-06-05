local W, F, E, L, V, P, G = unpack(select(2, ...))

local format = format
local pairs = pairs
local pcall = pcall
local print = print
local strsub = strsub
local tinsert = tinsert

local GetLocale = GetLocale
local GetMaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion
local InCombatLockdown = InCombatLockdown
local C_LFGList = C_LFGList

local ACCEPT = _G.ACCEPT
local CANCEL = _G.CANCEL

W.Title = L["WindTools"]
W.Locale = GetLocale()
W.ChineseLocale = strsub(W.Locale, 0, 2) == "zh"
W.MaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion()
W.SupportElvUIVersion = 12.80
W.ClassColor = _G.RAID_CLASS_COLORS[E.myclass]

W.RegisteredModules = {}
W.Changelog = {}

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
        E:ToggleOptionsUI("WindTools,information,changelog")
    end,
    hideOnEscape = 1
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
        F.DebugMessage(W, "The name of module is required!")
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
    -- fix ElvUI dropdown lib skin
    do
        local lib = LibStub("LibUIDropDownMenu-4.0", true)
        if lib and not _G.L_UIDropDownMenu_CreateFrames then
            _G.L_UIDropDownMenu_CreateFrames = lib.UIDropDownMenu_CreateFrames
            E.Skins:SkinLibDropDownMenu("L")
        end
    end

    -- fix duplicated party in lfg frame
    -- from: https://wago.io/tWVx_hIx3/4
    do
        if not _G["ShowLFGRemoveDuplicates"] and not IsAddOnLoaded("LFMPlus") then
            hooksecurefunc(
                "LFGListUtil_SortSearchResults",
                function(results, ...)
                    if (not LFGListFrame.SearchPanel:IsShown()) then
                        return
                    end

                    local applications = {}

                    for _, resultId in ipairs(LFGListFrame.SearchPanel.applications) do
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
                        table.wipe(results)

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
    do
        if C_LFGList.IsPlayerAuthenticatedForLFG(703) then
            function C_LFGList.GetPlaystyleString(playstyle, activityInfo)
                if
                    activityInfo and playstyle ~= (0 or nil) and
                        C_LFGList.GetLfgCategoryInfo(activityInfo.categoryID).showPlaystyleDropdown
                 then
                    local typeStr
                    if activityInfo.isMythicPlusActivity then
                        typeStr = "GROUP_FINDER_PVE_PLAYSTYLE"
                    elseif activityInfo.isRatedPvpActivity then
                        typeStr = "GROUP_FINDER_PVP_PLAYSTYLE"
                    elseif activityInfo.isCurrentRaidActivity then
                        typeStr = "GROUP_FINDER_PVE_RAID_PLAYSTYLE"
                    elseif activityInfo.isMythicActivity then
                        typeStr = "GROUP_FINDER_PVE_MYTHICZERO_PLAYSTYLE"
                    end
                    return typeStr and _G[typeStr .. tostring(playstyle)] or nil
                else
                    return nil
                end
            end

            function LFGListEntryCreation_SetTitleFromActivityInfo(_)
            end
        end
    end
end
