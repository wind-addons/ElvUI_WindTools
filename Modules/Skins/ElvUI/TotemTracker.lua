local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, table
local S = W.Modules.Skins ---@type Skins

local _G = _G

local MAX_TOTEMS = MAX_TOTEMS

function S:ElvUI_TotemTracker_Initialize()
	for i = 1, MAX_TOTEMS do
		local frame = _G["ElvUI_TotemTrackerTotem" .. i]
		if frame and not frame.__windSkin then
			self:CreateShadow(frame)
			frame.__windSkin = true
		end
	end
end

function S:ElvUI_TotemTracker()
	if not (E.private.general.totemTracker and E.private.WT.skins.elvui.totemTracker) then
		return
	end

	local totemTracker = E:GetModule("TotemTracker")
	if totemTracker.Initialized then
		self:ElvUI_TotemTracker_Initialize()
	else
		self:SecureHook(totemTracker, "Initialize", "ElvUI_TotemTracker_Initialize")
	end
end

S:AddCallback("ElvUI_TotemTracker")
