local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G
local LibStub = _G.LibStub

function S:Hekili_CreateButton(Hekili, ...)
	local button = self.hooks[Hekili]["CreateButton"](Hekili, ...)
	self:CreateShadow(button)
	return button
end

function S:Hekili()
	if not E.private.WT.skins.enable or not E.private.WT.skins.addons.hekili then
		return
	end

	self:DisableAddOnSkin("Hekili")

	local Hekili = LibStub("AceAddon-3.0"):GetAddon("Hekili")
	self:RawHook(Hekili, "CreateButton", "Hekili_CreateButton")
end

S:AddCallbackForAddon("Hekili")
