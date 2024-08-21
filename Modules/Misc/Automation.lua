local W, F, E, L = unpack((select(2, ...)))
local AM = W:NewModule("Automation", "AceEvent-3.0")

local _G = _G
local securecall = securecall

local AcceptResurrect = AcceptResurrect
local HideUIPanel = HideUIPanel
local PlayerCanTeleport = PlayerCanTeleport
local StaticPopup_Hide = StaticPopup_Hide
local UnitAffectingCombat = UnitAffectingCombat
local UnitExists = UnitExists

local C_SummonInfo_ConfirmSummon = C_SummonInfo.ConfirmSummon

local confirmSummonAfterCombat = false

function AM:CANCEL_SUMMON()
	confirmSummonAfterCombat = false
end

function AM:CONFIRM_SUMMON()
	if not self.db or not self.db.confirmSummon then
		return
	end

	if confirmSummonAfterCombat then
		return
	end

	if UnitAffectingCombat("player") or not PlayerCanTeleport() then
		confirmSummonAfterCombat = true
		return
	end

	E:Delay(0.6, function()
		C_SummonInfo_ConfirmSummon()
		StaticPopup_Hide("CONFIRM_SUMMON")
	end)
end

function AM:PLAYER_REGEN_ENABLED()
	self.isInCombat = false

	if confirmSummonAfterCombat then
		confirmSummonAfterCombat = false
		if self.db and self.db.confirmSummon then
			C_SummonInfo_ConfirmSummon()
			StaticPopup_Hide("CONFIRM_SUMMON")
		end
	end
end

function AM:PLAYER_REGEN_DISABLED()
	self.isInCombat = true

	if self.db.hideWorldMapAfterEnteringCombat and _G.WorldMapFrame:IsShown() then
		HideUIPanel(_G.WorldMapFrame)
	end

	if self.db.hideBagAfterEnteringCombat then
		securecall("CloseAllBags")
	end
end

function AM:RESURRECT_REQUEST(_, inviterName)
	local inviterIsInCombat = UnitAffectingCombat(inviterName)
	local bossIsInCombat = UnitExists("boss1") and UnitAffectingCombat("boss1")

	if self.isInCombat or inviterIsInCombat or bossIsInCombat then
		if self.db.acceptCombatResurrect then
			AcceptResurrect()
		end
	else
		if self.db.acceptResurrect then
			AcceptResurrect()
		end
	end
end

function AM:Initialize()
	self.db = E.db.WT.misc.automation
	if not self.db or not self.db.enable or self.initialized then
		return
	end

	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("RESURRECT_REQUEST")
	self:RegisterEvent("CONFIRM_SUMMON")
	self:RegisterEvent("CANCEL_SUMMON")
end

function AM:ProfileUpdate()
	self.db = E.db.WT.misc.automation
	if self.db and not self.db.enable and self.initialized then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		self:UnregisterEvent("RESURRECT_REQUEST")
	end
end

W:RegisterModule(AM:GetName())
