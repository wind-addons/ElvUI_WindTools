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

local ACCEPT = _G.ACCEPT
local CANCEL = _G.CANCEL

W.Title = L["WindTools"]
W.Locale = GetLocale()
W.ChineseLocale = strsub(W.Locale, 0, 2) == "zh"
W.MaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion()
W.SupportElvUIVersion = 12.75
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
    end

    if E.private.WT.core.loginMessage then
        local icon = F.GetIconString(W.Media.Textures.smallLogo, 14)
        print(
            format(
                icon ..
                    " " ..
                        L["%s %s Loaded."] ..
                            " " .. L["You can send your suggestions or bugs via %s, %s, %s, and the thread in %s."],
                W.Title,
                W.Version,
                L["QQ Group"],
                L["Discord"],
                L["Github"],
                L["NGA.cn"]
            )
        )
        self.showChangeLog = false
    end
end
