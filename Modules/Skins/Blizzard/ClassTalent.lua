local W, F, E, L = unpack(select(2, ...))
local S = W.Modules.Skins

local _G = _G
local pairs = pairs

function S:Blizzard_ClassTalentUI()
    if not self:CheckDB("talent", "classTalent") then
        return
    end

    self:CreateShadow(_G.ClassTalentFrame)

    for _, tab in pairs({_G.ClassTalentFrame.TabSystem:GetChildren()}) do
        self:ReskinTab(tab)
    end
end

S:AddCallbackForAddon("Blizzard_ClassTalentUI")
