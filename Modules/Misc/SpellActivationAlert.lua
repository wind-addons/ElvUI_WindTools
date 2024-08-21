local W, F, E, L = unpack((select(2, ...)))

local SA = W:NewModule("SpellActivationAlert", "AceEvent-3.0")

local _G = _G
local pairs = pairs
local tonumber = tonumber

local SpellActivationOverlay_ShowOverlay = SpellActivationOverlay_ShowOverlay

local C_CVar_GetCVar = C_CVar.GetCVar

function SA:PLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:Update()
end

function SA:Update()
	if not E.db.WT.misc.spellActivationAlert then
		return
	end

	local scale = 1
	if E.db.WT.misc.spellActivationAlert.enable then
		scale = E.db.WT.misc.spellActivationAlert.scale or scale
	end

	local opacity = tonumber(C_CVar_GetCVar("spellActivationOverlayOpacity"))

	_G.SpellActivationOverlayFrame:SetAlpha(opacity)
	_G.SpellActivationOverlayFrame:SetScale(scale)
end

function SA:Preview()
	self.previewID = (self.previewID or 0) + 1
	local _previewID = self.previewID

	local examples = {
		["TOP"] = { false, true, 449488 },
		["BOTTOM"] = { true, false, 449487 },
		["RIGHT"] = { true, true, 450929 },
		["LEFT"] = { false, false, 449490 },
	}

	for position, data in pairs(examples) do
		SpellActivationOverlay_ShowOverlay(
			_G.SpellActivationOverlayFrame,
			123986,
			data[3],
			position,
			1,
			255,
			255,
			255,
			data[1],
			data[2]
		)
	end

	E:Delay(2, function()
		if _previewID == self.previewID then
			_G.SpellActivationOverlay_HideAllOverlays(_G.SpellActivationOverlayFrame)
		end
	end)
end

function SA:Initialize()
	if not E.db.WT.misc.spellActivationAlert.enable then
		return
	end

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function SA:ProfileUpdate()
	self:Update()
end

W:RegisterModule(SA:GetName())
