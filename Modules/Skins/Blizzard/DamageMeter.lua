local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local next = next

function S.DamageMeter_HandleSessionWindow(sessionWindow)
	if not sessionWindow or sessionWindow.__windSkin then
		return
	end

	S:CreateBackdropShadow(sessionWindow)

	sessionWindow.__windSkin = true
end

function S:DamageMeter_SetupSessionWindow()
	_G.DamageMeter:ForEachSessionWindow(S.DamageMeter_HandleSessionWindow)
end

function S:Blizzard_DamageMeter()
	if not self:CheckDB("damageMeter") then
		return
	end

	self:SecureHook(_G.DamageMeter, "SetupSessionWindow", "DamageMeter_SetupSessionWindow")
	S:DamageMeter_SetupSessionWindow()
end

S:AddCallbackForAddon("Blizzard_DamageMeter")
