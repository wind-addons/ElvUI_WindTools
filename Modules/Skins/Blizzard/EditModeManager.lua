local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G

function S:EditModeManager()
    if not self:CheckDB("editor", "editModeManager") then
        return
    end

    self:CreateBackdropShadow(_G.EditModeManagerFrame)
end

S:AddCallback("EditModeManager")
