local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins
local AFK = E:GetModule("AFK")

local _G = _G

function S:ElvUI_AFK()
	if not (E.private.WT.skins.elvui.enable and E.private.WT.skins.elvui.afk) then
		return
	end

	self:CreateShadow(AFK.AFKMode.bottom, 10)

	AFK.AFKMode.bottom.guild:ClearAllPoints()
	AFK.AFKMode.bottom.guild:Point("TOPLEFT", AFK.AFKMode.bottom.name, "BOTTOMLEFT", 0, -11)

	AFK.AFKMode.bottom.time:ClearAllPoints()
	AFK.AFKMode.bottom.time:Point("TOPLEFT", AFK.AFKMode.bottom.guild, "BOTTOMLEFT", 0, -11)
end

S:AddCallback("ElvUI_AFK")
