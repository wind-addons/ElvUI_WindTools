local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local UIParentLoadAddOn = UIParentLoadAddOn

function S:DebugFrames()
    if not self:CheckDB("debug", "debugTools") then
        return
    end

    if not _G.FrameStackTooltip or not _G.TableAttributeDisplay then
        UIParentLoadAddOn("Blizzard_DebugTools")
    end

    self:CreateShadow(_G.TableAttributeDisplay)
    self:CreateShadow(_G.FrameStackTooltip)

    self:SecureHook(_G.TableInspectorMixin, "OnLoad", "CreateShadow")
end

S:AddCallback("DebugFrames")
