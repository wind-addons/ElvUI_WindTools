local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local UIParentLoadAddOn = UIParentLoadAddOn

function S:Blizzard_CovenantPreviewUI()
    if not self:CheckDB("covenantPreview") then
        return
    end

    self:CreateBackdropShadow(_G.CovenantPreviewFrame)
end

S:AddCallbackForAddon("Blizzard_CovenantPreviewUI")
