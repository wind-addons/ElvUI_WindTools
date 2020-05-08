local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local UIParentLoadAddOn = UIParentLoadAddOn

local _G = _G

function S:DebugFrames()
    if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.debug) then
        return
    end
    if not (E.private.WT.skins.blizzard.enable and E.private.WT.skins.blizzard.debugTools) then
        return
    end

    if not _G.FrameStackTooltip or not _G.TableAttributeDisplay then
        UIParentLoadAddOn("Blizzard_DebugTools")
    end

    S:CreateShadow(_G.TableAttributeDisplay)
    S:CreateShadow(_G.FrameStackTooltip)

    hooksecurefunc(
        _G.TableInspectorMixin,
        "OnLoad",
        function(s)
            if s then
                S:CreateShadow(s)
            end
        end
    )
end

S:AddCallback("DebugFrames")
