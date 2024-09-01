local W, F, E, L = unpack((select(2, ...)))
local S = W.Modules.Skins

local _G = _G

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

function S:Blizzard_DebugTools()
	if not self:CheckDB("debug", "debugTools") then
		return
	end

	self:CreateShadow(_G.TableAttributeDisplay)
	self:SecureHook(_G.TableInspectorMixin, "OnLoad", "CreateBackdropShadow")
end

if C_AddOns_IsAddOnLoaded("Blizzard_DebugTools") then
	S:AddCallback("Blizzard_DebugTools")
else
	S:AddCallbackForAddon("Blizzard_DebugTools")
end
