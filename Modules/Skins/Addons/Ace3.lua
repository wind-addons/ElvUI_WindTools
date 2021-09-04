local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G

function S:Ace3_Frame(Constructor)
    if not (E.private.WT.skins.enable and E.private.WT.skins.addons.ace3 and E.private.WT.skins.shadow) then
        return Constructor
    end

    local function SkinedConstructor()
        local widget = Constructor()
        S:CreateShadow(widget.frame)
        return widget
    end

    return SkinedConstructor
end

function S:AceConfigDialog()
    local lib = _G.LibStub("AceConfigDialog-3.0")
    self:CreateShadow(lib.popup)
end

S:AddCallbackForAceGUIWidget("Frame", S.Ace3_Frame)