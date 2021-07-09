local W, F, E, L = unpack(select(2, ...))
local S = W:GetModule("Skins")

local _G = _G
local hooksecurefunc = hooksecurefunc

local IsInJailersTower = IsInJailersTower

local function SetupOptions()
    if not _G.PlayerChoiceFrame.windStyle then
        S:CreateShadow(_G.PlayerChoiceFrame)
    end

    local inTower = IsInJailersTower()

    if inTower then
        _G.PlayerChoiceFrame.shadow:Hide()
    else
        _G.PlayerChoiceFrame.shadow:Show()
    end
end

function S:Blizzard_PlayerChoice()
    if not self:CheckDB("playerChoice") then
        return
    end

    hooksecurefunc(_G.PlayerChoiceFrame, "SetupOptions", SetupOptions)
end

S:AddCallbackForAddon("Blizzard_PlayerChoice")
