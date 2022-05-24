local E, _, V, P, G = unpack(ElvUI)
local addonName, addon = ...
local EP = E.Libs.EP
local AceAddon = E.Libs.AceAddon
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)

local _G = _G
local collectgarbage = collectgarbage
local hooksecurefunc = hooksecurefunc
local next = next
local tonumber = tonumber

local GetAddOnMetadata = GetAddOnMetadata

local W = AceAddon:NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")

V.WT = {} -- profile database defaults
P.WT = {} -- private database defaults
G.WT = {} -- global database defaults

addon[1] = W
addon[2] = {} -- Functions
addon[3] = E
addon[4] = L
addon[5] = V.WT
addon[6] = P.WT
addon[7] = G.WT

_G["WindTools"] = addon
W.Version = GetAddOnMetadata(addonName, "Version")

-- Pre-register some WindTools modules
W.Modules = {}
W.Modules.Misc = W:NewModule("Misc", "AceHook-3.0", "AceEvent-3.0")
W.Modules.Skins = W:NewModule("Skins", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
W.Modules.Tooltips = W:NewModule("Tooltips", "AceHook-3.0", "AceEvent-3.0")
W.Modules.MoveFrames = W:NewModule("MoveFrames", "AceEvent-3.0", "AceHook-3.0")

function W:Initialize()
    -- ElvUI -> WindTools -> WindTools Modules
    if not self:CheckElvUIVersion() then
        return
    end

    self.initialized = true

    self:UpdateScripts() -- Database need update first
    self:InitializeModules()

    EP:RegisterPlugin(addonName, W.OptionsCallback)
    self:SecureHook(E, "UpdateAll", "UpdateModules")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

do
    local checked = false
    function W:PLAYER_ENTERING_WORLD(_, isInitialLogin, isReloadingUi)
        if isInitialLogin then
            E:Delay(7, self.CheckInstalledVersion, self)
        end

        if not (checked or _G.ElvUIInstallFrame) then
            self:CheckCompatibility()
            checked = true
        end

        if _G.ElvDB then
            if isInitialLogin or not _G.ElvDB.WT then
                _G.ElvDB.WT = {
                    DisabledAddOns = {}
                }
            end

            if next(_G.ElvDB.WT.DisabledAddOns) then
                E:Delay(4, self.PrintDebugEnviromentTip)
            end
        end

        E:Delay(1, collectgarbage, "collect")
    end
end

EP:HookInitialize(W, W.Initialize)
