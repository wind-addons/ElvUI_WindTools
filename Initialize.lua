local E, _, V, P, G = unpack(ElvUI)
local addonName, addon = ...
local EP = E.Libs.EP
local AceAddon = E.Libs.AceAddon
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)

local _G = _G
local collectgarbage = collectgarbage
local format = format
local hooksecurefunc = hooksecurefunc
local next = next
local print = print
local strfind = strfind
local strmatch = strmatch

local C_AddOns_GetAddOnMetadata = C_AddOns.GetAddOnMetadata

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

local versionString = C_AddOns_GetAddOnMetadata(addonName, "Version")
local xVersionString = C_AddOns_GetAddOnMetadata(addonName, "X-Version")

local function getVersion()
	local version, variant, subversion

	-- Git
	if strfind(versionString, "project%-version") then
		return xVersionString, "git", nil
	end

	version, variant = strmatch(versionString, "^(%d+%.%d+)(.*)$")

	if not version then
		return xVersionString, nil, nil
	end

	if not variant or variant == "" then
		return version, nil, nil
	end

	local variantName, subversionNum = strmatch(variant, "^%-([%w]+)%-?(%d*)$")
	if variantName and subversionNum then
		variant = variantName
		subversion = subversionNum ~= "" and subversionNum or nil
	end

	return version, variant, subversion
end

W.Version, W.Variant, W.SubVersion = getVersion()

W.DisplayVersion = W.Version
if W.Variant then
	W.DisplayVersion = format("%s-%s", W.DisplayVersion, W.Variant)
	if W.SubVersion then
		W.DisplayVersion = format("%s-%s", W.DisplayVersion, W.SubVersion)
	end
end

-- Pre-register some WindTools modules
W.Modules = {}
W.Modules.Misc = W:NewModule("Misc", "AceHook-3.0", "AceEvent-3.0")
W.Modules.Skins = W:NewModule("Skins", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
W.Modules.Tooltips = W:NewModule("Tooltips", "AceHook-3.0", "AceEvent-3.0")
W.Modules.MoveFrames = W:NewModule("MoveFrames", "AceEvent-3.0", "AceHook-3.0")

-- Utilities namespace
W.Utilities = {}

-- Pre-register libs into ElvUI
E:AddLib("OpenRaid", "LibOpenRaid-1.0")
E:AddLib("ObjectiveProgress", "LibObjectiveProgress-1.0")
E:AddLib("RangeCheck", "LibRangeCheck-3.0")
E:AddLib("Keystone", "LibKeystone")

_G.WindTools_OnAddonCompartmentClick = function()
	E:ToggleOptions("WindTools")
end

function W:Initialize()
	-- ElvUI -> WindTools -> WindTools Modules
	if not self:CheckElvUIVersion() then
		return
	end

	for _, module in self:IterateModules() do
		addon[2].Developer.InjectLogger(module)
	end

	hooksecurefunc(W, "NewModule", function(_, name)
		addon[2].Developer.InjectLogger(name)
	end)

	self.initialized = true

	self:AddCustomLinkSupport()
	self:UpdateScripts()
	self:InitializeModules()

	-- To avoid the update tips from ElvUI when alpha/beta version is used
	EP:RegisterPlugin(addonName, W.OptionsCallback, false, xVersionString)
	self:SecureHook(E, "UpdateAll", "UpdateModules")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

do
	local checked = false
	function W:PLAYER_ENTERING_WORLD(_, isInitialLogin, isReloadingUi)
		if isInitialLogin then
			E:Delay(6, self.ChangelogReadAlert, self)
			if E.global.WT.core.loginMessage then
				local icon = addon[2].GetIconString(self.Media.Textures.smallLogo, 14)
				print(
					format(
						icon
							.. " "
							.. L["%s %s Loaded."]
							.. " "
							.. L["You can send your suggestions or bugs via %s, %s, %s and the thread in %s."],
						self.Title,
						self.Version,
						L["QQ Group"],
						L["Discord"],
						L["GitHub"],
						L["NGA.cn"]
					)
				)
			end
		end

		if not (checked or _G.ElvUIInstallFrame) then
			self:CheckCompatibility()
			checked = true
		end

		if _G.ElvDB then
			if isInitialLogin or not _G.ElvDB.WT then
				_G.ElvDB.WT = {
					DisabledAddOns = {},
				}
			end

			if next(_G.ElvDB.WT.DisabledAddOns) then
				E:Delay(4, self.PrintDebugEnviromentTip)
			end
		end

		self:GameFixing()

		E:Delay(1, collectgarbage, "collect")
	end
end

EP:HookInitialize(W, W.Initialize)
