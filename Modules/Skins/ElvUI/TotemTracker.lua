local W, F, E, L = unpack((select(2, ...))) ---@type WindTools, Functions, ElvUI, LocaleTable
local S = W.Modules.Skins ---@type Skins

local _G = _G

local MAX_TOTEMS = MAX_TOTEMS

local data = S:AddCallback("ElvUI_TotemTracker", function()
	return E.private.general.totemTracker and E.private.WT.skins.elvui.totemTracker and true or false
end)

function data:Initialize() -- self is the TotemTracker module when hooked, not data
	for i = 1, MAX_TOTEMS do
		local frame = _G["ElvUI_TotemTrackerTotem" .. i]
		if frame and not frame.__windSkin then
			S:CreateShadow(frame)
			frame.__windSkin = true
		end
	end
end

function S:ElvUI_TotemTracker()
	local totemTracker = E:GetModule("TotemTracker")
	if totemTracker.Initialized then
		data:Initialize()
	else
		self:SecureHook(totemTracker, "Initialize", data.Initialize)
	end
end
