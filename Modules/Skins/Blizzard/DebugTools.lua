local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local UIParentLoadAddOn = UIParentLoadAddOn

function S:Blizzard_DebugTools()
    if not self:CheckDB("debug", "debugTools") then
        return
    end

    self:CreateBackdropShadowAfterElvUISkins(_G.TableAttributeDisplay)
    self:CreateBackdropShadowAfterElvUISkins(_G.EventTraceFrame)

    self:SecureHook(_G.TableInspectorMixin, "OnLoad", "CreateBackdropShadow")
end

if _G.IsAddOnLoaded('Blizzard_DebugTools') then
	S:AddCallback('Blizzard_DebugTools')
else
	S:AddCallbackForAddon('Blizzard_DebugTools')
end