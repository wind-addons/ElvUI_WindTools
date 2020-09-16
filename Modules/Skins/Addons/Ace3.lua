local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

function S:Ace3_Frame(Constructor)
    if not E.private.WT.skins.enable or not E.private.WT.skins.addons.ace3 then
        return Constructor
    end

    local function SkinedConstructor()
        local widget = Constructor()
        S:CreateShadow(widget.frame)
        return widget
    end

    return SkinedConstructor
end

S:AddCallbackForAceGUIWidget("Frame", S.Ace3_Frame)
